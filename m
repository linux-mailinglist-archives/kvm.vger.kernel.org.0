Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E94864A72
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 18:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbfGJQFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 12:05:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:51715 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbfGJQFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 12:05:45 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 09:05:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,475,1557212400"; 
   d="scan'208";a="168350732"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by orsmga003.jf.intel.com with ESMTP; 10 Jul 2019 09:05:44 -0700
Date:   Wed, 10 Jul 2019 09:05:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Zhang Yang <w90p710@gmail.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: x86: Fix guest time accounting with
 VIRT_CPU_ACCOUNTING_GEN
Message-ID: <20190710160544.GB4348@linux.intel.com>
References: <20190708164751.88385-1-w90p710@gmail.com>
 <20190709145650.GC25369@linux.intel.com>
 <CANwVFYMwKqsvGhPS7ZpQRS-dJ58KMLRSx8oEk_PowMtwpfXK=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANwVFYMwKqsvGhPS7ZpQRS-dJ58KMLRSx8oEk_PowMtwpfXK=A@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 10, 2019 at 08:42:30PM +0800, Zhang Yang wrote:
> Yes, In fact we had a trouble with the small window,  the system monitor
> found that the host machine's sys is very high now and then.  Based on our's
> tracing, we found that timer interrupt always hit after local_irq_enable, the
> guest tick would be always accounted to system time. after applying this
> patch, the phenomenon disappears.

Fun.  Rather than switching to guest_exit(), I think it'd be better to
unconditionally open an irq window in order to minimize the overhead.
I'll send a patch, it's easier to explain with code :-)
