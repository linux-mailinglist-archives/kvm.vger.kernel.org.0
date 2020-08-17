Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F8F245B40
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 05:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgHQDuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Aug 2020 23:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727813AbgHQDt7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Aug 2020 23:49:59 -0400
Received: from vultr.net.flygoat.com (vultr.net.flygoat.com [IPv6:2001:19f0:6001:3633:5400:2ff:fe8c:553])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31213C061345;
        Sun, 16 Aug 2020 20:49:59 -0700 (PDT)
Received: from localhost.localdomain (unknown [IPv6:2001:da8:20f:4430:250:56ff:fe9a:7470])
        by vultr.net.flygoat.com (Postfix) with ESMTPSA id 3D253200D1;
        Mon, 17 Aug 2020 03:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com; s=vultr;
        t=1597636198; bh=kL2YUnCYl8qwBpA6tmpQUNRMhCovsao/yjQt7sCo0Bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3yc9obazAd+ebc31MIheSBo1LGXzc2+BKtmErfwYN0nOQcBzgiqjToLCjPtMBla5
         XLW5DctmBESfPdkcLgW9zf61XDVzByrtDNg1OLOwyTXOtkyfsBpVp4ADs6G2PkPA5R
         4sTtWQsiHGEiZUY575dw0j5IXTHocCOTdN55ROmXU3dyfMmo5kr26TvOf3lfhPLIka
         bWAH/Yhte3hphyj3IgKBXYXDcVsNm6Bs0ce8lR46GGqw43a9jTtp9Kme2mU2Ds6snq
         k6tau/J34MKdQT+8Ou59wP0+2LOdKrV7lHRN+dzZABA/ooP+sQDozNm1kWFrT4UYFy
         eQ/5qA7R6GUvA==
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     linux-mips@vger.kernel.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Burton <paulburton@kernel.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        WANG Xuerui <git@xen0n.name>,
        =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>,
        Liangliang Huang <huanglllzu@gmail.com>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Xu <peterx@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sergey Korolev <s.korolev@ndmsystems.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Anup Patel <anup.patel@wdc.com>, Marc Zyngier <maz@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Steven Price <steven.price@arm.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Mike Leach <mike.leach@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Atish Patra <atish.patra@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 7/7] MIPS: KVM: Don't use htimer when INTIMER is disabled
Date:   Mon, 17 Aug 2020 11:46:46 +0800
Message-Id: <20200817034701.3515721-8-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.28.0.rc1
In-Reply-To: <20200817034701.3515721-1-jiaxun.yang@flygoat.com>
References: <20200817034701.3515721-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When INTIMER is disabled by host, the GT compare interrupt
will be ignored.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/kvm/vz.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index 9d03bd0a604a..1d2140f7461a 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -341,6 +341,12 @@ static bool kvm_vz_should_use_htimer(struct kvm_vcpu *vcpu)
 	if (kvm_mips_count_disabled(vcpu))
 		return false;
 
+	if (cpu_has_extimer) {
+		/* Guest htimer compare interrupt will be ignored if INTIMER is disabled */
+		if (!(read_c0_config6() & LOONGSON_CONF6_INTIMER))
+			return false;
+	}
+
 	/* Chosen frequency must match real frequency */
 	if (mips_hpt_frequency != vcpu->arch.count_hz)
 		return false;
-- 
2.28.0.rc1

