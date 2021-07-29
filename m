Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0F43DA4BE
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 15:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237719AbhG2Nwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 09:52:51 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:17130 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237463AbhG2Nwn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 09:52:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1627566761; x=1659102761;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=vOwTZ5orfIykxaqp7JrAwtEKMxnNxzc6TJ11+WdRNEs=;
  b=JYul84FQr7jqxyoU/D6x80zezfwLgU1Xc979dgZFAugJcOd565CUBKwr
   vjqbs2HdGOnsnvXRD/CdaOTRK5B2OM8CTEHbrYsHjF4FhSjqrmg58vihC
   jTxvoORIh+sJ0kWjKcXIlSpphOMQZk4MhCuiJfv9dnDYgksS7UzMo6mP3
   o=;
X-IronPort-AV: E=Sophos;i="5.84,278,1620691200"; 
   d="scan'208";a="128792960"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 29 Jul 2021 13:52:31 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id C7CD4240413;
        Thu, 29 Jul 2021 13:52:29 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.160.66) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 29 Jul 2021 13:52:26 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC:     Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <kvm@vger.kernel.org>,
        <qemu-devel@nongnu.org>,
        Siddharth Chandrasekaran <sidcha@amazon.de>
Subject: [PATCH] hyperv: Fix struct hv_message_header ordering
Date:   Thu, 29 Jul 2021 15:52:10 +0200
Message-ID: <20210729135210.16970-1-sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.66]
X-ClientProxiedBy: EX13D20UWA003.ant.amazon.com (10.43.160.97) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to Hyper-V TLFS Version 6.0b, struct hv_message_header members
should be defined in the order:

	message_type, _reserved, message_flags, payload_size

but we have it defined in the order:

	message_type, payload_size, message_flags, _reserved

that is, the payload_size and _reserved members swapped. Due to this mix
up, we were inadvertently causing two issues:

    - The payload_size field has invalid data; it didn't cause an issue
      so far because we are delivering only timer messages which has fixed
      size payloads the guest probably did a sizeof(payload) instead
      relying on the value of payload_size member.

    - The message_flags was always delivered as 0 to the guest;
      fortunately, according to section 13.3.1 message_flags is also
      treated as a reserved field.

Although this is not causing an issue now, it might in future (we are
adding more message types in our VSM implementation) so fix it to
reflect the specification.

Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 include/hw/hyperv/hyperv-proto.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/hw/hyperv/hyperv-proto.h b/include/hw/hyperv/hyperv-proto.h
index 21dc28aee9..f578a60e78 100644
--- a/include/hw/hyperv/hyperv-proto.h
+++ b/include/hw/hyperv/hyperv-proto.h
@@ -101,9 +101,9 @@ struct hyperv_signal_event_input {
  */
 struct hyperv_message_header {
     uint32_t message_type;
-    uint8_t  payload_size;
-    uint8_t  message_flags; /* HV_MESSAGE_FLAG_XX */
     uint8_t  _reserved[2];
+    uint8_t  message_flags; /* HV_MESSAGE_FLAG_XX */
+    uint8_t  payload_size;
     uint64_t sender;
 };
 
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



