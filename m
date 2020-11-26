Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E342C5857
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 16:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391408AbgKZPeT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 10:34:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:49458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730987AbgKZPeR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Nov 2020 10:34:17 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0729821D46;
        Thu, 26 Nov 2020 15:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606404857;
        bh=Igx9jXBr7rpPOrw2MqxIsTEP9nndo9myMGoaHB2g/iU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nIqV3mB40duYn7B9JjVKyQhYGKWwujORRiFiiVPiXLxlIOSwKwVa0X9U9n6FOVCxT
         DxkADEC1BnDQ6kWO4ArX0X+EjeN4eSH2VJJUIlGiuydBv1nTNbUW6eerpsJVp+bF7j
         hTaLSTLt1uiueA5OJ0v/jqA+fYaZIT3C/smkDufQ=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kiJHi-00DqFH-DH; Thu, 26 Nov 2020 15:34:14 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 26 Nov 2020 15:34:14 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH 6/8] KVM: arm64: Remove dead PMU sysreg decoding code
In-Reply-To: <1ed6dfd6-4ace-a562-bc2f-054a5c853fa6@arm.com>
References: <20201113182602.471776-1-maz@kernel.org>
 <20201113182602.471776-7-maz@kernel.org>
 <1ed6dfd6-4ace-a562-bc2f-054a5c853fa6@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <3ae09ecc95b732129f71076b4b59c873@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 2020-11-26 15:18, Alexandru Elisei wrote:
> Hi Marc,
> 
> I checked and indeed the remaining cases cover all registers that use
> this accessor.
> 
> However, I'm a bit torn here. The warning that I got when trying to run 
> a guest
> with the PMU feature flag set, but not initialized (reported at [1])
> was also not
> supposed to ever be reached:
> 
> static u32 kvm_pmu_event_mask(struct kvm *kvm)
> {
>     switch (kvm->arch.pmuver) {
>     case 1:            /* ARMv8.0 */
>         return GENMASK(9, 0);
>     case 4:            /* ARMv8.1 */
>     case 5:            /* ARMv8.4 */
>     case 6:            /* ARMv8.5 */
>         return GENMASK(15, 0);
>     default:        /* Shouldn't be here, just for sanity */
>         WARN_ONCE(1, "Unknown PMU version %d\n", kvm->arch.pmuver);
>         return 0;
>     }
> }
> 
> I realize it's not exactly the same thing and I'll leave it up to you
> if you want
> to add a warning for the cases that should never happen. I'm fine 
> either way:

I already have queued such a warning[1]. It turns out that LLVM warns
idx can be left uninitialized, and shouts. Let me know if that works
for you.

Thanks,

         M.

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=kvm-arm64/pmu-undef&id=af7eff70eaf8f28179334f5aeabb70a306242c83
-- 
Jazz is not dead. It just smells funny...
