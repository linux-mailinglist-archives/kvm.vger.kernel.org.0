Return-Path: <kvm+bounces-39356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 775A3A46A3E
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:55:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E8623A5C2F
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F351237700;
	Wed, 26 Feb 2025 18:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WOy+655G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02ADB236A70
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596116; cv=none; b=tw4JCMwr1YGTRjRZe2/1nvCudGQ3mb/fEy/4M96Yz6GSqkFWBbR0YFS+RZuw8tUnQUyd/Wbri7RNdCW2LeHE5lZbfQDG0Ooki5Bpb/0y5TjtnqajUVPeaMCbyqP+nuYZnvogzPf//cEFptZlpVEc0f5m8vEOHPicw8doj+29LOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596116; c=relaxed/simple;
	bh=3oc8qhgJaB+qEvfVeOdFIBZPr+vcrIabY8Hr67IuZWk=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=hlvDPr7y04MathUak270OfzZxeTBxepUj1p2PI3B/RNE1fRfjWvx3yMqgy5tKPQiSBpmW4Hzyke5c8S5Hj4TaQMoSLy4nyAUOPKS3OX2KxudjipklohHknZpNsofdRIRU0sP0GI2zxfuiyo3F2hdmW3BcH1zJUuL8sIyJc/nZdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WOy+655G; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f2a9f056a8so300879a91.2
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 10:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740596114; x=1741200914; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pMxjrmr+C2lqhTDO1AsbIyjKpGntAjw/Nw4lGuuG6FA=;
        b=WOy+655GRlTqbi7xoiyFxeeB56NI2NmesFky22Qwy5WsgXcjOYIa2lwhtrF8FFVw5G
         OqDiIKDRFt+TVOby+Rmu4ylIQYA0/ObHiH4VYEyWqP5sBBOGRWQgWa4fkHzgKmwRMak2
         2d6kWe+bFe6uFZ6t/xafzo7Ycc1qb/UaBl8ihhzOjkeJoz/vHsQ347hd8PQ+uQ1skFxa
         As5tIcdybRRdaTTaGkp2vVOX9UiYVVTilEkyNdbpDN2FWIg4YvR46eDWJewAAIMS5tzF
         ifLnWIBRUBg2RXIsZdOG4orXbqYMCDNm22FpMX4Fn8bChqgkIVM/u7J+Kt9Zz4cdVYaz
         xlow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740596114; x=1741200914;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pMxjrmr+C2lqhTDO1AsbIyjKpGntAjw/Nw4lGuuG6FA=;
        b=DuymcwuzI7ndXsNx5n642hyP+pAzJ4pv4SaBj9uVtMSbptIi5jWvmVYSsm+l6/iBhK
         WjiFoMCTbXUJ2HXqov3BOrTRzIv8aOVMvQSSSSdSZ0KkuhY/VngTav/WUbL0ikRhZi0+
         JMYLb3wJ1X0IEY4r8HKk2N3enzvvQcUNoEhwPwC2L8Wu4tEL+vfqvPQioPgdUYWCE5wy
         UgPbJ+7eL0xC8uUngaCUHW3rGyJNMuLRDizcutDVVtiHqin+Zk2A0l+wIO7a11uTXp/z
         0AMbwGpIYG4gTzWgsZLJqHxI6+c6xb9fAL8DykA3BC46QaRgfmX2ITarHP2XFMipJaND
         nHWA==
X-Forwarded-Encrypted: i=1; AJvYcCWMujsUs6qypjuGVlB1CUaF3Ul2A/jFBhPo54oICw16v0F6QUuzgzpYr34K1bU+UsW3/cA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjQ55C3gA4EKWwZX9bReKL9tNzyyeTEmnPZ2DOTrroW6F12azt
	Djp75/Q1Glheck6DtqImds9gN/khJAQt6R14L0yu3AQA+4xyN+wwJ4ZMFXOeg3xOvwz6Tp9487P
	sfP6nrl6Q2DonKXmIM9QY0w==
X-Google-Smtp-Source: AGHT+IHXoYciUWfZJpCpSwX24N+e+ntqta9etAMpkRTScD6zTBwVRDGyD1SA1Qg0PQJM6OFM5du14J4bw5ZP8rzFVg==
X-Received: from pjbqi7.prod.google.com ([2002:a17:90b:2747:b0:2f5:4762:e778])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:cf8e:b0:2fe:7fea:ca34 with SMTP id 98e67ed59e1d1-2fe7feaca86mr5657943a91.32.1740596114259;
 Wed, 26 Feb 2025 10:55:14 -0800 (PST)
Date: Wed, 26 Feb 2025 18:55:12 +0000
In-Reply-To: <diqz5xle9nwq.fsf@ackerleytng-ctop.c.googlers.com> (message from
 Ackerley Tng on Thu, 13 Feb 2025 09:47:33 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzldtsfsdr.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 14/39] KVM: guest_memfd: hugetlb: initialization and cleanup
From: Ackerley Tng <ackerleytng@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: peterx@redhat.com, tabba@google.com, quic_eberman@quicinc.com, 
	roypat@amazon.co.uk, jgg@nvidia.com, david@redhat.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, seanjc@google.com, 
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev, 
	mike.kravetz@oracle.com, erdemaktas@google.com, vannapurve@google.com, 
	qperret@google.com, jhubbard@nvidia.com, willy@infradead.org, 
	shuah@kernel.org, brauner@kernel.org, bfoster@redhat.com, 
	kent.overstreet@linux.dev, pvorel@suse.cz, rppt@kernel.org, 
	richard.weiyang@gmail.com, anup@brainfault.org, haibo1.xu@intel.com, 
	ajones@ventanamicro.com, vkuznets@redhat.com, maciej.wieczor-retman@intel.com, 
	pgonda@google.com, oliver.upton@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-fsdevel@kvack.org
Content-Type: text/plain; charset="UTF-8"

Ackerley Tng <ackerleytng@google.com> writes:

> Peter Xu <peterx@redhat.com> writes:
>
>> On Tue, Sep 10, 2024 at 11:43:45PM +0000, Ackerley Tng wrote:
>>> +/**
>>> + * Removes folios in range [@lstart, @lend) from page cache of inode, updates
>>> + * inode metadata and hugetlb reservations.
>>> + */
>>> +static void kvm_gmem_hugetlb_truncate_folios_range(struct inode *inode,
>>> +						   loff_t lstart, loff_t lend)
>>> +{
>>> +	struct kvm_gmem_hugetlb *hgmem;
>>> +	struct hstate *h;
>>> +	int gbl_reserve;
>>> +	int num_freed;
>>> +
>>> +	hgmem = kvm_gmem_hgmem(inode);
>>> +	h = hgmem->h;
>>> +
>>> +	num_freed = kvm_gmem_hugetlb_filemap_remove_folios(inode->i_mapping,
>>> +							   h, lstart, lend);
>>> +
>>> +	gbl_reserve = hugepage_subpool_put_pages(hgmem->spool, num_freed);
>>> +	hugetlb_acct_memory(h, -gbl_reserve);
>>
>> I wonder whether this is needed, and whether hugetlb_acct_memory() needs to
>> be exported in the other patch.
>>
>> IIUC subpools manages the global reservation on its own when min_pages is
>> set (which should be gmem's case, where both max/min set to gmem size).
>> That's in hugepage_put_subpool() -> unlock_or_release_subpool().
>>
>
> Thank you for pointing this out! You are right and I will remove
> hugetlb_acct_memory() from here.
>

I looked further at the folio cleanup process in free_huge_folio() and I
realized I should be returning the pages to the subpool via
free_huge_folio(). There should be no call to
hugepage_subpool_put_pages() directly from this truncate function.

To use free_huge_folio() to return the pages to the subpool, I will
clear the restore_reserve flag once guest_memfd allocates a folio. All
the guest_memfd hugetlb folios will always have the restore_reserve flag
cleared.

With the restore_reserve flag cleared, free_huge_folio() will do
hugepage_subpool_put_pages(), and then restore the reservation in hstate
as well.

Returning the folio to the subpool on freeing is important and correct,
since if/when the folio_put() callback is used, the filemap may not hold
the last refcount on the folio, so truncation may not be when the folio
should not be returned to the subpool.

>>> +
>>> +	spin_lock(&inode->i_lock);
>>> +	inode->i_blocks -= blocks_per_huge_page(h) * num_freed;
>>> +	spin_unlock(&inode->i_lock);
>>> +}

