Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610F368A446
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 22:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbjBCVJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 16:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbjBCVJV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 16:09:21 -0500
Received: from out-29.mta1.migadu.com (out-29.mta1.migadu.com [IPv6:2001:41d0:203:375::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65ED59B719
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 13:08:15 -0800 (PST)
Date:   Fri, 3 Feb 2023 21:08:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675458492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zF794bsssBgYs01gtLHUkS28EIicNc0l0YnvFt/94YI=;
        b=gF+Ot9L7bvkYWgstVlN3IGR5gepXbOhnLUW+ryxf0GGE8OvgoAe8gh4332GPCHIBnUEDfl
        OstQTXxU52klLCCbGsxtBPABUoe9zoYwljDknwyOPX3XqLcs69d34u9p3+onFADs6Ko7Qx
        oTbdNErPix3LGrijaxdz/cn1jgoVGFY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     James Morse <james.morse@arm.com>
Cc:     linux-pm@vger.kernel.org, loongarch@lists.linux.dev,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Len Brown <lenb@kernel.org>,
        Rafael Wysocki <rafael@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Salil Mehta <salil.mehta@huawei.com>,
        Russell King <linux@armlinux.org.uk>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: Re: [RFC PATCH 29/32] KVM: arm64: Pass hypercalls to userspace
Message-ID: <Y913sIqWxmf4O5oG@google.com>
References: <20230203135043.409192-1-james.morse@arm.com>
 <20230203135043.409192-30-james.morse@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203135043.409192-30-james.morse@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi James,

On Fri, Feb 03, 2023 at 01:50:40PM +0000, James Morse wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> When capability KVM_CAP_ARM_HVC_TO_USER is available, userspace can
> request to handle all hypercalls that aren't handled by KVM.

I would very much prefer we not go down this route. This capability
effectively constructs an ABI out of what KVM presently does not
implement. What would happen if KVM decides to implement a new set
of hypercalls later down the road that were previously forwarded to
userspace?

Instead of a catch-all I think we should take the approach of having
userspace explicitly request which hypercalls should be forwarded to
userspace. I proposed something similar [1], but never got around to
respinning it (oops).

Let me dust those patches off and align with Marc's suggestions.

[1]: https://lore.kernel.org/kvmarm/20221110015327.3389351-1-oliver.upton@linux.dev/

--
Thanks,
Oliver
