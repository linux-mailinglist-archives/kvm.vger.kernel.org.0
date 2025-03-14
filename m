Return-Path: <kvm+bounces-41078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B771DA61549
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 16:51:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B447C17C5F5
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 15:51:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EEEE202C52;
	Fri, 14 Mar 2025 15:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VOQoMnft"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3268120126A
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 15:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741967479; cv=none; b=ZX5MLn32F6HSeQ5oX2tmQ90kB/njVAsCoQi3J+ul4X9or/USCxJufS0tu/7KL8iVbP2Fq/l+AfeSA00iRvD/DZCXFmJuk4XeuPaW+5d1BI4GyDorw5KLyVkiYZBOwOdS+AxKWC6mQ7VDE8xtN2DopaAxk8+AHmgx6QlqTUTO8oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741967479; c=relaxed/simple;
	bh=kzP55/MIfAnJXYhci7u8/DYGzdl4OSe501J7B855nOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emC/FV/UNc+we83HHAT83ez/zOdqcAmVZ7Q+khbaEbZUv1XP0Y1x6/GzcxDC9TP/y27Qmx7mBphvbCbtAekoRvR28pD0/IRrEa2WtBbNhKHXoQE83snS5hC6Ybei7MF+h9XEmfgZtfV8rsY4c3Uu938BqwRFloVwdN3Y5RR8CCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VOQoMnft; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43d0618746bso15754725e9.2
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 08:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741967475; x=1742572275; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZgQ0Ki7S7zg6nzRN4ZWX4z5ZVEFjxmGZvTrquNKZxZU=;
        b=VOQoMnft3l6VQUeLPu/EQVDH03sdAECR23nYGzZqkOakDLZQWHux68MeZY5PdBHfuU
         EQ/0cfk9SA+ndWI5udvxU0WgvDygJZxD+Y0krAqzJVuNrR3L7stqqBNQipeyTNXXACtp
         dfYVuFyc0gXbHdp8vc4eMRM07L+g/d0RnENplyQ9mXmwV98UifVaUn2qIyxjFjxJj0iS
         5KTnKBnvfDz4BUR3sQnfDJRKJWlbnXMUGDicai6ZrjxBedaJSwRofmLcRTTkhRuV/E0V
         0ICQwG0QsWVuJQMacZ21lUbtbqPEPTEZTI8QXyMPfTWZKjnGor9SJs6fCi44hsgTg77P
         0xiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741967475; x=1742572275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZgQ0Ki7S7zg6nzRN4ZWX4z5ZVEFjxmGZvTrquNKZxZU=;
        b=TdLiN8CJzIhUIfRZeWTpp5kSURmLHV1wshFz744kkwwlG2YlBGH2JfsD3qS3XM2BMy
         sRO1pXHe+mLH7VVBhFKZowOVkC4iw7x95i/2k9E2fYlW274/x7l7it2rcS7TZg4NO9S/
         3AS/+joqWcwBfEwHcLDSPv03dy2OLQvlxjRTa9h/fngMfzC/gXat/uFkZexptQQAQhUh
         GQN+cIPo7iNqlZ2SJHtmg8c7zt8aBuzhqVzw2zFVsNqAmdh1QjlU08/ok6NX1PKQ8jVC
         6a0hKLrDpDuIidH8RSjYV8ev1y9lPxzmWQJD/ZNU+37J8HUZksl4874pHaF6G1iPrG9H
         iirg==
X-Forwarded-Encrypted: i=1; AJvYcCVT7tIvbFwNgwWK8EB7XB3C49W4e/KufzRh/N1Man3zHsd2w7rxBtc+ei0yJ/55k9j1pqQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxczeN1fcubowQxtR4cRFLToAiglCiPWYG7mgIJUdVppeoTrqC4
	V3buIUnElORpMgerApa/uT/mPVWxQ5/rvM7EcOO0feDVfqy/SUIyytjIojDCOilGzr5+BoKh/Ta
	4c7A=
X-Gm-Gg: ASbGncsyk2G25Rtg1QYlDwwo5wmRvZtXaOR93L/qry1T+3nnhWPw6bmsshsGdNJ4SJk
	KDio6B1eVntShm9nQUFHA1NOHhaox918CmnkoVSPPbZ3fDXRFO98rhyShqW0Atk0+SVwgvY1Jjf
	HVC1vK5IQo31Q+E9olK7UUEM4fOD/VNNNTc50HSIq++6gxcWgleaS4xHuu3mHJDHJ6B3MQBM/bH
	S5vkJby6ppfleAcMwM0bLExtYJpPKpNIpJr5PiAHjO3bWaXGIrsHD4ImGDXd3sBKmMv3pHgP2Rb
	HVYc2IYydlAl7OXfCFxvihESXHwiGdDn8T12sMxzDtwGzIGemqJtgDDaiFyEuo4=
X-Google-Smtp-Source: AGHT+IFLNDlpPyRHd7THTJueCfShHv+cshQugLdnBwo9BUmrTvt7xn9ewfp+VyqjXp3lJ+1TO4LSpQ==
X-Received: by 2002:a05:600c:3ba6:b0:43c:eea9:f45d with SMTP id 5b1f17b1804b1-43d1eccbba1mr38605875e9.18.1741967475088;
        Fri, 14 Mar 2025 08:51:15 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d21d67819sm15249945e9.21.2025.03.14.08.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 08:51:14 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com
Subject: [kvm-unit-tests PATCH v2 1/5] configure: arm64: Don't display 'aarch64' as the default architecture
Date: Fri, 14 Mar 2025 15:49:01 +0000
Message-ID: <20250314154904.3946484-3-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250314154904.3946484-2-jean-philippe@linaro.org>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexandru Elisei <alexandru.elisei@arm.com>

--arch=aarch64, intentional or not, has been supported since the initial
arm64 support, commit 39ac3f8494be ("arm64: initial drop"). However,
"aarch64" does not show up in the list of supported architectures, but
it's displayed as the default architecture if doing ./configure --help
on an arm64 machine.

Keep everything consistent and make sure that the default value for
$arch is "arm64", but still allow --arch=aarch64, in case they are users
that use this configuration for kvm-unit-tests.

The help text for --arch changes from:

   --arch=ARCH            architecture to compile for (aarch64). ARCH can be one of:
                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64

to:

    --arch=ARCH            architecture to compile for (arm64). ARCH can be one of:
                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 configure | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/configure b/configure
index 06532a89..dc3413fc 100755
--- a/configure
+++ b/configure
@@ -15,8 +15,9 @@ objdump=objdump
 readelf=readelf
 ar=ar
 addr2line=addr2line
-arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
-host=$arch
+host=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
+arch=$host
+[ "$arch" = "aarch64" ] && arch="arm64"
 cross_prefix=
 endian=""
 pretty_print_stacks=yes
-- 
2.48.1


