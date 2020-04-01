Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B161019B8C6
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 01:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733292AbgDAXBI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 19:01:08 -0400
Received: from mga17.intel.com ([192.55.52.151]:34041 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732537AbgDAXBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 19:01:08 -0400
IronPort-SDR: e1DY0cHw2HDK5Ow55JQY8vbOpoPaCZbUJFdLDD0/GF4ONuMXPhD9Xe1Hy+RASb3CPo2OUd95Pt
 dRbxnzCnCsPg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2020 16:01:07 -0700
IronPort-SDR: c8aegkgBR93uXjxZA+7OGa8JwuBeJpCRXw6HLauhJt8LJ7ID7HNB1NmEbLhnFS9NYUIF/3zPKE
 KAwKlAdc/UdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,333,1580803200"; 
   d="scan'208";a="396156610"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 01 Apr 2020 16:01:00 -0700
Date:   Wed, 1 Apr 2020 16:01:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nadav Amit <namit@vmware.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 2/2] KVM: LAPIC: Don't need to clear IPI delivery
 status in x2apic mode
Message-ID: <20200401230100.GE9603@linux.intel.com>
References: <1585700362-11892-1-git-send-email-wanpengli@tencent.com>
 <1585700362-11892-2-git-send-email-wanpengli@tencent.com>
 <6de1a454-60fc-2bda-841d-f9ceb606d4c6@redhat.com>
 <CANRm+CzB3dWatF7qOO_WajXM_ZBn1U6Z8+uq4NxCuLG3TgwY1Q@mail.gmail.com>
 <CE34AD16-64A7-4AA0-9928-507C6F3FF6CD@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CE34AD16-64A7-4AA0-9928-507C6F3FF6CD@vmware.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 01, 2020 at 05:40:03PM +0000, Nadav Amit wrote:
> > On Mar 31, 2020, at 11:46 PM, Wanpeng Li <kernellwp@gmail.com> wrote:
> > 
> > Cc more people,
> > On Wed, 1 Apr 2020 at 08:35, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >> On 01/04/20 02:19, Wanpeng Li wrote:
> >>> -             /* No delay here, so we always clear the pending bit */
> >>> -             val &= ~(1 << 12);
> >>> +             /* Immediately clear Delivery Status in xAPIC mode */
> >>> +             if (!apic_x2apic_mode(apic))
> >>> +                     val &= ~(1 << 12);
> >> 
> >> This adds a conditional, and the old behavior was valid according to the
> >> SDM: "software should not assume the value returned by reading the ICR
> >> is the last written value".
> > 
> > Nadav, Sean, what do you think?
> 
> I do not know. But if you write a KVM unit-test, I can run it on bare-metal
> and give you feedback about how it behaves.

I agree with Paolo, clearing the bit doesn't violate the SDM.  The
conditional is just as costly as the AND, if not more so, even for x2APIC.

I would play it safe and clear the bit even in the x2APIC only path to
avoid tripping up guest kernels that loop on the delivery status even when
using x2APIC.
