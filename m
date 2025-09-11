Return-Path: <kvm+bounces-57327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 594BCB5363F
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 16:49:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34B4A162953
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 14:49:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27C393451B5;
	Thu, 11 Sep 2025 14:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C4wpGRmh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5A333EAE7
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 14:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757602177; cv=none; b=PwqpKnSHY1SCgLKe6HGS9Pw9r5kHDMcoiSvXhPCTUC+G+04gEzXBec4w4oHPzXXdm4LfPuLbhcAwJCZ2X9+BgkC1IYOsyYof2ZAUQtyUiph5Gynomte2Wc6Tn8QIYzcHPkHiYP/ED9xnlqSrOibVWqGI3vfNN6VlZwVrKaWdOFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757602177; c=relaxed/simple;
	bh=f4itS6SmhD+1bAHAW2RGqoDzpqerAJXPPgtLewtu/Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UB+EuH/EAYTyMF5tiPMYEwtb7mYfhrgxPlRIMCLjZW6JhpPF3Se9XnV0PhnRnIBs3HDjuzefYgPUZ01UYMR87MZgkHQXU7BdUv0055u5sDh0O8VULaBsPQcXGvQr5QPR4oFq2mUtB1Cx+AKK2tPuYvJfDXitW4T3fMgMnxT9eLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C4wpGRmh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757602174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oF2cIsPBN8qXmdEgTfizvTF3d/SEeert5/n3uAYGGo4=;
	b=C4wpGRmhTeB6G/+Qrfw6t0zLgxTkbHRkHUPGvLg6o/KTInK7lV2UV8Hv7i5hSHNx9O91Lw
	RfIMRI5+h/vIiOsNTsnbMi93nuTMKauNyAawEtrqobD2MptZ7v5TMP7qCDEMHCR0gi9kLb
	OdlH9YTWS/p0U+MLplcx+bA6Pz6RfCY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-NZa4sPk5OJGw2xWIAQl_rQ-1; Thu, 11 Sep 2025 10:49:31 -0400
X-MC-Unique: NZa4sPk5OJGw2xWIAQl_rQ-1
X-Mimecast-MFC-AGG-ID: NZa4sPk5OJGw2xWIAQl_rQ_1757602170
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b986a7b8aso8135635e9.0
        for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 07:49:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757602170; x=1758206970;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oF2cIsPBN8qXmdEgTfizvTF3d/SEeert5/n3uAYGGo4=;
        b=lbejmUM3N0Qr4/225Fpdyy11s2piOXvsudCUZIBaw/MfATzLyMXXAOA+WfJYBBVMUI
         REciNk2q4yIgacFnLn6j4RicGi3DCFEfZxsnWLZUoJZ15o7WGhEVGgK+um76gF/d7YaH
         tzhdoL0YUIGLoxTxtph0Vjj8NKIU7dOY1/5ny7H75ZAqfDVFWd1EyyFZa8UElw4Tstmo
         1z6viDKESCZD5xebwpo7p0UjoL1RlUToSqLyA7ZLJJ86iv6/teEK0jxGQDg7ijMUzotS
         LydUJoPKkbmjQOklxtAItJxcoxXRqk1IuCaDN1n1uzbQnVhPJPHFzZxmJPToQozA2/ft
         8Saw==
X-Forwarded-Encrypted: i=1; AJvYcCVbU6CGcsQKwX79ZmlG1G8ndb9K7+hoiiznNuTVTMcm4MxNUfxrokhtCcVGJGmAQrcc9tw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/2sx44zVQMqEpbuZ72c1CuH2SG5/F5dXMevwpLBMBEQ1yS5nN
	W1njY3JB9gsoOs1t6WJZrfljW+egeHUS4Sd5vQrerHgqUcE9+dIqn6kzFJ6YHKF7HNADdo9OzUX
	QYGbGvRUAjA9E3rEIXOn0cRIj1EpwtYt9C9ibWoa3M2UoTb4sw0Tf8g==
X-Gm-Gg: ASbGncuG+urdurocS7y/505A2yoVRcwVfGsJ9GjKxh/MdxTxO4wC25lpMGDRpONILhD
	yG4nFXjkMmN6WCbD2Qi6NZqNeB4CfeLgpeVFJofDZ76hsXi+pjg9wl39WkqCy3lwsLpKAOfc8AW
	1n46WWSGC7SIRepY+JnCqBxaStvjtXl9iGD+qY/qIx7RUhS4YjWNMG04EENRVNlN1XRjKX6oVlv
	ldVXucPstlItAVkCzlqebvJv9Y6FaAdcPP6dcKA6C/X1PHWPBDTEq3a+KK7ND8vRlS7ULW+mMrz
	9Okpkc1iz88+fJaUvidTF+qRwQaHFNGOShWzv0xIdvS6WiWJFUAcefQP0+4OWwc4c8/6nXHYxn9
	gZzLVYJfzC3CAJvCjwQ47vn09Q3so
X-Received: by 2002:a05:600c:4688:b0:45d:d2d2:f095 with SMTP id 5b1f17b1804b1-45deb702e1dmr110544245e9.19.1757602170327;
        Thu, 11 Sep 2025 07:49:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF8qtF1qAnlROs8xNUfS1Rs+dPLZYcpuM3doPWb7N6ekPV01fUhC82BPE/uzS0/3A1DBuiZ9g==
X-Received: by 2002:a05:600c:4688:b0:45d:d2d2:f095 with SMTP id 5b1f17b1804b1-45deb702e1dmr110544065e9.19.1757602169950;
        Thu, 11 Sep 2025 07:49:29 -0700 (PDT)
Received: from rh.redhat.com (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e0159c27csm14941575e9.8.2025.09.11.07.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 07:49:29 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH 0/2] arm: add kvm-psci-version vcpu property
Date: Thu, 11 Sep 2025 16:49:21 +0200
Message-ID: <20250911144923.24259-1-sebott@redhat.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds a vcpu knob to request a specific PSCI version
from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.

Note: in order to support PSCI v0.1 we need to drop vcpu
initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
Alternatively we could limit support to versions >=0.2 .

Sebastian Ott (2):
  target/arm/kvm: add constants for new PSCI versions
  target/arm/kvm: add kvm-psci-version vcpu property

 docs/system/arm/cpu-features.rst |  5 +++
 target/arm/cpu.h                 |  6 +++
 target/arm/kvm-consts.h          |  2 +
 target/arm/kvm.c                 | 70 +++++++++++++++++++++++++++++++-
 4 files changed, 82 insertions(+), 1 deletion(-)

-- 
2.42.0


