Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 571E49A419
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 01:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfHVX44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 19:56:56 -0400
Received: from mga18.intel.com ([134.134.136.126]:32126 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727627AbfHVX44 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 19:56:56 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 16:56:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="scan'208";a="379519238"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 22 Aug 2019 16:56:55 -0700
Date:   Thu, 22 Aug 2019 16:56:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86: Fix breakage of fw_cfg for 32-bit
 unit tests
Message-ID: <20190822235655.GH25467@linux.intel.com>
References: <20190822235052.3703-1-sean.j.christopherson@intel.com>
 <DCA6E594-72DC-43AD-A490-BAEC1DE85F7E@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DCA6E594-72DC-43AD-A490-BAEC1DE85F7E@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 22, 2019 at 04:55:14PM -0700, Nadav Amit wrote:
> > On Aug 22, 2019, at 4:50 PM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > 
> > Ensure the fw_cfg overrides are parsed prior consuming any of said
> > overrides.  fwcfg_get_u() treats zero as a valid overide value, which
> > is slightly problematic since the overrides are in the .bss and thus
> > initialized to zero.
> > 
> > Add a limit check when indexing fw_override so that future code doesn't
> > spontaneously explode.
> > 
> > Cc: Nadav Amit <nadav.amit@gmail.com>
> > Fixes: 03b1e4570f967 ("x86: Support environments without test-devices")
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> > lib/x86/fwcfg.c | 10 ++++++++--
> > lib/x86/fwcfg.h |  2 --
> > x86/cstart64.S  |  2 --
> > 3 files changed, 8 insertions(+), 6 deletions(-)
> > 
> > diff --git a/lib/x86/fwcfg.c b/lib/x86/fwcfg.c
> > index d8d797f..06ef62c 100644
> > --- a/lib/x86/fwcfg.c
> > +++ b/lib/x86/fwcfg.c
> > @@ -5,10 +5,11 @@
> > static struct spinlock lock;
> > 
> > static long fw_override[FW_CFG_MAX_ENTRY];
> > +static bool fw_override_done;
> > 
> > bool no_test_device;
> > 
> > -void read_cfg_override(void)
> > +static void read_cfg_override(void)
> > {
> > 	const char *str;
> > 	int i;
> > @@ -26,6 +27,8 @@ void read_cfg_override(void)
> > 
> > 	if ((str = getenv("TEST_DEVICE")))
> > 		no_test_device = !atol(str);
> > +
> > +    fw_override_done = true;
> > }
> > 
> > static uint64_t fwcfg_get_u(uint16_t index, int bytes)
> > @@ -34,7 +37,10 @@ static uint64_t fwcfg_get_u(uint16_t index, int bytes)
> >     uint8_t b;
> >     int i;
> > 
> > -    if (fw_override[index] >= 0)
> > +    if (!fw_override_done)
> > +        read_cfg_override();
> > +
> > +    if (index < FW_CFG_MAX_ENTRY && fw_override[index] >= 0)
> > 	    return fw_override[index];
> 
> How did that happen? I remember I tested this code with KVM..

It only breaks 32-bit KVM.
