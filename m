Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BE03D7431
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 13:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236428AbhG0LVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 07:21:05 -0400
Received: from mx449.baidu.com ([119.249.100.41]:34228 "EHLO mx419.baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236406AbhG0LVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 07:21:04 -0400
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jul 2021 07:21:03 EDT
Received: from unknown.domain.tld (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by mx419.baidu.com (Postfix) with ESMTP id AC3D718182150;
        Tue, 27 Jul 2021 19:12:47 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Subject: [PATCH][v2] KVM: use cpu_relax when halt polling
Date:   Tue, 27 Jul 2021 19:12:47 +0800
Message-Id: <20210727111247.55510-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.9.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SMT siblings share caches and other hardware, and busy halt polling
will degrade its sibling performance if its sibling is working

Sean Christopherson suggested as below:

"Rather than disallowing halt-polling entirely, on x86 it should be
sufficient to simply have the hardware thread yield to its sibling(s)
via PAUSE.  It probably won't get back all performance, but I would
expect it to be close.
This compiles on all KVM architectures, and AFAICT the intended usage
of cpu_relax() is identical for all architectures."

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
diff v1: using cpu_relax, rather that stop halt-polling

 virt/kvm/kvm_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7d95126..1679728 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3110,6 +3110,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 					++vcpu->stat.generic.halt_poll_invalid;
 				goto out;
 			}
+			cpu_relax();
 			poll_end = cur = ktime_get();
 		} while (kvm_vcpu_can_poll(cur, stop));
 	}
-- 
2.9.4

