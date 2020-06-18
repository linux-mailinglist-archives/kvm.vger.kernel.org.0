Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3251FEE35
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 10:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgFRI5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 04:57:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26667 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728957AbgFRI5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 04:57:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592470653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wqDesyDEKvVE0arFjXLzrboQB8n4OlGRbAZdAmnqecc=;
        b=IGQpmxwFGysMzJa7mSrntR4WU6ki38FxpCCqtpLP58lFxER7SF10sW0xPtw36MsgbL15Es
        ZZ/nsrgI+UPDQjXpSygocaurea7lUMHqFBYS0J/PcSFNLMf0jltTaAgMOdF32ze8/Ju6GF
        OyUWscMV1PkufoifnWwOYRfpzAJyv28=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-nDrm9QDzPK-zvyR-WUdb0Q-1; Thu, 18 Jun 2020 04:57:31 -0400
X-MC-Unique: nDrm9QDzPK-zvyR-WUdb0Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83ECE107ACCA;
        Thu, 18 Jun 2020 08:57:30 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.195.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E31285D9D3;
        Thu, 18 Jun 2020 08:57:28 +0000 (UTC)
Date:   Thu, 18 Jun 2020 10:57:26 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Haibo Xu <haibo.xu@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH] target/arm/kvm: Check supported feature per accelerator
 (not per vCPU)
Message-ID: <20200618085726.ti2hny6554l4l5kt@kamzik.brq.redhat.com>
References: <20200617130800.26355-1-philmd@redhat.com>
 <20200617152319.l77b4kdzwcftx7by@kamzik.brq.redhat.com>
 <69f9adc8-28ec-d949-60aa-ba760ea210a9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69f9adc8-28ec-d949-60aa-ba760ea210a9@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 17, 2020 at 07:37:42PM +0200, Paolo Bonzini wrote:
> On 17/06/20 17:23, Andrew Jones wrote:
> >>
> >> Fix by kvm_arm_<FEATURE>_supported() functions take a AccelState
> >> argument (already realized/valid at this point) instead of a
> >> CPUState argument.
> > I'd rather not do that. IMO, a CPU feature test should operate on CPU,
> > not an "accelerator".
> 
> If it's a test that the feature is enabled (e.g. via -cpu) then I agree.  
> For something that ends up as a KVM_CHECK_EXTENSION or KVM_ENABLE_CAP on 
> the KVM fd, however, I think passing an AccelState is better.

I can live with that justification as long as we don't support
heterogeneous VCPU configurations. And, if that ever happens, then I
guess we'll be reworking a lot more than just the interface of these
cpu feature probes.

Thanks,
drew


> kvm_arm_pmu_supported case is clearly the latter, even the error message
> hints at that:
> 
> +        if (kvm_enabled() && !kvm_arm_pmu_supported(current_accel())) {
>              error_setg(errp, "'pmu' feature not supported by KVM on this host");
>              return;
>          }
> 
> but the same is true of kvm_arm_aarch32_supported and kvm_arm_sve_supported.
> 
> Applying the change to kvm_arm_pmu_supported as you suggest below would be
> a bit of a bandaid because it would not have consistent prototypes.  Sp
> for Philippe's patch
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Thanks,
> 
> Paolo
> 
> > How that test is implemented is another story.
> > If the CPUState isn't interesting, but it points to something that is,
> > or there's another function that uses globals to get the job done, then
> > fine, but the callers of a CPU feature test shouldn't need to know that.
> > 
> > I think we should just revert d70c996df23f and then apply the same
> > change to kvm_arm_pmu_supported() that other similar functions got
> > with 4f7f589381d5.
> 
> 

