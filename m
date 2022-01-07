Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE62F487C96
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 19:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiAGSzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 13:55:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:43907 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231535AbiAGSzZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 13:55:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641581724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X/6dTkGCMxdSSMBeTmxzGgatvGMYNiCgl3Ne23BFT6g=;
        b=DV5Y4IuX7gpZlgSSyvZBEMQUTIiu20BgjlRYrbEeFtf476KAXJsiOJMsGi0qD2b9Cn+iZD
        0LCvJk/CFDNpIi2jgae2SnhvV2JPRymQoFpH9+CPqNbXEnD1z6uzxgD6ZfNyhBzUtSjofy
        oYgBE1pnDp8RzZ8eGDXa1g6SBlkYTtA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-ubVZrTNFNkqT-TT8EFz4qA-1; Fri, 07 Jan 2022 13:55:18 -0500
X-MC-Unique: ubVZrTNFNkqT-TT8EFz4qA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC4AC101F003;
        Fri,  7 Jan 2022 18:55:16 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B71D838DD;
        Fri,  7 Jan 2022 18:55:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     guang.zeng@intel.com, jing2.liu@intel.com, kevin.tian@intel.com,
        seanjc@google.com, tglx@linutronix.de, wei.w.wang@intel.com,
        yang.zhong@intel.com
Subject: [PATCH v6 03/21] kvm: x86: Fix xstate_required_size() to follow XSTATE alignment rule
Date:   Fri,  7 Jan 2022 13:54:54 -0500
Message-Id: <20220107185512.25321-4-pbonzini@redhat.com>
In-Reply-To: <20220107185512.25321-1-pbonzini@redhat.com>
References: <20220107185512.25321-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Liu <jing2.liu@intel.com>

CPUID.0xD.1.EBX enumerates the size of the XSAVE area (in compacted
format) required by XSAVES. If CPUID.0xD.i.ECX[1] is set for a state
component (i), this state component should be located on the next
64-bytes boundary following the preceding state component in the
compacted layout.

Fix xstate_required_size() to follow the alignment rule. AMX is the
first state component with 64-bytes alignment to catch this bug.

Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Message-Id: <20220105123532.12586-4-yang.zhong@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0b920e12bb6d..f3e6fda6b858 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -42,7 +42,11 @@ static u32 xstate_required_size(u64 xstate_bv, bool compacted)
 		if (xstate_bv & 0x1) {
 		        u32 eax, ebx, ecx, edx, offset;
 		        cpuid_count(0xD, feature_bit, &eax, &ebx, &ecx, &edx);
-			offset = compacted ? ret : ebx;
+			/* ECX[1]: 64B alignment in compacted form */
+			if (compacted)
+				offset = (ecx & 0x2) ? ALIGN(ret, 64) : ret;
+			else
+				offset = ebx;
 			ret = max(ret, offset + eax);
 		}
 
-- 
2.31.1


