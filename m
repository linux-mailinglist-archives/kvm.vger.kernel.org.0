Return-Path: <kvm+bounces-40454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 54B4DA5742D
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:56:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E997189A7A1
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:57:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CCD6257450;
	Fri,  7 Mar 2025 21:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WR9Vn74l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612EB21A456
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 21:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741384597; cv=none; b=ovlB4TGRgag19j5KI4p/vRJpJcE/SxaxtC/DS4F84tByHzwgzWdXxp1X158BPBwaNYpXRUNwW0BbUDPzMC+Lgl3SiKMTnsWotpBpZQYUoNHmibcgllUQXTtEFVnn06UbhwOHPuXRQm4b4F0cfgrqFiX8gS/2ZX5FcAaa4agXrPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741384597; c=relaxed/simple;
	bh=rVAM4RcOXiP9Rg8Wb3t+nj5uTZPrfgRj2ddSkUBIJ/o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RfLMxh9G6dPh+0WapHtz/zMjUikuh8tt7CR/RYoXssV9avg4cAMnz1dML05sJ1wpSLq1TqePHcwSyXNSM7Ttr46mKHP+QTl7TfiSw0aquR3qq292IUAu3KsU2wkGM7I676uJywQOF9MD7NtI7Am2PJAve28rGeP32MWUiu+Pyc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WR9Vn74l; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-224171d6826so19558975ad.3
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 13:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741384595; x=1741989395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OOjC5KI63SbLoAcab6C0ugB2QHtpLUMoBslKkCj8HHw=;
        b=WR9Vn74lJIYqmB6cPHz3pI/W42D1+7vtDkVl2iyzpcbRX6xNkypHv3XvXjTdo4u3tO
         hV+EKuxCYUSabYVi/q7EBFuyvQe1DJc8KtZ/gPfRzj7HupFoiqEJjmVC9B3vxGeaOIzn
         RkdGGrVOs6LjxSGNkrHyEKNWGrdrJ9BPUSLSqol8buh4XcHL/ffimp1I720dNg8SiOzx
         jQFTs5b/u8hnd5NpZI/he2c+KUeVwvX7AChbeVsU7P8lOnCemQ2Y2RUXUqomEd3eDrjz
         O16RLjsnSHiEsZgz1hhbTvNIIr2YpwYSziWfzPOo5vfVpIGtpzSIxYVeqVxr3nbsGy35
         ctfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741384595; x=1741989395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OOjC5KI63SbLoAcab6C0ugB2QHtpLUMoBslKkCj8HHw=;
        b=wauXUYPWzfYytU5L8pzG++37sqiFfhNtYZUTlUcw3E1Oa3LkuljZEA33bt8kfeyZxj
         v5zw4HzF/vk7boPImsaagFtVOPoVcwc/S6TyqyycuZlfwSyhnkZZMgS3Ij8HRKrK3VeR
         XxgHnhNXcis2zFdGM8zem8XgzAxTFlh7fGTlxxXfXi1PyuG+rfshm1QFDVCdmjBB5652
         Y+aiT0UHDzgdMvYFy6KXLmWmArZo/4EDLbV43dtAcvqcQzcN3BAdMWUICK9e0bpbKfsW
         tW0sF5o9R7PHAyG1urXbNtcyyyDIQdQIyy/9EJz46Ex8wn+VJQiF/lXrAlRzW81Glggq
         AbYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIyoy7MoW5D4tMleBWGuj1AMQQgciTTztwfs8EEHf7hyqw1WaS9iy2VqHictnOBqgNCAE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbqDI31RUdIifg4NARlpt2cT9/5utOkrZ/ExX/+AEPvC7W+0IJ
	64lf1QDwNd/9behs9KJsxt7gzc2iNhQsmTBER+Ru99SVTiFTC2Q6IeM2EjL1rRw=
X-Gm-Gg: ASbGnctaYl+gFzTj0tSLNUI1gfD6ekOIru8+cupytddRRPUSPzA3wh5y/AYTRePd+vj
	pAPXsZgPMZY6dA5xu56IoQlNNQVh54It5i9EJE5nsBubj2XCkzp6CNkoUz6OS0L8CaYCR5jzdee
	0rFuC8HpFb9yRs5nsVxCjagPHL9leosFIqZPCasBOyhahjaPpIfdGT3Im3PoveaHJ2f80mxcFxh
	qurPyRvKq1iMeERHLYGPUmsjliLrqwaK0wL9fAFhr5bXgFY3t+RFiUswzHl/R9OlXi2K/KT5krw
	feHmuJxMD0uyXrp0GsRoDD5RsTTX81hXdDCXjFmMVJ02
X-Google-Smtp-Source: AGHT+IHbTRM/2LjkgZq9JOrRP/gGIFUxKEh4mQoSru8fsXoQyQbJxwtGO2AS7C7F6sVgYOJOIty0Ww==
X-Received: by 2002:a05:6a00:4b11:b0:736:42a8:a742 with SMTP id d2e1a72fcca58-736aa9fe534mr7585906b3a.11.1741384595609;
        Fri, 07 Mar 2025 13:56:35 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736ac9247dcsm2000927b3a.125.2025.03.07.13.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 13:56:35 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: philmd@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	pierrick.bouvier@linaro.org,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	richard.henderson@linaro.org,
	manos.pitsidianakis@linaro.org
Subject: [PATCH v4 2/7] hw/hyperv/hyperv.h: header cleanup
Date: Fri,  7 Mar 2025 13:56:18 -0800
Message-Id: <20250307215623.524987-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
References: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/hw/hyperv/hyperv.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/hw/hyperv/hyperv.h b/include/hw/hyperv/hyperv.h
index d717b4e13d4..63a8b65278f 100644
--- a/include/hw/hyperv/hyperv.h
+++ b/include/hw/hyperv/hyperv.h
@@ -10,7 +10,8 @@
 #ifndef HW_HYPERV_HYPERV_H
 #define HW_HYPERV_HYPERV_H
 
-#include "cpu-qom.h"
+#include "exec/hwaddr.h"
+#include "hw/core/cpu.h"
 #include "hw/hyperv/hyperv-proto.h"
 
 typedef struct HvSintRoute HvSintRoute;
-- 
2.39.5


