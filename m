Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E70124AA7
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 16:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfLRPHy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 10:07:54 -0500
Received: from foss.arm.com ([217.140.110.172]:49406 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726998AbfLRPHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 10:07:54 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5533C30E;
        Wed, 18 Dec 2019 07:07:53 -0800 (PST)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 554673F719;
        Wed, 18 Dec 2019 07:07:51 -0800 (PST)
Subject: Re: [PATCH 7/7] KVM: arm/arm64: Elide CMOs when unmapping a range
To:     Marc Zyngier <maz@kernel.org>
Cc:     Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org
References: <20191213182503.14460-1-maz@kernel.org>
 <20191213182503.14460-8-maz@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <0c832b27-7041-a6c8-31c0-d71a25c6f5b8@arm.com>
Date:   Wed, 18 Dec 2019 15:07:48 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191213182503.14460-8-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 13/12/2019 18:25, Marc Zyngier wrote:
> If userspace issues a munmap() on a set of pages, there is no
> expectation that the pages are cleaned to the PoC.

(Pedantry: Clean and invalidate. If the guest wrote through a device mapping, we ditch any
clean+stale lines with this path, meaning swapout saves the correct values)


> So let's
> not do more work than strictly necessary, and set the magic
> flag that avoids CMOs in this case.

I think this assumes the pages went from anonymous->free, so no-one cares about the contents.

If the pages are backed by a file, won't dirty pages will still get written back before
the page is free? (e.g. EFI flash 'file' mmap()ed in)

What if this isn't the only mapping of the page? Can't it be swapped out from another VMA?
(tenuous example, poor man's memory mirroring?)


Thanks,

James
