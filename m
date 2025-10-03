Return-Path: <kvm+bounces-59489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A1B7BB865B
	for <lists+kvm@lfdr.de>; Sat, 04 Oct 2025 01:30:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24A1D4A82F5
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 23:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E66142E1F16;
	Fri,  3 Oct 2025 23:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o0OPp5Rg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88022E0B71
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 23:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759533997; cv=none; b=HtefRj+nosFwqMcreoWYByu+8S/NXTb9w4nxR4Id/R28Ude8rnJzaD2uJ/xlhYEopxmjCLoOznZJJVUHGF0OxE+FX7aGsdRVtiAjTb2p95aOBsPMJCuyKQUdsH7BnAuEQd6MELC8gdcJhP3QyzWcJ1njrVZIWplttA1hPS37ylA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759533997; c=relaxed/simple;
	bh=A35jNQC/Y3RxjqGBQN1sEn/RRSyfIzES/2AECjIpxI0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oq3v6pdW7PSH3Abr+EWKwuEYlN+Xftatz8DyOrWnUZsU+Te3heMxnYBkPJicW1hx82BCfgV44nsw3sAHKVrtCdi42O3xy3VlKJXfpvfL8LuZ3R3sBgWjYFD/6GUY3q0z5DBrdMgSndyO6RWITgaSp5si/BEAxg25kge5eFDsnUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o0OPp5Rg; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77f5e6a324fso4425761b3a.0
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 16:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759533995; x=1760138795; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZziZ37GNo1v+A7DeH1fg1jRwXSNmJJcf2TnA0oS/lkM=;
        b=o0OPp5Rg6ks8tA1BePwlhBcQ6fU1NJh63XbxX3KeDdCKHstkPfuDmTI1mXqXdMeSd7
         BQtqvjd5vqhb0waGIdR3gBuADdZC4diam2Sjp4UbOV/7H6JDwjNRi6fj1Lf8uY5xtfz/
         6H/EDQTF2i8EHVBOqnNVLSr0xNHwxCCoiC2jv/iRa7qx4FSZ1FMj1ne69VyAcws8eY2Q
         Z5/pqhNwS9jyqKQZNSSz/UnZVDMwNP4s1H0cNsrA2SmHbzd5Q+1nDHVNQQ07d0ZmTsm+
         /jS/h3XkPHsICCK3MWFIA/rmlVjo7EwZxT8cCyr4tCzqleBtKtVh6nO2f/dF/NgWlt41
         QIuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759533995; x=1760138795;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZziZ37GNo1v+A7DeH1fg1jRwXSNmJJcf2TnA0oS/lkM=;
        b=lK/SWOXSLL5MOLBFPb2PGYFWksfWS8cXWu89JbUJgXUXkyO5TfUROb3snKXs5RYcf/
         d3cee9EZGQIFQ3O+WTATVD7Qa4rDnapnNnhTCiO5eolqRKMoJbLBLInBQTiFDLOPRKJP
         Oz7p+G1+aB23haarwnaU9DiIwVa9LfNB5v3P0r4idiMB5oGOQ77rncpc1UV60GgnBS90
         /sDAeuD8LLUF5MXiwzoAG523IBwJsnpUBFHl3uWp8iGpYQP57pefseYxwFcVy1zIRT2Y
         18jqMI1wwtu2N2t6P7ieKW5f4ZbyWijDNahCJ1wfzZzMhJrCjYjaOX9m7Ybz6e6BDtF2
         2SUw==
X-Gm-Message-State: AOJu0YxMQJAvRY3gtRvfv1pJXlZQt7Ctb1PrHpOMUTPUbr2BjdiFRHDx
	p2h+Q4tEL3mKPddMtOCP1K1UI7962HrIjGCxSmzokGe/Y2ZK6gCM73jsF/EVydwdqolBFDFPUz1
	fG41NZg==
X-Google-Smtp-Source: AGHT+IGI45fASbGk78+EH7g4G06WAQxAWAI94Pfy4l7ikWrEGD/iRpekgctqMyc+R3oC7uyXtSz62tBnv3w=
X-Received: from pfjd14.prod.google.com ([2002:a05:6a00:244e:b0:781:1b2a:49c9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1301:b0:781:19e1:c4c8
 with SMTP id d2e1a72fcca58-78c98a6a5e1mr5790329b3a.9.1759533994969; Fri, 03
 Oct 2025 16:26:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Oct 2025 16:26:06 -0700
In-Reply-To: <20251003232606.4070510-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003232606.4070510-14-seanjc@google.com>
Subject: [PATCH v2 13/13] KVM: selftests: Verify that reads to inaccessible
 guest_memfd VMAs SIGBUS
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Expand the guest_memfd negative testcases for overflow and MAP_PRIVATE to
verify that reads to inaccessible memory also get a SIGBUS.

Opportunistically fix the write path to use the "val" instead of hardcoding
the literal value a second time, and to use TEST_FAIL(...) instead of
TEST_ASSERT(false, ...).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index f5372fdf096d..e7d9aeb418d3 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -84,6 +84,7 @@ static void test_fault_sigbus(int fd, size_t accessible_size, size_t map_size)
 	mem = kvm_mmap(map_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
 
 	TEST_EXPECT_SIGBUS(memset(mem, val, map_size));
+	TEST_EXPECT_SIGBUS((void)READ_ONCE(mem[accessible_size]));
 
 	for (i = 0; i < accessible_size; i++)
 		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
-- 
2.51.0.618.g983fd99d29-goog


