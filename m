Return-Path: <kvm+bounces-40422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AF442A57213
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:38:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2382118982BB
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ECD8253331;
	Fri,  7 Mar 2025 19:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cGQKlo2j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B44255E4E
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741376246; cv=none; b=pn9wYiAHLuqWhUdyLVG27vAFC4/6jJtSEX/L7ugUKmWfRPjgOgq0Q35vBMHbOhlpkIdxaQaIbsJ17y2olE0v7hHx73aL2mt5eWdkCslGlEhZjEk2lXHq9+1ZZPrt4iv4ydNrCpgs5zQFmMDTjDa35SI1/HT/VfjVelucLxQEOkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741376246; c=relaxed/simple;
	bh=rVAM4RcOXiP9Rg8Wb3t+nj5uTZPrfgRj2ddSkUBIJ/o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fxBOEOuRFbVnd0DTe0sPqlWsBeRy6jfeZATIUn9WGfGQpRj2D7mSX2rOkHQUlVACWiZiovaLUIu2fjz1vVU/lhU2TpZZnRsftx3WbweUMe/EkDEdv8LPAx6ZToU8rQqDm9wA8tyl6MgLrQic+6DbjzwDgzk5ByQ6KF6CH9hntKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cGQKlo2j; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2f42992f608so4102568a91.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741376244; x=1741981044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OOjC5KI63SbLoAcab6C0ugB2QHtpLUMoBslKkCj8HHw=;
        b=cGQKlo2jB340Mwff72k7ZaAie3s0X8wIVe335MzytPh05F77hHrSrFGn4rBYyNSRcC
         R7SdNHmHsJpFZyzFU3B4S6tt381jFvndsmd0etbvvqqyZhzzwkXk7MWovcJ8PWpXQ+zU
         vuYFkR/B0NhBVEmgIUZMlc0zFLUsRCmud5ImT9KOzNzoANoKZ+LNdwxrfHMv/lVWyL5M
         JnDXQruELYro7U1atQHd6Ii6sApiI9yr58qqMaATZcTmVOv1p+NSny48CXL3JHhhiEB3
         etUivHGeYMeAZmjIqSWci2HanUZzb3lcOtZN4seFhtk0gHrsUNzhCLEDlT7BBKBruG7/
         gu6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741376244; x=1741981044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OOjC5KI63SbLoAcab6C0ugB2QHtpLUMoBslKkCj8HHw=;
        b=LIH54oTPMYpExoN3iZ3ybcvZQJUg1TlAZrGBDToo/OVmG4r+o6IP0dUqlxsk/hpldq
         EaHobQlBXFqbHmEfjghdokRN5/LPrkI+5pwZNpon/evHHV5x/kM7rPWgCYN/Yh+Ggmze
         JssFpKUA6Z0Z6el996MvRyizODHWN81sPca5Jkwz+SWDG8q7N1ECRF1hCQQxaJMLgzRy
         51xFf4ROPH1VbnUsv8wP8Owt6mqjkbNO0bzdS+CTYy1I4H0Y1qUk0MS6cYVO5WQ7Ktmg
         weDdGtnZgyI1hIj2HjaTpHoRji151BXj7WP9MGEMs2uCDO7TCIn3jCB99i/MMtKAaqb1
         Y3nw==
X-Forwarded-Encrypted: i=1; AJvYcCVyyka9w3egNoXvhAeQNckR8cH+N4sNcvZ20KZLZa06z7nSRCzFbkljyy4IXf4+Soo3qWY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyR675s8JhnnIMycgy6M9JTpupWyxAciQRvw4kbnJwvrDeWXDZ
	XgZpUfCKGCvjem44xbVLLXJAUEoidWbdDJHpQTprDQWaz4Aemd4gJhpHMb45F1M=
X-Gm-Gg: ASbGnctTDbaHZT3lvDIHXVcY137zMVwnphxvBtCZVNCSilSKhQujHlqZ+NKfeevD9/U
	B2iMbgs4qtQEzpXzEKhe8gfVKia6gdsbdXr9Y3DDwPSl8QbyxAob7HqEz2hlDJimtSPP5cqLASl
	Rd+/bF0ipKV/f5fnWkmJhgO80ePAnUegvSpo2dKxl987vWVw0VC5SH/uGKyhr63m2QwlacILAiS
	YXQHJqFhkvtCuHmCIgmK/HtV/vnf5g2kfiCMm6BtLTY1WHIBez/8fXOj+SXZLRugS5PlykCkloT
	3IwQDATTjgJ8rpavwFjsw9/pS36CCE47n2e1vuX4pSGx
X-Google-Smtp-Source: AGHT+IFe9wgvnMzXQ/WyHuAR6wnkRDLj0hwLlEiJ0+W5nV2Ia4eswq2QZ++4R3SESqN9I8JkPgpKMA==
X-Received: by 2002:a17:90b:3d0e:b0:2fe:afbc:cd53 with SMTP id 98e67ed59e1d1-2ff7cef7345mr7076283a91.28.1741376244365;
        Fri, 07 Mar 2025 11:37:24 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff693739ecsm3821757a91.26.2025.03.07.11.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 11:37:23 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: alex.bennee@linaro.org,
	philmd@linaro.org,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	manos.pitsidianakis@linaro.org,
	pierrick.bouvier@linaro.org,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v3 2/7] hw/hyperv/hyperv.h: header cleanup
Date: Fri,  7 Mar 2025 11:37:07 -0800
Message-Id: <20250307193712.261415-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250307193712.261415-1-pierrick.bouvier@linaro.org>
References: <20250307193712.261415-1-pierrick.bouvier@linaro.org>
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


