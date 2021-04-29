Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5C936E3C0
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 05:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236863AbhD2DmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 23:42:23 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17049 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbhD2DmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 23:42:22 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FW1S16H0DzPvQL;
        Thu, 29 Apr 2021 11:38:25 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.224) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Thu, 29 Apr 2021 11:41:25 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
CC:     <wanghaibin.wang@huawei.com>
Subject: [PATCH v3 0/2] KVM: x86: Enable dirty logging lazily for huge pages
Date:   Thu, 29 Apr 2021 11:41:13 +0800
Message-ID: <20210429034115.35560-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Currently during start dirty logging, if we're with init-all-set,
we write protect huge pages and leave normal pages untouched, for
that we can enable dirty logging for these pages lazily.

Actually enable dirty logging lazily for huge pages is feasible
too, which not only reduces the time of start dirty logging, also
greatly reduces side-effect on guest when there is high dirty rate.

Thanks,
Keqian

Changelog:

v3:
 - Discussed with Ben and delete RFC comments. Thanks.

Keqian Zhu (2):
  KVM: x86: Support write protect gfn with min_level
  KVM: x86: Not wr-protect huge page with init_all_set dirty log

 arch/x86/kvm/mmu/mmu.c          | 38 ++++++++++++++++++++++++++-------
 arch/x86/kvm/mmu/mmu_internal.h |  3 ++-
 arch/x86/kvm/mmu/page_track.c   |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      | 16 ++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.h      |  3 ++-
 arch/x86/kvm/x86.c              | 37 +++++++++-----------------------
 6 files changed, 57 insertions(+), 42 deletions(-)

-- 
2.23.0

