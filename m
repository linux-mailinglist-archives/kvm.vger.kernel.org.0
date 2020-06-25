Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D720620A0EC
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 16:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405395AbgFYOgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 10:36:42 -0400
Received: from vulcan.kevinlocke.name ([107.191.43.88]:42576 "EHLO
        vulcan.kevinlocke.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405340AbgFYOgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 10:36:42 -0400
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jun 2020 10:36:41 EDT
Received: from kevinolos (host-69-145-60-23.bln-mt.client.bresnan.net [69.145.60.23])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id 812B71A0E756;
        Thu, 25 Jun 2020 14:26:53 +0000 (UTC)
Received: by kevinolos (Postfix, from userid 1000)
        id 5F4711300552; Thu, 25 Jun 2020 08:26:51 -0600 (MDT)
Date:   Thu, 25 Jun 2020 08:26:51 -0600
From:   Kevin Locke <kevin@kevinlocke.name>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Andi Kleen <ak@linux.intel.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>
Subject: Re: qemu polling KVM_IRQ_LINE_STATUS when stopped
Message-ID: <20200625142651.GA154525@kevinolos>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>
References: <87a80pihlz.fsf@linux.intel.com>
 <20171018174946.GU5109@tassilo.jf.intel.com>
 <3d37ef15-932a-1492-3068-9ef0b8cd5794@redhat.com>
 <20171020003449.GG5109@tassilo.jf.intel.com>
 <22d62b58-725b-9065-1f6d-081972ca32c3@redhat.com>
 <20171020140917.GH5109@tassilo.jf.intel.com>
 <2db78631-3c63-5e93-0ce8-f52b313593e1@redhat.com>
 <20171020205026.GI5109@tassilo.jf.intel.com>
 <1560363269.13828538.1508539882580.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560363269.13828538.1508539882580.JavaMail.zimbra@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo et al.,

I recently noticed ~30% CPU usage on a paused Windows 10 VM, as
reported in https://bugs.launchpad.net/bugs/1851062 and
https://bugzilla.redhat.com/1638289 which, with the help of Christian
Ehrhardt, led to your previous discussion of the issue with Andi Kleen
at https://lore.kernel.org/kvm/87a80pihlz.fsf@linux.intel.com/ quoted
below:

On Fri, 2017-10-20 at 18:51 -0400, Paolo Bonzini wrote:
> On Fri, 2017-10-20 at 13:50 -0700, Andi Kleen wrote:
>> On Fri, Oct 20, 2017 at 05:12:40PM +0200, Paolo Bonzini wrote:
>>> On 20/10/2017 16:09, Andi Kleen wrote:
>>>>> Unfortunately that's not possible in general.  Windows uses the periodic
>>>>> timer to track wall time (!), so if you do that your clock is going to
>>>>> be late when you resume the guest.
>>>> 
>>>> But when the guest cannot execute instructions
>>>> it cannot see whatever the handler does.
>>>> 
>>>> So the handler could always catch up after stopping for longer,
>>>> without making any difference.
>>> 
>>> You may be right... you should get the interrupt storm *after
>>> continuing* the guest, but not while it's stopped.
>> 
>> Maybe be find to not have a storm, but only one. I belive real hardware
>> cannot have a storm because only one interrupt can be pending at a time.
> 
> Real hardware also doesn't pause for an extended period of time, with
> exceptions such as JTAG that aren't as prominent as pausing a virtual
> machine.  This is just how Windows works: unless it's S3/S4, it updates
> the time from RTC periodic timer ticks, and the frequency sometimes goes
> up as much as 1024 or 2048 Hz (default being 64 Hz IIRC).
> 
> In fact, we have a lot of cruft in KVM just to track periodic timer
> ticks that couldn't be delivered and retry again a little later.  Without
> that, the smallest load on the host is enough for time to drift in
> Windows guests.

I'm trying to understand the cause and what options might exist for
addressing it.  Several questions:

1. Do I understand correctly that the CPU usage is due to counting
   RTC periodic timer ticks for replay when the guest is resumed?
2. If so, would it be possible to calculate the number of ticks
   required from the time delta at resume, rather than polling each
   tick while paused?
3. Presumably when restoring from a snapshot, Windows time must jump
   forward from the time the snapshot was taken.  How does this differ
   from resuming from a paused state?
4. How is this handled if the host is suspended (S3) when the VM is
   paused (or not paused) and ticks aren't counted on the host?
5. I have not observed high CPU usage for paused VMs in VirtualBox.
   Would it be worth investigating how they handle this?

From the discussion in https://bugs.launchpad.net/bugs/1851062 it
appears that the issue does not occur for all Windows 10 VMs.  Does
that fit the theory it is caused by RTC periodic timer ticks?  In my
VM, clockres reports

    Maximum timer interval: 15.625 ms
    Minimum timer interval: 0.500 ms
    Current timer interval: 15.625 ms

immediately before and after pausing, suggesting that high periodic
tick frequency is not necessary to cause the issue.

Thanks,
Kevin
