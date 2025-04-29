Return-Path: <kvm+bounces-44671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A4B2AA0184
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 07:00:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77FED17FB57
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B73882749CF;
	Tue, 29 Apr 2025 05:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xKU6Aocz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780DF26158D
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 05:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745902824; cv=none; b=k+jnjSjw3NehrZiu1ZHl85nT+oqFEzYlXTdkI3N1RvKIznNWYXRWgiiwhLQdD5SLj/4GN8tyQgUPWveKMmo87C6NUZdgfbv65WlQf3Q4Q5p1q/lv2GJKRfIXBvw6uZOm6h3YnnTgU1ZYVCO6Z2/2Dc0nLZ/fIyXJ2zz0zUUtPHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745902824; c=relaxed/simple;
	bh=gya62nAFKKLhf0Pph8JecIDpchBQw5utkJj2A+uV788=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOCtOS8/AueCGQG6ymmGTmp8mm7Pv8VGSboPU21uLJVJQbfkkaAUblvulEvnfqBq3H3C58bty4Tm9ltzqgEU6pG+xGuZYBRBnoqElv5/0P39WKDtNcd0oi71BwwPNxkjVPUw6cjvKidByixD2dP5C/kYCwwMnR4C/v0lrauocLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xKU6Aocz; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-223fd89d036so69119375ad.1
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745902822; x=1746507622; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZmDBK1mwNkNbnmEBtgMmVcGSzIRc7rMtBzbRfWVwQJ4=;
        b=xKU6AoczSjr1cQsSAxlv9c4iEwd3gKUk94PiVLKxa+MlTAKwujTpAU4d+922b1Mj5j
         pcCaH/SF6ktG2NgxCQoyp8WrOmPWyU2zDcBbz1I7vat1RHUcYCsLme+otnsmFufdbcwb
         G5HXfx6a8Ma/3c80/gHqbCtx+NFStLQoOnDkKRDTy+g586ifVlAnaGpHAl9H5/Rp0L5F
         iPD8NxxGjS34Cgr4cx+0/QdZVFk+LEVFhgBJXbpdz01Ga6KZmK+leVhlJAclk6x91VmU
         UicuGZmGinVNXKXFKJ85So5WOGc27qbVhJ3zCtB1Iicw9CGA2xHumuLSIDh5NNTtCqSP
         FOEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745902822; x=1746507622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZmDBK1mwNkNbnmEBtgMmVcGSzIRc7rMtBzbRfWVwQJ4=;
        b=IvQfNRTRx48HP85D3YRBevx+x+wyXJ7KTcXh0xBlo5Bq46XnrIe4QVoFBet/PbU/+0
         3OCTx6jzifIpnAC4nYy8IoTkMKj/EDEXmlTfG/JA+sE8SgVUqaLjyU7tw616CAfcgRS5
         eoruqFqeZLYp2/fwp1S7beb6r+lLKNXPcjDcWLxZulkvbhq3LrMAm9/AgMGBNn0Y4AHt
         PVYiy+dZexMuYih58SUu4sE2wPPDrz5aUItxCMegdmgkRHi7/HKXgiBTSkdJThKOuhgW
         Ss+Sp678RciZV18W4U4l3TpGWFSTVVV9PmHmrFrAqw/TEk0hsbHxXc1bRDkpeeUEk4hf
         fWeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpAszAuwQJK9eLO8kysilgkJJAXYiSP0/jKZjekQ8EFfdG1FX59tdqgqnaZcHTKRgFWE0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRY5MibM1GzURun7Yx4HQ6jDRueDM4KXnKvliV+XtTnFCzwNOj
	+jwpowmAdrMGwxZOKE1p/dKk85g9tndWY4IprUCdzMSegfgm7XVCjF03d9L9WfA=
X-Gm-Gg: ASbGncto5GtJZYEgEFtEDTA+seRuXHoKJJnq3EDe5T9D5d56+TOqFP64bRoWJgkGvAj
	EDUzAhM74c0jqL9FqRPsFrJ7fl6Mv362RW30sI0CCqBFCKIR04JnZ8dUTc80MLMKWt8c2SG6G1K
	sI05ZVyyxMBY+HxXeliwOGGsi6lhTdDzxpZ9XK2y611CfGATlxjC80n5+f/Bo3IAjlNK/xsG7l1
	egGDzEgBXYSC/amsz+eoDUgNxzeiUqySh63OAWX0/WvQRZZ0btD3iSi1JF0gVb+oN4kvREOHW+d
	Div2D7Dt9YFjIfq8Y8cTBqIGoK2WITgLfCj1BBEL
X-Google-Smtp-Source: AGHT+IFu3N+jj+Ept4mXyFeiTkaqrsFaktsu0U/CH8Tvkf94SUE6QCp5G/0psN7lUde/shvF6Qz/Rg==
X-Received: by 2002:a17:902:d2cb:b0:224:93e:b5d7 with SMTP id d9443c01a7336-22dc6a546bcmr176908975ad.34.1745902821676;
        Mon, 28 Apr 2025 22:00:21 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4dbd6f7sm93004015ad.76.2025.04.28.22.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 22:00:21 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	richard.henderson@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 06/13] target/arm/kvm-stub: add missing stubs
Date: Mon, 28 Apr 2025 22:00:03 -0700
Message-ID: <20250429050010.971128-7-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Whem removing CONFIG_KVM from target/arm/cpu.c, we need more stubs.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/kvm-stub.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 2b73d0598c1..2d369489543 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -99,3 +99,13 @@ void kvm_arm_enable_mte(Object *cpuobj, Error **errp)
 {
     g_assert_not_reached();
 }
+
+void kvm_arm_reset_vcpu(ARMCPU *cpu)
+{
+    g_assert_not_reached();
+}
+
+int kvm_arm_set_irq(int cpu, int irqtype, int irq, int level)
+{
+    g_assert_not_reached();
+}
-- 
2.47.2


