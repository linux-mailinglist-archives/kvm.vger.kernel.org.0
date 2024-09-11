Return-Path: <kvm+bounces-26583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC5E4975BF5
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 22:44:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE1EB1C2260F
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 20:44:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 134D61BE221;
	Wed, 11 Sep 2024 20:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yw8c9b2R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261941BDA88
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 20:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087362; cv=none; b=kxOCJI0C16uymoec4Y9WHd5hxJk20HqT7J7SWHK+Nxj9IIOSc8mjbnsuvaxeTXex4F9T+QWbkNFfISshKcWtZVwNcoXmexPpzdD3+17yGimFT1lOb5awsWFHxN/FPHOXYyqnImdbUr2eepneOXfIqe0zXEgLbijIMMqlhW+AbSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087362; c=relaxed/simple;
	bh=gMePtUPb5fvMNYGIlnFPhk6LbY7QAcbzAoZpHwWYGO8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NvHM5KUNeYt6/dKPujb0ZjhbuP7ijKj0ozExff3Q0sRymCJnUX8R6VlNKTEEu82aysLUGhpn5sDgHGBBUcH9LeU8Vk6dYdgF7BAp+KMsPksi5hX51x03Z+DxETUO9+GMvebj9wBjP+POfZRSKkL4NEmnD0yNcYAozMh1me4eUiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yw8c9b2R; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7c6a9c1a9b8so547307a12.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 13:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726087359; x=1726692159; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4Mm6F1KdfaC470dFwf81yhaZh6FdF3AX9IDG0p0k3Sc=;
        b=Yw8c9b2RZEBe0pPMF77ouMoX2IDLc5gqALGEBWGO5wWKo5fWm6OIXd5HeBeaxvi+Qr
         x0Gp0zswLeKcKJHRKZbgNIWdNtZaCe7LtuLXO6t8xeantMvkG99PLQK2jcncNYw4ZlVL
         sEE5WD6SoDfgE+GlPQm0afCVl6mbEn55/C/D8EI3c//MdTwNrL8wDobCiu9PCB6oH5vC
         dNUzizv2mPep+qGkHtvKgW0yr7/rO7Tah5oCe0iSff8hzJidweBO3XpcDvjqlITn6BNQ
         jB508vWvX9lNa02e89GcobLgpmdPEAPwftPC2OsZeO2ITnqU/ThGJEogHmmDMxB3VTFe
         a3jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726087359; x=1726692159;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Mm6F1KdfaC470dFwf81yhaZh6FdF3AX9IDG0p0k3Sc=;
        b=HXNo8TVxL4bJosMUok2m8kbVWWkmVl8INwvph5Z15aPFG5hYFsYArDiTHnWQtnphLl
         bZ+nIC1A8Z2vkuNI1hHcurwsANQ892Rx7IyM8wgJS+W3l0ZJbcZOB+qa4cdEqdjSztI5
         SicYyuckZ1k2fximZ5OZFaJfvsSn1MBWbKQsQr9M2OXtFeZYx7rlTUOsbf3XSNfMVGV2
         jEkJtga8CQD+KsRva1fPETKt2a9DR0HUDHsKk0/K9k5OPMH5VuM1CfkZXwKRGo+9yzKh
         U0WJJ4PLqZnNWQIJ/jzKM8ZJf3QUZFzhvGHaaFR/Pa2FokFqW+55VyjOOhI3iMS/C7a1
         mBjg==
X-Forwarded-Encrypted: i=1; AJvYcCVnq76+SraObuSMaQxfteVbBt4fsqT/48b3Bd+wZonKroDBAlOwdFjsJEunlZIR4a+e0t8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKjxcWjxHBebYwezu4q+oLuuHUHSlqMg8V3tRk3RxPKgliXYnf
	6aTLm6A7OrHlIV1ImjY8hmETDHQkT8ZsYWl+hZx/iaH2xdVXlgQVWEwVJF7yQGY+Pac8JqM26Pr
	8Yw==
X-Google-Smtp-Source: AGHT+IH2JHcNsNqRshbivfFJlAxw7IQtkbHmI9wZd8VBGGSLJ0WTJqdKfu0VETV264VsvIEa8GzsVh026XU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:4a5:b0:7db:18fc:3068 with SMTP id
 41be03b00d2f7-7db205d627emr1361a12.5.1726087359304; Wed, 11 Sep 2024 13:42:39
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Sep 2024 13:41:54 -0700
In-Reply-To: <20240911204158.2034295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911204158.2034295-10-seanjc@google.com>
Subject: [PATCH v2 09/13] KVM: selftests: Enable mmu_stress_test on arm64
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Enable the mmu_stress_test on arm64.  The intent was to enable the test
across all architectures when it was first added, but a few goofs made it
unrunnable on !x86.  Now that those goofs are fixed, at least for arm64,
enable the test.

Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 93d6e2596b3e..5150fad7a8c0 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -174,6 +174,7 @@ TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_aarch64 += kvm_page_table_test
 TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
 TEST_GEN_PROGS_aarch64 += memslot_perf_test
+TEST_GEN_PROGS_aarch64 += mmu_stress_test
 TEST_GEN_PROGS_aarch64 += rseq_test
 TEST_GEN_PROGS_aarch64 += set_memory_region_test
 TEST_GEN_PROGS_aarch64 += steal_time
-- 
2.46.0.598.g6f2099f65c-goog


