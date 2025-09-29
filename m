Return-Path: <kvm+bounces-59042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E825BAA57B
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 20:36:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 093C43C3619
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEC7725F7A4;
	Mon, 29 Sep 2025 18:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KbG4o0W7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFBF258ECB
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 18:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759170910; cv=none; b=T/rE7kzdBt/lC8AWyz6AFFd9YzhXz6hB9C3f5i6BIzI1VxU1ZjhXBT9qAhtAAUMI4HtIqfxJkOVJ4Rz5NsPa5vK/poQ5V0zrPGaizVss7Oa1vMwAsDdpmfC2DrM85HwQCUw35FvonUWxRAOzOdE+6jyu/7R/gba11ToLESfXnIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759170910; c=relaxed/simple;
	bh=fIIb2twrTp+ee3/m37i+hJz/W7LPccSw9IAoxQfZLoY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t/zTr5hGE+158Xy8dJ7kw2CrovpvoA+/DGeisEA5XgTVSzII7AwTb+k8zvFcUpeaxVk1FSycuAwFhrT5BROF1YtHgQpaJSfXj3sDRi3IBkdi/zpH5eh0wwkhYOEAyh1Dg8CXfEAI4ay7KJoi4OjdiEVBV0skkuGB7FbcaLzOp8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KbG4o0W7; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-28e538b5f23so1435525ad.3
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 11:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759170908; x=1759775708; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cXfUqpKd6dHxyOJQiTneWF8LWJFxDmdIGTP3Vx6zlJg=;
        b=KbG4o0W7WwmgZDQU8+KVf3EvYxvjfG1TtzcbGxe1n+OVl4u5seagQxpxcjQjO3mKht
         yqwNZxGXvqrEWED6YjJD2272lhqpr3aif1aOHE0AASeb763yO6MCaj0/qrYEyuJNTB/c
         TgBbPHxFolJihb0JI2I7GUJWwAm9FQeCpN7nBtb7O/7hHW/TYJ6quBcRe9xoRMrl9xqk
         TDUNkAW9wwcbhuO5nmnsd+vnPcl6W8lnLTMMIRB097jZe3SZd5W/LZr1wqWs97dkf1GP
         OZv8KZl1TffOyIH36liCxW6ysJpgZZJ5nB65TRgh7U2dch+LA86WeVeu7bKFw3DXCGUt
         V2xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759170908; x=1759775708;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cXfUqpKd6dHxyOJQiTneWF8LWJFxDmdIGTP3Vx6zlJg=;
        b=Xoq3SljhuUnGfOtiZ8PEfX4sHbK/CHdxEimUziyx2Tvf0jEXpwF4xs00cC72IQLDsO
         bTE3MEXf7PmpMbwBk8gJFopP1ppZJ2FIMgBWknuS/49EbORMyjU5cTjngSFQW0gLewun
         6ei/WiqNf89ym+Pz/e7l3cU8ciCDNmgKFUeJzUQx4kszmayr4W+fq0preVhq2+92DRLn
         99BkraqezU+39wF0hcFp0HavyYVVtRq/D/GQDUHyDGbetxDw0AgNlL8bO0LSWGg7KPo6
         Q1H8sji+YTn6zm2xvnpisLY3+AK8l8yaF2A/9OJdqPn5GiIW9E+uHDpBIduthPq3Vjm/
         r2EA==
X-Forwarded-Encrypted: i=1; AJvYcCUcy2l++E3syuQT3yEtHaf7Nrkj3EznQ6dUJA7tn+BvP/xspjEmJLfW97oZX9/IoqvPg7w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDp+fhrof1O//94AsYyeoN6PNWsmBDDqZQDnJDZLt/d+pDis8p
	m5XxkI0Tq4Se8qTeYsrrRKb+Ib63qgXeXuwmA1R2siLIG5oAdwQHM5wW29ftW8MvWKDhXlvcr7R
	EV9l8xg==
X-Google-Smtp-Source: AGHT+IH981e6NsQ3ClHJ6uiza+16E4T3EA3bY2V9J26shLo1MnL8u3/WqbuFvZSBRvr4YgYDuKyVG4B9ukA=
X-Received: from plje8.prod.google.com ([2002:a17:902:ed88:b0:269:b756:8e38])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:19ce:b0:249:1234:9f7c
 with SMTP id d9443c01a7336-27ed4ac6238mr157088135ad.60.1759170908478; Mon, 29
 Sep 2025 11:35:08 -0700 (PDT)
Date: Mon, 29 Sep 2025 11:35:07 -0700
In-Reply-To: <aNrLpkrbnwVSaQGX@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-7-seanjc@google.com>
 <diqzldlx1fyk.fsf@google.com> <aNrLpkrbnwVSaQGX@google.com>
Message-ID: <aNrRW7RtUgFU8ivs@google.com>
Subject: Re: [PATCH 6/6] KVM: selftests: Verify that faulting in private
 guest_memfd memory fails
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>, 
	Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 29, 2025, Sean Christopherson wrote:
> How's this look?
> 
> static void test_fault_sigbus(int fd, size_t accessible_size, size_t mmap_size)
> {
> 	struct sigaction sa_old, sa_new = {
> 		.sa_handler = fault_sigbus_handler,
> 	};
> 	const uint8_t val = 0xaa;
> 	uint8_t *mem;
> 	size_t i;
> 
> 	mem = kvm_mmap(mmap_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
> 
> 	sigaction(SIGBUS, &sa_new, &sa_old);
> 	if (sigsetjmp(jmpbuf, 1) == 0) {
> 		memset(mem, val, mmap_size);
> 		TEST_FAIL("memset() should have triggered SIGBUS");
> 	}
> 	if (sigsetjmp(jmpbuf, 1) == 0) {
> 		(void)READ_ONCE(mem[accessible_size]);
> 		TEST_FAIL("load at first unaccessible byte should have triggered SIGBUS");
> 	}
> 	sigaction(SIGBUS, &sa_old, NULL);
> 
> 	for (i = 0; i < accessible_size; i++)
> 		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
> 
> 	kvm_munmap(mem, mmap_size);
> }
> 
> static void test_fault_overflow(int fd, size_t total_size)
> {
> 	test_fault_sigbus(fd, total_size, total_size * 4);
> }
> 
> static void test_fault_private(int fd, size_t total_size)
> {
> 	test_fault_sigbus(fd, 0, total_size);
> }

And if I don't wantonly change variable names/types, the diff is much cleaner:

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 8ed08be72c43..8e375de2d7d8 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -83,12 +83,11 @@ void fault_sigbus_handler(int signum)
        siglongjmp(jmpbuf, 1);
 }
 
-static void test_fault_overflow(int fd, size_t total_size)
+static void test_fault_sigbus(int fd, size_t accessible_size, size_t map_size)
 {
        struct sigaction sa_old, sa_new = {
                .sa_handler = fault_sigbus_handler,
        };
-       size_t map_size = total_size * 4;
        const char val = 0xaa;
        char *mem;
        size_t i;
@@ -102,12 +101,22 @@ static void test_fault_overflow(int fd, size_t total_size)
        }
        sigaction(SIGBUS, &sa_old, NULL);
 
-       for (i = 0; i < total_size; i++)
+       for (i = 0; i < accessible_size; i++)
                TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
 
        kvm_munmap(mem, map_size);
 }
 
+static void test_fault_overflow(int fd, size_t total_size)
+{
+       test_fault_sigbus(fd, total_size, total_size * 4);
+}
+
+static void test_fault_private(int fd, size_t total_size)
+{
+       test_fault_sigbus(fd, 0, total_size);
+}
+
 static void test_mmap_not_supported(int fd, size_t total_size)
 {
        char *mem;
@@ -279,10 +288,13 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 
        gmem_test(file_read_write, vm, flags);
 
-       if (flags & GUEST_MEMFD_FLAG_MMAP) {
+       if (flags & GUEST_MEMFD_FLAG_MMAP &&
+           flags & GUEST_MEMFD_FLAG_DEFAULT_SHARED) {
                gmem_test(mmap_supported, vm, flags);
                gmem_test(mmap_cow, vm, flags);
                gmem_test(fault_overflow, vm, flags);
+       } else if (flags & GUEST_MEMFD_FLAG_MMAP) {
+               gmem_test(fault_private, vm, flags);
        } else {
                gmem_test(mmap_not_supported, vm, flags);
        }
@@ -300,9 +312,11 @@ static void test_guest_memfd(unsigned long vm_type)
 
        __test_guest_memfd(vm, 0);
 
-       if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP))
+       if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP)) {
+               __test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP);
                __test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |
                                       GUEST_MEMFD_FLAG_DEFAULT_SHARED);
+       }
 
        kvm_vm_free(vm);
 }

