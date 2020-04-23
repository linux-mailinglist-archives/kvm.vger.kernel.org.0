Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C216A1B5F74
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 17:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729221AbgDWPfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 11:35:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:46548 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729020AbgDWPfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 11:35:40 -0400
IronPort-SDR: IqfrTmve7PwVGxYad5Czmu25GB90QGRcK0Zq/+2i46duUkyF9tYGt1mJBbNoSs8MlmNGKPxZw/
 6RrK0D+0I2Pg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 08:35:32 -0700
IronPort-SDR: s4o5t7T+Ttf1hoTj9gnJjqgWdiktSlE/RmlkXrIHQlzAR9N0CkoQN7DNJGj31JvAQ59QW0H8K6
 eLsmn9no3nIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="274267705"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 23 Apr 2020 08:35:31 -0700
Date:   Thu, 23 Apr 2020 08:35:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Cathy Avery <cavery@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, vkuznets@redhat.com, wei.huang2@amd.com
Subject: Re: [PATCH 2/2] KVM: x86: check_nested_events if there is an
 injectable NMI
Message-ID: <20200423153531.GC17824@linux.intel.com>
References: <20200414201107.22952-1-cavery@redhat.com>
 <20200414201107.22952-3-cavery@redhat.com>
 <20200423144209.GA17824@linux.intel.com>
 <ae2d4f5d-cb96-f63a-7742-a7f46ad0d1a8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae2d4f5d-cb96-f63a-7742-a7f46ad0d1a8@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 05:10:45PM +0200, Paolo Bonzini wrote:
> On 23/04/20 16:42, Sean Christopherson wrote:
> > On Tue, Apr 14, 2020 at 04:11:07PM -0400, Cathy Avery wrote:
> >> With NMI intercept moved to check_nested_events there is a race
> >> condition where vcpu->arch.nmi_pending is set late causing
> > How is nmi_pending set late?  The KVM_{G,S}ET_VCPU_EVENTS paths can't set
> > it because the current KVM_RUN thread holds the mutex, and the only other
> > call to process_nmi() is in the request path of vcpu_enter_guest, which has
> > already executed.
> > 
> 
> I think the actual cause is priority inversion between NMI and
> interrupts, because NMI is added last in patch 1.

Ah, that makes more sense.  I stared/glared at this exact code for a long
while and came to the conclusion that the "late" behavior was exclusive to
interrupts, would have been a shame if all that glaring was for naught.
