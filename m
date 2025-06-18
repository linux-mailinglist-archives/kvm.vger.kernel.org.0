Return-Path: <kvm+bounces-49801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 940E0ADE27B
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 06:27:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5547A17C4CE
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 04:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48A0221CC48;
	Wed, 18 Jun 2025 04:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YYW6d+9e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFD121ADAE
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220684; cv=none; b=ZyZVrejoH1NrPiJ8ckfU9f/R6VuuzIu3myhkiEz7hGlCRkabkVvZVr3y3OSMyy9fWsMM2ozXN3JYSkFnWuuoJOHzLeItbTQ5TjwoOoiIojqaHCzv3oxNRxvwGzW28LBPUQenX9sJRroIEZD5eXP2SRDa4gLuFdNoceURUat16aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220684; c=relaxed/simple;
	bh=Xd+l4yVTMF6sIq+heJRlqv5EUOVaKyXfY1hn736d6Rs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NQOjuVKqGNda29u5UrGnZJzkx0dIUN+5nBYDRJns/+WapxbMaNIJAiTLqSPoQMfAcQuSF1Jgb3Ock3k68GQWCIoyd/GiSXljGwGJ10jmwKJICx1MrLaarwQ7iSfGwDyThiA8Hk+kri8D2FoLQ2WDCvovMO+k1luvmtNRxhsVZQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YYW6d+9e; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-234a102faa3so44040855ad.0
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 21:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220682; x=1750825482; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TiynHwWK8Tuc2ZhwblhQo9IFn5bKLScHdC3X2XmCKdY=;
        b=YYW6d+9eImKQAgLAFa/YIPUW9l+Xnlyp9slQjm2pzdPCEQLi93rzOOvBqXGZUU9SgW
         Kx4TgKxRyrpWYXeBsu+SDbIrr5q9Dq+nLG9l7BQWOleypkPY5DGYpA7YTi69dI5hSaTI
         DLbsDfTLnc+smRLv2OLzFSiRMwNKk6DEPjA6X9N76dKa1fXG31J79/SYhXI74Xh7Ssd3
         f4uOQdm9kJgaMu579duK7o3kAJyZco8dsuw7cw2HO8IPM+8g3J5ks8wHP8tRmSbUiMSo
         8AkoiK1X7g/85jz8shIIVKZCWrBaqyilUMJcvS6UfaOOih3xtahjJGBoRT0Q1Fg1NrEU
         5USA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220682; x=1750825482;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TiynHwWK8Tuc2ZhwblhQo9IFn5bKLScHdC3X2XmCKdY=;
        b=Z3D+xsvhEKyO6bTxe8QweTCXMFjnDlzKoLRDQGNQcRls9QqQcugh+JbRzphSGXHmKq
         iWwfUEWjKKgV32qxXnk1S0smmOGbEYnCYlFc5LT30SXq+XEXMea3fJY8F+GPGULp6yM7
         oPg68jzCSUg4eCUM5tVG5fTMlKKhuaRSJ92W7JYLfBuym4EFhMrEk/9trFMlrg56H7iR
         t0L8KBqj6oyH5/0pqfRow9qh7bH1pkbxibo0KkIJbK+R2gZfxP3vbBDTQ+NhwgkZpjxU
         hjYwv7wF5c+DqDwptCkOTkYZ+EeTILDROw3/F3i2ib5ntmJvi9H7jDGeDuryW2/juJsd
         AvWQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+YomrKVOhrjgXcAFvdPJStRGPkilqfHyDnFAaVz6opeu1UU5ajTXsRHCFbGXV1/TL3FQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywz4ofmfB7Ymm6zvVr34dmF29tP27ZcJDikcp8WLzyCeZW0iyQS
	8hh1+xYv/yf4c4f6+RNo0RUoiRY94xqgWD+MQsQfWF+OOtvwh1nupXcpmTmdeQ6JuHSNEIPOnmk
	qDOJGAUZvEm6RL+qQ4mM6uw==
X-Google-Smtp-Source: AGHT+IGRuVATub0VagSwSO594ph7F/RA6BsWrOduHNPJT0NSOVEpTFRu1SVjCYkpWfQ84SvEpdSv99cmJKRK2o6P
X-Received: from plbka7.prod.google.com ([2002:a17:903:3347:b0:22e:4bf7:1cb7])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:cf0e:b0:234:d7b2:2aa9 with SMTP id d9443c01a7336-2366b1221femr249131655ad.29.1750220682173;
 Tue, 17 Jun 2025 21:24:42 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:19 +0000
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-11-jthoughton@google.com>
Subject: [PATCH v3 10/15] KVM: selftests: Add va_start/end into uffd_desc
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

This will be used for the selftest to look up which userfaultfd we
should be using when handling a KVM Userfault (in the event KVM
Userfault and userfaultfd are being used together).

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/include/userfaultfd_util.h | 2 ++
 tools/testing/selftests/kvm/lib/userfaultfd_util.c     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/userfaultfd_util.h b/tools/testing/selftests/kvm/include/userfaultfd_util.h
index 60f7f9d435dc2..b62fecdfe745c 100644
--- a/tools/testing/selftests/kvm/include/userfaultfd_util.h
+++ b/tools/testing/selftests/kvm/include/userfaultfd_util.h
@@ -30,6 +30,8 @@ struct uffd_desc {
 	int *pipefds;
 	pthread_t *readers;
 	struct uffd_reader_args *reader_args;
+	void *va_start;
+	void *va_end;
 };
 
 struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
diff --git a/tools/testing/selftests/kvm/lib/userfaultfd_util.c b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
index 5bde176cedd59..31d38b3a9d127 100644
--- a/tools/testing/selftests/kvm/lib/userfaultfd_util.c
+++ b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
@@ -152,6 +152,8 @@ struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
 		    expected_ioctls, "missing userfaultfd ioctls");
 
 	uffd_desc->uffd = uffd;
+	uffd_desc->va_start = hva;
+	uffd_desc->va_end = (char *)hva + len;
 	for (i = 0; i < uffd_desc->num_readers; ++i) {
 		int pipes[2];
 
-- 
2.50.0.rc2.692.g299adb8693-goog


