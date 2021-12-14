Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2522447454E
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 15:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbhLNOjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 09:39:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52587 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234915AbhLNOjL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 09:39:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639492750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ji9Xa62KyjOXb6hvNO7YbP50Ro+nqRN9L5eN1quX6og=;
        b=fj2FN/Uovj9Pch0dfioxAG0z7+q/X5WMtwyPLX5aiH6HHQyiKv0R2xLnJDQy+JvJqCYYFj
        ZaD0P1qmsrl6wfhLtD4pQxamELlhqgET9YcCBgykprFInG6/hfVEVH/N6n69Ojse8Y8ky/
        xRI5kqxSJai+RInQemkvsqcmbuejKYk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-466-Ev9fMbLPMOSjpkVEv7bFkQ-1; Tue, 14 Dec 2021 09:39:07 -0500
X-MC-Unique: Ev9fMbLPMOSjpkVEv7bFkQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02D7881CCDC;
        Tue, 14 Dec 2021 14:39:06 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECE88756ED;
        Tue, 14 Dec 2021 14:39:03 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] KVM: nVMX: Also filter MSR_IA32_VMX_TRUE_PINBASED_CTLS when eVMCS
Date:   Tue, 14 Dec 2021 15:38:55 +0100
Message-Id: <20211214143859.111602-2-vkuznets@redhat.com>
In-Reply-To: <20211214143859.111602-1-vkuznets@redhat.com>
References: <20211214143859.111602-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to MSR_IA32_VMX_EXIT_CTLS/MSR_IA32_VMX_TRUE_EXIT_CTLS,
MSR_IA32_VMX_ENTRY_CTLS/MSR_IA32_VMX_TRUE_ENTRY_CTLS pair,
MSR_IA32_VMX_TRUE_PINBASED_CTLS needs to be filtered the same way
MSR_IA32_VMX_PINBASED_CTLS is currently filtered as guests may solely rely
on 'true' MSR data.

Note, none of the currently existing Windows/Hyper-V versions are known
to stumble upon the unfiltered MSR_IA32_VMX_TRUE_PINBASED_CTLS, the change
is aimed at making the filtering future proof.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index ba6f99f584ac..a7ed30d5647a 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -362,6 +362,7 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
 		ctl_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
 		break;
+	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
 	case MSR_IA32_VMX_PINBASED_CTLS:
 		ctl_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
 		break;
-- 
2.33.1

