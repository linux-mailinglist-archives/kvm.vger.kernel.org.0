Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F341C3E91
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 17:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbgEDPdp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 11:33:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:7968 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728641AbgEDPdo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 11:33:44 -0400
IronPort-SDR: py77krxLcPmVlmbPhiK9PryiJgRHoqCO3uB/FHa2FylAOmurpxSCfAcL2uT4nwamEpoNmxK2UE
 dT7f4BbPNVxA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 08:33:44 -0700
IronPort-SDR: 0rgde3xDthNXHxX+v6bO1rX+ZlxWzI1ZnGZwuNdsyO8Nsdvzvqfwj2JJ/kDWnC41Hf3Qh++QPA
 1V/7++o65v4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,352,1583222400"; 
   d="scan'208";a="294656227"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga002.fm.intel.com with ESMTP; 04 May 2020 08:33:43 -0700
Date:   Mon, 4 May 2020 08:33:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v4] KVM: VMX: Improve handle_external_interrupt_irqoff
 inline assembly
Message-ID: <20200504153343.GD16949@linux.intel.com>
References: <20200503230545.442042-1-ubizjak@gmail.com>
 <20200504152519.GC16949@linux.intel.com>
 <CAFULd4bWmcrsdfeyc++P9pGhn-MS703yWisKKmr601nAvP86gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFULd4bWmcrsdfeyc++P9pGhn-MS703yWisKKmr601nAvP86gw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 04, 2020 at 05:32:19PM +0200, Uros Bizjak wrote:
> On Mon, May 4, 2020 at 5:25 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Mon, May 04, 2020 at 01:05:45AM +0200, Uros Bizjak wrote:
> > > Improve handle_external_interrupt_irqoff inline assembly in several ways:
> > > - use "re" operand constraint instead of "i" and remove
> > >   unneeded %c operand modifiers and "$" prefixes
> > > - use %rsp instead of _ASM_SP, since we are in CONFIG_X86_64 part
> > > - use $-16 immediate to align %rsp
> > > - remove unneeded use of __ASM_SIZE macro
> > > - define "ss" named operand only for X86_64
> > >
> > > The patch introduces no functional changes.
> >
> > Hmm, for handcoded assembly I would argue that the switch from "i" to "re"
> > is a functional change of sorts.  The switch also needs explicit
> > justification to explain why it's correct/desirable.  Maybe make it a
> > separate patch?
> 
> I think this would be a good idea. So, in this patch the first point should read
> 
> "- remove unneeded %c operand modifiers and "$" prefixes"
> 
> The add-on patch will then explain that PUSH can only handle signed
> 32bit immediates and change "i" to "re".
> 
> Is this what you had in mind?

Yep, exactly.
