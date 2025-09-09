Return-Path: <kvm+bounces-57032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA8F1B49E1A
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 02:40:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3E703B9AAE
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 00:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4492720013A;
	Tue,  9 Sep 2025 00:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WotnxMPn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AE81E9906;
	Tue,  9 Sep 2025 00:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757378402; cv=none; b=IqTdY6zjtwYFib3lJ9MnkhJmSu1I/smvYhlM8JWECAegUzY4R05ZSlXvSEC1hnx5GKK3wcJmiCYG66+5cWNwpqrGkaK5a/iqIXZDxZT/Lje/cY2K3qB7iBE+cwiITowafzhoXqWT6ea2mANdCNTcWwfC6MOnRjBaeN98AcU2b/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757378402; c=relaxed/simple;
	bh=CO0FjS+2hJVAJS10NZf8s53S/WpzUmN69A/+HLx9ckA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UChvoJ2Dz3WFsrpWpHPMQq/KyIokQ5u+eUd7ykkEFFU/MbEgT8AHXHQjBg02lqjPeapwxERetCsA5k5MRm/YBqcVSWpPOVRM3jlJtFGKk8S3wlrIMokAVtxbJ1mhRxso2Z4v51CbHUehX+bVv3HrPMb3GDheqX5IfplgndcwOFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WotnxMPn; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-32d3e17d925so2499315a91.2;
        Mon, 08 Sep 2025 17:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757378400; x=1757983200; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KPJkBjtxnpDGCQnjAlatzBYUpsYeWLU6mm2ymMNie5I=;
        b=WotnxMPn+0iXRCjhQvTFILSr7rxvLdLMCXIOIY/+GfDUEg7pR8iSQhO4/1S0zmiTLI
         kmBzRXWKvIm/jK7ibrZn7ygiU5vBu+V7PIB5faxpmg7QF2SSpfmgR6sHSXVsVVaLdq1n
         3hIqstNITHEXEYYV3TeSZSgW/VpO/VeInos24Y2tVDkFxevzg1b2X45JDxX9f1VOdMtf
         ZtqT0RmH33MoohMnZCn/SGNZ0+wZ+KkE0xHKodBViqJxI4VWP4ZByft1A/kFH7IHDLE0
         THXKRXfx5Zo14mGn+R8bEXhDMepyGMhyxT/lphDRygdHHIMH0Ltk9Blie3h402iCUbVL
         AjwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757378400; x=1757983200;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KPJkBjtxnpDGCQnjAlatzBYUpsYeWLU6mm2ymMNie5I=;
        b=uhXH+s4unvv71z8sSwE09/7JJbUqn36GjwJurBs+AeqAs4tM8KDJSLouN/Pzfv1ChT
         Pk7qm+dB65CIkLrKItAdLJw5qrYJqpbesMSM6WVUgYO+/+OuUp+BoMOO+8vZml02lzIq
         v3LKdjAyd2k+FhN+yr5p0mBMpE37g3zyzBJ0YoW9FHuUmBEDs7atjnNOjjy227ksUN2u
         B9Hz2rVrDHXXuAbAxRpaoVzK+Hp+hYfIbsA5BRARHHFu0pvimpNIwqFHElfOk7iR4C5S
         QPoYpYMAU8RuLFVPJI14IK7/LjBzeDb5cFo8yecFI4WhOdU8eRHr8HK6ijsOXNXbES5P
         a1bw==
X-Forwarded-Encrypted: i=1; AJvYcCUd1Zp1vW3o67PWrGJXXzKC7oOEAOlyMlIeJMMHZKm6uQtsRxDLZmlRD7WQPnCiKIm6Rc8=@vger.kernel.org, AJvYcCVtetbmWa7qHgDE0cfdzti/Otf3zdKvGzYRciQQLICaHJTXJaitoLPqEF3X6RikUmio+ExcdERvP/aZ@vger.kernel.org
X-Gm-Message-State: AOJu0YySgVWmx5Qa1qYzcNVu/nqISd7anXe3dmXoHhiMqWeAxsxOs6L+
	waRo7EDKzad13HOaaXvnrQJOT6op+XZsChdwi7JB9E2NiBKo9etlFjcq
X-Gm-Gg: ASbGncvAd4UMIUwqi9Nry50cXd7HFl/ow1Zm0KpdeQNjd2QeYinz394+2K60Jmp7xO+
	X8KBOAhrj8Ey4GbhB4vgNubr3pMjBSS3eFQHACNWQhDTnHjfVFRIH5ZMxKUndFEr0FjheAef2a2
	CiXvU58gOpvOr8GRNwNi8dpH9aRqatoOjmn3HeQDf1PYWblVzdgYmcmwCv6AQo5l1RG81a8P4vt
	54xMnPbhOs+YNnOwv9f8K5ZeEd1OdWh4eacthlC1Y1J9Z90uZ/S1TDzwyMawEKIND/uj3BiQkM0
	7zhRkJRY++DbD8vNSC4bYrwIGWGZcMO6j7Tg5EiVxUHudjMt09KB5C8FZyrDH5TRNH1HiRiyxWv
	QK7iGXEjw/mXhbobVJHB947P04A==
X-Google-Smtp-Source: AGHT+IH6ulDgy2phv+kimj5Of+llTgHUm6R29mHUPofhStfAmJZS4UaniCBJPzBprvT861hcoGqJxQ==
X-Received: by 2002:a17:90b:278d:b0:328:acc:da37 with SMTP id 98e67ed59e1d1-32d43f04ffamr12197864a91.5.1757378400157;
        Mon, 08 Sep 2025 17:40:00 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32d7d4074b4sm4779254a91.4.2025.09.08.17.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 17:39:59 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 9B2AC4206923; Tue, 09 Sep 2025 07:39:56 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux KVM <kvm@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH] KVM: x86: Fix hypercalls docs section number order
Date: Tue,  9 Sep 2025 07:39:52 +0700
Message-ID: <20250909003952.10314-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1686; i=bagasdotme@gmail.com; h=from:subject; bh=CO0FjS+2hJVAJS10NZf8s53S/WpzUmN69A/+HLx9ckA=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBn7y9I5325+KXJATi8zZtIMaZ2otY3utubTlqjFvWu8+ uX4vuvTO0pZGMS4GGTFFFkmJfI1nd5lJHKhfa0jzBxWJpAhDFycAjCRB5wMf8WM+SvPLZ1aq33w 0I7wSb2VRZXbW2YvPemUrcS49J1I3E1GhgkRAZWBaVaZF1qn7itUfyS47MbDLWYbDy85997Pqep GJDcA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

Commit 4180bf1b655a79 ("KVM: X86: Implement "send IPI" hypercall")
documents KVM_HC_SEND_IPI hypercall, yet its section number duplicates
KVM_HC_CLOCK_PAIRING one (which both are 6th). Fix the numbering order
so that the former should be 7th.

Fixes: 4180bf1b655a ("KVM: X86: Implement "send IPI" hypercall")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/virt/kvm/x86/hypercalls.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/x86/hypercalls.rst b/Documentation/virt/kvm/x86/hypercalls.rst
index 10db7924720f16..521ecf9a8a361a 100644
--- a/Documentation/virt/kvm/x86/hypercalls.rst
+++ b/Documentation/virt/kvm/x86/hypercalls.rst
@@ -137,7 +137,7 @@ compute the CLOCK_REALTIME for its clock, at the same instant.
 Returns KVM_EOPNOTSUPP if the host does not use TSC clocksource,
 or if clock type is different than KVM_CLOCK_PAIRING_WALLCLOCK.
 
-6. KVM_HC_SEND_IPI
+7. KVM_HC_SEND_IPI
 ------------------
 
 :Architecture: x86
@@ -158,7 +158,7 @@ corresponds to the APIC ID a2+1, and so on.
 
 Returns the number of CPUs to which the IPIs were delivered successfully.
 
-7. KVM_HC_SCHED_YIELD
+8. KVM_HC_SCHED_YIELD
 ---------------------
 
 :Architecture: x86
@@ -170,7 +170,7 @@ a0: destination APIC ID
 :Usage example: When sending a call-function IPI-many to vCPUs, yield if
 	        any of the IPI target vCPUs was preempted.
 
-8. KVM_HC_MAP_GPA_RANGE
+9. KVM_HC_MAP_GPA_RANGE
 -------------------------
 :Architecture: x86
 :Status: active

base-commit: a6ad54137af92535cfe32e19e5f3bc1bb7dbd383
-- 
An old man doll... just what I always wanted! - Clara


