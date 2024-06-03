Return-Path: <kvm+bounces-18611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E86458D7E7E
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:28:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A47702820E4
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 09:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D8BE8060E;
	Mon,  3 Jun 2024 09:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KdAyh7e9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BFF7F7D5
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 09:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717406885; cv=none; b=gl6jwopdCI2wizh1TJlOJSOL5oOCD7Q3Nl/ooZWrrwBw2MD2Bf1jbX7XRMKmeQ7vwM0kCzccDeZftggfGoMlGgFXM4fUCA4k/miAzCD3ZS2Tm5ytgA3fkxGwrULFCxrAVmcSAHbJrrI6XDqd7DDB3gXGJmsWPP8eJGibt7iu6QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717406885; c=relaxed/simple;
	bh=kVnt0kroj53N+6U0/GGVpayIzzxTTb+2W/k2pwdxYy4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DRKqAoNlbVRI7uuH0AEtICe94diPxkA1LHvrMnnOTo2bKwibYILzVt9uQKiV9tNtCyXROvtUqQ/1242QFl6kjKzXjorGXATsWQXl7InJXosAkNgGwRPZ9xzQU1KlwxqDP8emQAnn6ukHc00ZSVhdajAhetBq2ErPAda141aZdB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KdAyh7e9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717406883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LSIJEcdao+bNuJ0G5dz/Sy9b8q+CkRCGmBFERtgc6js=;
	b=KdAyh7e9OGJUbrJCdajqNy9bo5XLrCigO/eiekNwjlTFor+oAVmQlRP6xJkihYyRKDZdyZ
	ONAC9k+u5FQTjxiOthqLl3nyR+PwRXzZvUugj92i3eQqbndH9Q4xUCmlLvlq7IvESPhnJw
	PNHR4ZkQkNvAd8bjxo/ZaanNx3yAiHE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-NPTKBpWcOPWYIO-tObtNkw-1; Mon, 03 Jun 2024 05:27:58 -0400
X-MC-Unique: NPTKBpWcOPWYIO-tObtNkw-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a68e0faf0e6so81913066b.2
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 02:27:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717406877; x=1718011677;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LSIJEcdao+bNuJ0G5dz/Sy9b8q+CkRCGmBFERtgc6js=;
        b=mqpSlOVx2RdFMc0G7N3/f7uBg9VW4LiQiMdEQTXW4mAogOHxaLXUoD6RRSRKQgG5W4
         /ttg4/PvQ0DrrsJylsNUlNvCNozh8X8FpfjhwjzdBDqw1qbIfoeh3LPJA/Wj3XTLjlWj
         uJc3hM8kodROI7l8N3YkmJhdy5pWvFdGiCsw0AmrrTCpa8s0AUKM3MFuTNvMnRGCa6Z0
         RWVhhnGR4b9G0Mxd7EMmk7IfrxaKCAGn/xjIj6U/576R6hPnxZF49U1zuAXfZU4wbefA
         rh6qVRRfaXvpS5Z46PblBp+bCuZhPmrD9yH1tNWNcur/ecRw+UdpN2xQR11TXnC81504
         9Etw==
X-Gm-Message-State: AOJu0YxHt+h0tUzsdHLeswJ0zlyA5ueSTIztT3tSQCVjNYoOskzODTre
	WQrbf+n43eOyje7pAzw9CmB6akwpd3tqTrTf/H8qLFzwdCiXaq9UZa9O+/tQMerMnJTVlPSaxxh
	5vUTGV/52rVRXhBZv7cayYnnM7jVfabQKB6bz76xdcTEdE6JnUEO+J4fglAJRQgiLiUET5PGPsw
	xN9SEZNyX2+9Q79EcDEzPAWwvlR2OL1q2Vzg==
X-Received: by 2002:a17:906:66cc:b0:a67:8fc4:7ad1 with SMTP id a640c23a62f3a-a6822636f02mr548296566b.63.1717406876822;
        Mon, 03 Jun 2024 02:27:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExcLuCJbIqaZVu+d4jSid2OtkK8WVOvmSpWGDkON9r6oyQ0Z80oZU2QkdRErnFEvOrtzH8bQ==
X-Received: by 2002:a17:906:66cc:b0:a67:8fc4:7ad1 with SMTP id a640c23a62f3a-a6822636f02mr548295366b.63.1717406876303;
        Mon, 03 Jun 2024 02:27:56 -0700 (PDT)
Received: from avogadro.local ([151.81.115.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a68e504139asm248773566b.47.2024.06.03.02.27.55
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 02:27:55 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] svm: allow CR4.PKS
Date: Mon,  3 Jun 2024 11:27:53 +0200
Message-ID: <20240603092753.608379-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

While no AMD processor supports PKS yet, QEMU does and this causes a
failure when running SVM tests with TCG.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/svm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/svm.h b/x86/svm.h
index 308daa55..c1dd84af 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -362,8 +362,8 @@ struct __attribute__ ((__packed__)) vmcb {
 #define	SVM_CR3_LONG_MBZ_MASK			0xfff0000000000000U
 #define	SVM_CR3_LONG_RESERVED_MASK		0x0000000000000fe7U
 #define SVM_CR3_PAE_LEGACY_RESERVED_MASK	0x0000000000000007U
-#define	SVM_CR4_LEGACY_RESERVED_MASK		0xff08e000U
-#define	SVM_CR4_RESERVED_MASK			0xffffffffff08e000U
+#define	SVM_CR4_LEGACY_RESERVED_MASK		0xfe08e000U
+#define	SVM_CR4_RESERVED_MASK			0xfffffffffe08e000U
 #define	SVM_DR6_RESERVED_MASK			0xffffffffffff1ff0U
 #define	SVM_DR7_RESERVED_MASK			0xffffffff0000cc00U
 #define	SVM_EFER_RESERVED_MASK			0xffffffffffff0200U
-- 
2.45.1


