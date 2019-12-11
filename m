Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A16B11A9A8
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 12:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbfLKLIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 06:08:39 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:39660 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727493AbfLKLIj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 06:08:39 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iezrB-00070p-2G; Wed, 11 Dec 2019 12:08:37 +0100
To:     Gurchetan Singh <gurchetansingh@chromium.org>
Subject: Re: How to expose caching policy to a para-virtualized  =?UTF-8?Q?guest=3F?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 11 Dec 2019 11:08:36 +0000
From:   Marc Zyngier <maz@kernel.org>
Cc:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
In-Reply-To: <CAAfnVB=8aWSHXHOP8erepbuxOO_-yz04tm8ToA7pLwNAYqA-xQ@mail.gmail.com>
References: <CAAfnVB=8aWSHXHOP8erepbuxOO_-yz04tm8ToA7pLwNAYqA-xQ@mail.gmail.com>
Message-ID: <dee7353e807f5ea2c8a7e84623332f1b@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: gurchetansingh@chromium.org, kvm@vger.kernel.org, pbonzini@redhat.com, kraxel@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Gurchetan,

I don't know anything about graphics API, so please bear with me.

On 2019-12-11 01:32, Gurchetan Singh wrote:
> Hi,
>
> We're trying to implement Vulkan with virtio-gpu, and that API 
> exposes
> the difference between cached and uncached mappings to userspace 
> (i.e,
> some older GPUs can't snoop the CPU's caches).
>
> We need to make sure that the guest and host caching attributes are
> aligned, or there's a proper API between the virtio driver and device
> to ensure coherence.

I think you trying to cross two barriers at once here.

Virtio is always coherent between host and guest, and the guest should
use cacheable mappings. That's at least my expectation, and I don't
know of any exception to this rule.

You have then the coherency of the physical device, and that's a host
kernel (and maybe userspace) matter. Why should the guest ever know 
about
this constraint?

> One issue that needs to be addressed is the caching policy is 
> variable
> dependent on the VM configuration and architecture.  For example, on
> x86, it looks like a MTRR controls whether the guest caching 
> attribute
> predominates[1].  On ARM, it looks like the MMU registers control
> whether the guest can override the host attribute, but in general 
> it's
> most restrictive attribute that makes a difference[2].  Let me if
> that's incorrect.

For ARM, this is true up to ARMv8.3. Starting with ARMv8.4, FWB gives
the hypervisor the opportunity to force memory mappings as cacheable
write-back. None of that is visible to userspace, thankfully.

> I'm wondering if there's some standard kernel API to query such
> attributes.  For example, something like
> arch_does_guest_attribute_matter() or arch_can_guest_flush() would do
> the trick.  Without this, we may need to introduce VIRTIO_GPU_F_*
> flags set by the host, but that may make the already giant QEMU
> command line even bigger.

If something has to manage the coherency, it should be the host that
knows how the memory traffic flows between host and guest, and apply
cache management as required. Note that on arm64, cache management
instructions are available from userspace. On systems that are
fully coherent, they are expected to be little more than NOPs.

 From the above, it is pretty obvious that I don't understand what
problem you are trying to solve. Maybe you could explain how
you envisage things to work, who maps what where, and the expected
semantics. Once we have a common understanding of the problem,
maybe we can think of a decent solution.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
