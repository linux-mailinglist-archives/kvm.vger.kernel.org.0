Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9FAA9932F
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 14:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731418AbfHVMV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 08:21:26 -0400
Received: from foss.arm.com ([217.140.110.172]:45030 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731132AbfHVMV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 08:21:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B1D7C337;
        Thu, 22 Aug 2019 05:21:25 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E78B13F706;
        Thu, 22 Aug 2019 05:21:24 -0700 (PDT)
Subject: Re: [PATCH v2] arm64: KVM: Only skip MMIO insn once
To:     Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     mark.rutland@arm.com
References: <20190822110305.18035-1-drjones@redhat.com>
From:   Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <af0737b1-ffe8-1ace-5aab-f08331b6d940@kernel.org>
Date:   Thu, 22 Aug 2019 13:21:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822110305.18035-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/08/2019 12:03, Andrew Jones wrote:
> If after an MMIO exit to userspace a VCPU is immediately run with an
> immediate_exit request, such as when a signal is delivered or an MMIO
> emulation completion is needed, then the VCPU completes the MMIO
> emulation and immediately returns to userspace. As the exit_reason
> does not get changed from KVM_EXIT_MMIO in these cases we have to
> be careful not to complete the MMIO emulation again, when the VCPU is
> eventually run again, because the emulation does an instruction skip
> (and doing too many skips would be a waste of guest code :-) We need
> to use additional VCPU state to track if the emulation is complete.
> As luck would have it, we already have 'mmio_needed', which even
> appears to be used in this way by other architectures already.
> 
> Fixes: 0d640732dbeb ("arm64: KVM: Skip MMIO insn after emulation")
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
> v2: move mmio_needed use closer to other mmio state use [maz]
> 
>  virt/kvm/arm/mmio.c | 7 +++++++
>  1 file changed, 7 insertions(+)

Applied with Mark's Ack.

Thanks,

	M.
-- 
Jazz is not dead, it just smells funny...
