Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87132EBCC2
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 11:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbhAFKv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 05:51:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25955 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726845AbhAFKvy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Jan 2021 05:51:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609930228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BoXbd9bXO+SBQ5e4XC54WHCcJ8ZKbMXQCmg8EWaguMQ=;
        b=fICDkwqkdT+Xdu4z0ai+IW8GSxSDNXK9foUV3fMmTvcLBpjcjWDRLNR1H9fnwCUtCmVQuU
        FCuennpnxQpHxQtljBbJKgsLm+bTAyntsnhX5NKm+IYTBxECLtIqhZazzAjCb54u8u/0zp
        KbwHti5PW7Bb2OgWScpW8i5jblWsD2w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-QlOqh-kiPF6chVDXe609QA-1; Wed, 06 Jan 2021 05:50:27 -0500
X-MC-Unique: QlOqh-kiPF6chVDXe609QA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 429441005504;
        Wed,  6 Jan 2021 10:50:25 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A779B669FC;
        Wed,  6 Jan 2021 10:50:21 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 4/6] KVM: nSVM: correctly restore nested_run_pending on migration
Date:   Wed,  6 Jan 2021 12:49:59 +0200
Message-Id: <20210106105001.449974-5-mlevitsk@redhat.com>
In-Reply-To: <20210106105001.449974-1-mlevitsk@redhat.com>
References: <20210106105001.449974-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The code to store it on the migration exists, but no code was restoring it.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 6208d3a5a3fdb..c1a3d0e996add 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1203,6 +1203,10 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	 * in the registers, the save area of the nested state instead
 	 * contains saved L1 state.
 	 */
+
+	if (kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING)
+		svm->nested.nested_run_pending = true;
+
 	copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
 	hsave->save = *save;
 
-- 
2.26.2

