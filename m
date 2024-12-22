Return-Path: <kvm+bounces-34298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A8D59FA793
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 19:39:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89D52165643
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 18:39:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82373190692;
	Sun, 22 Dec 2024 18:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gW9g+Etl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A49E2A8D0
	for <kvm@vger.kernel.org>; Sun, 22 Dec 2024 18:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734892733; cv=none; b=MtLfPbnM166ejf+n1dUv1odCj2tPtnytoar7nbfA0Q3tdChbirbl7sYaD+644i4BT3tJ+u0oY0peCgG5HgtbUcKnjmtqlSzBT7rmQRgsG/9q6DP91zu7ToRCOeWM0VnLlh/95sWSSopMv42Kup8ugUXRGp1VKSxnNHgqig3KQ2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734892733; c=relaxed/simple;
	bh=v9FQexJJ6dhesEEy466xzhcQHuZM99J6jZPzU/bjBv0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kEfaToGUo0tafcHg+A64JnXxATH0tqr0d4Q+czgBWHcJBPNNwTIL43VCKkExLXgGu59W5CG+QGyY6G+HYraIqLfX8nUVs7nH7KQc6Otusk8ggd4e56uAmg7OFX2hIbDtBIAk91sHxllcyFnBnGdBQkdZ7uKwHr+f4HFsiu0FhwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gW9g+Etl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734892730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GUgoQF8YaEpwSFCSJBrpvmUzJo+dN+Sbg4AfPzxi2zU=;
	b=gW9g+EtlbIilfRLdt/7EsSrY+t72r15p3Or5hWXEQyYpbXa7oAQT+qyTxgsAZ0VV5KYlVe
	ngON0OM/8spHheCeWOJXYVkx7kN3JaMsnpB4bcZYgnUcrmba84rlZC3Nw3FX4ePe8Nls9Q
	krmERZXAUZgg2E/oO+BLgHiI7pJyOIo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-TYmPzX2LP-m5SWz19cgc7Q-1; Sun, 22 Dec 2024 13:38:48 -0500
X-MC-Unique: TYmPzX2LP-m5SWz19cgc7Q-1
X-Mimecast-MFC-AGG-ID: TYmPzX2LP-m5SWz19cgc7Q
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4361ecebc5bso20178165e9.1
        for <kvm@vger.kernel.org>; Sun, 22 Dec 2024 10:38:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734892727; x=1735497527;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GUgoQF8YaEpwSFCSJBrpvmUzJo+dN+Sbg4AfPzxi2zU=;
        b=tLOB4L+fA1qL0Xbl0mTr/7ueju+S+oebTE73oTxzxFX28+I/YeuigaqhYN2UeN41Qa
         27Z0UBj2TK+WvJaJwhu8oi8t3IxwdghbbD4IuUiRPgEUTA1LwWU00kX1wI522j5XXr2i
         bqhS22WqhqYLBFf2wkk8cSyiX+0uc0ewflVJ8Nk3wHwGFBVX2gC8W4gE748z8L62Bnwx
         bmI7gobh8kcBdHRKk+wDxnyq3yytC03J5YXZ9WQX6bjKJoqrnaCMU5DF28VnClTh1IVS
         B6+0GUU1oHtJoY7mwpYlJNKTV/4hdDb4nWkFb35f0NsrTMMGSvaBV2LPkLMoRhXVWhfJ
         QqrA==
X-Forwarded-Encrypted: i=1; AJvYcCX/sFBAcVYkkJQDjjWg1L433DZ4CyHKSak3ijhPGnhgio92mM2RLxAyZVmAJaqY3MMpZos=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNKYQKf4IU4lxnknRWcSZt8MnpnRFc9zDqpW/ViJp84i4h3lD/
	Uvyf58c7xRfanrZ75hRyiZP5AZKHttEGMkP91V1rMLZYemQfBmHoYmqiH8zU62nxO0Ndv9hn/xo
	9d0qZlH4fKnNotwvQG09CdP8D0hSxnDw2sQ9g8IJdEm+dNfu7Pg==
X-Gm-Gg: ASbGncsZK6o7xhK+lgiTBiKf+JL26eHaSmCrbKr5WgoZWvwXTBL6ynDHu0rXmh5774k
	ZCyrFVP9JMQfqmA/YSvi/OhHTq1NZs89PMPYh8quhLTSIfqv/Z3Dk3zlWulyEpFb4AyE81aBG6b
	AMwomIAnJEWC7Zugxj2R9bhDhVNyCNFQlQn/TISAOfaUflInxrauHWIxk5/yBgxhe0m1EtVFPy6
	+gbbNQH37qA4uqktkJSeXxqj6MynGqeW2AIaowC/c/JN9BjSwBUDRLN4z0=
X-Received: by 2002:a05:600c:1987:b0:434:fbcd:1382 with SMTP id 5b1f17b1804b1-43668643a39mr81989935e9.11.1734892727388;
        Sun, 22 Dec 2024 10:38:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGUev8wBn8Ebbg3FuEVUJnwgBENGennmDaas7vkVamc8OvbvDw6fTwov4Z/wt7uETa9TEixSA==
X-Received: by 2002:a05:600c:1987:b0:434:fbcd:1382 with SMTP id 5b1f17b1804b1-43668643a39mr81989805e9.11.1734892727031;
        Sun, 22 Dec 2024 10:38:47 -0800 (PST)
Received: from [192.168.10.3] ([151.81.118.45])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38a1c828989sm9494805f8f.18.2024.12.22.10.38.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Dec 2024 10:38:46 -0800 (PST)
Message-ID: <fc22436b-6053-47d0-8329-d75cd748ea61@redhat.com>
Date: Sun, 22 Dec 2024 19:38:44 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: guest_memfd: Remove RCU-protected attribute from
 slot->gmem.file
To: Yan Zhao <yan.y.zhao@intel.com>, seanjc@google.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20241104084137.29855-1-yan.y.zhao@intel.com>
 <20241104084303.29909-1-yan.y.zhao@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241104084303.29909-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 09:43, Yan Zhao wrote:
> Remove the RCU-protected attribute from slot->gmem.file. No need to use RCU
> primitives rcu_assign_pointer()/synchronize_rcu() to update this pointer.
> 
> - slot->gmem.file is updated in 3 places:
>    kvm_gmem_bind(), kvm_gmem_unbind(), kvm_gmem_release().
>    All of them are protected by kvm->slots_lock.
> 
> - slot->gmem.file is read in 2 paths:
>    (1) kvm_gmem_populate
>          kvm_gmem_get_file
>          __kvm_gmem_get_pfn
> 
>    (2) kvm_gmem_get_pfn
>           kvm_gmem_get_file
>           __kvm_gmem_get_pfn
> 
>    Path (1) kvm_gmem_populate() requires holding kvm->slots_lock, so
>    slot->gmem.file is protected by the kvm->slots_lock in this path.
> 
>    Path (2) kvm_gmem_get_pfn() does not require holding kvm->slots_lock.
>    However, it's also not guarded by rcu_read_lock() and rcu_read_unlock().
>    So synchronize_rcu() in kvm_gmem_unbind()/kvm_gmem_release() actually
>    will not wait for the readers in kvm_gmem_get_pfn() due to lack of RCU
>    read-side critical section.
> 
>    The path (2) kvm_gmem_get_pfn() is safe without RCU protection because:
>    a) kvm_gmem_bind() is called on a new memslot, before the memslot is
>       visible to kvm_gmem_get_pfn().
>    b) kvm->srcu ensures that kvm_gmem_unbind() and freeing of a memslot
>       occur after the memslot is no longer visible to kvm_gmem_get_pfn().
>    c) get_file_active() ensures that kvm_gmem_get_pfn() will not access the
>       stale file if kvm_gmem_release() sets it to NULL.  This is because if
>       kvm_gmem_release() occurs before kvm_gmem_get_pfn(), get_file_active()
>       will return NULL; if get_file_active() does not return NULL,
>       kvm_gmem_release() should not occur until after kvm_gmem_get_pfn()
>       releases the file reference.

Thanks for the analysis, I added some notes:

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4ec2564c0d0f..c788d0bd952a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -602,6 +602,11 @@ struct kvm_memory_slot {
  
  #ifdef CONFIG_KVM_PRIVATE_MEM
  	struct {
+		/*
+		 * Writes protected by kvm->slots_lock.  Acquiring a
+		 * reference via kvm_gmem_get_file() is protected by
+		 * either kvm->slots_lock or kvm->srcu.
+		 */
  		struct file *file;
  		pgoff_t pgoff;
  	} gmem;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9d9bf3d033bd..411ff7224caa 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -261,6 +261,12 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
  	 * dereferencing the slot for existing bindings needs to be protected
  	 * against memslot updates, specifically so that unbind doesn't race
  	 * and free the memslot (kvm_gmem_get_file() will return NULL).
+	 *
+	 * Since .release is called only when the reference count is zero,
+	 * after which file_ref_get() and get_file_active() fail,
+	 * kvm_gmem_get_pfn() cannot be using the file concurrently.
+	 * file_ref_put() provides a full barrier, and get_file_active() the
+	 * matching acquire barrier.
  	 */
  	mutex_lock(&kvm->slots_lock);
  
@@ -508,8 +514,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
  
  	/*
  	 * memslots of flag KVM_MEM_GUEST_MEMFD are immutable to change, so
-	 * kvm_gmem_bind() must occur on a new memslot.
-	 * Readers are guaranteed to see this new file.
+	 * kvm_gmem_bind() must occur on a new memslot.  Because the memslot
+	 * is not visible yet, kvm_gmem_get_pfn() is guaranteed to see the file.
  	 */
  	WRITE_ONCE(slot->gmem.file, file);
  	slot->gmem.pgoff = start;
@@ -547,6 +554,11 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
  
  	filemap_invalidate_lock(file->f_mapping);
  	xa_store_range(&gmem->bindings, start, end - 1, NULL, GFP_KERNEL);
+
+	/*
+	 * synchronize_srcu(&kvm->srcu) ensured that kvm_gmem_get_pfn()
+	 * cannot see this memslot.
+	 */
  	WRITE_ONCE(slot->gmem.file, NULL);
  	filemap_invalidate_unlock(file->f_mapping);
  
Queued to kvm-coco-queue.

Paolo


