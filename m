Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517B041CB0D
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 19:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344658AbhI2R1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 13:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244721AbhI2R1G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 13:27:06 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8AC1C061760;
        Wed, 29 Sep 2021 10:25:25 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0bd10085b5178de8b08a0e.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:d100:85b5:178d:e8b0:8a0e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EFE231EC085D;
        Wed, 29 Sep 2021 19:25:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1632936324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=y/YSVKPz9O6La4nqgfOZhSPntZc7BllBHBJbPD+DgVw=;
        b=LxeHHdcNffy35LFdD96qNzM49vE6teo3umfP4ix8VPJapVr0lpiTVaY+CxmAC3nk8Gj3Tc
        MKiExWcSc3wL9YjiOMT3ty//UnaFWs/4uNI5zspIUZjUhkmh1xtLs7uDygniu+JpaWPoTs
        XNxJ/6bbGghvOxtnHXpgwgRFPZRAnek=
Date:   Wed, 29 Sep 2021 19:25:13 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 07/45] x86/traps: Define RMP violation #PF error
 code
Message-ID: <YVSheQCk2FvXvBwO@zn.tnic>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-8-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-8-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021 at 10:58:40AM -0500, Brijesh Singh wrote:
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

Those are tested against error_code mostly, which is unsigned long so it
looks like you wanna use _BITUL() here. Not that it matters on x86-64
but if we want to be precise...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
