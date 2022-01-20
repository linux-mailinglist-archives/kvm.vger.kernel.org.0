Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0202E494A4F
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 10:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239291AbiATJFW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 04:05:22 -0500
Received: from mx.uniclinxens.com ([220.194.70.58]:39492 "EHLO
        spam.unicloud.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358598AbiATJFS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 04:05:18 -0500
X-Greylist: delayed 1042 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Jan 2022 04:05:18 EST
Received: from spam.unicloud.com (localhost [127.0.0.2] (may be forged))
        by spam.unicloud.com with ESMTP id 20K8lvN3061950
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 16:47:57 +0800 (GMT-8)
        (envelope-from luofei@unicloud.com)
Received: from eage.unicloud.com ([220.194.70.35])
        by spam.unicloud.com with ESMTP id 20K8l7Jo061588;
        Thu, 20 Jan 2022 16:47:07 +0800 (GMT-8)
        (envelope-from luofei@unicloud.com)
Received: from localhost.localdomain (10.10.1.7) by zgys-ex-mb09.Unicloud.com
 (10.10.0.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2375.17; Thu, 20
 Jan 2022 16:47:06 +0800
From:   luofei <luofei@unicloud.com>
To:     qemu-devel <qemu-devel@nongnu.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, <kvm@vger.kernel.org>,
        luofei <luofei@unicloud.com>
Subject: [PATCH] i386: Set MCG_STATUS_RIPV bit for mce SRAR error
Date:   Thu, 20 Jan 2022 03:46:34 -0500
Message-ID: <20220120084634.131450-1-luofei@unicloud.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.10.1.7]
X-ClientProxiedBy: zgys-ex-mb06.Unicloud.com (10.10.0.52) To
 zgys-ex-mb09.Unicloud.com (10.10.0.24)
X-DNSRBL: 
X-MAIL: spam.unicloud.com 20K8lvN3061950
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the physical machine environment, when a SRAR error occurs,
the IA32_MCG_STATUS RIPV bit is set, but qemu does not set this
bit. When qemu injects an SRAR error into virtual machine, the
virtual machine kernel just call do_machine_check() to kill the
current task, but not call memory_failure() to isolate the faulty
page, which will cause the faulty page to be allocated and used
repeatedly. If used by the virtual machine kernel, it will cause
the virtual machine to crash

Signed-off-by: luofei <luofei@unicloud.com>
---
 target/i386/kvm/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 2c8feb4a6f..14655577f0 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -537,7 +537,7 @@ static void kvm_mce_inject(X86CPU *cpu, hwaddr paddr, int code)
 
     if (code == BUS_MCEERR_AR) {
         status |= MCI_STATUS_AR | 0x134;
-        mcg_status |= MCG_STATUS_EIPV;
+        mcg_status |= MCG_STATUS_RIPV | MCG_STATUS_EIPV;
     } else {
         status |= 0xc0;
         mcg_status |= MCG_STATUS_RIPV;
-- 
2.27.0

