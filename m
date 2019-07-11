Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0346265408
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 11:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbfGKJmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 05:42:04 -0400
Received: from foss.arm.com ([217.140.110.172]:43940 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbfGKJmE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 05:42:04 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2951337;
        Thu, 11 Jul 2019 02:42:03 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D3EC93F71F;
        Thu, 11 Jul 2019 02:42:02 -0700 (PDT)
Date:   Thu, 11 Jul 2019 10:42:00 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>, <kvm@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        <kvmarm@lists.cs.columbia.edu>
Subject: Re: [PATCH kvm-unit-tests] arm: Add PL031 test
Message-ID: <20190711104200.254073fb@donnerap.cambridge.arm.com>
In-Reply-To: <8c88eb2e-b401-42c7-f04f-2162f26af32c@redhat.com>
References: <20190710132724.28350-1-graf@amazon.com>
        <20190710180235.25c54b84@donnerap.cambridge.arm.com>
        <35e19306-d31b-187b-185d-e783f8d5a51a@redhat.com>
        <1537a9f2-9d23-97dd-b195-8239b263d5db@amazon.com>
        <8c88eb2e-b401-42c7-f04f-2162f26af32c@redhat.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Jul 2019 09:52:42 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

Hi,

> On 11/07/19 07:49, Alexander Graf wrote:
> >> I agree that it would belong more in qtest, but tests in not exactly the
> >> right place is better than no tests.  
> > 
> > The problem with qtest is that it tests QEMU device models from a QEMU
> > internal view.  
> 
> Not really: fundamentally it tests QEMU device models with stimuli that
> come from another process in the host, rather than code that runs in a
> guest.  It does have hooks into QEMU's internal view (mostly to
> intercept interrupts and advance the clocks), but the main feature of
> the protocol is the ability to do memory reads and writes.
> 
> > I am much more interested in the guest visible side of things. If
> > kvmtool wanted to implement a PL031, it should be able to execute the
> > same test that we run against QEMU, no?  

One of the design goals of kvmtool is to get away with as little emulation
as possible, in favour of paravirtualisation (so it's just virtio and not
IDE/flash). So a hardware RTC emulation sounds dispensable in this context.
 
> Well, kvmtool could also implement the qtest protocol; perhaps it should
> (probably as a different executable that shares the device models with
> the main kvmtool executable).  There would still be issues in reusing
> code from the QEMU tests, since it has references to QEMU command line
> options.

I had some patches to better abstract kvm-unit-tests from QEMU, basically
by splitting up extra_params into more generic options like memsize and
command_line, then translating them.
Sounds like the time to revive them.

> > If kvm-unit-test is the wrong place for it, we would probably want to
> > have a separate testing framework for guest side unit tests targeting
> > emulated devices.
> > 
> > Given how nice the kvm-unit-test framework is though, I'd rather rename
> > it to "virt-unit-test" than reinvent the wheel :).  
> 
> Definitely, or even just "hwtest". :)  With my QEMU hat I would prefer
> the test to be a qtest, but with my kvm-unit-tests hat on I see no
> reason to reject this test.  Sorry if this was not clear.

Fair enough, at the moment we have to trigger kvmtool tests manually
anyway. Just wanted to know what the idea is here, which I think you
answered.

Thanks,
Andre.
