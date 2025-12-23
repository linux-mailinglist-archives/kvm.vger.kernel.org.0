Return-Path: <kvm+bounces-66605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EA07CD85C8
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 08:11:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 97E6C3015867
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 07:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C65F32F1FCF;
	Tue, 23 Dec 2025 07:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ns6hKcB8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3A62D5412
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 07:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766473903; cv=none; b=SLSZRVEtfOeybtBIVkUC2ptGiMOuYfCgU7cyPI8mIOfnjvE4l+xCuQJcHghE1YodWFoZUklfuMglYB1zgM8F620sFxUbchvTwJ3yslWgyZ7Zhc9GklF3u+Dudfbj0Xt8FR1m7tjDJmSa+D9g8KY2tC8jnMyNlzMLoW3JoPahRXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766473903; c=relaxed/simple;
	bh=cY1R8BZqEkFfUdOMdBuzmERZu4oYIZ3e/SNl1IWGgHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jaV51p+lIiojSHxIt/JWvXKT6bje4vZQ0rzQrpEIhU0Dk9ACUJvehC3Bk6uy8C86anbPO1L9eQiAaG384VbjKW1H44S1aEcJu3lPqvmgvXhR1h192CKXzxQr+ZVo6q52h9hmVPMG/7IwfaprGdGPvAOT3Dn6/RQFsyrll6Q28PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ns6hKcB8; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-29f1bc40b35so80437585ad.2
        for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 23:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766473901; x=1767078701; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AA4up7hjWfGDJm+yWOl/FhE/QkC5ojky9paFwtWKLBw=;
        b=Ns6hKcB84zVnQUkjWwPn0bl748Z1pi6TT3LWon58mMIlBwPxhtN3SJ+Toi+o4Cz7cR
         TbfGBKOVviTclV8Ng6NvWRnO4Ht/4LY+Lc6/cLToQ8m7HhYFc0X+NKtNpAOfP/mPNtoX
         yuTGx4lh7JKBNkzlZBdk5hGYvF0kiNLFB+QWs+4xQznmvtDVBxBu1cDovyxj0xydq6Oc
         rAgXP2e+siS1IMaHzqBufa9pwQbjNhrcC26xi2RXS6HgbyqFrtoQL3eb4z0Ptl5wPGqJ
         o3s28kS8mFaIfLrfHjTQ8bbJKMM49v2TbBK4BV2aHd1q3oAzpD1lELGiw2699YhU/snd
         xHbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766473901; x=1767078701;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AA4up7hjWfGDJm+yWOl/FhE/QkC5ojky9paFwtWKLBw=;
        b=mas1LiPCnaec5d0aA5FVtf3IkDQ4iuMVm8Wui9T7hrLFRxT9DLr/Y/08xfuD4eLQiq
         MtPd64G2c4RXDQoMeE6IlOKsV5kvNRLG0ltZdhMh08gGzb9t6gMflK8/4l5j2oo8oKr4
         5X/zWc8118tlxsBJDOHSD456T04Uz7sWU0EiLii8VC4DCqIH6VfwUo549oaTBUlP/txN
         lhjWdaKLUWSRWnwR0teJPaRR8cA2Un3l2AKwlMMzRRWNWWOLbIc5t7yzmdXklj2hjJFX
         Avi2veW1ubHH+Giq1Gmnzz8Q0e9nXCUJn9NuLvRTxEZDQPx/HqieITzWSnIV9fEFdtQb
         nh7w==
X-Forwarded-Encrypted: i=1; AJvYcCUoObvKh5H5jM7XETRpQ4T9yAH04vMqAsFduae0LkpmPZn8qK9DjS5ZjkNMz497LuqT/Ik=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfovOsO2bx8ffv0yJ832v8rYMZbXgJHxVQapU+UcGdoJNwUqxu
	4Yt8KPh74VF1sZqeaqqyWGLr/3/QN/z5qa6RpYAVH2Xeh2AWH1wT6Suv
X-Gm-Gg: AY/fxX4pHQDq5+6gSOnWydG+6Xv+7WsQluH+/Q5r/2y+BCgQiLRjyQBD41mdoG4sTvm
	izeOwYXfA6Jv2+X7LvcS0DXvgJYr7h1snASawbjJMkPYr0LQWYDNtoLarDpZU4Sjj6JpDjTsWH5
	SAfb6p33GEjak+UFhYyJt6uBybt6hhLHvVi8Ejow5wH6SAKlTxPtayDGVRIvQUreCa0DFgfZBeK
	hPg5rcttwC4jPpY0vruE+wXIVRDDJ6QfR2agbf5Iy+6Y7DZvB+jtM5fl2Ic9hV7qWEDQbfC4O4q
	0Rr1qi/UUTKUR5w4xFzIvE5JKCRczrHRZCFf9HI9cIqkNSl+xVU1Bn/uWHZjS57MCOvor9C/GQJ
	c0kU9iuI+PB1F4vRp7/5vbk0JV1We1EKDffRE4Al3V7CR9bDLJVWU2cI3tZBRpNEfYewNhhAlIm
	Fhubqe0BwsZk5wcM11V5T6Si8Qi7MspGqbfo2ojJ5GVIp3gRGMrDz6vcM2vCLF890F
X-Google-Smtp-Source: AGHT+IG6xBQ1AjbQIoP64XaYatMphmPBNh85ZqnSFiedBkbqAJr47CuXrlbdgkQxQ5BWgu1VyG/FnQ==
X-Received: by 2002:a17:902:e552:b0:2a0:d4e3:7188 with SMTP id d9443c01a7336-2a2f2223bc0mr153759115ad.13.1766473900912;
        Mon, 22 Dec 2025 23:11:40 -0800 (PST)
Received: from FLYINGPENG-MC2.tencent.com ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c82858sm116757195ad.29.2025.12.22.23.11.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 22 Dec 2025 23:11:40 -0800 (PST)
From: Peng Hao <flyingpenghao@gmail.com>
X-Google-Original-From: Peng Hao <flyingpeng@tencent.com>
To: pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: Super User <root@localhost.localdomain>
Subject: [PATCH]  virt/kvm: Replace unsafe shift check with __builtin_clzll()
Date: Tue, 23 Dec 2025 15:11:36 +0800
Message-ID: <20251223071136.44743-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Super User <root@localhost.localdomain>

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


