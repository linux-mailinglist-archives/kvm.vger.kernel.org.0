Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBE328D57A
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 16:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfHNOAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 10:00:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:6613 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726865AbfHNOAd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 10:00:33 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Aug 2019 07:00:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,385,1559545200"; 
   d="scan'208";a="167434926"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.128])
  by orsmga007.jf.intel.com with ESMTP; 14 Aug 2019 07:00:31 -0700
Date:   Wed, 14 Aug 2019 22:02:12 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
        mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        yu.c.zhang@intel.com, alazar@bitdefender.com
Subject: Re: [PATCH RESEND v4 0/9] Enable Sub-page Write Protection Support
Message-ID: <20190814140212.GA7625@local-michael-cet-test.sh.intel.com>
References: <20190814070403.6588-1-weijiang.yang@intel.com>
 <5db7a1fc-994f-f95b-5813-ffe1801dbfbc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5db7a1fc-994f-f95b-5813-ffe1801dbfbc@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 14, 2019 at 02:36:30PM +0200, Paolo Bonzini wrote:
> On 14/08/19 09:03, Yang Weijiang wrote:
> > EPT-Based Sub-Page write Protection(SPP)is a HW capability which allows
> > Virtual Machine Monitor(VMM) to specify write-permission for guest
> > physical memory at a sub-page(128 byte) granularity. When this
> > capability is enabled, the CPU enforces write-access check for sub-pages
> > within a 4KB page.
> > 
> > The feature is targeted to provide fine-grained memory protection for
> > usages such as device virtualization, memory check-point and VM
> > introspection etc.
> > 
> > SPP is active when the "sub-page write protection" (bit 23) is 1 in
> > Secondary VM-Execution Controls. The feature is backed with a Sub-Page
> > Permission Table(SPPT), SPPT is referenced via a 64-bit control field
> > called Sub-Page Permission Table Pointer (SPPTP) which contains a
> > 4K-aligned physical address.
> > 
> > Right now, only 4KB physical pages are supported for SPP. To enable SPP
> > for certain physical page, we need to first make the physical page
> > write-protected, then set bit 61 of the corresponding EPT leaf entry. 
> > While HW walks EPT, if bit 61 is set, it traverses SPPT with the guset
> > physical address to find out the sub-page permissions at the leaf entry.
> > If the corresponding bit is set, write to sub-page is permitted,
> > otherwise, SPP induced EPT violation is generated.
> 
> Still no testcases?
> 
> Paolo

Hi, Paolo,
The testcases are included in selftest: https://lkml.org/lkml/2019/6/18/1197

