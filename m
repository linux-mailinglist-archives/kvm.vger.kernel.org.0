Return-Path: <kvm+bounces-44012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D572A9996D
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 22:26:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC3BD3A1303
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 20:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16BE926B96B;
	Wed, 23 Apr 2025 20:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B6KWxEd0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AFD244670
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 20:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745439951; cv=none; b=BvrwM9tP9MJGPLhZJq2vzQZ+gHatZR/35648jsmegJq7GALZLIoFqPueiW9cCAjj36tCk00nE7ulvFKWFBfgECmnkYgj0IBiitZeOFVB3Zv0c6FiJEtTeWUW4arXDO+zTcizRaZcuYxX+WX5QjJzi2ZcJfDe+PD/SNtdL2ix5Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745439951; c=relaxed/simple;
	bh=FVGAb43n+nj0WTaGxkD+7N48DxDKHF+TEMQjE/V8uF4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PmU4qXkvESKWoVngF8NcaxioMDXC617F+b+pdXv4YkXX0kpd7CjfoNFtA+YW1rnF3ubSm/zyOrem374nNVuTiT4lhofw4Lh6aMknMa7kBVgifDxK+/nBgUxIRc8xQfhGn+gZPFm9K2qtErZd0AeQZ9MZZZ0oYCVG4PJUci5Tdiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B6KWxEd0; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736b431ee0dso145277b3a.0
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 13:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745439949; x=1746044749; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CjX2WJaP/+hIZJnKE7ZkAy8ut0H0AnZ+KN3YDGIa+EI=;
        b=B6KWxEd0568908TIWQLQx4k1c+x0CSpZXkE1kYcxVLL81Tt9AN3dr3ltUQGsHM6mmL
         34jEuwT3lO03sF6lEH8EyoEIjz711G+PVcqYO8eqh6o/A2PpqXF3FySQzQGxx41v9Wqr
         yqS806Ds3P/KHbo5eiVSbHOLT4nY1ipeuog0OFyW4De9uwzamEuvQ9Qopbgjwd6qjrrp
         24kNv/QukRbbI9kcg4PBEEnENJRQ0oddSV8CUlmbgv4u+ncGFuFeh25OArs4+PJ3lidk
         UX6aZyAx0WQylgvg6WrqZ6lmaOrpJBfqkxhkI69tiSZRMEP6BHldGEkvesIvb3w6WcdN
         NSBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745439949; x=1746044749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CjX2WJaP/+hIZJnKE7ZkAy8ut0H0AnZ+KN3YDGIa+EI=;
        b=Qk4iYvUT9I53i4wgdF0cE4lvFgcJQryqF+iLGd98vWmMAqzf8rjJvLCfkTWjW172nr
         iNcbMRIHonqk8wPmtENG7mkk5/aNb2J8Ri/56Z2/bbiAmOqf74M/oTIyvhcPBXXn4i/S
         a5NmSaSK803GXrj4RSnql5nwq3VefnA6RGuf6uhYX+8h/9t8ciNugkRU/hi6579hWhSJ
         upO+SoVt+2mwcEVrzKNhN8HvTHQj5sPpVkeMt6LVSDIzzLHj7n9WBuuxMke0Uv8IQtv4
         EAmMI7TSlKipzABmmFlVqyWRZMDadRxKT5EYXl3evxEm+wtVW5VnlBwsTi0cV+dG+b1P
         bdUw==
X-Forwarded-Encrypted: i=1; AJvYcCW6Edrtd9lr50YtJPsDD9dHa2bo7fke/nYB1ve6c162pXaDF3QeOtqSpyC8Mc/IJEIMxaI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfZAZQg5fcdbusg9y7LqhkwKKQR4M9DL5L+6bP3vvXCSuyVB7+
	xRrilouikEu4tHYPksqf9C2ISzqt5COcw9eQEEBaOoLou0t8jTFPmGORr/hRUGjDjyc1JKzVAMv
	i4EcdJqnrGQMWMKLmisPv6Q==
X-Google-Smtp-Source: AGHT+IFLEEtCn1zkdoknKQC40EflQZ5HCAiPFEe4xIPUK0dlv/WJ0C7ai9MKNllw9+iA8ZkUhOs7ih4lNf6hYQC50w==
X-Received: from pfam7.prod.google.com ([2002:aa7:8a07:0:b0:736:ae72:7543])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:c889:b0:1ee:a914:1d64 with SMTP id adf61e73a8af0-2044113e9a5mr1184451637.28.1745439949162;
 Wed, 23 Apr 2025 13:25:49 -0700 (PDT)
Date: Wed, 23 Apr 2025 13:25:47 -0700
In-Reply-To: <Z47RSls2rr-xVqNk@x1n>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1726009989.git.ackerleytng@google.com> <5a05eb947cf7aa21f00b94171ca818cc3d5bdfee.1726009989.git.ackerleytng@google.com>
 <Z47RSls2rr-xVqNk@x1n>
Message-ID: <diqzplh2zktw.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 27/39] KVM: guest_memfd: Allow mmapping guest_memfd files
From: Ackerley Tng <ackerleytng@google.com>
To: Peter Xu <peterx@redhat.com>
Cc: tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk, 
	jgg@nvidia.com, david@redhat.com, rientjes@google.com, fvdl@google.com, 
	jthoughton@google.com, seanjc@google.com, pbonzini@redhat.com, 
	zhiquan1.li@intel.com, fan.du@intel.com, jun.miao@intel.com, 
	isaku.yamahata@intel.com, muchun.song@linux.dev, mike.kravetz@oracle.com, 
	erdemaktas@google.com, vannapurve@google.com, qperret@google.com, 
	jhubbard@nvidia.com, willy@infradead.org, shuah@kernel.org, 
	brauner@kernel.org, bfoster@redhat.com, kent.overstreet@linux.dev, 
	pvorel@suse.cz, rppt@kernel.org, richard.weiyang@gmail.com, 
	anup@brainfault.org, haibo1.xu@intel.com, ajones@ventanamicro.com, 
	vkuznets@redhat.com, maciej.wieczor-retman@intel.com, pgonda@google.com, 
	oliver.upton@linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-fsdevel@kvack.org
Content-Type: text/plain; charset="UTF-8"

Peter Xu <peterx@redhat.com> writes:

> On Tue, Sep 10, 2024 at 11:43:58PM +0000, Ackerley Tng wrote:
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
>> @@ -946,6 +950,9 @@ static void kvm_gmem_hugetlb_teardown(struct inode *inode)
>>  {
>>  	struct kvm_gmem_hugetlb *hgmem;
>>  
>> +	/* TODO: Check if even_cows should be 0 or 1 */
>> +	unmap_mapping_range(inode->i_mapping, 0, LLONG_MAX, 0);
>
> Setting to 0 is ok in both places: even_cows only applies to MAP_PRIVATE,
> which gmemfd doesn't support.  So feel free to drop the two comment lines.
>
> Thanks,
>
> -- 
> Peter Xu

Thank you for reviewing and helping me check on this!

