Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2141F58C92E
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 15:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243229AbiHHNNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 09:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243224AbiHHNNU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 09:13:20 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462F82C8;
        Mon,  8 Aug 2022 06:13:19 -0700 (PDT)
Received: from zn.tnic (p200300ea971b98cb329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:98cb:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 590671EC0324;
        Mon,  8 Aug 2022 15:13:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1659964393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=fMS7xVNFh3Y0DjyDY0WIgzKl0DxlBVb3xHKu0mYYgrw=;
        b=AzKfFbWBrPNIIgSbaUIvdZnU1hPajXBtY+5GZoxuBRLQAknp8MtBF5WpaCsRBLmSl1TuLC
        bmesbqCcUOLx5D1WJh4T1rV+uNWZLUSHHiU1rISjx4ARJRVahvtdvvUMnzwPVlaexl7vhZ
        UPWiZatlfigojXzDUj8TrS+zwo0+vQc=
Date:   Mon, 8 Aug 2022 15:13:08 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 08/49] x86/traps: Define RMP violation #PF error
 code
Message-ID: <YvEL5CxHXoE1fWU3@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <5328a76b3fab1f20b3ffc400ca2402bec19d9700.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5328a76b3fab1f20b3ffc400ca2402bec19d9700.1655761627.git.ashish.kalra@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 11:03:27PM +0000, Ashish Kalra wrote:
> @@ -12,15 +14,17 @@
>   *   bit 4 ==				1: fault was an instruction fetch
>   *   bit 5 ==				1: protection keys block access
>   *   bit 15 ==				1: SGX MMU page-fault
> + *   bit 31 ==				1: fault was due to RMP violation
>   */
>  enum x86_pf_error_code {
> -	X86_PF_PROT	=		1 << 0,
> -	X86_PF_WRITE	=		1 << 1,
> -	X86_PF_USER	=		1 << 2,
> -	X86_PF_RSVD	=		1 << 3,
> -	X86_PF_INSTR	=		1 << 4,
> -	X86_PF_PK	=		1 << 5,
> -	X86_PF_SGX	=		1 << 15,
> +	X86_PF_PROT	=		BIT_ULL(0),
> +	X86_PF_WRITE	=		BIT_ULL(1),
> +	X86_PF_USER	=		BIT_ULL(2),
> +	X86_PF_RSVD	=		BIT_ULL(3),
> +	X86_PF_INSTR	=		BIT_ULL(4),
> +	X86_PF_PK	=		BIT_ULL(5),
> +	X86_PF_SGX	=		BIT_ULL(15),
> +	X86_PF_RMP	=		BIT_ULL(31),

Yeah, I remember dhansen asked for those to use the BIT() macro but the
_ULL is an overkill. Those PF flags are 32 and they fit in an unsigned
int.

But we don't have BUT_UI() so I guess the next best thing - BIT() -
which uses UL internally, should be good enough.

So pls use BIT() here - not BIT_ULL().

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
