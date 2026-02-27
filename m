Return-Path: <kvm+bounces-72146-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4BPnOLyNoWnouAQAu9opvQ
	(envelope-from <kvm+bounces-72146-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 13:27:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 625401B70F9
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 13:27:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 03B8630451F9
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 12:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B99693F074B;
	Fri, 27 Feb 2026 12:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b7kdlOl1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DAE30CD81
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 12:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772195257; cv=none; b=JZyzVq5q2BVEyKb+y6XY0hDSxHsBlhmeZNVVEFKCTby7JtKinkbHWhYksZ7AbystKx+4oA54XtUOHR5DKraFmSE2+1k91+wZu5HkYrH9isjqOtPA67yDQ0UiS+jyJ4NJEjM9IXxSTzDJ6H/iR4KSmW8f28cM7SXja5lAlv534Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772195257; c=relaxed/simple;
	bh=PzpkNLsWIGHZiCrOjhr7MHI8LKyh0/MD9t8kysr1W78=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-version:Content-type; b=c07ERLCRnRtj2PBHrCdOTpb9sxz2D+Bq7IxZooaEmpBorTrJw29xasrG+n7TsgZIEXnS7ob/uS575Gzhbhnn0jP6OQkyW0tcIEMEn+8xgljSKJmGpDG6WSxsJA7l6J+QCDtxlvE8JnzWh10dC3yALlmHrEhiWH5Gxr3daZiTn3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b7kdlOl1; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-824adc96ad2so1981957b3a.3
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 04:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772195255; x=1772800055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BBCa2Iq0/hu0sJwRb681qcL3bM1nOatkl9qB4gJ48xY=;
        b=b7kdlOl11DaWcjhxH3Kr45UGFQV02XThQ2j/a8JNFy1tpKfHXM42zt21uMRXpz+E9Z
         wctsYmvCaBCPeKu6v/9/bQzCOSYX92H++u8banen8T0mR1SO4S9SgyZvCsCeqM+Lbyev
         K/NyrENhIOFzQ5qJNsHPXSa0IZOiprIhZpDjb1YRHFv62jbGk13ZDZ/pnzD2CR4iKPst
         FQ5ZY62jgKfdAFe4u1m6dWygMFhro8SLr8N/rEbiPmI8AYnGR9WwV/Enn3utwxH7CNsu
         u1pWkKE5fSiUDbpYrCjrtvqRmTMOSWlUNx2jVsOxDGXKfYpi1miTvsj7SDVyNOAc2Ue6
         WHGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772195255; x=1772800055;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BBCa2Iq0/hu0sJwRb681qcL3bM1nOatkl9qB4gJ48xY=;
        b=LZY2ZqqbH2z1EQ98F3P1S22D4ftZY5VhwmdbXxd26hp0nw4lgCyueDD2bMjIiWBBvI
         UjCR70frqY1KuO/usB34nDLNq0kDz4yrA5hnAoMNs0CpKuqDc3TstljJpwnRP4s6aLRY
         Paa4xhgZAqFu0fOFDkjKlq1xJ1udwrHhYx7gWBgzUG1U2yHlVbHvL5kVD5x0k/NtTGr1
         Wg1ndWtqDGAkrhDaWqI5ptgQBLgzL9l3VvnhNw3MeKQdAF2fvfVIR3Iskt+0Z2ApzOt4
         DsPBxTjnm2QkpGfpdVZLAiQYah7wS3yja+lSsCBQdZbw6ID1Opga+9RIEzeU036x5O2G
         Bxxw==
X-Forwarded-Encrypted: i=1; AJvYcCUxVtMImumRIhvRA7DNaKlqMfms72BIm55I3E/V6UqSj2CsQxU1/fCCoVjACVItnelzs8Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBqJYCJndmbW6vAjRSgli9UPNbYk9kNcKpuPxmOkH1kNolb8dA
	hjEx6fdf1ElfUNyS0SIDLWaQJh/2c4U/pD33kzwjTPmve5m5NuTpSZBy
X-Gm-Gg: ATEYQzwxYvTZL4djS2DnWgNsrJ8wr7TZ3ff9NMKpBz2TDITje6YuruCboDBXsLkfTRg
	byiiPWSugtz3xM0zKnjYqiL8oDfONwuUjXHxBBKbP+BOpskuSKC4JEOqmF2f9P3u08nfg7MoO9u
	5lxuS9A7S87EVMx6GPTWM3e1rGRgOg4cJYXrdpXsGSZIc2ylLGuVC98SJDNmbw0rlf3DyKpfohU
	drT1hkhIgEjDLqpYc66iq7jGfPoYTmEC+aBPF2OZUeL8gr1NeqwY7cdVbqYbq6RfevqTOCLTGlC
	aWw/OXPAnPUtAktkqoHAtxQCQFvdH9QcpBai/Zv+s692Y/hhV1pp6m/JC3QbNg2f+CGp1+gwzJM
	5+4FkVzDqBZzwsq4Ej3jpR+q63dgO495TQKGnGsVOrxSKdaXIacJALEbt7dQ+LixqaJ46pe93/w
	ZozrUj5kErSUgm1xwXNw==
X-Received: by 2002:a05:6a00:4c81:b0:81f:3ae9:3f71 with SMTP id d2e1a72fcca58-8274d9d0704mr2242350b3a.28.1772195255179;
        Fri, 27 Feb 2026 04:27:35 -0800 (PST)
Received: from dw-tp ([203.81.240.187])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82739ff1c9esm5479908b3a.32.2026.02.27.04.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 04:27:34 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org, kvm@vger.kernel.org, Alex Williamson <alex@shazbot.org>, Peter Xu <peterx@redhat.com>
Subject: Re: [RFC v1 2/2] powerpc/64s: Add support for huge pfnmaps
In-Reply-To: <abfbe83b-23fb-400d-9069-b8bf4ad21d95@kernel.org>
Date: Fri, 27 Feb 2026 16:02:25 +0530
Message-ID: <87pl5qh3ye.ritesh.list@gmail.com>
References: <0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list@gmail.com> <d159058a45ac5e225f2e64cc7c8bbbd1583e51f3.1772170860.git.ritesh.list@gmail.com> <abfbe83b-23fb-400d-9069-b8bf4ad21d95@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-72146-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[riteshlist@gmail.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 625401B70F9
X-Rspamd-Action: no action

"Christophe Leroy (CS GROUP)" <chleroy@kernel.org> writes:

> Le 27/02/2026 à 07:16, Ritesh Harjani (IBM) a écrit :
>> This uses _RPAGE_SW2 bit for the PMD and PUDs similar to PTEs.
>> This also adds support for {pte,pmd,pud}_pgprot helpers needed for
>> follow_pfnmap APIs.
>> 
>> This allows us to extend the PFN mappings, e.g. PCI MMIO bars where
>> it can grow as large as 8GB or even bigger, to map at PMD / PUD level.
>> VFIO PCI core driver already supports fault handling at PMD / PUD level
>> for more efficient BAR mappings.
>> 
>> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>
> Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
>
>

Thanks for the review!

>>   #define __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
>>   extern int pmdp_set_access_flags(struct vm_area_struct *vma,
>> diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
>> index dcd3a88caaf6..2d27cb1c2334 100644
>> --- a/arch/powerpc/include/asm/pgtable.h
>> +++ b/arch/powerpc/include/asm/pgtable.h
>> @@ -63,6 +63,18 @@ static inline pgprot_t pte_pgprot(pte_t pte)
>>   	return __pgprot(pte_flags);
>>   }
>> 
>> +#define pmd_pgprot pmd_pgprot
>> +static inline pgprot_t pmd_pgprot(pmd_t pmd)
>> +{
>> +	return pte_pgprot(pmd_pte(pmd));
>> +}
>> +
>> +#define pud_pgprot pud_pgprot
>> +static inline pgprot_t pud_pgprot(pud_t pud)
>> +{
>> +	return pte_pgprot(pud_pte(pud));
>> +}
>> +

In v2 - I will add above under #ifdef CONFIG_PPC_BOOK3S_64 
to avoid build issues with 32-bit PPC.

-ritesh

