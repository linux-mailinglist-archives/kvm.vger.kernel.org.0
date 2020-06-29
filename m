Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227AC20D606
	for <lists+kvm@lfdr.de>; Mon, 29 Jun 2020 22:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731896AbgF2TQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 15:16:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:63720 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726947AbgF2TQy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jun 2020 15:16:54 -0400
IronPort-SDR: 3u8gdtn0V+O33IBQP5QiQx220SHS3qyrILm1griFN9Qo1imHZdoN2suzZpHDccy7cuTNRi/Gwu
 idJCLgcQhD+A==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="164003720"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="164003720"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 08:42:12 -0700
IronPort-SDR: 1JiA3oy9vAT2yPS3waIF9GsF3Qi46ZkiEA044OeZ6BVgLNwWsT/dgLo/bEd0OHfyQOTpdfo1Yr
 q9wBQMk/UYjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="280906554"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 29 Jun 2020 08:42:12 -0700
Date:   Mon, 29 Jun 2020 08:42:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: Fix async pf caused null-ptr-deref
Message-ID: <20200629154212.GC12312@linux.intel.com>
References: <1593426391-8231-1-git-send-email-wanpengli@tencent.com>
 <877dvqc7cs.fsf@vitty.brq.redhat.com>
 <f9b06428-51c3-09af-48cc-d378182916fd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9b06428-51c3-09af-48cc-d378182916fd@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 29, 2020 at 03:59:25PM +0200, Paolo Bonzini wrote:
> On 29/06/20 15:46, Vitaly Kuznetsov wrote:
> >> +	if (!lapic_in_kernel(vcpu))
> >> +		return 1;
> >> +
> > I'm not sure how much we care about !lapic_in_kernel() case but this
> > change should be accompanied with userspace changes to not expose
> > KVM_FEATURE_ASYNC_PF_INT or how would the guest know that writing a
> > legitimate value will result in #GP?
> 
> Almost any pv feature is broken with QEMU if kernel_irqchip=off.  I
> wouldn't bother and I am seriously thinking of dropping all support for
> that, including:

Heh, based on my limited testing, that could be "Almost everything is
broken with Qemu if kernel_irqchip=off".

> - just injecting #UD for MOV from/to CR8 unless lapic_in_kernel()
> 
> - make KVM_INTERRUPT fail unless irqchip_in_kernel(), so that
> KVM_INTERRUPT is only used to inject EXTINT with kernel_irqchip=split
> 
> Paolo
> 
> > Alternatively, we may just return '0' here: guest will be able to check
> > what's in the MSR to see if the feature was enabled. Normally, guests
> > shouldn't care about this but maybe there are cases when they do?
> > 
> 
