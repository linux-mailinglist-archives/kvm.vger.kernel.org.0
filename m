Return-Path: <kvm+bounces-48124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DED0AC969B
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 22:33:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 790D93B7C40
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 20:32:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6020280CE5;
	Fri, 30 May 2025 20:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KsXM6Uh0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587271FF5E3
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 20:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748637175; cv=none; b=l0gdEILu2Liaoe/q8KsHBID7IrPteI1PnM8qmAeBaEOElSWL+g9oBGjyJE5pKwgl00de1bf+5rubNNIfLA9hd4tPJwwKhJ23lbyPZdOlIKpyDLFk9YTcFqQDX6oFcfOYls8jR+28DCidge+OfCAeR2uafcJgDSeF407JxjXGfe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748637175; c=relaxed/simple;
	bh=BqxGAPtXQ+w0it+7VSaKvqRRRpiyppxfHM2MLYqFpmo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=feDvClungBeY34i8JRn+NifipiF9U6Fr2FzH94/G21pRwHAedAN2a6J9CUvvxLzFxhbjohDuvU6Pj6KObK/tcdbvZI3aWkqSslF8f1WDQBFbxjdCcj+4Fv6PhPdd963txmWakmNN+mpX1jqr6Wb3ff+f0tkiesiYmLDtNgGqbnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KsXM6Uh0; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7370e73f690so2664168b3a.3
        for <kvm@vger.kernel.org>; Fri, 30 May 2025 13:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748637173; x=1749241973; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TBxCAqZvCNUWY+LzVlwT/+p8q3HcBUeDP2q6ZT5VtpU=;
        b=KsXM6Uh0oKAVYrDuQw7/q9KHm2vCoay/3/BG4dcXP6qY87gcf5v/rkVFGgUHqy+NlB
         Ih1/lGI2PcNVYFqn2wAFoTAAphqT261RNJm1MedMsqpBhEj22WuNZR5F2bWkb84IeCY4
         9zEesHUmUbn7sDery1B25e8+Ync9rtuFFZrtD0DGvtIAtCQb46h8oJsR+dvUuXRkKmGv
         uWe781DCkfBQcHzvbEF/vmcsfUQi7txOIJ8QTeAbrwZiuEhu2WWqtuQ+zg592jcZja7t
         JvVHcaOjhX7NQFtyD1m18OzEYXTFmL1dQRSwdSrCHDRJEFi9rUnjI3iUdbOpVVIguGv8
         nLhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748637173; x=1749241973;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TBxCAqZvCNUWY+LzVlwT/+p8q3HcBUeDP2q6ZT5VtpU=;
        b=SSbFEdkWZTL33uOm1uamjo7S5sLgpRIqD+UO7nwfiJ/rBCpiv+r/lGIYr2fAq/c+Yp
         NvnKGM2+hfc6SApyaPev7dP2SxHBzI/g5bMkcqh3xeEbdsOqsUUwWmq15KwtgFDkb/zK
         pwFgvxCiwW7AXnob/ZI1eMPw9qrmvJoweF7OzUJjH6609tgUQ0TRzWTmHXNiwE06dNH8
         78YqDK3gv6zlxib9NzTWBqJ1D0bZhwPBUoc34uZtXU66A2nCyS1B61RO0VQnlgmjGuQH
         TR9hFpmZHz+8/Gdnl+7RydoAvx/v4u4wRTaxmn7sc2Xid6sv7OeONV+jQJxA/61gitsF
         p3kg==
X-Gm-Message-State: AOJu0YypBrqGQ1xiJoK6BXD+4tQAhgWSiowNvH8+hHBD5FSq1Di2+C3b
	mD21ObCK0BK+TA6EXUjgoYsPIxaRVvCb22lPqsGFAcixICVVLjwI80+/GpaV3ArEJrbhSQVMXbd
	HgMu4M50MLOWMaGkTJS9uSVRFWw==
X-Google-Smtp-Source: AGHT+IHn8Apyh2qJk1ZiWPwI4Xf5KbG4kHs1lrIxOZPs3doTW55CGpIuzttZTAM9OFdmVmjXkdwqHEOcQmlogkipOw==
X-Received: from pfcg2.prod.google.com ([2002:a05:6a00:23c2:b0:746:1931:952a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3d4e:b0:73d:b1ff:c758 with SMTP id d2e1a72fcca58-747bd9e6de8mr6429258b3a.18.1748637173027;
 Fri, 30 May 2025 13:32:53 -0700 (PDT)
Date: Fri, 30 May 2025 13:32:51 -0700
In-Reply-To: <21b9b151-6e4f-47b8-9c6b-73eeb0c20165@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <37f60bbd7d408cf6d421d0582462488262c720ab.1747264138.git.ackerleytng@google.com>
 <21b9b151-6e4f-47b8-9c6b-73eeb0c20165@linux.intel.com>
Message-ID: <diqzplfp6dqk.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH v2 05/51] KVM: guest_memfd: Skip LRU for guest_memfd folios
From: Ackerley Tng <ackerleytng@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org, aik@amd.com, 
	ajones@ventanamicro.com, akpm@linux-foundation.org, amoorthy@google.com, 
	anthony.yznaga@oracle.com, anup@brainfault.org, aou@eecs.berkeley.edu, 
	bfoster@redhat.com, brauner@kernel.org, catalin.marinas@arm.com, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, dave.hansen@intel.com, 
	david@redhat.com, dmatlack@google.com, dwmw@amazon.co.uk, 
	erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, graf@amazon.com, 
	haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, vannapurve@google.com, vbabka@suse.cz, 
	viro@zeniv.linux.org.uk, vkuznets@redhat.com, wei.w.wang@intel.com, 
	will@kernel.org, willy@infradead.org, xiaoyao.li@intel.com, 
	yan.y.zhao@intel.com, yilun.xu@intel.com, yuzenghui@huawei.com, 
	zhiquan1.li@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Binbin Wu <binbin.wu@linux.intel.com> writes:

> On 5/15/2025 7:41 AM, Ackerley Tng wrote:
>> filemap_add_folio(), called from filemap_grab_folio(), adds the folio
>> onto some LRU list, which is not necessary for guest_memfd since
>> guest_memfd folios don't participate in any swapping.
>>
>> This patch reimplements part of filemap_add_folio() to avoid adding
>> allocated guest_memfd folios to the filemap.
>
> filemap -> LRU list?
>

Yes, thank you. Will fix this in the next revision.

>>
>> With shared to private conversions dependent on refcounts, avoiding
>> usage of LRU ensures that LRU lists no longer take any refcounts on
>> guest_memfd folios and significantly reduces the chance of elevated
>> refcounts during conversion.
>>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> Change-Id: Ia2540d9fc132d46219e6e714fd42bc82a62a27fa
>> ---
>>   mm/filemap.c           |  1 +
>>   mm/memcontrol.c        |  2 +
>>   virt/kvm/guest_memfd.c | 91 ++++++++++++++++++++++++++++++++++++++----
>>   3 files changed, 86 insertions(+), 8 deletions(-)
>>
> [...]
>>   /*
>>    * Returns a locked folio on success.  The caller is responsible for
>>    * setting the up-to-date flag before the memory is mapped into the gu=
est.
>> @@ -477,8 +509,46 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, =
struct kvm_memory_slot *slot,
>>    */
>>   static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t i=
ndex)
>>   {
>> +	struct folio *folio;
>> +	gfp_t gfp;
>> +	int ret;
>> +
>> +repeat:
>> +	folio =3D filemap_lock_folio(inode->i_mapping, index);
>> +	if (!IS_ERR(folio))
>> +		return folio;
>> +
>> +	gfp =3D mapping_gfp_mask(inode->i_mapping);
>> +
>>   	/* TODO: Support huge pages. */
>> -	return filemap_grab_folio(inode->i_mapping, index);
>> +	folio =3D filemap_alloc_folio(gfp, 0);
>> +	if (!folio)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	ret =3D mem_cgroup_charge(folio, NULL, gfp);
>> +	if (ret) {
>> +		folio_put(folio);
>> +		return ERR_PTR(ret);
>> +	}
>> +
>> +	ret =3D kvm_gmem_filemap_add_folio(inode->i_mapping, folio, index);
>> +	if (ret) {
>> +		folio_put(folio);
>> +
>> +		/*
>> +		 * There was a race, two threads tried to get a folio indexing
>> +		 * to the same location in the filemap. The losing thread should
>> +		 * free the allocated folio, then lock the folio added to the
>> +		 * filemap by the winning thread.
>
> How about changing
> =E2=80=9Cthen lock the folio added to the filemap by the winning thread=
=E2=80=9D
> to
> "the winning thread locks the folio added to the filemap"?
>

How about:

There was a race. Threads tried to get a folio indexing to the same
location in the filemap. The winning thread allocated and locked the
folio at the requested index. The losing threads should free the extra
allocated folio, then wait to lock the same folio allocated (and locked)
by the winning thread.

>> +		 */
>> +		if (ret =3D=3D -EEXIST)
>> +			goto repeat;
>> +
>> +		return ERR_PTR(ret);
>> +	}
>> +
>> +	__folio_set_locked(folio);
>> +	return folio;
>>   }
>>  =20
>>   static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t s=
tart,
>> @@ -956,23 +1026,28 @@ static int kvm_gmem_error_folio(struct address_sp=
ace *mapping, struct folio *fol
>>   }
>>  =20
>>   #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
>> +static void kvm_gmem_invalidate(struct folio *folio)
>> +{
>> +	kvm_pfn_t pfn =3D folio_pfn(folio);
>> +
>> +	kvm_arch_gmem_invalidate(pfn, pfn + folio_nr_pages(folio));
>> +}
>> +#else
>> +static inline void kvm_gmem_invalidate(struct folio *folio) {}
>
> No need to tag a local static function with "inline".
>

Will fix in the next revision.

>> +#endif
>> +
> [...]

