Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA84434760
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 10:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhJTIzl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 04:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhJTIzk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 04:55:40 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC54EC06161C;
        Wed, 20 Oct 2021 01:53:26 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d9so2356018pfl.6;
        Wed, 20 Oct 2021 01:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=DstmdxqQBhlt++xah38eM3RnFp7UHOdrRmQoIgCg+34=;
        b=nmcENzGLEY0g/VDHyHNb+r0gOnPcveOEu5q0HoJ0z+f5DWQuZrxHlIg/2ozA/BnBBE
         SboQjj2YhJJ5eVsDX32b8fzleeBb3NlExDwID/JHs3Y7sjVnwh+BjLPeoeYKxl5PezRP
         i0qwvlpnsaBuW7GkIHl0t3ZWsCeeYXyKsY/WZ3kbUIBXvhcnBzoflWIjdfn1S26uv8wN
         MqU+XudN8v2CUIy7tiQxPSOiNAXJl3UetVdt48ZpbonlJ0fTIVNSEJ+4KUUaOpBAGrvn
         zrMYoMU5C2x6XMJRO6ahTFokb99urpm3gUNU+V4gy/JALdEyH962Ad9pwbnFt5s7z7o/
         WZng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DstmdxqQBhlt++xah38eM3RnFp7UHOdrRmQoIgCg+34=;
        b=gc4HuUOdNeRUpzkvEABoE2XjgfjFGYynBFtwt+zmRjZ2QRhbsAo9SbhA2XVg4O08cq
         GEajX+4WzqgnVARKY9zRVLTt0c+RnzYHQtYFAmLmLsToTpCsv3kxcUI0WZuPMQ3bD2NS
         eIAoP2CgOcyRIL2lIO6BNJ9nqBGHidOeVXwj+t3NAnHnf0CphF4ztsZdcMefhVmk7LKl
         jrg00HFoCRjas0tqmNQC/DwAeZR6tmqm4+Y5HoercXkE4smWhn0T/bvSaZHxupVMsrNa
         l5usF7uJ/KBu9lyKlWeGp1Uc8uLmp9kQe0UJH7tivUY3J1zFXMAC3Y1wv3TBoCU0u+pZ
         o/Vg==
X-Gm-Message-State: AOAM531lOLzmgcQ3OqYPyBPLG8ICl/j6bDUNBYIFzJrdANry738ZmvJb
        1Mo9vN3wDwSWUZ7Jq5V4WmTF7EEseg99vw==
X-Google-Smtp-Source: ABdhPJwH+YtWjzrqw1vko7XW92fdaOn1IzU7xP50eFZOJIPsoVkiSna56fjWz4mA1sfEJGkVdEOyKw==
X-Received: by 2002:a05:6a00:15c9:b0:44c:a998:b50d with SMTP id o9-20020a056a0015c900b0044ca998b50dmr4976922pfu.49.1634720006101;
        Wed, 20 Oct 2021 01:53:26 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.googlemail.com with ESMTPSA id x7sm5109552pjl.55.2021.10.20.01.53.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Oct 2021 01:53:25 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v4] KVM: emulate: Don't inject #GP when emulating RDMPC if CR0.PE=0
Date:   Wed, 20 Oct 2021 01:52:31 -0700
Message-Id: <1634719951-73285-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

SDM mentioned that we should #GP for rdpmc if ECX is not valid or 
(CR4.PCE is 0 and CPL is 1, 2, or 3 and CR0.PE is 1).

Let's add the CR0.PE is 1 checking to rdpmc emulate, though this isn't
strictly necessary since it's impossible for CPL to be >0 if CR0.PE=0.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v3 -> v4:
 * add comments instead of pseudocode
v2 -> v3:
 * add the missing 'S'
v1 -> v2:
 * update patch description

 arch/x86/kvm/emulate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 9a144ca8e146..ab7ec569e8c9 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4213,6 +4213,7 @@ static int check_rdtsc(struct x86_emulate_ctxt *ctxt)
 static int check_rdpmc(struct x86_emulate_ctxt *ctxt)
 {
 	u64 cr4 = ctxt->ops->get_cr(ctxt, 4);
+	u64 cr0 = ctxt->ops->get_cr(ctxt, 0);
 	u64 rcx = reg_read(ctxt, VCPU_REGS_RCX);
 
 	/*
@@ -4222,7 +4223,7 @@ static int check_rdpmc(struct x86_emulate_ctxt *ctxt)
 	if (enable_vmware_backdoor && is_vmware_backdoor_pmc(rcx))
 		return X86EMUL_CONTINUE;
 
-	if ((!(cr4 & X86_CR4_PCE) && ctxt->ops->cpl(ctxt)) ||
+	if ((!(cr4 & X86_CR4_PCE) && ctxt->ops->cpl(ctxt) && (cr0 & X86_CR0_PE)) ||
 	    ctxt->ops->check_pmc(ctxt, rcx))
 		return emulate_gp(ctxt, 0);
 
-- 
2.25.1

