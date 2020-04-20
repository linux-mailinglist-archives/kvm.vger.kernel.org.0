Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE51F1B0F8B
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 17:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730222AbgDTPMM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 11:12:12 -0400
Received: from mga05.intel.com ([192.55.52.43]:20412 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730203AbgDTPMK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 11:12:10 -0400
IronPort-SDR: MVGG65zJ1AR37cZ8HD7xyoHDSHvFtYUIV37YQPBu848K3g/6E7Oucrz29eRfU8ysOocwevX/Z8
 mnjIMHopHf5g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 08:12:08 -0700
IronPort-SDR: fjvusSzbVWPR/v4yhL4s1hcLQLK1iQ/5M+MxwRZQ5BRCWInNSb3yqeaSXk48+QZfB8UVUAELSL
 5cRdpBIBP0jQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,406,1580803200"; 
   d="scan'208";a="258374088"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 20 Apr 2020 08:12:08 -0700
Date:   Mon, 20 Apr 2020 08:12:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] KVM: nVMX: KVM needs to unset "unrestricted
 guest" VM-execution control in vmcs02 if vmcs12 doesn't set it
Message-ID: <20200420151207.GB9279@linux.intel.com>
References: <20200415183047.11493-1-krish.sadhukhan@oracle.com>
 <20200415183047.11493-2-krish.sadhukhan@oracle.com>
 <20200415193016.GF30627@linux.intel.com>
 <CALMp9eRvZEzi3Ug0fL=ekMS_Weni6npwW+bXrJZjU8iLrppwEg@mail.gmail.com>
 <0b8bd238-e60f-b392-e793-0d88fb876224@redhat.com>
 <d49ce960-92f9-85eb-4cfb-d533a956223e@oracle.com>
 <20200418015545.GB15609@linux.intel.com>
 <c37b9429-0cb8-6514-44a7-65544873dba0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c37b9429-0cb8-6514-44a7-65544873dba0@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 18, 2020 at 11:53:36AM +0200, Paolo Bonzini wrote:
> On 18/04/20 03:55, Sean Christopherson wrote:
> > 
> >   static inline bool is_unrestricted_guest(struct kvm_vcpu *vcpu)
> >   {
> > 	return enable_unrestricted_guest && (!is_guest_mode(vcpu) ||
> > 	       to_vmx(vcpu)->nested.unrestricted_guest);
> >   }
> >
> > Putting the flag in loaded_vmcs might be more performant?  My guess is it'd
> > be in the noise, at which point I'd rather have it be clear the override is
> > only possible/necessary for nested guests.
> 
> Even better: you can use secondary_exec_controls_get, which does get the
> flag from the loaded_vmcs :) but without actually having to add one.

I keep forgetting we have those shadows.  Definitely the best solution.
