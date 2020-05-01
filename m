Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3498C1C1FBE
	for <lists+kvm@lfdr.de>; Fri,  1 May 2020 23:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgEAViF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 17:38:05 -0400
Received: from mga05.intel.com ([192.55.52.43]:4924 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgEAViE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 May 2020 17:38:04 -0400
IronPort-SDR: eiAEu5y7Kad6DH5DEtqlnqNsUXLykTAXEUCZKxypEvvSg36YDT3WPFGpxcpH3SGoEXWxF9aGMH
 XnnHZduGftZw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 14:38:03 -0700
IronPort-SDR: RRD85nzjzmo7I/0Q2wOa3LAHg0d0qYdHv1HBEOFQtPPYIVP0MYmIaWaVCmK02RnP/06m34eUS1
 LwWWLerkMiLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,341,1583222400"; 
   d="scan'208";a="405857296"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga004.jf.intel.com with ESMTP; 01 May 2020 14:38:03 -0700
Date:   Fri, 1 May 2020 14:38:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Joshua Abraham <j.abraham1776@gmail.com>
Cc:     pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: kvm: Fix KVM_KVMCLOCK_CTRL API doc
Message-ID: <20200501213803.GF4760@linux.intel.com>
References: <20200501193404.GA19745@josh-ZenBook>
 <20200501201836.GB4760@linux.intel.com>
 <20200501203234.GA20693@josh-ZenBook>
 <20200501205106.GE4760@linux.intel.com>
 <20200501211040.GA22118@josh-ZenBook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501211040.GA22118@josh-ZenBook>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 01, 2020 at 05:10:40PM -0400, Joshua Abraham wrote:
> On Fri, May 01, 2020 at 01:51:06PM -0700, Sean Christopherson wrote:
> > I don't disagree, but simply doing s/host/guest yields a misleading
> > sentence and inconsistencies with the rest of the paragraph.
> 
> I see your point. Would this wording be clearer:
> 
> "This ioctl sets a flag accessible to the guest indicating that it has been
> paused from the host userspace.

Ya.  Minor nit, probably worth clarifying that 'it' refers to the vCPU, e.g.

  This ioctl sets a flag accessible to the guest indicating that the specified
  vCPU has been paused by the host userspace.

> 
> The host will set a flag in the pvclock structure that is checked
> from the soft lockup watchdog.  The flag is part of the pvclock structure that
> is shared between guest and host, specifically the second bit of the flags
> field of the pvclock_vcpu_time_info structure.  It will be set exclusively by
> the host and read/cleared exclusively by the guest.  The guest operation of
> checking and clearing the flag must be an atomic operation so
> load-link/store-conditional, or equivalent must be used.  There are two cases
> where the guest will clear the flag: when the soft lockup watchdog timer resets
> itself or when a soft lockup is detected.  This ioctl can be called any time
> after pausing the vcpu, but before it is resumed."
