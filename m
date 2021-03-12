Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A93A3383DF
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 03:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbhCLCqH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 21:46:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbhCLCqD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 21:46:03 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9402C061574;
        Thu, 11 Mar 2021 18:46:02 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id 18so867950pfo.6;
        Thu, 11 Mar 2021 18:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=d9YsZjl8KPcCfohTLaB3vMCTcxLud525kwliSzoLjSM=;
        b=PsXU7Bu7iJYGWMkIU7bQZJG8iQo65W9qCJRD/PlehbjzcXSjFIKvERxI5eoVvfN8iA
         UyByTpcv7sPtQOz7myde90AQcpD+gyt+35aN5lTZFjjcATXdx4zr9b/AHKZQK/FRjLQe
         ckOON81qhUkKVvHbfjzNq+XcZD9cm6ZHWXuJvZqbeQmwnfo1PohATwr4XXtGjHE/DcVe
         rLoW2wgMKzFiGmfO4izQty2BnCRtJgr6aWRmprh11dTA/4Bvvvy2DEEM3PUwxD1xO669
         Xllr7o1C3I8bBHBRADfjnBGKHiljHC7NGTpJ1kW7CkiW/8DR3ymAT0w3AwM9T3Gko8jk
         lgBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=d9YsZjl8KPcCfohTLaB3vMCTcxLud525kwliSzoLjSM=;
        b=qFTGZm9fz1satnak4oe50sMbfUlv73nNRYBLKKtD+7tygRGyZ7Vpqpb9Cnxw+wkewM
         VWvEx2Z2nLkDFjuvHNV+zRSWDIUtEhmxOmCUgtDKjD0x9SztlFRyOVBhh32h6pWs139W
         4Y+Nmxs+tYzvyhP6CU0aBQ9pdZWa0EvVgFEIaPmfQCl9mRDMP7knpjdTxEGZcM8kjYjN
         cnsIgbxt1vzS3VEkUxmx9mSGFqGtXajUUmJrH6/Vu0j8DDABB9ucpKIs91UQHfind5l7
         JSGviQ0Ie0yn0mSHux0XHlNasz5wMJuGicQ0wzROp8NKAPIUGP/wgGli+X5CJK3QWLWR
         i4VQ==
X-Gm-Message-State: AOAM533XJ0rI/OxP4lqbfid6rQixDoBL6nLcC3upJr+Txb3mO5j1De6r
        qFGF/g8oQQpkgz0ZMRBlZ+xkC2BUCgE=
X-Google-Smtp-Source: ABdhPJz7xn4dMO2nJjEuZRgkchyM6In2oxsC1ik61xXs99EpuD2rJGq8V6jjGLXAlGM+kunJkU61AA==
X-Received: by 2002:a63:5645:: with SMTP id g5mr9386911pgm.387.1615517162247;
        Thu, 11 Mar 2021 18:46:02 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id e20sm3476846pgm.1.2021.03.11.18.45.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Mar 2021 18:46:01 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Nadav Amit <namit@vmware.com>
Subject: [PATCH] KVM: X86: Fix missing local pCPU when executing wbinvd on all dirty pCPUs
Date:   Fri, 12 Mar 2021 10:45:51 +0800
Message-Id: <1615517151-7465-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

We should execute wbinvd on all dirty pCPUs when guest wbinvd exits 
to maintain datat consistency in order to deal with noncoherent DMA.
smp_call_function_many() does not execute the provided function on 
the local core, this patch replaces it by on_each_cpu_mask().

Reported-by: Nadav Amit <namit@vmware.com>
Cc: Nadav Amit <namit@vmware.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 012d5df..aa6d667 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6638,7 +6638,7 @@ static int kvm_emulate_wbinvd_noskip(struct kvm_vcpu *vcpu)
 		int cpu = get_cpu();
 
 		cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
-		smp_call_function_many(vcpu->arch.wbinvd_dirty_mask,
+		on_each_cpu_mask(vcpu->arch.wbinvd_dirty_mask,
 				wbinvd_ipi, NULL, 1);
 		put_cpu();
 		cpumask_clear(vcpu->arch.wbinvd_dirty_mask);
-- 
2.7.4

