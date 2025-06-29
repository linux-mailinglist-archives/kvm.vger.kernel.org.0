Return-Path: <kvm+bounces-51051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04848AED0FE
	for <lists+kvm@lfdr.de>; Sun, 29 Jun 2025 22:26:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 385B93AFD14
	for <lists+kvm@lfdr.de>; Sun, 29 Jun 2025 20:25:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAF6F239591;
	Sun, 29 Jun 2025 20:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mind.be header.i=@mind.be header.b="B8VtBxJ6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4322D23C519
	for <kvm@vger.kernel.org>; Sun, 29 Jun 2025 20:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751228547; cv=none; b=rfeCs7vw8Mep7kjoBmLLmRyVoD+QFU+MjyF8J8yj3qy7ypoAMwvq+hnuK/bQLbjCQF+RLEPJs3qXIhD01A+gE6aeDhih3BF1zilmtcOwDzhEM2jqp09qRKvfnE4MS5AoBsVjS942/aM0tanB9yt0QeZ8ZxFMaYwRuAUOt5anZgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751228547; c=relaxed/simple;
	bh=OJqmNM7B0zztOupdOTvcppG3308y1Ai4wgi97D/Skwg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WcYz1zGFaxOAwDsvMYW4VTsbICjeHz21/oESKh5XgjLY7UNj0VIzAXMDCO4ieuCsPI6tyfkQy9G34WVzW0dI1KLC0zxw90h3wQAnRfPdQNadMg5U4pOBw4hFnP1vT4mwBP5XJAqZAR1nfcTOCFRUOvy4KxswkRwql6NmTNRz+Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mind.be; spf=pass smtp.mailfrom=essensium.com; dkim=pass (2048-bit key) header.d=mind.be header.i=@mind.be header.b=B8VtBxJ6; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mind.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=essensium.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a52874d593so1206682f8f.0
        for <kvm@vger.kernel.org>; Sun, 29 Jun 2025 13:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google; t=1751228542; x=1751833342; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qzJUEEyMsY77uKBTreXuiyIBY5zWQZVNm+Qz257gMKU=;
        b=B8VtBxJ62M7zlx6TRqqbyuTDxPeGI3p/wRN8QBr3RM8gorsT7ae+T5V+udWABBScfT
         P6m7Y3hl+zK5OoEEZlEftDcTHCtbowTRwpWIrWOEEZG02CKTvuIawn/zSGM7UcMe0+6U
         qKRMA5Auda5UqX5jlwoKJXi9a8IqMRtG76MlA9fYFQoySDHnnvDDeSI9MBs2C0FLWo5Y
         7UXaGew3n//+dSwVtRytYq+V3OwOCxlxqQKMeoGNraf1EEIfCd+cxQlBGnUg2g2N+P6p
         MTtjl2ZLWbmxJUnmcrNICG/ARvWHp90j/f345DVtUal94Nj3LjNeGFnuEDGT67sPhhGd
         SDIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751228542; x=1751833342;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qzJUEEyMsY77uKBTreXuiyIBY5zWQZVNm+Qz257gMKU=;
        b=ASRO1o4lkg98eX6ylaSKWDuoU18x0g5lAeXBm83OMwbLK4VeNizrOuuc0XY1zy1+Cm
         w6t7aS2/i5hTjERkQuG+tHy0XE3OSQzYCanHzmu6JcoLwh91a+3ibrs2Gx/UFQ0bFg5b
         yS71ad38TOAyicdvOZVSDEtmm2V4X7DEGneB0DEP97wNJy/UT/JyUKy+pGd0BGAowG+2
         alD7Iw91JKiRYCB044a3oJQq5I6J95kv4x2oGqe59kuIA/k2dPZe0kSnja5VMloXf+65
         1xDNf0USh9nhs68nricYnJxdloa43Uiehqn1np93e5rWU9P/7fmbs/IsekpOXM91S7kx
         Wt0Q==
X-Gm-Message-State: AOJu0YxqIzTUK4DwlFunJGMxk1mBVcAm3Ac/kPAf2LY5U8HCzzmOds4N
	vFKIVa7ympB0vANLALROE3thgZ//dHj25jW/EnFRagXw4SdW2KR6406GBd9pjxfqWhvXx04YuIm
	kfCiV
X-Gm-Gg: ASbGnctEwYxUkpnojsQgr6onOb1oZqFv9tiJxMUTih489Z0OtVRrL+5Alb3Rw/WDwUP
	xn+WDtICWCCiBH8l6ishlxYM+TU5MhaSoz7W+gEDUtrS54iVLvVenqaE0IGpULRU3/kS/Mhc13J
	e3aJDu7ZcAHkTgqrDlzYsV/O1D0a+PVyRAg4fJP0CPnTmU4OI51QZHES5xW9veoctArJkUpjygq
	IuEaZzZt4ZEhksB9JyQHKjzm8wt2R7d1twrhX+uKRdi4+AMJg0krIpi5Z8IKuGi+74nptKzX+2E
	n8UsTU7TUGVfoJAjz9ihZvqKUTLb1RSkRj94QsngO/w4tg2lh/fZNkh++sgNrEarBtHGgPDwlac
	l4PpstXCXc4BRNpbAyxl2
X-Google-Smtp-Source: AGHT+IGKTp7zELSfQ2JlpzY0sjDT0OV3kApCVgORic+kkTeZKca/kODK76rZho0QVrSUziZOViJBkA==
X-Received: by 2002:a05:6000:40cf:b0:3a5:2ef8:34f0 with SMTP id ffacd0b85a97d-3a8f5d43529mr8772514f8f.22.1751228542293;
        Sun, 29 Jun 2025 13:22:22 -0700 (PDT)
Received: from arch (94.105.118.175.dyn.edpnet.net. [94.105.118.175])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a88c7e76e1sm8716360f8f.16.2025.06.29.13.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jun 2025 13:22:21 -0700 (PDT)
From: Thomas Perale <thomas.perale@mind.be>
To: kvm@vger.kernel.org
Cc: thomas.perale@mind.be
Subject: [PATCH kvmtool] vfio: include libgen.h (for musl compatibility)
Date: Sun, 29 Jun 2025 22:22:21 +0200
Message-ID: <20250629202221.893360-1-thomas.perale@mind.be>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Starting GCC14 'implicit-function-declaration' are treated as errors by
default. When building kvmtool with musl libc, the following error
occurs due to missing declaration of 'basename':

vfio/core.c:537:22: error: implicit declaration of function ‘basename’ [-Wimplicit-function-declaration]
  537 |         group_name = basename(group_path);
      |                      ^~~~~~~~
vfio/core.c:537:22: warning: nested extern declaration of ‘basename’ [-Wnested-externs]
vfio/core.c:537:20: error: assignment to ‘char *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
  537 |         group_name = basename(group_path);
      |                    ^

This patch fixes the issue by including the appropriate header, ensuring
compatibility with musl and GCC14.

Signed-off-by: Thomas Perale <thomas.perale@mind.be>
Signed-off-by: Thomas Perale <perale.thomas@gmail.com>
---
 vfio/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/vfio/core.c b/vfio/core.c
index 3ff2c0b..8f88489 100644
--- a/vfio/core.c
+++ b/vfio/core.c
@@ -3,6 +3,7 @@
 #include "kvm/ioport.h"
 
 #include <linux/list.h>
+#include <libgen.h>
 
 #define VFIO_DEV_DIR		"/dev/vfio"
 #define VFIO_DEV_NODE		VFIO_DEV_DIR "/vfio"
-- 
2.50.0


