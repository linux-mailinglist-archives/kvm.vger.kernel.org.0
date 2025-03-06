Return-Path: <kvm+bounces-40221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 44668A542EF
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 07:42:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 602EE16C45F
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 06:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 743091A2C04;
	Thu,  6 Mar 2025 06:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iH13cwtW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4447D1AB531
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 06:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741243294; cv=none; b=KI2IxK/cle5DZpKd0sbsR8Tq5VQF/ir6buIr5mfKby9aBatF6Zu6NXAX5026lyFRZWeZK2pRjt8y4g2uaq7zX6gvYximRtFebHc9tdCr1jXPOLFLztrkYj4WbBjACigAjjoQhqMMB88PCNIHe53SxiHv0ZR2p7rBNsMe0voInfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741243294; c=relaxed/simple;
	bh=HyHaiDVA7lVwaYVjiQIxGFKufAoNsvAgFuXov2/NWCA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Dg0WMFrAZw4QBT1c6rI/gJer69J7qjLfuc8CBpISZyESQ5x1bhOMgUpPD3AapJB/ufTKiqnUC0opTpMuEsdXWgtH0srZ5IWb8XtiibrumZ5sGYSsA8qqL36gFWzsJf+DrmwQ/gaM9JVz9jdqdcpnz7tpv1DD2EsHqEc471Vsdg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iH13cwtW; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-224019ad9edso6763065ad.1
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 22:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741243292; x=1741848092; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KS1pyoPrhLTMjTQ7DxzuSKRnXO6pGHCc8r+hitBpHy0=;
        b=iH13cwtWDw5kuDR5Pgd2tm6p/0WPcM8ywj/O85nck161q59w3LOQjWaHCxfxkd+I8h
         rJsFf1shsXxZsRHJjROSkt/mFxUOnpyzD2Nj1vEog92un8COeBJwjlO32eJpShxdT5A8
         wfy849/lqhOgMXb1L9jxrFv0CzF9gyMx6eEw8FRUAdiGSfx9XWiLVBJDOnQ8swIeMXaZ
         Wc7+/x+Oaj828tUho9yKO+yuTAfrLcCMegZsrJaBGcYjw29ChDqQwt5tHnhNEb/ZlnjC
         kxRv9H0OPLZR571DDcTvAVTOngrG9bS9uSSldqytFOca9fFUShaxEzGWi/GmMVwDsqvR
         58NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741243292; x=1741848092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KS1pyoPrhLTMjTQ7DxzuSKRnXO6pGHCc8r+hitBpHy0=;
        b=VHbf/9ajncqurZ45i0KoCvg2yoC6Ymjh/nNmmqklxDZHZDCbq/k/uP9WXLksWh0djR
         QYAoWfOptYwJ6GdkN7AGFv8kSH01L04S1sybKCpyvwJEfX/2BDkXn0Jr8wCt2wcRulfu
         uHJo3Q+4MPafvR2O3mLctgVNNr6wNRcizo8W9OZZUQkTWOI9/HJrpMYfzMDoR16VHwP7
         psEnk4TfXHik5EFjh50gFtTXKhAzaJJFdlEHvMmm9qlkF76nxBUFG73K5T2e7RoKvf4o
         nebKsy90OiBv0iUcvlua8z7L9DyxCNfC3GcD8+yTPg4/GM4rCypFhWEXCrgThjSADqAr
         RBFQ==
X-Gm-Message-State: AOJu0YwK5EABqWZ65BDwNNj7MoSVPLcp0RKNFHjfcUbpOwhUiz6Pn1oT
	LZGx6/9rGD4L5Cggtm+93fx5OMYL/HolQPbp4vn3rdFB8izMLZNWwuBfl64jbaFINc2vsOLnZSn
	n
X-Gm-Gg: ASbGncuC0NE7c+fBQ0UVhDggUZAMM8+h85Z/fxXUCErwEXT+rJy/LjM+tLGrGMhOPMs
	AYjjhF6TuZKktNxc1LF5DVf1oTmbdzqBaNL82hUqvhpyKJCESZ1u8Y1XYpRgmq8LSXeVbcRPgFy
	eG+4tJ8CAs9r/1cT4xlNTtqd4UgSipVJ5Ky3BHzaVgTZUf+0EetTW5ezFlAzn2MLwxEkBHTzDDP
	sX/OHe+hxQY6U1pQj29FRTjDmU8oAYPRcI3lwr48h62DF09otQycDVsdHdyBtm1QeVJo5oBDUaq
	EqzogddHKjmMALvTJiSy0Bhmy0jkGYVpLuXW05MC09AD
X-Google-Smtp-Source: AGHT+IGXDmDFVP1/sw76lEJlHoFvgFi96AID39fEf8BwL58Sfr1TKu2UoT9IxZqKvUZKhteDcaLw6w==
X-Received: by 2002:a17:902:d4c5:b0:220:ea90:1925 with SMTP id d9443c01a7336-223f1d20313mr105946735ad.35.1741243292659;
        Wed, 05 Mar 2025 22:41:32 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410a91cffsm4769355ad.174.2025.03.05.22.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 22:41:32 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	philmd@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	pierrick.bouvier@linaro.org,
	manos.pitsidianakis@linaro.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	richard.henderson@linaro.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	alex.bennee@linaro.org
Subject: [PATCH 7/7] hw/hyperv/hyperv_testdev: common compilation unit
Date: Wed,  5 Mar 2025 22:41:18 -0800
Message-Id: <20250306064118.3879213-8-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
References: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/hyperv/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/hyperv/meson.build b/hw/hyperv/meson.build
index 5acd709bdd5..ef5a596c8ab 100644
--- a/hw/hyperv/meson.build
+++ b/hw/hyperv/meson.build
@@ -1,5 +1,5 @@
 specific_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'))
-specific_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
+system_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
 system_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
 system_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
 system_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'))
-- 
2.39.5


