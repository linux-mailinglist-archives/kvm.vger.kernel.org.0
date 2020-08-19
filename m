Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4CA249EAF
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 14:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbgHSMu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 08:50:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32202 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728434AbgHSMut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 08:50:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597841448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aNBcx8w5XcYHoCczqsi+mPWxfzakAJQKH//rEDM3Lhc=;
        b=FQVS7KCT3xqgAaX/dD41D3PoZnEWTk7OynEyLZ3qdZFdmYNmQXEQK+VkA3uHgbZ4c6IOO/
        nT/pz3DXLq4UKVMYcbb35XKc8MljCn+dfrZZdNv6N32Fes/MtoYiqka93f8feQxXkvh83h
        Y+HMHxKfzIRI3ZF94LnKnnKcNbfcaYY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-UIJLDnhOOpG-5dsXR4xkIw-1; Wed, 19 Aug 2020 08:50:31 -0400
X-MC-Unique: UIJLDnhOOpG-5dsXR4xkIw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90209425DE;
        Wed, 19 Aug 2020 12:50:30 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AAD169C9D;
        Wed, 19 Aug 2020 12:50:29 +0000 (UTC)
Date:   Wed, 19 Aug 2020 14:50:26 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, pbonzini@redhat.com, steven.price@arm.com
Subject: Re: [PATCH v2 0/6] KVM: arm64: pvtime: Fixes and a new cap
Message-ID: <20200819125026.fsbzvim74qp7sene@kamzik.brq.redhat.com>
References: <20200804170604.42662-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804170604.42662-1-drjones@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 04, 2020 at 07:05:58PM +0200, Andrew Jones wrote:
> v2:
>   - ARM_SMCCC_HV_PV_TIME_FEATURES now also returns SMCCC_RET_NOT_SUPPORTED
>     when steal time is not supported
>   - Added READ_ONCE() for the run_delay read
>   - Reworked kvm_put/get_guest to not require type as a parameter
>   - Added some more text to the documentation for KVM_CAP_STEAL_TIME
>   - Enough changed that I didn't pick up Steven's r-b's
> 
> 
> The first four patches in the series are fixes that come from testing
> and reviewing pvtime code while writing the QEMU support[*]. The last
> patch is only a convenience for userspace, and I wouldn't be heartbroken
> if it wasn't deemed worth it. The QEMU patches are currently written
> without the cap. However, if the cap is accepted, then I'll change the
> QEMU code to use it.
> 
> Thanks,
> drew
> 
> [*] https://lists.gnu.org/archive/html/qemu-devel/2020-07/msg03856.html
>     (a v2 of this series will also be posted shortly)
> 
> Andrew Jones (6):
>   KVM: arm64: pvtime: steal-time is only supported when configured
>   KVM: arm64: pvtime: Fix potential loss of stolen time
>   KVM: arm64: Drop type input from kvm_put_guest
>   KVM: arm64: pvtime: Fix stolen time accounting across migration
>   KVM: Documentation: Minor fixups
>   arm64/x86: KVM: Introduce steal-time cap
> 
>  Documentation/virt/kvm/api.rst    | 22 ++++++++++++++++++----
>  arch/arm64/include/asm/kvm_host.h |  2 +-
>  arch/arm64/kvm/arm.c              |  3 +++
>  arch/arm64/kvm/pvtime.c           | 29 +++++++++++++----------------
>  arch/x86/kvm/x86.c                |  3 +++
>  include/linux/kvm_host.h          | 31 ++++++++++++++++++++++++++-----
>  include/uapi/linux/kvm.h          |  1 +
>  7 files changed, 65 insertions(+), 26 deletions(-)
> 
> -- 
> 2.25.4
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>

Hi Marc,

Gentle ping. I'd like to to switch the QEMU code to using the proposed
KVM cap, if the cap is accepted.

Thanks,
drew 

