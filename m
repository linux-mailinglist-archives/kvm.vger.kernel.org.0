Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06AAC23EFED
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 17:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgHGPWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 11:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgHGPWq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 11:22:46 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6AAC061756;
        Fri,  7 Aug 2020 08:22:46 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596813755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NVumAgezZv+7SVfB6Q2/Q8X5jlsIYt1eVjkbA1gdAYw=;
        b=4EQlx0KMb0meqiPGzR18ImjZq7WryZlWL+Wk7/0XxpI9c6/yULykLFr3nu6YZveprK0jmQ
        2hc/eLkG/qsh+mXKa61yIcVVPRhV8BLJFvhJ8P1ZRJum5AsynK7ZbfOOWyea+jCzK7NVEC
        SbNXq1fNSunkpoMw60WEF94xSccakAhh7MZHhvlHXiKcBIOJN5IQR+5bENh9jLeEU+3+Ta
        I5dLC6u+27CZhHOVbwaRoMkNMdsHK0VAVdaJfYqOsdJENLFg1W9zRdj9TuD7SQ7GPjBoXL
        phOY9PTQYgmjbwLVdmUwV2P+h88yDTUCPhqTV4r5h9Gi/jPPIejCXB2Gf3YnRw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596813755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NVumAgezZv+7SVfB6Q2/Q8X5jlsIYt1eVjkbA1gdAYw=;
        b=snOYMyrybLgc0p11pj36AhN+M0Ea0tL3D1T62sjEyZSxQB9iW8Bt1kc8zPiAhMnhZywXor
        B5a75eWk7dW5XNBA==
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Dey\, Megha" <megha.dey@intel.com>, Marc Zyngier <maz@kernel.org>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        "vkoul\@kernel.org" <vkoul@kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "rafael\@kernel.org" <rafael@kernel.org>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hpa\@zytor.com" <hpa@zytor.com>,
        "alex.williamson\@redhat.com" <alex.williamson@redhat.com>,
        "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj\, Ashok" <ashok.raj@intel.com>,
        "Liu\, Yi L" <yi.l.liu@intel.com>,
        "Lu\, Baolu" <baolu.lu@intel.com>,
        "Tian\, Kevin" <kevin.tian@intel.com>,
        "Kumar\, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        "Lin\, Jing" <jing.lin@intel.com>,
        "Williams\, Dan J" <dan.j.williams@intel.com>,
        "kwankhede\@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger\@redhat.com" <eric.auger@redhat.com>,
        "parav\@mellanox.com" <parav@mellanox.com>,
        "Hansen\, Dave" <dave.hansen@intel.com>,
        "netanelg\@mellanox.com" <netanelg@mellanox.com>,
        "shahafs\@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao\@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "Ortiz\, Samuel" <samuel.ortiz@intel.com>,
        "Hossain\, Mona" <mona.hossain@intel.com>,
        "dmaengine\@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86\@kernel.org" <x86@kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI irq domain
In-Reply-To: <20200807120650.GR16789@nvidia.com>
References: <96a1eb5ccc724790b5404a642583919d@intel.com> <20200805221548.GK19097@mellanox.com> <70465fd3a7ae428a82e19f98daa779e8@intel.com> <20200805225330.GL19097@mellanox.com> <630e6a4dc17b49aba32675377f5a50e0@intel.com> <20200806001927.GM19097@mellanox.com> <c6a1c065ab9b46bbaf9f5713462085a5@intel.com> <87tuxfhf9u.fsf@nanos.tec.linutronix.de> <014ffe59-38d3-b770-e065-dfa2d589adc6@intel.com> <87h7tfh6fc.fsf@nanos.tec.linutronix.de> <20200807120650.GR16789@nvidia.com>
Date:   Fri, 07 Aug 2020 17:22:34 +0200
Message-ID: <87y2mqfpl1.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jason,

Jason Gunthorpe <jgg@nvidia.com> writes:
> On Thu, Aug 06, 2020 at 10:21:11PM +0200, Thomas Gleixner wrote:
>
>> Optionally? Please tell the hardware folks to make this mandatory. We
>> have enough pain with non maskable MSI interrupts already so introducing
>> yet another non maskable interrupt trainwreck is not an option.
>
> Can you elaborate on the flows where Linux will need to trigger
> masking?

1) disable/enable_irq() obviously needs masking
   
2) Affinity changes are preferrably done with masking to avoid a
   boatload of nasty side effect. We have a "fix" for 32bit addressing
   mode which works by chance due to the layout but it would fail
   miserably with 64bit addressing mode. 64bit addressing mode is only
   relevant for more than 256 CPUs which requires X2APIC which in turn
   requires interrupt remapping. Interrupt remappind saves us here
   because the interrupt can be disabled at the remapping level.

3) The ability to shutdown an irq at the interrupt level in case of
   malfunction. Of course that's pure paranoia because devices are
   perfect and never misbehave :)

So it's nowhere in the hot path of interrupt handling itself.

> I expect that masking will be available in our NIC HW too - but it
> will require a spin loop if masking has to be done in an atomic
> context.

Yes, it's all in atomic context.

We have functionality in the interrupt core to do #1 and #2 from task
context (requires the caller to be in task context as well). #3 not so
much.

>> It's more than a decade now that I tell HW people not to repeat the
>> non-maskable MSI failure, but obviously they still think that
>> non-maskable interrupts are a brilliant idea. I know that HW folks
>> believe that everything they omit can be fixed in software, but they
>> have to finally understand that this particular issue _cannot_ be fixed
>> at all.
>
> Sure, the CPU should always be able to shut off an interrupt!

Oh yes!

> Maybe explaining the goals would help understand the HW perspective.
>
> Today HW can process > 100k queues of work at once. Interrupt delivery
> works by having a MSI index in each queue's metadata and the interrupt
> indirects through a MSI-X table on-chip which has the
> addr/data/mask/etc.
>
> What IMS proposes is that the interrupt data can move into the queue
> meta data (which is not required to be on-chip), eg along side the
> producer/consumer pointers, and the central MSI-X table is not
> needed. This is necessary because the PCI spec has very harsh design
> requirements for a MSI-X table that make scaling it prohibitive.

I know.

> So an IRQ can be silenced by deleting or stopping the queue(s)
> triggering it.

We cannot do that from the interrupt layer without squaring the
circle and violating all locking and layering rules in one go.

> It can be masked by including masking in the queue metadata. We can
> detect pending by checking the producer/consumer values.
>
> However synchronizing all the HW and all the state is now more
> complicated than just writing a mask bit via MMIO to an on-die memory.

That's one of the reasons why I think that the IMS handling has to be a
per device irqdomain with it's own interrupt chip because the way how
IMS is managed is completely device specific.

There is certainly opportunity for sharing some of the functionality and
code, but not by creating a pseudo-shared entity which is customized per
device with indirections and magic storage plus device specific IMS slot
management glued at it as a wart. Such concepts fall apart in no time or
end up in a completely unmaintainable mess.

Coming back to mask/unmask. We could lift that requirement if and only
if irq remapping is mandatory to make use of those magic devices because
the remapping unit allows us to do the masking. That still would not
justify the pseudo-shared irqdomain because the IMS slot management
still stays per device.

Thanks,

        tglx

