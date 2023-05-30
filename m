Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983B47168DB
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 18:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbjE3QLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 12:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233330AbjE3QLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 12:11:13 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9DCA3184
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 09:10:47 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A9D311BA8;
        Tue, 30 May 2023 09:11:03 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 458763F663;
        Tue, 30 May 2023 09:10:17 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com,
        shahuang@redhat.com, Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v6 21/32] lib: Avoid ms_abi for calls related to EFI on arm64
Date:   Tue, 30 May 2023 17:09:13 +0100
Message-Id: <20230530160924.82158-22-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230530160924.82158-1-nikos.nikoleris@arm.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

x86_64 requires that EFI calls use the ms_abi calling convention. For
arm64 this is unnecessary.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 lib/linux/efi.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/linux/efi.h b/lib/linux/efi.h
index bb6d5a85..1d34c9a0 100644
--- a/lib/linux/efi.h
+++ b/lib/linux/efi.h
@@ -34,7 +34,11 @@ typedef u16 efi_char16_t;		/* UNICODE character */
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

