Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5BC1E37CA
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 07:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgE0FN4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 01:13:56 -0400
Received: from mga17.intel.com ([192.55.52.151]:3798 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725969AbgE0FNz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 01:13:55 -0400
IronPort-SDR: IjcWlCbiqXgTJoKu0wf/KWar0x7tikALWGy4P1nB07KDFtxAd/zN0Z8vuoA5k7pA2Wgvf3//I7
 34+If4jgvuXg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 22:13:55 -0700
IronPort-SDR: EZaFWLbW8btGXcoTvzeyQT6xjFbceGOJPwKLW6J7q51OFBid7lzF/JjZ5tQm4V+nRUhHp7EQ/B
 axatwRgBhKxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,440,1583222400"; 
   d="scan'208";a="414074697"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga004.jf.intel.com with ESMTP; 26 May 2020 22:13:55 -0700
Date:   Tue, 26 May 2020 22:13:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Brad Campbell <lists2009@fnarfbargle.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: KVM broken after suspend in most recent kernels.
Message-ID: <20200527051354.GL31696@linux.intel.com>
References: <1f7a85cc-38a6-2a2e-cbe3-a5b9970b7b92@fnarfbargle.com>
 <f726be8c-c7ef-bf6a-f31e-394969d35045@fnarfbargle.com>
 <1f7b1c9a8d9cbb6f82e97f8ba7a13ce5b773e16f.camel@redhat.com>
 <a45bc9d7-ad0b-2ff0-edcc-5283f591bc10@fnarfbargle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a45bc9d7-ad0b-2ff0-edcc-5283f591bc10@fnarfbargle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 09:15:57PM +0800, Brad Campbell wrote:
> >When you mean that KVM is broken after suspend, you mean that you can't
> >start new VMs after suspend, or do VMs that were running before suspend
> >break?  I see the later on my machine. I have AMD system though, so most
> >likely this is another bug.
> >
> >Looking at the commit, I suspect that we indeed should set the IA32_FEAT_CTL
> >after resume from ram, since suspend to ram might count as a complete CPU
> >reset.
> >
> 
> One of those "I should have clarified that" moments immediately after I
> pressed send.  I've not tried suspending with a VM running. It's "can't start
> new VMs after suspend".

Don't bother testing suspending with a VM, the only thing that will be
different is that your system will hang on resume instead when running a
VM.  If there are active VMs, KVM automatically re-enables VMX via VMXON
after resume, and VMXON is what's faulting.

Odds are good the firmware simply isn't initializing IA32_FEAT_CTL, ever.
The kernel handles the boot-time case, but I (obviously) didn't consider
the suspend case.  I'll work on a patch.
