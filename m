Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80AE1720F06
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 11:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjFCJsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Jun 2023 05:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjFCJsT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Jun 2023 05:48:19 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BC89E;
        Sat,  3 Jun 2023 02:48:13 -0700 (PDT)
Received: from zn.tnic (pd9530d32.dip0.t-ipconnect.de [217.83.13.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E7ACA1EC0741;
        Sat,  3 Jun 2023 11:48:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1685785692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=4eBISpVHvvvAIqctU9D3HtsydINafKGOlqSu7X2SgxE=;
        b=ovjLfrOrsg9vZaeA73I1h12dafUKjPg5efNR+JgzeWrzsJp8oxYkLP8RGwG6q3m6t5HVcI
        nRzW/8VJniI7i0nO685oxSkY4sPS1zgExTeocKVfDKDwgBHqd0MySTKz+7sANLni50yyHS
        iX0R7N4w3pNpsc5RxKAC4YmmEG7lWi4=
Date:   Sat, 3 Jun 2023 11:48:08 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        hpa@zytor.com, peterz@infradead.org, andrew.cooper3@citrix.com,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
Subject: Re: [PATCH v8 02/33] x86/fred: make unions for the cs and ss fields
 in struct pt_regs
Message-ID: <20230603094808.GAZHsMWDc5iUSWeBmK@fat_crate.local>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-3-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230410081438.1750-3-xin3.li@intel.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 10, 2023 at 01:14:07AM -0700, Xin Li wrote:
> diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
> index f4db78b09c8f..2abb23e6c1e2 100644
> --- a/arch/x86/include/asm/ptrace.h
> +++ b/arch/x86/include/asm/ptrace.h
> @@ -82,12 +82,40 @@ struct pt_regs {
>   * On hw interrupt, it's IRQ number:
>   */
>  	unsigned long orig_ax;
> -/* Return frame for iretq */
> +/* Return frame for iretq/eretu/erets */
>  	unsigned long ip;
> -	unsigned long cs;
> +	union {
> +		unsigned long  csx;	/* cs extended: CS + any fields above it */
> +		struct __attribute__((__packed__)) {

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 2abb23e6c1e2..d850d3072263 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -86,7 +86,7 @@ struct pt_regs {
 	unsigned long ip;
 	union {
 		unsigned long  csx;	/* cs extended: CS + any fields above it */
-		struct __attribute__((__packed__)) {
+		struct {
 			unsigned short cs;	/* CS selector proper */
 			unsigned int current_stack_level: 2;
 			unsigned int __csx_resv1	: 6;
@@ -96,13 +96,13 @@ struct pt_regs {
 			unsigned int nmi		: 1;
 			unsigned int __csx_resv3	: 3;
 			unsigned int __csx_resv4	: 32;
-		};
+		} __packed;
 	};
 	unsigned long flags;
 	unsigned long sp;
 	union {
 		unsigned long  ssx;	/* ss extended: SS + any fields above it */
-		struct __attribute__((__packed__)) {
+		struct {
 			unsigned short ss;	/* SS selector proper */
 			unsigned int __ssx_resv1	: 16;
 			unsigned int vector		: 8;
@@ -114,7 +114,7 @@ struct pt_regs {
 			unsigned int nested		: 1;
 			unsigned int __ssx_resv4	: 1;
 			unsigned int instr_len		: 4;
-		};
+		} __packed;
 	};
 /* top of stack page */
 };

> +			unsigned short cs;	/* CS selector proper */

Also, please put all those comments above the members, like the rest of the
file does.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
