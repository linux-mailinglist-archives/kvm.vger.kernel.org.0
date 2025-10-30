Return-Path: <kvm+bounces-61505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EB88C215B7
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 18:04:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 16A4A4ECE96
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 16:59:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71AEE315777;
	Thu, 30 Oct 2025 16:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z4Ept5S6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158042E091B
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 16:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761843554; cv=none; b=Lk9TfJWEdNFEq2jEj5lxgHqncJJZK3MBKMvt//tIOG0WZeAFtG37pUllT2Xt8maCl2E6dM2kQOWMP56ztegAJjwmbLRkqiFKxxuA0B2jWuTDQ63conE43a10amgXx0aZjmSgXk8bxYGKFDCuTfi+pNKdXjXHhMURCbapLMGWvrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761843554; c=relaxed/simple;
	bh=Cj0A3QIDVPBMiKmwKKjgWt2tMKBjdb3nDiyOrIhKRaA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QeXlWDhQ5VZc9nj24LePQXzO2RQvMR/vKzMPCYp5267FWshYrEaZmwghh+DaKzR0NHN5UCpHjkr2C0yuuzPUk3PF7Q7fn7Af+rYUBSwk/ouuPM5wxJ8US4rHMT3NW7XnuKGnLCNq5+DF5/egc6Cv6d+xEFh/7lrgFprQ/dLy52c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z4Ept5S6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761843552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=c4skaTSZXHQuIRmGbiy2gxynizyJICG1cT+Q8yDgioM=;
	b=Z4Ept5S64/SEnErFc+LZXYZHsZqcR2nECxN4TelQiN4puOB1bxyeKVZwa9ff37rFrADfnd
	QmCxvXi1uAICmIffSwuSTBAsdvhgEWlF52/P/umna9iU58af1oF+yO5n0SWCnLKPm1g1U6
	UckRC4FQPAgtCzoAOX9iWCT/ydHiZR4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-bEiZ5-2AM9GBu8qbiCrAuA-1; Thu, 30 Oct 2025 12:59:10 -0400
X-MC-Unique: bEiZ5-2AM9GBu8qbiCrAuA-1
X-Mimecast-MFC-AGG-ID: bEiZ5-2AM9GBu8qbiCrAuA_1761843549
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477171bbf51so9370015e9.3
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 09:59:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761843549; x=1762448349;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c4skaTSZXHQuIRmGbiy2gxynizyJICG1cT+Q8yDgioM=;
        b=LVwsWHzuD6YvlZbtO5bIxjiTgrdZwa/1uVh0d/RASJcMOwlgqGrTQxDKV490uq9cIi
         EuqkOb0xkB6AckcVZqr+vVxzXHMs2v8kXHuGpEgmnURQJwhM/dK0bC7E582bsTHfYmV+
         pzZ7K6p8FkinhmWvKa7+191AYKX7pks0trovWKvzqV2xAcSMJGo9JCCBsKRV7SPXuQsh
         HkjYSy5DV4tsjglWzTfCgu59dzueYLdxusXScCn18T+Iu8IYisTHH0N3gzsADJdT51sE
         3cBRuP/h6vJOCFWY6eDDNdXGVJaZPoYTgj44ZkSpmKy/qkTLvl2LjyLFdATZFf8TMScc
         9/hw==
X-Forwarded-Encrypted: i=1; AJvYcCWX61gRunfK225+oc1aDllKvu1txH7QZbnJOlv8v4yvQz+1XKYvTrSmeB+yiwOEgA+CSgk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxITmaImG+aETh9msmxnx1dRrkYhx7yzU5gGhuuCOFQ16fM8QR/
	JQRJnUqzWCm0CbN/t1vjZcYI9KDwMq66IiW4YxLTLdI0Y7RyFHk3YZhJYUkH/MV1grprg2mISjK
	0CqU92EQrc37I2xyOGofBCapErmWKMSeJUL2JdE8ze0VqI3l+2hcczw==
X-Gm-Gg: ASbGncssNqf28YM+e+qcHbPzZNskvb0BolJbK958xCZ2jT05yX37gjt6SuDiQpcI9yg
	lxqd7rBDOrg1u76yVRats/WaRsQK/VQ1zDUnmXjGfDxAjlrqvUDz+EXJS1XvzNf/dzz8bfR3ydM
	2mFAUNcrJFhV8Ku1yUPjiItsXSaERP1rgN/7QP5JgElFTMdgzGlxcRHOYDgEraTNd3/XRGk7WrR
	X6OVdLkCnOx6K6hEP/3gZTMm7hrrHRh8BT9N+ijAzUVGShk3G2KhZ5ZyTxTeKCy8fyyOQ/cEtJm
	U9bOWsYjQ//P6O4HSXwojbPjATj9tGXcO5hZfjy7Q6pu+RRDcfMJnhWn1wugtAWHI8QlGzkg7q5
	a06VCIjeLV9ptS1rLlFoyQKkUCU60ZAeV2SY9PgmLBjHPcaW7dEFOroEEgrS91DI=
X-Received: by 2002:a05:600c:841a:b0:471:672:3486 with SMTP id 5b1f17b1804b1-477307d7648mr5007435e9.15.1761843549526;
        Thu, 30 Oct 2025 09:59:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEt7B6ojHr/3JYckmLT4sLA4gFFjBs0ue4eJPWN4fnRoRr5RGdu8WPcg8CocqfFNx1nXc9tQQ==
X-Received: by 2002:a05:600c:841a:b0:471:672:3486 with SMTP id 5b1f17b1804b1-477307d7648mr5007155e9.15.1761843549096;
        Thu, 30 Oct 2025 09:59:09 -0700 (PDT)
Received: from rh.redhat.com (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477289e7cf5sm51104085e9.14.2025.10.30.09.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 09:59:08 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v2 0/2] arm: add kvm-psci-version vcpu property
Date: Thu, 30 Oct 2025 17:59:03 +0100
Message-ID: <20251030165905.73295-1-sebott@redhat.com>
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

Changes since V1 [1]:
* incorporated feedback from Peter and Eric

[1] https://lore.kernel.org/kvmarm/20250911144923.24259-1-sebott@redhat.com/

Sebastian Ott (2):
  target/arm/kvm: add constants for new PSCI versions
  target/arm/kvm: add kvm-psci-version vcpu property

 docs/system/arm/cpu-features.rst |  5 +++
 target/arm/cpu.h                 |  6 ++++
 target/arm/kvm-consts.h          |  2 ++
 target/arm/kvm.c                 | 60 +++++++++++++++++++++++++++++++-
 4 files changed, 72 insertions(+), 1 deletion(-)

-- 
2.42.0


