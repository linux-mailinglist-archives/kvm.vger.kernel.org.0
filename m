Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F9B22A477
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 03:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387567AbgGWBVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 21:21:16 -0400
Received: from mga04.intel.com ([192.55.52.120]:50738 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728914AbgGWBVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 21:21:15 -0400
IronPort-SDR: GT/C+Styor6hPrZ88Qj96gqDYDflTniPtm6aifAIjkJViyala+10u14b2mhHy7vBu5RWoQjiSr
 TZ3mzCNoGLkg==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="147942735"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="147942735"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 18:21:15 -0700
IronPort-SDR: q6D+IaEAS1EI1MqdrpHWpV55XW9bqt5jIXgd2Q5xtVMLieKpFCZrGPe4T19dPHD1C+M7guLyZt
 f0qsYL4cISJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="270906609"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga007.fm.intel.com with ESMTP; 22 Jul 2020 18:21:14 -0700
Date:   Wed, 22 Jul 2020 18:21:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [RFC 2/2] KVM: VMX: Enable bus lock VM exit
Message-ID: <20200723012114.GP9114@linux.intel.com>
References: <20200628085341.5107-1-chenyi.qiang@intel.com>
 <20200628085341.5107-3-chenyi.qiang@intel.com>
 <878sg3bo8b.fsf@vitty.brq.redhat.com>
 <0159554d-82d5-b388-d289-a5375ca91323@intel.com>
 <87366bbe1y.fsf@vitty.brq.redhat.com>
 <adad61e8-8252-0491-7feb-992a52c1b4f3@intel.com>
 <87zh8j9to2.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zh8j9to2.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 01, 2020 at 04:49:49PM +0200, Vitaly Kuznetsov wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> > So you want an exit to userspace for every bus lock and leave it all to 
> > userspace. Yes, it's doable.
> 
> In some cases we may not even want to have a VM exit: think
> e.g. real-time/partitioning case when even in case of bus lock we may
> not want to add additional latency just to count such events.

Hmm, I suspect this isn't all that useful for real-time cases because they'd
probably want to prevent the split lock in the first place, e.g. would prefer
to use the #AC variant in fatal mode.  Of course, the availability of split
lock #AC is a whole other can of worms.

But anyways, I 100% agree that this needs either an off-by-default module
param or an opt-in per-VM capability.

> I'd suggest we make the new capability tri-state:
> - disabled (no vmexit, default)
> - stats only (what this patch does)
> - userspace exit
> But maybe this is an overkill, I'd like to hear what others think.

Userspace exit would also be interesting for debug.  Another throttling
option would be schedule() or cond_reched(), though that's probably getting
into overkill territory.
