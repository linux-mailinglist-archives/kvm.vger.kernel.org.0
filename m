Return-Path: <kvm+bounces-14624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F8898A4863
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 08:52:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B3A231F21867
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 06:52:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6D0D1EEE3;
	Mon, 15 Apr 2024 06:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="O5bER9uc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC7F1DA22
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 06:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713163930; cv=none; b=ToWb2JD5hQhyBqUo24+a4Z2Fd803tof6Kub7GNxrmVmasI4H9hku1ACcg1DyxKowDBwBy3dT2Vm5kW6kLyiSi9GjR8CXjp2zuUlVGrYVwNsUI51tE/Gsh7RKBgMD0+wRb6ErzOSfrT4x1TrexDyzjM1R1qpYN9o8YcZDlPx4SM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713163930; c=relaxed/simple;
	bh=lj/0cNtgZ1CNx0zMt3WTFpnAIba2VtQTxqI2/GZ85Qs=;
	h=From:To:Cc:Subject:Date:Message-Id; b=FwoUKn2JeV0b9cNng4t5L0NZw1DmOwhkcove6lpbQ8vVi0a6hKmzl7R6l9tvfwFs5I9Bxdy0ldXfghYVNXV2n0s4+VXbqPux0D/a+2Fg62EQb+BdpHH+oe2o+G84oLNKyFnf59+ftUvLwXiouqAr+dxFPyNQw3G0B7qcYL/JqSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=O5bER9uc; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2a559928f46so1506484a91.0
        for <kvm@vger.kernel.org>; Sun, 14 Apr 2024 23:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1713163928; x=1713768728; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tLe6x/3HgnOIz9vWYDHuVxGuPOLGDxjBTAVY55W7ViE=;
        b=O5bER9ucXkx/SCEKHpMbBW+78OORL+BZPT1xe844X1zrJyp1UIqCpODGseEIujcN+3
         vz9hE1Win59F6PkZHW5kO22HuZOyHLkRoqlZ0V6S2uM0mAZmL4Umr4IWoio5Gy+sPCtm
         o45aYntGsl47O8IhvZmC1FPcUh8h3+An1dapXmJuvFV7pqfK5KuFm5U0Rjk8DsYKnBjx
         lKzkwR9ehpRKV2/1rmRTXrZ8dtv/SwjhMqOvylFx5B/2+KLQgqfdb1EX3o6/Pg1mcrgE
         NGKGVH83quXM9GgYOHU5+s7CFLjh4PLCMqBOr3AHWVotGS/pPZIIKDW4C09u9RKkpx9H
         I0RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713163928; x=1713768728;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tLe6x/3HgnOIz9vWYDHuVxGuPOLGDxjBTAVY55W7ViE=;
        b=v2zSmsqxZ7E6KFQHVdqgtnqPQXhCer434mpGmFSuD9no4RJFoH8P42Q+0h20VKreoO
         +/zYpsMLGh0KiclmXntCquiuUNMyxyeJhUZrHKwnaxzJgVScMW2QfZVv8zQdWEYCwKpy
         l9y/J9/vs23vumg05dBfakvaqXXDhiGl3UQ4IemdsureWdWjp29UZiFl30XUb/iHKWlW
         7cElVSTR9hcSMWmSLajb7QKpV4MSOmE0tgagmzoTl4W64I7RXoAi7hGOtMskJQ4UmL0w
         tWB8TqGKAl0gBUauADbsNJSkKCKqo6wasC8kOt9a8VW1kZMOXPkk/gD2IXoTroFEaG6y
         B2kw==
X-Gm-Message-State: AOJu0YxeZcoSnMF0SIfXRwsb6iQyH71RSKDmZOYUPS3FrA5gjG7O9K9H
	xfcxd2LLzgsgaT7WLz9WlWbcWhwNJ+Enl+6XRJWYkt965N7F2xatG9VWLUI7bsRd9gkH8RT5G/5
	ZJubIS5iQPVWFnJeKx0uy2sRT6llUNWI3ckGn4q2s1tPulZykv39hWQE+c4BvQDOn3GjivIzprw
	k4CoHTRdY7MwU/KGIpjFxpZ3RRttmBPNXs8J1In34nBw==
X-Google-Smtp-Source: AGHT+IH0KYzqp/vp9mDREQ6B6u7EJGhdtzQQgautIE1LqioBWHHLnO7vWceVMCsNCKGxwiaViqHAiQ==
X-Received: by 2002:a17:90a:51c1:b0:2a7:82a8:2ae1 with SMTP id u59-20020a17090a51c100b002a782a82ae1mr4174168pjh.45.1713163927690;
        Sun, 14 Apr 2024 23:52:07 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id 42-20020a17090a09ad00b002a2a3aebb38sm7127352pjo.48.2024.04.14.23.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Apr 2024 23:52:07 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: kvm@vger.kernel.org
Cc: greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>
Subject: [kvmtool PATCH 1/1] riscv: Fix the hart bit setting of AIA
Date: Mon, 15 Apr 2024 14:51:56 +0800
Message-Id: <20240415065156.25391-1-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The hart bit setting is different with Linux AIA driver[1] when the number
of hart is power of 2. For example, when the guest has 4 harts, the
estimated result of AIA driver is 2, whereas we pass 3 to RISC-V/KVM. Since
only 2 bits are needed to represent 4 harts, update the formula to get the
accurate result.

[1] https://lore.kernel.org/all/20240307140307.646078-1-apatel@ventanamicro.com/

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
---
 riscv/aia.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/riscv/aia.c b/riscv/aia.c
index fe9399a8ffc1..21d9704145d0 100644
--- a/riscv/aia.c
+++ b/riscv/aia.c
@@ -164,7 +164,7 @@ static int aia__init(struct kvm *kvm)
 	ret = ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_nr_sources_attr);
 	if (ret)
 		return ret;
-	aia_hart_bits = fls_long(kvm->nrcpus);
+	aia_hart_bits = fls_long(kvm->nrcpus - 1);
 	ret = ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_hart_bits_attr);
 	if (ret)
 		return ret;
-- 
2.17.1


