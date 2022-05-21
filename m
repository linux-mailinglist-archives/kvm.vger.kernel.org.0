Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836D052FA05
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 10:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238298AbiEUI0N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 04:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbiEUI0J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 04:26:09 -0400
X-Greylist: delayed 478 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 21 May 2022 01:26:07 PDT
Received: from mout-u-107.mailbox.org (mout-u-107.mailbox.org [IPv6:2001:67c:2050:101:465::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC51428E3C
        for <kvm@vger.kernel.org>; Sat, 21 May 2022 01:26:06 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-u-107.mailbox.org (Postfix) with ESMTPS id 4L4xL14MQZz9sSk;
        Sat, 21 May 2022 10:18:01 +0200 (CEST)
From:   Lev Kujawski <lkujaw@member.fsf.org>
To:     kvm@vger.kernel.org
Cc:     Lev Kujawski <lkujaw@member.fsf.org>
Subject: [PATCH] KVM: set_msr_mce: Permit guests to ignore single-bit ECC errors
Date:   Sat, 21 May 2022 08:15:11 +0000
Message-Id: <20220521081511.187388-1-lkujaw@member.fsf.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Certain guest operating systems (e.g., UNIXWARE) clear bit 0 of
MC1_CTL to ignore single-bit ECC data errors.  Single-bit ECC data
errors are always correctable and thus are safe to ignore because they
are informational in nature rather than signaling a loss of data
integrity.

Prior to this patch, these guests would crash upon writing MC1_CTL,
with resultant error messages like the following:

error: kvm run failed Operation not permitted
EAX=fffffffe EBX=fffffffe ECX=00000404 EDX=ffffffff
ESI=ffffffff EDI=00000001 EBP=fffdaba4 ESP=fffdab20
EIP=c01333a5 EFL=00000246 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0108 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
CS =0100 00000000 ffffffff 00c09b00 DPL=0 CS32 [-RA]
SS =0108 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
DS =0108 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
FS =0000 00000000 ffffffff 00c00000
GS =0000 00000000 ffffffff 00c00000
LDT=0118 c1026390 00000047 00008200 DPL=0 LDT
TR =0110 ffff5af0 00000067 00008b00 DPL=0 TSS32-busy
GDT=     ffff5020 000002cf
IDT=     ffff52f0 000007ff
CR0=8001003b CR2=00000000 CR3=0100a000 CR4=00000230
DR0=00000000 DR1=00000000 DR2=00000000 DR3=00000000
DR6=ffff0ff0 DR7=00000400
EFER=0000000000000000
Code=08 89 01 89 51 04 c3 8b 4c 24 08 8b 01 8b 51 04 8b 4c 24 04 <0f>
30 c3 f7 05 a4 6d ff ff 10 00 00 00 74 03 0f 31 c3 33 c0 33 d2 c3 8d
74 26 00 0f 31 c3

Signed-off-by: Lev Kujawski <lkujaw@member.fsf.org>
---
 arch/x86/kvm/x86.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4790f0d7d40b..128dca4e7bb7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3215,10 +3215,13 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			/* only 0 or all 1s can be written to IA32_MCi_CTL
 			 * some Linux kernels though clear bit 10 in bank 4 to
 			 * workaround a BIOS/GART TBL issue on AMD K8s, ignore
-			 * this to avoid an uncatched #GP in the guest
+			 * this to avoid an uncatched #GP in the guest.
+			 *
+			 * UNIXWARE clears bit 0 of MC1_CTL to ignore
+			 * correctable, single-bit ECC data errors.
 			 */
 			if ((offset & 0x3) == 0 &&
-			    data != 0 && (data | (1 << 10)) != ~(u64)0)
+			    data != 0 && (data | (1 << 10) | 1) != ~(u64)0)
 				return -1;
 
 			/* MCi_STATUS */
-- 
2.34.1

