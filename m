Return-Path: <kvm+bounces-59752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AFCEABCB43C
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 02:21:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63D383C60C6
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 00:21:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 313A91B142D;
	Fri, 10 Oct 2025 00:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MqFizPv3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE71635950
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 00:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760055668; cv=none; b=mn94LFaUvOiEtdGVbP59wIyNKMrQaYMqBc6A+lHW9zsap90qZuwNrsw293pqiIohMbHdKR12P4plNs9aPScgOBGlkTnWsbGbPAe2W1LOvZXmW0TVuK5+tgCxCAUH3viCBgtx1PV7GQalXuVsWhRnW5y6CgOpR61tVs0ijt4F9Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760055668; c=relaxed/simple;
	bh=KMt095iiyuBP1knvWX8UoQHqOWM6llfPWYLTHZZQfig=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=XIB6EOx5ZyFVA7eSoX9Dko2grXiIJ+19rW5o+9yIAQ49wRUc7HKuQdpfy3x5iYPVLdbBEc3ufOhCPRC1ZeZ8F1Xcnjq0oUlEG+ElPgLu3owLrDd10lOKuAdKnPjfoggSRZvtK63f09x5nPkap9i25K/gQI68XNhaRuR8NVefldE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MqFizPv3; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-335276a711cso3873067a91.2
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 17:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760055666; x=1760660466; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8J/T8vKLOgBLYKJ9qjPmAcztyaV4J8sITP6618B36dM=;
        b=MqFizPv31fuBqet0o9RFcElHN+hxbzluCZ1KgXH71eFsReZCbGfFY8gCDaWT3I/7A4
         ziRbmIEhccD/xMEpBrTXy8EwEKH4tK2FZx5vY76TIuiqvZrOcXIQVTwWE23QJwjryrxu
         sF1sl/QGUBBkFm3MnC8Kdm1UMAFU8e+38PBCiaMvj3Cu8RD6E8ib6XlPNc/mq4Yex2Wl
         P/WYcbrTbsI2M+nfGYu38Cv5nDb05L0EUqLXkY16mOu0gWQy/yvPXThmVZ93A1ne/iRw
         grTBfwaCmNu91rtak0epvEqjhT9v/LH5XVwXhcVZ4kLq/yCsNBGUXX89LFZp2GQwD1xw
         LDaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760055666; x=1760660466;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8J/T8vKLOgBLYKJ9qjPmAcztyaV4J8sITP6618B36dM=;
        b=Jb9vDF4GSt4dx0isVp+rNf1aEYYbQUaYKDdCTgeUZ3lwZOxv6FbSixksTaiLtySXCI
         Oj1psFb7fB4jIBJJE1bsMk4Zlcat6MXYhii+UUHoqWHYiFJh6nqIPn3Qzvmon6WOqWl/
         tlq+kifzdF6Kj8Ka11IEp/EsWiPLswuK5egQ07bPwC0+jOOAAWAUTsrx0mSi5V+lF0lr
         NGPfidbqCExgYrd0nL6SGwDigLGcwF1Esv5Vuu5CHRVsaLGrg/Jkt/ZvCaW6dp0ttH3V
         vxWpfvVaePaD6SPYBS0A9KzYKqk/yu/sfJTdK72y23VngVpxQbZKVdu8FJkj80nSB29K
         fvuA==
X-Forwarded-Encrypted: i=1; AJvYcCWMNBEm2cTnjTGbiwasf7rt2Qg2/W8WtDetr7i5q60GCnuiUoCdgDqtQeLAkW2+0cFN0Qw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJSsSZI5/Rm1oIB+xED5eABQq2/82O+90tE3wt4n4kQTTJzqx0
	55ySzVOE1sesooX2mQ5h6Cimd+++pEE912LVCN5b+XW8+WY8V4FeiAgQnYLU4HvzXiN+sEy9n0O
	G+InUUaEseYNMBBauRlyjxBr74w==
X-Google-Smtp-Source: AGHT+IFCF4kBFT0RabFawshnZQQD13nsDTauZ920Dv/bvVdtd5JRE7f5nr5M5m5TgY/YQczN9wLa+pjeYwjxb5YA8A==
X-Received: from pjbta16.prod.google.com ([2002:a17:90b:4ed0:b0:339:dc34:fa49])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:17c2:b0:327:734a:ae7a with SMTP id 98e67ed59e1d1-33b5114ac35mr14074248a91.11.1760055666058;
 Thu, 09 Oct 2025 17:21:06 -0700 (PDT)
Date: Thu, 09 Oct 2025 17:21:04 -0700
In-Reply-To: <20251007222356.348349-1-seanjc@google.com> (message from Sean
 Christopherson on Tue,  7 Oct 2025 15:23:56 -0700)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqz7bx3haj3.fsf@google.com>
Subject: Re: [PATCH] KVM: guest_memfd: Define a CLASS to get+put guest_memfd
 file from a memslot
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	seanjc@google.com
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Add a CLASS to handle getting and putting a guest_memfd file given a
> memslot to reduce the amount of related boilerplate, and more importantly
> to minimize the chances of forgetting to put the file (thankfully the bug
> that prompted this didn't escape initial testing).
>
> Define a CLASS instead of using __free(fput) as _free() comes with subtle
> caveats related to FILO ordering (objects are freed in the order in which
> they are declared), and the recommended solution/workaround (declare file
> pointers exactly when they are initialized) is visually jarring relative
> to KVM's (and the kernel's) overall strict adherence to not mixing
> declarations and code.

This is kind of dangerous, glad you highlighted this!

> E.g. the use in kvm_gmem_populate() would be:
>
> 	slot = gfn_to_memslot(kvm, start_gfn);
> 	if (!kvm_slot_has_gmem(slot))
> 		return -EINVAL;
>
> 	struct file *file __free(fput) = kvm_gmem_get_file(slot;
> 	if (!file)
> 		return -EFAULT;
>
> 	filemap_invalidate_lock(file->f_mapping);
>
> Note, using CLASS() still declares variables in the middle of code, but
> the syntactic sugar obfuscates the declaration, i.e. hides the anomaly to
> a large extent.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>



> ---
>  virt/kvm/guest_memfd.c | 22 ++++++++--------------
>  1 file changed, 8 insertions(+), 14 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 94bafd6c558c..130244e46326 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -307,6 +307,9 @@ static inline struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot)
>  	return get_file_active(&slot->gmem.file);
>  }
>  
> +DEFINE_CLASS(gmem_get_file, struct file *, if (_T) fput(_T),
> +	     kvm_gmem_get_file(slot), struct kvm_memory_slot *slot);
> +
>  static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>  {
>  	return gfn - slot->base_gfn + slot->gmem.pgoff;
> @@ -605,13 +608,12 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
>  	unsigned long start = slot->gmem.pgoff;
>  	unsigned long end = start + slot->npages;
>  	struct kvm_gmem *gmem;
> -	struct file *file;
>  
>  	/*
>  	 * Nothing to do if the underlying file was already closed (or is being
>  	 * closed right now), kvm_gmem_release() invalidates all bindings.
>  	 */
> -	file = kvm_gmem_get_file(slot);
> +	CLASS(gmem_get_file, file)(slot);
>  	if (!file)
>  		return;
>  
> @@ -626,8 +628,6 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
>  	 */
>  	WRITE_ONCE(slot->gmem.file, NULL);
>  	filemap_invalidate_unlock(file->f_mapping);
> -
> -	fput(file);
>  }
>  
>  /* Returns a locked folio on success.  */
> @@ -674,19 +674,17 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  		     int *max_order)
>  {
>  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
> -	struct file *file = kvm_gmem_get_file(slot);
>  	struct folio *folio;
>  	bool is_prepared = false;
>  	int r = 0;
>  
> +	CLASS(gmem_get_file, file)(slot);
>  	if (!file)
>  		return -EFAULT;
>  
>  	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
> -	if (IS_ERR(folio)) {
> -		r = PTR_ERR(folio);
> -		goto out;
> -	}
> +	if (IS_ERR(folio))
> +		return PTR_ERR(folio);
>  
>  	if (!is_prepared)
>  		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> @@ -698,8 +696,6 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	else
>  		folio_put(folio);
>  
> -out:
> -	fput(file);
>  	return r;
>  }
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
> @@ -708,7 +704,6 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
>  long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
>  		       kvm_gmem_populate_cb post_populate, void *opaque)
>  {
> -	struct file *file;
>  	struct kvm_memory_slot *slot;
>  	void __user *p;
>  
> @@ -724,7 +719,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  	if (!kvm_slot_has_gmem(slot))
>  		return -EINVAL;
>  
> -	file = kvm_gmem_get_file(slot);
> +	CLASS(gmem_get_file, file)(slot);
>  	if (!file)
>  		return -EFAULT;
>  
> @@ -782,7 +777,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  
>  	filemap_invalidate_unlock(file->f_mapping);
>  
> -	fput(file);
>  	return ret && !i ? ret : i;
>  }
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_populate);
>
> base-commit: 6b36119b94d0b2bb8cea9d512017efafd461d6ac

