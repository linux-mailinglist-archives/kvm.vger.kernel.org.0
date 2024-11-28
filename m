Return-Path: <kvm+bounces-32642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 722C19DB07C
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:58:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1299FB235A2
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 00:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CDAD14658D;
	Thu, 28 Nov 2024 00:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2QCVFgUT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F0413DBA0
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 00:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755367; cv=none; b=S3s6K6xNA6YgtLZc7n3X5+U3eOl0aMBuasJ/q98eJ++1vTQcX5pgLDxT6JpGmSGEhW42LNOM4F2GKDeYyOI5QhydwKy3NWl5p/LJNIlcW9JZaEYHUhBbXSuEkxb9mE3VzgU+Aq0d+CIyX9+4odTsA+sW29sc+acgowkrNoqNyxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755367; c=relaxed/simple;
	bh=aNYWrhV3+Hlqkeo6/DSEk9PQ+DunnQgH+0LyxQ37ZvY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I542vN0UtMJkOv4mM/TNiOF8vFOe2zFUhZ1TT0U7yFVniwk5Vfg9/53rokiGykd1H5KimIqWUrbIpzDteQ5nVlwPMzy+JRLXpQAswhZjyvtd8Qoqn1AAR+3Y5D4gBoEr9Y0apFtoMAU0U3jqv/gLtP/2AyU62XZ0Tri5jhVlcfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2QCVFgUT; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea5447561bso309259a91.1
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732755365; x=1733360165; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=m3N0I2xWsrfV4i9nnr3KT1Cpmm4B4GrEhZX0cF+2Gqk=;
        b=2QCVFgUTqg42jrqoJJlSe69N1DGudTAzLkpZgLaDN+H94GlnnaSOsVn9F/mUxiqxnf
         QhbECdSFLTqECkq6YppyZZ2bkUE9YTy37KWlPEYXxzqSIwVnfghbQ9NfoZ56EPFscgQU
         /KUaYX7n9unHO40bBmYhF+I+ANnLCUSb9Wjfm4r15/RXgjLuJkhgyrCorrPElKj7RFFw
         TzpaLecjBqY5Wxd6g6iCyowrWMK57SLaIcNJ1Es0Xd16bp7VzhMQajMp75+RJfhbBgp5
         EA0ohdTE49Zkn9bobsd3FVcQma3YZhlsM40rSs2kqHIyMqSzqzjLwQoUKE4NO9zsNdKl
         yxgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732755365; x=1733360165;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m3N0I2xWsrfV4i9nnr3KT1Cpmm4B4GrEhZX0cF+2Gqk=;
        b=OMI/LGc0t1TD36WLm3lTJk3mlD0zJXqyGBkW94IiApvADWdBnQR5PtB4XDau3+OBjZ
         eJMP9iPRfMnN2d8Gy1BXToPz/PLydWaPAJnJodgZUzejVEIUFG4HLRPviT2nQe5wud3p
         PagNQzjpbylTJZvAkY1QOP11gxULwz/5uYYgthymiyF6Sdciif6ZgOGhP7P2FUhNtY9D
         TpulDnoakgS57X/cXi2Ds5iW3mTRFFQsWsAQZ0NIrQ5Jo06uHThVUQNWmd6ikqLV22iF
         jGzuG0MweBVkSnJ0EBB3CgGIDSlxj8kPoWghZrgqNIyLRIQxNuNsQGUl0ODkFGiVX1wJ
         3T2w==
X-Forwarded-Encrypted: i=1; AJvYcCW9SALMMf7htmzaTdPp89NbvBJ2ShJM4H0gP757UV16XcJAaNPXRLRNbYUzAQ6UoIOQxnw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzb1xOIeyVoi6y/lUa0+ASyZJEHmpPSMB+5KQZoI1a9OZH/r2jx
	8TJ3YDcYT/dgkHEbVOgkPZ4ZXtqlxClj2SJPKm9YJ9s4wq6W2l/0ZYIfZtMCRPYlQSzuq22MoM7
	7CA==
X-Google-Smtp-Source: AGHT+IE4OA2YWpjZt4cUyGKEolrSn+wbKfMl6eazhCePp/W8mIleK1HW5p9Pm9svs3J06p9qg41Q+800XRI=
X-Received: from pjbsn5.prod.google.com ([2002:a17:90b:2e85:b0:2da:5868:311c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:28c6:b0:2ea:6f96:6504
 with SMTP id 98e67ed59e1d1-2ee08e9c7a3mr6508990a91.1.1732755365479; Wed, 27
 Nov 2024 16:56:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:55:40 -0800
In-Reply-To: <20241128005547.4077116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128005547.4077116-10-seanjc@google.com>
Subject: [PATCH v4 09/16] KVM: selftests: Enable mmu_stress_test on arm64
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="UTF-8"

Enable the mmu_stress_test on arm64.  The intent was to enable the test
across all architectures when it was first added, but a few goofs made it
unrunnable on !x86.  Now that those goofs are fixed, at least for arm64,
enable the test.

Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>
Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 4384e5f45c36..c59a337cd4da 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -180,6 +180,7 @@ TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_aarch64 += kvm_page_table_test
 TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
 TEST_GEN_PROGS_aarch64 += memslot_perf_test
+TEST_GEN_PROGS_aarch64 += mmu_stress_test
 TEST_GEN_PROGS_aarch64 += rseq_test
 TEST_GEN_PROGS_aarch64 += set_memory_region_test
 TEST_GEN_PROGS_aarch64 += steal_time
-- 
2.47.0.338.g60cca15819-goog


