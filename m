Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA36298EDE
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 15:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780310AbgJZOIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 10:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1780302AbgJZOIi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 10:08:38 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3405F2242A;
        Mon, 26 Oct 2020 14:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603721318;
        bh=piPyVG4naoRlpa5Gf3UOt8KiGpTMaw7CwHneYKoEims=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P4Dfr9oOop2NEpcLIejN6byw2vAQtq2F3IQ3NfTLPnTq5m2Rk5j+r4T/EJ8jUek+J
         eGJ9/CXQG7VRoEvBtjYDQ5AdPd9pPZFhMNOXyItxICFcdliZFFSXWv2HNeZfHW5bo1
         U1ZFlbClUSGIXji/cpUxk8ArIMPUIMCLzyo4NPnY=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kX3Aq-004LSu-3z; Mon, 26 Oct 2020 14:08:36 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 26 Oct 2020 14:08:35 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 01/11] KVM: arm64: Don't adjust PC on SError during SMC
 trap
In-Reply-To: <20201026135308.GC12454@C02TD0UTHF1T.local>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-2-maz@kernel.org>
 <20201026135308.GC12454@C02TD0UTHF1T.local>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <b85f3ed6b97944055eda7f4bfeae8abc@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-10-26 13:53, Mark Rutland wrote:
> On Mon, Oct 26, 2020 at 01:34:40PM +0000, Marc Zyngier wrote:
>> On SMC trap, the prefered return address is set to that of the SMC
>> instruction itself. It is thus wrong to tyr and roll it back when
> 
> Typo: s/tyr/try/
> 
>> an SError occurs while trapping on SMC. It is still necessary on
>> HVC though, as HVC doesn't cause a trap, and sets ELR to returning
>> *after* the HVC.
>> 
>> It also became apparent that the is 16bit encoding for an AArch32
> 
> I guess s/that the is/that there is no/ ?

Something along these lines, yes! ;-)

> 
>> HVC instruction, meaning that the displacement is always 4 bytes,
>> no matter what the ISA is. Take this opportunity to simplify it.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> Assuming that there is no 16-bit HVC:

It is actually impossible to have a 16bit encoding for HVC, as
it always convey a 16bit immediate, and you need some space
to encode the instruction itself!

> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
