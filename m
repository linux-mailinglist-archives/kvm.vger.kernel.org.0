Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3F2487C9A
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 19:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbiAGS40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 13:56:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54096 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232016AbiAGSzb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 13:55:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641581730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dBNFKUgWKdCqor0H5VfFU85e88DSuI1/0lzNTJj8o5s=;
        b=GBr1XB1YnbAPBrYjLxg304FXHAXPCmYhQZFty9vQoQ67tWXS4isyycOIFJgXFAbSxvX2La
        xhzkgJhSl+TWzuoA0WJZp6SAgAcQBTLDVo3yh1r4KfQC8DYsVpT6KwNgOHrw5xhkMEQMm7
        sSRPHKkDSO0lKeJvtruUIiEgVFVRYqU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-178-kBlLH0JxPEymU_zJgXZaTw-1; Fri, 07 Jan 2022 13:55:25 -0500
X-MC-Unique: kBlLH0JxPEymU_zJgXZaTw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A60A418C9F40;
        Fri,  7 Jan 2022 18:55:23 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF0CE92FAF;
        Fri,  7 Jan 2022 18:55:22 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     guang.zeng@intel.com, jing2.liu@intel.com, kevin.tian@intel.com,
        seanjc@google.com, tglx@linutronix.de, wei.w.wang@intel.com,
        yang.zhong@intel.com
Subject: [PATCH v6 11/21] x86/fpu: Prepare xfd_err in struct fpu_guest
Date:   Fri,  7 Jan 2022 13:55:02 -0500
Message-Id: <20220107185512.25321-12-pbonzini@redhat.com>
In-Reply-To: <20220107185512.25321-1-pbonzini@redhat.com>
References: <20220107185512.25321-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Liu <jing2.liu@intel.com>

When XFD causes an instruction to generate #NM, IA32_XFD_ERR
contains information about which disabled state components are
being accessed. The #NM handler is expected to check this
information and then enable the state components by clearing
IA32_XFD for the faulting task (if having permission).

If the XFD_ERR value generated in guest is consumed/clobbered
by the host before the guest itself doing so, it may lead to
non-XFD-related #NM treated as XFD #NM in host (due to non-zero
value in XFD_ERR), or XFD-related #NM treated as non-XFD #NM in
guest (XFD_ERR cleared by the host #NM handler).

Introduce a new field in fpu_guest to save the guest xfd_err value.
KVM is expected to save guest xfd_err before interrupt is enabled
and restore it right before entering the guest (with interrupt
disabled).

Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Message-Id: <20220105123532.12586-12-yang.zhong@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/fpu/types.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index c752d0aa23a4..3795d0573773 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -517,6 +517,11 @@ struct fpu_guest {
 	 */
 	u64				perm;
 
+	/*
+	 * @xfd_err:			Save the guest value.
+	 */
+	u64				xfd_err;
+
 	/*
 	 * @fpstate:			Pointer to the allocated guest fpstate
 	 */
-- 
2.31.1


