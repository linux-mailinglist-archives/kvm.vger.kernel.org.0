Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71E5456C6AA
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 06:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiGIEVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 00:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiGIEVX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 00:21:23 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784EF4E861;
        Fri,  8 Jul 2022 21:21:22 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id z12-20020a17090a7b8c00b001ef84000b8bso3697633pjc.1;
        Fri, 08 Jul 2022 21:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7862CG8gdBkkTAJc3wwQbEUsLZoydkrGNeAOeSolID4=;
        b=WYW4ChbpsRxZ1gJaxSIztXNft5qthK/2PeMQCA9WXhq4+rRV2J4W1LcAEdYKzA3XLa
         SIkvqry5SrQFEZCGaE7PZvtf4cnGRMqfjmeMxEVS2Lhr5Y+qKvdZISBgh81rs7UgJya9
         SjP39SvaBQ741WGaKGKqTVbMmFpmJVuQqVatEEWFHPkQmB/itDoH9tAFVimcIludyvXA
         hxSqt5YCWJs3KtSjkHa/ZAu1V/ehd+qMWd+ucNdYwse0cuqGAsFhWvVra+tXOWrCEbt1
         Tb97dcfZLxhaHMVgteSLnL+tmKsiOoQzS10NO2vCtZP9Yej1H0BRE0FDJzSDhTRsCWf6
         mT6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7862CG8gdBkkTAJc3wwQbEUsLZoydkrGNeAOeSolID4=;
        b=dl3sGte9tSZrD4jGHFbE2roRrAwOgwo4RIIF9WXFpQ6TQfS12aY5oJrqrQa0Mia5MO
         ovT9/+13d9NMFhuNOUS32mrSB9EeM2hhRMqZSSiI1fDTS1D6r/Vwdl1pBierMNGt5Vyd
         2o/wLKc6228psiQUDywMWAbz2zFlfnBtibiqrH1Tf8qU0n6XiUuOJ4CgFGD3nkKP8y3f
         uMIyb0vYR4lrlxeyavUgXWnfU2PhZclQjIYiEbYQtdMU0qNfTrv/mifljpCuyUhoCPCq
         kEK+UzncRvFSKfA4VVxxlHVT601zMvwtpm7BTFu6zk2R/+CZVw+JGXDjZ5cs7u2N3UK8
         VvHQ==
X-Gm-Message-State: AJIora/ZeeEPyfuRRbpDEvPrfYuDs15Y7bv9WDYVIhK2Atqv7qFQPCNq
        8ckPQXZ/xvisCaC8HdmPL98=
X-Google-Smtp-Source: AGRyM1teRY0eMw7nwfVY9ar4a4cuXuk75JgTUr6H7bdIBeFb3SwU/a+Dpz1Q3Dg8E5U2dOvdY2szTg==
X-Received: by 2002:a17:903:41d2:b0:16a:2cca:4869 with SMTP id u18-20020a17090341d200b0016a2cca4869mr7057894ple.13.1657340481995;
        Fri, 08 Jul 2022 21:21:21 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-88.three.co.id. [180.214.232.88])
        by smtp.gmail.com with ESMTPSA id n17-20020a170902d2d100b0016c23c2c98dsm318286plc.246.2022.07.08.21.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 21:21:21 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id E05EB1039C8; Sat,  9 Jul 2022 11:21:11 +0700 (WIB)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 11/12] Documentation: x86: Use literal code block for TDX dmesg output
Date:   Sat,  9 Jul 2022 11:20:37 +0700
Message-Id: <20220709042037.21903-12-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220709042037.21903-1-bagasdotme@gmail.com>
References: <20220709042037.21903-1-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The dmesg output blocks are using line blocks, which is incorrect, since
this will render the blocks as normal paragraph with preserved line
breaks instead of code blocks.

Use literal code blocks instead for the output.

Fixes: f05f595045dfc7 ("Documentation/x86: Add documentation for TDX host support")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/x86/tdx.rst | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/Documentation/x86/tdx.rst b/Documentation/x86/tdx.rst
index 4430912a2e4f05..f5bd22b89159ec 100644
--- a/Documentation/x86/tdx.rst
+++ b/Documentation/x86/tdx.rst
@@ -41,11 +41,11 @@ TDX boot-time detection
 -----------------------
 
 Kernel detects TDX and the TDX private KeyIDs during kernel boot.  User
-can see below dmesg if TDX is enabled by BIOS:
+can see below dmesg if TDX is enabled by BIOS::
 
-|  [..] tdx: SEAMRR enabled.
-|  [..] tdx: TDX private KeyID range: [16, 64).
-|  [..] tdx: TDX enabled by BIOS.
+   [..] tdx: SEAMRR enabled.
+   [..] tdx: TDX private KeyID range: [16, 64).
+   [..] tdx: TDX enabled by BIOS.
 
 TDX module detection and initialization
 ---------------------------------------
@@ -79,20 +79,20 @@ caller.
 User can consult dmesg to see the presence of the TDX module, and whether
 it has been initialized.
 
-If the TDX module is not loaded, dmesg shows below:
+If the TDX module is not loaded, dmesg shows below::
 
-|  [..] tdx: TDX module is not loaded.
+   [..] tdx: TDX module is not loaded.
 
 If the TDX module is initialized successfully, dmesg shows something
-like below:
+like below::
 
-|  [..] tdx: TDX module: vendor_id 0x8086, major_version 1, minor_version 0, build_date 20211209, build_num 160
-|  [..] tdx: 65667 pages allocated for PAMT.
-|  [..] tdx: TDX module initialized.
+   [..] tdx: TDX module: vendor_id 0x8086, major_version 1, minor_version 0, build_date 20211209, build_num 160
+   [..] tdx: 65667 pages allocated for PAMT.
+   [..] tdx: TDX module initialized.
 
-If the TDX module failed to initialize, dmesg shows below:
+If the TDX module failed to initialize, dmesg shows below::
 
-|  [..] tdx: Failed to initialize TDX module.  Shut it down.
+   [..] tdx: Failed to initialize TDX module.  Shut it down.
 
 TDX Interaction to Other Kernel Components
 ------------------------------------------
@@ -143,10 +143,10 @@ There are basically two memory hot-add cases that need to be prevented:
 ACPI memory hot-add and driver managed memory hot-add.  The kernel
 rejectes the driver managed memory hot-add too when TDX is enabled by
 BIOS.  For instance, dmesg shows below error when using kmem driver to
-add a legacy PMEM as system RAM:
+add a legacy PMEM as system RAM::
 
-|  [..] tdx: Unable to add memory [0x580000000, 0x600000000) on TDX enabled platform.
-|  [..] kmem dax0.0: mapping0: 0x580000000-0x5ffffffff memory add failed
+   [..] tdx: Unable to add memory [0x580000000, 0x600000000) on TDX enabled platform.
+   [..] kmem dax0.0: mapping0: 0x580000000-0x5ffffffff memory add failed
 
 However, adding new memory to ZONE_DEVICE should not be prevented as
 those pages are not managed by the page allocator.  Therefore,
-- 
An old man doll... just what I always wanted! - Clara

