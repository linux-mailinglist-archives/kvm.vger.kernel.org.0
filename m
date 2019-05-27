Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F9D2B08C
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 10:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfE0Ips convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 27 May 2019 04:45:48 -0400
Received: from prv1-mh.provo.novell.com ([137.65.248.33]:59561 "EHLO
        prv1-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbfE0Ips (ORCPT
        <rfc822;groupwise-kvm@vger.kernel.org:2:1>);
        Mon, 27 May 2019 04:45:48 -0400
Received: from INET-PRV1-MTA by prv1-mh.provo.novell.com
        with Novell_GroupWise; Mon, 27 May 2019 02:45:47 -0600
Message-Id: <5CEBA3B80200007800232856@prv1-mh.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 18.1.1 
Date:   Mon, 27 May 2019 02:45:44 -0600
From:   "Jan Beulich" <JBeulich@suse.com>
To:     "Paolo Bonzini" <pbonzini@redhat.com>,
        "Radim Krm" <rkrcmar@redhat.com>
Cc:     "KVM" <kvm@vger.kernel.org>
Subject: [PATCH] x86/kvm/VMX: drop bad asm() clobber from
 nested_vmx_check_vmentry_hw()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While upstream gcc doesn't detect conflicts on cc (yet), it really
should, and hence "cc" should not be specified for asm()-s also having
"=@cc<cond>" outputs. (It is quite pointless anyway to specify a "cc"
clobber in x86 inline assembly, since the compiler assumes it to be
always clobbered, and has no means [yet] to suppress this behavior.)

Signed-off-by: Jan Beulich <jbeulich@suse.com>

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2781,7 +2781,7 @@ static int nested_vmx_check_vmentry_hw(s
 		[launched]"i"(offsetof(struct loaded_vmcs, launched)),
 		[host_state_rsp]"i"(offsetof(struct loaded_vmcs, host_state.rsp)),
 		[wordsize]"i"(sizeof(ulong))
-	      : "cc", "memory"
+	      : "memory"
 	);
 
 	if (vmx->msr_autoload.host.nr)


