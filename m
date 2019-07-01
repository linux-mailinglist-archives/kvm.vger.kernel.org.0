Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE82311117
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 04:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbfEBCGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 May 2019 22:06:45 -0400
Received: from outprodmail01.cc.columbia.edu ([128.59.72.39]:44606 "EHLO
        outprodmail01.cc.columbia.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726152AbfEBCGp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 May 2019 22:06:45 -0400
X-Greylist: delayed 673 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 May 2019 22:06:43 EDT
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
        by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id x421t8I8044651
        for <kvm@vger.kernel.org>; Wed, 1 May 2019 21:55:29 -0400
Received: from hazelnut (localhost.localdomain [127.0.0.1])
        by hazelnut (Postfix) with ESMTP id AEEFB6D
        for <kvm@vger.kernel.org>; Wed,  1 May 2019 21:55:29 -0400 (EDT)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu [128.59.72.14])
        by hazelnut (Postfix) with ESMTP id 936726D
        for <kvm@vger.kernel.org>; Wed,  1 May 2019 21:55:29 -0400 (EDT)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
        by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id x421tTd6000917
        (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 1 May 2019 21:55:29 -0400
Received: by mail-qk1-f198.google.com with SMTP id u15so976375qkj.12
        for <kvm@vger.kernel.org>; Wed, 01 May 2019 18:55:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DipZkjPoE1y0mKX4SeL1BWW7IS4g9E1E70yAwDxzXZI=;
        b=jyysdUHg9kVUewzMqP48xm8FIZJrx2+AkPM9xK5nuFhHz7lHe+6hTk2QnP4k03LPKA
         M0Tk/+rBX99BUT+SIzak00Pi18PA6nHwMnrgzkJVAtPbglpm31Fe/OGYy527iB7HAmoQ
         jpZwUJ2jKqQT0Ep0RD4boTbr2uXkeD71366mzEijpE4EK/EWp+vVODSMxtzduG3xyRZC
         t9hMIRqIujqZ7qDS8uh9OPH49uwUSsFKJKwCkZpFpz0hlGx0u20N5x5Q5AP4PWM/G5SX
         XPr/2Hx55zOf8pYAQ3JYdxos65Uksa/QDrzzmvvws5m/u7NmF+VhGglLf9exjkdMdy0E
         OuGg==
X-Gm-Message-State: APjAAAW5OLZUroTNqTxyEONXGenNDuFA0M/4b8exnYvfxg8Cg8YoSlKK
        SDCZJGtL8FxPA5VOI1klMz+CHzx4hwRA7fij0MW/udPFyGv9YUkD4Il6WSenDVnLCGSQj3P11YX
        EantD+dXViTCiWmXt/A5N
X-Received: by 2002:ad4:53c4:: with SMTP id k4mr1084749qvv.111.1556762128779;
        Wed, 01 May 2019 18:55:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy5p3a3d8ucqWrsew7zT9XuZbsLj/X4oY7fucYjTUrdC5W4lwSap+uhYzy7qtVvOy9AhEfiJA==
X-Received: by 2002:ad4:53c4:: with SMTP id k4mr1084739qvv.111.1556762128636;
        Wed, 01 May 2019 18:55:28 -0700 (PDT)
Received: from hp03.ncl.cs.columbia.edu (hp03.ncl.cs.columbia.edu. [128.59.18.193])
        by smtp.gmail.com with ESMTPSA id e131sm4888474qkb.80.2019.05.01.18.55.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 01 May 2019 18:55:27 -0700 (PDT)
From:   Jintack Lim <jintack@cs.columbia.edu>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        Jintack Lim <jintack@cs.columbia.edu>
Subject: [PATCH] KVM: nVMX: Set msr bitmap correctly for MSR_FS_BASE in vmcs02
Date:   Wed,  1 May 2019 22:09:19 -0400
Message-Id: <1556762959-31705-1-git-send-email-jintack@cs.columbia.edu>
X-Mailer: git-send-email 1.9.1
X-No-Spam-Score: Local
X-Scanned-By: MIMEDefang 2.84 on 128.59.72.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Even when neither L0 nor L1 configured to trap MSR_FS_BASE writes from
its own VMs, the current KVM L0 always traps MSR_FS_BASE writes from L2.
Let's check if both L0 and L1 disabled trap for MSR_FS_BASE for its VMs
respectively, and let L2 write to MSR_FS_BASE without trap if that's the
case.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/x86/kvm/vmx/nested.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0c601d0..ab85aea 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -537,6 +537,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	 */
 	bool pred_cmd = !msr_write_intercepted_l01(vcpu, MSR_IA32_PRED_CMD);
 	bool spec_ctrl = !msr_write_intercepted_l01(vcpu, MSR_IA32_SPEC_CTRL);
+	bool fs_base = !msr_write_intercepted_l01(vcpu, MSR_FS_BASE);
 
 	/* Nothing to do if the MSR bitmap is not in use.  */
 	if (!cpu_has_vmx_msr_bitmap() ||
@@ -592,6 +593,12 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 		}
 	}
 
+	if (fs_base)
+		nested_vmx_disable_intercept_for_msr(
+					msr_bitmap_l1, msr_bitmap_l0,
+					MSR_FS_BASE,
+					MSR_TYPE_W);
+
 	if (spec_ctrl)
 		nested_vmx_disable_intercept_for_msr(
 					msr_bitmap_l1, msr_bitmap_l0,
-- 
1.9.1


