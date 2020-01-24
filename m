Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC2B149025
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 22:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbgAXVaa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 16:30:30 -0500
Received: from mga12.intel.com ([192.55.52.136]:48886 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbgAXVaa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jan 2020 16:30:30 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jan 2020 13:30:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,358,1574150400"; 
   d="scan'208";a="221148350"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 24 Jan 2020 13:30:28 -0800
Date:   Fri, 24 Jan 2020 13:30:28 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM <kvm@vger.kernel.org>
Subject: Re: linux-next: Tree for Jan 24 (kvm)
Message-ID: <20200124213027.GP2109@linux.intel.com>
References: <20200124173302.2c3228b2@canb.auug.org.au>
 <38d53302-b700-b162-e766-2e2a461fc569@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38d53302-b700-b162-e766-2e2a461fc569@infradead.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 24, 2020 at 12:51:31PM -0800, Randy Dunlap wrote:
> On 1/23/20 10:33 PM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20200123:
> > 
> > The kvm tree gained a conflict against Linus' tree.
> > 
> 
> on i386:
> 
> ../arch/x86/kvm/x86.h:363:16: warning: right shift count >= width of type [-Wshift-count-overflow]

Jim, 

This is due to using "unsigned long data" for kvm_dr7_valid() along with
"return !(data >> 32);" to check for bits being set in 63:32.  Any
objection to fixing the issue by making @data a u64?  Part of me thinks
that's the proper behavior anyways, i.e. the helper is purely a reflection
of the architectural requirements, the caller is responsible for dropping
bits appropriately based on the current mode.

> 
> 
> -- 
> ~Randy
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
