Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F110C28508F
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 19:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgJFRRU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 13:17:20 -0400
Received: from mga05.intel.com ([192.55.52.43]:56410 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbgJFRRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 13:17:20 -0400
IronPort-SDR: JwG/zZYucnqANSln8iCWHIPUu0Z4iFgm5tk8lU+/fe11ZBlSLE53YYug8IJN+2S5+qW7jqkvkb
 wNauNVNFS2GQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="249300989"
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="249300989"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 10:17:06 -0700
IronPort-SDR: m+Tc5wq9sWO0NnqVdPajk56RgYJuwBhCaLiCcwUTC2KqKoUADxb93Jjs7styw57WgIjZitEn4p
 XZCRfVeRmV8w==
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="527456307"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 10:17:06 -0700
Date:   Tue, 6 Oct 2020 10:17:04 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com
Subject: Re: [PATCH v4] kvm,x86: Exit to user space in case page fault error
Message-ID: <20201006171704.GC17610@linux.intel.com>
References: <20201005153318.GA4302@redhat.com>
 <20201005161620.GC11938@linux.intel.com>
 <20201006134629.GB5306@redhat.com>
 <877ds38n6r.fsf@vitty.brq.redhat.com>
 <20201006141501.GC5306@redhat.com>
 <874kn78l2z.fsf@vitty.brq.redhat.com>
 <20201006150817.GD5306@redhat.com>
 <871rib8ji1.fsf@vitty.brq.redhat.com>
 <20201006161200.GB17610@linux.intel.com>
 <87y2kj71gj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2kj71gj.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 06, 2020 at 06:39:56PM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > On Tue, Oct 06, 2020 at 05:24:54PM +0200, Vitaly Kuznetsov wrote:
> >> Vivek Goyal <vgoyal@redhat.com> writes:
> >> > So you will have to report token (along with -EFAULT) to user space. So this
> >> > is basically the 3rd proposal which is extension of kvm API and will
> >> > report say HVA/GFN also to user space along with -EFAULT.
> >> 
> >> Right, I meant to say that guest kernel has full register state of the
> >> userspace process which caused APF to get queued and instead of trying
> >> to extract it in KVM and pass to userspace in case of a (later) failure
> >> we limit KVM api change to contain token or GFN only and somehow keep
> >> the rest in the guest. This should help with TDX/SEV-ES.
> >
> > Whatever gets reported to userspace should be identical with and without
> > async page faults, i.e. it definitely shouldn't have token information.
> >
> 
> Oh, right, when the error gets reported synchronously guest's kernel is
> not yet aware of the issue so it won't be possible to find anything in
> its kdump if userspace decides to crash it immediately. The register
> state (if available) will be actual though.
> 
> > Note, TDX doesn't allow injection exceptions, so reflecting a #PF back
> > into the guest is not an option.  
> 
> Not even #MC? So sad :-)

Heh, #MC isn't allowed either, yet...

> > Nor do I think that's "correct" behavior (see everyone's objections to
> > using #PF for APF fixed).  I.e. the event should probably be an IRQ.
> 
> I recall Paolo objected against making APF 'page not present' into in
> interrupt as it will require some very special handling to make sure it
> gets injected (and handled) immediately but I'm not really sure how big
> the hack is going to be, maybe in the light of TDX/SEV-ES it's worth a
> try.

This shouldn't have anything to do with APF.  Again, the event injection is
needed even in the synchronous case as the file truncation in the host can
affect existing mappings in the guest.

I don't know that the mechanism needs to be virtiofs specific or if there can
be a more generic "these PFNs have disappeared", but it's most definitely
orthogonal to APF.
