Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3823667C26F
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 02:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236310AbjAZBfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 20:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236182AbjAZBfC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 20:35:02 -0500
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED0F41B47
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 17:34:59 -0800 (PST)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pKrAG-003VAe-Nd; Thu, 26 Jan 2023 02:34:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=JhLJBlabJ3ThCuruapRDG8mUyKrEjivTaeKvk3LPhds=; b=eTcji/BmKaS3MUTX3TX7z+ml/x
        EvggncK9b08eGBhfrEyGb0Opb6bUJWePodNEFphizCvc3sNszMeACfHrUE6EHuiev4oEvlKrquLN/
        F2N7aNfqUdLLxyL0EUlW0qSCudMc3i5h0dBwOEbFvik1NYH0ZSm5NqQJh61CZJ3tYDgJ250a3kEDT
        RhzD+96l5zN6OjXNsh2oKAxidoSCiAZ9ZReRbw8a/8PI5R0pxi9vH9mFOeauD1w8IlNrSiQJLDI5u
        G4m0CkTQyybC6sEm49xjry5aeNs/z/LTnkfV81Cn1dp7NMYa48BYvkkLGj1ZytFuoGHYFmPEoLL/3
        M3XlurvA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pKrAF-0004k1-MH; Thu, 26 Jan 2023 02:34:55 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pKrA7-00010H-6o; Thu, 26 Jan 2023 02:34:47 +0100
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 1/3] KVM: x86/emulator: Fix segment load privilege level validation
Date:   Thu, 26 Jan 2023 02:34:03 +0100
Message-Id: <20230126013405.2967156-2-mhal@rbox.co>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230126013405.2967156-1-mhal@rbox.co>
References: <20230126013405.2967156-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel SDM describes what steps are taken by the CPU to verify if a
memory segment can actually be used at a given privilege level. Loading
DS/ES/FS/GS involves checking segment's type as well as making sure that
neither selector's RPL nor caller's CPL are greater than segment's DPL.

Emulator implements Intel's pseudocode in __load_segment_descriptor(),
even quoting the pseudocode in the comments. Although the pseudocode is
correctly translated, the implementation is incorrect. This is most
likely due to SDM, at the time, being wrong.

Patch fixes emulator's logic and updates the pseudocode in the comment.
Below are historical notes.

Emulator code for handling segment descriptors appears to have been
introduced in March 2010 in commit 38ba30ba51a0 ("KVM: x86 emulator:
Emulate task switch in emulator.c"). Intel SDM Vol 2A: Instruction Set
Reference, A-M (Order Number: 253666-034US, _March 2010_) lists the
steps for loading segment registers in section related to MOV
instruction:

  IF DS, ES, FS, or GS is loaded with non-NULL selector
  THEN
    IF segment selector index is outside descriptor table limits
    or segment is not a data or readable code segment
    or ((segment is a data or nonconforming code segment)
    and (both RPL and CPL > DPL))   <---
      THEN #GP(selector); FI;

This is precisely what __load_segment_descriptor() quotes and
implements. But there's a twist; a few SDM revisions later
(253667-044US), in August 2012, the snippet above becomes:

  IF DS, ES, FS, or GS is loaded with non-NULL selector
  THEN
    IF segment selector index is outside descriptor table limits
    or segment is not a data or readable code segment
    or ((segment is a data or nonconforming code segment)
      [note: missing or superfluous parenthesis?]
    or ((RPL > DPL) and (CPL > DPL))   <---
      THEN #GP(selector); FI;

Many SDMs later (253667-065US), in December 2017, pseudocode reaches
what seems to be its final form:

  IF DS, ES, FS, or GS is loaded with non-NULL selector
  THEN
    IF segment selector index is outside descriptor table limits
    OR segment is not a data or readable code segment
    OR ((segment is a data or nonconforming code segment)
        AND ((RPL > DPL) or (CPL > DPL)))   <---
      THEN #GP(selector); FI;

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/emulate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 5cc3efa0e21c..81b8f5dcfa44 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1695,11 +1695,11 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 		/*
 		 * segment is not a data or readable code segment or
 		 * ((segment is a data or nonconforming code segment)
-		 * and (both RPL and CPL > DPL))
+		 * and ((RPL > DPL) or (CPL > DPL)))
 		 */
 		if ((seg_desc.type & 0xa) == 0x8 ||
 		    (((seg_desc.type & 0xc) != 0xc) &&
-		     (rpl > dpl && cpl > dpl)))
+		     (rpl > dpl || cpl > dpl)))
 			goto exception;
 		break;
 	}
-- 
2.39.0

