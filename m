Return-Path: <kvm+bounces-38509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D064A3AC59
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 00:09:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9760D1894F6E
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 23:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A33161D958E;
	Tue, 18 Feb 2025 23:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b="L+uNAUPN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E24D2862B7
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 23:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739920181; cv=none; b=IKUnUSieus+1wl8nEf7F1HmEfDZoQjzEwsFhja3TpofkbS0p08gsx6r3x43zhm8vXgnHRrKHb2IPg8nxWCxMcOG1f6lOYdg4f25dkPlE/7NDctqCKRu7LdaVf/o8a/gf89w3LCKyEgKBJ+ZsR6+VapEQvzz7DiJ+K22Y+8Xq5U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739920181; c=relaxed/simple;
	bh=6Nhg1O6blPZgQ9N1EcXhOdZPzshzMMts66O0T+NgGko=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=c7vpOOwEEIqV/PXiZ9gCSbmxMK4fyO2zOG636CCnpdAOIhFAbyGMSvFjCR13H8dQRIBCBanqdqdnMrZOuhK+PxXCD0QDL7oYzloTHVxj+IYdwvPwgvT2dlrrmHZhzzuPICg/2WyZzJ1IS/+y0mz5GVHx4ZJ4PQJU7pyYrTLWHKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tenstorrent.com; spf=pass smtp.mailfrom=tenstorrent.com; dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b=L+uNAUPN; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tenstorrent.com
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7272f3477e9so418966a34.3
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 15:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tenstorrent.com; s=google; t=1739920178; x=1740524978; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3y/gR+LeihyJHTKRZOGopeinhSvVCmlzc9gkBxiMUM0=;
        b=L+uNAUPN1bx8o0tE/6iICjsrvhd9Gmu0DREBFZ7d30RtK6D4X7i86KMxRB7jzjLCBr
         69F7ion3xyAGhS0zWtO1A5WyJSr+43XV4jwDaysn8+l9CQkypKkfekJY7CWcWQ3s9AfY
         mEJpNKe+vim2mv7hFsAFUQY0Sw1uhb0JZTjQVlAreTGVHzHP1ZZSP1ruEu56uoezqqrV
         YQFDQKm3NlD94rq3FanZeDgoPGrXXW2jyT2ZyMzd0YaGeOvvGCG/yia08lr2x93evESI
         HpCoxGDWo2PdpFJbxRWn0Rp/VxU/3lvb03jUdRGlezLHPmbKHh716rBJMeJ+ssbi/oi/
         bpIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739920178; x=1740524978;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3y/gR+LeihyJHTKRZOGopeinhSvVCmlzc9gkBxiMUM0=;
        b=hMypwFWdfsBrAXGkGD6BMUUjwgWLpK+dBl+6dduTgJIFwFmwfpS9y0hz0CXYuJilds
         /hhOsEkdoiLwpkHM+iL+v50pkbEX+nDeJEjb3NScFV0Lnkl9BVU/M4NCK6v+1hVC/7Kd
         u3GWyE/9eCtYOnp47jlxrqAF86KrZ3Cm23gQ86mSHvL19DQbIWySpysiZ2oOGDoZl28J
         s7iSmg28P9Tor0T6Vff/LamSnG5BHuW8uoRmOfXBdjbJ9Hn128TrJt6EW1O15+auCFmH
         pC0nrww3yvEGlZyncs1Gln3sBTdPIl1gxdfWPXoC3FAZGKY/mjE6tPHSNajdr0F1W8dq
         wlrA==
X-Gm-Message-State: AOJu0YykV8cHKLKWYcXnXJ1c7wM4Pu2+nucjC2Dp84D8XgxrDXAXsiPN
	+HqHKM4qjlkZZr+oLGF55adspEgvvy0L12PWPK8CUCoG6hj6BXjMSAsdDS/5ZXAcbQ1Mf1f/0zk
	nNA==
X-Gm-Gg: ASbGnctgmkta4RFRpt//UK0TxDWUaVuEpQz33fj3LusyuIVAw1bv/Ynnkzr0sRIhJV2
	cVA4FndWC0Z+5OLSSsuTGJjEB46HNHZv6pOoSqtBvcPz96JkBtc4Kj0xLCwfAMcIHtCseBON/VG
	KngguWtIiRVDJQHKswnqqPnwzFK72OUmTTkO/iAQvwMG8PEAFpWFkiV8d/Rav5pFCBZE1LeFAq0
	Bm3cfvE4M+8KjX63O9jxq7pKaQcrj8M7qykoV3iSI0cpqrOLUTfW+48TghNvLnnJZz/oo3fSf2Z
	wcixK8OUtmG+MQW0Am8fY+RHekGcVghsvw==
X-Google-Smtp-Source: AGHT+IEmY18J1FmPvXpZGIHY4UpFVhq/GcJfyU8ixvP3S0+WUMLRcc3l8sD3KGr+jc22yNybL1Btwg==
X-Received: by 2002:a05:6830:3697:b0:703:7827:6a68 with SMTP id 46e09a7af769-7271202d93cmr10813162a34.6.1739920177952;
        Tue, 18 Feb 2025 15:09:37 -0800 (PST)
Received: from aus-ird.tenstorrent.com ([38.104.49.66])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-727359dd714sm454360a34.64.2025.02.18.15.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 15:09:37 -0800 (PST)
From: Cyril Bur <cyrilbur@tenstorrent.com>
To: kvm@vger.kernel.org
Cc: apatel@ventanamicro.com,
	joel@jms.id.au
Subject: [PATCH kvmtool v3] riscv: Use the count parameter of term_putc in SBI_EXT_DBCN_CONSOLE_WRITE
Date: Tue, 18 Feb 2025 23:09:36 +0000
Message-Id: <20250218230936.408429-1-cyrilbur@tenstorrent.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently each character of a string is term_putc()ed individually. This
causes a round trip into opensbi for each char. Very inefficient
especially since the interface term_putc() does accept a count.

This patch passes a count to term_putc() in the
SBI_EXT_DBCN_CONSOLE_WRITE path.

Signed-off-by: Cyril Bur <cyrilbur@tenstorrent.com>
---
 riscv/kvm-cpu.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
index 0c171da..84d35f7 100644
--- a/riscv/kvm-cpu.c
+++ b/riscv/kvm-cpu.c
@@ -172,21 +172,23 @@ static bool kvm_cpu_riscv_sbi(struct kvm_cpu *vcpu)
 			str_start = guest_flat_to_host(vcpu->kvm, addr);
 			addr += vcpu->kvm_run->riscv_sbi.args[0] - 1;
 			str_end = guest_flat_to_host(vcpu->kvm, addr);
-			if (!str_start || !str_end) {
+			if (!str_start || !str_end || str_start > str_end) {
 				vcpu->kvm_run->riscv_sbi.ret[0] =
 						SBI_ERR_INVALID_PARAM;
 				break;
 			}
+			if (vcpu->kvm_run->riscv_sbi.function_id ==
+			    SBI_EXT_DBCN_CONSOLE_WRITE) {
+				int length = (str_end - str_start) + 1;
+
+				length = term_putc(str_start, length, 0);
+				vcpu->kvm_run->riscv_sbi.ret[1] = length;
+				break;
+			}
+			/* This will be SBI_EXT_DBCN_CONSOLE_READ */
 			vcpu->kvm_run->riscv_sbi.ret[1] = 0;
-			while (str_start <= str_end) {
-				if (vcpu->kvm_run->riscv_sbi.function_id ==
-				    SBI_EXT_DBCN_CONSOLE_WRITE) {
-					term_putc(str_start, 1, 0);
-				} else {
-					if (!term_readable(0))
-						break;
-					*str_start = term_getc(vcpu->kvm, 0);
-				}
+			while (str_start <= str_end && term_readable(0)) {
+				*str_start = term_getc(vcpu->kvm, 0);
 				vcpu->kvm_run->riscv_sbi.ret[1]++;
 				str_start++;
 			}
-- 
2.34.1


