Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7877D278AE5
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 16:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbgIYOeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 10:34:46 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:40262 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbgIYOeq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 10:34:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1601044486; x=1632580486;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sfZL+fYteYafFZgtkEQwRvIq4yeNSzLylDLTNYYN9Qs=;
  b=qDKTgJ+4VgmsMDsQquvCtqOphLoTtfwN7KKQnsq2Wg75RdM5afpK1WiU
   Kr3Ceu25llH2aBnwmC5Dl6cRlYYDaH3REmzX8eLdXjhQAwz6ac4sPQuQs
   zbkCNCOvvFs9xgHpc3R2MEnnaYYB8XKQ8eMA3r+NEmNppfSpIw5kUkbyN
   Q=;
X-IronPort-AV: E=Sophos;i="5.77,302,1596499200"; 
   d="scan'208";a="56284047"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 25 Sep 2020 14:34:42 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id BC09BA17D3;
        Fri, 25 Sep 2020 14:34:37 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 25 Sep 2020 14:34:37 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.162.221) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 25 Sep 2020 14:34:33 +0000
From:   Alexander Graf <graf@amazon.com>
To:     kvm list <kvm@vger.kernel.org>
CC:     Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 1/8] KVM: x86: Return -ENOENT on unimplemented MSRs
Date:   Fri, 25 Sep 2020 16:34:15 +0200
Message-ID: <20200925143422.21718-2-graf@amazon.com>
X-Mailer: git-send-email 2.28.0.394.ge197136389
In-Reply-To: <20200925143422.21718-1-graf@amazon.com>
References: <20200925143422.21718-1-graf@amazon.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.162.221]
X-ClientProxiedBy: EX13D08UWC002.ant.amazon.com (10.43.162.168) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we find an MSR that we can not handle, bubble up that error code as
MSR error return code. Follow up patches will use that to expose the fact
that an MSR is not handled by KVM to user space.

Suggested-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Alexander Graf <graf@amazon.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 17f4995e80a7..58d513c5e264 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -267,7 +267,7 @@ static int kvm_msr_ignored_check(struct kvm_vcpu *vcpu, u32 msr,
 	} else {
 		vcpu_debug_ratelimited(vcpu, "unhandled %s: 0x%x data 0x%llx\n",
 				       op, msr, data);
-		return 1;
+		return -ENOENT;
 	}
 }
 
-- 
2.28.0.394.ge197136389




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



