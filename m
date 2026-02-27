Return-Path: <kvm+bounces-72138-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KO/oJ8RyoWkPtQQAu9opvQ
	(envelope-from <kvm+bounces-72138-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 11:32:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 06D271B604F
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 11:32:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E337530514B4
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 10:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BF94395274;
	Fri, 27 Feb 2026 10:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GupWZKbh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7635F38F24D
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 10:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772188334; cv=none; b=l1OcicFB8aUi7vUDUZo3BsyVon6VCLDlCRCGRdtGYlgqI5YDYDiqrg9HO4iXL1am9tcTBj7kbjbpclZj1oqkNzv/qMMoMZpiEl51NrkUXXMyIvTojbY+8aPF3y8pmBnE2eQ0aWeEe1aui1XDGAYTkxKIpgLIc5XiZN+9msvSyxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772188334; c=relaxed/simple;
	bh=bbOe/GfMU2fCLJ9kswN1atfFqEWPs7QDcdUvH+JI4cc=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-version:Content-type; b=RVDwVxCYkJnc7gDreyMrIjGieCyqsOCgMeNTcgfy/UZYf1Dq2gYV60JF2SHjt5fgBLiN5T3mMpehleelq8pnQutFkgDJrlgpSV1pIZ2LbSGTGHdk/L11se9Nl+NxX+byLLYxrLlxbyfpiYvq+P0SExPqWpkB98e/koUrtorR49A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GupWZKbh; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3590c295150so714062a91.1
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 02:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772188333; x=1772793133; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LT1HXP6ImCtKkrDGFwhhoLVXorV0oXPyJhBSmf51vOA=;
        b=GupWZKbhK2ZICHYLy0iFLAHzaBl8Xe/NgnnfKqIWd1x3Qr0gJ9yFsIhCXcVwkjek7v
         VdVpL2QRGNa9BeT2o4Lst27XgtNAjL5+cq6qaxtV9VzH1hyZfLbsc/bORLUEbMzs0axS
         IDwVzTFZqIQrtFaTiUWZ3yC4TcOMUfbhlJ9o4Q7Lm/PhO5KOKZODAO/RyEaWrKzz2ROV
         bXvaVhqv7PEPq8lnhM5uoVwg9THOsg/rLpFaEXeoLp5oH9JhO9i1EoB2dgWjrfsLVtbc
         sswdADC2qvf6od2Iyd7GDBHe9SqgilfUVCYFbFugYrXmvFul8pf+x5nHr+Ehoq+QhCzL
         0y7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772188333; x=1772793133;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LT1HXP6ImCtKkrDGFwhhoLVXorV0oXPyJhBSmf51vOA=;
        b=DVrqioH+/HkjZh5tLKBxhKszj7OJ6Ib+DR1ANMjgRYmr93fpfyXsMj+HqG0OI1jSgd
         XMRqDsN6yp1tCF/zVPY63m7LNFGAIWnnfDW2errObrHa9aWkRDl/9GVwsV62L76GP8+c
         B1wjonjGyHCt35N2LsAkSE5irs2MkNmJsEDgyE1kVYeqzW+vCazkcOYkFcVkl7LiA6DY
         zIcCRmYDh6dA8cwuPAjcJULdj4EdHWDmncc7Wu2xN186Jq9fQ3h69TIKzT5/BO4LZv5u
         WTdm+SYj3Ey7FI8iDUgCTVqjAXL7UJELdmc0i0sy+BL5lJpDa/4a9iaV/MpWQ5FgYS+k
         kQ2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWJWPS/PIuKfhK8ws0Zv+2g2ojOYmqxFM5qtzDuhE30R9ZVnb/4FE2oxLPjn/xPty70jiI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmE1RSHh060vzZym+DRj2uydyO3RkYdUOOUIuwOtDg7DPsr4YS
	Yx3mNA/r80W2dGb/Z3R43qwzLF/edoiSVAC0ouCb60HbFGq7J087wXFl
X-Gm-Gg: ATEYQzzOYHkV2j7rj1qs1Kg7iTwlteNDODhmNl4e5tHn6sa0kmu0dti3Z8nOefYgPbp
	ymocW6SLw0XhCW4FEDRBmTWPQLjEJDzNz+ZY9GKKy6LnL00OOsBG/oz+mC67sKunxDhxldMOWRx
	nYWSzuJ6RTEs6IzLFyxR23qk3UINVuX6+lZ2eMRVa/uDr9Mg4gX82MeFk8c3Jepfrft+4aQZEt/
	45xZaoecqv6PpCGUqZEU+02Kb9fZq06nLwa/fKHp8rcxZLGB/XGm3h6Gwo0M5ao2PIQPeQJBigq
	HpqS2W7P4QYLZ7dV935tmakyMTktefLbIwovWEGCjbWWtcNU5+DSwpJAJd45kdnSqOmflawIVJC
	mtJ+zIID+MFsgmuMixNwFhawXYSRyiYZwK8Z8gEQ/S/TAdSb7/tfTlOrp8Iow3Koh5/tmvNJRFE
	dpD18Y1VCxpphf28G+tA==
X-Received: by 2002:a17:90b:2884:b0:356:4ea0:e9e2 with SMTP id 98e67ed59e1d1-35965d074afmr2219544a91.34.1772188332691;
        Fri, 27 Feb 2026 02:32:12 -0800 (PST)
Received: from dw-tp ([203.81.240.187])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359134a0a2asm3170713a91.14.2026.02.27.02.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 02:32:11 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org, kvm@vger.kernel.org, Alex Williamson <alex@shazbot.org>, Peter Xu <peterx@redhat.com>
Subject: Re: [RFC v1 1/2] drivers/vfio_pci_core: Change PXD_ORDER check from switch case to if/else block
In-Reply-To: <a864b2ed-1a77-4aac-b0e8-d97b4bf8be47@kernel.org>
Date: Fri, 27 Feb 2026 16:00:54 +0530
Message-ID: <87qzq6h40x.ritesh.list@gmail.com>
References: <0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list@gmail.com> <a864b2ed-1a77-4aac-b0e8-d97b4bf8be47@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-72138-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[riteshlist@gmail.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 06D271B604F
X-Rspamd-Action: no action

"Christophe Leroy (CS GROUP)" <chleroy@kernel.org> writes:

> Le 27/02/2026 à 07:16, Ritesh Harjani (IBM) a écrit :
>> Architectures like PowerPC uses runtime defined values for
>> PMD_ORDER/PUD_ORDER. This is because it can use either RADIX or HASH MMU
>> at runtime using kernel cmdline. So the pXd_index_size is not known at
>> compile time. Without this fix, when we add huge pfn support on powerpc
>> in the next patch, vfio_pci_core driver compilation can fail with the
>> following errors.
>> 
>>    CC [M]  drivers/vfio/vfio_main.o
>>    CC [M]  drivers/vfio/group.o
>>    CC [M]  drivers/vfio/container.o
>>    CC [M]  drivers/vfio/virqfd.o
>>    CC [M]  drivers/vfio/vfio_iommu_spapr_tce.o
>>    CC [M]  drivers/vfio/pci/vfio_pci_core.o
>>    CC [M]  drivers/vfio/pci/vfio_pci_intrs.o
>>    CC [M]  drivers/vfio/pci/vfio_pci_rdwr.o
>>    CC [M]  drivers/vfio/pci/vfio_pci_config.o
>>    CC [M]  drivers/vfio/pci/vfio_pci.o
>>    AR      kernel/built-in.a
>> ../drivers/vfio/pci/vfio_pci_core.c: In function ‘vfio_pci_vmf_insert_pfn’:
>> ../drivers/vfio/pci/vfio_pci_core.c:1678:9: error: case label does not reduce to an integer constant
>>   1678 |         case PMD_ORDER:
>>        |         ^~~~
>> ../drivers/vfio/pci/vfio_pci_core.c:1682:9: error: case label does not reduce to an integer constant
>>   1682 |         case PUD_ORDER:
>>        |         ^~~~
>> make[6]: *** [../scripts/Makefile.build:289: drivers/vfio/pci/vfio_pci_core.o] Error 1
>> make[6]: *** Waiting for unfinished jobs....
>> make[5]: *** [../scripts/Makefile.build:546: drivers/vfio/pci] Error 2
>> make[5]: *** Waiting for unfinished jobs....
>> make[4]: *** [../scripts/Makefile.build:546: drivers/vfio] Error 2
>> make[3]: *** [../scripts/Makefile.build:546: drivers] Error 2
>> 
>> Fixes: f9e54c3a2f5b7 ("vfio/pci: implement huge_fault support")
>> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>> ---
>>   drivers/vfio/pci/vfio_pci_core.c | 15 +++++++--------
>>   1 file changed, 7 insertions(+), 8 deletions(-)
>> 
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index d43745fe4c84..5395a6f30904 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -1670,21 +1670,20 @@ vm_fault_t vfio_pci_vmf_insert_pfn(struct vfio_pci_core_device *vdev,
>>   	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
>>   		return VM_FAULT_SIGBUS;
>> 
>> -	switch (order) {
>> -	case 0:
>> +	if (order == 0) {
>>   		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
>> +	}
>
> Those braces are unneeded as all legs of the if/else are single lines
>
>>   #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
>
> ifdef could be replaced by IS_ENABLED() because PxD_ORDER and 
> vmf_insert_pfn_xxx() are declared all the time
>
>> -	case PMD_ORDER:
>> +	 else if (order == PMD_ORDER) {
>
> 'else' is not needed because every 'if' leads to a return statement
>
>>   		return vmf_insert_pfn_pmd(vmf, pfn, false);
>> +	 }
>>   #endif
>>   #ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
>> -	case PUD_ORDER:
>> +	 else if (order == PUD_ORDER) {
>>   		return vmf_insert_pfn_pud(vmf, pfn, false);
>> -		break;
>> +	 }
>>   #endif
>> -	default:
>> -		return VM_FAULT_FALLBACK;
>> -	}
>> +	return VM_FAULT_FALLBACK;
>
> So at the end we should get something like:
>
> 	if (!order)
> 		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
>
> 	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && order == PMD_ORDER)
> 		return vmf_insert_pfn_pmd(vmf, pfn, false);
>
> 	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && order == PMD_ORDER)
                                                                ^^^ PUD_ORDER

> 		return vmf_insert_pfn_pud(vmf, pfn, false);
>
> 	return VM_FAULT_FALLBACK;
>
>

Looks a lot cleaner. Thanks!
I will make that change in v2.

-ritesh

