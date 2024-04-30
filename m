Return-Path: <kvm+bounces-16241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6384F8B7CAE
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 18:21:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20A15285887
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 16:21:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6D2F17967E;
	Tue, 30 Apr 2024 16:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pMYMYvUr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAFC176FA3
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 16:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714494098; cv=none; b=oo+48xEO5oPfr5zewouw62mDvHxr9WB33mNfFeq5OkNnaFjEY0haZS+XO8+igj4uTMCIsSc+ORbV4ddfYEnCgmN2GLegM8x54u9IxCYt2JtF5ZeR/5hf3zWCrvMq3liqgNALSvuSwR/JyaReQJeIDyOguZwGBoslYP7CSqKbNAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714494098; c=relaxed/simple;
	bh=mMQeVatdhY0z/Hzuq0x90qLZKt1bNakFK//2+S6JQDE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=pKehZHJlCNJJv5kJ8XrvRE9KyLoi31AvGRI46d0u7LiGeUk0PfUNkLgGy5LhhHt0fkSm3JHJqPLnJpQx/FkZmCsf8jihuMAdlGYLbd5p2YPWdN1KklGoqWIUVkxWfnw8zsNegHUGZ/XsWQSfBSG6a2bTb6+Ss8l36bme5FJ/7Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pMYMYvUr; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1ec4c65a091so6210425ad.3
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 09:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714494096; x=1715098896; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rer1rNNi3GrfhpFHRupavXxC5l2J9OfOfjt8KTc82VA=;
        b=pMYMYvUrUMP67k9QPc3tyOCNUJFfsslgpgyDE6n6F4yhbxD8lUu3ZymFkZZgXxQSJ+
         1GxI8EX1hdh7jRKZOvBMdLeDg9WfLtYWgI+9qrARpJiJ/pgTLzdXdLQIIEtETBHeuFXK
         sOprNFaPCUi1H9dx/JjVXdF6j9OlSy8JvbhfBKSedMXMc90Yn4vBF08dMnch/CxU0FDc
         4fqWreWMnTpqU0yP8YDs/Oh6i8MVvhCBw5ftemi3zByIWmcyZdaa5XFBobjX7cgtkkQC
         N6Pgb6YYH2fnim0288WXZ5VAtpt7ga2xcXqUThRNTw7q7JSlHu8iBwlRSErgTb4C5U6U
         ur9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714494096; x=1715098896;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rer1rNNi3GrfhpFHRupavXxC5l2J9OfOfjt8KTc82VA=;
        b=c8hpnIwoQ9k/JTOLwcvhz9dTViTObWR0hA9FBSWiiFjCMHgWLg2pPpYfvA86wIHy/K
         EEgoCswyIMqATNEgMy7fIlxJUqsiL0Hu84XjEBVRrbN3Mt6lv4AqL7yedEKBbe6Cqu7U
         r+D1oaW26Oyv6OLBgZgRWCMgJS3/p+HUTGgGBuIY+NYs8E7qoBJHUiZgJfINlJqa4Pbq
         p1VDev/Hcv9ofBjkVOsAxbe4Z8+ScnohlxwRvXldxbcAr9bSPS+V1y1hwjvYykhOKOpj
         m87ramcyZY+AUQIgtY3UEQamx5jMe0URTpYurTvhMOSdfYlCSaOXd13juo6mFob80UEY
         +8sQ==
X-Gm-Message-State: AOJu0YwFnpeSBpsSEnGYDj9+AG94oQ4jO3NNnkwcROFdRVE0F1kcdxUF
	gS21vQedtmD6vDCCK5XeMzwDUOfgMg/Lkx09GkWZmtLY/+05rvrfvMWdqqZ5zl/Ww8tOXsspxHh
	hew==
X-Google-Smtp-Source: AGHT+IGeUqMbP6R4h4nh3EhJErcbKrhORFlCWKSjyPKOpk0Hi8QmlI02M7JPeFnehnqvb0t+o1MrNi7E1Zg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:cec5:b0:1eb:5bc7:1891 with SMTP id
 d5-20020a170902cec500b001eb5bc71891mr414542plg.5.1714494095950; Tue, 30 Apr
 2024 09:21:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Apr 2024 09:21:33 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240430162133.337541-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Require KVM_CAP_USER_MEMORY2 for tests that
 create memslots
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dan Carpenter <dan.carpenter@linaro.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly require KVM_CAP_USER_MEMORY2 for selftests that create memslots,
i.e. skip selftests that need memslots instead of letting them fail on
KVM_SET_USER_MEMORY_REGION2.  While it's ok to take a dependency on new
kernel features, selftests should skip gracefully instead of failing hard
when run on older kernels.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/69ae0694-8ca3-402c-b864-99b500b24f5d@moroto.mountain
Suggested-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 6b2158655baa..ad00e4761886 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -935,6 +935,10 @@ void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
 		    errno, strerror(errno));
 }
 
+#define TEST_REQUIRE_SET_USER_MEMORY_REGION2()			\
+	__TEST_REQUIRE(kvm_has_cap(KVM_CAP_USER_MEMORY2),	\
+		       "KVM selftests now require KVM_SET_USER_MEMORY_REGION2 (introduced in v6.8)")
+
 int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
 				 uint64_t gpa, uint64_t size, void *hva,
 				 uint32_t guest_memfd, uint64_t guest_memfd_offset)
@@ -949,6 +953,8 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flag
 		.guest_memfd_offset = guest_memfd_offset,
 	};
 
+	TEST_REQUIRE_SET_USER_MEMORY_REGION2();
+
 	return ioctl(vm->fd, KVM_SET_USER_MEMORY_REGION2, &region);
 }
 
@@ -975,6 +981,8 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 	size_t mem_size = npages * vm->page_size;
 	size_t alignment;
 
+	TEST_REQUIRE_SET_USER_MEMORY_REGION2();
+
 	TEST_ASSERT(vm_adjust_num_guest_pages(vm->mode, npages) == npages,
 		"Number of guest pages is not compatible with the host. "
 		"Try npages=%d", vm_adjust_num_guest_pages(vm->mode, npages));

base-commit: 2489e6c9ebb57d6d0e98936479b5f586201379c7
-- 
2.44.0.769.g3c40516874-goog


