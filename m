Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0277163696
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 23:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbgBRW6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 17:58:11 -0500
Received: from mga03.intel.com ([134.134.136.65]:47140 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbgBRW6L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 17:58:11 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 14:58:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="282926429"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Feb 2020 14:58:09 -0800
Date:   Tue, 18 Feb 2020 14:58:09 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Chia-I Wu <olvaffe@gmail.com>,
        kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Gurchetan Singh <gurchetansingh@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [RFC PATCH 0/3] KVM: x86: honor guest memory type
Message-ID: <20200218225809.GL28156@linux.intel.com>
References: <20200213213036.207625-1-olvaffe@gmail.com>
 <8fdb85ea-6441-9519-ae35-eaf91ffe8741@redhat.com>
 <CAPaKu7T8VYXTMc1_GOzJnwBaZSG214qNoqRr8c7Z4Lb3B7dtTg@mail.gmail.com>
 <b82cd76c-0690-c13b-cf2c-75d7911c5c61@redhat.com>
 <20200214195229.GF20690@linux.intel.com>
 <CAPaKu7Q4gehyhEgG_Nw=tiZiTh+7A8-uuXq1w4he6knp6NWErQ@mail.gmail.com>
 <CALMp9eRwTxdqxAcobZ7sYbD=F8Kga=jR3kaz-OEYdA9fV0AoKQ@mail.gmail.com>
 <20200214220341.GJ20690@linux.intel.com>
 <d3a6fac6-3831-3b8e-09b6-bfff4592f235@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3a6fac6-3831-3b8e-09b6-bfff4592f235@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 18, 2020 at 05:28:51PM +0100, Paolo Bonzini wrote:
> On 14/02/20 23:03, Sean Christopherson wrote:
> >> On Fri, Feb 14, 2020 at 1:47 PM Chia-I Wu <olvaffe@gmail.com> wrote:
> >>> AFAICT, it is currently allowed on ARM (verified) and AMD (not
> >>> verified, but svm_get_mt_mask returns 0 which supposedly means the NPT
> >>> does not restrict what the guest PAT can do).  This diff would do the
> >>> trick for Intel without needing any uapi change:
> >> I would be concerned about Intel CPU errata such as SKX40 and SKX59.
> > The part KVM cares about, #MC, is already addressed by forcing UC for MMIO.
> > The data corruption issue is on the guest kernel to correctly use WC
> > and/or non-temporal writes.
> 
> What about coherency across live migration?  The userspace process would
> use cached accesses, and also a WBINVD could potentially corrupt guest
> memory.

Haven't given it an iota of thought.  My comments were purely in the
context of the SKX40 and SKX59 errata, which are silly bugs that no real
world software will ever hit, e.g. no sane software is going to split a
MASKMOV instruction across address spaces.  Hitting SKX59 would further
require the kernel to map MMIO as WB directly adjacent to RAM, which is
beyond crazy.
