Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56621DA34E
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 23:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgESVNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 17:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727918AbgESVNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 17:13:32 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E35C08C5C3;
        Tue, 19 May 2020 14:13:32 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jb9YB-0001zf-LZ; Tue, 19 May 2020 23:13:23 +0200
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 1ABAF100D00;
        Tue, 19 May 2020 23:13:23 +0200 (CEST)
Message-Id: <20200519211224.845737494@linutronix.de>
User-Agent: quilt/0.65
Date:   Tue, 19 May 2020 22:31:35 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [patch 7/7] x86/kvm/vmx: Use native read/write_cr2()
References: <20200519203128.773151484@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


read/write_cr2() go throuh the paravirt XXL indirection, but nested VMX in
a XEN_PV guest is not supported.

Use the native variants.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Juergen Gross <jgross@suse.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0a751a6ddf6e..9a5b193fe0b3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6677,13 +6677,13 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	else if (static_branch_unlikely(&mds_user_clear))
 		mds_clear_cpu_buffers();
 
-	if (vcpu->arch.cr2 != read_cr2())
-		write_cr2(vcpu->arch.cr2);
+	if (vcpu->arch.cr2 != native_read_cr2())
+		native_write_cr2(vcpu->arch.cr2);
 
 	vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
 				   vmx->loaded_vmcs->launched);
 
-	vcpu->arch.cr2 = read_cr2();
+	vcpu->arch.cr2 = native_read_cr2();
 
 	/*
 	 * VMEXIT disables interrupts (host state), but tracing and lockdep

