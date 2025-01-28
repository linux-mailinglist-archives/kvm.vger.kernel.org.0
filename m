Return-Path: <kvm+bounces-36776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DAFFAA20BEF
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 15:22:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B9061886DAE
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 14:22:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DFA41A9B29;
	Tue, 28 Jan 2025 14:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uxRqY4Mv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975B91AA1D2
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 14:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738074143; cv=none; b=AqplQYcQ1/lTYW6T6k5EfpZ0knFu+dXEGlvXOoahR3DO0q2Gz9eeyEHG0K0UVHKOB2KI/VBDQl1tFIVI5+f1wWp+q8vjNR+EXGCHDOqm/f9a/evraa/si4u1NHTtfeL73hsVs+kNFlt0T4eIcIn7LmeujsZn8rpy+Kg/x1KXAKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738074143; c=relaxed/simple;
	bh=JmHTzVtwDG4VRrHuvKuN52rz6X+CgLY48sZJXwcoACs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NHPAGYWm7IiMlqlTHqj1QnNqwg7jYovZ+jpyvzeKrCRZAo+fvDmgnpL25ECcHcArcxM/UfywgeiQGjCQkr9II5mj0nNyeRTnIULjh60BjpxYuPkWo807YFPQTafc9syVddcCKKHSjMEdXXbELCdmnEONlCJ+759G46FMvXAelDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uxRqY4Mv; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4363dc916ceso42395845e9.0
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 06:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738074140; x=1738678940; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mCOhYMyVhf/9MTlWJYC1Pyb8EOr+qnDpIx/K4OIle8U=;
        b=uxRqY4MvvMCSJaXCy3QBtFguBoe5aoPJKiyY7Oy6SixOU6ZY4YNzhuAfq7wN64mpVB
         V8vM8/qGFf9IkMUT5X22OFVtP9mpmW7jq0ECE+oTWZ895sXW8spJ365ea71kUNIhZQoq
         c522tSDHVNXMZoyhRhSfBlNIS46qgThPs0PeD76w53M3hvGJSS4C6Jl75Zj61Sjl4QkN
         foRxR0RQrVqwJS4vmpZsTe2EdIkLKifiRzr2nlAJu3KqP/1s5rZ/ZPUXXXjCdMBMfB4w
         02gwXHltsba8D3R2kVmOkcme9BVpBSZUefOFwyEFtKhKUmBiN34J0Dljnwq03tO/zJDh
         Hn+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738074140; x=1738678940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mCOhYMyVhf/9MTlWJYC1Pyb8EOr+qnDpIx/K4OIle8U=;
        b=U6aikh/OOWwsTbAUhgwcpSLjernsNATEmJSS3se3Gd2CUMaWpqe/X+3tGbkbHsM90x
         TYd2vhEE3hnU3iOdVV3NBu/jkNLgXBqAjtZ1G2lnJcU2n+1BEDFSjaOpaLmJPGe4vOsJ
         gI8PxowosCglbYmLD0KBlEHIsklBCRA6Ydr2n46XhUoHkwncrl+uu0XzpcHuq66D7LJ5
         6j0qc1VrUBeL9V1XY2W6KfKRTe571WULKCatF5wjsMXjIgtNLcP7CN2fjBVQ98gwkoSJ
         kkPA3wPkDDMZ3UIbGJzBolHHa/+iYK8gkC2jc5gVuIMRQ4/eEpC1ltHZb+csxbCh+I23
         9wcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPoC4KbAFrFKQNofOq1j0asHvrQp50tiu7DCpaxYsuH9pBjPfNl6jeCjF9cov+NoQc3Kw=@vger.kernel.org
X-Gm-Message-State: AOJu0YziBbVzWqALRh09FSCKT7oozUQIf4iQWNYiJ+eQFGVJ73BrGalV
	v5QHd2LgeDpQygMmAMDatcx3NZsa+7Ul36l5Ztlg98dThQQRFAAK8J9VF0oNbdTHGAD/DJtEQgq
	4KBE=
X-Gm-Gg: ASbGncvsAeIeXBBD6+acg76p/TxMtmZiGNqAzycO0vdwLK/cH7fZr9BI6IQexrypNLm
	slRC+lRvX+wTeMUvoBz1TIDsImmPvm+78XocJXxMYI27Fi2U2yzyDFgS22Ge/yWJIz4WgOzVftc
	6xxTotj4LHp8YQHGzuwkdTgBeoE+lVAIqc6P1Rq04v76sB+Gb/FLgql6tuFXiNom0X3a7C9/tWn
	L7bLKajmq3WYMPDknI1Icbv8g7guGVT/sUhOzFd/U9oyQByXYqldM8GBrE59Q+ZGR93KmriB5cF
	lsOYO9/I04gUSRENUKiOmrHM/mY/CQjNdPgth98tj6L2bPH7cmhB31gBZgL2BCSLug==
X-Google-Smtp-Source: AGHT+IE44lMFstrRJbbKMMn+hBpz79bGQD7lLRHTYaowiK6y0WzRah7ztkDdk12TT/+zj/uGA78k7A==
X-Received: by 2002:a05:600c:6c92:b0:437:c453:ff19 with SMTP id 5b1f17b1804b1-438d59b566dmr30503145e9.14.1738074139917;
        Tue, 28 Jan 2025 06:22:19 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd57325csm172106435e9.34.2025.01.28.06.22.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Jan 2025 06:22:19 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH 5/9] cpus: Add DeviceClass::[un]wire() stubs
Date: Tue, 28 Jan 2025 15:21:48 +0100
Message-ID: <20250128142152.9889-6-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250128142152.9889-1-philmd@linaro.org>
References: <20250128142152.9889-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/core/cpu-common.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index cb79566cc51..9ee44a00277 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -219,6 +219,14 @@ static void cpu_common_realizefn(DeviceState *dev, Error **errp)
     /* NOTE: latest generic point where the cpu is fully realized */
 }
 
+static void cpu_common_wire(DeviceState *dev)
+{
+}
+
+static void cpu_common_unwire(DeviceState *dev)
+{
+}
+
 static void cpu_common_unrealizefn(DeviceState *dev)
 {
     CPUState *cpu = CPU(dev);
@@ -311,6 +319,8 @@ static void cpu_common_class_init(ObjectClass *klass, void *data)
     k->gdb_write_register = cpu_common_gdb_write_register;
     set_bit(DEVICE_CATEGORY_CPU, dc->categories);
     dc->realize = cpu_common_realizefn;
+    dc->wire = cpu_common_wire;
+    dc->unwire = cpu_common_unwire;
     dc->unrealize = cpu_common_unrealizefn;
     rc->phases.hold = cpu_common_reset_hold;
     cpu_class_init_props(dc);
-- 
2.47.1


