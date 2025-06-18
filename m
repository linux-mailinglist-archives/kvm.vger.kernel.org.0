Return-Path: <kvm+bounces-49803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A493CADE27F
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 06:27:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 68D397AB7C6
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 04:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9264C21E091;
	Wed, 18 Jun 2025 04:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wzund+6I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2069621CFF4
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220687; cv=none; b=pTjdslqOWyRyBwb23sohkOlW1UwT7vRLl7tVCok6yuE2F588Woy7bBFvyx272cqkQi8AkHlx7YSGYRxile3QLan03hHs/zXFBDc/TdKWDNlkvERS39Pgms+/BNk2YrbcbUiKQtVyiHnFb/6ZNtfw/lGDjUKR0RbvVBdMt8iDCK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220687; c=relaxed/simple;
	bh=jSiCen/C1Tdc2UB541LJK2epQTbdnnCbieLg8I8XSIE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oDywPgi9meOZZDn+MVBawOG0qG6sREappBE0CuNGPiZoADx2YnRffcg8sxrSEYYbnltOvIlXMLz0iGspf/sh6pR402e6r2ZIm18NyK1xNA3FwJncoCIpwkGyZjhleDl/7uS68dJNW7zMJIvcbHnEFeXsw7hHmsSSWS0J1JHJ7a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wzund+6I; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7398d70abbfso8422202b3a.2
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 21:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220685; x=1750825485; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lJmtzreapar7RYm6csfZXNlZpVROzgpN0suNPttjN9U=;
        b=Wzund+6Icwa5O3/0juL0BZb2/v/gcv/vvLwv+IGtYkiBSz3VkaqxW91RgcihHfLgKP
         hMogqClv5btqfQiCSNhaC3siOaNNFbaMRlZ4z7NStt5WHlQDdMgW3DhAjjpJQBXuImEI
         zo2gmp8JwJY24+5oxAzWNMEwLAhtQB18by9XZeKq3YDNQJjJWNl5nnZcOmdYaTdfG39s
         Uo5vO0r+HvPJYQAewKf1hjSETfHBeC4Z1TLEyEXaoq3Hxe2r0Tn4qZTYPemi8zfYWrNT
         k0FtyB7fRys1xt2gAxiKDF3ciYUQwr7XEbNdFigzuMO3UnL04G2SzoyD9F1pOehoLucD
         64Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220685; x=1750825485;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lJmtzreapar7RYm6csfZXNlZpVROzgpN0suNPttjN9U=;
        b=dE0Mc54Kbt8h+WraSBfMEKkWHQV6YUtlPNPZ2p+fqgEWw+//nEoZNI3NxTonQve3K4
         Olp1dovhkqlcwlTfRIrY2CRk1Dpnr+p7+cSREUU2HAJv9ReS2GLvc4h9eqVQhdB7nUnM
         y6Mp1RwF5mOIHedz1a1F6B63Ga+/zj4Xf4XYPZJJ9qsyJNYiR2QSvQq5nVA7NGaUov4z
         wYKdSPPh/Mbw7XYf3JTqdeRJzzzNntfH87wg/NyUqVR6NOSLXXUZuhS1NhJ9NETGhJtf
         5oB+JTdcvW7sq3gydyXTtoi7DEhIdvZTxZ6b/4baO/0WawLqGan6VrLNZrObgK190mf7
         UuNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUobGKvGPLnEbilE68pyENe5wf+ZI0q2bXdr7jXB6n4VvsBQ/4LrId09KlPmOwD3yt5duw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgF8C9A8Oty32xc40+pvrGCGrH8OBNOVlmQI/IbCtoFKDICofE
	FHarP67tGLU6uJpFllrITiC7lvfjfS83OPQkgXbo/T55bpNO+ofNtvlZomuEioidFYw89dgnBVZ
	maVxCrHurvapvIGWkd6YkPw==
X-Google-Smtp-Source: AGHT+IEYBcC2cDsFrgiMsyVhS97ys7BmjM02OsUOLrECd3uh2HcwoI2YZYxPTZFJmgzjhVgSJXNOQSUyK0OIbxzF
X-Received: from pfus9.prod.google.com ([2002:a05:6a00:8c9:b0:747:a4c0:983d])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:a115:b0:218:c01:ddce with SMTP id adf61e73a8af0-21fbd5d90aemr27193918637.40.1750220685258;
 Tue, 17 Jun 2025 21:24:45 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:21 +0000
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-13-jthoughton@google.com>
Subject: [PATCH v3 12/15] KVM: selftests: Inform set_memory_region_test of KVM_MEM_USERFAULT
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

The KVM_MEM_USERFAULT flag is supported iff KVM_CAP_USERFAULT is
available.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/set_memory_region_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index ce3ac0fd6dfb4..ba3fe8a53b33e 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -364,6 +364,9 @@ static void test_invalid_memory_region_flags(void)
 	if (kvm_check_cap(KVM_CAP_MEMORY_ATTRIBUTES) & KVM_MEMORY_ATTRIBUTE_PRIVATE)
 		supported_flags |= KVM_MEM_GUEST_MEMFD;
 
+	if (kvm_check_cap(KVM_CAP_USERFAULT))
+		supported_flags |= KVM_MEM_USERFAULT;
+
 	for (i = 0; i < 32; i++) {
 		if ((supported_flags & BIT(i)) && !(v2_only_flags & BIT(i)))
 			continue;
-- 
2.50.0.rc2.692.g299adb8693-goog


