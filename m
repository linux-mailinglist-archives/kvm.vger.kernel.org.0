Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96E38D3A3F
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2019 09:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbfJKHsn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Oct 2019 03:48:43 -0400
Received: from mga06.intel.com ([134.134.136.31]:51255 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726853AbfJKHsm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Oct 2019 03:48:42 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Oct 2019 00:48:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,283,1566889200"; 
   d="scan'208";a="224257084"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga002.fm.intel.com with ESMTP; 11 Oct 2019 00:48:40 -0700
Date:   Fri, 11 Oct 2019 15:50:33 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        yu.c.zhang@intel.com, alazar@bitdefender.com
Subject: Re: [PATCH v5 0/9] Enable Sub-page Write Protection Support
Message-ID: <20191011075033.GA11817@local-michael-cet-test>
References: <20190917085304.16987-1-weijiang.yang@intel.com>
 <CALMp9eSTz+XbmLtWZLqWvSNjjb4Ado4s+SfABtRuVNQBXUHStQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSTz+XbmLtWZLqWvSNjjb4Ado4s+SfABtRuVNQBXUHStQ@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 10, 2019 at 02:42:51PM -0700, Jim Mattson wrote:
> On Tue, Sep 17, 2019 at 1:52 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
> >
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
> > To enable SPP for certain physical page, the gfn should be first mapped
> > to a 4KB entry, then set bit 61 of the corresponding EPT leaf entry.
> > While HW walks EPT, if bit 61 is set, it traverses SPPT with the guset
> > physical address to find out the sub-page permissions at the leaf entry.
> > If the corresponding bit is set, write to sub-page is permitted,
> > otherwise, SPP induced EPT violation is generated.
> 
> How do you handle sub-page permissions for instructions emulated by kvm?
How about checking if the gpa is SPP protected, if it is, inject some
exception to guest? 
