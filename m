Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFADAD7C81
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388304AbfJOQz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:55:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:46844 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbfJOQz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:55:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Oct 2019 09:55:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,300,1566889200"; 
   d="scan'208";a="201811346"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.57])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Oct 2019 09:55:26 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Refactor vcpu creation flow of x86 arch
Date:   Wed, 16 Oct 2019 00:40:29 +0800
Message-Id: <20191015164033.87276-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When reading the vcpu creationg flow of vmx, I find it hard to follow since it
mixes the data structure allocation and initilization together.

This series tries to make the vcpu creation flow more clear that first
allocating data structure and then initializing them. In this way, it helps
move FPU allocation to generic x86 code (Patch 4).

This series intends to do no functional change. I just tested it with
kvm_unit_tests for vmx since I have no AMD machine at hand.

Xiaoyao Li (4):
  KVM: VMX: rename {vmx,nested_vmx}_vcpu_setup functions
  KVM: VMX: Setup MSR bitmap only when has msr_bitmap capability
  KVM: X86: Refactor kvm_arch_vcpu_create
  KVM: X86: Make vcpu's FPU allocation a common function

 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/svm.c              |  81 ++++++---------
 arch/x86/kvm/vmx/nested.c       |   2 +-
 arch/x86/kvm/vmx/nested.h       |   2 +-
 arch/x86/kvm/vmx/vmx.c          | 173 ++++++++++++++------------------
 arch/x86/kvm/x86.c              |  40 ++++++++
 6 files changed, 150 insertions(+), 149 deletions(-)

-- 
2.19.1

