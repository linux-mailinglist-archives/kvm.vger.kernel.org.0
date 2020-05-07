Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9CA1C9640
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 18:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgEGQTH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 12:19:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20180 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726616AbgEGQTG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 12:19:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588868344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WPWPHe3pgTIBihcXGk8hJCaqBjbGv2lpjNArereGrgk=;
        b=A3/HxWGXu7qcUCw0R3G68UEvkWFyP8Gk33ndonkL/4mUK5v8zHyGRQXR+8y9uEAMpVmoii
        lIAaUf18nF2f0gwsXyVvpEwDEjH0vlWEJ/zHRj/y15d/gp718PnYjNjkgk4rkQ24FsHbKe
        7qG/s9kZ+jDijcdPRL/MwpW0okQs9wE=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-A9MWGFUlOSyyw-296KWmSQ-1; Thu, 07 May 2020 12:18:57 -0400
X-MC-Unique: A9MWGFUlOSyyw-296KWmSQ-1
Received: by mail-qt1-f200.google.com with SMTP id g14so7729556qts.7
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 09:18:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WPWPHe3pgTIBihcXGk8hJCaqBjbGv2lpjNArereGrgk=;
        b=eKlhXod7KkRGGp7TWi3TbwKC5qtrglCIpdj3xuxTQh0imjflmIa98RZb8MsuMukFIL
         Ly+dn/LD2WedrLAmeC2AJPk1WLqJ8yepTw8/0KSRnTy2GWr3HBftuNFZVF+Z65U0fWxj
         BygG7fmo7ttBo1/KjheFJ8qpiXoHUyvdsgyWhoqg1tOpBLEWQO6mLrIqwmYcupAUIl5Y
         Tqk81ZvEVVHQECS73OG3M0hlXBByRN5okA4vnmZHXCpOhMlqK4uxt2Jmlj2lNn5qFV+Q
         QohdVz/+t0pzXEtDhVSxED9r1PsynMQP/zY4jejalzQ2749Aez0eHLBP5E2LB5fsUiKd
         D8cA==
X-Gm-Message-State: AGi0PuYSHZeA3YNEOoZGrV/WaJZhas95jJaJP1+5orhjeTriH3NDpVoH
        uzJdOA5a+Pz2skKvWPmHpZsr7yXp/l1pN6Fm9alHM733r0pGw+nCn7bWNjij32xCYzFRYFDGHj2
        vmUOs6e1PLvnq
X-Received: by 2002:ac8:5057:: with SMTP id h23mr14783768qtm.287.1588868336833;
        Thu, 07 May 2020 09:18:56 -0700 (PDT)
X-Google-Smtp-Source: APiQypKMXRz+2RdT4/NUmlbtskmTYfoso9urd97IW1y5qNWjs9Os8BEJwCtLJ++jqbfn/vjqoo8YLg==
X-Received: by 2002:ac8:5057:: with SMTP id h23mr14783733qtm.287.1588868336490;
        Thu, 07 May 2020 09:18:56 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id i43sm2874675qte.37.2020.05.07.09.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 09:18:55 -0700 (PDT)
Date:   Thu, 7 May 2020 12:18:54 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 9/9] KVM: VMX: pass correct DR6 for GD userspace exit
Message-ID: <20200507161854.GF228260@xz-x1>
References: <20200507115011.494562-1-pbonzini@redhat.com>
 <20200507115011.494562-10-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200507115011.494562-10-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 07, 2020 at 07:50:11AM -0400, Paolo Bonzini wrote:
> When KVM_EXIT_DEBUG is raised for the disabled-breakpoints case (DR7.GD),
> DR6 was incorrectly copied from the value in the VM.  Instead,
> DR6.BD should be set in order to catch this case.
> 
> On AMD this does not need any special code because the processor triggers
> a #DB exception that is intercepted.  However, the testcase would fail
> without the previous patch because both DR6.BS and DR6.BD would be set.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c                        |  2 +-
>  .../testing/selftests/kvm/x86_64/debug_regs.c | 24 ++++++++++++++++++-
>  2 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e2b71b0cdfce..e45cf89c5821 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4927,7 +4927,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
>  		 * guest debugging itself.
>  		 */
>  		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
> -			vcpu->run->debug.arch.dr6 = vcpu->arch.dr6;
> +			vcpu->run->debug.arch.dr6 = DR6_BD | DR6_RTM | DR6_FIXED_1;

After a second thought I'm thinking whether it would be okay to have BS set in
that test case.  I just remembered there's a test case in the kvm-unit-test
that checks explicitly against BS leftover as long as dr6 is not cleared
explicitly by the guest code, while the spec seems to have no explicit
description on this case.

Intead of above, I'm thinking whether we should allow the userspace to also
change dr6 with the KVM_SET_GUEST_DEBUG ioctl when they wanted to (right now
iiuc dr6 from userspace is completely ignored), instead of offering a fake dr6.
Or to make it simple, maybe we can just check BD bit only?

Thanks,

>  			vcpu->run->debug.arch.dr7 = dr7;
>  			vcpu->run->debug.arch.pc = kvm_get_linear_rip(vcpu);
>  			vcpu->run->debug.arch.exception = DB_VECTOR;

-- 
Peter Xu

