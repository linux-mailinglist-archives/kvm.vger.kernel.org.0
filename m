Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18BB7123B7F
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 01:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfLRAYL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 19:24:11 -0500
Received: from mga17.intel.com ([192.55.52.151]:10966 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbfLRAYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 19:24:11 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 16:24:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,327,1571727600"; 
   d="scan'208";a="415653162"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 17 Dec 2019 16:24:11 -0800
Date:   Tue, 17 Dec 2019 16:24:10 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH] x86: Fix max VMCS field encoding index
 check
Message-ID: <20191218002410.GN11771@linux.intel.com>
References: <20190518163743.5396-1-nadav.amit@gmail.com>
 <CALMp9eQOKX6m0ih6bH5Oyqq5hFbSs7vn0MAZXka3RcOCrC+sUg@mail.gmail.com>
 <51BBC492-AD4F-4AA4-B9AD-8E0AAFFC276F@gmail.com>
 <CALMp9eT+K7qwLeBb231OjNwqTaS4XE6Ci+-j_b+a=0JU__HEqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eT+K7qwLeBb231OjNwqTaS4XE6Ci+-j_b+a=0JU__HEqg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 13, 2019 at 09:30:45AM -0800, Jim Mattson wrote:
> On Fri, Dec 13, 2019 at 1:13 AM Nadav Amit <nadav.amit@gmail.com> wrote:
> >
> > > On Dec 13, 2019, at 12:59 AM, Jim Mattson <jmattson@google.com> wrote:
> > >
> > > On Sat, May 18, 2019 at 4:58 PM Nadav Amit <nadav.amit@gmail.com> wrote:
> > >> The test that checks the maximum VMCS field encoding does not probe all
> > >> possible VMCS fields. As a result it might fail since the actual
> > >> IA32_VMX_VMCS_ENUM.MAX_INDEX would be higher than the expected value.
> > >>
> > >> Change the test to check that the maximum of the supported probed
> > >> VMCS fields is lower/equal than the actual reported
> > >> IA32_VMX_VMCS_ENUM.MAX_INDEX.
> > >
> > > Wouldn't it be better to probe all possible VMCS fields and keep the
> > > test for equality?
> >
> > It might take a while though…
> >
> > How about probing VMREAD/VMWRITE to MAX_INDEX in addition to all the known
> > VMCS fields and then checking for equation?
> >
> It can't take that long. VMCS field encodings are only 15 bits, and
> you can ignore the "high" part of 64-bit fields, so that leaves only
> 14 bits.

Unless kvm-unit-tests is being run in L1, in which case things like this
are painful.  That being said, I do agree that probing "all" VMCS fields
is the way to go.  Walking from highest->lowest probably won't even take
all that many VMREADS.  If it is slow, the test can be binned to its own
config.
