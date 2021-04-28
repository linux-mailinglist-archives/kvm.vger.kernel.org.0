Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B4336D083
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 04:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239585AbhD1CWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 22:22:49 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:34802 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239572AbhD1CWt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Apr 2021 22:22:49 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=zelin.deng@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UX0thWn_1619576521;
Received: from localhost(mailfrom:zelin.deng@linux.alibaba.com fp:SMTPD_---0UX0thWn_1619576521)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 28 Apr 2021 10:22:01 +0800
From:   Zelin Deng <zelin.deng@linux.alibaba.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Subject: [PATCH] KVM: x86: Update vCPU's hv_clock before back to guest when tsc_offset is adjusted
Date:   Wed, 28 Apr 2021 10:22:01 +0800
Message-Id: <1619576521-81399-2-git-send-email-zelin.deng@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619576521-81399-1-git-send-email-zelin.deng@linux.alibaba.com>
References: <1619576521-81399-1-git-send-email-zelin.deng@linux.alibaba.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When MSR_IA32_TSC_ADJUST is written by guest due to TSC ADJUST feature
especially there's a big tsc warp (like a new vCPU is hot-added into VM
which has been up for a long time), tsc_offset is added by a large value
then go back to guest. This causes system time jump as tsc_timestamp is
not adjusted in the meantime and pvclock monotonic character.
To fix this, just notify kvm to update vCPU's guest time before back to
guest.

Cc: stable@vger.kernel.org
Signed-off-by: Zelin Deng <zelin.deng@linux.alibaba.com>
---
 arch/x86/kvm/x86.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index efc7a82..f03294f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3095,6 +3095,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if (!msr_info->host_initiated) {
 				s64 adj = data - vcpu->arch.ia32_tsc_adjust_msr;
 				adjust_tsc_offset_guest(vcpu, adj);
+				/* Before back to guest, tsc_timestamp must be adjusted
+				 * as well, otherwise guest's percpu pvclock time could jump.
+				 */
+				kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 			}
 			vcpu->arch.ia32_tsc_adjust_msr = data;
 		}
-- 
1.8.3.1

