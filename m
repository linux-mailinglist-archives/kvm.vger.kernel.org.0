Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E90833BDC7
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 15:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbhCOOih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 10:38:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57079 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239526AbhCOOhS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 10:37:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615819037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O5Co9d4ozrTngCdGCM1S57GEotFMyYjlIiNeBZ4sqxk=;
        b=h/y4RDRqbhVbyTehf8d12v62U+fddJGdoRUSxKRFm7qWekwNUpIdyPDTXy26tWVGLgWw3B
        Z3Rs63n9jLqJF9osvhWFH9pLjrUYgm5hQERoi4/9wxmCYvL0rFQtRQlCbmmckLogNSR1Oc
        78NAZZHqFtcuZfmwgXhzpZ4tJivnPxA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-c6DaTcNyO3aTxQeaW05zmw-1; Mon, 15 Mar 2021 10:37:13 -0400
X-MC-Unique: c6DaTcNyO3aTxQeaW05zmw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5199C18460E1;
        Mon, 15 Mar 2021 14:37:12 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FDAB5C3E6;
        Mon, 15 Mar 2021 14:37:10 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 1/4] KVM: x86: hyper-v: Limit guest to writing zero to HV_X64_MSR_TSC_EMULATION_STATUS
Date:   Mon, 15 Mar 2021 15:37:03 +0100
Message-Id: <20210315143706.859293-2-vkuznets@redhat.com>
In-Reply-To: <20210315143706.859293-1-vkuznets@redhat.com>
References: <20210315143706.859293-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HV_X64_MSR_TSC_EMULATION_STATUS indicates whether TSC accesses are emulated
after migration (to accommodate for a different host TSC frequency when TSC
scaling is not supported; we don't implement this in KVM). Guest can use
the same MSR to stop TSC access emulation by writing zero. Writing anything
else is forbidden.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 58fa8c029867..eefb85b86fe8 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1229,6 +1229,9 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 		hv->hv_tsc_emulation_control = data;
 		break;
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
+		if (data && !host)
+			return 1;
+
 		hv->hv_tsc_emulation_status = data;
 		break;
 	case HV_X64_MSR_TIME_REF_COUNT:
-- 
2.30.2

