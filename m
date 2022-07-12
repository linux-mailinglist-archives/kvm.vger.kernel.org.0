Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1E3571BB3
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 15:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbiGLNuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 09:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbiGLNuQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 09:50:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F01B796B7
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 06:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657633815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=SFVSLqrYrgkusctV+2V73g8BNKpJLh23Sh2hGgmwXNY=;
        b=Pi6Vq40e7BKfVKvej9pkXIRC1thXmDi9sKTr3UUn2jitcFw92SdaJhoguFAKt0ROG+y8Rk
        d1xB8LgvgU1qaKB15p/C+rG+iyFlIpvecaI/c+aJUVtgqCsnfsT/YzK/gFebquYmdFOy3i
        ULDRmznKHukdd+sT1aE/osRlx5GZG/o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-428-XmcgN4WfNkSfqll6zDHypw-1; Tue, 12 Jul 2022 09:50:12 -0400
X-MC-Unique: XmcgN4WfNkSfqll6zDHypw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B338F185A7BA;
        Tue, 12 Jul 2022 13:50:11 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 346DB9D7F;
        Tue, 12 Jul 2022 13:50:10 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: nVMX: Always enable TSC scaling for L2 when it was enabled for L1
Date:   Tue, 12 Jul 2022 15:50:09 +0200
Message-Id: <20220712135009.952805-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Windows 10/11 guests with Hyper-V role (WSL2) enabled are observed to
hang upon boot or shortly after when a non-default TSC frequency was
set for L1. The issue is observed on a host where TSC scaling is
supported. The problem appears to be that Windows doesn't use TSC
frequency for its guests even when the feature is advertised and KVM
filters SECONDARY_EXEC_TSC_SCALING out when creating L2 controls from
L1's. This leads to L2 running with the default frequency (matching
host's) while L1 is running with an altered one.

Keep SECONDARY_EXEC_TSC_SCALING in secondary exec controls for L2 when
it was set for L1. TSC_MULTIPLIER is already correctly computed and
written by prepare_vmcs02().

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 778f82015f03..bfa366938c49 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2284,7 +2284,6 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
 				  SECONDARY_EXEC_APIC_REGISTER_VIRT |
 				  SECONDARY_EXEC_ENABLE_VMFUNC |
-				  SECONDARY_EXEC_TSC_SCALING |
 				  SECONDARY_EXEC_DESC);
 
 		if (nested_cpu_has(vmcs12,
-- 
2.35.3

