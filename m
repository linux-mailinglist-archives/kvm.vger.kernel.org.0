Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5141230F28
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 18:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731191AbgG1QZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 12:25:28 -0400
Received: from mga18.intel.com ([134.134.136.126]:2871 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730679AbgG1QZ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 12:25:28 -0400
IronPort-SDR: j9HYufdvPC8mybHGZP8sBdzH6L4Slak0UVRx6JOXTtbl+5/yIs+MJNYyDe/f28L5WaSfEAMIJn
 BEdk0X8Db0jA==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="138772585"
X-IronPort-AV: E=Sophos;i="5.75,406,1589266800"; 
   d="scan'208";a="138772585"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 09:25:28 -0700
IronPort-SDR: YAW0CaxbxjIeOA9o7ZaCbA5yvLUgv88BYxvkLjskK3Y4+SilGEzhvrR8BL2HdV5/HfpcSnkpiB
 nEQiVb0Gabcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,406,1589266800"; 
   d="scan'208";a="290231385"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 28 Jul 2020 09:25:24 -0700
Date:   Tue, 28 Jul 2020 09:25:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [RFC 2/2] KVM: VMX: Enable bus lock VM exit
Message-ID: <20200728162524.GE5300@linux.intel.com>
References: <20200628085341.5107-1-chenyi.qiang@intel.com>
 <20200628085341.5107-3-chenyi.qiang@intel.com>
 <878sg3bo8b.fsf@vitty.brq.redhat.com>
 <0159554d-82d5-b388-d289-a5375ca91323@intel.com>
 <87366bbe1y.fsf@vitty.brq.redhat.com>
 <adad61e8-8252-0491-7feb-992a52c1b4f3@intel.com>
 <87zh8j9to2.fsf@vitty.brq.redhat.com>
 <20200723012114.GP9114@linux.intel.com>
 <a1c2a7dc-d52a-daad-4078-3097579ffef2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1c2a7dc-d52a-daad-4078-3097579ffef2@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 27, 2020 at 12:38:53PM +0800, Xiaoyao Li wrote:
> On 7/23/2020 9:21 AM, Sean Christopherson wrote:
> >On Wed, Jul 01, 2020 at 04:49:49PM +0200, Vitaly Kuznetsov wrote:
> >>Xiaoyao Li <xiaoyao.li@intel.com> writes:
> >>>So you want an exit to userspace for every bus lock and leave it all to
> >>>userspace. Yes, it's doable.
> >>
> >>In some cases we may not even want to have a VM exit: think
> >>e.g. real-time/partitioning case when even in case of bus lock we may
> >>not want to add additional latency just to count such events.
> >
> >Hmm, I suspect this isn't all that useful for real-time cases because they'd
> >probably want to prevent the split lock in the first place, e.g. would prefer
> >to use the #AC variant in fatal mode.  Of course, the availability of split
> >lock #AC is a whole other can of worms.
> >
> >But anyways, I 100% agree that this needs either an off-by-default module
> >param or an opt-in per-VM capability.
> >
> 
> Maybe on-by-default or an opt-out per-VM capability?
> Turning it on introduces no overhead if no bus lock happens in guest but
> gives KVM the capability to track every potential bus lock. If user doesn't
> want the extra latency due to bus lock VM exit, it's better try to fix the
> bus lock, which also incurs high latency.

Except that I doubt the physical system owner and VM owner are the same
entity in the vast majority of KVM use cases.  So yeah, in a perfect world
the guest application that's causing bus locks would be fixed, but in
practice there is likely no sane way for the KVM owner to inform the guest
application owner that their application is broken, let alone fix said
application.

The caveat would be that we may need to enable this by default if the host
kernel policy mandates it.

> >>I'd suggest we make the new capability tri-state:
> >>- disabled (no vmexit, default)
> >>- stats only (what this patch does)
> >>- userspace exit
> >>But maybe this is an overkill, I'd like to hear what others think.
> >
> >Userspace exit would also be interesting for debug.  Another throttling
> >option would be schedule() or cond_reched(), though that's probably getting
> >into overkill territory.
> >
> 
> We're going to leverage host's policy, i.e., calling handle_user_bus_lock(),
> for throttling, as proposed in https://lkml.kernel.org/r/1595021700-68460-1-git-send-email-fenghua.yu@intel.com
> 
