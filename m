Return-Path: <kvm+bounces-33234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B06F9E7BEA
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 23:47:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D30F188432B
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 22:47:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C57591F9EC6;
	Fri,  6 Dec 2024 22:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UeZWq2x8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f202.google.com (mail-vk1-f202.google.com [209.85.221.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DF41F4706
	for <kvm@vger.kernel.org>; Fri,  6 Dec 2024 22:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733525223; cv=none; b=KgTj6cuu0ssnmEzVCBigb22q153h9pCeJ6JKITTHt2x3PnSGPUF9GljIwdenSp6g4tHRWXTBVAOd9cBszrnEb+BrtjtfWNSjlBRzxuNKgWCDaFQfzZ2tiwbyZXQHg82aKr/BuD787iTNks0TxnSy4Q5iCkrhGpewouFlifY8v+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733525223; c=relaxed/simple;
	bh=iITAE1Ks58yzjB7pv45kbC7F7m3AmF+RtaX7q902Uf8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Kd5Dtia2g7hIn+5sz1tjX3SC+Wz7l22Q0mBaxFSfYJjfv9nwk0+bURXQD4R9PBWY56weuEYpD3IryytNBxlvW6lrxMtGXoEghPr53qTx+YVr1wT41KhmwXnQCvc1wxf70tJ5ZX9wIY0ZiwdYXXQraa+yMHFOFRz3tGSERps05Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UeZWq2x8; arc=none smtp.client-ip=209.85.221.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vk1-f202.google.com with SMTP id 71dfb90a1353d-515cf198890so445363e0c.2
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2024 14:47:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733525219; x=1734130019; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8xOebWP/M8X2cP/fdZF9vXfDo8byCjFk2C5X5FbCC10=;
        b=UeZWq2x8T1e3RuJxryf1R9hW2RwLmEkMrt3ufE+U20FGxTLb8Ugy4tn9n4jVUpbpQ5
         5PeMMpUTNjgPZx4RIqy7Hw6qiw0R2b3pctMJiogjpYF+D+o5kaysTfRx5aBoagIDo7b+
         qVXEB7Q6xcBigTmB5vq8dtVX+seSb3ZIIr47FPPyNUu4NJr4vjyZRyCveEC4pX+VNTYz
         DyeO/O3yVBq7QGzeMUMBf6K7UYvYhf6s8EKqSvohOWYVNFDhUcB0XHN+6BcIg4kjN2F4
         anEWfTIlDraCHiRaJ3q20SWA9KkfjktCuHhgUeUmOt4RvYXNNomgk3CofeJOc0A5DWsK
         iw8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733525219; x=1734130019;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8xOebWP/M8X2cP/fdZF9vXfDo8byCjFk2C5X5FbCC10=;
        b=SuVPA0JyaMijESQ9PoLCtEwR9v7TZylz9qz7P8124OJF7siiIpIXcabiZ2yaet3dXp
         CrafeU5bUoJJaQLnezOu0RXAIwdIie7W+lLgzgIVdimBlgUViLNpjU139RY/CIwI37dT
         PX4a3DXIcFBLed/MhPevv5AykqbXxdbQ/81apuQyjnfPokIZ4kBg7mMU7BXJZZMG/xC3
         6RQnXfne05Uz9SuHqpQ3l8NI2aEFhhFLc6l8OaMssyrgyqcPzvppYfG8trAOW9Nh6Bv4
         M1eIqqEjBNXF9NmQ9CWBFvxLEJf7huItK5kpPb64K85n10wdXhiabmWW/OSS1LTRlvFu
         DLNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeZfBwBpeHZ6EZMAvC7KqfgumpDYb0TraIhY8dDA7b9mQTcQMvpmoCDgZmSYmcuTwhfjo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbLPeZ6K9tziwCrEmpzDrNk70T1EwzL8qccWKM7k567LvDpdbg
	EdICyg200VmjoVHzIseVH7xwwt3sIYaLsE3Nx6+OYcaXjHLDi1oMdB/4dT8rG6oXTr9UWow9eGn
	hK0ho9Bu65w6DpqVPdQ==
X-Google-Smtp-Source: AGHT+IFWYRH0ZDfG1SCEobsGl/BiWTfQRI31egCmHBP1UIFLmQh8g16wMoeT9PBzM1Kkhhw9DuLZq6uIHa5tY1W0
X-Received: from vkbes1.prod.google.com ([2002:a05:6122:1b81:b0:50d:806e:dfd0])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6122:1da1:b0:50b:e9a5:cd7b with SMTP id 71dfb90a1353d-515fcae70a3mr5700023e0c.9.1733525219486;
 Fri, 06 Dec 2024 14:46:59 -0800 (PST)
Date: Fri,  6 Dec 2024 22:46:58 +0000
In-Reply-To: <202412052133.pTg3UAQm-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <202412052133.pTg3UAQm-lkp@intel.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241206224658.2833655-1-jthoughton@google.com>
Subject: Re: [PATCH v1 01/13] KVM: Add KVM_MEM_USERFAULT memslot flag and bitmap
From: James Houghton <jthoughton@google.com>
To: lkp@intel.com
Cc: amoorthy@google.com, corbet@lwn.net, dmatlack@google.com, 
	jthoughton@google.com, kalyazin@amazon.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org, 
	oe-kbuild-all@lists.linux.dev, oliver.upton@linux.dev, pbonzini@redhat.com, 
	peterx@redhat.com, pgonda@google.com, seanjc@google.com, wei.w.wang@intel.com, 
	yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"

>    arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function '__kvm_set_memory_region':
> >> arch/x86/kvm/../../../virt/kvm/kvm_main.c:2049:41: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>     2049 |                 new->userfault_bitmap = (unsigned long *)mem->userfault_bitmap;
>          |                                         ^

I realize that, not only have I done this cast slightly wrong, I'm
missing a few checks on userfault_bitmap that I should have. Applying
this diff, or at least something like it, to fix it:

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b552cdef2850..30f09141df64 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1977,6 +1977,12 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		return -EINVAL;
 	if ((mem->memory_size >> PAGE_SHIFT) > KVM_MEM_MAX_NR_PAGES)
 		return -EINVAL;
+	if (mem->flags & KVM_MEM_USERFAULT &&
+	    ((mem->userfault_bitmap != untagged_addr(mem->userfault_bitmap)) ||
+	     !access_ok((void __user *)(unsigned long)mem->userfault_bitmap,
+			DIV_ROUND_UP(mem->memory_size >> PAGE_SHIFT, BITS_PER_LONG)
+			 * sizeof(long))))
+		return -EINVAL;
 
 	slots = __kvm_memslots(kvm, as_id);
 
@@ -2053,7 +2059,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			goto out;
 	}
 	if (mem->flags & KVM_MEM_USERFAULT)
-		new->userfault_bitmap = (unsigned long *)mem->userfault_bitmap;
+		new->userfault_bitmap =
+		  (unsigned long __user *)(unsigned long)mem->userfault_bitmap;
 
 	r = kvm_set_memslot(kvm, old, new, change);
 	if (r)

