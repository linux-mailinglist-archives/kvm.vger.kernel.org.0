Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 078986B00B
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 21:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbfGPTpg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 15:45:36 -0400
Received: from mga12.intel.com ([192.55.52.136]:45443 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbfGPTpg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 15:45:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 12:45:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,271,1559545200"; 
   d="scan'208";a="366771520"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by fmsmga006.fm.intel.com with ESMTP; 16 Jul 2019 12:45:35 -0700
Date:   Tue, 16 Jul 2019 12:45:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
Message-ID: <20190716194535.GB28096@linux.intel.com>
References: <CF48BCA4-4BC8-4AC8-8B48-85FA29E16719@oracle.com>
 <f6c78d65-70fc-4a79-44db-6abb0434db73@amd.com>
 <F2442A5C-702A-433D-9156-056E1844F378@oracle.com>
 <20190716164151.GC1987@linux.intel.com>
 <60D01C4B-EC2E-453E-B5F6-BBE8FA94E31D@oracle.com>
 <ce1284de-6088-afd7-ead4-6ef70b89f365@redhat.com>
 <DD44D29C-36C4-42E7-905E-7300F92F3BE6@oracle.com>
 <015b03bc-8518-2066-c916-f5e12dd2d506@amd.com>
 <174F27B9-2C6B-4B9F-8091-56FA85B32BB2@oracle.com>
 <3cdd12c4-c3fa-5157-1a91-69e333750152@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cdd12c4-c3fa-5157-1a91-69e333750152@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 16, 2019 at 09:39:48PM +0200, Paolo Bonzini wrote:
> On 16/07/19 21:34, Liran Alon wrote:
> >> When this errata is hit, the CPU will be at CPL3. From hardware
> >> point-of-view the below sequence happens:
> >>
> >> 1. CPL3 guest hits reserved bit NPT fault (MMIO access)
> > Why CPU needs to be at CPL3?
> > The requirement for SMAP should be that this page is user-accessible in guest page-tables.
> > Think on a case where guest have CR4.SMAP=1 and CR4.SMEP=0.
> > 
> 
> If you are not at CPL3, you'd get a SMAP NPF, not a RSVD NPF.

I think Liran is right.  When software is executing, the %rip access is
a code fetch (SMEP), but the ucode assist is a data access (SMAP).

This likely has only been observed in a CPL3 scenario because no sane OS
exercises the case of the kernel executing from a user page with SMAP=1
and SMEP=0.
