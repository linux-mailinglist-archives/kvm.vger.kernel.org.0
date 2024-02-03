Return-Path: <kvm+bounces-7937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A748984864A
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 13:46:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6207528219B
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 12:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F4775EE65;
	Sat,  3 Feb 2024 12:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="kIJLyRO+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107B05D911
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 12:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706964366; cv=none; b=quJRQfHHtLdNgV8ItsfybQF0ieC4oNG+Ehoehoc+cLFEjb9pkPsUSfVXHc50mQSjEeJoSpUQl37moeNYqK2f8QDjG/3vhhfsRtDi6e7+RLy7ofWTbBYoaM3ds29RvlRpv5h8iORgXFxlR6YyWfG7Y+p8RyH2wcn2VkMLuW7kkxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706964366; c=relaxed/simple;
	bh=2C/lBPGgw35xKUUT+TSTkIl00FYT1lgXCPI4v1lLSH8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FaPjxQ/VYFBWO5VpUvByl3+v6RwJfw2E0NSShnwsa8+AsYmONuyg9p+nlYC7KS8EcfPQ9g/NnnlKQkMZlRjfHWEhOKY/1yhf23wslGT0jXYo0dH/dy6DZa7yNFkMYwAjCuOTt6PgdWOOBPWWJzJVloK6LOTQaJ7zK2Rf9A5a3BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=kIJLyRO+; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-51124d86022so4777357e87.0
        for <kvm@vger.kernel.org>; Sat, 03 Feb 2024 04:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1706964359; x=1707569159; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vg2BmUaHuPeKYpoaY9EQkW970I7eWQW9doIaoyWAUis=;
        b=kIJLyRO+Edhwf9ZKV9RDcQSgMGaJVFKvd6bulNYxCpyErw7Q2TQUC+isPIPlDkvbIn
         W5z0TaT43dMx8QOe5pOG/F7ztyvbB2WwXJ/pzzFc+0K1utipQ+aemVwRJLT/BKDMX0FP
         McaUzApeBoFzDWUxl2z4GF//BN9Ds4z4SsXa64bXnhdQFUzOL9SX5mXFQfTDNBCYheyO
         DaEuoMq6sT++Uz6VOtOCfBtaTrlOZccMc0B32tRtKEa+P+X/fO/lVItbO8ZFysCHfL/r
         oNWIDdEqFUvy1NNFLbYRKbsSBInTFB6kBOZGehfi/dnrV36qRl1eFafkgtIxsegCeWb3
         gH9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706964359; x=1707569159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vg2BmUaHuPeKYpoaY9EQkW970I7eWQW9doIaoyWAUis=;
        b=QnN/QbmXlrNIYa04bYiLkFJyq8+P+PkToKy2hFYdbU3rMn3Jr3b8Dqb+vhSvPyIc9I
         Dm5N7vgQ37gF/VQNYok2ULO6qr3KGATMrXCYjSxBAecBnImeUJqqtbFo3B3Vd7q/X7Yz
         JkHMvpnILX2iPVxMh+MgyUhuHE/Et/me1ytiDa3V9UXd10itjh+LFjElzBuTToN2P6gB
         Qbs4VkQWAifhOr86v9QDRpHC8XM6qB2ZgUcLqWetSK2YF01oH9ZrVDdOt2b/otMj+f/0
         CguvHZ8djkxkDo9fsY7ZPMDNL0iNLzx+dRZch6zxaUs2/SJeBC7eNDGAniAAFpN64xXM
         6N8w==
X-Gm-Message-State: AOJu0YzBVhudyAc/NM9oupAja+x8WRkiZgOqBZfiKk7rzzLtyXr4EfAJ
	dGuMWv/E4wg8VgX3GroPP6AJ9QGvQT5L3jc22FDqVo7T2B7jNU1RDrvFcXoijwI=
X-Google-Smtp-Source: AGHT+IHLaJp0UIkY+26LBCOE/Q93lwK8V4vDaMqjE89YFITfGERlrudcPjVRLHoL3FyDX2x2GcOFQw==
X-Received: by 2002:a05:6512:3e05:b0:511:3232:954f with SMTP id i5-20020a0565123e0500b005113232954fmr5562711lfv.2.1706964359090;
        Sat, 03 Feb 2024 04:45:59 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUl2TbQyK5bxtm25un3MxLgtNkDy9oSr2NtlP52Mpw+6Ed0IyNmpMV5RbgdFh6wYQc2WzJZ8mPyCD7xM6g3qwYXq1CMMZYO7Y0hxMgkUjZU4AmxVwIKJaq3LBY3
Received: from x1.fosdem.net ([2001:67c:1810:f051:d51b:7b6:cc25:3002])
        by smtp.gmail.com with ESMTPSA id i11-20020a170906250b00b00a36c58ba621sm1942015ejb.119.2024.02.03.04.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Feb 2024 04:45:58 -0800 (PST)
From: Mathias Krause <minipli@grsecurity.net>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 3/3] KVM: x86: Fix broken debugregs ABI for 32 bit kernels
Date: Sat,  3 Feb 2024 13:45:22 +0100
Message-Id: <20240203124522.592778-4-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240203124522.592778-1-minipli@grsecurity.net>
References: <20240203124522.592778-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ioctl()s to get and set KVM's debug registers are broken for 32 bit
kernels as they'd only copy half of the user register state because of a
UAPI and in-kernel type mismatch (__u64 vs. unsigned long; 8 vs. 4
bytes).

This makes it impossible for userland to set anything but DR0 without
resorting to bit folding tricks.

Switch to a loop for copying debug registers that'll implicitly do the
type conversion for us, if needed.

There are likely no users (left) for 32bit KVM, fix the bug nonetheless.

Fixes: a1efbe77c1fd ("KVM: x86: Add support for saving&restoring debug registers")
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arch/x86/kvm/x86.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0f958dcf8458..34ea934b499b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5504,8 +5504,14 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
 					     struct kvm_debugregs *dbgregs)
 {
+	unsigned int i;
+
 	memset(dbgregs, 0, sizeof(*dbgregs));
-	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
+
+	BUILD_BUG_ON(ARRAY_SIZE(vcpu->arch.db) != ARRAY_SIZE(dbgregs->db));
+	for (i = 0; i < ARRAY_SIZE(vcpu->arch.db); i++)
+		dbgregs->db[i] = vcpu->arch.db[i];
+
 	dbgregs->dr6 = vcpu->arch.dr6;
 	dbgregs->dr7 = vcpu->arch.dr7;
 }
@@ -5513,6 +5519,8 @@ static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
 static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 					    struct kvm_debugregs *dbgregs)
 {
+	unsigned int i;
+
 	if (dbgregs->flags)
 		return -EINVAL;
 
@@ -5521,7 +5529,9 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 	if (!kvm_dr7_valid(dbgregs->dr7))
 		return -EINVAL;
 
-	memcpy(vcpu->arch.db, dbgregs->db, sizeof(vcpu->arch.db));
+	for (i = 0; i < ARRAY_SIZE(vcpu->arch.db); i++)
+		vcpu->arch.db[i] = dbgregs->db[i];
+
 	kvm_update_dr0123(vcpu);
 	vcpu->arch.dr6 = dbgregs->dr6;
 	vcpu->arch.dr7 = dbgregs->dr7;
-- 
2.39.2


