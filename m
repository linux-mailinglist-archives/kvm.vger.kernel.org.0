Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A27F40B375
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 17:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbhINPuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 11:50:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42185 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234786AbhINPuA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 11:50:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631634522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pEV05lOFEjMox5QCsgxD2AGwkvNu18w87kROINIyih0=;
        b=MV6dN07zzmCVRsuYOl6mj1PZnHDtRMRYgpn2vFBaNLsZnNCF2brEQBR8JVSp7z/gTzvduW
        C76nTe/5QNKdVoPgFn3lS0uRCXX5K4ErYZWX41StIBvnM9jmJ3PC+oFRktGWTxyXNp2kC8
        98SLpsexdDtBMtcLjiQkRgrPE5W7O0I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-xxUqKsjMPnyqaTqLuyC7eA-1; Tue, 14 Sep 2021 11:48:41 -0400
X-MC-Unique: xxUqKsjMPnyqaTqLuyC7eA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7446619253C2;
        Tue, 14 Sep 2021 15:48:39 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09A665C1BB;
        Tue, 14 Sep 2021 15:48:34 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Bandan Das <bsd@redhat.com>,
        linux-kernel@vger.kernel.org (open list),
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Wei Huang <wei.huang2@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK),
        Maxim Levitsky <mlevitsk@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Shuah Khan <shuah@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 01/14] KVM: x86: nSVM: restore int_vector in svm_clear_vintr
Date:   Tue, 14 Sep 2021 18:48:12 +0300
Message-Id: <20210914154825.104886-2-mlevitsk@redhat.com>
In-Reply-To: <20210914154825.104886-1-mlevitsk@redhat.com>
References: <20210914154825.104886-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In svm_clear_vintr we try to restore the virtual interrupt
injection that might be pending, but we fail to restore
the interrupt vector.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 05e8d4d27969..b2e710a3fff6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1566,6 +1566,8 @@ static void svm_clear_vintr(struct vcpu_svm *svm)
 
 		svm->vmcb->control.int_ctl |= svm->nested.ctl.int_ctl &
 			V_IRQ_INJECTION_BITS_MASK;
+
+		svm->vmcb->control.int_vector = svm->nested.ctl.int_vector;
 	}
 
 	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);
-- 
2.26.3

