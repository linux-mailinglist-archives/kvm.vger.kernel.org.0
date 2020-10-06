Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D187284FA4
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 18:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgJFQPU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 12:15:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:40888 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbgJFQPT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 12:15:19 -0400
IronPort-SDR: iGdI+DcKJHsCT4DH16t9LU1f0E7Kfw2dDra2E61iictBCeQELuiGvuORiL5K164J3ShPiF9T+i
 Y6Cxu2yMue7w==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="228694422"
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="228694422"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 09:12:02 -0700
IronPort-SDR: stvAu5V5ArIkhb65+5xX22vrNhwq9qvEre1+vJPC+dd8YMhN4ZwLklfbXK9J9x0T9beEC2KXf+
 UDk1DR+bwfQA==
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="348545356"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 09:12:01 -0700
Date:   Tue, 6 Oct 2020 09:12:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com
Subject: Re: [PATCH v4] kvm,x86: Exit to user space in case page fault error
Message-ID: <20201006161200.GB17610@linux.intel.com>
References: <20201002200214.GB10232@redhat.com>
 <20201002211314.GE24460@linux.intel.com>
 <20201005153318.GA4302@redhat.com>
 <20201005161620.GC11938@linux.intel.com>
 <20201006134629.GB5306@redhat.com>
 <877ds38n6r.fsf@vitty.brq.redhat.com>
 <20201006141501.GC5306@redhat.com>
 <874kn78l2z.fsf@vitty.brq.redhat.com>
 <20201006150817.GD5306@redhat.com>
 <871rib8ji1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871rib8ji1.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 06, 2020 at 05:24:54PM +0200, Vitaly Kuznetsov wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> > So you will have to report token (along with -EFAULT) to user space. So this
> > is basically the 3rd proposal which is extension of kvm API and will
> > report say HVA/GFN also to user space along with -EFAULT.
> 
> Right, I meant to say that guest kernel has full register state of the
> userspace process which caused APF to get queued and instead of trying
> to extract it in KVM and pass to userspace in case of a (later) failure
> we limit KVM api change to contain token or GFN only and somehow keep
> the rest in the guest. This should help with TDX/SEV-ES.

Whatever gets reported to userspace should be identical with and without
async page faults, i.e. it definitely shouldn't have token information.

Note, TDX doesn't allow injection exceptions, so reflecting a #PF back
into the guest is not an option.  Nor do I think that's "correct"
behavior (see everyone's objections to using #PF for APF fixed).  I.e. the
event should probably be an IRQ.
