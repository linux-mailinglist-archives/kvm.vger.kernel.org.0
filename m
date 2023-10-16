Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCB67CAD34
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 17:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbjJPPTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 11:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233721AbjJPPTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 11:19:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A76EE
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 08:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vtO5N+wDv4TrwwTv9zLMoxCNzI1zqbUwBjGBebK9mtU=; b=VytKiJSn6jDj/vFvhCOH+pzA+G
        hNoBp0fpQwayhvdjr2fGGMYnebOK+W9bolWMK3n10K6ocwhz7jBgMf10Dp4DKZgQWM24VmEvfTIsE
        BZb05ZDYRAQ2flMzqF/Wpj+6ewIlRuJG5zXq1par0JIOpljTKHvpNrC8EohvEaqA+jbnW5LlQEdqC
        TMs9W7hXJxB0RczoRR+VMHhxzhgqntDLNFLucvRN+++GPz7esDSR48LH0HkiDfuQDozgqbnwlx3EG
        GObBhsnpZgllt6nksabXqe90NabHtijgMAggzFnDlDfBwqXFegA1Rr1sdawRi/6Q7Ls9L3W7875C/
        CDyI0V6A==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qsPNC-006lqY-2R; Mon, 16 Oct 2023 15:19:14 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qsPNB-0005n8-27;
        Mon, 16 Oct 2023 16:19:13 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org
Subject: [PATCH 01/12] i386/xen: fix per-vCPU upcall vector for Xen emulation
Date:   Mon, 16 Oct 2023 16:18:58 +0100
Message-Id: <20231016151909.22133-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231016151909.22133-1-dwmw2@infradead.org>
References: <20231016151909.22133-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

The per-vCPU upcall vector support had two problems. Firstly it was
using the wrong hypercall argument and would always return -EFAULT.
And secondly it was using the wrong ioctl() to pass the vector to
the kernel and thus the *kernel* would always return -EINVAL.

Linux doesn't (yet) use this mode so it went without decent testing
for a while.

Fixes: 105b47fdf2d0 ("i386/xen: implement HVMOP_set_evtchn_upcall_vector")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 target/i386/kvm/xen-emu.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index c4fa84a982..b49a840438 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -306,7 +306,7 @@ static int kvm_xen_set_vcpu_callback_vector(CPUState *cs)
 
     trace_kvm_xen_set_vcpu_callback(cs->cpu_index, vector);
 
-    return kvm_vcpu_ioctl(cs, KVM_XEN_HVM_SET_ATTR, &xva);
+    return kvm_vcpu_ioctl(cs, KVM_XEN_VCPU_SET_ATTR, &xva);
 }
 
 static void do_set_vcpu_callback_vector(CPUState *cs, run_on_cpu_data data)
@@ -849,8 +849,7 @@ static bool kvm_xen_hcall_hvm_op(struct kvm_xen_exit *exit, X86CPU *cpu,
     int ret = -ENOSYS;
     switch (cmd) {
     case HVMOP_set_evtchn_upcall_vector:
-        ret = kvm_xen_hcall_evtchn_upcall_vector(exit, cpu,
-                                                 exit->u.hcall.params[0]);
+        ret = kvm_xen_hcall_evtchn_upcall_vector(exit, cpu, arg);
         break;
 
     case HVMOP_pagetable_dying:
-- 
2.40.1

