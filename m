Return-Path: <kvm+bounces-73231-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IP2SCaO4rGkftgEAu9opvQ
	(envelope-from <kvm+bounces-73231-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 00:45:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D05622E044
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 00:45:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7248A302C5FD
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 23:45:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BDCB3382F7;
	Sat,  7 Mar 2026 23:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kW577S4F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7491A9F93
	for <kvm@vger.kernel.org>; Sat,  7 Mar 2026 23:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772927116; cv=none; b=REyVYFBppYe1deEUYuRR3Wgi2mlfp5JkYIZXN4SUMKBGgJNvVw9Fz+fmKOqM3Q1JpEx0VC8mwHJupj3DXuGVl2u/T8GOauymzhJVNNhMkoak7N5nGHvKpdyrHQPChYBifsDRO2sv/fmHHFqXSaXFayYoP3e0mBqm/+0TAY86gME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772927116; c=relaxed/simple;
	bh=B0FMhBfrocAC+fIijCeunI5+OVR44/k33na+05sqr5o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jSB+ISSzT56Y6kKbrTGgNxWqywhGNFKw4XiT9snmMsSJQiWdnHpmCGSXdsYKwIQIZREjDOTGrZJHD1LGBKhQfszBv7YJgEnKWdWpFdSsU69prEtyxMFBAK1g9jitvK5S45H0mMFBdiaIqf+L9NpC2DoKYu8ypgXPrndqxKno8N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kW577S4F; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4836f4cbe0bso91049305e9.3
        for <kvm@vger.kernel.org>; Sat, 07 Mar 2026 15:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772927112; x=1773531912; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qjRKrJQ2J/VDkoqe2xizeTmn4PJSWMUuw8x/Xk5UYBU=;
        b=kW577S4FRR5AndfU8/5opz2HwzArmfkjl3uR/DGr0TflSrY3xgIYQeig6L1f+o2Gdr
         wVGsmqqletCiknaQfHHo8snlbgMVFImBzHk73Gzx9ha48uaxTF1LjliDQ9g1rjxqsib5
         v/ma4AfRg6ieR1eKvZfaCdmH00lcGkFodnpeeMrago9EyM1yDyMHY0HEbLN5QoGuWGVZ
         d7BuEhUYXeuvf/M1Fm6vcUkwkiByC5JC8a+T/Bh1k0LEcYYfa7BttPuwNmkgrnGdrB5d
         Jnfj7E32KUn6mMHvck24Y3/HKTkxYExffp8Cu63uTLiGm202UggHF4w+Gt+HqgZvTJSe
         Q8yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772927112; x=1773531912;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qjRKrJQ2J/VDkoqe2xizeTmn4PJSWMUuw8x/Xk5UYBU=;
        b=P1zV1ZUSigjt1pRweXCQRwkecWA15tl71gse3pAMumXDFBKaKRgZine4oIh6QOo8xf
         /unPx6QqY/w8Fn6WinHSHGQ2HYSGxSvwJYRIgOyVqZcRtuIV4JtA1jpfkz4Lc3kHV0vE
         L8ZPJ72RWIW4OR7GUKm+4q4ZxnNcjWPUaj6ONs60okoNqMrgPVqqjWHbvzJ8Bh0j3+uQ
         0iDch3BWzfrUGbccD4qAjmHIMb0viV/IdJ1uPR8SwVpHHLsHNEJUcWXknfqCZ/PXnpWC
         jzsPm6f7e69P4bY/ZSRM01SPG40+uyhoLn9HpgSUu/z7loAhzEKHejKX+eb4fCnwmJEc
         XURQ==
X-Forwarded-Encrypted: i=1; AJvYcCVK5P6SzhEKc7h0mldgSandoX+EvtjlIs5jdKW2v3ZyInviEn+snbll1OCwzZZ+oc/txG0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPvRsonm+wEuXZdH4VDYMS9IO2cfrtA/rXpmN+xjiHIqrrx07F
	Iim82+Aqf+vy8dxYNLYtMd8HEwOjzqLHFmJ0lsDRAjQYZwr6GmiF1iNz
X-Gm-Gg: ATEYQzwSp9yEAyZ05eXvLlCtyEbOGuy/O4/NIY3m/LC57luAx7N164svnzUW0Ylah9n
	UL2YEExMnAtPcgJKMEG2k5Zgb1OrfOqdSk8UrTB23IKDkAz2blXE7b7gLVvOJEGFW+osxWEUIyH
	avDkQcKjOyDRAtiEDrShQ86ne6pZ7sUPkRxGa+EEKf4o257GolWdlK7RxrMyEWsREi0zOe2os48
	4YUV9HVTyDWyq23TYdTiTklLlEptyMAqR8cAaV7qZQwyPjduUcIm5MV5Hz7dhwDEV125f52ghYX
	ZHTSkcgGh2uZllpJgEcVO5TJvpsrmmhyiBocGSbcjnuSR6nJtooArsO1jTtBWhaxbkTS9DfipNb
	FkjPCHvpgTiDymhLFkAD3YkznbKege/E6biUcXqTmePrusxzoqHytAP7HXvH+Y2LTG1XtKV5TV7
	g/jVRU6bUOIkjXh6HG6W/XwlNpt/ajkmCjUGt24uBbFN+xGNkOE+Q46cqL7e3v
X-Received: by 2002:a05:600c:1e88:b0:47d:8479:78d5 with SMTP id 5b1f17b1804b1-4852690f599mr132855755e9.7.1772927112391;
        Sat, 07 Mar 2026 15:45:12 -0800 (PST)
Received: from osama.. ([156.223.176.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485247029a4sm49900895e9.26.2026.03.07.15.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2026 15:45:11 -0800 (PST)
From: Osama Abdelkader <osama.abdelkader@gmail.com>
To: Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Osama Abdelkader <osama.abdelkader@gmail.com>
Subject: [PATCH] RISC-V: KVM: fix PMU snapshot_set_shmem on 32-bit hosts
Date: Sun,  8 Mar 2026 00:43:54 +0100
Message-ID: <20260307234355.69831-1-osama.abdelkader@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7D05622E044
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	FREEMAIL_CC(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73231-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[osamaabdelkader@gmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.993];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

When saddr_high != 0 on RV32, the goto out was unconditional, causing
valid 64-bit addresses to be rejected. Only goto out when the address
is invalid (64-bit host with saddr_high != 0).

Fixes: c2f41ddbcdd7 ("RISC-V: KVM: Implement SBI PMU Snapshot feature")
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
---
 arch/riscv/kvm/vcpu_pmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 4d8d5e9aa53d..045099ca904b 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -425,9 +425,10 @@ int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_vcpu *vcpu, unsigned long s
 	if (saddr_high != 0) {
 		if (IS_ENABLED(CONFIG_32BIT))
 			saddr |= ((gpa_t)saddr_high << 32);
-		else
+		else {
 			sbiret = SBI_ERR_INVALID_ADDRESS;
-		goto out;
+			goto out;
+		}
 	}
 
 	kvpmu->sdata = kzalloc(snapshot_area_size, GFP_ATOMIC);
-- 
2.43.0


