Return-Path: <kvm+bounces-66606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8411DCD85DA
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 08:17:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F2947301517A
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 07:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0BBF2E62C0;
	Tue, 23 Dec 2025 07:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z4af1ZPu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7EC10F2
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 07:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766474250; cv=none; b=fEqoKaKPFl2SxobeKWyltIZAQzb7Aa/BlP2DzGaw0RSxz1KXttf4dAgpAK86gN4rR8H9/wX64bcBdmQ8zHirJ6aSCU2c8j55dZTmnDYs1iYYVPl71W6Yw4G+jxAQowENiSinxlVI7k120nGbfgSouL4pbb8WfZokOgzS1kq7vWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766474250; c=relaxed/simple;
	bh=rcVgs2oysaTGHsi0WoeMKgrbuj2agH+XtQWhvYom0qQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=W9PfSCKL5Wl7fqNULJbeHJqfRA6xSI6JEF9m0xnLPPSY0agST1S0Oqy6jzkW9ps3AJq5ipFigfzq+fezcxvU/Rpt6ckZvZwmkB25zmY2ca3qos7ZW3l619UkJPPSsWMyWeD+TYox9zfT9eJHUkl7xZ6/t7eVxN/QQLjALdg6e8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z4af1ZPu; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7f0da2dfeaeso4867042b3a.1
        for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 23:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766474248; x=1767079048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=0AZYxeFaAjCFw/z2wD9QznaYeyXIGRCI2X83K4WbTtU=;
        b=Z4af1ZPu+sH28229bEfXnZzP8YVvOgLt91uxMm5GXGJU9zAxu9L8TqXGeJl6mOwNYK
         YAMQjBtAqAl8DZ2+s3xlgZtlGTK3Ea3oubipWXxtMc/XKFcVrYNJC2MHyUMmi11ZuU8p
         BfcF2QjpfJVFJI1T40g2z/vHKecUrz7Di06UGY41ZMgSGrsOGOCPynjrp3nUDiW9O+L9
         1TMJckDI25l5BCohe3KGqGcp7jV9zjEWhSxd3G/T8ohtt1YOQ2RgTpYZI632FpF3t9eV
         LRRuxRrIVMAo0cZI994XkXXGNVWefpX3L9nKTsztMvkVWjSBjXIDt8aD9y0pclK8bXvz
         2Mcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766474248; x=1767079048;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0AZYxeFaAjCFw/z2wD9QznaYeyXIGRCI2X83K4WbTtU=;
        b=PHgwD/Z8lbNpBYpi90jXu7doGpi1fpn5kuUaXwGHdhO19jolSlpP1ujQwQvCI+9Wpl
         8qajBLYd5Lv0R6kMSeOKjCbmmncu0tL4iE2J8NkEVwIZdKz/KONaYz5A4NaFHHpVxB2k
         Q195GRyBLDLBzmQOxOCkaoIBoYtOI8kl3sjstuqGwEpHHFwCgpkX1bE7diTxXRA926N6
         yke0qzfPqhzpm/VbFCMxaxWaThDzXgxkbEQ4uY/cvX5dNEPXK0YSZcfL4jLxGXbLjCHF
         Hwdn9uH81nkNB7bhLGQjE2AYEl+tpH+XfBqBLV9P2833m7/v0CotmvjyCVQ5NlwF/Bm8
         PzJw==
X-Forwarded-Encrypted: i=1; AJvYcCU1pbNT1gNtNvssoElV844EUhYifPLdb/sbCaFd6lGl/l4zxzCL0RLotKpAPMFrfWx/Eqs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+ieXR/nYTUgtsj/u4Rj+bIn9CNtGhEpjcp+CTMDWRgSrIuSuU
	S/YgAqLD7aEtl56rR3X3IBqiDjNKVARDN+OdKApnFcqxjyWIycQqKvwwGy5Krw==
X-Gm-Gg: AY/fxX6OqaViNxLFMirX4hN7Sm5G7sQ6sH4AgEHxxYVMSLyljS0qXll9Qmu69fmYa1G
	B6eXlZIPoFOhl9yoIAYoeLvKE3iO3R8nOm8QCHmQIRtSTNmd0Zj6CsIZPc1dqZKeJIGeixBGpRH
	SCxwpgSvnwAPVFG2VfkG/oP2HENqNCR13qFlL2xEx8vYtiD3oIhDelox86BpgmADmtKY2P3y/Of
	3am/74gZGXI8vhozPJQyaE6bh/AyHoJbu3qYIfCMubN3Tu0pO+CzNQcWp+9gtEton8zaTzn1P1a
	XFZYgijn3IYrU82EUs3K+ERn2/uAg1lIjvAdxN3oDDXVSXpBuMLamW9OdkBBUCYvRAsMimUDLTz
	JtLh8wQBgIzjtvyGLrDbDKj4XuCFonWnS8fgN2KKks9IlArxWHrJcOM+EXuSJIvUfYoZCNOj2FE
	+LJgWbNouPWjtwO+cqP+J7lbizKevMzkRmOIVc5UeBY7JdsJFtEoLmew==
X-Google-Smtp-Source: AGHT+IFLdOzvivk7Upqt1NGeyU/xIt2qQeG9FIIAsApd5OA13WmweRRDH0jzxJ5wbkfVYhRtHxTMtw==
X-Received: by 2002:a05:6a00:e8b:b0:7e8:43f5:bd1d with SMTP id d2e1a72fcca58-7ff6735e5a0mr9849637b3a.50.1766474247904;
        Mon, 22 Dec 2025 23:17:27 -0800 (PST)
Received: from FLYINGPENG-MC2.tencent.com ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e0a1a2asm12604840b3a.41.2025.12.22.23.17.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 22 Dec 2025 23:17:27 -0800 (PST)
From: Peng Hao <flyingpenghao@gmail.com>
X-Google-Original-From: Peng Hao <flyingpeng@tencent.com>
To: pbonzini@redhat.com,
	kvm@vger.kernel.org
Subject: [PATCH]  virt/kvm: Replace unsafe shift check with __builtin_clzll()
Date: Tue, 23 Dec 2025 15:17:24 +0800
Message-ID: <20251223071724.50294-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The `(mask << x >> x) == mask` pattern to check for shift overflow is
considered undefined behavior by modern compilers and can be optimized
away incorrectly.

Replace it with a safe and explicit check using `__builtin_clzll()` to
ensure the left shift does not discard any bits. This avoids UB and is
more robust.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 virt/kvm/dirty_ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 02bc6b00d76c..926a4c0115d1 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -171,7 +171,7 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
 
 				/* Backwards visit, careful about overflows! */
 				if (delta > -BITS_PER_LONG && delta < 0 &&
-				(mask << -delta >> -delta) == mask) {
+				(unsigned long)-delta <= __builtin_clzll(mask)) {
 					cur_offset = next_offset;
 					mask = (mask << -delta) | 1;
 					continue;
-- 
2.49.0


