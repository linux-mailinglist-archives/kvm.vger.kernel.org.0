Return-Path: <kvm+bounces-40198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 49AF2A53ECB
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 01:02:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2A4618929BA
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 00:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46B5BC8E0;
	Thu,  6 Mar 2025 00:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RArCYBHJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D98B367
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 00:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741219322; cv=none; b=OZTqisY++clOWmMdQaTR+iOZ83nQltb2GDQixoSVza4PBOjZ8Lo7buSiu9Q4uni7xQ68gbl//69tfXFDpq4aQZ89FxD0cYqkdNhBuB0zMmD0Y4YbPvxsHVZWW/5NAqKjg2VqEGQ66giPehiRn9y77azop5IRgpjUEayeFHa442A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741219322; c=relaxed/simple;
	bh=qJemjvKpicpp1fb2vOExLOIaNYkqsEKWLsn7chUtgG0=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=AY+zJoS/WFaV0kihXcO74MEypepXzSVQf/5lMZa5+32HQfI/IT1koeG7Tnr96GCP8oRit5SqVveRXW/In6iaoRF8Cs2Tx8mdTXo7BF7IcBxSm9Wl9qh/h2zVbH9oj6svEFv6ZqDs5ez+/HV99Xw3Vj3YRc5q5xXc0xKxSk7VXQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RArCYBHJ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-223725a1e76so933955ad.0
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 16:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741219319; x=1741824119; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=56oJ12Bp4zx+P97DlMZ4Tn8DtYif33Fhe6HEZDkqc4g=;
        b=RArCYBHJ9d/hR2hV1ZoL5oU38v+KezhgdtQb8mD7lUwe0svHH29e4x8GwegCIovWtV
         dsQABuYDVj4G4FkluMEG9ExfVx7u6xNbaEfPpIJDGmvQ3T++oeO8WiynnV+q0l+ucCEG
         3EnLH/Y9wQlxg2HtflKUjgcn61rgtDOWP9u+htDSIEvqvolEoJupMHG8gCPciJbOpJwV
         CxaFcYJKgb7xqZDz0WS0A2k8PieR+ixs8zHeQWreIhnpzAhcL4T+r/la91Dq3UlQzVdn
         NxcQ8/cjFa3yA1GoUD7xAw9iZLUGiUfDW1dEubo0rbGQMq2PxdenWONtVWe4gcgpsYX6
         i5NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741219319; x=1741824119;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=56oJ12Bp4zx+P97DlMZ4Tn8DtYif33Fhe6HEZDkqc4g=;
        b=KBs+C6GHmSB+HhJoatVaEH/vJdMBkml2/Fm7HoCsWH3MZoTYCqEblx0LQ94xFXQmh1
         ict52H5TPkrw8zV/TpM/eXJKlIee9R/uDoJqi9yn91r71Zjwz79bQsVT9umVM1zpLBUW
         R9JQBKg5a1J8gwy5KyOmeQVSCr3j1jXDh8MYZa31Dv9deduaR8OKY265Q8UA6VB/XvU6
         8qFOvcHZSCcjAWDzWzv9TORgsd4hWcHEpt7WHx3wlbrYdBJaVjCbGahel6lSFPFuX+4h
         obaBebCFWAP0a+CUaAR2uB5G1W083e+G8WDyDT/wchBEaop3Izfd/LdfdD4kqbqsIPGo
         omeg==
X-Gm-Message-State: AOJu0YzoPyuMXFNNuF6rz10NB/a782O78phIFMuFe5IWoMHTi4sfeLV1
	Yi1zN4g2Wx8NwOGfq0x7wtGD0i2mEKGUOIXqyDmWWrM42NlRGyX1FpCbvkB6NPtlGzLeARPBSB2
	/jIC9jHZDeSPrwr78Jq89XA==
X-Google-Smtp-Source: AGHT+IEjpOP/Wjl0soyGnkaTnhki4yqOQAJMvMYNKzU+1gICchyohzEwQvzUEmiM/rlr5qBvpAcs/G+6lcFLOH+FSQ==
X-Received: from plbmq6.prod.google.com ([2002:a17:902:fd46:b0:220:ddee:5ee])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d50a:b0:224:1001:6787 with SMTP id d9443c01a7336-22410016aaamr1718525ad.4.1741219319186;
 Wed, 05 Mar 2025 16:01:59 -0800 (PST)
Date: Thu, 06 Mar 2025 00:01:57 +0000
In-Reply-To: <20250303171013.3548775-4-tabba@google.com> (message from Fuad
 Tabba on Mon,  3 Mar 2025 17:10:07 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzr03bt4ay.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v5 3/9] KVM: guest_memfd: Allow host to map guest_memfd() pages
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

> <snip>
>
> +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> +{
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	struct folio *folio;
> +	vm_fault_t ret = VM_FAULT_LOCKED;
> +
> +	filemap_invalidate_lock_shared(inode->i_mapping);
> +
> +	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +	if (IS_ERR(folio)) {
> +		switch (PTR_ERR(folio)) {
> +		case -EAGAIN:
> +			ret = VM_FAULT_RETRY;
> +			break;
> +		case -ENOMEM:
> +			ret = VM_FAULT_OOM;
> +			break;
> +		default:
> +			ret = VM_FAULT_SIGBUS;
> +			break;
> +		}
> +		goto out_filemap;
> +	}
> +
> +	if (folio_test_hwpoison(folio)) {
> +		ret = VM_FAULT_HWPOISON;
> +		goto out_folio;
> +	}
> +
> +	/* Must be called with folio lock held, i.e., after kvm_gmem_get_folio() */
> +	if (!kvm_gmem_offset_is_shared(vmf->vma->vm_file, vmf->pgoff)) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out_folio;
> +	}
> +
> +	/*
> +	 * Only private folios are marked as "guestmem" so far, and we never
> +	 * expect private folios at this point.
> +	 */

I think this is not quite accurate.

Based on my understanding and kvm_gmem_handle_folio_put() in this other
patch [1], only pages *in transition* from shared to private state are
marked "guestmem", although it is true that no private folios or folios
marked guestmem are expected here.

> +	if (WARN_ON_ONCE(folio_test_guestmem(folio)))  {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out_folio;
> +	}
> +
> +	/* No support for huge pages. */
> +	if (WARN_ON_ONCE(folio_test_large(folio))) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out_folio;
> +	}
> +
> +	if (!folio_test_uptodate(folio)) {
> +		clear_highpage(folio_page(folio, 0));
> +		kvm_gmem_mark_prepared(folio);
> +	}
> +
> +	vmf->page = folio_file_page(folio, vmf->pgoff);
> +
> +out_folio:
> +	if (ret != VM_FAULT_LOCKED) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}
> +
> +out_filemap:
> +	filemap_invalidate_unlock_shared(inode->i_mapping);
> +
> +	return ret;
> +}
>
> <snip>

[1] https://lore.kernel.org/all/20250117163001.2326672-7-tabba@google.com/

