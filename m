Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF78B236E
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 17:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388084AbfIMPc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 11:32:57 -0400
Received: from foss.arm.com ([217.140.110.172]:45788 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727452AbfIMPc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 11:32:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB2A21000;
        Fri, 13 Sep 2019 08:32:55 -0700 (PDT)
Received: from [10.1.197.57] (e110467-lin.cambridge.arm.com [10.1.197.57])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A2CC43F67D;
        Fri, 13 Sep 2019 08:32:50 -0700 (PDT)
Subject: Re: KASAN: slab-out-of-bounds Read in handle_vmptrld
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     mark.rutland@arm.com, x86@kernel.org, wanpengli@tencent.com,
        kvm@vger.kernel.org, narmstrong@baylibre.com,
        catalin.marinas@arm.com, will.deacon@arm.com, hpa@zytor.com,
        khilman@baylibre.com, joro@8bytes.org, rkrcmar@redhat.com,
        mingo@redhat.com, Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+46f1dd7dbbe2bfb98b10@syzkaller.appspotmail.com>,
        devicetree@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        robh+dt@kernel.org, bp@alien8.de,
        linux-amlogic@lists.infradead.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, jmattson@google.com,
        USB list <linux-usb@vger.kernel.org>,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
        carlo@caione.org, Vitaly Kuznetsov <vkuznets@redhat.com>
References: <000000000000a9d4f705924cff7a@google.com>
 <87lfutei1j.fsf@vitty.brq.redhat.com>
 <5218e70e-8a80-7c5f-277b-01d9ab70692a@redhat.com>
 <20190913044614.GA120223@kroah.com>
 <db02a285-ad1d-6094-6359-ba80e6d3f2e0@redhat.com>
 <20190913130226.GB403359@kroah.com>
 <6a0ec3a2-2a52-f67a-6140-e0a60874538a@redhat.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <462660f4-1537-cece-b55f-0ceba0269eb8@arm.com>
Date:   Fri, 13 Sep 2019 16:32:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <6a0ec3a2-2a52-f67a-6140-e0a60874538a@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/09/2019 16:01, Paolo Bonzini wrote:
> On 13/09/19 15:02, Greg Kroah-Hartman wrote:
>> Look at linux-next, we "should" have fixed up hcd_buffer_alloc() now to
>> not need this type of thing.  If we got it wrong, please let us know and
>> then yes, a fix like this would be most appreciated :)
> 
> I still see
> 
> 	/* some USB hosts just use PIO */
> 	if (!hcd_uses_dma(hcd)) {
> 		*dma = ~(dma_addr_t) 0;
> 		return kmalloc(size, mem_flags);
> 	}
> 
> in linux-next's hcd_buffer_alloc and also in usb.git's usb-next branch.
>   I also see the same
> 
> 	if (remap_pfn_range(vma, vma->vm_start,
> 			virt_to_phys(usbm->mem) >> PAGE_SHIFT,
> 			size, vma->vm_page_prot) < 0) {
> 		...
> 	}
> 
> in usbdev_mmap.  Of course it's possible that I'm looking at the wrong
> branch, or just being dense.

Oh, that bit of usbdev_mmap() is already known to be pretty much totally 
bogus for various reasons - there have been a few threads about it, of 
which I think [1] is both the most recent and the most informative. 
There was another patch[2], but that might have stalled (and might need 
reworking with additional hcd_uses_dma() checks anyway).

Robin.

[1] 
https://lore.kernel.org/linux-arm-kernel/20190808084636.GB15080@priv-mua.localdomain/
[2] 
https://lore.kernel.org/linux-usb/20190801220134.3295-1-gavinli@thegavinli.com/
