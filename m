Return-Path: <kvm+bounces-42254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 31390A76AA4
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 17:35:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9653416F923
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 15:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ACC0215064;
	Mon, 31 Mar 2025 15:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WESEtsHi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CCA214223
	for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 15:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743433561; cv=none; b=fX5aINdoCycAWC6AVkKD9+efkKJpkqYFEvhIOUIkmbAHqlMykCQUJ1DfCeJVI6mnVxRKhW9+RFAizyvsMa/qC7aNprVrlhbqbcwzY8TRLByjbjNwOBndh+O3e8oIgZBWrTgzixjQxFj+pZD9z6LnjRCu/KjOVmNADuKKuFjWuBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743433561; c=relaxed/simple;
	bh=92zGFyMpFmCzM0JZzn7mpnCDHeTUImGKBYCvrCI4/c0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=eeUeE4PkvyBFRwgJM+A3GAxgBbtEBgpXCIlaCN0605jjsb5HG/wgm+IqfZ6byZYHA3XZruKF1cmBCRz9kREP93mO7JEPOFu28ZStHgDK+V4fcQrmlSX0d4EuPVjMiVkaUk84nSnzBYUzv3zmY3v3whi1uee15DzgkHXKbMtIp0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WESEtsHi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743433558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=V0VVaNtKIa5CiN0w1u8U5zQJhgOgmovWcu6176XK7Tw=;
	b=WESEtsHivTLz+4NJfmVynHfHllQxt3LPsBk448mZrGNCPS4TtGiX0/YHVO4vR8cskgqKGZ
	RlOvIjiYhXLFsYk8pvWzhp9YUA4qvwQmNRRppseJDTruTJTTdu5OQS0tpZfJIO9cWfk4M+
	bC3DCeN90CtjVwlCb6+JX+qXmb5cDDM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-agwDWg7ZOwCigtBqNEw9aw-1; Mon, 31 Mar 2025 11:05:57 -0400
X-MC-Unique: agwDWg7ZOwCigtBqNEw9aw-1
X-Mimecast-MFC-AGG-ID: agwDWg7ZOwCigtBqNEw9aw_1743433556
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43cf44b66f7so33187235e9.1
        for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 08:05:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743433556; x=1744038356;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V0VVaNtKIa5CiN0w1u8U5zQJhgOgmovWcu6176XK7Tw=;
        b=njNfGlfjG4wvOZ9iqC27QhN2RmHwL//Tlh80Z6Ab3Yuaqm+Etxl1lwMafN8MZHLvnT
         FqLGaVbX3QTM69CEX6YlLfh94qycKiE8OjH183RqAJK/0eMuJ7/eZazUmkmWKCMR0Zsr
         ONz49V2Yz0CIyrIW3LCMl0Jgrlx4ngWMfQrgjOzKFxyWdwI02A7InOr/PGA7K12q9QMr
         zRlKeXNgrG4o37ssUjHBK28l0VrXeEMHWGobFEwH9/xP0phuZoNoNYLeERS+VD9yh/m2
         AVWN5xE2tRhzjwzgiFcc4B5fLz70eCcP31faAtVaZglo1Gw9kwKAGDOBh9x32EasyChZ
         Z7gw==
X-Forwarded-Encrypted: i=1; AJvYcCWFZfdW+6bPRFJ8i+7VAiFiwKFLt+H1ETFxVUZxG3vzQGZh+DNtsqfvZrrJFSR8Mkdys4o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/wYGlbb5QFPdgjc4IEDI/AlHmvb4IMmrrlhrDOTO71l+qVM//
	MrTX3+0vY9YBV53PyIAerc5fWEGaNjWGa6PTWGKQxfQHWNj4p/VIiPwaQfOAKFnzpFbYSbIXy+p
	jUc2WFm8bcGBjqDtsbVtt8ppXz1xXktQMtoAh/KWChif4vAlPL2nWeMINRA==
X-Gm-Gg: ASbGncv8tYoYb/qOauBeeYbti5TjUML8Q5iPV00ngT1PVIgB5H4HXZMwusGRDEQ8Po+
	nJcZJVquOr4f5AfZh+CcpgMMxmFOBLKcABWKFSanXzpdICLY1FwEa5qVgD332+xtwKs2XalSWAc
	PKI3Hexjkl2pBOWrA9JD0RM0lndzVN+CEf9P85Y/jmtMywbDldd3RrfHJiLBOKGLdBvAPmwdiEj
	pF3CHJufI77EfZ9aLJ01A3i/Ut7es2MBolbj6tMXdY4ThVSVvGjnf3AveXgmy9CI3+0iZyTBK8F
	t1qfzJ+7ScI4ZAeZpw==
X-Received: by 2002:a05:600c:444d:b0:43d:94:2d1e with SMTP id 5b1f17b1804b1-43db6247c9bmr76745195e9.13.1743433555976;
        Mon, 31 Mar 2025 08:05:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFlnfgHPZeFzfKVU8ncu2wmMLWzUgiJHrI2Pbtb+1URUeMfzpZT/i5njkN772+REGtd1DtAeA==
X-Received: by 2002:a05:600c:444d:b0:43d:94:2d1e with SMTP id 5b1f17b1804b1-43db6247c9bmr76744615e9.13.1743433555567;
        Mon, 31 Mar 2025 08:05:55 -0700 (PDT)
Received: from [192.168.10.48] ([151.95.105.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d8fbc10e1sm123813005e9.12.2025.03.31.08.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 08:05:54 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH] Documentation: KVM: KVM_GET_SUPPORTED_CPUID now exposes TSC_DEADLINE
Date: Mon, 31 Mar 2025 17:05:50 +0200
Message-ID: <20250331150550.510320-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TSC_DEADLINE is now advertised unconditionally by KVM_GET_SUPPORTED_CPUID,
since commit 9be4ec35d668 ("KVM: x86: Advertise TSC_DEADLINE_TIMER in
KVM_GET_SUPPORTED_CPUID", 2024-12-18).  Adjust the documentation to
reflect the new behavior.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d90ae23c0a40..732e07b44d48 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -9265,9 +9265,10 @@ the local APIC.
 
 The same is true for the ``KVM_FEATURE_PV_UNHALT`` paravirtualized feature.
 
-CPU[EAX=1]:ECX[24] (TSC_DEADLINE) is not reported by ``KVM_GET_SUPPORTED_CPUID``.
-It can be enabled if ``KVM_CAP_TSC_DEADLINE_TIMER`` is present and the kernel
-has enabled in-kernel emulation of the local APIC.
+On older versions of Linux, CPU[EAX=1]:ECX[24] (TSC_DEADLINE) is not reported by
+``KVM_GET_SUPPORTED_CPUID``, but it can be enabled if ``KVM_CAP_TSC_DEADLINE_TIMER``
+is present and the kernel has enabled in-kernel emulation of the local APIC.
+On newer versions, ``KVM_GET_SUPPORTED_CPUID`` does report the bit as available.
 
 CPU topology
 ~~~~~~~~~~~~
-- 
2.49.0


