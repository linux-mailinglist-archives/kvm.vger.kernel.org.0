Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C2257EAC6
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 02:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236896AbiGWAwg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 20:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236654AbiGWAwA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 20:52:00 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FB48F530
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:51:55 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id k11-20020a170902ce0b00b0016a15fe2627so3443163plg.22
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=nzU1XzUnvE/6/rujCQjEFEDszI5LMFfOZskmJLapFUU=;
        b=rwyEJY+R06LW0SE9ENmhj1dnegcwD3lH+JcfwdvFbMfKniXKroCaELMEMHeVlmmTcM
         IiTBsKM35kKpaW/WvhZgwlXl16dbEIuvC5pZIjyIn/W4hgiEe4ey3b98yEc0c4pxCYAX
         yuhjccpbTM7GpzKwJyF7DV0MHoWpZ98aLFZgJTB6fLC8TTG3/kb4i1Uva86+YqXqZvIi
         XwBSFuNussSDnk6FKO6xZ0Eo/jr6/mi7We6/iz+6t05ti0Q3IWqYVbmZsfB0Ieto2Sbd
         d1MqMan3aclEQYTkylhQMcS4BqlxSG68Hj4lINKaZNi1Mjx/EN7a2SgumszcyP7GQ2yc
         U7JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=nzU1XzUnvE/6/rujCQjEFEDszI5LMFfOZskmJLapFUU=;
        b=dcy8M6cguDACTFTK3UNjp4Ajt65cZgsgzex/aK9+2Z9qiMxoXjJPDL+jv7inVCoTWh
         TQpBgFNPt+6KaLfQ4NGRQ6QGnpnhkeTJ0a2xtTK+kPLJ3GyrveGYYYJX1LcTMtVW5fmj
         iqsbiJDYfPqVF133dcTBo4s5yf1g8KrQtxN/vwd28USZRPFk0vZGp89bVwKevozwN9YQ
         oc/teGcrx7RSM/wHvrZXw2J0TYlPKnFI4u1taFmPT+3oDXsilZ3gsDQV1h03VTGheo7E
         ZB3EviG3iwfHyAiDbK3mJYczwbbBEhcnaVGs1tb9DXZjtKffeF0YKRvzvosO/ahVzgt+
         6qwQ==
X-Gm-Message-State: AJIora8pgn4i22WZW3N6mrmsVmYJMqCxBHpmXzKSzqcxDVwOKQK+JE/o
        YchMct0BgJ3vW+A/mouEe6VoaQxVHIo=
X-Google-Smtp-Source: AGRyM1vkgClrTi4iNH0srLgiv2Bw6T6Hr6KVH+F8Lz8n6WFnaJ8ZR8ghp/OylcC2I4Ebr3p6LQjCEgDldOo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:16ce:0:b0:528:c4c7:972f with SMTP id
 197-20020a6216ce000000b00528c4c7972fmr2456794pfw.55.1658537515264; Fri, 22
 Jul 2022 17:51:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Jul 2022 00:51:21 +0000
In-Reply-To: <20220723005137.1649592-1-seanjc@google.com>
Message-Id: <20220723005137.1649592-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220723005137.1649592-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v4 08/24] KVM: nVMX: Ignore SIPI that arrives in L2 when vCPU
 is not in WFS
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fall through to handling other pending exception/events for L2 if SIPI
is pending while the CPU is not in Wait-for-SIPI.  KVM correctly ignores
the event, but incorrectly returns immediately, e.g. a SIPI coincident
with another event could lead to KVM incorrectly routing the event to L1
instead of L2.

Fixes: bf0cd88ce363 ("KVM: x86: emulate wait-for-SIPI and SIPI-VMExit")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6b4368d96d9e..46ea7740bb9e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3932,10 +3932,12 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 			return -EBUSY;
 
 		clear_bit(KVM_APIC_SIPI, &apic->pending_events);
-		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED)
+		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
 			nested_vmx_vmexit(vcpu, EXIT_REASON_SIPI_SIGNAL, 0,
 						apic->sipi_vector & 0xFFUL);
-		return 0;
+			return 0;
+		}
+		/* Fallthrough, the SIPI is completely ignored. */
 	}
 
 	/*
-- 
2.37.1.359.gd136c6c3e2-goog

