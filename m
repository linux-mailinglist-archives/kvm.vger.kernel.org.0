Return-Path: <kvm+bounces-2656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7A097FC02B
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 18:19:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1E531C20C87
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 17:19:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65DDE5C08D;
	Tue, 28 Nov 2023 17:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="6XE+gwUS"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8F410CB;
	Tue, 28 Nov 2023 09:19:17 -0800 (PST)
Received: from [127.0.0.1] ([98.35.210.218])
	(authenticated bits=0)
	by mail.zytor.com (8.17.2/8.17.1) with ESMTPSA id 3ASHIMck585558
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 28 Nov 2023 09:18:23 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 3ASHIMck585558
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2023111101; t=1701191904;
	bh=f6l68iGv5eAcjwGj55E8OL6CF5X9iU8J74t2PrTG5YA=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=6XE+gwUSIscmXlxZmR/obyqPnRdyFc9SgOdDhOLZ5zIn1Qj3I3XIlJN7R91edhLqJ
	 3ATaGYKTRv7hC69ocMawcn/GiY4V77tWz594FEnWHS1T/g+UF3/dc6k9z0gaybTIHl
	 sdQV9dZqS9FscMeWhYHdMnochTHoBUVyrWGiTY2zNzeuYMHsP9gBs5xV7h8+eLlOz8
	 5O5NkXqRyj9mjLrHrEoT9mG7b2dvs/x/bc4pP1UavUy6IAgToEPxAtQdtXqZvS6W9m
	 YOJM6Xe1gTSAM8HoXUXn+o/WwGXl2uufOA2uqrbGW6boguYBo3j4/dND+m2saj1FAf
	 JdMK7bWrvWlow==
Date: Tue, 28 Nov 2023 09:18:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Borislav Petkov <bp@alien8.de>, Xin Li <xin3.li@intel.com>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        x86@kernel.org, luto@kernel.org, pbonzini@redhat.com,
        seanjc@google.com, peterz@infradead.org, jgross@suse.com,
        ravi.v.shankar@intel.com, mhiramat@kernel.org,
        andrew.cooper3@citrix.com, jiangshanlai@gmail.com,
        nik.borisov@suse.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v12_16/37=5D_x86/ptrace=3A_Add_FRED_ad?= =?US-ASCII?Q?ditional_information_to_the_pt=5Fregs_structure?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20231128085122.GPZWWqCrPYnzB8BqFB@fat_crate.local>
References: <20231003062458.23552-1-xin3.li@intel.com> <20231003062458.23552-17-xin3.li@intel.com> <20231128085122.GPZWWqCrPYnzB8BqFB@fat_crate.local>
Message-ID: <E5913DD8-7C41-4658-9E42-63C01E2209B2@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On November 28, 2023 12:51:22 AM PST, Borislav Petkov <bp@alien8=2Ede> wrot=
e:
>On Mon, Oct 02, 2023 at 11:24:37PM -0700, Xin Li wrote:
>> FRED defines additional information in the upper 48 bits of cs/ss
>> fields=2E Therefore add the information definitions into the pt_regs
>> structure=2E
>>=20
>> Specially introduce a new structure fred_ss to denote the FRED flags
>> above SS selector, which avoids FRED_SSX_ macros and makes the code
>> simpler and easier to read=2E
>>=20
>> Signed-off-by: H=2E Peter Anvin (Intel) <hpa@zytor=2Ecom>
>
>You and hpa need to go through all the patches and figure out who's the
>author that's going to land in git=2E
>
>Because this and others have hpa's SOB first, suggesting he's the
>author=2E However, the mail doesn't start with
>
>From: H=2E Peter Anvin (Intel) <hpa@zytor=2Ecom>
>
>and then git will make *you* the author=2E
>
>> Tested-by: Shan Kang <shan=2Ekang@intel=2Ecom>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix=2Ede>
>> Signed-off-by: Xin Li <xin3=2Eli@intel=2Ecom>
>
>=2E=2E=2E
>
>>  	union {
>> -		u64	ssx;	// The full 64-bit data slot containing SS
>> -		u16	ss;	// SS selector
>> +		/* SS selector */
>> +		u16		ss;
>> +		/* The extended 64-bit data slot containing SS */
>> +		u64		ssx;
>> +		/* The FRED SS extension */
>> +		struct fred_ss	fred_ss;
>
>Aha, sanity about the right comments has come to your mind in this next
>patch=2E :-P
>
>Just do them right in the previous one=2E
>
>>  	/*
>> -	 * Top of stack on IDT systems=2E
>> +	 * Top of stack on IDT systems, while FRED systems have extra fields
>> +	 * defined above for storing exception related information, e=2Eg=2E =
CR2 or
>> +	 * DR6=2E
>
>Btw, I really appreciate the good commenting - thanks for that!
>

For Xin, mainly:

Standard practice is:

1=2E For a patch with relatively small modifications, or where the changes=
 are mainly in comments or the patch message:

Keep the authorship, but put a description of what you have changed in bra=
ckets with your username at the bottom of the description, immediately befo=
re Signed-off-by:

[ xin: changed foo, bar, baz ]


2=2E For a patch with major rewrites:

Take authorship on the From: line, but have an Originally-by: tag (rather =
than a Signed-off-by: by the original author):

Originally-by: Someone Else <someone@elsewhere=2Edom>


3=2E For a patch which is fully or nearly fully your own work (a total rew=
rite, or based on a concept idea rather than actual code), credit the origi=
nal in the patch comment:

Based on an idea by Someone Else <someone@elsewhere=2Edom> (optional link =
to lore=2Ekernel=2Eorg)=2E

