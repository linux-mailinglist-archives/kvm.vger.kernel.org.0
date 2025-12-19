Return-Path: <kvm+bounces-66429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D99CECD232A
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 00:39:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 21DE33061280
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 23:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D12A92F0692;
	Fri, 19 Dec 2025 23:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J+Ht3dOV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5AF2D3EF2
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 23:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766187509; cv=none; b=INXcqaAiTYHtxkIwFkcG/9hnDGpk61AnaBMXqVKcZj9SOzbv+Ke8aikuhgRbVz8/KogUNBxLP2A+k/7lcH5aRHAtgTq3sKQ8+mze0rgqcW4UncOkw9rx+HACQT9YpHF7FEh5xyYpDrNxZHA7JBqm0HB7i3ZO6EPDvyzPQRAQ2hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766187509; c=relaxed/simple;
	bh=/+AGKRNSS+uF+0YmBMyl5tXf6XXogWL5c7gic6FqdHA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VOlKYMcoMdzdc8fuCzj0izP8SSPPIwojoIHv8fqn6K8wpDpGFoSmYq9UEdZmhja5WJucevcKFOKIQgSnrEUhEgmI/g1wNCiUBlDSsX1JczWsgiyHJgGQq0lT3yRc2dLYYb4RkOGlYYXahlu3YutqhVvF4zFmIYFNSVif/5ptEMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J+Ht3dOV; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b90740249dso3934610b3a.0
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766187508; x=1766792308; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C9QFtmNn1fSYGFAaSlaEhnDrHjK6Ba3UZ+o+JdNc1Kk=;
        b=J+Ht3dOVdle9BUbBneqlfOvUx3tAhOqNLMF5nMCIMQ+tSK1AW3e/pjXkc35hqQWs4l
         gTu1QPYQO3w8+53VaMcRy23pp7M/I2agafm+dImkrocPWsaHXmFMm7qEztj0UvN6CXUb
         rFDJrtkmUCmiJ+9kdsUK0YRatwTxtH8+yOllOiH5lUM4E3XejdJaHp3aqm8QhsrVtkMc
         bKaBHddaFbVKsRQbXLF/jwTWbyGt4Pn6X23WoJD+ixGwKeEhb3GekhxrvHSagL/KcQzc
         cvRyR713J9o4VX0aX+jQ2SlskxxoQFb3nNFzPAkf3SQiAspeoBBcHFjc4T7I0FyBnnuS
         TWNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766187508; x=1766792308;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C9QFtmNn1fSYGFAaSlaEhnDrHjK6Ba3UZ+o+JdNc1Kk=;
        b=dnl2g2CyyKStbTUR5JF22gB77ahdY/ER9LxztsE70c5omIT4dQtoBDSbedTT9WeAds
         82oahvkXltHY+h0gLQ/r7tH7c8hUZMg0G3KU21oeBij5pmP5jhkBhw34gvve0scJ3NOr
         iMdcmLxQPFA+1NRcFi0pmcnQkLaldY1kLjruZKnDUYQGcdWOfr39kDEK9KLxhmbj6CLY
         wOXgyYIScuix7u9YIvK//DhTPgWQVCmdGpUtV6ffe/53R+9VWYN5TtHdhRojm1r9TmI3
         3iF1ZlmEMRRw4qPdIqpJKDaD+Jq2CnfnnTPxlQm6saWGBctfqd/xEZNqor+iWCS8Mhsf
         JSLw==
X-Forwarded-Encrypted: i=1; AJvYcCXkKKD/Re41DbTWa3vmy7wvyMI3QKhGu9ldhCyU+Qoxa/8VamAuSzR+ml7k62CjCuYN+wc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzv9afltvQEVfm7lTJsfhe0nXrTWMEOpSt2DiY/0VeFngBZOAwe
	rJrar2FpqQXhjyri95PuXkCabwk/+/guOkecnRQDigzqlFDkILpQWK1ckBMZIMCXwK56QoDozIq
	GIsAkPmBLMGEhIA==
X-Google-Smtp-Source: AGHT+IED2KQiUi/cz01nSHrPqB0DVKiLe95LbUVmtbI/s/CFr3dErQCP8IrnneW5VYeTPjnU60u3FKnJmJnaZA==
X-Received: from pfj19.prod.google.com ([2002:a05:6a00:a413:b0:7b7:b98e:7a9c])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1d27:b0:7e8:450c:61c1 with SMTP id d2e1a72fcca58-7ff66679547mr3739825b3a.49.1766187507834;
 Fri, 19 Dec 2025 15:38:27 -0800 (PST)
Date: Fri, 19 Dec 2025 23:38:17 +0000
In-Reply-To: <20251219233818.1965306-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251219233818.1965306-1-dmatlack@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219233818.1965306-2-dmatlack@google.com>
Subject: [PATCH 1/2] tools include: Add definitions for __aligned_{l,b}e64
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Alex Mastro <amastro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Matlack <dmatlack@google.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>, Shuah Khan <shuah@kernel.org>, 
	Wei Yang <richard.weiyang@gmail.com>, Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"

Add definitions for the missing __aligned_le64 and __aligned_be64 to
tools/include/linux/types.h. The former is needed by <linux/iommufd.h>
for builds where tools/include/ is on the include path ahead of
usr/include/.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/include/linux/types.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/include/linux/types.h b/tools/include/linux/types.h
index 4928e33d44ac..d41f8a261bce 100644
--- a/tools/include/linux/types.h
+++ b/tools/include/linux/types.h
@@ -88,6 +88,14 @@ typedef struct {
 # define __aligned_u64 __u64 __attribute__((aligned(8)))
 #endif
 
+#ifndef __aligned_be64
+# define __aligned_be64 __be64 __attribute__((aligned(8)))
+#endif
+
+#ifndef __aligned_le64
+# define __aligned_le64 __le64 __attribute__((aligned(8)))
+#endif
+
 struct list_head {
 	struct list_head *next, *prev;
 };
-- 
2.52.0.322.g1dd061c0dc-goog


