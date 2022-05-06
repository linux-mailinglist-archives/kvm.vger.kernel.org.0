Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904A251E081
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 22:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444289AbiEFVA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 17:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444275AbiEFVAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 17:00:52 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D98556A068
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 13:57:08 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94C8A14BF;
        Fri,  6 May 2022 13:57:08 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD6A13F800;
        Fri,  6 May 2022 13:57:07 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     drjones@redhat.com, pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH v2 14/23] lib: Avoid ms_abi for calls related to EFI on arm64
Date:   Fri,  6 May 2022 21:55:56 +0100
Message-Id: <20220506205605.359830-15-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220506205605.359830-1-nikos.nikoleris@arm.com>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

x86_64 requires that EFI calls use the ms_abi calling convention. For
arm64 this is unnecessary.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/linux/efi.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/linux/efi.h b/lib/linux/efi.h
index e3aba1d..594eaca 100644
--- a/lib/linux/efi.h
+++ b/lib/linux/efi.h
@@ -33,7 +33,11 @@ typedef u16 efi_char16_t;		/* UNICODE character */
 typedef u64 efi_physical_addr_t;
 typedef void *efi_handle_t;
 
+#ifdef __x86_64__
 #define __efiapi __attribute__((ms_abi))
+#else
+#define __efiapi
+#endif
 
 /*
  * The UEFI spec and EDK2 reference implementation both define EFI_GUID as
-- 
2.25.1

