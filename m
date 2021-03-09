Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC1C3323FF
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 12:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhCIL1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 06:27:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229775AbhCIL1E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 06:27:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 625AD65256;
        Tue,  9 Mar 2021 11:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615289224;
        bh=3mvvIYMbhn0yW3e9UoJuGvQ6p3EJb2dOKQp50ugFPzI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bKZJAmV6h9VHQFlVpmt82CfSGeCMNGU/kUQxE5g7rAmN3jk7sKCadAyge8DNRJzou
         28xOaif1rNN/v+6n+tSa2QIBpUnwNox+3jHjHbPEyPs6kwKTlzWZVjo3vakHJok31e
         ISFRxLSwoYQzuqlK6p7WepW/+vVB8BNrzUhM/eQoyJMlplrJHT7si8jZCVOp9+uNMB
         qT+V+KrCLLYLMm/qE0BfuloLdROwPxcMM/bws7TJ8NAGMfFhCIROhRlSHi1QMmdps2
         1Vx00sIaMiSStYqsD9R5bVY9iYRRDuaRVRQx6SbLejD6m4hlw+sHWhOl1GkOeOh1zr
         7whrO1fVvdKUQ==
Date:   Tue, 9 Mar 2021 11:26:59 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Cap default IPA size to the host's own size
Message-ID: <20210309112658.GA28025@willie-the-truck>
References: <20210308174643.761100-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308174643.761100-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021 at 05:46:43PM +0000, Marc Zyngier wrote:
> KVM/arm64 has forever used a 40bit default IPA space, partially
> due to its 32bit heritage (where the only choice is 40bit).
> 
> However, there are implementations in the wild that have a *cough*
> much smaller *cough* IPA space, which leads to a misprogramming of
> VTCR_EL2, and a guest that is stuck on its first memory access
> if userspace dares to ask for the default IPA setting (which most
> VMMs do).
> 
> Instead, cap the default IPA size to what the host can actually
> do, and spit out a one-off message on the console. The boot warning
> is turned into a more meaningfull message, and the new behaviour
> is also documented.
> 
> Although this is a userspace ABI change, it doesn't really change
> much for userspace:
> 
> - the guest couldn't run before this change, while it now has
>   a chance to if the memory range fits the reduced IPA space
> 
> - a memory slot that was accepted because it did fit the default
>   IPA space but didn't fit the HW constraints is now properly
>   rejected
> 
> The other thing that's left doing is to convince userspace to
> actually use the IPA space setting instead of relying on the
> antiquated default.

Is there a way for userspace to discover the default IPA size, or does
it have to try setting values until it finds one that sticks?

Will
