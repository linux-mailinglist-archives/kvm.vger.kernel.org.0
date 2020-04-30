Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700961BF03C
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 08:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgD3G14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 02:27:56 -0400
Received: from condef-03.nifty.com ([202.248.20.68]:17993 "EHLO
        condef-03.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgD3G1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 02:27:55 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Apr 2020 02:27:54 EDT
Received: from conuserg-08.nifty.com ([10.126.8.71])by condef-03.nifty.com with ESMTP id 03U6J5Dw019414
        for <kvm@vger.kernel.org>; Thu, 30 Apr 2020 15:19:05 +0900
Received: from oscar.flets-west.jp (softbank126090202047.bbtec.net [126.90.202.47]) (authenticated)
        by conuserg-08.nifty.com with ESMTP id 03U6IlOK012831;
        Thu, 30 Apr 2020 15:18:48 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-08.nifty.com 03U6IlOK012831
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1588227528;
        bh=gaD1VqtiOrhems+zmteSxRH2XxSbswTqIOlpgqqgfXA=;
        h=From:To:Cc:Subject:Date:From;
        b=Thp0FZMEoh6/gGu5f+Rmp8AffXtOAhetOAihhiUIZDUimPVx1rWZ9UuAcKtTnK5Xj
         pbBWnEjDmXAB307CAnwVmX+vu06+lTjhyEJJBFGwV/BmVCBNukotf3t/EUdYgwV5XM
         XlIDW4VrB7Qku5syENHYemd8qQXEQ74A8Lyhr0qJAB27y8YCc/HPo2nbA2X3axzazE
         Jibv9kL+s5513RfohHRDZwdzNcJfsnw5OXjErVCOLtkEuFI/rfSHk1in7S4ZjYflg8
         XlptkZywIj3vwNqxLwDZBYFmVktjQom0mucSuPr0/WMHwxxD2FSsLxFecqP8n9HxPP
         mr6QLBmIv8egg==
X-Nifty-SrcIP: [126.90.202.47]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     linux-kbuild@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH] kconfig: announce removal of 'kvmconfig' and 'xenconfig' shorthands
Date:   Thu, 30 Apr 2020 15:18:45 +0900
Message-Id: <20200430061845.775144-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvmconfig' is a shorthand for kvm_guest.config to save 7 character typing.

xenconfig' is a shorthand for xen.config to save 1 character typing.

There is nothing more than that.

There are more files in kernel/configs/, so it is not maintainable
to wire-up every config fragment to the Kconfig Makefile. Hence,
we should not do this at all.

These will be removed after Linux 5.10. Meanwhile, the following
warning message will be displayed if they are used.

WARNING: 'make kvmconfig' will be removed after Linux 5.10
         Please use 'make kvm_guest.config' instead.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 scripts/kconfig/Makefile | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 1015abec9e58..30c69e83652b 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -96,11 +96,13 @@ configfiles=$(wildcard $(srctree)/kernel/configs/$@ $(srctree)/arch/$(SRCARCH)/c
 
 PHONY += kvmconfig
 kvmconfig: kvm_guest.config
-	@:
+	@echo >&2 "WARNING: 'make $@' will be removed after Linux 5.10"
+	@echo >&2 "         Please use 'make $<' instead."
 
 PHONY += xenconfig
 xenconfig: xen.config
-	@:
+	@echo >&2 "WARNING: 'make $@' will be removed after Linux 5.10"
+	@echo >&2 "         Please use 'make $<' instead."
 
 PHONY += tinyconfig
 tinyconfig:
@@ -137,9 +139,6 @@ help:
 	@echo  '  helpnewconfig   - List new options and help text'
 	@echo  '  olddefconfig	  - Same as oldconfig but sets new symbols to their'
 	@echo  '                    default value without prompting'
-	@echo  '  kvmconfig	  - Enable additional options for kvm guest kernel support'
-	@echo  '  xenconfig       - Enable additional options for xen dom0 and guest kernel'
-	@echo  '                    support'
 	@echo  '  tinyconfig	  - Configure the tiniest possible kernel'
 	@echo  '  testconfig	  - Run Kconfig unit tests (requires python3 and pytest)'
 
-- 
2.25.1

