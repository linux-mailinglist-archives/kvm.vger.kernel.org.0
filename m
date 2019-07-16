Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5B26B0A6
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 22:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388615AbfGPUy3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 16:54:29 -0400
Received: from mga06.intel.com ([134.134.136.31]:45159 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729031AbfGPUy3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 16:54:29 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 13:54:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,271,1559545200"; 
   d="scan'208";a="169370635"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by fmsmga007.fm.intel.com with ESMTP; 16 Jul 2019 13:54:27 -0700
Date:   Tue, 16 Jul 2019 13:54:27 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Singh, Brijesh" <brijesh.singh@amd.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Fix workaround for AMD Errata 1096
Message-ID: <20190716205427.GD28096@linux.intel.com>
References: <F2442A5C-702A-433D-9156-056E1844F378@oracle.com>
 <20190716164151.GC1987@linux.intel.com>
 <60D01C4B-EC2E-453E-B5F6-BBE8FA94E31D@oracle.com>
 <ce1284de-6088-afd7-ead4-6ef70b89f365@redhat.com>
 <DD44D29C-36C4-42E7-905E-7300F92F3BE6@oracle.com>
 <015b03bc-8518-2066-c916-f5e12dd2d506@amd.com>
 <174F27B9-2C6B-4B9F-8091-56FA85B32BB2@oracle.com>
 <31926848-2cf3-caca-335d-5f3e32a25cd3@amd.com>
 <AAAE41B2-C920-46E5-A171-46428E53FB20@oracle.com>
 <17d102bd-74ef-64f8-0237-3a49d64ea344@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17d102bd-74ef-64f8-0237-3a49d64ea344@amd.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 16, 2019 at 08:27:12PM +0000, Singh, Brijesh wrote:
> 
> On 7/16/19 3:09 PM, Liran Alon wrote:
> >>
> >> We are discussing reserved NPF so we need to be at CPL3.
> > 
> > I don’t see the connection between a reserved #NPF and the need to be at
> > CPL3.  A vCPU can execute at CPL<3 a page that is mapped user-accessible in
> > guest page-tables in case CR4.SMEP=0 and then instruction will execute
> > successfully and can dereference a page that is mapped in NPT using an
> > entry with a reserved bit set.  Thus, reserved #NPF will be raised while
> > vCPU is at CPL<3 and DecodeAssist microcode will still raise SMAP violation
> > as CR4.SMAP=1 and microcode perform data-fetch with CPL<3. This leading
> > exactly to Errata condition as far as I understand.
> > 
> 
> Yes, vCPU at CPL<3 can raise the SMAP violation. When SMEP is disabled,
> the guest kernel never should be executing from code in user-mode pages,
> that'd be insecure. So I am not sure if kernel code can cause this
> errata.

From KVM's perspective, it's not a question of what is *likely* to happen
so much as it's a question of what *can* happen.  Architecturally there is
nothing that prevents CPL<3 code from encountering the SMAP fault.
