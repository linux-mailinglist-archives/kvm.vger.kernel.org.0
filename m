Return-Path: <kvm+bounces-35141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60A48A09F2F
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:20:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D5AF16AD0D
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:20:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35B4ADDC5;
	Sat, 11 Jan 2025 00:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WbLDyZHq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BCE1C27
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736554828; cv=none; b=qd5IOgKdfEbZWkcCd3Cx5zaXWZ323IuOjHPHTcM8xFzE/19XJZcEJ+dkJpuidqgPoF9bVVRSVXQiQPXazPA4FxwzBs8MCY8TxEw/5WDuiOI0rr7BXm2lvdjoWkT7VQ1j6Fs+fuT2rxsPwbSXJLge4V8+0CLgUxiEggfSs3oEliU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736554828; c=relaxed/simple;
	bh=9bLabAX9qJpvoDdnVlnPIlO/ydni9rNkwiea7ti7JxI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B7coM0AoQaK0jSxR8LWM+KkrOWhgDHxwcXwX/d72vNE6u4mcyMfzd6Gv6VkD/JQaZHhvu5dzzgd3sOjl33ELEn4rnhOfy3+5lbHSu5MtuonYLebPdfvsVj7NrjVKlJpqgbckp+cNJPCVmDpsjRDb6vHyhiNcB0Vx9Si82+Eidsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WbLDyZHq; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef79d9c692so6703427a91.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736554826; x=1737159626; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1z0qvvRjGkbjMSPVvMkJ6g5fzjiEL9xgqcuZ1X7Vulw=;
        b=WbLDyZHqg9eNJFOrH6BAEcN6g1Np/l8p/M5LlnC5fNOWqjZQXy264bLhNLKycWpsAT
         HqaNvMOMdh6gfLcoRExQR4gsfFNNKbLKX+f9HrLxWu+6nhtfC8KSKoWHjnetwsfQ8ogn
         xtVZ/fTkDy3rX/Jyzcx8gQKmY85nKhh43dPIRBeYwpZ994FW7uxYK7KZ0ffup1MP/ksf
         N8A1ntT59nOcMK/y4ZkKqm181MB6PU59viQy50QLTAohD4dvLZm/tmNHUO0+c8wEyloc
         BY5YDZ0vN21Ppk1FTUHVFN/6qO7EuOQ0WSmjeNPCC8ph4o9B7LXfq6Am0qF+zyWw6zDQ
         SpCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736554826; x=1737159626;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1z0qvvRjGkbjMSPVvMkJ6g5fzjiEL9xgqcuZ1X7Vulw=;
        b=wINIcZdQSFiUa/fh+9Sh2+p4dSdMKXVBz/UOQ3DYtjdx4dxiZDRJleFbHcsJP/SpAm
         aIKByNkZphSay8uGOzM/8CFPHniR6UrHZ1MRDtt89LSvpC+jCV46uciBLFMZl5Katq0t
         a+Js0SgxMLT7zPvmdFH1oqPpw8fRSvUKZA+naCwEUID+/k3y1pAA9NP6blYbYVzT0Dly
         7MosBr9jb85wdiPbr8kd5uv+XfcuGgR+8v6bWu8FHWV59BvMmJGUy7X8/0wmVppSV+8d
         9hLRfEOPP2CztLUvd2OymSDprvc2NkchcAUrL4B6YiSouwVTNGjibp9YZlKuTTuAd6Xo
         GhEw==
X-Gm-Message-State: AOJu0Yyi6AHQEmDwKYVUgugHdmbJQ9qBKkJFGkC6Sbsj6Gaq69G8vazQ
	T907M+GG0qdCxkJRP7wXzW1WJV0Yu4pDGyvHvSFaiFljZM/Z6ztV1m+PXP8lMYLHzKoRxVqcyiY
	+jg==
X-Google-Smtp-Source: AGHT+IHWbfZBHGSMZfSSplPGo1MbCjmySgtVr8uQK2bZeENb0UAKX/k6hcjnMICqiEw6LKHg1epjouIsGUk=
X-Received: from pjbrs12.prod.google.com ([2002:a17:90b:2b8c:b0:2ea:6aa8:c4ad])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e10:b0:2ea:4a6b:79d1
 with SMTP id 98e67ed59e1d1-2f548eb3213mr19097571a91.11.1736554826286; Fri, 10
 Jan 2025 16:20:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:20:18 -0800
In-Reply-To: <20250111002022.1230573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111002022.1230573-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111002022.1230573-2-seanjc@google.com>
Subject: [PATCH v2 1/5] KVM: Open code kvm_set_memory_region() into its sole
 caller (ioctl() API)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tao Su <tao1.su@linux.intel.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@de.ibm.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

Open code kvm_set_memory_region() into its sole caller in preparation for
adding a dedicated API for setting internal memslots.

Oppurtunistically use the fancy new guard(mutex) to avoid a local 'r'
variable.

Cc: Tao Su <tao1.su@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  2 --
 virt/kvm/kvm_main.c      | 15 ++-------------
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 401439bb21e3..7443de24b1d9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1192,8 +1192,6 @@ enum kvm_mr_change {
 	KVM_MR_FLAGS_ONLY,
 };
 
-int kvm_set_memory_region(struct kvm *kvm,
-			  const struct kvm_userspace_memory_region2 *mem);
 int __kvm_set_memory_region(struct kvm *kvm,
 			    const struct kvm_userspace_memory_region2 *mem);
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index de2c11dae231..eb3d0a385077 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2058,25 +2058,14 @@ int __kvm_set_memory_region(struct kvm *kvm,
 }
 EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
 
-int kvm_set_memory_region(struct kvm *kvm,
-			  const struct kvm_userspace_memory_region2 *mem)
-{
-	int r;
-
-	mutex_lock(&kvm->slots_lock);
-	r = __kvm_set_memory_region(kvm, mem);
-	mutex_unlock(&kvm->slots_lock);
-	return r;
-}
-EXPORT_SYMBOL_GPL(kvm_set_memory_region);
-
 static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 					  struct kvm_userspace_memory_region2 *mem)
 {
 	if ((u16)mem->slot >= KVM_USER_MEM_SLOTS)
 		return -EINVAL;
 
-	return kvm_set_memory_region(kvm, mem);
+	guard(mutex)(&kvm->slots_lock);
+	return __kvm_set_memory_region(kvm, mem);
 }
 
 #ifndef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
-- 
2.47.1.613.gc27f4b7a9f-goog


