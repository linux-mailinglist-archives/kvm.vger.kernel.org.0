Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46A14188E5C
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 20:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgCQTx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 15:53:57 -0400
Received: from mga07.intel.com ([134.134.136.100]:43598 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgCQTx4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 15:53:56 -0400
IronPort-SDR: nRHavrib3Ig8MbYf2o0K7mAiL+GxtPrCHGjtf9+LBqMW98TiLHwcohLBGsBAyuNh4DHFO3LtYu
 /o2Po1BrsOoQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2020 12:53:55 -0700
IronPort-SDR: sZRlNPJhdYT1bnnh1jFZqjJuXOWD5N4DSj5+9TdIF+zJ/lntfhmOTcP8eFFn+vt/JaH5koFds3
 Oiq6H8jciBxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,565,1574150400"; 
   d="scan'208";a="233604297"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 17 Mar 2020 12:53:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 0/2] KVM: x86: CPUID tracepoint enhancements
Date:   Tue, 17 Mar 2020 12:53:52 -0700
Message-Id: <20200317195354.28384-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two enhancements to the CPUID tracepoint.  Patch 01 was originally in the
CPUID ranges series, but I unintentionally dropped it in v2.

The final output looks like:

  kvm_cpuid: func 0 idx 0 rax d rbx 68747541 rcx 444d4163 rdx 69746e65, cpuid entry found
  kvm_cpuid: func d idx 444d4163 rax 0 rbx 0 rcx 0 rdx 0, cpuid entry not found
  kvm_cpuid: func 80000023 idx 1 rax f rbx 240 rcx 0 rdx 0, cpuid entry not found, used max basic
  kvm_cpuid: func 80000023 idx 2 rax 100 rbx 240 rcx 0 rdx 0, cpuid entry not found, used max basic

I also considered appending "exact" to the "found" case, which is more
directly what Jan suggested, but IMO "found exact" implies there's also a
"found inexact", which is not true.  AIUI, calling out that KVM is using
the max basic leaf values is what's really important to avoid confusion.

Ideally, the function of the max basic leaf would also be displayed, but
doing that without printing garbage for the other cases is a lot of ugly
code for marginal value.

Sean Christopherson (2):
  KVM: x86: Add requested index to the CPUID tracepoint
  KVM: x86: Add blurb to CPUID tracepoint when using max basic leaf
    values

 arch/x86/kvm/cpuid.c |  9 ++++++---
 arch/x86/kvm/trace.h | 18 ++++++++++++------
 2 files changed, 18 insertions(+), 9 deletions(-)

-- 
2.24.1

