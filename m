Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE7499870
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 17:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387689AbfHVPqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 11:46:14 -0400
Received: from foss.arm.com ([217.140.110.172]:48276 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730741AbfHVPqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 11:46:14 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A80BA337;
        Thu, 22 Aug 2019 08:46:13 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B7BD53F718;
        Thu, 22 Aug 2019 08:46:11 -0700 (PDT)
Subject: Re: [PATCH v3 04/10] KVM: Implement kvm_put_guest()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20190821153656.33429-1-steven.price@arm.com>
 <20190821153656.33429-5-steven.price@arm.com>
 <20190822152854.GE25467@linux.intel.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <e2abc69b-74c2-64ef-e270-43d93513eaae@arm.com>
Date:   Thu, 22 Aug 2019 16:46:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822152854.GE25467@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/08/2019 16:28, Sean Christopherson wrote:
> On Wed, Aug 21, 2019 at 04:36:50PM +0100, Steven Price wrote:
>> kvm_put_guest() is analogous to put_user() - it writes a single value to
>> the guest physical address. The implementation is built upon put_user()
>> and so it has the same single copy atomic properties.
> 
> What you mean by "single copy atomic"?  I.e. what guarantees does
> put_user() provide that __copy_to_user() does not?

Single-copy atomicity is defined by the Arm architecture[1] and I'm not
going to try to go into the full details here, so this is a summary.

For the sake of this feature what we care about is that the value
written/read cannot be "torn". In other words if there is a read (in
this case from another VCPU) that is racing with the write then the read
will either get the old value or the new value. It cannot return a
mixture. (This is of course assuming that the read is using a
single-copy atomic safe method).

__copy_to_user() is implemented as a memcpy() and as such cannot provide
single-copy atomicity in the general case (the buffer could easily be
bigger than the architecture can guarantee).

put_user() on the other hand is implemented (on arm64) as an explicit
store instruction and therefore is guaranteed by the architecture to be
single-copy atomic (i.e. another CPU cannot see a half-written value).

Steve

[1] https://static.docs.arm.com/ddi0487/ea/DDI0487E_a_armv8_arm.pdf#page=110
