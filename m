Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03282470E8
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 20:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390732AbgHQSRa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 14:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390578AbgHQSRW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 14:17:22 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16330C061389
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 11:17:22 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u2so2626719plz.2
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 11:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=U9+EZytlOJt/Kkaqc/PFAVQgMOHKp5PrDfsBMroqYxs=;
        b=SLo68rlXad6w4YPkRiGwTlNAxFivPAvqW63FOkTr3gQUZKwNnEVLRyNHt22UU05z2I
         jvzATdk757NuX0qWQT40G+32GBVhCHvITwA0CyLVOyKLsLFMPtv1ypXt1lhYeQvMpT2S
         6q8mX7PsBiIBFTJjVoiEhIl6MgVnai2eu8EpTHBQlqkJqOTuiIeHZ8V3TRur2Cngnmy8
         i1XozkeqgC5/iq5GEvh5Buqw+kpowAfSKPBFxh9zLha9NauINvE60z23zhihxzUpQIH9
         pHHgRRKaB1W6YcSL0gOzRVqGj6TqbMhl2fqCMX+O5qm0dGzUi2UfVXwIqQWWWK5qYejm
         F9/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=U9+EZytlOJt/Kkaqc/PFAVQgMOHKp5PrDfsBMroqYxs=;
        b=jL1M+VXD4xXn3tbysnhHXg5ekm73UEG3jR+SN7E/K/b3txJDj4BxJkVv/xobRnaKFZ
         FxMykfEsi/7Rz6mFvRLul2uMmGvZ5PKflEma3jhH9vARpKvlw9kBVvnbdzLaOC29AKNm
         ZYst3/OGNxB4VOA/ZmG5D7F/Z0QCljVphBKoN76hJixuQpVcFZV/PiK09BHRayVoTItX
         B45+PlnbAXxwqXlam2UfJk3MAdBG+JAjMxYTtxPgulVaPgOY7psTvCWgkXhUxyr1dcnl
         s0A25fdqRQmnQMzBPmfmJ12WxOG/Wr6zaauR9wy9huVd99u56/Mas7qKblEV8R5zK9Xf
         F6Jw==
X-Gm-Message-State: AOAM532TrlgvN6adbpl4dQJpfeZl+MBPpS7bOvEUzKQdG7sLo7KjKoqe
        2y2/JzH1cm5A1quhs5lEeAK+D5/kW89yD2VM6BeViLLxYWSyFzBr0vLGbIZrqL/Bp+G+aZvhnk4
        9D1V1tOzXkspsKeFZoVsvR/iSK6QxwUHMXB3uDCDfoay8rOECvZz4iQpw9/C1LA0=
X-Google-Smtp-Source: ABdhPJz6g6yj89JoYSobFHvG9W50WiO4egz9AtKwyMlQY0515KFGMWFDbdg4bieZwQtc46yPoiiEuZFNE8RDrw==
X-Received: by 2002:a17:90a:bd82:: with SMTP id z2mr2856pjr.1.1597688240087;
 Mon, 17 Aug 2020 11:17:20 -0700 (PDT)
Date:   Mon, 17 Aug 2020 11:16:55 -0700
In-Reply-To: <20200817181655.3716509-1-jmattson@google.com>
Message-Id: <20200817181655.3716509-2-jmattson@google.com>
Mime-Version: 1.0
References: <20200817181655.3716509-1-jmattson@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH 2/2] kvm: x86: Toggling CR4.SMAP does not load PDPTEs in PAE mode
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

See the SDM, volume 3, section 4.4.1:

If PAE paging would be in use following an execution of MOV to CR0 or
MOV to CR4 (see Section 4.1.1) and the instruction is modifying any of
CR0.CD, CR0.NW, CR0.PG, CR4.PAE, CR4.PGE, CR4.PSE, or CR4.SMEP; then
the PDPTEs are loaded from the address in CR3.

Fixes: 0be0226f07d14 ("KVM: MMU: fix SMAP virtualization")
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9e427f14e77f..d8f827063c9c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -975,7 +975,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	unsigned long old_cr4 = kvm_read_cr4(vcpu);
 	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
-				   X86_CR4_SMEP | X86_CR4_SMAP;
+				   X86_CR4_SMEP;
 
 	if (kvm_valid_cr4(vcpu, cr4))
 		return 1;
-- 
2.28.0.220.ged08abb693-goog

