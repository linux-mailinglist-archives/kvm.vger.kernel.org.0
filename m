Return-Path: <kvm+bounces-54444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EA323B21676
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 22:31:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2FD421A2393D
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 20:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A0F42E2DF3;
	Mon, 11 Aug 2025 20:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T61lkoHL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B41E2DFF3F;
	Mon, 11 Aug 2025 20:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754944248; cv=none; b=XaiRgibxAvSNQ3WkzeaGMZh8BvKf57mu1hjiAqSVmslmEf32ZakScCg/eikX9hz9x8fSpUaGeW6My5rU59b/FBHUxJhCTDZlZ2lsaxUuyH4EKu3i0TC4kV7U+4L15CEOzW3Zlc5W0FOznWiy5RP4ATnt+ECVdZnS8/jqG3Lnu/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754944248; c=relaxed/simple;
	bh=OXl6s+b7PkRbs1K4+KpWNYCb2ljXVw43F5/T19TVMvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tWV9FN5i7Sy/d59/8umYmLaDRbM/p1tAcIBUmOcOh4fIpdvi246pqZrbCZFsPNt6yCeayetSUXrmYp0ejOyF7P35qT6nS9PVWJM7Abmjzkevp4QyYVBCP6/D3dxWtnHQCQj1Dd/ZQHNvfEszGBVQPIX6hSdy1TaHvCXMv4w1I/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T61lkoHL; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b1fd59851baso3231385a12.0;
        Mon, 11 Aug 2025 13:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754944246; x=1755549046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fzhWjAp055AAc8JzQkAUEhY3bLwP70Etr1zWNUruP1w=;
        b=T61lkoHLqOCBL3UROOWBt2+3ZYPx6s1gvrxMUV8OGnj+YXs1ySDY5ICJmmMam2/KNd
         JmH1tbLGia3UgOBqxd8UJFuxe00/JBKWAhj1lcsvQlfooQJQRB3dFUmPogbj4hYJybNH
         u0dBMuyp9hiXl3BiRhJfAEp28GHd4y31VYQgCUBH2DbPbPAFCBZQOHKVUvPNvxk1Wfsh
         JzxuesK3UcKgUMlzt1VtMWOFRqv07jLPVOf3Zp2LnO0Sf3mKeBVGCh2cjin55E1TgVCe
         6wPe9lYoMniCjOpIsPh3srHk4E3hE/5vHFUl0Tn+VRaBsSKOXhGP3EOOVJBNknFdGspJ
         s75Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754944246; x=1755549046;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fzhWjAp055AAc8JzQkAUEhY3bLwP70Etr1zWNUruP1w=;
        b=Kh1hxhOTD9bCMeTGn9xL5F0xjEIN2pe/B0RidNodt5nGDVmcTaOylj99sSowXTr2IR
         jp8yQE/+FzoLo6gIzZjkyv0TyBD/CK+0eKTjQPTF1KuhRCxFdKTtjDcFN1DLBxsTAI/v
         veM4Ggg/nGpfDoyLGahXL3zsmaa8UoWkXbRxdfpPGcBnSVT3zFxFJ43rlAmv2cCTRsUN
         G79qPbYwFkz6L9GiHhZ2w1KHmsndXx8oj+yZTSwNbhdmQxyNm/fQlCSxKOd+mA05BvfN
         wWxMD7gaeLkU0hgDTDXBWJNczGbbG0I0uaO6TJsToSnkIWwH6UM9SAsrZUVCEDfhhFOZ
         DT4A==
X-Forwarded-Encrypted: i=1; AJvYcCU6uhxmbpBov0D74bIlmZZnJ2D6lpk/cda2uYYr0f0asccuyWYTIg7AJKXCpcHuuTq2C/k=@vger.kernel.org, AJvYcCV4fx9ic+MphuhJBKyUWr7bDr5pQbMWqA5ZQqBGTvkzs0zJ5Q7WcoBtDYPPQ84M2tAgCaAVtEPU1qQ2p8Zu@vger.kernel.org
X-Gm-Message-State: AOJu0Yyny71MjRCVD88E8GmusI8RaK1WF+c0IVceuvFmvMDGz5zc9r3J
	n+o8T27ZnE8YX3lV24iSyjdf+Kbai3iwHcaLEXDELnNaG40jjwOdF5uv
X-Gm-Gg: ASbGncsgEh42NQUMBI9LU3l1wYVxqanSMU+P8enbaIqcd+tybWqoKKl6h+cwQm8xAAU
	TpRKQC0BS3kW2ThMpM/SXYg33woOI1yvqQhMNJdqC2rB9j2detxaPDrugNxWgfnasxR1fhjnjPa
	ykvi2MLmnJkI1dZIiFc8nktiwLvBx7+XkVnQyYdQcRiYkoTAO2L9Lo3mp67GU1xBpeXgRSA9oCp
	VTUS+E4z8GqtXGBtK96utf+Qg758tyDU4TSy0PfX7n0qqPdRGythjiSy5mWju+4uVxRyyVzOvM7
	wYXe3ErLCSYs/aOg3ILVenx9A6LPdO/Us0NMwKyNKso7y7bMaizPUg7CjdBA3iCxcDkH0rHnC0/
	LedmPV621kaaU6GrVW1Rr4DpvULv7kqKe
X-Google-Smtp-Source: AGHT+IFy+oRUI4ne9Pf1e+xWraITSGC335iBNIDmm+gOciMW+BDv76ZIZaxdpjZxNx4LPbf+m0PynQ==
X-Received: by 2002:a17:90b:4c:b0:321:59e7:c5ba with SMTP id 98e67ed59e1d1-321c0a0ff55mr1337403a91.15.1754944245335;
        Mon, 11 Aug 2025 13:30:45 -0700 (PDT)
Received: from localhost ([216.228.127.130])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b422b7d86f7sm23746167a12.24.2025.08.11.13.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 13:30:44 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>,
	Zheyun Shen <szy0127@sjtu.edu.cn>
Subject: [PATCH 0/2] KVM: SVM: fixes for SEV
Date: Mon, 11 Aug 2025 16:30:38 -0400
Message-ID: <20250811203041.61622-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yury Norov (NVIDIA) <yury.norov@gmail.com>

A couple fixes for recently merged sev_writeback_caches() and
pre_sev_run() changes.

Yury Norov (NVIDIA) (2):
  KVM: SVM: don't check have_run_cpus in sev_writeback_caches()
  KVM: SVM: drop useless cpumask_test_cpu() in pre_sev_run()

 arch/x86/kvm/svm/sev.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

-- 
2.43.0


