Return-Path: <kvm+bounces-72117-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IPG+AoPooGndnwQAu9opvQ
	(envelope-from <kvm+bounces-72117-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 01:42:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 50EB31B144C
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 01:42:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8AE353046538
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:42:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 163B327381E;
	Fri, 27 Feb 2026 00:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b8NZluiR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E9026B2D2
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 00:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772152954; cv=none; b=WybUzzcsPu/tIk285WFaQfnlOq6Kyqp+8Mm4jl+N0dJlB58rdADOA3Qdjsu5ttp6wGdHiO2Ujz8lVH0tJDKDbyEHTZnHqeydZyb3yDUqgjeoNFV65/tsmSRRGEdVZTysOBXaHRYPNGy3+I15NziUIceg0Io/VZ3+Dx8X3Iz+yHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772152954; c=relaxed/simple;
	bh=MVhpYkWxt+UA+IFF0kimPBU094n6yJhh4+GeSctGQJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ny1IZyPd7QJgTglL39EEPjdyorzfcIBMzJluhl8EXt0AY6+zbXUz7MmaRJs1ivlvWn+Lq2Vl4ejjuYfT4wyh5NAXmkd6s1JMF+ZNhhGP9cOZWjXjTEd7gvrwAki2d6d1LzzwAQvGcoeE3ToHvd3QF2omUj5izza6i6rnTrRIr3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b8NZluiR; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8274843810cso443023b3a.3
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772152952; x=1772757752; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CivCSSXjOn0EK8t0pg9P9WXCoBW641fvR8TqbUzXcro=;
        b=b8NZluiRIpU7flFgTvh/j7hKMm9T8QDwUvOkWugJwb3aU8rfijKHry+eKlovVr2zwD
         Y1wBdb19Iu+ZbfkSu6wj1Ru5BoJMYaLLoPbExHi21mfGRxcGKj8EtPYcn0HLKS4LrDd0
         h9SS/V8N1yQD7ebf1Y8dC0nY7Wqq8jZr2DSIVgO6Hf8MBgxZhpwfpYHGdwROSfFPTwI3
         uNparyofTz2vQ8Vtj6bxA1MpTeDnwThMdpIKMYHd+2kHO6k6xfbK69E/bUlSBIlZrTt2
         uXQlEAIE3czLOzw8+YPGDNy8yYKSCn4ynI5F4d0UJoiHrw3sUPtTYJ7nBZUSWvik72OF
         Xm1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772152952; x=1772757752;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CivCSSXjOn0EK8t0pg9P9WXCoBW641fvR8TqbUzXcro=;
        b=NwjrdGYyGPrDgEK4ofB1P9qE7bSq5PyhitwfF5hcoQOkOitu3o2KEt349OQR14b1DU
         gDMSEr1EjrQbXk5F2IjbpXIiESYKvSwR3dx/nq4/xSBfG2yMhu9F7a2XeTKt3R80spNp
         02XCevHW/94pHCB85HYQ8INPJbqLsrIvhv3CCAnPoD/qWhzQSjd9hL3j8cWXf02A5c7L
         hgngciwbLg3j09S5F7o8d8k2CQeNrW5l5+3xmwSD7WkrrWp/tGKC4dul8DDsZP5utnZJ
         YppgCKnS5RFMPoXCfY6PBCp2LrXT7Su1vLICo891YKcJBvmth2slw6Ldn0LcSOZIsCb5
         usPQ==
X-Gm-Message-State: AOJu0YwytOplq3v/OZNP2ixXKl/0ayo/yYfroD4ur10XAx6bvQciXcL4
	Q/1oQBpIfaGI6IKi5BgyL7Gp5Wg3KPe8qdWM8Ut6WYkBz4e6gcYrQYe9uWvk1X9yebfrLw==
X-Gm-Gg: ATEYQzxi+txa9u/dFTjOpMO7+Bg4XLx6SlqAcdm6XvcG+5XQpBAtDQIjeJo9eUl32/p
	2koqGJLdfKQ122IxIZPkE3N3u9Zog60d8mhITDP65u/r5q+YVgJj/271W3QnwV8wBNda2d+pTjA
	u5mXRv7fYonxpAtOLHdJDU7vY/XcpK6Ep0gtie2faML8dzB4fKQ4LLPMrpR5mcM2PMia+GYSvH9
	Fhqr/pUjgSt5dplDIRneNdfIzbx+XqyW4kSji3QVnsQm4+6y13qR6lc04X1Ge8SAb2DYD1tWYGK
	xVJ/+XIMxYur/2bnI20K0emj8bH5yJIsTUU1eEDmSHbaGjxxYG727Pc9dwTgQMR2cfWc6gLNG5S
	6uZ7QghCvLTWgph6KiOq0fvTT5eC1CSbT5fGL6rsb8N6q1VMGBPRG8tstWYYsR7HFKw5pom6sNK
	UoyHhS0gTdz25uWRPlIUtQ38PRTYkOsaU9SYwTGw==
X-Received: by 2002:a05:6a00:a85:b0:823:1c2f:e9d5 with SMTP id d2e1a72fcca58-8274d97acf5mr1056684b3a.26.1772152952308;
        Thu, 26 Feb 2026 16:42:32 -0800 (PST)
Received: from localhost.localdomain ([101.201.173.233])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82739ff372fsm3501030b3a.31.2026.02.26.16.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 16:42:31 -0800 (PST)
From: hbuxiaofei <hbuxiaofei@gmail.com>
To: kvm@vger.kernel.org
Cc: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	hbuxiaofei <hbuxiaofei@gmail.com>
Subject: [PATCH kvmtool 1/1] linux/virtio_pci.h: Include kernel.h to provide the __KERNEL_DIV_ROUND_UP define
Date: Fri, 27 Feb 2026 08:42:24 +0800
Message-ID: <20260227004224.269441-1-hbuxiaofei@gmail.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-72117-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hbuxiaofei@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 50EB31B144C
X-Rspamd-Action: no action

GCC Version:
  gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-44)

CC       builtin-balloon.o
In file included from include/kvm/pci.h:7:0,
                 from include/kvm/vfio.h:6,
                 from include/kvm/kvm-config.h:5,
                 from include/kvm/kvm.h:6,
                 from builtin-balloon.c:9:
include/linux/virtio_pci.h:326:2: error: implicit declaration of function ‘__KERNEL_DIV_ROUND_UP’ [-Werror=implicit-function-declaration]
  __le64 supported_caps[MAX_CAP_ID];
  ^
include/linux/virtio_pci.h:326:9: error: variably modified ‘supported_caps’ at file scope
  __le64 supported_caps[MAX_CAP_ID];
         ^
cc1: all warnings being treated as errors
make: *** [builtin-balloon.o] Error 1

Signed-off-by: hbuxiaofei <hbuxiaofei@gmail.com>
---
 include/linux/virtio_pci.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/virtio_pci.h b/include/linux/virtio_pci.h
index e732e34..fb2f66a 100644
--- a/include/linux/virtio_pci.h
+++ b/include/linux/virtio_pci.h
@@ -39,6 +39,7 @@
 #ifndef _LINUX_VIRTIO_PCI_H
 #define _LINUX_VIRTIO_PCI_H
 
+#include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/const.h>
 
-- 
2.43.7


