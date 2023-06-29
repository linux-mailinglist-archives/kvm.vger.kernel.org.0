Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0782742B17
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 19:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbjF2RTn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 13:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbjF2RTm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 13:19:42 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DEA53595
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 10:19:40 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-262e04a6f5aso554515a91.2
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 10:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688059180; x=1690651180;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vsug4q/7DHQPgeIlomXxa8wBczhcEdo4oTk+wDRMkzw=;
        b=5zbQ7t8Q36AniZGdwegMe7PO/pTQbPeeDK86t+ZeIdDrPDcUWUcUt/YNpBEMJR+5TK
         jnZ2C/e8CSnB2VDhLM2szRhInlOrnmLBJDiI6JdtlYPmKby1l5HQfEoHU3fogfIQGYwH
         ymGEHxHXSCUjT2cNzU5Ofp8A0oszFb6JXu5PVdmQwDDi6bqpHcj++MSw9wvVA31+u6sX
         LIArrHRzjRkwFYMFkZtYxYt6YOrCSg2myVakDf8anqVViD5ZY3MfUz/aoT2Ry+7h9YOO
         ojs9H+v31xaK2MzbN7oH015zTgEyjEPalWuBFhxrfmgyEaTznrRzrnJr9akCqJflI1FT
         /9iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688059180; x=1690651180;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vsug4q/7DHQPgeIlomXxa8wBczhcEdo4oTk+wDRMkzw=;
        b=KwvLHzHJQldkEsIvRkYH1ugiIuAI3X3KA8kowH1DFW0+giNL4aG5/2hLCvRU6etUaY
         VgerexmyD3NTnKC8gaeMkpPieYL+v9vBc7IgRS0auM6XcIp2MgVY0MbptrRS4yTaJnXh
         lIwIxSaQmdG+tHcnvDAIoA1a8398VPSO9YcF5v1DjfJrd/QS5cBLPPLOY0WIS9j+AcQ/
         m+Jc2aA+lmddC/kVdwy52crjr7m+ncwo1O133szZ5AN3ZQHsjGmQZkW272zJmy7dPNay
         /XjKYtifSBYv2FxsyPMe+84GFFWxKmI7Xf1vWrV6CSLl3eybibjg2NNQbu8aFILe/LKZ
         sHyA==
X-Gm-Message-State: ABy/qLYM6sYwJbhDr3TxBbbiuIWrDN86j3W1SihUhUFzSqHP0KjKjcDO
        AsZn2m8I275lME4s9qsfP/0nfV7L5sM=
X-Google-Smtp-Source: APBJJlFAFtBaWHSL0VcaxYGZM19od2Cyi2EMpoBxY/F2lmrPfJPwMn0AiVjPvO8UM7tQqGi4WFoGHjsjd7E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c7cb:b0:262:dc60:20b3 with SMTP id
 gf11-20020a17090ac7cb00b00262dc6020b3mr14686pjb.8.1688059179997; Thu, 29 Jun
 2023 10:19:39 -0700 (PDT)
Date:   Thu, 29 Jun 2023 10:19:38 -0700
In-Reply-To: <20230629164838.66847-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20230629164838.66847-1-likexu@tencent.com>
Message-ID: <ZJ29KhiVLyAq/7Sh@google.com>
Subject: Re: [PATCH] KVM: x86/tsc: Update guest tsc_offset again before vcpu
 first runs
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Oliver

On Fri, Jun 30, 2023, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> When a new vcpu is created and subsequently restored by vcpu snapshot,
> apply kvm_vcpu_write_tsc_offset() before vcpu runs for the first time.
> 
> Before a vcpu runs for the first time, the user space (VMM) sets the guest
> tsc as it wants, which may triggers the time synchronization mechanism with
> other vcpus (if any). In a scenario where a vcpu snapshot is used to
> restore, like the bugzilla report [*], the newly target guest tsc (e.g.
> at the time of vcpu restoration) is synchronized with its the most
> primitive guest timestamp initialized at the time of vcpu creation.
> 
> Furthermore, the VMM can actually update the target guest tsc multiple
> times before the vcpu actually gets running, which requires the tsc_offset
> to be updated every time it is set. In this scenario, it can be considered
> as unstable tsc (even this vcpu has not yet even started ticking to follow
> the intended logic of KVM timer emulation).
> 
> It is only necessary to delay this step until kvm_arch_vcpu_load() to
> catch up with guest expectation with the help of kvm_vcpu_has_run(),
> and the change is expected to not break any of the cumbersome existing
> virt timer features.

"expected to not break" and "does not break" are two different statements.

> Reported-by: Yong He <alexyonghe@tencent.com>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217423 [*] 
> Tested-by: Jinrong Liang <cloudliang@tencent.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 439312e04384..616940fc3791 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4818,7 +4818,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  		if (tsc_delta < 0)
>  			mark_tsc_unstable("KVM discovered backwards TSC");
>  
> -		if (kvm_check_tsc_unstable()) {
> +		if (kvm_check_tsc_unstable() || !kvm_vcpu_has_run(vcpu)) {
>  			u64 offset = kvm_compute_l1_tsc_offset(vcpu,
>  						vcpu->arch.last_guest_tsc);
>  			kvm_vcpu_write_tsc_offset(vcpu, offset);

Doing this on every vCPU load feels all kinds of wrong, e.g. it will override the
value set by userspace via KVM_VCPU_TSC_OFFSET.  One could argue the KVM is "helping"
userspace by providing a more up-to-date offset for the guest, but "helping"
userspace by silently overriding userspace rarely ends well.

Can't we instead just fix the heuristic that tries to detect synchronization?

---
 arch/x86/kvm/x86.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c30364152fe6..43d40f058a41 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2721,14 +2721,14 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 			 * kvm_clock stable after CPU hotplug
 			 */
 			synchronizing = true;
-		} else {
+		} else if (kvm_vcpu_has_run(vcpu)) {
 			u64 tsc_exp = kvm->arch.last_tsc_write +
 						nsec_to_cycles(vcpu, elapsed);
 			u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
 			/*
 			 * Special case: TSC write with a small delta (1 second)
-			 * of virtual cycle time against real time is
-			 * interpreted as an attempt to synchronize the CPU.
+			 * of virtual cycle time against real time on a running
+			 * vCPU is interpreted as an attempt to synchronize.
 			 */
 			synchronizing = data < tsc_exp + tsc_hz &&
 					data + tsc_hz > tsc_exp;

base-commit: 2d6f036579d4ef5a09b0b45f66e34406290dfa1e
--
