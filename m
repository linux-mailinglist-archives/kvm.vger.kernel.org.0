Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850FC1AB378
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 23:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730441AbgDOVoh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 17:44:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:2384 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729965AbgDOVoT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 17:44:19 -0400
IronPort-SDR: wFj/djImGxDDMCfplq3+51oEMvM5fDzfHqb/4WjXi15ihaKNsqaj2zsTwwqxrKVqp5rSgEkLlg
 ie57TipOAffg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 14:44:15 -0700
IronPort-SDR: mP2+PDzN60teQtLbePMMO6U7zyS3zNRQVJvl2S2ygWLdn0s77oMWgQjXcYG/cgnesKVh9vUGf3
 esKYMQl9hA8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,388,1580803200"; 
   d="scan'208";a="427584259"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 15 Apr 2020 14:44:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH 0/2] KVM: x86/mmu: Minor cleanup in try_async_pf()
Date:   Wed, 15 Apr 2020 14:44:12 -0700
Message-Id: <20200415214414.10194-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two cleanups with no functional changes.

I'm not 100% on whether or not open coding the private memslot check in
patch 2 is a good idea.  Avoiding the extra memslot lookup is nice, but
that could be done by providing e.g. kvm_is_memslot_visible().  On one
hand, I like deferring the nonexistent and invalid checks to common code,
but on the other hand it creates the possibility of missing some future
case where kvm_is_gfn_visible() adds a check that's not also incoporated
into __gfn_to_hva_many(), though that seems like a rather unlikely
scenario.

Sean Christopherson (2):
  KVM: x86/mmu: Set @writable to false for non-visible accesses by L2
  KVM: x86/mmu: Avoid an extra memslot lookup in try_async_pf() for L2

 arch/x86/kvm/mmu/mmu.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

-- 
2.26.0

