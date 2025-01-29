Return-Path: <kvm+bounces-36880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE901A222D9
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 18:25:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FF77166A2E
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 17:24:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C2E01E3793;
	Wed, 29 Jan 2025 17:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NaDUN5HB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0580F1E285A
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 17:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738171427; cv=none; b=NfQg1DCL+eHQkxvvQEJbUq0IGfqMtkAFCRxnrQVGWNU26nD//97z6NqXmTlrkDUNe5FZdOYMKlMvmr/nZoV8uFTerJgwkhK1Lh3LhbV4bf2Xh2203UE0OuBrk2zdWPME5Lohlyz6sC3MsqpSYUG7FF2Y07iThdxQKeCsB4h2LTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738171427; c=relaxed/simple;
	bh=74nSgIXA5pHR25K4J06Pa+CtFxgX++f0E7ugAdxdjWc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u7U6m/NM2NbWN2ir0fPVnfneloFRZvsvRseZ8TwyLfmY9GPbFcUa0m/kjuYaDxxj7m6UQXfXFumr1thuSUnp64Vf+6BajDvnnxf2EARpnEeJhjkA2zWf37GC5Lt3ve2kHwJO/bI1i96a3SddfgRNzhkfyRMSwB2WJgGy/2nnh3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NaDUN5HB; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4362b9c1641so33672385e9.3
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 09:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738171424; x=1738776224; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OG1tDMqftBd8Me3OBv+qFo5btVz20E1wK5N2Nsjw9qk=;
        b=NaDUN5HBNsOpC/VBfafRReJEqBYtoy/lFEQmg5MNq8qBxcgQY0gT933Zjx6idlFXcb
         OQ/g7ks+pn6PRbrnxNSrWHGvqHOJ2A4j2iQ1DjsRQHdL/3YBJNWyyf5oRzk6RRDPoDjL
         wTJvsksXEayF3ZXBF3ChwhWYZ+EjirB77iw2trhgeqgwD9Ar0SPfrDAtNsQzGuUyrjKv
         vw/kulrbYbm7V8kEoGLD7Ak6RczMA6UAEJV9zajwQTlWpSaJZk/VQ2bRKR4A1uJWRvMM
         cFl2fxQl2d4qhroOpV6b74kgs0oJBmHdVhV9aC1H+H7QLJd3Z3b4daLWdywnHPezhBHl
         xJIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738171424; x=1738776224;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OG1tDMqftBd8Me3OBv+qFo5btVz20E1wK5N2Nsjw9qk=;
        b=UZ0WwdOLQ3ChlYoK0hJ6LH/aP5NHhD3FkuKKfbagQMlUiWdnX6fdDSwZSscIBQOztw
         8hOV29Oufb/4MJDrcy2WNrCsNlsNi2pUNeNbEt6cDzmFM+cB773raFMXevNA8YtKrPA0
         Q2m0V+pgS3dACmDn+8sH1/+TheMhIJBr9J0E5DoeZCxSVOYfpVzCa631vAG+xQDOL7PB
         xu5GQQQ8wRtbIRh4W8eSdRJXfcRA3OGpwySBKF5m0W7jE6l1fTyrLHZz5g+TQGH6zXUs
         ztm1kapj2IGBjXWOVMHfskEu0S3KSKdI+EoCXZmLqKArOIE26NJnjZySrevfTpz1VaWN
         9PHw==
X-Gm-Message-State: AOJu0Yxxov1eZfL4H7OGZn1s84lgUPfZjejihaCcCGQ7XePyYb/4aurW
	QcUlR05rMAxC2CJJKTgrFCkft7rOvEBZVdRTdGdFPKifova4M7g6vyPcSVNeReoq4ArSNg04ehp
	hcz4sR5zWTq/rtvyYgAppDSqXca+lURFVP/22nNgN9oK0QKyJaOaa7PsuSHevNRQ9E/eJbg27lr
	hwsR2h+CWHy2IHsF8/Z4z28RY=
X-Google-Smtp-Source: AGHT+IGvVHP8k2OISYlCvdzbSWOg8/1s8TB8QwJ8K/TIlHOXAaW3sCB6BDzqqteDbn13Mj2Ujoo4vShVnA==
X-Received: from wmqe15.prod.google.com ([2002:a05:600c:4e4f:b0:434:f996:b54])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1c97:b0:434:9c1b:b36a
 with SMTP id 5b1f17b1804b1-438dc3caac1mr34886695e9.13.1738171424101; Wed, 29
 Jan 2025 09:23:44 -0800 (PST)
Date: Wed, 29 Jan 2025 17:23:19 +0000
In-Reply-To: <20250129172320.950523-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250129172320.950523-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250129172320.950523-11-tabba@google.com>
Subject: [RFC PATCH v2 10/11] KVM: arm64: Enable mapping guest_memfd in arm64
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Enable mapping guest_memfd in arm64, which would only apply to
VMs with the type KVM_VM_TYPE_ARM_SW_PROTECTED.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index ead632ad01b4..4830d8805bed 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -38,6 +38,7 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
+	select KVM_GMEM_SHARED_MEM
 	help
 	  Support hosting virtualized guest machines.
 
-- 
2.48.1.262.g85cc9f2d1e-goog


