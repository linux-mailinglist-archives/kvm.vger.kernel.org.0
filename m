Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D5A219100
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 21:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgGHTxu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 15:53:50 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53434 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgGHTxr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 15:53:47 -0400
Message-Id: <20200708195322.344731916@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594238025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=qENerA8I1NYDNTLbmvsdZ/rAWI2IBukjDbybqGSssqQ=;
        b=gc0fAMPbSU3zL9Bs/acFj+hz9yYiBq0d3OOqc5MRGE8WxPXGuiuMQaBuxUq45JYmAuoICR
        /kv4Z9EN+/wkOA85iN1BHLDyE63rzZZ6i7HslVzjuSAxvBeRjs1FBc/0ktTl1Adpw891pg
        YqRJ7tFPKuf0w53mgty57JXY4FO5dKT7cTvFRfB4CC2c0ZUmPHeE/WV1hkoku1ssGTqD00
        OtqHu2lzrH+mCM4TlfSrjgaOrAe2HHsUnwplm15H5WVrry1oLo6W6mp2vt9BQPEoLXLmHg
        wqlUS8g8/7N6L5EfytZ4HgL7R8z8fUnAlT2G1U+buy1kR1QtjH8I8XRZjaBvmg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594238025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=qENerA8I1NYDNTLbmvsdZ/rAWI2IBukjDbybqGSssqQ=;
        b=/OSTOmhI0F9Ns2LuLU4M9LGunENk/fmZBEGTUExRHYK/1UcyLAi1/OFQ+StCGVSzUKvQPj
        rRqNH4Gcucm6qmDg==
Date:   Wed, 08 Jul 2020 21:52:00 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>
Subject: [patch V2 7/7] x86/kvm/vmx: Use native read/write_cr2()
References: <20200708195153.746357686@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

read/write_cr2() go throuh the paravirt XXL indirection, but nested VMX in
a XEN_PV guest is not supported.

Use the native variants.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kvm/vmx/vmx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6683,13 +6683,13 @@ static noinstr void vmx_vcpu_enter_exit(
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

