Return-Path: <kvm+bounces-43485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32FD7A90A69
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 19:48:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6EF475A254E
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 17:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C11D621576A;
	Wed, 16 Apr 2025 17:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gz1aXodn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B107B14B950
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 17:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744825691; cv=none; b=a2rp9a3BtKXga1zAhwDLNMT4shSZmqzG98/Ils5bqvPyyTDMFDEv3AhTolcF/SY76/EaRp4995OlADxUQKALSSFfoMVM8EoJl8Q990NwzNj4vxXxqdS1ms3Kdo00+aFznMWpn1eWg0C4S3QJ5z2jzMMhc+G0e9QeL3qcUSSTZrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744825691; c=relaxed/simple;
	bh=nDlzDHO7lG1CyoT8kHmoRds6M0Ktog63OmQxCqfcvkM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t5/e9GmDDfsXjElV4L/EoLcazSTwI6dZsty7jvugzMXCC/P8JK8GucXPeh3HxA3sj9Of7SzPPlA37tjE8a8H/9J+mHwLqarDl7XRiHsY/Kt6FpqoK6yJGQZ1iHvAf0uLTUeeHFCoWhHiYL5zma41dzPztBZfwuGiE7CPsSIiOgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gz1aXodn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744825688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/YUAN4imupbHgjWn5VTBZKruYuHjhfh3kj8IKp3Z0dY=;
	b=gz1aXodnoCFG1a/IQlXzd/7G7GH7ZKuiZSEfF0XHWctz/Z1DT8rlLoumCN6So40stGjqdR
	UMlYuzPlzgep8/5qaH5wn62FtZ8+kaUes4dA7XgjTnqIa9TvUBKKLjoOk5my2SzxtI7kxU
	wMtIgsx9WFXCUEZEE3UTtXdRs+mDBbc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-NthvwTQKOQiiCCyVVFECew-1; Wed, 16 Apr 2025 13:48:07 -0400
X-MC-Unique: NthvwTQKOQiiCCyVVFECew-1
X-Mimecast-MFC-AGG-ID: NthvwTQKOQiiCCyVVFECew_1744825686
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-39135d31ca4so584184f8f.1
        for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 10:48:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744825686; x=1745430486;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/YUAN4imupbHgjWn5VTBZKruYuHjhfh3kj8IKp3Z0dY=;
        b=T6aa288EGyDSwvhTotO58cQm5BRsqY+4LsK5BpboJsfz1RCdC3kbDhm6H2eHvS5IPO
         qa32RXUqSzawIykKzPVoVJI0pl2Ns21zRQQRqxMRui4UIkYo8olUO7v6WJUDRxmR+9Q7
         cEb02i4DpgFHMDp+cBGpOZL97DV2+90SnsGRZyZ/8dyRoe0f0rA9mqp2Q5G0mW6UI9z+
         NPAYBcW3w2G3/u2WHCUOmixVVV8tqKKe4xoYRCVZ5d51AUiBleVeG+eowrQuaTbFqAn3
         5/HKhf91LqcihI7yV9MR/5VngoLNBx1LkbwCIhZ9zL4yLOttuV02OIVZCX7WyI4fynnb
         irng==
X-Gm-Message-State: AOJu0YwFXHuoOrA9n3UTfuNCfPL8CMDFZVj0hb72wMdCX0jP6hu5d3MH
	x0id5KSCzIueOHXbZQg+1Ml0U+lknGYQ7NY5I/FLSs6NTCT7dYEQS4b3hih1+01H3+kthvzbd+Z
	2OInmbMLKQrYRcLDHfRsYQw94ham+gOR+g1zZfMAOOzWfxK0gfA==
X-Gm-Gg: ASbGncuyVdYK9ciQ8Dz+7daAEiJk76Inigpzp+x2C5kVG19uq3RxGmGXlilvsH9ERvE
	AHGDKGvrpXi8OzH1wg6HjkszyjnQIi82An3KjapGY8Cl1MN++fiWZAE2u4LI6OkIcNDOi+R3h2g
	HM+nSiVARTks0d6Jd0XVALlkCg7i0S9wsMYnMDuBWvbec1H3SaYECdtOGK7LMvW23c5awhCetXE
	oPdX4U6z+af9QFee3n+QoPBPzJ8EZ0NAHJVDIpVEivMukznWHAZ2p5RFRDADh5LzV1Cx+jxOYqv
	a02kSA3gVGTIFrTo
X-Received: by 2002:a5d:598d:0:b0:39c:266b:feec with SMTP id ffacd0b85a97d-39ee904afe3mr313544f8f.7.1744825685972;
        Wed, 16 Apr 2025 10:48:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHd/Q9xU1Lv4kZ9t/WwJIPpluDO/OcIMcKulh4/sk/gvKDXTcl2daOqoE90IlBaQsWY9I2m/g==
X-Received: by 2002:a5d:598d:0:b0:39c:266b:feec with SMTP id ffacd0b85a97d-39ee904afe3mr313534f8f.7.1744825685524;
        Wed, 16 Apr 2025 10:48:05 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.109.83])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-39eae9640e3sm18034375f8f.12.2025.04.16.10.48.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 10:48:04 -0700 (PDT)
Message-ID: <60b7607b-8ada-447d-9dcb-034d93b9abe8@redhat.com>
Date: Wed, 16 Apr 2025 19:48:00 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] KVM: x86: move sev_lock/unlock_vcpus_for_migration
 to kvm_main.c
To: Peter Zijlstra <peterz@infradead.org>,
 Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Alexander Potapenko <glider@google.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 kvm-riscv@lists.infradead.org, Oliver Upton <oliver.upton@linux.dev>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Jing Zhang <jingzhangos@google.com>, Waiman Long <longman@redhat.com>,
 x86@kernel.org, Kunkun Jiang <jiangkunkun@huawei.com>,
 Boqun Feng <boqun.feng@gmail.com>, Anup Patel <anup@brainfault.org>,
 Albert Ou <aou@eecs.berkeley.edu>, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
 Borislav Petkov <bp@alien8.de>, Alexandre Ghiti <alex@ghiti.fr>,
 Keisuke Nishimura <keisuke.nishimura@inria.fr>,
 Sebastian Ott <sebott@redhat.com>, Atish Patra <atishp@atishpatra.org>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Randy Dunlap <rdunlap@infradead.org>, Will Deacon <will@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, linux-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 Joey Gouly <joey.gouly@arm.com>, Ingo Molnar <mingo@redhat.com>,
 Andre Przywara <andre.przywara@arm.com>, Thomas Gleixner
 <tglx@linutronix.de>, Sean Christopherson <seanjc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Bjorn Helgaas <bhelgaas@google.com>
References: <20250409014136.2816971-1-mlevitsk@redhat.com>
 <20250409014136.2816971-3-mlevitsk@redhat.com>
 <20250410081640.GX9833@noisy.programming.kicks-ass.net>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250410081640.GX9833@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/10/25 10:16, Peter Zijlstra wrote:
> On Tue, Apr 08, 2025 at 09:41:34PM -0400, Maxim Levitsky wrote:
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 69782df3617f..71c0d8c35b4b 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -1368,6 +1368,77 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
>>   	return 0;
>>   }
>>   
>> +
>> +/*
>> + * Lock all VM vCPUs.
>> + * Can be used nested (to lock vCPUS of two VMs for example)
>> + */
>> +int kvm_lock_all_vcpus_nested(struct kvm *kvm, bool trylock, unsigned int role)
>> +{
>> +	struct kvm_vcpu *vcpu;
>> +	unsigned long i, j;
>> +
>> +	lockdep_assert_held(&kvm->lock);
>> +
>> +	kvm_for_each_vcpu(i, vcpu, kvm) {
>> +
>> +		if (trylock && !mutex_trylock_nested(&vcpu->mutex, role))
>> +			goto out_unlock;
>> +		else if (!trylock && mutex_lock_killable_nested(&vcpu->mutex, role))
>> +			goto out_unlock;
>> +
>> +#ifdef CONFIG_PROVE_LOCKING
>> +		if (!i)
>> +			/*
>> +			 * Reset the role to one that avoids colliding with
>> +			 * the role used for the first vcpu mutex.
>> +			 */
>> +			role = MAX_LOCK_DEPTH - 1;
>> +		else
>> +			mutex_release(&vcpu->mutex.dep_map, _THIS_IP_);
>> +#endif
>> +	}
> 
> This code is all sorts of terrible.
> 
> Per the lockdep_assert_held() above, you serialize all these locks by
> holding that lock, this means you can be using the _nest_lock()
> annotation.
> 
> Also, the original code didn't have this trylock nonsense, and the
> Changelog doesn't mention this -- in fact the Changelog claims no
> change, which is patently false.
> 
> Anyway, please write like:
> 
> 	kvm_for_each_vcpu(i, vcpu, kvm) {
> 		if (mutex_lock_killable_nest_lock(&vcpu->mutex, &kvm->lock))
> 			goto unlock;
> 	}
> 
> 	return 0;
> 
> unlock:
> 
> 	kvm_for_each_vcpu(j, vcpu, kvm) {
> 		if (j == i)
> 			break;
> 
> 		mutex_unlock(&vcpu->mutex);
> 	}
> 	return -EINTR;
> 
> And yes, you'll have to add mutex_lock_killable_nest_lock(), but that
> should be trivial.

If I understand correctly, that would be actually
_mutex_lock_killable_nest_lock() plus a wrapper macro.  But yes,
that is easy so it sounds good.

For the ARM case, which is the actual buggy one (it was complaining
about too high a depth) it still needs mutex_trylock_nest_lock();
the nest_lock is needed to avoid bumping the depth on every
mutex_trylock().

It should be something like
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 2143d05116be..328f573cab6d 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -174,6 +174,12 @@ do {									\
  	_mutex_lock_nest_lock(lock, &(nest_lock)->dep_map);		\
  } while (0)
  
+#define mutex_trylock_nest_lock(lock, nest_lock)			\
+do {									\
+	typecheck(struct lockdep_map *, &(nest_lock)->dep_map);		\
+	_mutex_trylock_nest_lock(lock, &(nest_lock)->dep_map);		\
+} while (0)
+
  #else
  extern void mutex_lock(struct mutex *lock);
  extern int __must_check mutex_lock_interruptible(struct mutex *lock);
@@ -185,6 +191,7 @@ extern void mutex_lock_io(struct mutex *lock);
  # define mutex_lock_killable_nested(lock, subclass) mutex_lock_killable(lock)
  # define mutex_lock_nest_lock(lock, nest_lock) mutex_lock(lock)
  # define mutex_lock_io_nested(lock, subclass) mutex_lock_io(lock)
+# define mutex_trylock_nest_lock(lock, nest_lock) mutex_trylock(lock)
  #endif
  
  /*
@@ -193,9 +200,14 @@ extern void mutex_lock_io(struct mutex *lock);
   *
   * Returns 1 if the mutex has been acquired successfully, and 0 on contention.
   */
-extern int mutex_trylock(struct mutex *lock);
+extern int _mutex_trylock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock);
  extern void mutex_unlock(struct mutex *lock);
  
+static inline int mutex_trylock(struct mutex *lock)
+{
+	return _mutex_trylock_nest_lock(lock, NULL);
+}
+
  extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
  
  DEFINE_GUARD(mutex, struct mutex *, mutex_lock(_T), mutex_unlock(_T))
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 555e2b3a665a..d5d1e79495fc 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -1063,8 +1063,10 @@ __ww_mutex_lock_interruptible_slowpath(struct ww_mutex *lock,
  #endif
  
  /**
- * mutex_trylock - try to acquire the mutex, without waiting
+ * _mutex_trylock_nest_lock - try to acquire the mutex, without waiting
   * @lock: the mutex to be acquired
+ * @nest_lock: if not NULL, a mutex that is always taken whenever multiple
+ *   instances of @lock are
   *
   * Try to acquire the mutex atomically. Returns 1 if the mutex
   * has been acquired successfully, and 0 on contention.
@@ -1076,7 +1078,7 @@ __ww_mutex_lock_interruptible_slowpath(struct ww_mutex *lock,
   * This function must not be used in interrupt context. The
   * mutex must be released by the same task that acquired it.
   */
-int __sched mutex_trylock(struct mutex *lock)
+int __sched _mutex_trylock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock)
  {
  	bool locked;
  
@@ -1084,11 +1086,11 @@ int __sched mutex_trylock(struct mutex *lock)
  
  	locked = __mutex_trylock(lock);
  	if (locked)
-		mutex_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		mutex_acquire_nest(&lock->dep_map, 0, 1, nest_lock, _RET_IP_);
  
  	return locked;
  }
-EXPORT_SYMBOL(mutex_trylock);
+EXPORT_SYMBOL(_mutex_trylock_nest_lock);
  
  #ifndef CONFIG_DEBUG_LOCK_ALLOC
  int __sched

Does that seem sane?

Paolo


