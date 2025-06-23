Return-Path: <kvm+bounces-50334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D57E7AE4009
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:27:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 465523A6447
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:21:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F13D244661;
	Mon, 23 Jun 2025 12:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TSXVw/1f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27F8221D9E
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681248; cv=none; b=Z6ki1gicVQS7Xy/GD06EqLuYo1TGSdiq54Dxz0CYM2CM+jEDk0zdbVWJ+FMrKOJCV9sF8guCzWOoSNOJ8LHK0dQ3Dsgq6086E0D9sKHCkueDxpHbBxlpPlg/qVJJckMo/JPw94UGBEcSOEo6TWv5OXdX8MNalKBaP1HA0DHaick=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681248; c=relaxed/simple;
	bh=8cwXaTYXIK/p0NRyNFoG4sX65BRCXzKa7uJwtHqNniY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jb0g0Kye9PiouFCS/SZcU3Z/xO1rVJawPUoU7tkdvboZDdi6hB/ryfJUB3LFYZ+GmfXcEfpqjb7pwEydyWhb2pYsb0duOvl/mKum/e6N50CYcwXjXx4Hpn6zLPc7ugZmxrt4A3xFiNXtkO64MLTCSel3fInq8K9dSmZ1plJMSSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TSXVw/1f; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43edecbfb94so42115275e9.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681245; x=1751286045; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y66de3esKoxe7Lq7nXgyyvCOXzL/4wNdUP/QM7Hg6f4=;
        b=TSXVw/1f7ERbSwBOAwm5ws/Pl9YTSW//5uit6yi+6gZMScEYUiQ0O6BjrDE/1B5f7u
         J7WcKjcRvZUAtsESSVuxjaQ2TTXBrV+BUlc+9ojzOus21pn0b9Gog14f4ymk/m7QPjFZ
         /fwummoJELCGQy9olpjYrpRDT6/2EZm8GPhfsYS60ngeoBPmbVq03JHvSWsI3YFdm8Cc
         XUAo+P4nvQFaBawCazTw3GRXIRooZAJ5BfI3PKQAQS1kqeYVpJ2vAMv0UeiZJhAqd5NW
         lXeCiY/k7I8iA66grrvexZcbU3NQuihpr/VgDkdSHQxamIhedfmMl8dpp1KVtwHoon8c
         f2ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681245; x=1751286045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y66de3esKoxe7Lq7nXgyyvCOXzL/4wNdUP/QM7Hg6f4=;
        b=AeOHnbT/G8ZbNjbBf/wYoYMrk0VEzyQL00l3H6kgIeaM/l4KIM7uxNS6qaTHZKYZVl
         jTUPwg/Vn6YBjaBRGwuxqkt7+KsE5mJuBxmQaann/ZJNXkzCaNF+eM4VXkFqfze+64Ud
         ussdgtAhpcDCCxXqpoW1XXhnF3oujRAlJpGB7PGLR9ht/dbdymg1Ndhhgu/dmf7fC/PN
         bzi6BYDCSUO2mMomWnZflUvtTMs9b/Gt0yKFW93p9GLsD/CrMBQq/7ESjjHenV++ZYoe
         JMW7iC+yjh5PrM+fTIiFYKvbfvfBbUeU0fQYgns+WBBynLSS6tTk4ltgPqGfGnzg6Cjf
         p/rQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4Iz4BIkvD3pahrX2paxH/lxTaE3bdXovW5cXRWEydmA6E+xxT1PBBht6lJHQz4e1sE7Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1RO/3NIKPZTDn500i3SPNRN+CdNn0ZeZERT3vviMJb0TJoo1T
	mmTiHIoYoFwCU3j0/SHQllXfZI1p5liQWc2Vse3oqflKfgoK+6Il9dMJZDhrFlquwgc=
X-Gm-Gg: ASbGnctM0TinXr6uxrLoiZE1FhlgicAa2PFt0FU8sIqU8nOz6lfgCjsdyYvRTAOVBQ3
	f4qo0U/ZRpvy3GiQ+34SQToFfjptcLIYYx4oLyt0MuGIcp2ZrAig8ezrrbAZvlbr0HVspIl2aEj
	PLX1ol6GmcLqYRLdUc3zCBFbViHljkh+TNkXNiTWT9bMOpfDQiUBEKgQccbg11ltjlcR1BpwzkX
	iS0g/AF7Jx0NjJ6ncOXU7NM4c33wpwVqDHnUziMlqvGFayTIyHw4dtR2jD6bmulsxbV86xy2Bv9
	tIzTi3PUhaJT8q6V+nQPaVl3Z4ijlILSijaYTpgNXewTHcUa0/ljv/L9ydZRmjWUmEskBSx8GFb
	HCuyyWyzMGGMYGfO6TIOPkE30bPrH33P7UDBl
X-Google-Smtp-Source: AGHT+IEID5av1fp7z71GMDcrtgYTt/iBmDplBK/iwcImMCZA+DLu+Yd9shEYZ/xuGkpZgY5IEvOhLw==
X-Received: by 2002:a05:600c:c1c8:20b0:450:d3b9:4ba2 with SMTP id 5b1f17b1804b1-453659d4330mr62504005e9.24.1750681245056;
        Mon, 23 Jun 2025 05:20:45 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d117c0fcsm9565403f8f.62.2025.06.23.05.20.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:20:44 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Bernhard Beschow <shentey@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	kvm@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Cleber Rosa <crosa@redhat.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 23/26] tests/functional: Restrict nested Aarch64 Xen test to TCG
Date: Mon, 23 Jun 2025 14:18:42 +0200
Message-ID: <20250623121845.7214-24-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250623121845.7214-1-philmd@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently QEMU only support accelerating EL0 and EL1, so features
requiring EL2 (like virtualization) or EL3 must be emulated with TCG.

On macOS this test fails:

  qemu-system-aarch64: mach-virt: HVF does not support providing Virtualization extensions to the guest CPU

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 tests/functional/test_aarch64_xen.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/functional/test_aarch64_xen.py b/tests/functional/test_aarch64_xen.py
index 339904221b0..261d796540d 100755
--- a/tests/functional/test_aarch64_xen.py
+++ b/tests/functional/test_aarch64_xen.py
@@ -33,6 +33,7 @@ def launch_xen(self, xen_path):
         """
         Launch Xen with a dom0 guest kernel
         """
+        self.require_accelerator("tcg") # virtualization=on
         self.set_machine('virt')
         self.cpu = "cortex-a57"
         self.kernel_path = self.ASSET_KERNEL.fetch()
-- 
2.49.0


