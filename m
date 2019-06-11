Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFFB3C0CC
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 03:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390101AbfFKBLB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 21:11:01 -0400
Received: from mga06.intel.com ([134.134.136.31]:45314 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388845AbfFKBLB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 21:11:01 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jun 2019 18:11:00 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga004.jf.intel.com with ESMTP; 10 Jun 2019 18:11:00 -0700
Date:   Mon, 10 Jun 2019 18:11:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 0/3] KVM: Yield to IPI target if necessary
Message-ID: <20190611011100.GB24835@linux.intel.com>
References: <1559178307-6835-1-git-send-email-wanpengli@tencent.com>
 <20190610143420.GA6594@flask>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190610143420.GA6594@flask>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 10, 2019 at 04:34:20PM +0200, Radim Krčmář wrote:
> 2019-05-30 09:05+0800, Wanpeng Li:
> > The idea is from Xen, when sending a call-function IPI-many to vCPUs, 
> > yield if any of the IPI target vCPUs was preempted. 17% performance 
> > increasement of ebizzy benchmark can be observed in an over-subscribe 
> > environment. (w/ kvm-pv-tlb disabled, testing TLB flush call-function 
> > IPI-many since call-function is not easy to be trigged by userspace 
> > workload).
> 
> Have you checked if we could gain performance by having the yield as an
> extension to our PV IPI call?
> 
> It would allow us to skip the VM entry/exit overhead on the caller.
> (The benefit of that might be negligible and it also poses a
>  complication when splitting the target mask into several PV IPI
>  hypercalls.)

Tangetially related to splitting PV IPI hypercalls, are there any major
hurdles to supporting shorthand?  Not having to generate the mask for
->send_IPI_allbutself and ->kvm_send_ipi_all seems like an easy to way
shave cycles for affected flows.
