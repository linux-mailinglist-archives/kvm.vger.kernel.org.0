Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F185143B53F
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 17:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235007AbhJZPQK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 11:16:10 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:50826 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhJZPQJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 11:16:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1635261225; x=1666797225;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hMVGXLAP08E9V76L8Z59RzfC5zmfXLUlh1tBbI5dHvw=;
  b=wtJtRcyLlyjl85z6dUKjMCAGFhCOGW+Dy/HKCf3CrBhJLKYQWmPdCW8W
   ICygK4/GAtsij9UignJv73cEWzX7AR3lV+RsguCoXG+1qv73wGMkKG2HK
   ccXsvDxDkf1a17xt2MifOdqoekMZiNhnONJosJ9z0OXCdzgfoCmA0Kamt
   E=;
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 26 Oct 2021 08:13:45 -0700
X-QCInternal: smtphost
Received: from nalasex01a.na.qualcomm.com ([10.47.209.196])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 08:13:45 -0700
Received: from qian-HP-Z2-SFF-G5-Workstation.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7;
 Tue, 26 Oct 2021 08:13:44 -0700
From:   Qian Cai <quic_qiancai@quicinc.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Qian Cai <quic_qiancai@quicinc.com>
Subject: [PATCH] kvm: Avoid shadowing a local in search_memslots()
Date:   Tue, 26 Oct 2021 11:13:10 -0400
Message-ID: <20211026151310.42728-1-quic_qiancai@quicinc.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is less error-prone to use a different variable name from the existing
one in a wider scope. This is also flagged by GCC (W=2):

./include/linux/kvm_host.h: In function 'search_memslots':
./include/linux/kvm_host.h:1246:7: warning: declaration of 'slot' shadows a previous local [-Wshadow]
 1246 |   int slot = start + (end - start) / 2;
      |       ^~~~
./include/linux/kvm_host.h:1240:26: note: shadowed declaration is here
 1240 |  struct kvm_memory_slot *slot;
      |                          ^~~~

Signed-off-by: Qian Cai <quic_qiancai@quicinc.com>
---
 include/linux/kvm_host.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 60a35d9fe259..1c1a36f658fe 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1243,12 +1243,12 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index)
 		return NULL;
 
 	while (start < end) {
-		int slot = start + (end - start) / 2;
+		int new_slot = start + (end - start) / 2;
 
-		if (gfn >= memslots[slot].base_gfn)
-			end = slot;
+		if (gfn >= memslots[new_slot].base_gfn)
+			end = new_slot;
 		else
-			start = slot + 1;
+			start = new_slot + 1;
 	}
 
 	slot = try_get_memslot(slots, start, gfn);
-- 
2.30.2

