Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02DB25179DE
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 00:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243234AbiEBWW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 18:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbiEBWWZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 18:22:25 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE65CD9B
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 15:18:53 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id fy8-20020a17090b020800b001d8de2118ccso207231pjb.8
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 15:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=TXIIJNLl5tS81cj1e6Sb3BybyFnRD2QLWwcLwhsiYDs=;
        b=Qa0ikLUOxl2s5X8Ry8796VJb+tcDzIXLzrUSN7TnPSNNudW3bfEOQOU0kLfq1hxTfN
         IP0sESs7FFstPfBGMaVlPw3HKJgDcJGjTmkSLqd0UrTUQtGrrOhmhHaEUYguiGrFlYpi
         XX6v9u/nMe9PUrknwsQNDkHoJxoVXIQ2wh/eH25qHwZnKU/rnkU+MdkHiS3BC1oHQHOZ
         ec8cSZKZ6NgLQEGvkV5zimwoWmRB8l7ztqb2//HE10AiNxDZOLT6df1hYp9p/CZGSAN7
         WU8sq/BbQhJhtywBCzi4+sBjdWtrTkNbehr+5R6iHdwswF7JtkjD7Jo+AS2tZUokyc/C
         eXjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=TXIIJNLl5tS81cj1e6Sb3BybyFnRD2QLWwcLwhsiYDs=;
        b=xdJz6tzapaHA1LVRfjZeBj1OZpWIcXeBwA5A1KWOor8e7XhtFYW7ARd98NIjSqKoZQ
         0YqEezTbrlNqjHTIb9QoN0cW+YlarVTZb4tD6odJs3CB879lHGs6tjpehhtTqQfFgtgK
         WxT/M6Ib8ARzC2JIZmtdgEBc/G0AHj/pqi1JKMmpG0iXq+r7QaA+5aIzHPwakY6T7Kzx
         lTsN+hZDsvqo3CunnHzovawQvFQ4/d+hk1e8y0eZDnx6sUmOxQgtPH6RqO9uFVnXBYCj
         t88AoO3IF6E64eQ257LPke45kq1OJi1+JmMZSDZuGsws5o0K0tbhHBsfQvczBeXqDTdx
         Xw8w==
X-Gm-Message-State: AOAM530yqspZ9/9GON6UjpK7Ab+SQY6Ai/zs8qNJKNimRUSxAJPW5X46
        YzSPqvEx1LDdgN0367cpHMlUbt3hYvk=
X-Google-Smtp-Source: ABdhPJzAB+fTD/4HJyBSgaZ6B+/uiqDSapY8Q+Y3yfuxmKFMC3Uamz17CxAwrCKbS6zRQaerkilOVz5CgnQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c986:b0:1d9:56e7:4e83 with SMTP id
 w6-20020a17090ac98600b001d956e74e83mr149900pjt.1.1651529932080; Mon, 02 May
 2022 15:18:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon,  2 May 2022 22:18:50 +0000
Message-Id: <20220502221850.131873-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH] KVM: VMX: Exit to userspace if vCPU has injected exception
 and invalid state
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+cfafed3bb76d3e37581b@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Exit to userspace with an emulation error if KVM encounters an injected
exception with invalid guest state, in addition to the existing check of
bailing if there's a pending exception (KVM doesn't support emulating
exceptions except when emulating real mode via vm86).

In theory, KVM should never get to such a situation as KVM is supposed to
exit to userspace before injecting an exception with invalid guest state.
But in practice, userspace can intervene and manually inject an exception
and/or stuff registers to force invalid guest state while a previously
injected exception is awaiting reinjection.

Fixes: fc4fad79fc3d ("KVM: VMX: Reject KVM_RUN if emulation is required with pending exception")
Reported-by: syzbot+cfafed3bb76d3e37581b@syzkaller.appspotmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cf8581978bce..c41f0ac700c7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5465,7 +5465,7 @@ static bool vmx_emulation_required_with_pending_exception(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	return vmx->emulation_required && !vmx->rmode.vm86_active &&
-	       vcpu->arch.exception.pending;
+	       (vcpu->arch.exception.pending || vcpu->arch.exception.injected);
 }
 
 static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)

base-commit: 84e5ffd045f33e4fa32370135436d987478d0bf7
-- 
2.36.0.464.gb9c8b46e94-goog

