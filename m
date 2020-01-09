Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC2DD136416
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 00:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729714AbgAIX4W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 18:56:22 -0500
Received: from mga05.intel.com ([192.55.52.43]:55945 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729649AbgAIX4W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 18:56:22 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 15:56:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="246828479"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 09 Jan 2020 15:56:21 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Andrew Honig <ahonig@google.com>,
        Barret Rhoden <brho@google.com>
Subject: [PATCH 0/3] KVM: Clean up guest/host cache read/write code
Date:   Thu,  9 Jan 2020 15:56:17 -0800
Message-Id: <20200109235620.6536-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Minor cleanup to fix the underlying crustiness that led to an uninitialized
variable warning reported by Barret.

The first two patches are tagged with Fixes:, but I don't know that they're
actually worth backporting to stable.  Functionally, everthing works, it's
just a bit weird and AFAICT not what is intended.  It might be preferable
to take Barret's patch[*] first and only mark that for stable, as it fixes
the immediate issue without revamping __kvm_gfn_to_hva_cache_init().

[*] https://lkml.kernel.org/r/20200109195855.17353-1-brho@google.com

Sean Christopherson (3):
  KVM: Check for a bad hva before dropping into the ghc slow path
  KVM: Clean up __kvm_gfn_to_hva_cache_init() and its callers
  KVM: Return immediately if __kvm_gfn_to_hva_cache_init() fails

 virt/kvm/kvm_main.c | 45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

-- 
2.24.1

