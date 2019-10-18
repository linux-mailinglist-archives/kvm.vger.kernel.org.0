Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41C0CDBB4F
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 03:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409479AbfJRB3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 21:29:14 -0400
Received: from mga18.intel.com ([134.134.136.126]:24410 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391934AbfJRB3O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 21:29:14 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2019 18:29:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,309,1566889200"; 
   d="scan'208";a="226377085"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga002.fm.intel.com with ESMTP; 17 Oct 2019 18:29:11 -0700
Date:   Fri, 18 Oct 2019 09:32:11 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v7 7/7] KVM: x86: Add user-space access interface for CET
 MSRs
Message-ID: <20191018013211.GC2286@local-michael-cet-test>
References: <20190927021927.23057-1-weijiang.yang@intel.com>
 <20190927021927.23057-8-weijiang.yang@intel.com>
 <CALMp9eQNDNmmCr8DM-2fMVYvQ-eTEpeE=bW8+BLbfxmBsTmQvg@mail.gmail.com>
 <20191017195811.GK20903@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017195811.GK20903@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 17, 2019 at 12:58:11PM -0700, Sean Christopherson wrote:
> On Wed, Oct 02, 2019 at 01:57:50PM -0700, Jim Mattson wrote:
> > On Thu, Sep 26, 2019 at 7:17 PM Yang Weijiang <weijiang.yang@intel.com> wrote:
> > >
> > > There're two different places storing Guest CET states, the states
> > > managed with XSAVES/XRSTORS, as restored/saved
> > > in previous patch, can be read/write directly from/to the MSRs.
> > > For those stored in VMCS fields, they're access via vmcs_read/
> > > vmcs_write.
> > >
> > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > > ---
> > >  arch/x86/kvm/vmx/vmx.c | 83 ++++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 83 insertions(+)
> > >
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 44913e4ab558..5265db7cd2af 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -1671,6 +1671,49 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
> > >         return 0;
> > >  }
> > >
> > > +static int check_cet_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > 
> > I'd suggest changing return type to bool, since you are essentially
> > returning true or false.
> 
> I'd also be more explicit in the name, e.g. is_valid_cet_msr().
Sure, thank you two.
