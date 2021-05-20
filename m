Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B2738B26B
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 17:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240781AbhETPEI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 11:04:08 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:37225 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231470AbhETPEE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 11:04:04 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 65AE119409FB;
        Thu, 20 May 2021 10:56:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 20 May 2021 10:56:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=DDI408hEzIsKkkLSrWxdgVh7cxIzItBOhihRC+7ELzw=; b=mI09N+Uq
        0NeWaQRtDFdPgYpD1WJvHI/QLeHD/rdMw3J/Z1qdr3SY8sy7QfMI4S4tLcHPlFkf
        vbJl7mpT3z/rK2UXoMWyIdoykc1V15GGQb91MMsDa5hNuFUeCy0Qj+RidSGztanj
        YXhyi5U6cXxHSge51ECE6WcUvDmEUhofiQ3A4+dCBHl9xgW4Ya75taqhXZAJ0sKy
        eypTF1q/CrwDhr3VBCG4/F0Vtk/3s7q69po3tVAN0Fx4hYyYreFdst7inN4OYsWZ
        b9SrhCNFJrbEqW3iJCYtXVJHdZtrFO54LRBL2H03nNW3lL4EcnTUT4Y7SioyzP72
        OKnmc78/m5E8Jw==
X-ME-Sender: <xms:tHimYI2pD7K0I2geEIRd9ujc4Cv5fDvvpT2D-d1vu6S69rpHTVF5VQ>
    <xme:tHimYDH78b5cdlu2dCpxdGDAMmEkinacBbvxFYV4nn-b-DeCVM3Ciev9AgSB1DQzU
    GbbH5p9wzreSWTVrn8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejuddgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucfkphepkedurddukeejrddviedrvdefkeenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgv
    ughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:tHimYA5SQrsPmqFvhfPrAS61E_hXyvKhxElNA4NGTOx2lYTtDP9giw>
    <xmx:tHimYB3wwF5oZO3M1eQixdO-SC4qpberzWqf8VDZzqS_VMgVj0cPtw>
    <xmx:tHimYLEO4GxrAA9K4flF-j1Gzd2tttCtF4Av_pZcVZfiE1FmOhjOyg>
    <xmx:tHimYLEJSzGWh7NdW3ZeGaRKwRvpfJixUUMs_DFReWc7MvSkf0-zJQ>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Thu, 20 May 2021 10:56:51 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 03d9d232;
        Thu, 20 May 2021 14:56:47 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Babu Moger <babu.moger@amd.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [RFC PATCH 2/7] target/i386: Use constants for XSAVE offsets
Date:   Thu, 20 May 2021 15:56:42 +0100
Message-Id: <20210520145647.3483809-3-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210520145647.3483809-1-david.edmondson@oracle.com>
References: <20210520145647.3483809-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Where existing constants for XSAVE offsets exists, use them.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 target/i386/kvm/kvm.c | 56 ++++++++++++++-----------------------------
 1 file changed, 18 insertions(+), 38 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index d972eb4705..aff0774fef 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2397,44 +2397,24 @@ static int kvm_put_fpu(X86CPU *cpu)
     return kvm_vcpu_ioctl(CPU(cpu), KVM_SET_FPU, &fpu);
 }
 
-#define XSAVE_FCW_FSW     0
-#define XSAVE_FTW_FOP     1
-#define XSAVE_CWD_RIP     2
-#define XSAVE_CWD_RDP     4
-#define XSAVE_MXCSR       6
-#define XSAVE_ST_SPACE    8
-#define XSAVE_XMM_SPACE   40
-#define XSAVE_XSTATE_BV   128
-#define XSAVE_YMMH_SPACE  144
-#define XSAVE_BNDREGS     240
-#define XSAVE_BNDCSR      256
-#define XSAVE_OPMASK      272
-#define XSAVE_ZMM_Hi256   288
-#define XSAVE_Hi16_ZMM    416
-#define XSAVE_PKRU        672
-
-#define XSAVE_BYTE_OFFSET(word_offset) \
-    ((word_offset) * sizeof_field(struct kvm_xsave, region[0]))
-
-#define ASSERT_OFFSET(word_offset, field) \
-    QEMU_BUILD_BUG_ON(XSAVE_BYTE_OFFSET(word_offset) != \
-                      offsetof(X86XSaveArea, field))
-
-ASSERT_OFFSET(XSAVE_FCW_FSW, legacy.fcw);
-ASSERT_OFFSET(XSAVE_FTW_FOP, legacy.ftw);
-ASSERT_OFFSET(XSAVE_CWD_RIP, legacy.fpip);
-ASSERT_OFFSET(XSAVE_CWD_RDP, legacy.fpdp);
-ASSERT_OFFSET(XSAVE_MXCSR, legacy.mxcsr);
-ASSERT_OFFSET(XSAVE_ST_SPACE, legacy.fpregs);
-ASSERT_OFFSET(XSAVE_XMM_SPACE, legacy.xmm_regs);
-ASSERT_OFFSET(XSAVE_XSTATE_BV, header.xstate_bv);
-ASSERT_OFFSET(XSAVE_YMMH_SPACE, avx_state);
-ASSERT_OFFSET(XSAVE_BNDREGS, bndreg_state);
-ASSERT_OFFSET(XSAVE_BNDCSR, bndcsr_state);
-ASSERT_OFFSET(XSAVE_OPMASK, opmask_state);
-ASSERT_OFFSET(XSAVE_ZMM_Hi256, zmm_hi256_state);
-ASSERT_OFFSET(XSAVE_Hi16_ZMM, hi16_zmm_state);
-ASSERT_OFFSET(XSAVE_PKRU, pkru_state);
+#define ASSERT_OFFSET(offset, field) \
+    QEMU_BUILD_BUG_ON(offset != offsetof(X86XSaveArea, field))
+
+ASSERT_OFFSET(XSAVE_FCW_FSW_OFFSET, legacy.fcw);
+ASSERT_OFFSET(XSAVE_FTW_FOP_OFFSET, legacy.ftw);
+ASSERT_OFFSET(XSAVE_CWD_RIP_OFFSET, legacy.fpip);
+ASSERT_OFFSET(XSAVE_CWD_RDP_OFFSET, legacy.fpdp);
+ASSERT_OFFSET(XSAVE_MXCSR_OFFSET, legacy.mxcsr);
+ASSERT_OFFSET(XSAVE_ST_SPACE_OFFSET, legacy.fpregs);
+ASSERT_OFFSET(XSAVE_XMM_SPACE_OFFSET, legacy.xmm_regs);
+ASSERT_OFFSET(XSAVE_XSTATE_BV_OFFSET, header.xstate_bv);
+ASSERT_OFFSET(XSAVE_AVX_OFFSET, avx_state);
+ASSERT_OFFSET(XSAVE_BNDREG_OFFSET, bndreg_state);
+ASSERT_OFFSET(XSAVE_BNDCSR_OFFSET, bndcsr_state);
+ASSERT_OFFSET(XSAVE_OPMASK_OFFSET, opmask_state);
+ASSERT_OFFSET(XSAVE_ZMM_HI256_OFFSET, zmm_hi256_state);
+ASSERT_OFFSET(XSAVE_HI16_ZMM_OFFSET, hi16_zmm_state);
+ASSERT_OFFSET(XSAVE_PKRU_OFFSET, pkru_state);
 
 static int kvm_put_xsave(X86CPU *cpu)
 {
-- 
2.30.2

