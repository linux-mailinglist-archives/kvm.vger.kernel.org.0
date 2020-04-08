Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA471A1BF9
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 08:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgDHGlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 02:41:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:58629 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgDHGlB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 02:41:01 -0400
IronPort-SDR: b0kAEnnDh1eZ8dI2ucSKQT5OkoPuUXoB4rzSuz6/7M46054ogwz6zCMSY7HtOqeda+QacNfZv2
 4V1rLohnSRmg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2020 23:41:00 -0700
IronPort-SDR: halR6uMpyjoM49Qdt0aAPJ7n+zzxMn4iZIouZHew+0mina4slQBcG5vQzt2/IzvFA3YdG3ct/1
 oc+fArWvMMcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,357,1580803200"; 
   d="scan'208";a="240207988"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 07 Apr 2020 23:40:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+d889b59b2bb87d4047a2@syzkaller.appspotmail.com
Subject: [PATCH 2/2] KVM: s390: Return last valid slot if approx index is out-of-bounds
Date:   Tue,  7 Apr 2020 23:40:59 -0700
Message-Id: <20200408064059.8957-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200408064059.8957-1-sean.j.christopherson@intel.com>
References: <20200408064059.8957-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Return the index of the last valid slot from gfn_to_memslot_approx() if
its binary search loop yielded an out-of-bounds index.  The index can
be out-of-bounds if the specified gfn is less than the base of the
lowest memslot (which is also the last valid memslot).

Note, the sole caller, kvm_s390_get_cmma(), ensures used_slots is
non-zero.

Fixes: afdad61615cc3 ("KVM: s390: Fix storage attributes migration with memory slots")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/s390/kvm/kvm-s390.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 19a81024fe16..5dcf9ff12828 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1939,6 +1939,9 @@ static int gfn_to_memslot_approx(struct kvm_memslots *slots, gfn_t gfn)
 			start = slot + 1;
 	}
 
+	if (start >= slots->used_slots)
+		return slots->used_slots - 1;
+
 	if (gfn >= memslots[start].base_gfn &&
 	    gfn < memslots[start].base_gfn + memslots[start].npages) {
 		atomic_set(&slots->lru_slot, start);
-- 
2.24.1

