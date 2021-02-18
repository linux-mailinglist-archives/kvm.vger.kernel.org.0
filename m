Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1350431EC12
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 17:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbhBRQMd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 11:12:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46978 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233534AbhBRN24 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 08:28:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613654812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bhnfXN4CfJadCOJu0k85BVIxh2VnYixTtm/U1XJMPFM=;
        b=eA3rwuv10bZjOZOEE49k2xKfnGb0/oe8kBcyB2SxbNBjQVSuTlwJXG17f2VbsnGeEIoe/e
        r50x/hIVzmiOCs43EGBoWqC2/CJ62A+MHaFbMZPxMWtvCG8U2IH1UTSjMnlkEBxU6GeOvw
        QCRY/HKi76x1+qJki6QDuEG7gErITWw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-xfRKVqxvNEqUUb6rTXPIFg-1; Thu, 18 Feb 2021 08:26:50 -0500
X-MC-Unique: xfRKVqxvNEqUUb6rTXPIFg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE60710066F0
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 13:26:49 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B17C0614F0
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 13:26:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] x86: clean up EFER definitions
Date:   Thu, 18 Feb 2021 08:26:48 -0500
Message-Id: <20210218132648.1397421-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The X86_EFER_LMA definition is wrong, while X86_IA32_EFER is unused.
There are also two useless WRMSRs that try to set EFER_LMA in
x86/pks.c and x86/pku.c.  Clean them all up.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/x86/processor.h | 2 --
 x86/pks.c           | 1 -
 x86/pku.c           | 1 -
 3 files changed, 4 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 9f85fd2..dda57a1 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -72,8 +72,6 @@
 #define X86_EFLAGS_ALU (X86_EFLAGS_CF | X86_EFLAGS_PF | X86_EFLAGS_AF | \
 			X86_EFLAGS_ZF | X86_EFLAGS_SF | X86_EFLAGS_OF)
 
-#define X86_IA32_EFER          0xc0000080
-#define X86_EFER_LMA           (1UL << 8)
 
 /*
  * CPU features
diff --git a/x86/pks.c b/x86/pks.c
index a506622..ef95fb9 100644
--- a/x86/pks.c
+++ b/x86/pks.c
@@ -77,7 +77,6 @@ int main(int ac, char **av)
     setup_vm();
     setup_alt_stack();
     set_intr_alt_stack(14, pf_tss);
-    wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_LMA);
 
     if (reserve_pages(SUPER_BASE, SUPER_BASE >> 12))
         report_abort("Could not reserve memory");
diff --git a/x86/pku.c b/x86/pku.c
index 7e8247c..51ff412 100644
--- a/x86/pku.c
+++ b/x86/pku.c
@@ -76,7 +76,6 @@ int main(int ac, char **av)
     setup_vm();
     setup_alt_stack();
     set_intr_alt_stack(14, pf_tss);
-    wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_LMA);
 
     if (reserve_pages(USER_BASE, USER_BASE >> 12))
         report_abort("Could not reserve memory");
-- 
2.26.2

