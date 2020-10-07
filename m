Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4A3285519
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 02:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgJGAE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 20:04:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:4470 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgJGAE1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 20:04:27 -0400
IronPort-SDR: eTCcfybZeErdyzzx74hol+yEXs0/oKJOvzWyv9+Jo4nzgvT0d9vgvAXpEdWytoE57ttzWpwd3a
 pL8rjc/+MIqA==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="161364552"
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="161364552"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 17:04:26 -0700
IronPort-SDR: KmB5ByB6QIQHPVZGEN9baEpIgMmRsc5mNFre9CmO3c7LXzyQTKxygNnRE4nbJL7+TOs0tfCaYp
 GZdWiqfeolGA==
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="418472064"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 17:04:26 -0700
Date:   Tue, 6 Oct 2020 17:04:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com
Subject: Re: [PATCH v4] kvm,x86: Exit to user space in case page fault error
Message-ID: <20201007000424.GD28981@linux.intel.com>
References: <20201006134629.GB5306@redhat.com>
 <877ds38n6r.fsf@vitty.brq.redhat.com>
 <20201006141501.GC5306@redhat.com>
 <874kn78l2z.fsf@vitty.brq.redhat.com>
 <20201006150817.GD5306@redhat.com>
 <871rib8ji1.fsf@vitty.brq.redhat.com>
 <20201006161200.GB17610@linux.intel.com>
 <87y2kj71gj.fsf@vitty.brq.redhat.com>
 <20201006171704.GC17610@linux.intel.com>
 <20201006173527.GG5306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006173527.GG5306@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 06, 2020 at 01:35:27PM -0400, Vivek Goyal wrote:
> On Tue, Oct 06, 2020 at 10:17:04AM -0700, Sean Christopherson wrote:
> 
> [..]
> > > > Note, TDX doesn't allow injection exceptions, so reflecting a #PF back
> > > > into the guest is not an option.  
> > > 
> > > Not even #MC? So sad :-)
> > 
> > Heh, #MC isn't allowed either, yet...
> 
> If #MC is not allowd, logic related to hwpoison memory will not work
> as that seems to inject #MC.

Yep.  Piggybacking #MC is undesirable for other reasons, e.g. adds a "hardware"
dependency for what is really a paravirt feature.
