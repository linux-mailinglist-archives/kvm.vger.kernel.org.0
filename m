Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AABD1A6FEE
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 02:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390367AbgDNAJ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 20:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727878AbgDNAJy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Apr 2020 20:09:54 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2132C0A3BDC
        for <kvm@vger.kernel.org>; Mon, 13 Apr 2020 17:09:53 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id e22so9947261pgm.22
        for <kvm@vger.kernel.org>; Mon, 13 Apr 2020 17:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TB3th6I+XkdOIx1ebBel5qlm5SBKsAmVepxQYdzaNw4=;
        b=MWXa4WfyJWvaR/P15uWGhFniHKPqDgqRJX0AeehyuQDYRcVZ7iZBRAl7zhE78lyI/z
         inFDe+Iz/QQ/+2ZzNqE3bS4dLK+SLYAerXUXz8c9dPhN632LpHlVlMF0tM05OXsryPAV
         xflX6nv56hx2feSrb0pSGaGY1HMgHqqu+Q/BGruFbCWI8yMmGeNOZt3xTNHAHHBE1Lkc
         rx+JhWKlpVsQRXKgMML79IXZ0e2qjciT2nXVkcZoM3xMCzcewn8gTqWHFP5Wo1QZr3JY
         pTF8Qmy/SA6I4ebnex9C8v1Ke3ZfJ3X7Aa+K5sOdPnpajfvnPK18gOV593pZPB23rHq1
         +1hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TB3th6I+XkdOIx1ebBel5qlm5SBKsAmVepxQYdzaNw4=;
        b=hp++H5yB/I54stdTJzl0dnE6zUxf6P6UjU1Iv70mt/d9BrMG/LtRajedvQ1GcLUwXO
         UWZUQ6H/3f+srQv7ukFszLAyu5VLM1H3z7lHA0yhVfWY/+h4fWf8sZHI+8B3oep2rThB
         mBar7/MD8y925GOvtCdHcDuOhzOpKvA7cdG5EYpJmFBJRQRGb3H33bgETAVayfDhTaRi
         WBDQRKK/gPxqGoJDNReliV3ZeX9KPygQey/6gRcVm5D75aXLid0VsDTJVeKPTsYClyBM
         DR6dWDxwNkrgtbfG2WYck43RF0elly4TaATnS0THrdRCXeAgitdiC6oo9JWpT84wcWI9
         Fr0w==
X-Gm-Message-State: AGi0PuaZewkB7Nmh8emQX4MqarQgz747V5Z8daaQRkM71GKbio+btVUg
        0Xlbbh578qepUZoSJJacNChGuLZI0TrTtayLoV7GkBmMMvP1rXYrQxq3CrFTivSSg5ExzQXLj50
        2VQ3xbSlVJmoEq/DNMyJX9Z0111Q4RhFXfq1VLGFI4tbkHxaYitissNlqrL6BlbY=
X-Google-Smtp-Source: APiQypLQ7zRZisIGqR/m/NLS6Aq5tQl8Fh8g7ZA2pL8fT0nwxtL0cfByU7sbebLEh1FdpWEJkxwozu9bRdBJQg==
X-Received: by 2002:a17:90a:c78b:: with SMTP id gn11mr24122032pjb.147.1586822993391;
 Mon, 13 Apr 2020 17:09:53 -0700 (PDT)
Date:   Mon, 13 Apr 2020 17:09:46 -0700
In-Reply-To: <20200414000946.47396-1-jmattson@google.com>
Message-Id: <20200414000946.47396-2-jmattson@google.com>
Mime-Version: 1.0
References: <20200414000946.47396-1-jmattson@google.com>
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [PATCH 2/2] kvm: nVMX: Single-step traps trump expired VMX-preemption timer
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Previously, if the hrtimer for the nested VMX-preemption timer fired
while L0 was emulating an L2 instruction with RFLAGS.TF set, the
synthesized single-step trap would be unceremoniously dropped when
synthesizing the "VMX-preemption timer expired" VM-exit from L2 to L1.

To fix this, don't synthesize a "VMX-preemption timer expired" VM-exit
from L2 to L1 when there is a pending debug trap, such as a
single-step trap.

Fixes: f4124500c2c13 ("KVM: nVMX: Fully emulate preemption timer")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/vmx/nested.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index cbc9ea2de28f..6ab974debd44 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3690,7 +3690,9 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	    vmx->nested.preemption_timer_expired) {
 		if (block_nested_events)
 			return -EBUSY;
-		nested_vmx_vmexit(vcpu, EXIT_REASON_PREEMPTION_TIMER, 0, 0);
+		if (!vmx_pending_dbg_trap(vcpu))
+			nested_vmx_vmexit(vcpu, EXIT_REASON_PREEMPTION_TIMER,
+					  0, 0);
 		return 0;
 	}
 
-- 
2.26.0.110.g2183baf09c-goog

