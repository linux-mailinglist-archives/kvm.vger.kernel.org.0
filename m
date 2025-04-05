Return-Path: <kvm+bounces-42774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08C6FA7C6D5
	for <lists+kvm@lfdr.de>; Sat,  5 Apr 2025 02:11:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95DC13B82AC
	for <lists+kvm@lfdr.de>; Sat,  5 Apr 2025 00:11:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E699AC2E0;
	Sat,  5 Apr 2025 00:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HZJjVgfU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96448A32
	for <kvm@vger.kernel.org>; Sat,  5 Apr 2025 00:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743811849; cv=none; b=JwGU6oAZzPjiH6Veoj+lbUFZVsvT06iTJbwdALNDEBKXbh41mR6tr0eq25FINp9goKtcD2e/X7uTzmwhFoByJP7/se+acsOd9Qsfo36zOETTSgE5gzrH6IbBvwclw8+FXT8jb/0CUi0E5V9pKi8XDJPnYJHEFN0Np2TYpRFt+2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743811849; c=relaxed/simple;
	bh=eb9ivKenV6eSeMfJ8jsJ4zcf/HhA0ll43TAeZRApRYE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lBLsHWWkogDf5Z3qybC0sKyqfvkl7ic+Dc5Oe5M4yVJh7q92ZXBYZBIkFDTVLLe/v1O67LOZlIduyoPTjUrYDUVjIofQsi4Op0E6gcDtWQ7leQiQw6UodPp89F0NeSM7uN1Bv3MQCwsCr8UM18LxK+si9yFdH0PWYv3nyb9ZZts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HZJjVgfU; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-85b5a7981ccso227761039f.2
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 17:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743811847; x=1744416647; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pe2bIRfllqLhJxxHpJNmnpza0I+tDqutdvnRlHikMBQ=;
        b=HZJjVgfU7N7pa6L1D0+d8FOwL6YmONikNUdAbK2u4bcAcLaEGxnqbaHFYyFsOcdeMk
         8iFvDch1eLKL22N3w1bt5hN92AoicwYHpTfgVPYSyZDmeGplVrfLgUXK2ijKYV9IuvK5
         5L/1r5jnsN33IWmM6wzZcDanwTsK7Z/pCdMlTkHPSkH3os7S7naojAYZYL4MVU9qn948
         6wiAn4cYYICZNViupPpw4Km6mkoZHTIDPknUAw6pC4hPFqunkCkmLrc1tdPi7j/tsF3L
         2za3n8TlmZMABPed312qYh3n5FHpodACepxf7zHnzPgPpwxkBlDu04m0/yCeBYWiOjAd
         27CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743811847; x=1744416647;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pe2bIRfllqLhJxxHpJNmnpza0I+tDqutdvnRlHikMBQ=;
        b=UPMZH9JCI+4yNXI49sgAc40CXkKUf+nnNl2IwYvfNFifUcbjy8Qfig/3O0rkF7NkOQ
         vkZPitCYWP3f/yPI0bu3xUkGkZgGPBzCeeGuiXkbCIJKSh1cUkvq+RTiBRYJ0KnF5VJV
         4hS5H3+BE50ZHdPG+lhlgj/mo0NODhE38o8Nw5nU5MS8X/LxShDspWtop4a2gsRbwSGH
         aXqnyq28SdITcv8wrF2At1bOJfWVobZMOu+YPW8H8OKUkApJ8pFbNVuiCim7TqMnIu54
         FiZGRCgC37u3KBXoKQQCgwOUzTsi2HcyJgkNkBD3NdaYwx8kunm8R+t+gR8jUV+meZno
         kRmA==
X-Forwarded-Encrypted: i=1; AJvYcCWlVPu7TgA2UYob+x6/qdkRsn/6cGmvfPG76e8goYgpwyaorbqDzDf9speMFekfTNKZ/18=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx346O+A4wQV9pK2EyoKgCvFagq2zL9q5ogyp7gfvUwfgLE/26n
	CGhrygMy58ZTnqoNvCiooZEa593mGNJS4DxueN1XH8ieS1IIwoo12YFTgQYwM7idks/08oMhqv7
	2F3HsTQ==
X-Google-Smtp-Source: AGHT+IF1StR86BOR3Add0XYDFbLf59K7X1ePZtATYMdVN91h6vHs+7fhLEgNJ0U//lXVpSgwej6JAhyyVci0
X-Received: from iovo14.prod.google.com ([2002:a05:6602:13ce:b0:861:1f46:a1e3])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:3a09:b0:85d:b26e:e194
 with SMTP id ca18e2360f4ac-8611c2f92e0mr488329639f.7.1743811846805; Fri, 04
 Apr 2025 17:10:46 -0700 (PDT)
Date: Sat,  5 Apr 2025 00:10:42 +0000
In-Reply-To: <20250405001042.1470552-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250405001042.1470552-1-rananta@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250405001042.1470552-3-rananta@google.com>
Subject: [PATCH v2 2/2] KVM: selftests: arm64: Explicitly set the page attrs
 to Inner-Shareable
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"

Atomic instructions such as 'ldset' over (global) variables in the guest
is observed to cause an EL1 data abort with FSC 0x35 (IMPLEMENTATION
DEFINED fault (Unsupported Exclusive or Atomic access)). The observation
was particularly apparent on Neoverse-N3.

According to ARM ARM DDI0487L.a B2.2.6 (Possible implementation
restrictions on using atomic instructions), atomic instructions are
architecturally guaranteed for Inner Shareable and Outer Shareable
attributes. For Non-Shareable attribute, the atomic instructions are
not atomic and issuing such an instruction can lead to the FSC
mentioned in this case (among other things).

Moreover, according to DDI0487L.a C3.2.6 (Single-copy atomic 64-byte
load/store), it is implementation defined that a data abort with the
mentioned FSC is reported for the first stage of translation that
provides an inappropriate memory type. It's likely that Neoverse-N3
chose to implement these two and why we see an FSC of 0x35 in EL1 upon
executing atomic instructions.

ARM64 KVM selftests sets no shareable attributes, which makes them
Non-Shareable by default. Hence, explicitly set them as Inner-Shareable
to fix this issue.

Suggested-by: Oliver Upton <oupton@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/include/arm64/processor.h | 1 +
 tools/testing/selftests/kvm/lib/arm64/processor.c     | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index 7d88ff22013a..b0fc0f945766 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -113,6 +113,7 @@
 #define PMD_TYPE_TABLE		BIT(1)
 #define PTE_TYPE_PAGE		BIT(1)
 
+#define PTE_SHARED		(UL(3) << 8) /* SH[1:0], inner shareable */
 #define PTE_AF			BIT(10)
 
 #define PTE_ADDR_MASK(page_shift)	GENMASK(47, (page_shift))
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index da5802c8a59c..9d69904cb608 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -172,6 +172,9 @@ static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	}
 
 	pg_attr = PTE_AF | PTE_ATTRINDX(attr_idx) | PTE_TYPE_PAGE | PTE_VALID;
+	if (!use_lpa2_pte_format(vm))
+		pg_attr |= PTE_SHARED;
+
 	*ptep = addr_pte(vm, paddr, pg_attr);
 }
 
-- 
2.49.0.504.g3bcea36a83-goog


