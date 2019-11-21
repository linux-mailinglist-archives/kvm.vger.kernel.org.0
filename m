Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C63BD105489
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 15:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfKUOet (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 09:34:49 -0500
Received: from mga07.intel.com ([134.134.136.100]:15979 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbfKUOet (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 09:34:49 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Nov 2019 06:34:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,226,1571727600"; 
   d="scan'208";a="209921903"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga003.jf.intel.com with ESMTP; 21 Nov 2019 06:34:46 -0800
Date:   Thu, 21 Nov 2019 22:36:43 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com, yu.c.zhang@linux.intel.com,
        alazar@bitdefender.com, edwin.zhai@intel.com
Subject: Re: [PATCH v7 0/9] Enable Sub-Page Write Protection Support
Message-ID: <20191121143643.GA17169@local-michael-cet-test>
References: <20191119084949.15471-1-weijiang.yang@intel.com>
 <e1b64143-d372-81ae-349d-bcd72fd3b668@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1b64143-d372-81ae-349d-bcd72fd3b668@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 21, 2019 at 11:43:17AM +0100, Paolo Bonzini wrote:
> On 19/11/19 09:49, Yang Weijiang wrote:
> > EPT-Based Sub-Page write Protection(SPP) allows Virtual Machine Monitor(VMM)
> > specify write-permission for guest physical memory at a sub-page(128 byte)
> > granularity. When SPP works, HW enforces write-access check for sub-pages
> > within a protected 4KB page.
> > 
> > The feature targets to provide fine-grained memory protection for
> > usages such as memory guard and VM introspection etc.
> > 
> > SPP is active when the "sub-page write protection" (bit 23) is 1 in
> > Secondary VM-Execution Controls. The feature is backed with a Sub-Page
> > Permission Table(SPPT), and subpage permission vector is stored in the
> > leaf entry of SPPT. The root page is referenced via a Sub-Page Permission
> > Table Pointer (SPPTP) in VMCS.
> > 
> > To enable SPP for guest memory, the guest page should be first mapped
> > to a 4KB EPT entry, then set SPP bit 61 of the corresponding entry. 
> > While HW walks EPT, it traverses SPPT with the gpa to look up the sub-page
> > permission vector within SPPT leaf entry. If the corresponding bit is set,
> > write to sub-page is permitted, otherwise, SPP induced EPT violation is generated.
> > 
> > This patch serial passed SPP function test and selftest on Ice-Lake platform.
> > 
> > Please refer to the SPP introduction document in this patch set and
> > Intel SDM for details:
> > 
> > Intel SDM:
> > https://software.intel.com/sites/default/files/managed/39/c5/325462-sdm-vol-1-2abcd-3abcd.pdf
> > 
> > SPP selftest patch:
> > https://lkml.org/lkml/2019/6/18/1197
> 
> On top of the changes I sent for the individual patches, please move
> vmx/spp.c to mmu/spp.c, and vmx/spp.h to spp.h (I've just sent a patch
> to create the mmu/ directory).  Also, please include the selftest in
> this series.
> 
> Paolo
> 
Thanks Paolo! Will follow it.
