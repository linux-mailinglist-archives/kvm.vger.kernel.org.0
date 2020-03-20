Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 075BB18D20A
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 15:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgCTO5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 10:57:12 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:51178 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726954AbgCTO5L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 10:57:11 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id D7499412E5;
        Fri, 20 Mar 2020 14:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1584716228; x=1586530629; bh=hXk2I+Uf3B4qG3bY1LH8F04P3dqKkVGLcEc
        7zB2bHMU=; b=TZZi6xqEYLSgSmJYhypUX/vHopxgYdjY2sPwW99Z9z/vA/T7fTd
        PN6R1R6zHQFgZtS7+MVZb8hqa+XpKqCsLNS5Fn4OEcUm4qwuG0PZIOCBVcbfKysV
        1HAKuxzC+5LvIkysrA3d7U0sOj1jQcL/1FRSjKX4Ackk0ZZYsjmTksIA=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id q9bfuiwIYJdN; Fri, 20 Mar 2020 17:57:08 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 9B986412EA;
        Fri, 20 Mar 2020 17:57:07 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 20
 Mar 2020 17:57:08 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [kvm-unit-tests PATCH 1/2] scripts/arch-run: Support testing of hvf accel
Date:   Fri, 20 Mar 2020 17:55:40 +0300
Message-ID: <20200320145541.38578-2-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320145541.38578-1-r.bolshakov@yadro.com>
References: <20200320145541.38578-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The tests can be run if Hypervisor.framework API is available:

  https://developer.apple.com/documentation/hypervisor?language=objc#1676667

Cc: Cameron Esfahani <dirty@apple.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 scripts/arch-run.bash | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index d3ca19d..197ae6c 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -315,17 +315,30 @@ kvm_available ()
 		( [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] )
 }
 
+hvf_available ()
+{
+	[ "$(sysctl -n kern.hv_support 2>/dev/null)" = "1" ] || return 1
+	[ "$HOST" = "$ARCH_NAME" ] ||
+		( [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] )
+}
+
 get_qemu_accelerator ()
 {
 	if [ "$ACCEL" = "kvm" ] && ! kvm_available; then
 		echo "KVM is needed, but not available on this host" >&2
 		return 2
 	fi
+	if [ "$ACCEL" = "hvf" ] && ! hvf_available; then
+		echo "HVF is needed, but not available on this host" >&2
+		return 2
+	fi
 
 	if [ "$ACCEL" ]; then
 		echo $ACCEL
 	elif kvm_available; then
 		echo kvm
+	elif hvf_available; then
+		echo hvf
 	else
 		echo tcg
 	fi
-- 
2.24.1

