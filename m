Return-Path: <kvm+bounces-28400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A146998164
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 11:03:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BDB01C246B1
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 09:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9AE01BC9FB;
	Thu, 10 Oct 2024 08:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NE+EOjow"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B971BC9F0
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 08:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728550794; cv=none; b=io8Kjp6XYVyMQKrrCt4owHu6nhLXbqUmPTmgkV9Ktr5ji12z33nOScFxq85SMtObsEC4D9/9WPRzMTkCFrm8AKEFPPv2ScBSgC/2ez1UeBMFUuJga2EiYrYZ6LeeW5vG0KJvyAydIIlJEb3Ji749PPYQksQnaFoHIn26Wj8JCmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728550794; c=relaxed/simple;
	bh=BhjpzC9e+LOdQaEyIwWjPOfcNwacANucZUU5tZhNjr4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gFimTo90G8/WzaukE9c/tZwDu3aM8kMClrtc773yU35jJ7kop7szXF+QOJUktloHay27VCV8LxcW2dgAG64bJ/uiNoBoFzcJlJY5VGXM58MpxV2JnuZYu7Jsy33NHn19BKIT3uTnrWj1x3tmUERe0emwdG3LD6SyAi6fyZbgC8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NE+EOjow; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e02fff66a83so1082082276.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 01:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728550791; x=1729155591; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zKaf8nivAag4/4uIL21ZmJPpCRWLdv9h6z/9SiSCBvk=;
        b=NE+EOjowsLpQuoh+ZjHURomptnThefOwBzO24Jr7z7JBcV8VeT+gnefkJOdb7+EDv/
         YzDNXq2BJfusfUr6VLOhAsQtWHdbNJhBUyV6tVxiE9iSbJVb0XdRpJsiJnPpNvGRa1YZ
         eW5JOOWKpkdWkYabbPmPOylXkhXlPEOdlpbmWR0hl/r54YUQUTRAHrXPZK4KeTWODHxQ
         FZ1QkAZ56Atasf4AC6VrcaUhG9NweXWpdHz1KbzkWsOX4M/dRslnLA+cAcSylrJe3ITh
         hvJsXvSmGE7qRbzeuTPyY9QortdR3IHfP14XHHjzd9pGB9x/4Ifdy3x492+FBMdthXJN
         Wimw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728550791; x=1729155591;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zKaf8nivAag4/4uIL21ZmJPpCRWLdv9h6z/9SiSCBvk=;
        b=l2MD+F55QE1Wu84dcTHJpPTnuk/hyq/9AyAk18PCt5D8uva4wKW63zdDPLa9c+hi5J
         CrX5xnWrJaA4ryd+cw2jMzXaKqinKvIn4xNGslhgSUtnfJeWLNkw/W2zrmdgJ8SBPAAD
         uEUKoMpfJI9/s7Prh6c2P0w/IQptiz2hrqyuERbWQIM5kB3iqUw2Q/F8U5I7NU6zfjFK
         /HjO9wL3ejR6w2QdKzCct7aso/i5Viwc+Y0oq6ao0oaXiGDGxMquYEnBC47tmCpdgOAa
         oDYxnPdj6Ktl2/zUdG2OrOzCNADrqSjCUdx5Fgp+UQncr2iQQ+rjzPGK0GGQNMw6JzLo
         ta6A==
X-Gm-Message-State: AOJu0YzK1cQtedY/tVl3Cmlk/vbGFH2q83q3mbPY6lmFpxt47bAVg+Gk
	3shO9grqcumvaerbASUVLGuot10bNRF37kaEKmnECVv6s+eRLaJ63lmNwnnbFkRVmbtDCYFQ4Do
	nobDTHPxW5TwbbKQmnWt20OJT/JfHfA7bsa65HngofhqcgOyFNy3f9eW5hQSXXLhDh4SM1UwRUe
	BA88/sQcvdflJcJCbUFS3u9NA=
X-Google-Smtp-Source: AGHT+IFyezTuDqo1giJ/p5guQQYFu/xIk5SZEqJH7PMzqSsZJQW4O7K2L6rTa8b012uIruIWq11czsKArw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:c2c1:0:b0:e22:5bdf:39c1 with SMTP id
 3f1490d57ef6-e28fe45b504mr3520276.10.1728550790172; Thu, 10 Oct 2024 01:59:50
 -0700 (PDT)
Date: Thu, 10 Oct 2024 09:59:26 +0100
In-Reply-To: <20241010085930.1546800-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010085930.1546800-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241010085930.1546800-8-tabba@google.com>
Subject: [PATCH v3 07/11] KVM: guest_memfd: Add a guest_memfd() flag to
 initialize it as mappable
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Not all use cases require guest_memfd() to be mappable by the
host when first created. Add a new flag,
GUEST_MEMFD_FLAG_INIT_MAPPABLE, which when set on
KVM_CREATE_GUEST_MEMFD initializes the memory as mappable by the
host. Otherwise, memory is private until shared by the guest with
the host.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 Documentation/virt/kvm/api.rst | 4 ++++
 include/uapi/linux/kvm.h       | 1 +
 virt/kvm/guest_memfd.c         | 6 +++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e32471977d0a..c503f9443335 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6380,6 +6380,10 @@ most one mapping per page, i.e. binding multiple memory regions to a single
 guest_memfd range is not allowed (any number of memory regions can be bound to
 a single guest_memfd file, but the bound ranges must not overlap).
 
+If the capability KVM_CAP_GUEST_MEMFD_MAPPABLE is supported, then the flags
+field supports GUEST_MEMFD_FLAG_INIT_MAPPABLE, which initializes the memory
+as mappable by the host.
+
 See KVM_SET_USER_MEMORY_REGION2 for additional details.
 
 4.143 KVM_PRE_FAULT_MEMORY
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2c6057bab71c..751f167d0f33 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1558,6 +1558,7 @@ struct kvm_memory_attributes {
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
 
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
+#define GUEST_MEMFD_FLAG_INIT_MAPPABLE		BIT(0)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index df3a6f05a16e..9080fa29cd8c 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -734,7 +734,8 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 		goto err_gmem;
 	}
 
-	if (IS_ENABLED(CONFIG_KVM_GMEM_MAPPABLE)) {
+	if (IS_ENABLED(CONFIG_KVM_GMEM_MAPPABLE) &&
+	    (flags & GUEST_MEMFD_FLAG_INIT_MAPPABLE)) {
 		err = gmem_set_mappable(file_inode(file), 0, size >> PAGE_SHIFT);
 		if (err) {
 			fput(file);
@@ -763,6 +764,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	u64 flags = args->flags;
 	u64 valid_flags = 0;
 
+	if (IS_ENABLED(CONFIG_KVM_GMEM_MAPPABLE))
+		valid_flags |= GUEST_MEMFD_FLAG_INIT_MAPPABLE;
+
 	if (flags & ~valid_flags)
 		return -EINVAL;
 
-- 
2.47.0.rc0.187.ge670bccf7e-goog


