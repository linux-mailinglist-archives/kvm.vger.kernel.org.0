Return-Path: <kvm+bounces-40421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DDDF4A57214
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:38:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 11AB87A9594
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A861B2500CE;
	Fri,  7 Mar 2025 19:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="twkrckQI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF9D255E34
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741376245; cv=none; b=oCqLSj/tR6OwLZDDpTuBlWF+Dbj36rkZru/6R4wzCouMH37Gy5pTTjpNnOX/fO1chEv+BEmI8T0BfJyehYKoPzJgaooj9ZVEgRwuO76j7l+hGS3voJhzNG24kuJ+uWzOkye+24D/NEVs6W5BT/ViH06lVq/VLFVRz8pXUQpFMy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741376245; c=relaxed/simple;
	bh=gBV4um8wlOhOwRmzVNVgWoclDLVNGnUH5xpVA2pmGY4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KhMrLNv5t2dNLA28FHQ/vBdqxsv+i4EPYedl5dKFW/b/gKzfMlSegntDuv3fzsYOTSm9QYw0HvBhqIpUrKnoXInAAsizDwjubhz5LUnV2Ff6sSWEceuk4yJBrAzOKSZk+g0q6HpMYMzxW+8F+mH6D+s4VKzFD65OXqUFs3d5SYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=twkrckQI; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2232aead377so46751895ad.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741376243; x=1741981043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rr2e69lL8FG0Id6CFQe12hDqKFL6G/BQmRPiJllL+3c=;
        b=twkrckQIQhETUvKZHyEuwAl4jk8zoYekYHTsq5/NDl8Skd64b4RbBh19CCsFeN7eEw
         tjzmZhmKabWtUj3dLBPUryIqV9TIuXszIuwR5OTFfJ/uFlzvzHJ4LVGaSGsEv40EGF+Q
         IXYQubnpQBdA3Gigby43thvCjPnc/PeMKyeDNpMmoGU1HBzQhMn3tbX3L82AOOabzdEg
         yyTPuEOuYymtEL9L3b+jbTD53tDrtkZL3fumiIs13p3bP6dkdmwNTJ64NmFzQyrm6b8i
         C9qm6GjvDX7CKSW5qOjVJ70/9Tb+oajE+JiIKHK3gxPLB29OPmlATq4aRNgLPAxYGYlZ
         Ly8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741376243; x=1741981043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rr2e69lL8FG0Id6CFQe12hDqKFL6G/BQmRPiJllL+3c=;
        b=C3FVfVfvZCsgaFzfs1mm439qZ95qUy7ujyo2hRkM+1tCNKWe6FUmCdAGvyRIUP6452
         B0zXwjZ2IUr9AEXWTttv7cgOM4ZMEwqxgDZe0DaCnyTLt0PtaX4TD35ymUX/PbtTcL8G
         e4csiCpkz+Wq8ZhHM7JEH9+FJC4J9epJm6JhE2jhp61oHsQqSxJM3ZU+yyFuqHR9gKyt
         n49FoJmoKxhD56X7HhWMwh3SytTXCat6gfaNSLze1XUwNX480xUSlgjsIqvfauGVrkE1
         cywEFWJu44qQGb/yUVzOhvf8uSc9RJvXRvqz1OTRyrtsvM5JqXYlU0oRWNRxHANCaRev
         Bj5w==
X-Forwarded-Encrypted: i=1; AJvYcCVkKZSyeY3sk0ix9Q4enLW5J0PefMxftpY8uk7Xu+PYd5BYw778sawXGwkplWmLtS5mJq4=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywitb143YBFKcYBTehbb6QOESAIOPvAck/xJ9omQIqLtPMvo9ZY
	lVssB6SqxLercPzT2WM7WIpcg43D1rasvsrwMJEED/eY1k3O/5B/q9vo7hnst3M=
X-Gm-Gg: ASbGncv0CaG0IPiP3ln/y6Cqhczo6xNiFczSn7Rp+vTjKFfFTWtaT90Va3uYGo5sKEA
	iLprDvYRw3wmk9vubNHAdwc02jTqHxZz0Oo7zWRRbGWML2JZoSX4f7wMopgJ7xXdTC3pCNzhBT+
	6xkARFoAhaYOhwfvR8QilnygdonT5F5sReP+D9ABDhNkf4hWSlWn/4qX2B417lczX0xMlq7JTc0
	ZyJqR4NkG/H5nMAYVltLYVnDMbM0rSmibaARfIVTLqL+Yp7hR4Ws/+7I97DJKT2b7RMPCmLwRbJ
	R3G9aFKVaBhx4JJ50GTGdg6OBzSYMe8o3kpFbuN+lJgp
X-Google-Smtp-Source: AGHT+IF+B4FmJwW4AAH0ztyyNrVMPlGFTFmizaeHxb8u74ANm2FF7U52/1RJ8EMRstrrGA/FGRW6YA==
X-Received: by 2002:a17:90b:1c0c:b0:2fe:a545:4c85 with SMTP id 98e67ed59e1d1-2ff7cefccd3mr7096469a91.27.1741376243525;
        Fri, 07 Mar 2025 11:37:23 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff693739ecsm3821757a91.26.2025.03.07.11.37.22
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
Subject: [PATCH v3 1/7] hw/hyperv/hv-balloon-stub: common compilation unit
Date: Fri,  7 Mar 2025 11:37:06 -0800
Message-Id: <20250307193712.261415-2-pierrick.bouvier@linaro.org>
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
 hw/hyperv/meson.build | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/hw/hyperv/meson.build b/hw/hyperv/meson.build
index d3d2668c71a..f4aa0a5ada9 100644
--- a/hw/hyperv/meson.build
+++ b/hw/hyperv/meson.build
@@ -2,4 +2,5 @@ specific_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'))
 specific_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
 specific_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
 specific_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
-specific_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'), if_false: files('hv-balloon-stub.c'))
+specific_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'))
+system_ss.add(when: 'CONFIG_HV_BALLOON', if_false: files('hv-balloon-stub.c'))
-- 
2.39.5


