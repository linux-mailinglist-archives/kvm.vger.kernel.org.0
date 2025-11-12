Return-Path: <kvm+bounces-62915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id ABF09C53E57
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 19:23:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9673F4F205A
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 18:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 094B834A3B0;
	Wed, 12 Nov 2025 18:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EdVHQASl";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="tmer2xaj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2CB33893A
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 18:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762971252; cv=none; b=LQCuO3otAZgL2MIH9Hhn8qRKouqpqCFJz7odBUqCtEu9Xa/Qu6q4t4yFvi97aiouFpPQHQH7/YNUh4u+TaZvcRG1RwR/TVKMA58EZFHFKGOcMnOoO+AeYSGT77bP84Md9gQkTyd8FIAJgFAKIKUKSHJ76bgIZBumyURLzWSs+jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762971252; c=relaxed/simple;
	bh=2fL91WULS/rZQmHZyuQUO6TygM4iRQwAhrVr9f1eNTg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MIL3NS0cJrjgkYdPKXhKR1kd9yHGIpVqISDQn9cfmeMDkomdyMMLCNwUra+Z31D0bpydSEmjbkgPTkY+/W57lXLu/D5xOEl+kXb4rwPKk9li7WqfkbqptV5lEdUdzkQKn/yEiP0N3twW9QNVZ/eHauls8tgH2zPkpiADgPgP1so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EdVHQASl; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=tmer2xaj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762971249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6wkDGLNl95u4gTMNts1lwy5hnz5zbSzJt2V8JBhOwjc=;
	b=EdVHQASlogO70eec98x6Xu2BHzJt/yYVTnSA+zeNrLELO/uDenHifZU93T6Z32gM+GP5Jz
	H40gVR+vi1QHCZKu0FjTQTQulGlEGY1yKqwpWXRB1V5GcMcjYBWwWPjED6erApm39CP6Ml
	Uzzx/tzNC4tW2u4ehjmdBf9REQBndXI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-PSvVwQHNPryvIIlPNJ1cwg-1; Wed, 12 Nov 2025 13:14:07 -0500
X-MC-Unique: PSvVwQHNPryvIIlPNJ1cwg-1
X-Mimecast-MFC-AGG-ID: PSvVwQHNPryvIIlPNJ1cwg_1762971246
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e39567579so116515e9.0
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 10:14:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762971246; x=1763576046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6wkDGLNl95u4gTMNts1lwy5hnz5zbSzJt2V8JBhOwjc=;
        b=tmer2xajez/YJc1kGstBhatc7bkKiYI7FmN5XKweU2FZAnGDTRjNLsl8UOjcc8+Whg
         3ujCjSnwijmmIW/Ylw0hbGV/pr4+3IHb3i7qeqXqLEn3Z0fEGxTKhq9Zi4YfR3o3WRk0
         pqNnRZzgFEPq1PGHUx5pXpXbTmmii+MSEq4O2ILZ5nmdOOkG/I8EeFoebD/5FnqEokVJ
         U+jetsrr5eCZRwhWhKqryessvh91XDGnIsfxs98xc2cXPtv4XoMbyALFx4hFufVFobWT
         n8OYwtcAzY16jpY6QPd3+tEaVQyJd1/IeTcWQ9ZsWkMUUYxOyfVK5jeUhduz9srrmBk3
         MsDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762971246; x=1763576046;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6wkDGLNl95u4gTMNts1lwy5hnz5zbSzJt2V8JBhOwjc=;
        b=YPwxCeekvsA+YxMNI3FXR1kAgpwsoS1W8lIFANBppkF6+7+LLAYY8LyobY25U2P8TB
         wqzyL41+inle/oYz7VOfb3DGTPvjkqCiNA/kHJsAZ401s5EeOoMuaU99UM3Iq2OcnUrQ
         fgkFmslqL45mJiEAU/TydeTVQ5tA6A7F3AOho1c+6Mo+KaPwccNCVnDyviy/iJ9PdlSK
         vAYvIqRVVdovahUlQAyraiHLJRSUb1YEZ0BB1cnqKqj1R4W/fDJIi7PHhLxVQSILB9wQ
         78W0G5CwZ3kED4BBzB3AkldXuvXiTbAeZEheWcrcY6HimeDfFewdoiI6o6zeHoETIyK3
         sHiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtfOzgDr8RepYaXFmLECK5xdds5G3c+B/CuZaW9BVH7G/gH2u+OVGUvg1k1R2avPI+J24=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeUkWuKJaYCPfM07qDXgHy2RXYhAOQBUWmzoHGBH2lu1sF9Bwt
	azhtupZxsWtruDs3SHGnG5a/AeSnlqrzUz6ZToGr4SwDsthK30UesLJc+ox3yoYrnHoDeiazazl
	KUOEOsJSyLUSzGSyJI6jfxpzsAw2sy2Zh67jNVAO770i9hn6n+jo8Tg==
X-Gm-Gg: ASbGncubmRli5wNuclsHJmfVmoSWZ5kGEibl5wqTeegFQhI+aeDepGhCBQ1KdOejhQQ
	EtZOoAkfIdxBs3dwFeNcxnMQgS80UKUX8TSgafVxqw9w8xk5H6sT3bdUxAHVpkTTvxfsW0qyMV2
	1824daFFxhRILRf9DO6tddamb8Xdb1oUfCwGnaNNEBc27kvoFjKCYWMhEF7USQdDjrU4Xoywzfj
	bSBd9UjHNy6pY14POO0IRE6DXtpBOv5CXdru4btgeQJpzMw8dBIcYRRz9UpgaS9cI097szPszBY
	nbeoGf3r1YGq8NlrD+N5loeKpSO40i7RmQFZSn2PWzWjlmy1V9wxbaqe9DQi9N/Uhz/dgTaRHtt
	vRIy4yvILc6/TFAOgOwJCvfWVa9EIx1o3uC++GWCPQzvGVOxVCDdlzByWjkOxhA==
X-Received: by 2002:a05:600c:4f54:b0:477:7ab8:aba with SMTP id 5b1f17b1804b1-47787071103mr41219905e9.1.1762971246462;
        Wed, 12 Nov 2025 10:14:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG9+tZW+TZfDNytcYdvgsMKLxtasoyhEGtTeovHC2gFRRAmyVWZ9b21XTXgVv0PcfEXirpotw==
X-Received: by 2002:a05:600c:4f54:b0:477:7ab8:aba with SMTP id 5b1f17b1804b1-47787071103mr41219625e9.1.1762971246059;
        Wed, 12 Nov 2025 10:14:06 -0800 (PST)
Received: from rh.fritz.box (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e51e49sm46851355e9.7.2025.11.12.10.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 10:14:05 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v3 0/2]  arm: add kvm-psci-version vcpu property
Date: Wed, 12 Nov 2025 19:13:55 +0100
Message-ID: <20251112181357.38999-1-sebott@redhat.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds a vcpu knob to request a specific PSCI version
from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.

The use case for this is to support migration between host kernels
that differ in their default (a.k.a. most recent) PSCI version.

Note: in order to support PSCI v0.1 we need to drop vcpu
initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
Alternatively we could limit support to versions >=0.2 .

Changes since V2 [2]:
* fix kvm_get_psci_version() when the prop is not specified - thanks Eric!
* removed the assertion in kvm_get_psci_version() so that this also works
  with a future kernel/psci version
* added R-B
Changes since V1 [1]:
* incorporated feedback from Peter and Eric

[1] https://lore.kernel.org/kvmarm/20250911144923.24259-1-sebott@redhat.com/
[2] https://lore.kernel.org/kvmarm/20251030165905.73295-1-sebott@redhat.com/


Sebastian Ott (2):
  target/arm/kvm: add constants for new PSCI versions
  target/arm/kvm: add kvm-psci-version vcpu property

 docs/system/arm/cpu-features.rst |  5 +++
 target/arm/cpu.h                 |  6 +++
 target/arm/kvm-consts.h          |  2 +
 target/arm/kvm.c                 | 64 +++++++++++++++++++++++++++++++-
 4 files changed, 76 insertions(+), 1 deletion(-)

-- 
2.42.0


