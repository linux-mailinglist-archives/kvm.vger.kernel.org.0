Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972DA5F80D9
	for <lists+kvm@lfdr.de>; Sat,  8 Oct 2022 00:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiJGWlc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 18:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiJGWla (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 18:41:30 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66184792E8
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 15:41:26 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id 204so6066529pfx.10
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 15:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XZo46KulR3GJqtVuZHIWbUUZizarbLhyKl4TV2qKphU=;
        b=dBBdyRYuo32YUPpc1kGUEYYAzpkYTTnrRhBl72Uadl3ko8LhHSWsmYs9i/H+A5IIRy
         HwzMZ71od0PXvo5KcAGPDGqTfiupn7S3CO/Gor9rE83zMRkPMTlbzLmnsKUjHgIZg8LN
         2juqE0SCgI095Dw2wskPWPXZmF+GYPIiO73ixWc6ilrstT0Jb5+zbXR8opgyw5Ng2y+U
         9i2SqN7uxjBBGUXGP9k3SRcIU3VBwMGHEUv7kYTLMKmxW8h8tTuwOOeZy0g6eaGrDLn0
         RQg4QKwsTQpr/NJfGxU+dHtPK1Tt5vY4flFa/Y0WFMowYAI42st5gno21ZVaJ7uqSmrF
         rQCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XZo46KulR3GJqtVuZHIWbUUZizarbLhyKl4TV2qKphU=;
        b=lqj5YmQLcxm4pS7V9J/U+p8PcO/zd0UR5l1vyN0OU4znQKaFptC5/dkZpvNZFBUXY+
         k4DYWSjRG/rFgGmydMyhTXmuw0JWUJXuXdUjHsDAH6/a4MAMEBGo0P67oH08n7QASXqj
         ke8eLuBJibFP2Nna31QiL/DEP+BoDQ3IrQC/uRUeQ0xlcnkJae9LOFTs5FLharjJ0wEq
         eK5v6a2G2ekP+upVyaXfgBJpAJtxhZPY9SVNqWT1WBORfdnLf09vB7eHQAlDaI5ciyox
         RTUB0wPmOwws+8u48iXKJnK3Dk/oZslusXP7erklplYI9YOwU2Jo0GvuqNiaA5iRpbMo
         1Htg==
X-Gm-Message-State: ACrzQf2fRi9jVnrMd1LYqalKegt2GAGJPsCQQpCyagY/YvenJn1ofVXD
        3Ex32aEIiNajODfTF4vyHd3GHg==
X-Google-Smtp-Source: AMsMyM6v3bn6n2QXmRyp6k9/WFXcHeQTrFHSgtt18uX5jmUuho3VNautnRtV5ssoL+ke73ayUJkiiQ==
X-Received: by 2002:a63:2f45:0:b0:457:dc63:68b4 with SMTP id v66-20020a632f45000000b00457dc6368b4mr6416380pgv.228.1665182485640;
        Fri, 07 Oct 2022 15:41:25 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e17-20020a17090301d100b00172e19c2fa9sm2069723plh.9.2022.10.07.15.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 15:41:25 -0700 (PDT)
Date:   Fri, 7 Oct 2022 22:41:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/3] KVM: SVM: Unconditionally enumerate
 EferLmsleUnsupported
Message-ID: <Y0CrER/yiHheWiZw@google.com>
References: <20220920205922.1564814-1-jmattson@google.com>
 <20220920205922.1564814-4-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920205922.1564814-4-jmattson@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 20, 2022, Jim Mattson wrote:
> CPUID.80000008H:EDX.EferLmsleUnsupported[bit 20] indicates that
> IA32_EFER.LMSLE[bit 13] is unsupported and must be zero.
> 
> KVM doesn't support "Long Mode Segment Limit Enable," even if the
> underlying physical processor does, so set that bit in the guest CPUID
> table returned by KVM_GET_SUPPORTED_CPUID.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3af360fe21e6..0bf6ac51f097 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4945,6 +4945,7 @@ static __init void svm_set_cpu_caps(void)
>  	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
>  	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
>  		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
> +	kvm_cpu_cap_set(X86_FEATURE_NO_LMSLE);

This can go in common x86 code, e.g. if someone wants to run an AMD VM on Intel
hardware.

Side topic, in the context of this series, the below diff highlights how silly it
is for PSFD to be banished from cpufeatures.h.  While we have Boris's attention
(and ACK!), can you tack on a patch to move drop KVM_X86_FEATURE_PSFD and move the
bit to cpufeatures.h where it belongs?

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -696,6 +696,7 @@ void kvm_set_cpu_caps(void)
                F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) |
                __feature_bit(KVM_X86_FEATURE_PSFD)
        );
+       kvm_cpu_cap_set(X86_FEATURE_NO_LMSLE);
 
        /*
         * AMD has separate bits for each SPEC_CTRL bit.
