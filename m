Return-Path: <kvm+bounces-26426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BB849746EF
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 01:56:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E433B285F3C
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 23:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE4201C3300;
	Tue, 10 Sep 2024 23:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XCVC0DPY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784121C2DC1
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726011934; cv=none; b=efmti6QuH1C7CflypbSsDw3KgbIq0mMOdFTD4WmjxDC4gPwlZO3it+7u3K5ndMwntN7d/GGLcXFmL1UiChQt/JuCZnG4WkhKL9tW4vRKN9f3OTtSeG23uygvmIIJfKwowObxTktbSX6PovnZuSJJ6l8C8ponRyak1XxhUY/bqME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726011934; c=relaxed/simple;
	bh=iM0jj8S3VKYKj12HU0Sug/HTfaVLGaHYStfmhvHzgm0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RGVqNfHDrq5oTwxYbQOUEU9tkNZrC65DDY1fF9SN4UKy9LejBqSD7ZQ507DWG+5fpt3K92wOyX6T5FBYm+EptSJJYItZvYcrEfZNGfMYp+mZ1JmRz8he76SAhUP3n6Ncj8Nc3lJvOHQMZyZ/mkaHPTSDS/PLddb7dGAHyxtDKdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XCVC0DPY; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-718e82769aeso2115060b3a.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 16:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726011932; x=1726616732; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AYJem9uK2cy9PiRW4XqF1AVoy187cj8pbxn6tsiytpU=;
        b=XCVC0DPYnM33AnLjbbAdn960pEa8qXpOSY3DLkgnNQ31m5/hsUia+5fxEifie4GArS
         Jew+A+/rskLpbRo9txVq4LtmGFcRuYKaFlxgHDtexf/2OGi2syYrAtOQl6oxrFRmcIU0
         SwGFcqCrzSTEux8Yrf/4ePSnthLl4Hbns4DurCCaPQFjRRMT6JeEdl11rcwL5xYdsee+
         RP62YB5I2MrCCTFiLq8TaOEfp+JqJlWi24taGtSMjYwr1nI8RF9YvdV5qbVfuOQbBqev
         IpThbkFsCVWwlTYniRsvBcw53i7Fj+qAF8m8jmd2byDxR9aepbRPaXACEAoONf4nYGpb
         ATqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726011932; x=1726616732;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AYJem9uK2cy9PiRW4XqF1AVoy187cj8pbxn6tsiytpU=;
        b=lW9Rflmq73OwIQzkpGNRUM6574dG8mRRwCPEXWHfnxb8x2xZ4+DRRkJevtb0ZuPuhQ
         MhY7Dje5+dpAhy++EImh1m3q3Bmb0R9vC4Sq4DUvM+n9RG4HyJ4/3s6hoKDZNAWJw0gQ
         bzP65LSfNN1zaz53s8rgoFArUPoSEao6/BXZGnEI/F8yHuDuZbjJYowYhRkEIGxYDhwE
         +TDNnV2pDlYfcBcKoRYhM9TbEUoEJF1NXcifcgM7ZsasQnFCzKOGEHR8qmIvYEb4voHM
         S2ZLmD3e2UkxDyoUpeYO8An2CPavzlwOkFWKjeNrFmnRk2CEIWPG1b0vKuc0RheT0979
         hj4g==
X-Forwarded-Encrypted: i=1; AJvYcCXzuveDLwyGmexHHReGibFJjYoWgtTodZQBaY8CE8/iP2zR+EzH7kvLW6x5XmpdtTs7HNU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHaThHoLP5jQY3w3fuTnJJ2zh8Dxl6bl41yP9Hk75Rh/hlFtIo
	m/E5lOvO5iOwNoWazee8+5IU7l52PnaTULlCmDFLcZXRq/ezaVpMrydJlvAJDBO7SE4JUqTHN8e
	Sj0S8M2/oYkXSMdliCDPsaQ==
X-Google-Smtp-Source: AGHT+IHaymwmA0a5qHgrrgMyaOagseBsBxvzMqXn3tRr1+SR9wD08VNMmkUJlj2d4F4z5ptyADsmNrcNJBVUlk0nKg==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:aa7:9390:0:b0:706:3153:978a with SMTP
 id d2e1a72fcca58-7191722c371mr2134b3a.6.1726011931559; Tue, 10 Sep 2024
 16:45:31 -0700 (PDT)
Date: Tue, 10 Sep 2024 23:44:05 +0000
In-Reply-To: <cover.1726009989.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1726009989.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <0ea30ee1128f7e6d033783034b6bc48dfbabb5db.1726009989.git.ackerleytng@google.com>
Subject: [RFC PATCH 34/39] KVM: selftests: Add notes in private_mem_kvm_exits_test
 for mmap-able guest_memfd
From: Ackerley Tng <ackerleytng@google.com>
To: tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk, 
	jgg@nvidia.com, peterx@redhat.com, david@redhat.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, seanjc@google.com, 
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev, 
	mike.kravetz@oracle.com
Cc: erdemaktas@google.com, vannapurve@google.com, ackerleytng@google.com, 
	qperret@google.com, jhubbard@nvidia.com, willy@infradead.org, 
	shuah@kernel.org, brauner@kernel.org, bfoster@redhat.com, 
	kent.overstreet@linux.dev, pvorel@suse.cz, rppt@kernel.org, 
	richard.weiyang@gmail.com, anup@brainfault.org, haibo1.xu@intel.com, 
	ajones@ventanamicro.com, vkuznets@redhat.com, maciej.wieczor-retman@intel.com, 
	pgonda@google.com, oliver.upton@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-fsdevel@kvack.org
Content-Type: text/plain; charset="UTF-8"

Note in comments why madvise() is not needed before setting memory to
private.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86_64/private_mem_kvm_exits_test.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/private_mem_kvm_exits_test.c b/tools/testing/selftests/kvm/x86_64/private_mem_kvm_exits_test.c
index 13e72fcec8dd..f8bcfc897f6a 100644
--- a/tools/testing/selftests/kvm/x86_64/private_mem_kvm_exits_test.c
+++ b/tools/testing/selftests/kvm/x86_64/private_mem_kvm_exits_test.c
@@ -62,7 +62,11 @@ static void test_private_access_memslot_deleted(void)
 
 	virt_map(vm, EXITS_TEST_GVA, EXITS_TEST_GPA, EXITS_TEST_NPAGES);
 
-	/* Request to access page privately */
+	/*
+	 * Request to access page privately. madvise(MADV_DONTNEED) not required
+	 * since memory was never mmap()-ed from guest_memfd. Anonymous memory
+	 * was used instead for this memslot's userspace_addr.
+	 */
 	vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE);
 
 	pthread_create(&vm_thread, NULL,
@@ -98,7 +102,10 @@ static void test_private_access_memslot_not_private(void)
 
 	virt_map(vm, EXITS_TEST_GVA, EXITS_TEST_GPA, EXITS_TEST_NPAGES);
 
-	/* Request to access page privately */
+	/*
+	 * Request to access page privately. madvise(MADV_DONTNEED) not required
+	 * since the affected memslot doesn't use guest_memfd.
+	 */
 	vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE);
 
 	exit_reason = run_vcpu_get_exit_reason(vcpu);
-- 
2.46.0.598.g6f2099f65c-goog


