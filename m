Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322DB608BA8
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 12:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiJVKbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Oct 2022 06:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiJVKba (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Oct 2022 06:31:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3D313FA9
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 02:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666431964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Z4xH2gIaFjaMtuLR3rjMmby3hquw36E2ehtRGHxZNnk=;
        b=XUnqjzXz+mOYb+aogf9034FoTED0GbHzgRnc6kWIjufn9upvsa1cQJfuvKNo+IWrHiIbDp
        yRCVk/k0113eEsw5TeWYAo/zMrToeYFmY6iiChysNTZVXC0UlcbEIu0HVF57TGn54wkDIJ
        +fiDAX04cRgHvx7ACwz6C0p7Mc/+OP0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-2XO7Ra7wNaWtadjImSpXMA-1; Sat, 22 Oct 2022 04:26:54 -0400
X-MC-Unique: 2XO7Ra7wNaWtadjImSpXMA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E60D804186;
        Sat, 22 Oct 2022 08:26:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 78D932166B2C;
        Sat, 22 Oct 2022 08:26:45 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, jmattson@google.com
Subject: [PATCH] KVM: x86: Do not expose the host value of CPUID.8000001EH
Date:   Sat, 22 Oct 2022 04:26:43 -0400
Message-Id: <20221022082643.1725875-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Several fields of CPUID.8000001EH (ExtendedApicId in EAX[31:0],
CoreId in EBX[7:0], NodeId in ECX[7:0]) vary on each processor,
and it is simply impossible to fit the right values in the
KVM_GET_SUPPORTED_CPUID API, in such a way that they can be
passed to KVM_SET_CPUID2.

The most likely way to avoid confusion in the guest is to zero
out all the values.  Userspace will most likely override it
anyway if it want to present a specific topology to the guest.

This patch essentially reverts commit 382409b4c43e ("kvm: x86: Include
CPUID leaf 0x8000001e in kvm's supported CPUID").

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index a0292ba650df..380b71600a9e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1193,6 +1193,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->ebx = entry->ecx = entry->edx = 0;
 		break;
 	case 0x8000001e:
+		/* Different on each processor, just hide it.  */
+		entry->eax = entry->ebx = entry->ecx = 0;
+		entry->edx = 0;
 		break;
 	case 0x8000001F:
 		if (!kvm_cpu_cap_has(X86_FEATURE_SEV)) {
-- 
2.31.1

