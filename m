Return-Path: <kvm+bounces-64943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7845CC92D90
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 18:52:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8075A4E4F48
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 17:52:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 550B92D781E;
	Fri, 28 Nov 2025 17:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BKXKYfTL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6343628C849
	for <kvm@vger.kernel.org>; Fri, 28 Nov 2025 17:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764352343; cv=none; b=nTuzXF/6blIn2W7h/C7lf6Ez7MqMKZgsDXHAX6SKFjScycVaIITEV6e9sduTGNJKh2Sla9cbG5ZfSfPETx7N2sh5R9RQFGmztAQUxtkInnn8kYK/ckYhoNV88kyWcDmHL37rHBgfBtTXtCc4UDlSUYKttiu+vPdBIzYzdD5XrBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764352343; c=relaxed/simple;
	bh=GkebHRZ4hW0W7hKq0Uj4FDaIkukgfjcfiLZIR/1thWU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pWqH9+AXkOgwIDlQkANI3zLxEpK1D8iX8t8XlZnmjbgtR1DSj7HhPBzv6uCLnqhTOoawHFdd4lDAnvCsBsKW54RUwKQx9dL28JRBI9xp7GT+/Gg6l8QI4sAykq8kzQV/NRuNqKtRRnI5k77ZYNRappjWRIFq3nUjwCQ6ergFiOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BKXKYfTL; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-477ba2c1ca2so23692475e9.2
        for <kvm@vger.kernel.org>; Fri, 28 Nov 2025 09:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764352339; x=1764957139; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oAfyF823/XbGGGKg2P6nxUijTsKpVqaSaPrfyNHwf9s=;
        b=BKXKYfTLWed173LFLR9je6NtxzsImQGF4s9UD0lAxP50BiSrS/pAFPpoFakpJy2Nc6
         cMHxJZwD/MuBGz4awUmZLNZOSZ8+6d5jymZBV1WPpQpaHW4j3s7DYMFpjmIi/UKicP5V
         YP107sQNpznju3d4xVo/kmrr+HZOsm9Q9LcRDMEJck9/PDy5ch01nSS8GCnrECwpigtf
         lElzEcQXctdaxFaOq8GKSLQskgTxtRDE+2Lbu8fmBKy+0rP5Gv1d36V95SiH1kADJ/st
         bLuLWrpIcwwM3wBZxTRzrRFOoIo00DlaqY9DP0edUD8zNRl6sePhFajKRi/zg21pONtm
         /kkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764352339; x=1764957139;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oAfyF823/XbGGGKg2P6nxUijTsKpVqaSaPrfyNHwf9s=;
        b=XnlF8k+LX5BgJqv+swS7xcgTbWGdK5XEKAJgswUrqv8WX+eegx8pXNMAQcxs+2k0lx
         UoOE8I6ju2oByMc6XhKvSdoO2LmeUKXvr8VKMXuFs50IExowciE6EH1Ul6zKbRM0Q6DE
         Nt5DwCV9ixktCW03gsd3+0sIvGJFJNnJS/OoAZ2u5grzrnrYSj4mrok09R2VQ9kuciOs
         xOBGJH7f18oBNqX9l/qqdO3ErkesP1Z93yfSaMRDmM83oD/W1HFM3LZ5Ca9YjEBENcXd
         qnXMR8OrTSiTXL1Op8g7M498r40dNUEP0Aolv/PpLUxVFJHWELtxMeUbJWoyQB4PfSMg
         oJ0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVV4L0/vhM+aXjwC77Tn2kV1enDVRC58BgTJptkCLSzOmIfsBmMQzBiTsMjgIkMxk4/o+4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9t8/B5Kk/MqHs3IEFEXoM3sANvC8PtOYZwteeONTYUxC7WVow
	2MkLiGzgyv+BB6VZkGbOvVBt9D5/toa3Wy2dvCmdLPMYAs59K+oTTjVU
X-Gm-Gg: ASbGncuPvVlZaIwnhpu69tEEgyoWAL5byesdDfBIOYRR29g/RTTTXJ3+uhGRANdngHq
	ZjaGCi5Bv7tOFMCluoghDZjIeLgAPqyer9r8vPQ2wMwq/9XKCYj5JZ+7Dm8f7NJDyBdPoyuFULF
	RRCrLSCahTN0o4+xbjUCKFnotlFuM7qNOzxHM5GzHxcCwCxkJD7GU7l0GYeOyaFCITiL3LPnpZ5
	A/wJLe+5Byon4vD7LI4Lt7yhnDv+4DeXI4M/8ugZwZ8ugL662ttqIKJqC8KguEtrFG18+y+PI0P
	Xei/jXXP+i8UIcE0O+zFz7c12HKOAs8vWIDdjnHm0DXdRRFlWQA5uTZbkGOLxYQf8PTndkQMUKf
	GwlQkdysvwzvCHvKCH5CE1XKOupg6vPmviE01fQigb2hX5ktJeYidC3sa8G5mj/uiZF6XVqi9B+
	QB16CCZdyo4Q==
X-Google-Smtp-Source: AGHT+IFNrav6emQa7eo4LXuc9QahSL2PszCgaxJFgT0UH28eKJZFTLEzFFZCoVSa6zVdulqINe9u9g==
X-Received: by 2002:a05:600c:4e8c:b0:477:8b77:155e with SMTP id 5b1f17b1804b1-47904af05b5mr178200545e9.15.1764352338440;
        Fri, 28 Nov 2025 09:52:18 -0800 (PST)
Received: from localhost ([87.254.0.133])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-47913870b38sm33438875e9.15.2025.11.28.09.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 09:52:18 -0800 (PST)
From: Colin Ian King <colin.i.king@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] KVM: arm64: Fix spelling mistake "Unexpeced" -> "Unexpected"
Date: Fri, 28 Nov 2025 17:51:24 +0000
Message-ID: <20251128175124.319094-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a spelling mistake in a TEST_FAIL message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 tools/testing/selftests/kvm/arm64/at.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/at.c b/tools/testing/selftests/kvm/arm64/at.c
index acecb6ab5071..c8ee6f520734 100644
--- a/tools/testing/selftests/kvm/arm64/at.c
+++ b/tools/testing/selftests/kvm/arm64/at.c
@@ -137,7 +137,7 @@ static void run_test(struct kvm_vcpu *vcpu)
 			REPORT_GUEST_ASSERT(uc);
 			return;
 		default:
-			TEST_FAIL("Unexpeced ucall: %lu", uc.cmd);
+			TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
 		}
 	}
 }
-- 
2.51.0


