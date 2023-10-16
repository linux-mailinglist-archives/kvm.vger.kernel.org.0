Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F747CAD45
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 17:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbjJPPTy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 11:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbjJPPTr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 11:19:47 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50207F1
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 08:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=iXDULQVzCobMyEZ4WUylbwZd7CUi+M/tuPLUTKt/3jw=; b=l1d5jbcw6JNVUwXd23LtcOWIrz
        awoQAWR2TcM4l7zFuNYfHDL5IW5doK4mER0sDrz9GFfi7g/6TGn1GKF7Nh4SXaBj7lExkZqV/6OBu
        BFw1UTrhAyKXsOt9PwCTU2pMxqKJdP2htFgualbxn+lvN/uSw/zpRypzgvobUd3b+niKIDlRnOUN0
        y25iFrORunLd1zKmTJ4gAmMrkYqYU3tM4LCEhYMpEqbeBcCd11W2GY5HtBdadVn3PG+6tuK2XfGfg
        nLsgelc99k1Us9mOk0LZPdAD9438EocKtKfbD+cMKYAq2PLkAUu3jedsBUI2LXJKDiK3BJ8DZHlBK
        82Uotnsw==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qsPNB-0067AH-2I;
        Mon, 16 Oct 2023 15:19:15 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qsPNB-0005nK-2S;
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
Subject: [PATCH 04/12] i386/xen: advertise XEN_HVM_CPUID_UPCALL_VECTOR in CPUID
Date:   Mon, 16 Oct 2023 16:19:01 +0100
Message-Id: <20231016151909.22133-5-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231016151909.22133-1-dwmw2@infradead.org>
References: <20231016151909.22133-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

This will allow Linux guests (since v6.0) to use the per-vCPU upcall
vector delivered as MSI through the local APIC.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 target/i386/kvm/kvm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index f6c7f7e268..8bdbdcdffe 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1887,6 +1887,10 @@ int kvm_arch_init_vcpu(CPUState *cs)
                 c->eax |= XEN_HVM_CPUID_VCPU_ID_PRESENT;
                 c->ebx = cs->cpu_index;
             }
+
+            if (cs->kvm_state->xen_version >= XEN_VERSION(4, 17)) {
+                c->eax |= XEN_HVM_CPUID_UPCALL_VECTOR;
+            }
         }
 
         r = kvm_xen_init_vcpu(cs);
-- 
2.40.1

