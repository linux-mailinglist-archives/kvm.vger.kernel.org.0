Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB50E2470F0
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 20:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390418AbgHQSSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 14:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390534AbgHQSRP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 14:17:15 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7697C061342
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 11:17:14 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id z16so11237792pfq.7
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 11:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Q9Urp5Zg/ojVwCnBfwbevPtDZNDnY8XuunFzOx8DVIs=;
        b=r+Qpffn8N6PCB7loSsHOq1dt9znqP2KrseMok4tDGoPV+RB5L+0w6PlHpMv3qML/xG
         As3v2+PiRsirgzzoNjqseL1mrNEw6NzXKwZYcdO2lNI1Nm7qiyj3MzVpm8kxoDdOW4iJ
         Jt/DdUcJptkoQIjPTfxyE4/dnwIEv8iHE8z5uPrplXvcHEGbha89ZVpQHcjk0HdeDBZa
         0PMGK6vVUh+j+kaXkAEYEvVIkWiquHtuzM1PF32v5u+9t+MQ5sZ1jMZ/fog6moM5/dFd
         692B9nm9Y8+W12oHss00gfZZLAwTQOjG3SQGV1paCuxDrb1UH+YzLQvlie4rXSXK8vmm
         w+xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Q9Urp5Zg/ojVwCnBfwbevPtDZNDnY8XuunFzOx8DVIs=;
        b=fJ2kBqMfNMgP1gtWQq3J/y++nJFHevNY4JvPianydACQ9Pq6W8+GMPyae0kNfpC/JG
         3zawUXAKHy460vilqNqvvt9nkKIPRg4KzYKd0cDzDFMqyWJBootKlvxNPmtiwjEdpyLN
         njDD2btLQRbmatk5czldfmcdJo+hgh+SlApuOIDp2BuJACQpyZEkNAr54MlksDaTP5gd
         il4wa/fY7ml3+Tz3ISPdQruLz7Ph/6QJjER5Dh81f1Zo3ce3Nd74rdC6zi5ZlUo7o7oE
         a9ED4nwcHGKcmPaI6RSnO5qhlHloYZtgbaMpKcN70AoIi57ASbCaFr5nIDSVW1hZ73zz
         dw1A==
X-Gm-Message-State: AOAM532QU1wIjj8QkF+LJfAlS/b0lxdIFEPCBWBPba4yUIm5zGWF0eg4
        CGiEdYXgCccT4IUhpu1BiLZYQ0QgcZ8ZEhUNhy1MBWEWEEGOIG+Cbn902+CI201C1JOi8n5/FD5
        QIBM3SDpng+f0jG5GuQtlo5XfbipZJJZrdqW6gSMZL12Ctoq0XWMmQ4YtRL06734=
X-Google-Smtp-Source: ABdhPJyqyBGxKNmVszoTSjP/mYizC+F5KdT0j7N/lvFmDir7y7UR79jV73CUsaUbYmrCwGaLpxknId+QZi4Exg==
X-Received: by 2002:aa7:8608:: with SMTP id p8mr11898432pfn.62.1597688233247;
 Mon, 17 Aug 2020 11:17:13 -0700 (PDT)
Date:   Mon, 17 Aug 2020 11:16:54 -0700
Message-Id: <20200817181655.3716509-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH 1/2] kvm: x86: Toggling CR4.PKE does not load PDPTEs in PAE mode
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Huaitong Han <huaitong.han@intel.com>,
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

Fixes: b9baba8614890 ("KVM, pkeys: expose CPUID/CR4 to guest")
Cc: Huaitong Han <huaitong.han@intel.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 599d73206299..9e427f14e77f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -975,7 +975,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	unsigned long old_cr4 = kvm_read_cr4(vcpu);
 	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
-				   X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE;
+				   X86_CR4_SMEP | X86_CR4_SMAP;
 
 	if (kvm_valid_cr4(vcpu, cr4))
 		return 1;
-- 
2.28.0.220.ged08abb693-goog

