Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C397F3918A5
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 15:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbhEZNWg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 09:22:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60719 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233236AbhEZNWZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 09:22:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622035253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZGc6qbuuYO0qoOZgZ3jqZru38h7KO7v3PLsZa2TmF14=;
        b=HvczlX+jwMAMNrC6HSbstx5o7bow8Rjf8GHFmG9V135zOtuwI4fbaaR6dxmxzQs8V7VXef
        0+kH3OJ9+a/TkLWxCzHyIihRGXyhopDt/QmvK3pnvp29TCcYBluvqAuiFOeNSzXpqivGMQ
        UKOb0keo/dR228e6nyAsG33Z+Spe/GI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-my7SdG6bPEeAZLtAGihj1g-1; Wed, 26 May 2021 09:20:49 -0400
X-MC-Unique: my7SdG6bPEeAZLtAGihj1g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 221DD107ACCD;
        Wed, 26 May 2021 13:20:48 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 825E15D9E2;
        Wed, 26 May 2021 13:20:39 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 03/11] KVM: nVMX: Release eVMCS when enlightened VMENTRY was disabled
Date:   Wed, 26 May 2021 15:20:18 +0200
Message-Id: <20210526132026.270394-4-vkuznets@redhat.com>
In-Reply-To: <20210526132026.270394-1-vkuznets@redhat.com>
References: <20210526132026.270394-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In theory, L1 can try to disable enlightened VMENTRY in VP assist page and
try to issue VMLAUNCH/VMRESUME. While nested_vmx_handle_enlightened_vmptrld()
properly handles this as 'EVMPTRLD_DISABLED', previously mapped eVMCS
remains mapped and thus all evmptr_is_valid() checks will still pass and
nested_vmx_run() will proceed when it shouldn't.

Release eVMCS immediately when we detect that enlightened vmentry was
disabled by L1.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c662278e4793..ea2c52aad8f0 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1980,8 +1980,10 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 	if (likely(!vmx->nested.enlightened_vmcs_enabled))
 		return EVMPTRLD_DISABLED;
 
-	if (!nested_enlightened_vmentry(vcpu, &evmcs_gpa))
+	if (!nested_enlightened_vmentry(vcpu, &evmcs_gpa)) {
+		nested_release_evmcs(vcpu);
 		return EVMPTRLD_DISABLED;
+	}
 
 	if (unlikely(evmcs_gpa != vmx->nested.hv_evmcs_vmptr)) {
 		vmx->nested.current_vmptr = -1ull;
-- 
2.31.1

