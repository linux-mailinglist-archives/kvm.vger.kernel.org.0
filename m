Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D1B38B26E
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 17:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242804AbhETPEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 11:04:20 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:47301 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239826AbhETPEH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 11:04:07 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id E3C0C1940A04;
        Thu, 20 May 2021 10:56:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 20 May 2021 10:56:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=2b+Iav3ZgZxI2yn9eMrphy8hZPx+8/wDXUh3tEu8dIo=; b=rnweCNcw
        clSGmKilZ/lGxJvwfzYD8vz382vYdisb8iwHNEKdU/P2lRPHm+IPEhji0MrGd7VL
        rQ+VtoDVldRvsXpvkHpNXJA99pgOEh7SHwKCtVeMCxDhyb5EmPaRqPH9oIs9gaA9
        6f5Umt7N1hKROwdPZQ6G4t79l5yC0s/h8hWRmwDx4RrTO1QOSow3mWLi/y3s6Q0O
        HjbBDUrhDmXKvpmTxnXl+clLAAla3QoESqgRmTTIGF+70dXBG7uw0wVf2l3hJIoY
        FEZAOqjyrdNfMQMgOWmmxNb0ClwCj+SvbQ0e34gLc9LD4xGBK2xATrX6+i9yOS7g
        xLsGVrRs2TWRIA==
X-ME-Sender: <xms:tXimYDFWTF3oykGfYboJ2SeA8-nqJM3HCoFRs9Ai6gi3wgcvEI2b0w>
    <xme:tXimYAXVEopPAzeeCieH9fTjCz7avH4OzelWj_k29pBGBiCopDmmIzBT8ihGMhAB6
    ArB-E1-qHYoRp9y2-k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejuddgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucfkphepkedurddukeejrddviedrvdefkeenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgv
    ughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:tXimYFKJY2P6m2DWnzA-2j2iDc5MOVkFSKmALZIhHZtpzxzS4qIRjQ>
    <xmx:tXimYBGQPLcO9ZNNl8YvzTaruIy-oSJ7ZlZLKaisMr8PJE8Yp6oIow>
    <xmx:tXimYJVhKDge1ZuxYopDt-E6MnO3ln44Wyg2AHWomOt4PTAN_nItmA>
    <xmx:tXimYOVp_ZEj_aI4pwSUn82tfTwr-CEOr_1PsjA7SMIcO4tM4x5qxQ>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Thu, 20 May 2021 10:56:52 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 0c7b4072;
        Thu, 20 May 2021 14:56:48 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Babu Moger <babu.moger@amd.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [RFC PATCH 5/7] target/i386: Introduce AMD X86XSaveArea sub-union
Date:   Thu, 20 May 2021 15:56:45 +0100
Message-Id: <20210520145647.3483809-6-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210520145647.3483809-1-david.edmondson@oracle.com>
References: <20210520145647.3483809-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD stores the pkru_state at a different offset to Intel.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 target/i386/cpu.h     | 17 +++++++++++++++--
 target/i386/kvm/kvm.c |  3 ++-
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index f1ce4e3008..99f0d5d851 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1319,7 +1319,8 @@ typedef struct XSavePKRU {
 #define XSAVE_OPMASK_OFFSET     0x440
 #define XSAVE_ZMM_HI256_OFFSET  0x480
 #define XSAVE_HI16_ZMM_OFFSET   0x680
-#define XSAVE_PKRU_OFFSET       0xa80
+#define XSAVE_INTEL_PKRU_OFFSET 0xa80
+#define XSAVE_AMD_PKRU_OFFSET   0x980
 
 typedef struct X86XSaveArea {
     X86LegacyXSaveArea legacy;
@@ -1348,6 +1349,16 @@ typedef struct X86XSaveArea {
             /* PKRU State: */
             XSavePKRU pkru_state;
         } intel;
+        struct {
+            /* Ensure that XSavePKRU is properly aligned. */
+            uint8_t padding[XSAVE_AMD_PKRU_OFFSET
+                            - sizeof(X86LegacyXSaveArea)
+                            - sizeof(X86XSaveHeader)
+                            - sizeof(XSaveAVX)];
+
+            /* PKRU State: */
+            XSavePKRU pkru_state;
+        } amd;
     };
 } X86XSaveArea;
 
@@ -1370,7 +1381,9 @@ QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, intel.hi16_zmm_state)
                   != XSAVE_HI16_ZMM_OFFSET);
 QEMU_BUILD_BUG_ON(sizeof(XSaveHi16_ZMM) != 0x400);
 QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, intel.pkru_state)
-                  != XSAVE_PKRU_OFFSET);
+                  != XSAVE_INTEL_PKRU_OFFSET);
+QEMU_BUILD_BUG_ON(offsetof(X86XSaveArea, amd.pkru_state)
+                  != XSAVE_AMD_PKRU_OFFSET);
 QEMU_BUILD_BUG_ON(sizeof(XSavePKRU) != 0x8);
 
 typedef enum TPRAccess {
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 417776a635..9dd7db060d 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2414,7 +2414,8 @@ ASSERT_OFFSET(XSAVE_BNDCSR_OFFSET, intel.bndcsr_state);
 ASSERT_OFFSET(XSAVE_OPMASK_OFFSET, intel.opmask_state);
 ASSERT_OFFSET(XSAVE_ZMM_HI256_OFFSET, intel.zmm_hi256_state);
 ASSERT_OFFSET(XSAVE_HI16_ZMM_OFFSET, intel.hi16_zmm_state);
-ASSERT_OFFSET(XSAVE_PKRU_OFFSET, intel.pkru_state);
+ASSERT_OFFSET(XSAVE_INTEL_PKRU_OFFSET, intel.pkru_state);
+ASSERT_OFFSET(XSAVE_AMD_PKRU_OFFSET, amd.pkru_state);
 
 static int kvm_put_xsave(X86CPU *cpu)
 {
-- 
2.30.2

