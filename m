Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFCD37178F
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 17:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhECPKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 11:10:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230058AbhECPJ7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 11:09:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620054545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/uQsxGUHYKaif29C+o0XpobAqQVTryVzBnnTIXwgX7E=;
        b=VMZGVsyeZ37VsYYnFyR6OXIYzN+x2PjeDDaunnNT8+T76jTCd8Dp1CvoZ3/ZlnQXmj1FDc
        D51I3n5/9Iy6CfNFFxBKQEfkHCLLHbeEN6YQQRyPbhM2nOhcwdB8IXJ1A8cFKNgYnzDbUx
        B6YiLDEScaSTkMvQ3WY59LP1BhV95l0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-t7yd9-mLM5yubPlxvwghCw-1; Mon, 03 May 2021 11:09:04 -0400
X-MC-Unique: t7yd9-mLM5yubPlxvwghCw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A3B91966325;
        Mon,  3 May 2021 15:09:03 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB86519C45;
        Mon,  3 May 2021 15:09:00 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] KVM: nVMX: Properly pad 'struct kvm_vmx_nested_state_hdr'
Date:   Mon,  3 May 2021 17:08:52 +0200
Message-Id: <20210503150854.1144255-3-vkuznets@redhat.com>
In-Reply-To: <20210503150854.1144255-1-vkuznets@redhat.com>
References: <20210503150854.1144255-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eliminate the probably unwanted hole in 'struct kvm_vmx_nested_state_hdr':

Pre-patch:
struct kvm_vmx_nested_state_hdr {
        __u64                      vmxon_pa;             /*     0     8 */
        __u64                      vmcs12_pa;            /*     8     8 */
        struct {
                __u16              flags;                /*    16     2 */
        } smm;                                           /*    16     2 */

        /* XXX 2 bytes hole, try to pack */

        __u32                      flags;                /*    20     4 */
        __u64                      preemption_timer_deadline; /*    24     8 */
};

Post-patch:
struct kvm_vmx_nested_state_hdr {
        __u64                      vmxon_pa;             /*     0     8 */
        __u64                      vmcs12_pa;            /*     8     8 */
        struct {
                __u16              flags;                /*    16     2 */
        } smm;                                           /*    16     2 */
        __u16                      pad;                  /*    18     2 */
        __u32                      flags;                /*    20     4 */
        __u64                      preemption_timer_deadline; /*    24     8 */
};

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/uapi/asm/kvm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 5a3022c8af82..0662f644aad9 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -437,6 +437,8 @@ struct kvm_vmx_nested_state_hdr {
 		__u16 flags;
 	} smm;
 
+	__u16 pad;
+
 	__u32 flags;
 	__u64 preemption_timer_deadline;
 };
-- 
2.30.2

