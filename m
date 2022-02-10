Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5492E4B1300
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 17:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241464AbiBJQjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 11:39:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237433AbiBJQjG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 11:39:06 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D205C24
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 08:39:07 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id a11-20020a17090a740b00b001b8b506c42fso9203868pjg.0
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 08:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CLm6QahwfUqv2o403kfVuC3IsoRBsn5o8i8ZA1jS7Uo=;
        b=gi3V2hB1K6fj+Yq4Zk+QFfaTjeXNfJeh/gXsdaRN63HhN10Wvk6oDPWxuRMcN5yrnS
         9ws8AYS6s/9BQSDBSwfY+W5L5r1NisBBE6sSEBIpdTDONpp/sJEkoWwlAxiMy4FG/5M5
         bq2qf4lwYaPjtpzlAgXpvGEEr35KfBLhZVYVr4fBeNNFbCeNjdpACaUCedkEGh5HSWUc
         /Rp3ppiy51HzNYbAUK6P2rXqxBCYTXPN4Bw2tpknakQO25P4WvM4PId0QD3IAfhEfLmN
         lUtGHF3gPt9RDAHQ0ITFb90b9O7XuAPWxw0wVX5Pb/egXD82n6B1KqPYg1V5k2Ud36N4
         K4iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CLm6QahwfUqv2o403kfVuC3IsoRBsn5o8i8ZA1jS7Uo=;
        b=HmyvaUPwRynVtc1ITWb//Frsg/1Evhtskm7ADbMTiFucNTlLOXv7OhXGiOoBeQEGBK
         wT7jXHiViYoK4Bm6JZoq/3FUWNICD0DY0GQIQ2wqC5/Ie4YvRRdF40WV1MFw9K/pcuc/
         Kb0gusosBp86y0MtcW1pibctdtfMuqIfYVKvTnig4Qca7Sg7IJ7fHPtxEh+Qpd9a+PZ2
         +a2Ne8kl9lnAq2RH556jR/g7SqDIbiU4Oh5aHBs7RvFwdEyB+5+FR82v2srmvWuLZPJD
         o9AGRj9g+VYze6PJkDBKjKtPWJIu/BuQXmpAZxM2BadCaCdMFHYQUl0PYS8cLQWpAB/I
         fvFw==
X-Gm-Message-State: AOAM532vqS+NNqTiPiQiuh7EUUVCJRIh4Nxdu9+wo4Kcz7PqHI6JcI5e
        UnB6ZRz/WQ2bVd+uZKd9JAf63dsrSRL/AA==
X-Google-Smtp-Source: ABdhPJx3LX4G1SMGbv9kBVJ/IpVWN+R2B+Ftmpmsdq9sCU+fkooG8n1HIsjpPC1aDbsdnTJavKO3ug==
X-Received: by 2002:a17:902:eb45:: with SMTP id i5mr8369604pli.75.1644511146457;
        Thu, 10 Feb 2022 08:39:06 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mw14sm3050549pjb.6.2022.02.10.08.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 08:39:05 -0800 (PST)
Date:   Thu, 10 Feb 2022 16:39:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/3] x86/emulator: Add some tests for
 far ret instruction emulation
Message-ID: <YgU/pjL8hW628hTV@google.com>
References: <cover.1644481282.git.houwenlong.hwl@antgroup.com>
 <5e4eab590cb46108d2b007a117edf1b9f566446d.1644481282.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e4eab590cb46108d2b007a117edf1b9f566446d.1644481282.git.houwenlong.hwl@antgroup.com>
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

On Thu, Feb 10, 2022, Hou Wenlong wrote:
> Per Intel's SDM on the "Instruction Set Reference", when
> loading segment descriptor for far return, not-present segment
> check should be after all type and privilege checks. However,
> __load_segment_descriptor() in x86's emulator does not-present
> segment check first, so it would trigger #NP instead of #GP
> if type or privilege checks fail and the segment is not present.
> 
> And if RPL < CPL, it should trigger #GP, but the check is missing
> in emulator.
> 
> So add some tests for far ret instruction, and it will test
> those tests on hardware and emulator. Enable
> kvm.force_emulation_prefix when try to test them on emulator.
> 
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---

With fixup for the -fPIC issue...

Reviewed-and-tested-by: Sean Christopherson <seanjc@google.com>

> +#define TEST_FAR_RET_ASM(seg, prefix)		\
> +({						\
> +	asm volatile("lea 1f(%%rip), %%rax\n\t" \
> +		     "pushq %[asm_seg]\n\t"	\
> +		     "pushq $2f\n\t"		\
> +		      prefix "lretq\n\t"	\
> +		     "1: addq $16, %%rsp\n\t"	\
> +		     "2:"			\
> +		     : : [asm_seg]"r"((u64)seg)	\
> +		     : "eax", "memory");	\
> +})


The "push $2f" generates an absolute address and fails to build with --target-efi,
which requires -fPIC.  The easiest thing that comes to mind is to load the address
into RAX and then push RAX.  The lea to get the exception IRET target into RAX needs
to be moved down, but that's ok.

---
 x86/emulator.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index c56b32b..c62dced 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -66,9 +66,10 @@ static struct far_xfer_test far_ret_test = {

 #define TEST_FAR_RET_ASM(seg, prefix)		\
 ({						\
-	asm volatile("lea 1f(%%rip), %%rax\n\t" \
-		     "pushq %[asm_seg]\n\t"	\
-		     "pushq $2f\n\t"		\
+	asm volatile("pushq %[asm_seg]\n\t"	\
+		     "lea 2f(%%rip), %%rax\n\t" \
+		     "pushq %%rax\n\t"		\
+		     "lea 1f(%%rip), %%rax\n\t" \
 		      prefix "lretq\n\t"	\
 		     "1: addq $16, %%rsp\n\t"	\
 		     "2:"			\

base-commit: 41d3306e19784478679910ee0afa55de05279b42
--

