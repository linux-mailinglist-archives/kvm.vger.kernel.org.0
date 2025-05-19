Return-Path: <kvm+bounces-47004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C0B2ABC52B
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 19:04:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01C9C1B62484
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 17:05:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E708D288506;
	Mon, 19 May 2025 17:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tAP6QcQy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9572F278E42
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 17:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747674289; cv=none; b=Ek2+3SGKfCBgW9zid3BoinJSWshMHABlhpYXQRh0Yh65GHgx4VqlRpt6xjoXeQ3ObILoTpDC6BWwuJaeP32L5vbkm/ovuu+J3Oy6f7+J1jtm9xYhh5IiykrBBJLohKDUE2oAzhSAx02gTpBY3GvlAnQaqsxMXblGsKQCNxk7dZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747674289; c=relaxed/simple;
	bh=01w4XwT5rgnUWhWg7mruXsUD7XvOWhDH57c8K7bFTHk=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=NKGdwmSZZAYBc2/YcdJ7H/tN4SmDFowxzXzHBGDhIZFbsc5Tkg3NwIixBlKWV7t+gGaggoWGAxWWbd0EskbNVr7w2Fv1ynn3jpXZQUg6LQq9zjbZqq1sdnIJugxAQHk6NAPLZlWOhz1r9YASVso88dBQGX/0HHNxGyoSnsWQv9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tAP6QcQy; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74299055c3dso6625266b3a.0
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 10:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747674287; x=1748279087; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Goq4u7JwRNa/mNKgeJWxWxL3A/olzwx0SUya3IskYzo=;
        b=tAP6QcQyorM6ILuTPiWEtFgc55dmE/x61zd0zl8Rr/6nErXk5aTErWRTxxpXl+TRSE
         J12tNE6OYfFw1mb+ku4VvOllKsehlJmluZFzLwhOGHPTc5G1R2htLAgpsBvb3UrpLsR2
         ffOjInJMm040HZ9Hx6KmVDpx7Na9f67xB26CVdcDeyvKDXgckUbHYavdZIN1H3vM7MTQ
         FGT8ZOEEv73w1fmfBDiRVt3JL6MayuHzHji4UqEG8VI4GmgJUO9NpwtWU3pmQetheK5X
         FOwWmI5bSFNd029woHzG3ijz/eDd3+RnI2bqf0uX0wzh3Clmgg160bOE0TIr7uCFITxB
         7Zhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747674287; x=1748279087;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Goq4u7JwRNa/mNKgeJWxWxL3A/olzwx0SUya3IskYzo=;
        b=HtECOanBDUJyhqVNup5oW5DEhHkwn9UUMt/MB6EGXgMusI6JMb1EX5dOXGwtS8SyRn
         I6GijKag5fonmIWEmABS+QvuDAvZ7upnUnHVh/c6tmbMiYF9vKcnlptdeOlAXuAgpD2v
         UJd0kdrUH2EVs1NeaeuhKqJHYTK0zc7yhIG2b1EYHFiVZvzHLNUA/8IQeZ71xrNKwceh
         F1UKiSvKZ259s0o7Fn+WymbIRHPPvSZeYbbJtoisyfTVA4/Bt48rzCiEsTpc4NvwZAfK
         llMDfxuS1APkJqwi0mzFwjA+/1EH3n9sN5GFsFR4H8pBbfr58dMrzbsR2rDL1l7AHAY4
         Y2sQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/qoA1sC6cvAzQ7sTcU5wukDwtuVLCfBR+i0Oui1vX65OJqRjRSGbVZOkpVkMW8IVkprU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3V+pYYh22xYRY3dnsebUnXU/kW1rdeXUQ+TJ43hZw7W6Szsv1
	ZgOtv/U/IfgPM/r1qPtz85Yjv3vF+cBX3Y4S0Om+J9jqBuZypnYl7upKav2+9rpgO7rROZ2+Tqk
	LhEPVfhVBkTCJt5EwIxZO8iVSqA==
X-Google-Smtp-Source: AGHT+IFMPwogMPOLeEVsy9zVVtiGIXpX7XWCAue2qkIgrW2Gtgg1AnNlznNb/LyQz+ITtedo/7pWya9Uw1d88i2rcQ==
X-Received: from pfbbo8.prod.google.com ([2002:a05:6a00:e88:b0:740:b0f1:1ede])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3a14:b0:740:67ce:1d8b with SMTP id d2e1a72fcca58-742a97b7a1bmr20111944b3a.7.1747674286740;
 Mon, 19 May 2025 10:04:46 -0700 (PDT)
Date: Mon, 19 May 2025 10:04:45 -0700
In-Reply-To: <diqzjz7azkmf.fsf@ackerleytng-ctop.c.googlers.com> (message from
 Ackerley Tng on Wed, 23 Apr 2025 13:30:16 -0700)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqz8qmsfs5u.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH 3/5] KVM: gmem: Hold filemap invalidate lock while
 allocating/preparing folios
From: Ackerley Tng <ackerleytng@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: yan.y.zhao@intel.com, michael.roth@amd.com, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	jroedel@suse.de, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	seanjc@google.com, vbabka@suse.cz, amit.shah@amd.com, 
	pratikrajesh.sampat@amd.com, ashish.kalra@amd.com, liam.merwick@oracle.com, 
	david@redhat.com, vannapurve@google.com, quic_eberman@quicinc.com
Content-Type: text/plain; charset="UTF-8"

Ackerley Tng <ackerleytng@google.com> writes:

> Yan Zhao <yan.y.zhao@intel.com> writes:
>
>> On Fri, Mar 14, 2025 at 05:20:21PM +0800, Yan Zhao wrote:
>>> This patch would cause host deadlock when booting up a TDX VM even if huge page
>>> is turned off. I currently reverted this patch. No further debug yet.
>> This is because kvm_gmem_populate() takes filemap invalidation lock, and for
>> TDX, kvm_gmem_populate() further invokes kvm_gmem_get_pfn(), causing deadlock.
>>
>> kvm_gmem_populate
>>   filemap_invalidate_lock
>>   post_populate
>>     tdx_gmem_post_populate
>>       kvm_tdp_map_page
>>        kvm_mmu_do_page_fault
>>          kvm_tdp_page_fault
>> 	   kvm_tdp_mmu_page_fault
>> 	     kvm_mmu_faultin_pfn
>> 	       __kvm_mmu_faultin_pfn
>> 	         kvm_mmu_faultin_pfn_private
>> 		   kvm_gmem_get_pfn
>> 		     filemap_invalidate_lock_shared
>> 	
>> Though, kvm_gmem_populate() is able to take shared filemap invalidation lock,
>> (then no deadlock), lockdep would still warn "Possible unsafe locking scenario:
>> ...DEADLOCK" due to the recursive shared lock, since commit e918188611f0
>> ("locking: More accurate annotations for read_lock()").
>>
>
> Thank you for investigating. This should be fixed in the next revision.
>

This was not fixed in v2 [1], I misunderstood this locking issue.

IIUC kvm_gmem_populate() gets a pfn via __kvm_gmem_get_pfn(), then calls
part of the KVM fault handler to map the pfn into secure EPTs, then
calls the TDX module for the copy+encrypt.

Regarding this lock, seems like KVM'S MMU lock is already held while TDX
does the copy+encrypt. Why must the filemap_invalidate_lock() also be
held throughout the process?

If we don't have to hold the filemap_invalidate_lock() throughout, 

1. Would it be possible to call kvm_gmem_get_pfn() to get the pfn
   instead of calling __kvm_gmem_get_pfn() and managing the lock in a
   loop?

2. Would it be possible to trigger the kvm fault path from
   kvm_gmem_populate() so that we don't rebuild the get_pfn+mapping
   logic and reuse the entire faulting code? That way the
   filemap_invalidate_lock() will only be held while getting a pfn.

[1] https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com/T/

>>> > @@ -819,12 +827,16 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>>> >  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
>>> >  	struct file *file = kvm_gmem_get_file(slot);
>>> >  	int max_order_local;
>>> > +	struct address_space *mapping;
>>> >  	struct folio *folio;
>>> >  	int r = 0;
>>> >  
>>> >  	if (!file)
>>> >  		return -EFAULT;
>>> >  
>>> > +	mapping = file->f_inode->i_mapping;
>>> > +	filemap_invalidate_lock_shared(mapping);
>>> > +
>>> >  	/*
>>> >  	 * The caller might pass a NULL 'max_order', but internally this
>>> >  	 * function needs to be aware of any order limitations set by
>>> > @@ -838,6 +850,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>>> >  	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &max_order_local);
>>> >  	if (IS_ERR(folio)) {
>>> >  		r = PTR_ERR(folio);
>>> > +		filemap_invalidate_unlock_shared(mapping);
>>> >  		goto out;
>>> >  	}
>>> >  
>>> > @@ -845,6 +858,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>>> >  		r = kvm_gmem_prepare_folio(kvm, file, slot, gfn, folio, max_order_local);
>>> >  
>>> >  	folio_unlock(folio);
>>> > +	filemap_invalidate_unlock_shared(mapping);
>>> >  
>>> >  	if (!r)
>>> >  		*page = folio_file_page(folio, index);
>>> > -- 
>>> > 2.25.1
>>> > 
>>> > 


