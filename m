Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391B374B5A2
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 19:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjGGRQ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 13:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbjGGRQ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 13:16:27 -0400
Received: from out-51.mta0.migadu.com (out-51.mta0.migadu.com [91.218.175.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBB2196
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 10:16:17 -0700 (PDT)
Date:   Fri, 7 Jul 2023 17:16:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688750175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MgD/1IVW5Bgo6C3rsqk1ZusNkWbZT0MYcmbLOXvyZ0A=;
        b=CdaxDCJR240gLrTWtVoeHO2R6gLfUd9xPnAwu59N9o4AZk20jbnzIKDFRc2sGZYCcWGUcF
        z80ksCHzKWmG+AZk20trbkVD4KN3KMmwTfjfIJNxQLMmTz0SFpvU8j6KtyTJzSiehVnYVH
        0tPfWPKFYiu1W+mxvAatu7Lj6r7GmiQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     maz@kernel.org, james.morse@arm.com, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH] KVM: arm64: Keep need_db always true in vgic_v4_put()
 when emulating WFI
Message-ID: <ZKhIXFlPykpvI8MG@linux.dev>
References: <1688720145-37923-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1688720145-37923-1-git-send-email-chenxiang66@hisilicon.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Xiang,

Thanks for reporting this.

On Fri, Jul 07, 2023 at 04:55:45PM +0800, chenxiang wrote:
> When enabled GICv4.1 on Kunpeng 920 platform with 6.4 kernel (preemptible
> kernel), running a vm with 128 vcpus on 64 pcpu, sometimes vm is not booted
> successfully, and we find there is a situation that doorbell interrupt will
> not occur event if there is a pending interrupt.

Oh, that's no good.

> ---
>  arch/arm64/kvm/vgic/vgic-v4.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
> index c1c28fe..37152cf8 100644
> --- a/arch/arm64/kvm/vgic/vgic-v4.c
> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
> @@ -343,6 +343,9 @@ int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db)
>  	if (!vgic_supports_direct_msis(vcpu->kvm) || !vpe->resident)
>  		return 0;
>  
> +	if (vcpu->stat.generic.blocking == 1)
> +		need_db = true;
> +

As I understand it, the issue really comes from the fact that @need_db
is always false when called from vgic_v3_put(). I'd rather we not
override the argument, as that could have unintended consequences in the
future.

You could also use the helper we already have for determining if a vCPU
is blocking, which we could use as a hint for requesting a doorbell
interrupt on sched out.

Putting the two comments together, I arrived at the following (untested)
diff. I don't have a GICv4 system on hand, sadly. Mind taking it for a
spin?

--
Thanks,
Oliver

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 93a47a515c13..8c743643b122 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -756,7 +756,7 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
-	WARN_ON(vgic_v4_put(vcpu, false));
+	WARN_ON(vgic_v4_put(vcpu, kvm_vcpu_is_blocking(vcpu)));
 
 	vgic_v3_vmcr_sync(vcpu);
 
