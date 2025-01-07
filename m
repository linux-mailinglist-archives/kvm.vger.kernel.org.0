Return-Path: <kvm+bounces-34658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B893A03702
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 05:27:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D901160FA9
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 04:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DEB11DF963;
	Tue,  7 Jan 2025 04:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eqQ7xnXJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0FD1D90D7
	for <kvm@vger.kernel.org>; Tue,  7 Jan 2025 04:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736223971; cv=none; b=PBsfwokTL99fyEqIkmcVtjLhNRGQvnLBRZrF+x13x6/udK5p9QuvwtNhwCJKkQ3TP2pGCJnO7K68nwDsLDj+kNBkP8F/XB68lAV3QAW1BsGWkK5v8wvswAzl0BTOoPg3ib5aNrh9PLYL+fpZ/hZNtgOZY4k+eYhG4tX+5dSDOgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736223971; c=relaxed/simple;
	bh=s25S+IIcIvU6NfHzDcJg2UokwZvlhm0DiOxjBcDy6cM=;
	h=Date:In-Reply-To:Message-Id:Mime-Version:References:Subject:From:
	 To:Cc:Content-Type; b=q2cBBcWBK1tonpmRam988XOxUszx4TQR5vAudNE54tctI7AwkZnNeOhIPk1NmJoMmiqiW5HNWh8umaV2Yj16ODOssaBDW90x3b0r9OvJTDSFGVqfURlnDLajphbr8tUMenGTEf9wBP5hET5V0/fWmRxbaqZ0fYXW9iXa/Y3dVMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eqQ7xnXJ; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e399457a216so9258487276.3
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 20:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736223969; x=1736828769; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ibH41uyLFh1ZmBilF+lh7wTD30QR58+YJn14H5cwa2A=;
        b=eqQ7xnXJm5/3ToK3Y+KIRkGBGnT8ck5PGKRrO+7kwDPwAigKGRXf4GK3G+e/4kPMDX
         ekgz4GTbeegb+tTL8oJw5JKPKVgWPT2NVyH78ldkKlTwQj5TOG60v0qBzKsfwWwrYqns
         5r96rlRbMS4inCmPG+jZ4Z6fcS0u/OibXrg13zgQPbBQFkL06/qykNM1qfF/wFCi/Sit
         05PVOjbpTuPc2su7+W9EnC7CXII/nczz6OLpPn9Bg3191Y9s5IpDJaqsbrFpIwWU8+Oc
         0Y9sIDjh8IzWeege/9zPBWSfjO7fCrITdz9JQY6xLcaw+Gk7yuhSW9fgcKiyvQcuIgP4
         9YZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736223969; x=1736828769;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ibH41uyLFh1ZmBilF+lh7wTD30QR58+YJn14H5cwa2A=;
        b=JTx9JIl9HMdPi1+UwmscgFmiTPuQEkY3C1UlzM6jPqKgW/HpVjf9ucRGc22f5aoG0h
         GKjWcDa17fwRubfltoz7a6n3ij2W1+aG2c6yJNkp3q/lOQog/KggN6eBx9Fc1GbN0RUF
         ImLF1Kr8aWxZJRYTD/taI6RWn0n6UCO3txFkl86ogD0JxKi21EKKBhFbAiup0mNs3zD/
         vVcf2+NH72w5SwpVs2AY9Qs7xavwdjSYCGhTNl/RYyjkjS3WCV/KPYC+cztBKRDdx3zv
         JHsB1075w1dBCsuDTGt/QTZrWwiQtqkGzfHFAkA4FGEod71887xfOezWymCwbWirYOiy
         O30g==
X-Forwarded-Encrypted: i=1; AJvYcCVQgyPLhcm49ugimJM2MSl1JwgXuzolN9ehSARJu+1jBous9iUNO7/NudHku5BXch0002U=@vger.kernel.org
X-Gm-Message-State: AOJu0YyX4dbFWR2ETnVjX+rlxisrLXlpQute0dTea+fLeLpvAUVnvstd
	2xj7f7EtzGunkjtmwCTwnUQPnnW5b6E1GpVpRJdv4/RMbJYjoEGASqdrzjob9e9NTopS4tvgsyw
	GWJXJSaXR8w==
X-Google-Smtp-Source: AGHT+IEX66bQDxVtTDO+iv5Yj+TmEWirbM3zI7mFYJ98qz1aCvyAgg8k6W+5VvQt0BAu4w5ZqXAok0ekqv+9fg==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:66b9:6412:4213:e30a])
 (user=suleiman job=sendgmr) by 2002:a05:6902:d45:b0:e39:7a90:7b2 with SMTP id
 3f1490d57ef6-e538c391482mr121318276.7.1736223969501; Mon, 06 Jan 2025
 20:26:09 -0800 (PST)
Date: Tue,  7 Jan 2025 13:22:01 +0900
In-Reply-To: <20250107042202.2554063-1-suleiman@google.com>
Message-Id: <20250107042202.2554063-4-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250107042202.2554063-1-suleiman@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Subject: [PATCH v3 3/3] KVM: x86: Document host suspend being included in
 steal time.
From: Suleiman Souhlal <suleiman@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org, Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"

Steal time now includes the time that the host was suspended.

Change-Id: Ie1236bc787e0d3bc9aff0d35e6b82b7e5cc8fd91
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 Documentation/virt/kvm/x86/msr.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/x86/msr.rst b/Documentation/virt/kvm/x86/msr.rst
index 3aecf2a70e7b43..81c17c2200ca2f 100644
--- a/Documentation/virt/kvm/x86/msr.rst
+++ b/Documentation/virt/kvm/x86/msr.rst
@@ -294,8 +294,10 @@ data:
 
 	steal:
 		the amount of time in which this vCPU did not run, in
-		nanoseconds. Time during which the vcpu is idle, will not be
-		reported as steal time.
+		nanoseconds. This includes the time during which the host is
+		suspended. However, the case where the host suspends during a
+		VM migration might not be correctly accounted. Time during
+		which the vcpu is idle, will not be reported as steal time.
 
 	preempted:
 		indicate the vCPU who owns this struct is running or
-- 
2.47.1.613.gc27f4b7a9f-goog


