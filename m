Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001E735758A
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 22:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345454AbhDGUJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 16:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbhDGUI7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 16:08:59 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E304C06175F
        for <kvm@vger.kernel.org>; Wed,  7 Apr 2021 13:08:48 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id b17so10231823pgh.7
        for <kvm@vger.kernel.org>; Wed, 07 Apr 2021 13:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xtWZ787MlQUKg7hTVZQgduf2IbH/MKv8i1FMG/FmukA=;
        b=nRDuuvK2QA1vyj5nKYztc+o90COIxHA0LRuaVf7jhCaPWPWFP9AmCwZevhPJ1rz/Tu
         zuGn2HQM66SIpnq1XPELoBB7iulqG3lzHzHL6Ge2VZvHTOazhKiqSYjm1O0EQw6X0L9z
         yfxLfv7eChkGaBsKnuF0j6wMwrgiFYsy1BBa4ue2UgvQgM3/4xkKUuWP1E9MGSDaFzLA
         s6ykEhkHb2B0VXsmFMRr4eD/D3X9Q/JiyeOJVqRNsYyVNM8gxg34MUmHyMXb8Gk4LniA
         mKZuXTGs5Kn9J8kl1vuIeJw/SDcTwhu+v7pjtT3sJYQ4J6790ZTokOb3YNqbMRn2jBIk
         uQXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xtWZ787MlQUKg7hTVZQgduf2IbH/MKv8i1FMG/FmukA=;
        b=tAgU62g7RheJfayxoAgUhwjKDSPPXZGppUfQW7Z+29zMbsNiOjijdnm7tMp1Fou8vF
         bvUZqr8sGKXH8me1InZFnGPrKEHkVUaL8VQLpmIXee8aSl39B16k+KH6l3PFXeIQpoUq
         Uyoe2k/ZDQvvD/vIHWtGGkVXJEQIWLEWgM+wjQsLipVR5hm6TJF6frs9zmM2RnGqPgjT
         OSEJeK7owJtuK8E3pYayxs/DnNuJ65xxxevfrm2QJfErb/ENuJV6BfPzmtHC6xehdLKD
         5yn4srEvc9NdRwAwgh53katapQR9VlckzmQ4NN7iD+KvsQHox7JtcC5Rzqa5XM3yuHnq
         PKOw==
X-Gm-Message-State: AOAM531y/7xh+fbydTKUe9jZoDSdMIPOq5G02Twav+y8hDLo4ugqbXkV
        cFGOelRpfMaxGOa2CfGHuR6BWw==
X-Google-Smtp-Source: ABdhPJwzxgxZWHir+VWtQJP7Vc2wxRavfml6YgqrNIQWgfmqwAsYI0FbVgPBeP2bUadn7+cimqxGxQ==
X-Received: by 2002:aa7:9e43:0:b029:1f3:a2b3:d9fd with SMTP id z3-20020aa79e430000b02901f3a2b3d9fdmr4445146pfq.74.1617826127566;
        Wed, 07 Apr 2021 13:08:47 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id b126sm22346155pga.91.2021.04.07.13.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 13:08:46 -0700 (PDT)
Date:   Wed, 7 Apr 2021 20:08:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH] KVM: SVM: Make sure GHCB is mapped before updating
Message-ID: <YG4RSl88TSPccRfj@google.com>
References: <03b349cb19b360d4c2bbeebdd171f99298082d28.1617820214.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03b349cb19b360d4c2bbeebdd171f99298082d28.1617820214.git.thomas.lendacky@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 07, 2021, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> The sev_vcpu_deliver_sipi_vector() routine will update the GHCB to inform
> the caller of the AP Reset Hold NAE event that a SIPI has been delivered.
> However, if a SIPI is performed without a corresponding AP Reset Hold,
> then the GHCB may not be mapped, which will result in a NULL pointer
> dereference.
> 
> Check that the GHCB is mapped before attempting the update.

It's tempting to say the ghcb_set_*() helpers should guard against this, but
that would add a lot of pollution and the vast majority of uses are very clearly
in the vmgexit path.  svm_complete_emulated_msr() is the only other case that
is non-obvious; would it make sense to sanity check svm->ghcb there as well?

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 019ac836dcd0..abe9c765628f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2728,7 +2728,8 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
 {
        struct vcpu_svm *svm = to_svm(vcpu);
-       if (!sev_es_guest(vcpu->kvm) || !err)
+
+       if (!err || !sev_es_guest(vcpu->kvm) || !WARN_ON_ONCE(svm->ghcb))
                return kvm_complete_insn_gp(vcpu, err);

        ghcb_set_sw_exit_info_1(svm->ghcb, 1);

> Fixes: 647daca25d24 ("KVM: SVM: Add support for booting APs in an SEV-ES guest")
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Either way:

Reviewed-by: Sean Christopherson <seanjc@google.com> 

> ---
>  arch/x86/kvm/svm/sev.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 83e00e524513..13758e3b106d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2105,5 +2105,6 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>  	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
>  	 * non-zero value.
>  	 */
> -	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
> +	if (svm->ghcb)
> +		ghcb_set_sw_exit_info_2(svm->ghcb, 1);
>  }
> -- 
> 2.31.0
> 
