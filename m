Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA5B6F5BEE
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 18:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjECQZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 12:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjECQZq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 12:25:46 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3D859C8
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 09:25:45 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1aaf4334a67so21498725ad.1
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 09:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683131145; x=1685723145;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qt0gpyvj0PrNkFHTcXEACbFbewOA092WhoxjkY5DTCA=;
        b=gAL+Ef/vVrsorERQ+Apoo+wsZOEtzfDG5jUutqzfy6vM49t2H/0QbSoiUdd/ws67ob
         ms8LiARVLI28bdNuS/QOYNb3Yd2RFZbp2RSgci/YGkux288Zz0diDW8loiDH3fnzrCfU
         Sms+SYsnooZDmsbWdoh6dLtc7+G1WfnBWCAV1+bLD65KpdajEqJ0QulqQaOlhbAThoOZ
         bF70GD6FDA9HEJ8xp4IwdA8L256Vbn6eeITdLVJZBG5IWQ+wrNfvU3A3MYtO9T6YEe+7
         SyGNo8RpS3EG9N040iKbCNJQgqlvn/wwOHkqX+M8FG7QLAenX7A46MbR1B8nYFgevE+S
         f3Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683131145; x=1685723145;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qt0gpyvj0PrNkFHTcXEACbFbewOA092WhoxjkY5DTCA=;
        b=d8RKzq5xYFyCoTcgVxejAypVoO/JIJEUk2/gocwTMWO2ecC45lSiLXmzprd68raxqt
         zdpx5ju5CweF95lJfbzBUrA0SQ47Jbl0CzAaH9lmf6OU8XN9CTtI1vyFT1XeyGh08ajm
         9vcJvYONiF3oOgB7GG9WZsAPTm0XdwAUVTAv+hvMipJK2tvtI+ej3LkkBNGnvBIlv/aJ
         Mx4a3hPScnzgvxZht8YBhOLqw6LDTwUszYuZlVnwg5sfUJSHdVjEI5ShtM4i/2+7w8vz
         zqKUWbleTzSBu8TsWTBUtOfdBXf/wAnK/EREQAZyPi0vQ/B4W/KgKXBb3g3qvXu0J9g4
         IK/g==
X-Gm-Message-State: AC+VfDw9MKkavDoMv45bgToAsc6a3mKxSZ0tkv7jtd13KUOpozSW373k
        zd/KVj7HKikJWbuWXrEkLr9IwndBsac=
X-Google-Smtp-Source: ACHHUZ6ZwjU+1o1SnBJUJp39KbT/aM8FW8HD4jpS8aSanZE8qJUrN1/uwrsma6otsqv/UGxIxjzBEPSEYtc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2352:b0:1a6:6be8:fc9 with SMTP id
 c18-20020a170903235200b001a66be80fc9mr219134plh.0.1683131145294; Wed, 03 May
 2023 09:25:45 -0700 (PDT)
Date:   Wed, 3 May 2023 09:25:43 -0700
In-Reply-To: <20230503041631.3368796-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230503041631.3368796-1-mizhang@google.com>
Message-ID: <ZFKLB1C+v6HKcy0o@google.com>
Subject: Re: [PATCH] KVM: VMX: add MSR_IA32_TSX_CTRL into msrs_to_save
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
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

On Wed, May 03, 2023, Mingwei Zhang wrote:
> Add MSR_IA32_TSX_CTRL into msrs_to_save[] to explicitly tell userspace to
> save/restore the register value during migration. Missing this may cause
> userspace that relies on KVM ioctl(KVM_GET_MSR_INDEX_LIST) fail to port the
> value to the target VM.
> 
> Fixes: b07a5c53d42a ("KVM: vmx: use MSR_IA32_TSX_CTRL to hard-disable TSX on guest that lack it")
> Reported-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 237c483b1230..2236cfee4b7a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1431,7 +1431,7 @@ static const u32 msrs_to_save_base[] = {
>  #endif
>  	MSR_IA32_TSC, MSR_IA32_CR_PAT, MSR_VM_HSAVE_PA,
>  	MSR_IA32_FEAT_CTL, MSR_IA32_BNDCFGS, MSR_TSC_AUX,
> -	MSR_IA32_SPEC_CTRL,
> +	MSR_IA32_SPEC_CTRL, MSR_IA32_TSX_CTRL,
>  	MSR_IA32_RTIT_CTL, MSR_IA32_RTIT_STATUS, MSR_IA32_RTIT_CR3_MATCH,
>  	MSR_IA32_RTIT_OUTPUT_BASE, MSR_IA32_RTIT_OUTPUT_MASK,
>  	MSR_IA32_RTIT_ADDR0_A, MSR_IA32_RTIT_ADDR0_B,
> -- 

Hmm, KVM shouldn't report the MSR if it can't be written by the guest.  Over-
reporting won't cause functional issues, and the odds of the MSR existing but not
being reported in ARCH_CAPILIBITES are basically zilch, but IMO it's worth adding
the check if only to document when the MSRs is fully supported.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e7f78fe79b32..d8608c6753ff 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7152,6 +7152,10 @@ static void kvm_probe_msr_to_save(u32 msr_index)
                if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
                        return;
                break;
+       case MSR_IA32_TSX_CTRL:
+               if (!(kvm_get_arch_capabilities() & ARCH_CAP_TSX_CTRL_MSR))
+                       return;
+               break;
        default:
                break;
        }
