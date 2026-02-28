Return-Path: <kvm+bounces-72285-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6DYMB/Jho2myBQUAu9opvQ
	(envelope-from <kvm+bounces-72285-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 22:45:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 111A81C93AF
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 22:45:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 92B5330689CC
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 21:27:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95CA4317143;
	Sat, 28 Feb 2026 21:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l0s7lJKs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC33223DD6
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 21:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772314021; cv=none; b=vEUhhs0/g93UXB9h+jRWJYCOiWSr1fpiNPkCzHbvXyeG24faMAFB76v34bA6swL6zfGvSQqmFlokAeMCdcc5SqiaXiMRBDTvbyUPH0BBvWnMamdtowBgCJWZ8V5p6tlaUYJk5hA2BSBz4TVH3Ov6ChUOxJCj53p0QCyD3INSADA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772314021; c=relaxed/simple;
	bh=X/bP553Kn7rWVva7qg+2pv2HgUlqbPDkAW43FQSl84o=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-version:Content-type; b=CO7X9HzR2YvKtaMPUdKLODZhS81104l2HI88b5FH9XgWkbkRMI02O0ayQNuPtUfc0n5JM3HDcb5+g+Z5N6m33TwgE6000ruEuSJCoyir5n6Yggm+3co2mc8qJP/npf5ailYTTdoKal46oox2w1YhPHoBLac4/o2n9sF2+yHhzWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l0s7lJKs; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ab39b111b9so15929895ad.1
        for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 13:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772314020; x=1772918820; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3u+tbCKuiO12lFJH2PgWftBt3LrL7T3icieNzOkjqcE=;
        b=l0s7lJKs181DQmlH0Fchnyk3D3qb+cBo+e9Ngfd3pW42RiG0klYj2RRnZS564cpC5g
         hq3kqLNdPauD21WIFClg+UPp3ZhaNsfE1QV4NoGN2zHFUMwiP74TEQYgfS7V2NzjWaia
         eeYDkdSUofBg5AakFnb+MvzyhdlW65N2ujMvx5khly+ppRVXnX5cjKNfXhv1XlKqvM4M
         gyeg+0JVxCy00YKEVlt8+1JbYTOs5I3P+sIF6OI6hAzSS7032VN6CYKSRLDH+akz9RFC
         uXh/plCV/jDIFeh1FThFmD++KRQkn/dY2yc6ET+O73tBlRwpAdbc8Cw6FUQWmihQILYi
         egIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772314020; x=1772918820;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3u+tbCKuiO12lFJH2PgWftBt3LrL7T3icieNzOkjqcE=;
        b=sDFnRCxRtGRHpuyXyjaGwOASrfKd5C1iIEHmThnRfPyDgSQsGftWqCXkg7ztXMNyI1
         aJAmyN5rpsu1njV8hMv53wdGSnMnO+QjnoA2Yli4DoNMQnkft5ATPx1zDM/TbfkeNB7X
         gmQr0ubYVZULmhJplqzgfY18iId5AJTCJSnm0JFBaGL7ep9qWWquzlKuGcJJ4pTtVgm9
         me41LLBt6KnpffBBr9Kv9wrQvmYF8A9gEo64qRktazcyxbhFedBE+elJ7mTrvDWmOzqo
         s9WVpSns8jX+EKYcZKik5FfcIXVkBLFsvSObqld71rxvibjKoTcQI+N8+wWyoVGIdh2x
         tKZA==
X-Forwarded-Encrypted: i=1; AJvYcCXczocI2DB5Jvzj9dZnSwX00PbXl4wPflj0xc2NmgtTejST9he0jJMTz9Hnf0pMihojlCg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf3rY2Uj8fcxdPd+9AFT+utYC170DjV515CNyPooS3iNIbFmEJ
	jR52aMaM1iqZUFO+9dG0f4IIuziBto43Juqf3xWZMiGK/zM0KnWyMFCtbnN2Ww==
X-Gm-Gg: ATEYQzwh1CKSwq/j69Du7XXYGa5wvZPMMkmXIlz0SnFPYmy/7mxPNU08cIIB1+Qbgdy
	sKnacnHmeWbTYyv6/msxMsMT/SxEWPohRTyItabfJAIaGDsU4S4mBUtD8KOqfjpGbBIpVaZxp3+
	JfR50mDwEG8hLRqKtE1uHNykl2Rlt1V4wg1zE0cMCqmQhKsGgeY11ZQ8UljOLMWop+biJ4aP7eU
	/F0k3jS+ho5ZA4lHdXdDzLqYtJLBD6+VS/K4xQV2pGA/mBsMK0Vtah1SdscJBZosUuw+nNTi9JK
	4tP4alO7daz7aljpSDuGbzF9l297ibRccgkrNhSOMLT8HGApxpyAKr66Q2AxUqjmKfBReZizmiZ
	1ofrp5s82B/oXg1dgJo3Bq5Nq4onrPsT/cz/JJcSn2Q906yEsWfVccwi469mWQKh6MF+rCMefrj
	6zPNGsKETRA8MKbqEK
X-Received: by 2002:a17:903:1aad:b0:2aa:ecec:a43d with SMTP id d9443c01a7336-2ae2e401f52mr62465095ad.21.1772314019931;
        Sat, 28 Feb 2026 13:26:59 -0800 (PST)
Received: from dw-tp ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae3e4e34e6sm26334335ad.30.2026.02.28.13.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Feb 2026 13:26:58 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org, kvm@vger.kernel.org, Alex Williamson <alex@shazbot.org>, Peter Xu <peterx@redhat.com>
Subject: Re: [RFC v1 2/2] powerpc/64s: Add support for huge pfnmaps
In-Reply-To: <87pl5qh3ye.ritesh.list@gmail.com>
Date: Sun, 01 Mar 2026 02:44:32 +0530
Message-ID: <87tsv0in9j.ritesh.list@gmail.com>
References: <0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list@gmail.com> <d159058a45ac5e225f2e64cc7c8bbbd1583e51f3.1772170860.git.ritesh.list@gmail.com> <abfbe83b-23fb-400d-9069-b8bf4ad21d95@kernel.org> <87pl5qh3ye.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-72285-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[riteshlist@gmail.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 111A81C93AF
X-Rspamd-Action: no action

Ritesh Harjani (IBM) <ritesh.list@gmail.com> writes:

> "Christophe Leroy (CS GROUP)" <chleroy@kernel.org> writes:
>
>> Le 27/02/2026 à 07:16, Ritesh Harjani (IBM) a écrit :
>>> This uses _RPAGE_SW2 bit for the PMD and PUDs similar to PTEs.
>>> This also adds support for {pte,pmd,pud}_pgprot helpers needed for
>>> follow_pfnmap APIs.
>>> 
>>> This allows us to extend the PFN mappings, e.g. PCI MMIO bars where
>>> it can grow as large as 8GB or even bigger, to map at PMD / PUD level.
>>> VFIO PCI core driver already supports fault handling at PMD / PUD level
>>> for more efficient BAR mappings.
>>> 
>>> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>>
>> Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
>>
>>
>
> Thanks for the review!
>
>>>   #define __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
>>>   extern int pmdp_set_access_flags(struct vm_area_struct *vma,
>>> diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
>>> index dcd3a88caaf6..2d27cb1c2334 100644
>>> --- a/arch/powerpc/include/asm/pgtable.h
>>> +++ b/arch/powerpc/include/asm/pgtable.h
>>> @@ -63,6 +63,18 @@ static inline pgprot_t pte_pgprot(pte_t pte)
>>>   	return __pgprot(pte_flags);
>>>   }
>>> 
>>> +#define pmd_pgprot pmd_pgprot
>>> +static inline pgprot_t pmd_pgprot(pmd_t pmd)
>>> +{
>>> +	return pte_pgprot(pmd_pte(pmd));
>>> +}
>>> +
>>> +#define pud_pgprot pud_pgprot
>>> +static inline pgprot_t pud_pgprot(pud_t pud)
>>> +{
>>> +	return pte_pgprot(pud_pte(pud));
>>> +}
>>> +
>
> In v2 - I will add above under #ifdef CONFIG_PPC_BOOK3S_64 
> to avoid build issues with 32-bit PPC.
>

On second thoughts, I am thinking maybe we should guard it with CONFIG_PPC64.  
Currently the build fails on 32-bit since no definitions of pmd_pte()
and pud_pte().  Though, we could open-code that, but I think as of
today, this only gets excercised from follow_pfnmap_start() which gates
it with VM_PFNMAP | VM_IO, which I think could only happen for THP which
is only true for book3s/64. 
But to keep the generic definitions of pXd_pgprot() and since pmd_pte()
and pud_pte() are anyways available on book3s/64 & nohash/64, so let's
just guard this with PPC64.

I will amend this change in RFC-v2 and will keep the RB from Christophe.


+#ifdef CONFIG_PPC64
+#define pmd_pgprot pmd_pgprot
+static inline pgprot_t pmd_pgprot(pmd_t pmd)
+{
+       return pte_pgprot(pmd_pte(pmd));
+}
+
+#define pud_pgprot pud_pgprot
+static inline pgprot_t pud_pgprot(pud_t pud)
+{
+       return pte_pgprot(pud_pte(pud));
+}
+#endif /* CONFIG_PPC64 */
+


-ritesh


