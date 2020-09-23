Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB33927604D
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgIWSoy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:44:54 -0400
Received: from mga07.intel.com ([134.134.136.100]:14506 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726572AbgIWSoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:44:54 -0400
IronPort-SDR: e0/So8Fod/wGXYrSmkcRHgJLjmBa/PSCyUBh3/t4LKDYi8HGUQaUVVENF7YnxzLq50Q45YkNvu
 qhX1ckkkGkbg==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="225124469"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="225124469"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:44:53 -0700
IronPort-SDR: AG21uKJ436RIhpwWxjdI38cfG5EviAAvcqTu/07YPugVMhGwvDhfNfrDpdU+xlWpNDW1tcwOgi
 te3FdDBE8Dtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="347457640"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Sep 2020 11:44:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Cross <dcross@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH v2 0/7]  KVM: nVMX: Bug fixes and cleanup
Date:   Wed, 23 Sep 2020 11:44:45 -0700
Message-Id: <20200923184452.980-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix for a brutal segment caching bug that manifested as random nested
VM-Enter failures when running with unrestricted guest disabled.  A few
more bug fixes and cleanups for stuff found by inspection when hunting
down the caching issue.

v2:
  - Rebased to kvm/queue, commit e1ba1a15af73 ("KVM: SVM: Enable INVPCID
    feature on AMD").

Sean Christopherson (7):
  KVM: nVMX: Reset the segment cache when stuffing guest segs
  KVM: nVMX: Reload vmcs01 if getting vmcs12's pages fails
  KVM: nVMX: Explicitly check for valid guest state for !unrestricted
    guest
  KVM: nVMX: Move free_nested() below vmx_switch_vmcs()
  KVM: nVMX: Ensure vmcs01 is the loaded VMCS when freeing nested state
  KVM: nVMX: Drop redundant VMCS switch and free_nested() call
  KVM: nVMX: WARN on attempt to switch the currently loaded VMCS

 arch/x86/kvm/vmx/nested.c | 103 ++++++++++++++++++++------------------
 arch/x86/kvm/vmx/vmx.c    |   8 +--
 arch/x86/kvm/vmx/vmx.h    |   9 ++++
 3 files changed, 65 insertions(+), 55 deletions(-)

-- 
2.28.0

