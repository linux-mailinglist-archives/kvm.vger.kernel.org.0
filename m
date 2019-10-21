Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29552DF002
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 16:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbfJUOim (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 10:38:42 -0400
Received: from [217.140.110.172] ([217.140.110.172]:54524 "EHLO foss.arm.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1727670AbfJUOil (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 10:38:41 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B3F521042;
        Mon, 21 Oct 2019 07:38:16 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2845D3F71F;
        Mon, 21 Oct 2019 07:38:15 -0700 (PDT)
Date:   Mon, 21 Oct 2019 15:38:13 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Steven Price <steven.price@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 01/10] KVM: arm64: Document PV-time interface
Message-ID: <20191021143812.GB56589@lakrids.cambridge.arm.com>
References: <20191011125930.40834-1-steven.price@arm.com>
 <20191011125930.40834-2-steven.price@arm.com>
 <20191015175651.GF24604@lakrids.cambridge.arm.com>
 <20191018171039.GA18838@lakrids.cambridge.arm.com>
 <d01edcb3-0d9a-d4ec-6a60-a82f3ffccba5@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d01edcb3-0d9a-d4ec-6a60-a82f3ffccba5@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 21, 2019 at 02:40:31PM +0100, Steven Price wrote:
> On 18/10/2019 18:10, Mark Rutland wrote:
> > On Tue, Oct 15, 2019 at 06:56:51PM +0100, Mark Rutland wrote:
> [...]
> >>> +PV_TIME_ST
> >>> +    ============= ========    ==========
> >>> +    Function ID:  (uint32)    0xC5000021
> >>> +    Return value: (int64)     IPA of the stolen time data structure for this
> >>> +                              VCPU. On failure:
> >>> +                              NOT_SUPPORTED (-1)
> >>> +    ============= ========    ==========
> >>> +
> >>> +The IPA returned by PV_TIME_ST should be mapped by the guest as normal memory
> >>> +with inner and outer write back caching attributes, in the inner shareable
> >>> +domain. A total of 16 bytes from the IPA returned are guaranteed to be
> >>> +meaningfully filled by the hypervisor (see structure below).
> >>
> >> At what granularity is this allowed to share IPA space with other
> >> mappings? The spec doesn't provide any guidance here, and I strongly
> >> suspect that it should.
> >>
> >> To support a 64K guest, we must ensure that this doesn't share a 64K IPA
> >> granule with any MMIO, and it probably only makes sense for an instance
> >> of this structure to share that granule with another vCPU's structure.
> >>
> >> We probably _also_ want to ensure that this doesn't share a 64K granule
> >> with memory the guest sees as regular system RAM. Otherwise we're liable
> >> to force it into having mismatched attributes for any of that RAM it
> >> happens to map as part of mapping the PV_TIME_ST structure.
> > 
> > I guess we can say that it's userspace's responsibiltiy to set this up
> > with sufficient alignment, but I do think we want to make a
> > recommendataion here.
> 
> I can add something like this to the kernel's documentation:
> 
>     It is advisable that one or more 64k pages are set aside for the
>     purpose of these structures and not used for other purposes, this
>     enables the guest to map the region using 64k pages and avoids
>     conflicting attributes with other memory.

Sounds good to me!

Thanks,
Mark.
