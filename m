Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A64B16ACF4
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 18:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388035AbfGPQlw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 12:41:52 -0400
Received: from mga06.intel.com ([134.134.136.31]:27740 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726722AbfGPQlw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 12:41:52 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 09:41:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,498,1557212400"; 
   d="scan'208";a="169980568"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by orsmga003.jf.intel.com with ESMTP; 16 Jul 2019 09:41:51 -0700
Date:   Tue, 16 Jul 2019 09:41:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
Message-ID: <20190716164151.GC1987@linux.intel.com>
References: <20190715203043.100483-1-liran.alon@oracle.com>
 <20190715203043.100483-2-liran.alon@oracle.com>
 <1ef0f594-2039-1aeb-4fe0-edbc21fa1f60@amd.com>
 <CF48BCA4-4BC8-4AC8-8B48-85FA29E16719@oracle.com>
 <f6c78d65-70fc-4a79-44db-6abb0434db73@amd.com>
 <F2442A5C-702A-433D-9156-056E1844F378@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F2442A5C-702A-433D-9156-056E1844F378@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 16, 2019 at 07:20:42PM +0300, Liran Alon wrote:
> How can a SMAP fault occur when CPL==3? One of the conditions for SMAP is
> that CPL<3.

The CPU is effectively at CPL0 when it does the decode assist, e.g.:

  1. CPL3 guest hits reserved bit NPT fault (MMIO access)
  2. CPU transitions to CPL0 on VM-Exit
  3. CPU performs data access on **%rip**, encounters SMAP violation
  4. CPU squashes SMAP violation, sets VMCB.insn_len=0
  5. CPU delivers VM-Exit to software for original NPT fault

The original NPT fault is due to a reserved bit (or not present) entry for
a MMIO GPA, *not* the GPA corresponding to %rip.  The fault on the decode
assist is never delivered to software, it simply results in having invalid
info in the VMCB's insn_bytes and insn_len fields.
