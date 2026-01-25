Return-Path: <kvm+bounces-69054-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mICgFKeydWk6HwEAu9opvQ
	(envelope-from <kvm+bounces-69054-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 07:05:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AD5EE7FDE8
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 07:05:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3A2B93014427
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 06:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA653164C3;
	Sun, 25 Jan 2026 06:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dpOiRDKX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57609315D57
	for <kvm@vger.kernel.org>; Sun, 25 Jan 2026 06:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769321092; cv=none; b=Iu5R8p6/v96rW+hWbf1Eyqbou4mqi/LW0OO30cJoW81fKj5KZONEV6zlPx2WruQulEH7iZhZ/tu7Z2yskg58qawtRftRnWVIv/91sMpHZS/mWvdlAv//puiC6P3k+pXWti7n79WjfWdJggMnNtukRHYZIdjpdc45OvNyXzbZ4Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769321092; c=relaxed/simple;
	bh=j0y5gSih2Jq5DRi6Vs9SOcxLJyfJcwnozVs/xA5Y6h0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KbMNUxOeNgbOdMh8/2Pdc+knw0FOl/k6eJV1mr3C5lIy3dHaz1FyW3bMTdiykh7oTl5ZsjM9Tq824tEXsHEkKjW1jDdXkePjBkRpGssaiGI662GOpxMqxMslX0A7NcWSTMuHPorQaI+osBxzIrX1xB1VxiXVipPKTXKrb6a0Jog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dpOiRDKX; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-81e9d0cd082so2879170b3a.0
        for <kvm@vger.kernel.org>; Sat, 24 Jan 2026 22:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769321091; x=1769925891; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=K+PLBq69wrKLc26ADhjxIh+RODq0JZVHyjoP2LCVX+I=;
        b=dpOiRDKX4QzKjWwegBFVH+eFRM+E0ogDSdTgrA3bOUiTgx/EaGuQBlkH//RD2+RwXD
         vlnhUVhR1wftyeW9HFGn8IoF9M8HZu/K6NVI8bIDGDM5ImMBRjj+URuSyq7b+KJyspSF
         qN0ZWlT1Rx2SpXW5oDi4IdxRhLyeHYL2KMVxKGAGTcLnJ94FHmgR/flyLYOU14LvqdKZ
         4QFno1LhHHNvCzQ1T5PFY+/kO5EwQm5656GBPqwcDzRhWIoQnI4ATsRE32hCAqdh2a5/
         cTl/rb5Wz7fCDiWih+Xg3FNEHWyDWhTqgioJHJnDq1EJbAQ2e5NMqrrp6MlqJkqzTsuk
         ka3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769321091; x=1769925891;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K+PLBq69wrKLc26ADhjxIh+RODq0JZVHyjoP2LCVX+I=;
        b=i/lYpvQC5LcAZVngPGutndKHZW8gKD8Ho/LcEa9Rd5L0pyKHFXSq2Qx01/LrwayWuO
         pIVZETjsbOYfcF2NtfkOnBTlnMzNr3Ch0OynyVcIv+Q43TWimn5VB+bMyf6dL/X7v86H
         4mSUI/9vwyMmMAC6NmdtHIKkNqAk9HRZPgu3mLQWBc7oWUnT9l508d7Nc+/ppeWs7FyE
         mlnZJoCO/dr63kz9KwhGsXOfYZTvfCbfo7eRj13iiTzIu2I9+1MIVAgRtlZweu74I+KZ
         18AF/wtabKW71ETkaGkatf5cSfy/e/47El/fklGt2VaPvppOH0aaTxkm56m9yNXKvrwE
         MN7Q==
X-Forwarded-Encrypted: i=1; AJvYcCW1+MoMxX93xsg7BEwCt7b481SI4nU0b5P0E53dBP6SEw+kosatxAXe3NWLjU7U00sHe2E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuTrS6ArlNr1INprTJuaAXKt52v91h4gikfNe1DpPLPa0wq/0A
	EoQtO1JZvGruA5FtDlhfryKWye5Q2bCCULzDkiHnTxMdckrDZ+/y9XPp
X-Gm-Gg: AZuq6aJxEhVRJGk1DNQiVf7HKMdkp8sytVn54BRODjQrSWPu5izx+D3r6DjhNlFeXl+
	T7z7mFgI7x1HFb3asRHsc+mwCVYs0oYyQV6GQMJ4vEJ6welsA/MBxVI9r5n4wtHUbL++nzoKT3D
	CCr//+dvoVzHa5zOe9UjSqLepwFWpVF6rYSGZXaub+tPAi9vM+aJ+ouTXQu7EFhogVWM01dvCkj
	93/uC2Ktocfjfup/dsHEH/6MK+YLyKD0ZfpyPBFY8ruiaCa8p3CxoduDH6ZSeEUTqBK16oILHth
	/BBidtxs5ZLoxX5qkFNtiiZx647Ze3Y3kS1s5L7eP+ccOZQKhrrvgl7HN+rs9uQcK2M+CQoJ38I
	50KNYRlK1qifKqNUkUBIDoAjwQ777I+EGTaW0dfvgkh1t7s/+nI5FtkKzekLkPIGZRk4FyRWEDf
	zYc5QjhkS/FTCw0uc611iSg2WiqigNUGOChiAjhpcwNz9NbR02YPQ=
X-Received: by 2002:a05:6a00:14c9:b0:81f:3a83:9756 with SMTP id d2e1a72fcca58-8234121ffbcmr739273b3a.30.1769321090580;
        Sat, 24 Jan 2026 22:04:50 -0800 (PST)
Received: from fric.. ([210.73.43.101])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8231864489csm6108340b3a.9.2026.01.24.22.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jan 2026 22:04:49 -0800 (PST)
From: Jiakai Xu <jiakaipeanut@gmail.com>
X-Google-Original-From: Jiakai Xu <xujiakai2025@iscas.ac.cn>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Atish Patra <atish.patra@linux.dev>,
	Anup Patel <anup@brainfault.org>,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>
Subject: [PATCH] RISC-V: KVM: Fix null pointer dereference in kvm_riscv_aia_imsic_has_attr
Date: Sun, 25 Jan 2026 06:04:41 +0000
Message-Id: <20260125060441.2437515-1-xujiakai2025@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69054-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jiakaipeanut@gmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AD5EE7FDE8
X-Rspamd-Action: no action

Add a null pointer check for imsic_state before dereferencing it in
kvm_riscv_aia_imsic_has_attr(). While the function checks that the
vcpu exists, it doesn't verify that the vcpu's imsic_state has been
initialized, leading to a null pointer dereference when accessed.

This issue was discovered during fuzzing of RISC-V KVM code. The
crash occurs when userspace calls KVM_HAS_DEVICE_ATTR ioctl on an
AIA IMSIC device before the IMSIC state has been fully initialized
for a vcpu.

The crash manifests as:
  Unable to handle kernel paging request at virtual address 
  dfffffff00000001
  ...
  epc : kvm_riscv_aia_imsic_has_attr+0x464/0x50e 
  arch/riscv/kvm/aia_imsic.c:998
  ...
  kvm_riscv_aia_imsic_has_attr+0x464/0x50e arch/riscv/kvm/aia_imsic.c:998
  aia_has_attr+0x128/0x2bc arch/riscv/kvm/aia_device.c:471
  kvm_device_ioctl_attr virt/kvm/kvm_main.c:4722 [inline]
  kvm_device_ioctl+0x296/0x374 virt/kvm/kvm_main.c:4739
  ...

The fix adds a check to return -ENODEV if imsic_state is NULL, which
is consistent with other error handling in the function and prevents
the null pointer dereference.

Reproducer and detailed analysis available at:
https://github.com/j1akai/temp/tree/main/20260125

Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
---
 arch/riscv/kvm/aia_imsic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index e597e86491c3b..9c58a66068447 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -995,6 +995,9 @@ int kvm_riscv_aia_imsic_has_attr(struct kvm *kvm, unsigned long type)
 
 	isel = KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(type);
 	imsic = vcpu->arch.aia_context.imsic_state;
+	if (!imsic)
+		return -ENODEV;
+
 	return imsic_mrif_isel_check(imsic->nr_eix, isel);
 }
 
-- 
2.34.1


