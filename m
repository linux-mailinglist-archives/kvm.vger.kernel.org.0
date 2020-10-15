Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB6028F6E1
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 18:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389725AbgJOQfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 12:35:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:29163 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389147AbgJOQfl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Oct 2020 12:35:41 -0400
IronPort-SDR: +ZNl6koX1NjTOnz2n6mFWOy3Uq7oIeMlk4LAgmDW9QZUA26sPf1F8Q8BU0tre+4T9suqgHhW1C
 cJ11DQJFFOsw==
X-IronPort-AV: E=McAfee;i="6000,8403,9775"; a="165615518"
X-IronPort-AV: E=Sophos;i="5.77,379,1596524400"; 
   d="scan'208";a="165615518"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2020 09:35:40 -0700
IronPort-SDR: KUHWWS0IKFlQ6/ghz/xDys+pntZK4sUggqisP38RQDoTerlbvEoHRZoQbLQopyu6ZbcrKD5h/O
 T5n5cX1eQSrA==
X-IronPort-AV: E=Sophos;i="5.77,379,1596524400"; 
   d="scan'208";a="521902525"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2020 09:35:40 -0700
Date:   Thu, 15 Oct 2020 09:35:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Po-Hsu Lin <po-hsu.lin@canonical.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCHv2] unittests.cfg: Increase timeout for
 apic test
Message-ID: <20201015163539.GA27813@linux.intel.com>
References: <20201013091237.67132-1-po-hsu.lin@canonical.com>
 <87d01j5vk7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d01j5vk7.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 15, 2020 at 05:59:52PM +0200, Vitaly Kuznetsov wrote:
> Po-Hsu Lin <po-hsu.lin@canonical.com> writes:
> 
> > We found that on Azure cloud hyperv instance Standard_D48_v3, it will
> > take about 45 seconds to run this apic test.
> >
> > It takes even longer (about 150 seconds) to run inside a KVM instance
> > VM.Standard2.1 on Oracle cloud.
> >
> > Bump the timeout threshold to give it a chance to finish.
> >
> > Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
> > ---
> >  x86/unittests.cfg | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> > index 872d679..c72a659 100644
> > --- a/x86/unittests.cfg
> > +++ b/x86/unittests.cfg
> > @@ -41,7 +41,7 @@ file = apic.flat
> >  smp = 2
> >  extra_params = -cpu qemu64,+x2apic,+tsc-deadline
> >  arch = x86_64
> > -timeout = 30
> > +timeout = 240
> >  
> >  [ioapic]
> >  file = ioapic.flat
> 
> AFAIR the default timeout for tests where timeout it not set explicitly
> is 90s so don't you need to also modify it for other tests like
> 'apic-split', 'ioapic', 'ioapic-split', ... ?
> 
> I was thinking about introducing a 'timeout multiplier' or something to
> run_tests.sh for running in slow (read: nested) environments, doing that
> would allow us to keep reasonably small timeouts by default. This is
> somewhat important as tests tend to hang and waiting for 4 minutes every
> time is not great.

I would much prefer to go in the other direction and make tests like APIC not
do so many loops (in a nested environment?).  The port80 test in particular is
an absolute waste of time.

E.g. does running 1M loops in test_multiple_nmi() really add value versus
say 10k or 100k loops?
