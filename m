Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4428B54E95D
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 20:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbiFPSae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 14:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiFPSad (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 14:30:33 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B7E517E5
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 11:30:31 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id w21so2231239pfc.0
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 11:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R6cBgQ1F8u8a2uJ9mP+rpKOs9c3SYpszQM1QCFQFkRs=;
        b=Sw9PsfqGzJRWbgotRY/ozUoYOxtDrNrOiUVEftvUaP1IsUN3qgC7l52PFbBpsGacA9
         0t1SZUhmXGAjX+lDPZco8miobYrz+ogmkTIMqH24WuUdz4Vy7yvVqGbcQZIU7Yy/bZQE
         9jhhIxWZZzA4RXopx9utwKctJcha8Ei3edfMwTOcgv3/gE95Md00Yn6haBDGQcbzpIYh
         ypr7GGD7Z4vLLyKI2pUOc7U25LApDKcIDVDYSTXm6Z+0QSsdoBLmWVSePCdP+VzU6qy/
         kZ1aYRg9bU25aKieUNz3z17J6gSLJah+zCqJL0tp5SO6jI8Wi9P2n/yqX6MresoNYxdE
         5MCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R6cBgQ1F8u8a2uJ9mP+rpKOs9c3SYpszQM1QCFQFkRs=;
        b=5C2I1lmxbyIkBWQzfgiWDr+sD4u9s7sZdbLeCoM89Pv2w8f4b4YFZRvgnKTKu2Fg4n
         eWGV85S5JWuN3KJ4jrIt1e7SVmm0gJIiPVzqexzsVCPqlHv60e4OZxZDhvNlbm0Wxjhx
         EmBTqDM01mGajlRzaxSLwC1j3FCMjSZ94cPNRvPjC2J0w4661SpPV5AdZ1lyOIFDq3p9
         Gj4ZslkhkZOtZnPvajDaUOq3ojd69ZgwBfm57I2AKccC0mGxKrwzRavdAGG8FjNjX0mp
         svLUA63y5FbS0Eh0gqHggi9iXoW87SUAHz15+Za0DcXbiuIxA+A5pkqUrgpmWmcU9Y4J
         7AJw==
X-Gm-Message-State: AJIora9e/FIcREeJPv2Q11kuJMI5lD8iRFjx4w4D46Cu1Au8Q/kpKqyA
        psytLR1aeQaS1P2xw83SVqnuWQ==
X-Google-Smtp-Source: AGRyM1trS9QR7RaasFeFbinzj/SA7eKs44RC1sjNcTCwM4FWCIxDCKxJSSFWxcT75UCBboyIiOLwZA==
X-Received: by 2002:a05:6a00:a8e:b0:51e:76bf:5d1c with SMTP id b14-20020a056a000a8e00b0051e76bf5d1cmr5923135pfl.53.1655404231133;
        Thu, 16 Jun 2022 11:30:31 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id h4-20020a170902680400b001640aad2f71sm1987531plk.180.2022.06.16.11.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 11:30:30 -0700 (PDT)
Date:   Thu, 16 Jun 2022 18:30:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, likexu@tencent.com
Subject: Re: [PATCH kvm-unit-tests] x86: do not overwrite bits 7 and 12 of
 MSR_IA32_MISC_ENABLE
Message-ID: <Yqt2wlBKqsoOH0Y4@google.com>
References: <20220520183207.7952-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520183207.7952-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 20, 2022, Paolo Bonzini wrote:
> Bits 7 and 12 of MSR_IA32_MISC_ENABLE represent the configuration of the
> vPMU, and latest KVM does not allow the guest to modify them.  Adjust
> kvm-unit-tests to avoid failures.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  x86/msr.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/x86/msr.c b/x86/msr.c
> index 44fbb3b..2eb928c 100644
> --- a/x86/msr.c
> +++ b/x86/msr.c
> @@ -19,6 +19,7 @@ struct msr_info {
>  	bool is_64bit_only;
>  	const char *name;
>  	unsigned long long value;
> +	unsigned long long keep;
>  };
>  
>  
> @@ -27,6 +28,8 @@ struct msr_info {
>  
>  #define MSR_TEST(msr, val, only64)	\
>  	{ .index = msr, .name = #msr, .value = val, .is_64bit_only = only64 }
> +#define MSR_TEST_RO_BITS(msr, val, only64, ro)	\

Heh, I wrote pretty much this exact patch before I saw your version.

> +	{ .index = msr, .name = #msr, .value = val, .is_64bit_only = only64, .keep = ro }

What if we omit @only64 and hardcode it false, and add separate macros for the
"64-bit only" MSRS?  Then there are fewer magic booleans in the code.  Prep patch
at the bottom.  With that, this becomes:

#define MSR_TEST_RO_BITS(msr, val, ro)	__MSR_TEST(msr, val, false, ro)

>  struct msr_info msr_info[] =
>  {
> @@ -34,7 +37,8 @@ struct msr_info msr_info[] =
>  	MSR_TEST(MSR_IA32_SYSENTER_ESP, addr_ul, false),
>  	MSR_TEST(MSR_IA32_SYSENTER_EIP, addr_ul, false),
>  	// reserved: 1:2, 4:6, 8:10, 13:15, 17, 19:21, 24:33, 35:63
> -	MSR_TEST(MSR_IA32_MISC_ENABLE, 0x400c51889, false),
> +	// read-only: 7, 12
> +	MSR_TEST_RO_BITS(MSR_IA32_MISC_ENABLE, 0x400c50809, false, 0x1080),

Bit 11, "BTS Unavailable", is also read-only.  I would also strongly prefer that
this use BIT(7) | BIT(11) | BIT(12).  Maybe someday we can pull in msr-index.h...

>  	MSR_TEST(MSR_IA32_CR_PAT, 0x07070707, false),
>  	MSR_TEST(MSR_FS_BASE, addr_64, true),
>  	MSR_TEST(MSR_GS_BASE, addr_64, true),
> @@ -59,6 +63,8 @@ static void test_msr_rw(struct msr_info *msr, unsigned long long val)
>  	 */
>  	if (msr->index == MSR_EFER)
>  		val |= orig;
> +	else
> +		val = (val & ~msr->keep) | (orig & msr->keep);

Use MSR_TEST_RO_BITS() for MSR_EFER and the special case goes away.

	MSR_TEST_RO_BITS(MSR_EFER, EFER_SCE, ~EFER_SCE),

--
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jun 2022 12:44:01 -0700
Subject: [PATCH] x86/msr: Add dedicated macros to handle MSRs that are 64-bit
 only

Add a separate macro for handling 64-bit only MSRs to minimize churn and
copy+paste in a future commit that will add support for read-only bits.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/msr.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/x86/msr.c b/x86/msr.c
index 44fbb3b2..5f2ad8d6 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -25,24 +25,27 @@ struct msr_info {
 #define addr_64 0x0000123456789abcULL
 #define addr_ul (unsigned long)addr_64
 
-#define MSR_TEST(msr, val, only64)	\
+#define __MSR_TEST(msr, val, only64) \
 	{ .index = msr, .name = #msr, .value = val, .is_64bit_only = only64 }
 
+#define MSR_TEST(msr, val)		__MSR_TEST(msr, val, false)
+#define MSR_TEST_ONLY64(msr, val)	__MSR_TEST(msr, val, true)
+
 struct msr_info msr_info[] =
 {
-	MSR_TEST(MSR_IA32_SYSENTER_CS, 0x1234, false),
-	MSR_TEST(MSR_IA32_SYSENTER_ESP, addr_ul, false),
-	MSR_TEST(MSR_IA32_SYSENTER_EIP, addr_ul, false),
+	MSR_TEST(MSR_IA32_SYSENTER_CS, 0x1234),
+	MSR_TEST(MSR_IA32_SYSENTER_ESP, addr_ul),
+	MSR_TEST(MSR_IA32_SYSENTER_EIP, addr_ul),
 	// reserved: 1:2, 4:6, 8:10, 13:15, 17, 19:21, 24:33, 35:63
-	MSR_TEST(MSR_IA32_MISC_ENABLE, 0x400c51889, false),
-	MSR_TEST(MSR_IA32_CR_PAT, 0x07070707, false),
-	MSR_TEST(MSR_FS_BASE, addr_64, true),
-	MSR_TEST(MSR_GS_BASE, addr_64, true),
-	MSR_TEST(MSR_KERNEL_GS_BASE, addr_64, true),
-	MSR_TEST(MSR_EFER, EFER_SCE, false),
-	MSR_TEST(MSR_LSTAR, addr_64, true),
-	MSR_TEST(MSR_CSTAR, addr_64, true),
-	MSR_TEST(MSR_SYSCALL_MASK, 0xffffffff, true),
+	MSR_TEST(MSR_IA32_MISC_ENABLE, 0x400c51889),
+	MSR_TEST(MSR_IA32_CR_PAT, 0x07070707),
+	MSR_TEST_ONLY64(MSR_FS_BASE, addr_64),
+	MSR_TEST_ONLY64(MSR_GS_BASE, addr_64),
+	MSR_TEST_ONLY64(MSR_KERNEL_GS_BASE, addr_64),
+	MSR_TEST(MSR_EFER, EFER_SCE),
+	MSR_TEST_ONLY64(MSR_LSTAR, addr_64),
+	MSR_TEST_ONLY64(MSR_CSTAR, addr_64),
+	MSR_TEST_ONLY64(MSR_SYSCALL_MASK, 0xffffffff),
 //	MSR_IA32_DEBUGCTLMSR needs svm feature LBRV
 //	MSR_VM_HSAVE_PA only AMD host
 };

base-commit: 2eed0bf1096077144cc3a0dd9974689487f9511a
-- 

