Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF4BF8F0BD
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 18:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732102AbfHOQiq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 12:38:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:22205 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731913AbfHOQiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 12:38:46 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Aug 2019 09:38:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,389,1559545200"; 
   d="scan'208";a="178512101"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 15 Aug 2019 09:38:44 -0700
Date:   Thu, 15 Aug 2019 09:38:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        yu.c.zhang@intel.com, alazar@bitdefender.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RESEND v4 5/9] KVM: VMX: Add init/set/get functions for
 SPP
Message-ID: <20190815163844.GD27076@linux.intel.com>
References: <20190814070403.6588-1-weijiang.yang@intel.com>
 <20190814070403.6588-6-weijiang.yang@intel.com>
 <87a7cbapdw.fsf@vitty.brq.redhat.com>
 <20190815134329.GA11449@local-michael-cet-test>
 <CALMp9eTGXDDfVspFwFyEhagg9sdnqZqzSQhDksT0bkKzVNGSqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eTGXDDfVspFwFyEhagg9sdnqZqzSQhDksT0bkKzVNGSqw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 15, 2019 at 09:25:41AM -0700, Jim Mattson wrote:
> On Thu, Aug 15, 2019 at 6:41 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
> 
> > Hi, Vitaly,
> > After looked into the issue and others, I feel to make SPP co-existing
> > with nested VM is not good, the major reason is, L1 pages protected by
> > SPP are transparent to L1 VM, if it launches L2 VM, probably the
> > pages would be allocated to L2 VM, and that will bother to L1 and L2.
> > Given the feature is new and I don't see nested VM can benefit
> > from it right now, I would like to make SPP and nested feature mutually
> > exclusive, i.e., detecting if the other part is active before activate one
> > feature,what do you think of it?
> > thanks!
> 
> How do you propose making the features mutually exclusive?

I haven't looked at the details or the end to end flow, but would it make
sense to exit to userspace on nested VMLAUNCH/VMRESUME if there are SPP
mappings?  And have the SPP ioctl() kick vCPUs out of guest.

KVM already exits on SPP violations, so presumably this is something that
can be punted to userspace.
