Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0393918A2
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 15:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbhEZNWT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 09:22:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28504 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233149AbhEZNWO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 09:22:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622035241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Awh7A09CLWEqFPUHcnB6wUGwgrbU/YRLsFlTNEttmpg=;
        b=QYwvr6C3KUetmjCxCqritQCArsC/WOKZBgoRN21xlyiLr2yOWU6apH0Brf6jWTt5Z2SolI
        Vs52FKOZGS075sa8+YOLubsTsK70W2Fjz4YalheLvF5f6BC5Tiewt0ZpBNMm9keytPEiuk
        ztuZxmA9GGWZbZPf4F8L3HpuN9q02Rc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-q0SlDo2rO3majY2CBGNLyg-1; Wed, 26 May 2021 09:20:40 -0400
X-MC-Unique: q0SlDo2rO3majY2CBGNLyg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D0D781840C;
        Wed, 26 May 2021 13:20:39 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE7D35D9C6;
        Wed, 26 May 2021 13:20:33 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 02/11] KVM: nVMX: Don't set 'dirty_vmcs12' flag on enlightened VMPTRLD
Date:   Wed, 26 May 2021 15:20:17 +0200
Message-Id: <20210526132026.270394-3-vkuznets@redhat.com>
In-Reply-To: <20210526132026.270394-1-vkuznets@redhat.com>
References: <20210526132026.270394-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'dirty_vmcs12' is only checked in prepare_vmcs02_early()/prepare_vmcs02()
and both checks look like:

 'vmx->nested.dirty_vmcs12 || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)'

so for eVMCS case the flag changes nothing. Drop the assignment to avoid
the confusion.

No functional change intended.

Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 74ff3fd56ce5..c662278e4793 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2022,7 +2022,6 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 			return EVMPTRLD_VMFAIL;
 		}
 
-		vmx->nested.dirty_vmcs12 = true;
 		vmx->nested.hv_evmcs_vmptr = evmcs_gpa;
 
 		evmcs_gpa_changed = true;
-- 
2.31.1

