Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3B0E9B239
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 16:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395371AbfHWOh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 10:37:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:62650 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393066AbfHWOh5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 10:37:57 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 07:37:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,421,1559545200"; 
   d="scan'208";a="196492866"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 23 Aug 2019 07:37:55 -0700
Date:   Fri, 23 Aug 2019 07:37:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [RESEND PATCH 01/13] KVM: x86: Relocate MMIO exit stats counting
Message-ID: <20190823143755.GA6713@linux.intel.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com>
 <20190823010709.24879-2-sean.j.christopherson@intel.com>
 <87d0gwp7ix.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d0gwp7ix.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 23, 2019 at 11:15:18AM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Move the stat.mmio_exits update into x86_emulate_instruction().  This is
> > both a bug fix, e.g. the current update flows will incorrectly increment
> > mmio_exits on emulation failure, and a preparatory change to set the
> > stage for eliminating EMULATE_DONE and company.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> This, however, makes me wonder why this is handled in x86-specific code
> in the first place, can we just count KVM_EXIT_MMIO exits when handling
> KVM_RUN?

struct kvm_vcpu_stat is arch specific.  At a glance, everyone is counting
similar things, but often in slightly different ways.  E.g. PowerPC and
ARM count MMIO exits, but PowerPC counts all exits, ARM has separate
counters for in-kernel vs. userspace, and x86 counts only userspace.
