Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9AB43B950
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 20:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238197AbhJZSV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 14:21:59 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:36540 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238181AbhJZSV6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 14:21:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1635272375; x=1666808375;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oRl19oj7wMvXCaYc6Y80gCnG7GztQIUdbpmo+In0/Mk=;
  b=qV59A8ZI0bhP9jT85PRn0hrebEob9Xoy5vf5OJ9k0axAswgyjeb3GZM1
   10N1Y8kNjT81yBFZJkefDgVz5vUSKvD2EvoWgQDuTfofJXl0Sm6nGtNVF
   n/JnBS7Cjo6JK4/wxIfu1+fVcdtVQm8zaRf7gtqtAudNotoVw5vooiSC/
   Q=;
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 26 Oct 2021 11:19:34 -0700
X-QCInternal: smtphost
Received: from nalasex01a.na.qualcomm.com ([10.47.209.196])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 11:19:33 -0700
Received: from qian-HP-Z2-SFF-G5-Workstation.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7;
 Tue, 26 Oct 2021 11:19:32 -0700
From:   Qian Cai <quic_qiancai@quicinc.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Qian Cai <quic_qiancai@quicinc.com>
Subject: [PATCH v2] kvm: Avoid shadowing a local in search_memslots()
Date:   Tue, 26 Oct 2021 14:19:15 -0400
Message-ID: <20211026181915.48652-1-quic_qiancai@quicinc.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
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
index 60a35d9fe259..9a62c0e52519 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1243,12 +1243,12 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index)
 		return NULL;
 
 	while (start < end) {
-		int slot = start + (end - start) / 2;
+		int pivot = start + (end - start) / 2;
 
-		if (gfn >= memslots[slot].base_gfn)
-			end = slot;
+		if (gfn >= memslots[pivot].base_gfn)
+			end = pivot;
 		else
-			start = slot + 1;
+			start = pivot + 1;
 	}
 
 	slot = try_get_memslot(slots, start, gfn);
-- 
2.30.2

