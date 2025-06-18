Return-Path: <kvm+bounces-49806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 91AFBADE28A
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 06:28:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5AB177A3BCA
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 04:27:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6F6621D3F1;
	Wed, 18 Jun 2025 04:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sqlFzraH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503AF1F473C
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220691; cv=none; b=rFjemDSmQAB10HenE/z2mogGnEDe0RgW3E3tklga/undzoAM0dd7QaZpj3PQ4Tq1Cv+yULZdD0sdSzN9OQVMuMDirWhS93HIjMVlCoadnfUvKouGj76p/j/PW/6Zu2iq2TXzClhQOnI0ORlawqZvf6xk5ypCQMRMYRkkXkJYLnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220691; c=relaxed/simple;
	bh=TlPwQV38TsKUYD4upWrrqkkEe7fCtClTkHmYIdQHZto=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JHQz76GrD3PgKrN9tc9sHWJPFdcn58EejRzUxdr6aRUqoM+t4LK6C+jQuKw7ifrOwYTesxuFAvnVPYozlCqcA+jT/yaCVXhV/kyZBYE36xBREXHPOa+wAbtR05g3W4jujhimic04whWd67ZclrNNwfJcIpjBYMTa6ZlTXui9dqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sqlFzraH; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2c37558eccso4946408a12.1
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 21:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220690; x=1750825490; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P6MpWO9eGHCybkhP95T8R+1KfjKYk4MOXDyWFRHvmIc=;
        b=sqlFzraHghTHRkzSRh5LYZqz0Li96xF/7qXzaeRb6Hsgv5Jp0FgjmB66wj3unmdJQS
         JydoGEG6palK4LvzFRmdY7Jlru8hU3CVV2OSKH+2PEwfslG/VtLyUf6wOhnVqZU21Wuh
         Jdf1V4QZYh041kkYjQ8YWaBueksQ1V07nsXfa28RlR9XllZz/augWVUb+lyVkdvyLqxQ
         VG4ltejQa3Jm7Qy4M7VIxlWtoyQjgZVG7ASR1+QbMtLpz7QzgaR6GgHf9ZP8IAZT5kwQ
         OymuRDSXy4I32QSUpCrot2nXSEllVdLCm18cqtQjVOTvQrNw9tuN+c95DB9DSwpux7g0
         LD0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220690; x=1750825490;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P6MpWO9eGHCybkhP95T8R+1KfjKYk4MOXDyWFRHvmIc=;
        b=aRntVpuNjWVjNIslnhbQaW9WUDNEoU3rwmUfg2nIYiuhxHVQJVnYoqE8nF+ZAvOjOr
         O6B3JUNtwkL8A+DsIdirNCN+M1VOR38+M0R7ruXt8hHKMBF4KgbA17NzeYXXrG7iN7cz
         18td3ah6ifCItT8wccAyFIH7yw73uw6/2bcmwtT2GtuvPRcxqjbMoJa0ahlAZh1/p3q3
         x1UHEn0RgPvtusmm+e5hP91dRNXkOKXoFssCryM9qujcBtLwIpFlYCYCQ9pT2/c6Zrea
         h0v7mxKKzLRdxa6ZCQTokK6urE5GcnytpEibC3qX9vAu+NTVtxSigT0ZRkHS0mTkhEA1
         hxww==
X-Forwarded-Encrypted: i=1; AJvYcCU0AiUQwaeQpk5/oZrxtQBsqZhk6Bggjd5jV3PwGm2sAQPUO55M079eRnTNfWwrEl+hcDw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxubPJiCqXDfedY8I8IvecPg6TGbiyIFgpjRKwxAsAbO2fBe+bg
	iC/GeCNFZeU+RIuufMipRQvzqeVCgIJ8yn6vBs+JS5lDxGq+ZZJm0EUffVH1+q1We+T3/k2hNUf
	sul+xwGlbVd7qlT8uwLKKuA==
X-Google-Smtp-Source: AGHT+IFBmqhQDFkst9hOrle0gOrugvU+bLMa/osue2o1jv722NhjgUmFbYBlQLzwI5ul7WF7bNf9FKyZ7x+dJLfM
X-Received: from pgbfq12.prod.google.com ([2002:a05:6a02:298c:b0:b2f:dfa3:cb81])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:512:b0:218:5954:1293 with SMTP id adf61e73a8af0-21fbd668df0mr28784142637.34.1750220689787;
 Tue, 17 Jun 2025 21:24:49 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:24 +0000
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-16-jthoughton@google.com>
Subject: [PATCH v3 15/15] KVM: Documentation: Add KVM_CAP_USERFAULT and
 KVM_MEM_USERFAULT details
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Bagas Sanjaya <bagasdotme@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Include the note about memory ordering when clearing bits in
userfault_bitmap, as it may not be obvious for users.

Signed-off-by: James Houghton <jthoughton@google.com>
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/virt/kvm/api.rst | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index ff0aa9eb91efe..25668206a5d80 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6308,7 +6308,8 @@ bounds checks apply (use common sense).
 	__u64 guest_memfd_offset;
 	__u32 guest_memfd;
 	__u32 pad1;
-	__u64 pad2[14];
+	__u64 userfault_bitmap;
+	__u64 pad2[13];
   };
 
 A KVM_MEM_GUEST_MEMFD region _must_ have a valid guest_memfd (private memory) and
@@ -6324,6 +6325,25 @@ state.  At VM creation time, all memory is shared, i.e. the PRIVATE attribute
 is '0' for all gfns.  Userspace can control whether memory is shared/private by
 toggling KVM_MEMORY_ATTRIBUTE_PRIVATE via KVM_SET_MEMORY_ATTRIBUTES as needed.
 
+When the KVM_MEM_USERFAULT flag is set, userfault_bitmap points to the starting
+address for the bitmap that controls if vCPU memory faults should immediately
+exit to userspace. If an invalid pointer is provided, at fault time, KVM_RUN
+will return -EFAULT. KVM_MEM_USERFAULT is only supported when
+KVM_CAP_USERFAULT is supported.
+
+userfault_bitmap should point to an array of longs where each bit in the array
+linearly corresponds to a single gfn. Bit 0 in userfault_bitmap corresponds to
+guest_phys_addr, bit 1 corresponds to guest_phys_addr + PAGE_SIZE, etc. If the
+bit for a page is set, any vCPU access to that page will exit to userspace with
+KVM_MEMORY_EXIT_FLAG_USERFAULT.
+
+Setting bits in userfault_bitmap has no effect on pages that have already been
+mapped by KVM until KVM_MEM_USERFAULT is disabled and re-enabled again.
+
+Clearing bits in userfault_bitmap should usually be done with a store-release
+if changes to guest memory are being made available to the guest via
+userfault_bitmap.
+
 S390:
 ^^^^^
 
@@ -8557,6 +8577,17 @@ given VM.
 When this capability is enabled, KVM resets the VCPU when setting
 MP_STATE_INIT_RECEIVED through IOCTL.  The original MP_STATE is preserved.
 
+7.44 KVM_CAP_USERFAULT
+----------------------
+
+:Architectures: x86, arm64
+:Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
+
+The presence of this capability indicates that KVM_SET_USER_MEMORY_REGION2 will
+accept KVM_MEM_USERFAULT as a valid memslot flag.
+
+See KVM_SET_USER_MEMORY_REGION2 for more details.
+
 8. Other capabilities.
 ======================
 
-- 
2.50.0.rc2.692.g299adb8693-goog


