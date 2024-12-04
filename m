Return-Path: <kvm+bounces-33072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EF889E4457
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 20:16:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DEDB316697C
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 19:16:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8300206F02;
	Wed,  4 Dec 2024 19:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RLzC5YlO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com [209.85.160.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4696A202C2C
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 19:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733339665; cv=none; b=levTNTcwAaG5Jjt7e5o9EwUqdddDZtiP5KyJ2B4qKMoV7YNar82rdA0M2mGnNfSpiYv5zc3ykoxz4F0Y9c0ETJwO2nkZ7uOU/q/foIaj/Whtmh6hPc+n7SYe9MPsu7uGQsMDcpua3GOE7NlycDFWNDjaVqRrpmcnic7pxDNM2DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733339665; c=relaxed/simple;
	bh=xFw8gMJXJ08WDMuWWWZTgPnAYLLdNgG37mOiDKQ6GfI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D+dq1PsvYWDuXjeUz4li8afmS6cWttBsV487svbEihRMkfEkPbAXcxXUjpoHk5s3PfONIYPtR1F9RSMXXVpbqsz72NR77Mg/6xM7S3zxZvJBOWMw6Oqk0y87pn8hc/WC1lgHn35SJWXg8+9RtffMnGShewH4893ugpr6wUE+YDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RLzC5YlO; arc=none smtp.client-ip=209.85.160.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-qt1-f201.google.com with SMTP id d75a77b69052e-46720a5dde3so1666751cf.1
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 11:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733339662; x=1733944462; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=D0Bh/8/p57GgUO0KFv6z2qw3B4ssWvPHnpaRRwgHkKo=;
        b=RLzC5YlOkHSg5BEp9VK3913OpLGrLK4OgYjfdvSzcOVUpnM47LjFNp4MyD4pSxJr28
         4klhyJ7clyEi2w8gqLffEOKz5UEREENNz3K1l8RWmfYDedVORsdpi5SVKlKP7Ax3mYuS
         zcD2oltS7NeXcEB+hH+ULoYe8G/AyaiDNJqt1SSAT0O36G+d+0Wc0Bx/n/Z29lcExIDI
         LVeKySYNhbFhL0e6ra9hxwatT95xCDId4+U/T8DGaHztYdXeijwdNk090H4mtF0zTPrC
         ohIfq6MXSpwiXUkBjzH2++5Y6Cqf3Ehb+2+9ITgOJoCjdjLrIdT+LpRZEvcMtbp9bBeQ
         ZOlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733339662; x=1733944462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D0Bh/8/p57GgUO0KFv6z2qw3B4ssWvPHnpaRRwgHkKo=;
        b=G7TUrwlx25sMw0SJNSSd3f7zd/L6Z5KCUsQnTYFXJ6Q31awlMuQbanBG4bXVcfE9Wt
         YlIDLiuZ7Ut/lMaTp93mfacq6qZn9nxahHekLzz3pPxntGptSEgSQ47MS1vqyZQE2Ykh
         RMTc2L7W+KUOio5kkoAQOfjIb2e8Sb++4IQ+NY0DM4DBfaZ4RwptEvVZ686od+uJmMW6
         hmkzWq4MPhdlR2PKQYQE0iTFMnn7zTG0qYIVQoIBYF04u3fdx59kmn2fuGOS/aSnwouk
         KIH/9tWbDSEWEK0VTyLILuGYYULYBQd1E1hjwm/168bF/iNBTqxPt8NF6Cxpx+dcQFoa
         vyJA==
X-Forwarded-Encrypted: i=1; AJvYcCWhqk0dqSPoG0RMCF4WwKEZISu4IGqevKfx3WklxW6dA5KScgEAjMsfe8lk5AZ/Sjhfytw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/k5k7pOcmiVM2YuDiay1oqnbX0zZoy+3jRsZ28wXEcYwaXKIg
	UVi5cTAAjAqaEGe4yz4ZbjpwoBLPXkVhsttO0+ksOI/ClatkicSi4Hr0sjE2qmhnaSp5NsXGaol
	xoLVtJzhRr7RiQk1QIA==
X-Google-Smtp-Source: AGHT+IFL6Yzt0JAsezCjVnC1Ege7Dcb8t0Na16LNTuDgarqYjisKQzOlRXRbl7knWaQbVhi5EaZ6me/AizxIjPXb
X-Received: from qtbcf26.prod.google.com ([2002:a05:622a:401a:b0:466:a2a5:c51f])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:ac8:7fc4:0:b0:466:7a01:372b with SMTP id d75a77b69052e-4670c0c1884mr95272281cf.30.1733339662158;
 Wed, 04 Dec 2024 11:14:22 -0800 (PST)
Date: Wed,  4 Dec 2024 19:13:42 +0000
In-Reply-To: <20241204191349.1730936-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241204191349.1730936-8-jthoughton@google.com>
Subject: [PATCH v1 07/13] KVM: selftests: Fix vm_mem_region_set_flags docstring
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, Wang@google.com, Wei W <wei.w.wang@intel.com>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

`flags` is what region->region.flags gets set to.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 480e3a40d197..9603f99d3247 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1124,7 +1124,7 @@ memslot2region(struct kvm_vm *vm, uint32_t memslot)
  *
  * Input Args:
  *   vm - Virtual Machine
- *   flags - Starting guest physical address
+ *   flags - Flags for the memslot
  *
  * Output Args: None
  *
-- 
2.47.0.338.g60cca15819-goog


