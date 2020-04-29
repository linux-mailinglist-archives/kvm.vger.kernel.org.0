Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700241BE42F
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 18:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgD2Qpt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 12:45:49 -0400
Received: from mga12.intel.com ([192.55.52.136]:65512 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgD2Qpt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 12:45:49 -0400
IronPort-SDR: Dw4DlxqM5j2xkFY6wDf+lVnThZJbuLD1I29MJ8AVKpbgTJSCXfUQyJgnxtHJAn8z0KY+TQhfaw
 MVdMn7oQ/DtQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 09:45:48 -0700
IronPort-SDR: oaKyK6ixi+V2jpn3Dv65+j5HnCJMTog49RBW+pIJlNQf4avqLTznIcUF13JCgDuxH6apHwP2Cf
 ENdkMbzEsxFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,332,1583222400"; 
   d="scan'208";a="248035288"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga007.fm.intel.com with ESMTP; 29 Apr 2020 09:45:48 -0700
Date:   Wed, 29 Apr 2020 09:45:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 12/13] KVM: x86: Replace late check_nested_events() hack
 with more precise fix
Message-ID: <20200429164547.GF15992@linux.intel.com>
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
 <20200423022550.15113-13-sean.j.christopherson@intel.com>
 <CALMp9eTiGdYPpejAOLNz7zzqP1wPXb_zSL02F27VMHeHGzANJg@mail.gmail.com>
 <20200428222010.GN12735@linux.intel.com>
 <6b35ec9b-9565-ea6c-3de5-0957a9f76257@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b35ec9b-9565-ea6c-3de5-0957a9f76257@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 29, 2020 at 10:36:17AM +0200, Paolo Bonzini wrote:
> On 29/04/20 00:20, Sean Christopherson wrote:
> >> So, that's what this mess was all about! Well, this certainly looks better.
> > Right?  I can't count the number of times I've looked at this code and
> > wondered what the hell it was doing.
> > 
> > Side topic, I just realized you're reviewing my original series.  Paolo
> > commandeered it to extend it to SVM. https://patchwork.kernel.org/cover/11508679/
> 
> If you can just send a patch to squash into 9/13 I can take care of it.

Ugh, correctly prioritizing SMI is a mess.  It has migration implications,
a proper fix requires non-trivial changes to inject_pending_event(), there
are pre-existing (minor) bugs related to MTF handling, and technically INIT
should have lower priority than non-trap exceptions (because the exception
happens before the event window is opened).

Can you just drop 9/13, "Prioritize SMI over nested IRQ/NMI" from kvm/queue?
It's probably best to deal with this in a new series rather than trying to
squeeze it in.
