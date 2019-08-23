Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38AF79B856
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 23:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393247AbfHWVzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 17:55:22 -0400
Received: from mga12.intel.com ([192.55.52.136]:43389 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388000AbfHWVzW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 17:55:22 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 14:55:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,422,1559545200"; 
   d="scan'208";a="263305949"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 23 Aug 2019 14:55:21 -0700
Date:   Fri, 23 Aug 2019 14:55:21 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 04/13] KVM: x86: Drop EMULTYPE_NO_UD_ON_FAIL as a
 standalone type
Message-ID: <20190823215521.GD24772@linux.intel.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com>
 <20190823010709.24879-5-sean.j.christopherson@intel.com>
 <4993FDBF-6641-43E9-BCEE-7F5FE58561E9@oracle.com>
 <CB2B4523-AA0C-4931-BD1E-9F63FA114EF0@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CB2B4523-AA0C-4931-BD1E-9F63FA114EF0@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 23, 2019 at 04:32:05PM +0300, Liran Alon wrote:
> 
> > On 23 Aug 2019, at 16:21, Liran Alon <liran.alon@oracle.com> wrote:
> > 
> >> On 23 Aug 2019, at 4:07, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> >> 
> >> The "no #UD on fail" is used only in the VMWare case, and for the VMWare
> >> scenario it really means "#GP instead of #UD on fail".  Remove the flag
> >> in preparation for moving all fault injection into the emulation flow
> >> itself, which in turn will allow eliminating EMULATE_DONE and company.
> >> 
> >> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > When I created the commit which introduced this e23661712005 ("KVM: x86:
> > Add emulation_type to not raise #UD on emulation failure") I intentionally
> > introduced a new flag to emulation_type instead of using EMULTYPE_VMWARE as
> > I thought it’s weird to couple this behaviour specifically with VMware
> > emulation.  As it made sense to me that there could be more scenarios in
> > which some VMExit handler would like to use the x86 emulator but in case of
> > failure want to decide what would be the failure handling from the outside.
> > I also didn’t want the x86 emulator to be aware of VMware interception
> > internals.
> > 
> > Having said that, one could argue that the x86 emulator already knows about
> > the VMware interception internals because of how x86_emulate_instruction()
> > use is_vmware_backdoor_opcode() and from the mere existence of
> > EMULTYPE_VMWARE. So I think it’s legit to decide that we will just move all
> > the VMware interception logic into the x86 emulator. Including handling
> > emulation failures. But then, I would make this patch of yours to also
> > modify handle_emulation_failure() to queue #GP to guest directly instead of
> > #GP intercept in VMX/SVM to do so.  I see you do it in a later patch "KVM:
> > x86: Move #GP injection for VMware into x86_emulate_instruction()" but I
> > think this should just be squashed with this patch to make sense.
> > 
> > To sum-up, I agree with your approach but I recommend you squash this patch
> > and patch 6 of the series to one and change commit message to explain that
> > you just move entire handling of VMware interception into the x86 emulator.
> > Instead of providing explanations such as VMware emulation is the only one
> > that use “no #UD on fail”.
> 
> After reading patch 5 as-well, I would recommend to first apply patch 5
> (filter out #GP with error-code != 0) and only then apply 4+6.

Works for me.
