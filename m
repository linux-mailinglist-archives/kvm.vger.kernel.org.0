Return-Path: <kvm+bounces-44013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 502BFA99973
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 22:28:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 008ED3BFF13
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 20:28:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27F1426D4E1;
	Wed, 23 Apr 2025 20:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BxISFlk9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D84269CEB
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 20:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745440110; cv=none; b=FGTK4m2eIo36SjFCx3AWfFxPJeH81Urs4D0nMNCx9qQ0ZQqds+T3qkiSG7LMvV3et/jclgt/bDC9sPiBIetuNu4f3ZXj81r1QuLCu/Jwf0jewfMB3MhMu9tV8EI3mjGCJuJUdidy9pUbv1FJtlurFB96qo/u84atAlP8gBoAEa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745440110; c=relaxed/simple;
	bh=2RjA3K+20hOlo+w2EtMfB5HnfDnpGVGbjQV0yf7+ROI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=roYhW2M52KId03gxyO1kbmEjZ/CzHFkwSpo/5Ya9V0mv4JOTv9WCY4She4gDB4Y+6H3Uv0mgtxSZEhDh7kmSNMdl4JVGdl4A2blw0UDMZcmLwdIIj/VxdflBSxbbRYQ2jp8X37cAn+ozeCj2k3qAWW2V5LpCFDPPtEKSQIFSlKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BxISFlk9; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b0ae9e87fe2so1042271a12.0
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 13:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745440108; x=1746044908; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ah6zkuRCc/Z7s5oeCTOt9XwXTfn1W/VtyormqwMBFB4=;
        b=BxISFlk998XDIFbFaLcYNxmAuoEIeYq3Z8AVHzfM6nq6bJwV7qcWrzDUMzB67F1vTP
         u8tzA4/42VgDnbJ/Fc1zQx/zcggdRM+0sLt8K6myJU33xE3V79RBgRE5rjlpy0aTaK3G
         Nu0wcXI7MDdWsOeXMYxKdA7ZZqApPiJZgUVhYsnBhRWdcsJDfdhaeU9oBgNKiDYamPvi
         E5PciGTzDRUQp/KUPg/n84EU8hDSQItfNwTKwXycFihatIFIL7r7YTyDWZvAilwVVs8p
         a9Ep8IZmUsiReLuvEZlR7UUCGS+DvS/+pTjpvf9S3HtDe6PlyF9NltxkpAol/hanJYZA
         qG7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745440108; x=1746044908;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ah6zkuRCc/Z7s5oeCTOt9XwXTfn1W/VtyormqwMBFB4=;
        b=JWpRKAW9gOVpdnzZGAw2WtWTXkFxPVDx0jLEhNyqVMA9qIu79UY9RZ1fSXj1rLdkd6
         kI47C5DGhdvuyD084Xe3TuYe0A3xbYU9krV2Nliev4EJDipV1gf9ratyMLnSeHRwjKk2
         W1IDO13ErNB5Pln5uKDJH9po4JCSQ765WMNpeNNyoF9xV66KRwNDDkhX4hkQGaK7izsM
         7ghWNAJtoySUfeFMS39Kx6YFwTen2tMuJwtOl4d32cam/0ZzLHIn2ZkEUIKY7lXUW31j
         n6a8Ctt5Mpuj9q4Damu909TF9hj+GKRIPehc28xlr/gp6KtZdcGJE+SlbCCKGIMaCW2X
         CE/w==
X-Forwarded-Encrypted: i=1; AJvYcCUfl5AsIIiP2/rNcPSt5lP3JD1siB23hKwofuh0o0HftXc8v3eFxvsONqi0rkDKUyIiGxU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRw3gruvNo9v6ogKQQCZR0a9pd+8TBykmesCHvjuct1lyB5jQf
	9Ds4ANaf9NYCc2bYFWKDs8q82XxpLan8hxdXKdfciQrSwU+hGcn6fUl2nZvIvNNOmRvRelRvJbf
	tXJRGUDwJGKRvXoIGIcF++w==
X-Google-Smtp-Source: AGHT+IFiQVdxeBhTsiJOg9dL2jv2xFuiQooZC1rWX975oVPQU0mYN3lKF6SuxLR/yO5H1PbpNGLjnT3cV40FkFG7uQ==
X-Received: from pftb21.prod.google.com ([2002:a05:6a00:2d5:b0:730:7b0c:592c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6d8e:b0:201:8a06:6e3b with SMTP id adf61e73a8af0-204447b1cb0mr161140637.9.1745440107858;
 Wed, 23 Apr 2025 13:28:27 -0700 (PDT)
Date: Wed, 23 Apr 2025 13:28:26 -0700
In-Reply-To: <Z+y4E3tcOCOJxCiS@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1726009989.git.ackerleytng@google.com> <5a05eb947cf7aa21f00b94171ca818cc3d5bdfee.1726009989.git.ackerleytng@google.com>
 <Z+y4E3tcOCOJxCiS@yzhao56-desk.sh.intel.com>
Message-ID: <diqzmsc6zkph.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 27/39] KVM: guest_memfd: Allow mmapping guest_memfd files
From: Ackerley Tng <ackerleytng@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk, 
	jgg@nvidia.com, peterx@redhat.com, david@redhat.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, seanjc@google.com, 
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev, 
	erdemaktas@google.com, vannapurve@google.com, qperret@google.com, 
	jhubbard@nvidia.com, willy@infradead.org, shuah@kernel.org, 
	brauner@kernel.org, bfoster@redhat.com, kent.overstreet@linux.dev, 
	pvorel@suse.cz, rppt@kernel.org, richard.weiyang@gmail.com, 
	anup@brainfault.org, haibo1.xu@intel.com, ajones@ventanamicro.com, 
	vkuznets@redhat.com, maciej.wieczor-retman@intel.com, pgonda@google.com, 
	oliver.upton@linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="UTF-8"

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Tue, Sep 10, 2024 at 11:43:58PM +0000, Ackerley Tng wrote:
>> guest_memfd files can always be mmap()ed to userspace, but
>> faultability is controlled by an attribute on the inode.
>> 
>> Co-developed-by: Fuad Tabba <tabba@google.com>
>> Signed-off-by: Fuad Tabba <tabba@google.com>
>> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> 
>> ---
>>  virt/kvm/guest_memfd.c | 46 ++++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 44 insertions(+), 2 deletions(-)
>> 
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index b603518f7b62..fc2483e35876 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -781,7 +781,8 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>>  {
> Hi Ackerley,
>
> If userspace mmaps a guest_memfd to a VA when a GFN range is shared, it looks
> that even after the GFN range has been successfully converted to private,
> userspace can still call madvise(mem, size, MADV_REMOVE) on the userspace VA.
> This action triggers kvm_gmem_punch_hole() and kvm_gmem_invalidate_begin(),
> which can zap the private GFNs in the EPT.
>
> Is this behavior intended for in-place conversion, and could it potentially lead
> to private GFN ranges being accidentally zapped from the EPT?
>
> Apologies if I missed any related discussions on this topic.

No worries and thank you for your review! The next revision will not be
requiring userspace to do madvise(MADV_REMOVE), because memory could be
mapped in multiple processes, so unmapping from the kernel saves the
trouble of coordination in userspace between multiple processes.

>
> Thanks
> Yan
>
>>  	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
>>  	pgoff_t start = offset >> PAGE_SHIFT;
>> -	pgoff_t end = (offset + len) >> PAGE_SHIFT;
>> +	pgoff_t nr = len >> PAGE_SHIFT;
>> +	pgoff_t end = start + nr;
>>  	struct kvm_gmem *gmem;
>>  
>>  	/*
>> @@ -790,6 +791,9 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>>  	 */
>>  	filemap_invalidate_lock(inode->i_mapping);
>>  
>> +	/* TODO: Check if even_cows should be 0 or 1 */
>> +	unmap_mapping_range(inode->i_mapping, start, len, 0);
>> +
>>  	list_for_each_entry(gmem, gmem_list, entry)
>>  		kvm_gmem_invalidate_begin(gmem, start, end);
>>  

