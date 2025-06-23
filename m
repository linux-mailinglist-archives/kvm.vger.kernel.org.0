Return-Path: <kvm+bounces-50335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DE66EAE4004
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:27:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0FA0189B897
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:22:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 758F124A06F;
	Mon, 23 Jun 2025 12:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AC4cCg2r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE411221D9E
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681253; cv=none; b=tSQXP3lU/Ar+G1N1gJ+DP3vVlcaqR5qk3xvyWZYkwDypNQJssS+/rvf1X1vmoEYGKUiONHxQIGC5gPF0P1PKrhz/y2pzMDSQ7aykqbUJSQ4ffkvXh3EMf1NxE+oiOuX7qv41bttcM6mRCX5J+lxP7rmM07Pa57zRZq3DmFKJN3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681253; c=relaxed/simple;
	bh=yPM73+X/aSAie2BVDALOQ3WGTVSSbWiQReZnxK16H7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j+cQ3qYy51Cv3vMnwp0UmKLhLBhY7nf8CB3K2dgK2PUTGDVKyQYyZmW2QZdN5+freG2vFC8Zu4vblLbeqZeNLCtSg0bCumKujBpLkOjPJYsqNIBw8BqF6jUkwjkgZiAZPEhHhasNVIUIRNOpbXmEz5GJZIsJTVZjSuLmuKCs5kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AC4cCg2r; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-453398e90e9so27083975e9.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681250; x=1751286050; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/XMJ0zIICEYOJOmZnjjg6la4eos6APBolhDpaT3Vg7M=;
        b=AC4cCg2rHeKNbee7j5Zoqsph303Wq43AOMrvRbEPDJlB7Br+0eYn5Jw4fed4vPxcZW
         VcFGjrXRAisfiUYSIorscDNZt8KZSmn2YZSVQV4UOqkoHrsIOJgkUNzaGDRDcEY3Idu4
         4wTu7BH6o00d2KCLF0VCRR8hih/i7bb1rMcSJlnA5nITDLn6dcXnXOVKeiCFmqYhaax9
         T+fpQOL85TK1AL2iuA7/O766yaSRF8WzjmYwPYjsUAkSMV4NEHFLpuJn8pGp8MAiUDpk
         SL/bdIwkz4t4v6KJBNTEz/v5yauKdoRZIPIok5p4vSdlPZMrQZMQ//7LD/ERDx+rnKbm
         zPQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681250; x=1751286050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/XMJ0zIICEYOJOmZnjjg6la4eos6APBolhDpaT3Vg7M=;
        b=tODFYMdVjgpo/GFhUQj78IrZu2VduCN7flTfkERGavaRyshIJixeflhLU2JnHhAuYJ
         49v+M/DpIAr6ibGk7DqLqOgcxUtW8h8QaR7fqb9zODSV47y6S9bCI96GvnWvYSB4iPy4
         BqoitruWgW1T5Iaq8XKwdbFlnwX82ABNzK55+K8ueuVm2/KcYbXKn9RyELi9iA8XZl1o
         C/fN9sqpFBA83U1htEBfqqXGsapZ0GuSrxiasF+M1hbkuDIldoTsf5bc+4Tx05kERGk+
         SVYOvFhBij+y6NLPxJBqEJtUZktbG0bz3SU4/CjIctdIs3hwEyAC+GqsH1aS3jNPjzSM
         Flzw==
X-Forwarded-Encrypted: i=1; AJvYcCWh8JYo+c9YLthRKwgonq3uQ/vTtDlemXjwYIyDs0roJmOPJscfKcVuiOsGIjfz7mODMDg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3JJw9AlFkjwTdPVUmxIpbOkEuIYedH8lbrKZRWo3eyemu7cAq
	2g72I1fiOMIpemzMO6MEFZxbAmfUuIIrbDmJFS0QNzobCaL9LejHKEbTrAWcv5pcj+g=
X-Gm-Gg: ASbGncvKB7L4bVqIpaa674kW0RUDp39fycgWW9ia8RvDYymHJtkXOoS3N8to5VxbyDq
	vGRIn8zWmbIBcYj6JpbxZfXNL4ezBJIUfRIilcludV9xcVDPorDz0ZMxt7tfcjoxhTjWmYWM9oh
	qPk/0wCJW1REX9pfBAB3i6aEic5kWbzpxutZHzBSYIvI8Ze6nJzhG1vzYpR+gtuVz1PYVI9KSPw
	6tFuR2KX7WrYxbWRHu9u+xCywqkooazk2oBib1pWMEDcfJAYa9Mn0HOlzTYf3nTnuFOmCEuSPP4
	hBSBM+KHcM0df1qYfQKnKp4j3dkINVygCWQRkTfl1nIQ6Kje7z/ACjlaEtSO4zo2lJqRSza4Wa7
	uf9bpdgZn3gYrPMBQmSsyNw7N2GcUqqDgKYkn
X-Google-Smtp-Source: AGHT+IEa/iknzQpht+lrSGEcOk6XAtkG3t/fuyvBomWpFBo82CfJvaf+wwRcGbgYUNKrlTzMZ6RvuA==
X-Received: by 2002:a05:600c:5024:b0:442:f482:c42d with SMTP id 5b1f17b1804b1-453659c9c39mr118467105e9.9.1750681250095;
        Mon, 23 Jun 2025 05:20:50 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d0f10138sm9313250f8f.3.2025.06.23.05.20.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:20:49 -0700 (PDT)
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
Subject: [PATCH v3 24/26] tests/functional: Require TCG to run Aarch64 imx8mp-evk test
Date: Mon, 23 Jun 2025 14:18:43 +0200
Message-ID: <20250623121845.7214-25-philmd@linaro.org>
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

The imx8mp-evk machine can only run with the TCG accelerator.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 tests/functional/test_aarch64_imx8mp_evk.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/functional/test_aarch64_imx8mp_evk.py b/tests/functional/test_aarch64_imx8mp_evk.py
index 638bf9e1310..99ddcdef835 100755
--- a/tests/functional/test_aarch64_imx8mp_evk.py
+++ b/tests/functional/test_aarch64_imx8mp_evk.py
@@ -49,6 +49,7 @@ def setUp(self):
                      self.DTB_OFFSET, self.DTB_SIZE)
 
     def test_aarch64_imx8mp_evk_usdhc(self):
+        self.require_accelerator("tcg")
         self.set_machine('imx8mp-evk')
         self.vm.set_console(console_index=1)
         self.vm.add_args('-m', '2G',
-- 
2.49.0


