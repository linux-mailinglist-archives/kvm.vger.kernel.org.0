Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9C4A5A2B58
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 17:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbiHZPgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 11:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343978AbiHZPf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 11:35:57 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF59C32DBE
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 08:35:53 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id s31-20020a17090a2f2200b001faaf9d92easo8415486pjd.3
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 08:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=v4f55tB6LpMB6qzJlij3nDx/2y9fqNcIxEdXWIyFCqg=;
        b=oiKhCk3413IsNcAtel5Y+SNqkFDisFy0d6Wmt8ZxA7p7WQKZJIpQuwZabNCJAF774m
         MuQb7J6P9vrnDmg6xgin3pivFzbHQNEawpq+vjitSPmUTIVufOZPJfteItGbSAvuqQ3M
         mCzK2C1Vn8HYqehashp3BfsMBNGRwbDZqgN70F9mF1JJPuF46NWEAx/8TUqDFZpikQZe
         88DoKuH2ws22j0PI2HdLyKiOR9ik11wbSur0W3rR1zjOWcPQKrPrsEA1SN/IKFhIv8F4
         T32RYhI6xs+xPV96uh6FDAac4XKfFAxKvJcwyfo+mmrehOmKZrKExrS9Twd9QTI9aHKA
         7tzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=v4f55tB6LpMB6qzJlij3nDx/2y9fqNcIxEdXWIyFCqg=;
        b=jv45HxOn9kYRik2NU56Q8C6lRW8e7Q5EU8ZFNOIKOMK6GkpGDuhnzXtnqm55dGCtAY
         /k3Mv+k8VJGvwcAb7hKzvDxxtWT7kD6rvk+4CchFZXRS6Ex3hXijSH/r7JXOxXgRuc5f
         2lgDh+ev00ofggQrsmhLhtM+pH275EszAj67S6Ew13Cui0/KLU//24dMJvX+x4DwqVED
         oQXg2YGfzZeU5lIhmjqV0NChw4CcksthIgcwo7xECGFPoDfRtBE/nL7mG5m0vJmm2B7b
         BDmiiuB8zNPuQNRabOuFPbgd7x6FWVX+PUhltXe5GruUIhm5Q9byTy0FjB8agjX70Ogp
         BUog==
X-Gm-Message-State: ACgBeo1uWfCDAVOEvTBVUpr1Nz6nUL400xqmFizJCuWpndCepQiZx84h
        goTwiplvAzCnM6sm3KPpgUpP/g==
X-Google-Smtp-Source: AA6agR7IHY3uESv8bxhhnN8uS2VNtnBQ04kLtlD7XvOpLWcCXuXK8b7JCwh2UmXFuV3zYfh5BInO/w==
X-Received: by 2002:a17:902:b190:b0:172:e555:72e3 with SMTP id s16-20020a170902b19000b00172e55572e3mr4167496plr.74.1661528153147;
        Fri, 26 Aug 2022 08:35:53 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k2-20020aa79982000000b00535e49245d6sm1945044pfh.12.2022.08.26.08.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 08:35:52 -0700 (PDT)
Date:   Fri, 26 Aug 2022 15:35:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: move dest calculation out of loop
Message-ID: <YwjoVPTzaZsfT6f/@google.com>
References: <1661492603-52093-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1661492603-52093-1-git-send-email-lirongqing@baidu.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 26, 2022, Li RongQing wrote:
> There is no need to calculate dest in each vcpu iteration
> since dest is not change
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  arch/x86/kvm/svm/avic.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 6919dee..087c073 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -451,6 +451,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>  static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
>  				   u32 icrl, u32 icrh, u32 index)
>  {
> +	u32 dest;
>  	unsigned long i;
>  	struct kvm_vcpu *vcpu;
>  
> @@ -465,13 +466,13 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
>  	 * vCPUs that were in guest at the time of the IPI, and vCPUs that have
>  	 * since entered the guest will have processed pending IRQs at VMRUN.
>  	 */
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		u32 dest;
>  
> -		if (apic_x2apic_mode(vcpu->arch.apic))
> -			dest = icrh;
> -		else
> -			dest = GET_XAPIC_DEST_FIELD(icrh);
> +	if (apic_x2apic_mode(vcpu->arch.apic))

Please try to actually test patches before posting.  "vcpu" is quite clearly accessed
uninitialized.  gcc isn't smart enough to warn, but clang is.  I realize that testing
AVIC is more difficult than it should be, but it's not prohitively difficult.

arch/x86/kvm/svm/avic.c:470:23: error: variable 'vcpu' is uninitialized when used here [-Werror,-Wuninitialized]
        if (apic_x2apic_mode(vcpu->arch.apic))
                             ^~~~
arch/x86/kvm/svm/avic.c:456:23: note: initialize the variable 'vcpu' to silence this warning
        struct kvm_vcpu *vcpu;
                             ^
                              = NULL


That said, there is actually a functional bug here.  "dest" needs to be computed
using the source x2APIC status.

I'll send a small series, there are more cleanups than can be done by moving the
dissection of ichr/ichl into avic_kick_target_vcpus() instead of duplicating the
code in avic_kick_target_vcpus_fast().

--
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Aug 2022 08:30:57 -0700
Subject: [PATCH] KVM: SVM: Compute dest based on sender's x2APIC status for
 AVIC kick

Compute the destination from ICRH using the sender's x2APIC status, not
each (potential) target's x2APIC status.

Fixes: c514d3a348ac ("KVM: SVM: Update avic_kick_target_vcpus to support 32-bit APIC ID")
Cc: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 6919dee69f18..623431289d88 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -451,6 +451,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 				   u32 icrl, u32 icrh, u32 index)
 {
+	u32 dest = apic_x2apic_mode(source) ? icrh : GET_XAPIC_DEST_FIELD(icrh);
 	unsigned long i;
 	struct kvm_vcpu *vcpu;

@@ -466,13 +467,6 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 	 * since entered the guest will have processed pending IRQs at VMRUN.
 	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		u32 dest;
-
-		if (apic_x2apic_mode(vcpu->arch.apic))
-			dest = icrh;
-		else
-			dest = GET_XAPIC_DEST_FIELD(icrh);
-
 		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
 					dest, icrl & APIC_DEST_MASK)) {
 			vcpu->arch.apic->irr_pending = true;

base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
--

