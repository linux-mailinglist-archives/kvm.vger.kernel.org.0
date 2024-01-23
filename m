Return-Path: <kvm+bounces-6712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A633837EBE
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 02:42:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F1C01C26ECB
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99C561272C0;
	Tue, 23 Jan 2024 00:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="NdcyDFzU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0FA6167B
	for <kvm@vger.kernel.org>; Tue, 23 Jan 2024 00:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970759; cv=none; b=DXjUPRqvGGdPR4Afd7rB9ALKbZWxAceHBl6kQw9XLGwgZQ1337mifjNaMtq+Fe0TDwUZUW092uyS2tdAc1MZdZreVVJYdRaOzYtWBlh1FtvokS6Q82XZd3BueWPSJL5dEPovve8v1RB57OJxxVC2ckmUjh1gIpFkqtXC4tBOq0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970759; c=relaxed/simple;
	bh=7SK+CeaptbBP/v+CP2JEux9OatqqjJKzGmyq2Voqx04=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RoxGkoKvrkbjTU0M/kq9K+c0awSphaK5DJc7+9d0M3SwdyMaQV2tEQ5wvf4b98W7XaRaXvJ4E8LZaKs1UbiI4C+UvB8htC8CEuOXw3u8bPAEqbI9338q5EyAF6zL2aYC48/3zv1BS9d1j23KrDv/kwudItoDeiHSfroopryw/hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=NdcyDFzU; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1d7393de183so8820285ad.3
        for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 16:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1705970757; x=1706575557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iBzwhtxHV7+0pkueVEdOMj16Ew6MX43q2RtCRgBYnfE=;
        b=NdcyDFzUhvzwX4yoUH4hoUPRRbxPVswsvgSrjYNQ54x5uzW9pV54KelUvXlN97GcLf
         LKSb1v1TQQEQ1HC134EB+87lJrhokCugQ1IC/LJwPjt0ndO4rBR7kCnNeaKMXfItHDYK
         HyNNFIBlgVVW+LRphKpcKBrr6QAdLpoZz+XIs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705970757; x=1706575557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iBzwhtxHV7+0pkueVEdOMj16Ew6MX43q2RtCRgBYnfE=;
        b=PhYS5xDFp6YnDp1p0WL/l6GS8yGcuqOrhtzzweoN8fzZtVXMuacOuMHpXHjVj9fYyQ
         Z5mjDXAUzyzA/wUD7rfaEuV5VV6HIyIhSXtD31C+o2F96l732c0RmxUr1LTw89+wKJ+O
         5roo2Bely9a/i4x/N4HW1S7FLNnJjMJ4t/GIahE3TJp5wns554GkZofSsehSuHywChvS
         qCEfB3GEffWcRx5/FRJQjN1pAgLtl2R3Fjh7a3mo90L0aw6B7EKNYCQO+nipvmU6qYHL
         YEm3X+YiO70yY3WgumCkaV4RYEkNydrzffwsbzd3fvqCjbuHi0mtHA/JtvpmSrmeEhAd
         kPVw==
X-Gm-Message-State: AOJu0Yw6coIZFgzebEToRwnsY4y4rCOD06VyxjhhIUSCVOdtwF4dsw/G
	7nu9Kcnj3oG7ydm01CfScf3b2KWA2n5bRWm9axJEurJWL54e3raLYoFe8ijXLw==
X-Google-Smtp-Source: AGHT+IF8yhCmkJNt7Ij2XpjUMJOmTKGRgOFOqqmGAHzjTF1WQ4RIpNJnjNIqKXh4JiYJsFhdhzQmyQ==
X-Received: by 2002:a17:903:249:b0:1d7:4f6:931b with SMTP id j9-20020a170903024900b001d704f6931bmr2578303plh.18.1705970757393;
        Mon, 22 Jan 2024 16:45:57 -0800 (PST)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id e6-20020a170902784600b001d66b134f53sm8013882pln.233.2024.01.22.16.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 16:45:55 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: linux-hardening@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 23/82] KVM: Refactor intentional wrap-around calculation
Date: Mon, 22 Jan 2024 16:26:58 -0800
Message-Id: <20240123002814.1396804-23-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240122235208.work.748-kees@kernel.org>
References: <20240122235208.work.748-kees@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2091; i=keescook@chromium.org;
 h=from:subject; bh=7SK+CeaptbBP/v+CP2JEux9OatqqjJKzGmyq2Voqx04=;
 b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBlrwgGMUghWI+PGsPguK5zp1jJTO9Udx8kDt3JM
 m98iBkuTfCJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZa8IBgAKCRCJcvTf3G3A
 JsIxEACt5a2RN2oZ+4JYd2ymbmpv5B6nOsrUIqOPauBUQY+OHeVN8nMnsBdASH58oAT8jCD9WVQ
 7HAb+2ANB08IYc8/R0h6xkBqa2lCZk/3c5dpFUtpIlCTzY+hAfPnj3l7atArhXefRspVNbsJft8
 hYD5qHs7sMR4xnQPCwbKLBjLn46735BXMxnSYAn9JYVGEL740vCDkxpqmQgFiSX23MaRZDi2p8U
 v1qhycBB3BSMK6Lo8r85YYSK2XJ9x47dytKFlfuqi371X3bi2J4T1Zmf1zmU0ALDy4G3/NJIlX2
 JhbQiOfH98N9+MtqcBMq3RWtHRqVRJsqM4nPVlbzO4D0Z5EKX7HzxzAg+wZOWXOJqZBUflBMu00
 jbo8OBTZLfp9yRmymYTGlNNuanwYU4YZpdO9MQx9rvC1YQM+HdtO9YWpu+++sAgjyvdln94rlUO
 sMJ9ZmFXRxInaysdaafEyQBh06ugVvFdamYsCf6FILZP9XmKMUKSGcyiRVCG0f2brI9Fuyw3SRn
 cbpJzb9ATyxDFZyuhMI/7g3fuPMKee7yNNoMul1dOGNFcLCtwSAgsgOVJEGFdCgdgXj7MmvUulL
 ZBQpjnBa8JFB3UeWkmEc5ex6AaaLMKyDaTl9rbXMZXXt2w178+78kcYV5TBWH9Pt2AyakcqiqaQ C0S0f0g8Orqog+w==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

In an effort to separate intentional arithmetic wrap-around from
unexpected wrap-around, we need to refactor places that depend on this
kind of math. One of the most common code patterns of this is:

	VAR + value < VAR

Notable, this is considered "undefined behavior" for signed and pointer
types, which the kernel works around by using the -fno-strict-overflow
option in the build[1] (which used to just be -fwrapv). Regardless, we
want to get the kernel source to the position where we can meaningfully
instrument arithmetic wrap-around conditions and catch them when they
are unexpected, regardless of whether they are signed, unsigned, or
pointer types.

Refactor open-coded unsigned wrap-around addition test to use
check_add_overflow(), retaining the result for later usage (which removes
the redundant open-coded addition). This paves the way to enabling the
unsigned wrap-around sanitizer[2] in the future.

Link: https://git.kernel.org/linus/68df3755e383e6fecf2354a67b08f92f18536594 [1]
Link: https://github.com/KSPP/linux/issues/27 [2]
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 virt/kvm/coalesced_mmio.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 1b90acb6e3fe..0a3b706fbf4c 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -25,17 +25,19 @@ static inline struct kvm_coalesced_mmio_dev *to_mmio(struct kvm_io_device *dev)
 static int coalesced_mmio_in_range(struct kvm_coalesced_mmio_dev *dev,
 				   gpa_t addr, int len)
 {
+	gpa_t sum;
+
 	/* is it in a batchable area ?
 	 * (addr,len) is fully included in
 	 * (zone->addr, zone->size)
 	 */
 	if (len < 0)
 		return 0;
-	if (addr + len < addr)
+	if (check_add_overflow(addr, len, &sum))
 		return 0;
 	if (addr < dev->zone.addr)
 		return 0;
-	if (addr + len > dev->zone.addr + dev->zone.size)
+	if (sum > dev->zone.addr + dev->zone.size)
 		return 0;
 	return 1;
 }
-- 
2.34.1


