Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DA426CBFC
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 22:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgIPUho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 16:37:44 -0400
Received: from mga04.intel.com ([192.55.52.120]:14999 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726849AbgIPRJW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 13:09:22 -0400
IronPort-SDR: NRRfqxIk2POsUCi6COTFpiYUT+IRTW9bCotYLwH8EbF229HbkzlW3YosPyxkdHpKCMSaZ7yX/u
 gY13ALiH5vIQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9746"; a="156909016"
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="156909016"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 10:08:41 -0700
IronPort-SDR: VQ1WRuPQofTMsAY577bwERRjOaaJuPrpDemjjRSKVq28NMlARkxp2x3q5tOYrRVqo7DIhV1eAn
 oCOKk015bv2A==
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="451937469"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 10:08:40 -0700
Date:   Wed, 16 Sep 2020 10:08:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        kvm list <kvm@vger.kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/7] KVM: x86: Deflect unknown MSR accesses to user
 space
Message-ID: <20200916170839.GD10227@sjchrist-ice>
References: <20200902125935.20646-1-graf@amazon.com>
 <20200902125935.20646-2-graf@amazon.com>
 <CAAAPnDFGD8+5KBCLKERrH0hajHEwU9UdEEGqp3RZu3Lws+5rmw@mail.gmail.com>
 <186ccace-2fad-3db3-0848-cd272b1a64ba@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <186ccace-2fad-3db3-0848-cd272b1a64ba@amazon.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 16, 2020 at 11:31:30AM +0200, Alexander Graf wrote:
> On 03.09.20 21:27, Aaron Lewis wrote:
> > > @@ -412,6 +414,15 @@ struct kvm_run {
> > >                          __u64 esr_iss;
> > >                          __u64 fault_ipa;
> > >                  } arm_nisv;
> > > +               /* KVM_EXIT_X86_RDMSR / KVM_EXIT_X86_WRMSR */
> > > +               struct {
> > > +                       __u8 error; /* user -> kernel */
> > > +                       __u8 pad[3];
> > 
> > __u8 pad[7] to maintain 8 byte alignment?  unless we can get away with
> > fewer bits for 'reason' and
> > get them from 'pad'.
> 
> Why would we need an 8 byte alignment here? I always thought natural u64
> alignment on x86_64 was on 4 bytes?

u64 will usually (always?) be 8 byte aligned by the compiler.  "Natural"
alignment means an object is aligned to its size.  E.g. an 8-byte object
can split a cache line if it's only aligned on a 4-byte boundary.
