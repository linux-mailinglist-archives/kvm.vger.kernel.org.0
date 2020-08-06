Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FDC23DDE3
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 19:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730101AbgHFRRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 13:17:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31251 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730440AbgHFRRG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 13:17:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596734224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gT8t13wbhbYFLFrPxxkSEHSrNjvXeJVY5ONNGfCIIHQ=;
        b=NYGfsOPAE/3+G2UZuk384ULEZGjPI3zGaYxZjoBHY3X0smipYmTsBXmP0F/APez6t7XTRo
        JN+JUzwfpNSr7EzpYxTwDVSWrwZFwYRRwtJHtWtpRqG/891pSQg9DoNIM4rpYfa/9r4i/C
        oixxw1/vQK3t2TAReFcw7ekIAiF++Us=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-Qpunr_n1O12gwAKZSOfrvw-1; Thu, 06 Aug 2020 08:44:31 -0400
X-MC-Unique: Qpunr_n1O12gwAKZSOfrvw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F346C102C88B
        for <kvm@vger.kernel.org>; Thu,  6 Aug 2020 12:44:18 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-17.ams2.redhat.com [10.36.114.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 348825F9DC;
        Thu,  6 Aug 2020 12:44:11 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Mohammed Gamal <mgamal@redhat.com>
Subject: [kvm-unit-tests PATCH 2/3] x86/access: Skip running guest physical bits tests on AMD with NPT enabled
Date:   Thu,  6 Aug 2020 14:43:57 +0200
Message-Id: <20200806124358.4928-3-mgamal@redhat.com>
In-Reply-To: <20200806124358.4928-1-mgamal@redhat.com>
References: <20200806124358.4928-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since we can't handle NPT VM exits properly. We won't run
guest physical bits tests if NPT is enabled.

Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
---
 x86/access.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/x86/access.c b/x86/access.c
index 7dc9eb6..90c5fe4 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -973,6 +973,14 @@ static int ac_test_run(void)
         invalid_mask |= AC_PTE_BIT36_MASK;
     }
 
+    if (this_cpu_has(X86_FEATURE_NPT)) {
+        printf("NPT enabled. Skipping physical bits tests\n");
+        invalid_mask |= AC_PDE_BIT51_MASK;
+        invalid_mask |= AC_PTE_BIT51_MASK;
+        invalid_mask |= AC_PDE_BIT36_MASK;
+        invalid_mask |= AC_PTE_BIT36_MASK;
+    }
+
     if (this_cpu_has(X86_FEATURE_PKU)) {
         set_cr4_pke(1);
         set_cr4_pke(0);
-- 
2.26.2

