Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0CF445FC4
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 07:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbhKEGlE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 02:41:04 -0400
Received: from mx408.baidu.com ([124.64.200.29]:52596 "EHLO
        bddwd-sys-mailin03.bddwd.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231142AbhKEGlC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Nov 2021 02:41:02 -0400
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by bddwd-sys-mailin03.bddwd.baidu.com (Postfix) with ESMTP id EABDC13D00055;
        Fri,  5 Nov 2021 14:37:43 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id DC6BBD9932;
        Fri,  5 Nov 2021 14:37:43 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     kvm@vger.kernel.org, lirongqing@baidu.com
Subject: [PATCH] KVM: x86: check steal time address when enable steal time
Date:   Fri,  5 Nov 2021 14:37:43 +0800
Message-Id: <1636094263-13695-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

check steal time address when enable steal time, disable steal
time if guest gives a wrong address, to avoid unnecessary
write/read invalid memory

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/x86.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2686f2e..8c7f4f4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3440,6 +3440,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data & KVM_STEAL_RESERVED_MASK)
 			return 1;
 
+		if (!kvm_vcpu_gfn_to_memslot(vcpu, data >> PAGE_SHIFT))
+			return 1;
+
 		vcpu->arch.st.msr_val = data;
 
 		if (!(data & KVM_MSR_ENABLED))
-- 
1.7.1

