Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAFCA87F5C
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437120AbfHIQQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:16:07 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52910 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437093AbfHIQPD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:03 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 6E9AD3031EDB;
        Fri,  9 Aug 2019 19:01:41 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 2797E305B7A3;
        Fri,  9 Aug 2019 19:01:41 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v6 84/92] kvm: x86: enable the half part of movss, movsd, movups
Date:   Fri,  9 Aug 2019 19:00:39 +0300
Message-Id: <20190809160047.8319-85-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

A previous patch added emulation support for these instructions with a
register source and memory destination. This patch adds the variants
with a memory source and a register destination.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/emulate.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index b42a71653622..a2e5e63bd94a 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1184,6 +1184,10 @@ static u8 simd_prefix_to_bytes(const struct x86_emulate_ctxt *ctxt,
 	u8 bytes = 16;
 
 	switch (ctxt->b) {
+	case 0x10:
+		/* movss m32, xmm */
+		/* movsd m64, xmm */
+		/* movups m128, xmm */
 	case 0x11:
 		/* movss xmm, m32 */
 		/* movsd xmm, m64 */
