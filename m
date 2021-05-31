Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FEA39669B
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 19:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbhEaRNb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 13:13:31 -0400
Received: from prt-mail.chinatelecom.cn ([42.123.76.227]:40241 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232102AbhEaRLY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 13:11:24 -0400
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 May 2021 13:11:24 EDT
HMM_SOURCE_IP: 172.18.0.48:36278.1609563638
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.38?logid-2b89bfe9d6a14a9583ec07acf9b45452 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id 92446280029;
        Tue,  1 Jun 2021 01:02:46 +0800 (CST)
X-189-SAVE-TO-SEND: +huangy81@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id 2b89bfe9d6a14a9583ec07acf9b45452 for qemu-devel@nongnu.org;
        Tue Jun  1 01:02:47 2021
X-Transaction-ID: 2b89bfe9d6a14a9583ec07acf9b45452
X-filter-score:  filter<0>
X-Real-From: huangy81@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: huangy81@chinatelecom.cn
From:   huangy81@chinatelecom.cn
To:     <qemu-devel@nongnu.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Peter Xu <peterx@redhat.com>, Hyman <huangy81@chinatelecom.cn>
Subject: [PATCH v1 0/6] support dirtyrate at the granualrity of vcpu 
Date:   Tue,  1 Jun 2021 01:02:45 +0800
Message-Id: <cover.1622479161.git.huangy81@chinatelecom.cn>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Hyman Huang(黄勇) <huangy81@chinatelecom.cn>

Since the Dirty Ring on QEMU part has been merged recently, how to use
this feature is under consideration.

In the scene of migration, it is valuable to provide a more accurante
interface to track dirty memory than existing one, so that the upper
layer application can make a wise decision, or whatever. More importantly,
dirtyrate info at the granualrity of vcpu could provide a possibility to
make migration convergent by imposing restriction on vcpu. With Dirty
Ring, we can calculate dirtyrate efficiently and cheaply.

The old interface implemented by sampling pages, it consumes cpu 
resource, and the larger guest memory size become, the more cpu resource
it consumes, namely, hard to scale. New interface has no such drawback.

Please review, thanks !

Best Regards !

Hyman Huang(黄勇) (6):
  KVM: add kvm_dirty_ring_enabled function
  KVM: introduce dirty_pages into CPUState
  migration/dirtyrate: add vcpu option for qmp calc-dirty-rate
  migration/dirtyrate: adjust struct DirtyRateStat
  migration/dirtyrate: check support of calculation for vcpu
  migration/dirtyrate: implement dirty-ring dirtyrate calculation

 accel/kvm/kvm-all.c    |  11 +++
 include/hw/core/cpu.h  |   2 +
 include/sysemu/kvm.h   |   1 +
 migration/dirtyrate.c  | 179 +++++++++++++++++++++++++++++++++++++----
 migration/dirtyrate.h  |  19 ++++-
 migration/trace-events |   1 +
 qapi/migration.json    |  28 ++++++-
 7 files changed, 222 insertions(+), 19 deletions(-)

-- 
2.24.3

