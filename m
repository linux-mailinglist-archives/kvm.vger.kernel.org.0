Return-Path: <kvm+bounces-61506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D5FFBC215BA
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 18:04:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BF7334F3B5E
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 16:59:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EAD332E69C;
	Thu, 30 Oct 2025 16:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P/3DnzAb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5563161B3
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 16:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761843557; cv=none; b=B74GSyuvzo/kly1z1OUvMyW5v76ulU+4EeJApDqfDO1d4RmDK7JNegjMpbaPzAu9uCR4Ocpr4Vvh8JISa6MxIlj4q4sVGJbu/mP7ktCYT7cFs9E/wsL9GCkw5grQSFU9zdPfwAeuoaQCw/DJUoP2dGhERevCjbRFyq/P8+hTwic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761843557; c=relaxed/simple;
	bh=w4AiSi8ptQwSr8mcpa/oN3zet3lqMxfDUN+SznFdMFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5J81i83Yn3X2TpDB0TzhNnGkjTVm6qGoZqNNaySVyQmdtNAzLt+xzmMz4q78b831pyvETIoYyz5a+hgEuubz8uwDc/gYSQGJlzD8m0uWqhe0s3AP3eMCe9Q3IsT+N0wXHnfrj4+z++n+NlnGahm+C6jdpN0XJLVChcoYRm/OmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P/3DnzAb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761843554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hWmmkEUNuPGh9RNwegX9zD/J9TxS8gEM8JXHywhlakk=;
	b=P/3DnzAb29F5+AdgVsLIBHGPexTmrKosy2to86oEDYovmAgHf946tbZcN9RzzpeuujUu5a
	fQzMkJm9KY4Zhh+uCR5LUUxr26EtR7P3vVfOURYcgSyHdRcEwkXeXLaIP1K1pxxWWVN1HN
	CFlPTLEdKxIMl1askSYQoa0Qe/2b8zk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-486-yAmaSDg5Pc6eaR3pvaSqPw-1; Thu, 30 Oct 2025 12:59:13 -0400
X-MC-Unique: yAmaSDg5Pc6eaR3pvaSqPw-1
X-Mimecast-MFC-AGG-ID: yAmaSDg5Pc6eaR3pvaSqPw_1761843552
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-475dd9906e1so8124605e9.0
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 09:59:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761843552; x=1762448352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hWmmkEUNuPGh9RNwegX9zD/J9TxS8gEM8JXHywhlakk=;
        b=aYYOKPdP1MoSovTyhik46Qe3oT7xyz8erHFOrpuE9qFdl0VsIVa+BbsF0Ob0zE2M9h
         owBcojLzg59VgZl2zwdBxxIBQcMFJRodAdsvMsCWMRnaDj8ZBduzBzsusXn7Wtdthzyi
         xevUKKgKsYdSqLjIPuw9AHKgud9hud7sA+cpoUpJdE3+BW8dgIMHHIud2F1UsFE4ekYg
         4BxpcHMa0wQgKf5cJLjt4eS20gDr78JcnG4Gr1UXh0segK1WCRBPKMZi+sJGod00wCT6
         l9+WmzdUDNx4vaCx+TZ6Or6hFgUdkT3QWd0fkzMnx7aL86IdhIyjBUJB47mXqL24Iw5B
         C0rA==
X-Forwarded-Encrypted: i=1; AJvYcCXJH784nyMBdQyeHrUN6rnQ1AgyS7t68PGnrA9ppPSBUldVBsC3NcMaB9t/Pq3E/EARUsk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRfSHctksQI8pMeel8/GL0uotqp7xjnMwauGCOzy+PrP4c4Qo6
	lMXnsZsnOIM6518N+D17nxCXuH5l4DnEaHpptSeCmSnBUgiu+tAU4v6J1qY6Itfxi6DsCl6fmHd
	/V6PB/LzySz8yumVI8yqoJVVPIswI9Gu/IgaSq36hKR+n3bAXe5V9Pg==
X-Gm-Gg: ASbGncvs5P2P6Ek6/2dFpyAN2FJWlfEg8+UhHdmOEIb3AjGn5bFzWd0dwTUAlnczeJQ
	3iafKl0lkM6xv669MASQ6aLytxScQjsNJH1zlzjC1a+zg9kQAAKNM5RD9lzw2QD20bLPm4rUitO
	MkrJKccL3dN3LUtfaQkaowTwqyacdxqyMSr3B6stuEPQd8H6PKAFQd+yy1hqtQ+GRby9apj6bBU
	MKUIdLEoE4IOAptpQOsi4r7dM7hNrOgJyPfPqpVgJRCQg8dYZ1/AHHcfschv44nrrf5otCyO0Qc
	/nH4l22p0kUCjc3QtgLP+xfR16FlSMkyME5VGRRetebedc0Dy4KEzHXA8QibsITV0hYdoQ36/GY
	Og5qwLRB/9XCloemFqxLZMHHEJ0GN/m8GwDU8nlDLDN2l+Mz/2rPyBi1bwy9TvoQ=
X-Received: by 2002:a05:600c:34d0:b0:471:114e:5894 with SMTP id 5b1f17b1804b1-477308721b1mr4431735e9.25.1761843552027;
        Thu, 30 Oct 2025 09:59:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEdysDVvnycX2QFcyER9PBsXwHxfA4shM0ptgu5S+ePqTnpY3IFDLDiXiVx7sJ1KtjfLnplcg==
X-Received: by 2002:a05:600c:34d0:b0:471:114e:5894 with SMTP id 5b1f17b1804b1-477308721b1mr4431485e9.25.1761843551618;
        Thu, 30 Oct 2025 09:59:11 -0700 (PDT)
Received: from rh.redhat.com (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477289e7cf5sm51104085e9.14.2025.10.30.09.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 09:59:11 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v2 1/2] target/arm/kvm: add constants for new PSCI versions
Date: Thu, 30 Oct 2025 17:59:04 +0100
Message-ID: <20251030165905.73295-2-sebott@redhat.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251030165905.73295-1-sebott@redhat.com>
References: <20251030165905.73295-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add constants for PSCI version 1_2 and 1_3.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 target/arm/kvm-consts.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/arm/kvm-consts.h b/target/arm/kvm-consts.h
index 54ae5da7ce..9fba3e886d 100644
--- a/target/arm/kvm-consts.h
+++ b/target/arm/kvm-consts.h
@@ -97,6 +97,8 @@ MISMATCH_CHECK(QEMU_PSCI_1_0_FN_PSCI_FEATURES, PSCI_1_0_FN_PSCI_FEATURES);
 #define QEMU_PSCI_VERSION_0_2                     0x00002
 #define QEMU_PSCI_VERSION_1_0                     0x10000
 #define QEMU_PSCI_VERSION_1_1                     0x10001
+#define QEMU_PSCI_VERSION_1_2                     0x10002
+#define QEMU_PSCI_VERSION_1_3                     0x10003
 
 MISMATCH_CHECK(QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED, PSCI_0_2_TOS_MP);
 /* We don't bother to check every possible version value */
-- 
2.42.0


