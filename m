Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B0B361B83
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 10:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236787AbhDPIZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 04:25:48 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:17364 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbhDPIZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 04:25:47 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FM8Nv077CzlYCq;
        Fri, 16 Apr 2021 16:23:27 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.224) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Fri, 16 Apr 2021 16:25:13 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
CC:     <wanghaibin.wang@huawei.com>
Subject: [RFC PATCH v2 0/2] KVM: x86: Enable dirty logging lazily for huge pages
Date:   Fri, 16 Apr 2021 16:25:09 +0800
Message-ID: <20210416082511.2856-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently during start dirty logging, if we're with init-all-set,
we write protect huge pages and leave normal pages untouched, for
that we can enable dirty logging for these pages lazily.

Actually enable dirty logging lazily for huge pages is feasible
too, which not only reduces the time of start dirty logging, also
greatly reduces side-effect on guest when there is high dirty rate.

Thanks,
Keqian

Keqian Zhu (2):
  KVM: x86: Support write protect gfn with min_level
  KVM: x86: Not wr-protect huge page with init_all_set dirty log

 arch/x86/kvm/mmu/mmu.c          | 57 ++++++++++++++++++++++++++++-----
 arch/x86/kvm/mmu/mmu_internal.h |  3 +-
 arch/x86/kvm/mmu/page_track.c   |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      | 16 ++++++---
 arch/x86/kvm/mmu/tdp_mmu.h      |  3 +-
 arch/x86/kvm/x86.c              | 37 ++++++---------------
 6 files changed, 76 insertions(+), 42 deletions(-)

-- 
2.23.0

