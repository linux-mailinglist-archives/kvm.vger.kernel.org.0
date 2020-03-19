Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB0AD18AFC6
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 10:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbgCSJO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 05:14:26 -0400
Received: from 8bytes.org ([81.169.241.247]:51930 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727216AbgCSJOZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 05:14:25 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id A25C528B; Thu, 19 Mar 2020 10:14:17 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 10/70] x86/boot/compressed: Fix debug_puthex() parameter type
Date:   Thu, 19 Mar 2020 10:13:07 +0100
Message-Id: <20200319091407.1481-11-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319091407.1481-1-joro@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

In the CONFIG_X86_VERBOSE_BOOTUP=Y case the debug_puthex() macro just
turns into __puthex, which takes 'unsigned long' as parameter. But in
the CONFIG_X86_VERBOSE_BOOTUP=N case it is a function which takes
'unsigned char *', causing compile warnings when the function is used.
Fix the parameter type to get rid of the warnings.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/misc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index c8181392f70d..726e264410ff 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -59,7 +59,7 @@ void __puthex(unsigned long value);
 
 static inline void debug_putstr(const char *s)
 { }
-static inline void debug_puthex(const char *s)
+static inline void debug_puthex(unsigned long value)
 { }
 #define debug_putaddr(x) /* */
 
-- 
2.17.1

