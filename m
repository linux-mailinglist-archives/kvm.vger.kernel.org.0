Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140BC2C2387
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 12:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732467AbgKXLCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 06:02:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:59914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732463AbgKXLCO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Nov 2020 06:02:14 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A9E82083E;
        Tue, 24 Nov 2020 11:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606215733;
        bh=1cxLgDpJmbdMl+KoljU+RVmexumupWZLEWD2oMoaKUU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q75xZPDVFkN48q5ixVGY/INzSkna2IoQiNKgDb4iGJT45iswpwLADZaC+ly61ri94
         8re58ReAIjl1Tnv1nU4Or8bpJk8xty90DFENNPZRJeKjb7j+ycPeOjyIMlv6xGWwzZ
         3eBoXOh0wLdMYbdnDeNWJqq/1f0SacT67S0XRqYc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1khW5L-00DE77-AT; Tue, 24 Nov 2020 11:02:11 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 24 Nov 2020 11:02:11 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Jingyi Wang <wangjingyi11@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, will@kernel.org,
        catalin.marinas@arm.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        wanghaibin.wang@huawei.com, yezengruan@huawei.com,
        shameerali.kolothum.thodi@huawei.com, fanhenglong@huawei.com,
        prime.zeng@hisilicon.com
Subject: Re: [RFC PATCH 0/4] Add support for ARMv8.6 TWED feature
In-Reply-To: <9d341a2d-19f8-400c-6674-ef991ab78f62@huawei.com>
References: <20200929091727.8692-1-wangjingyi11@huawei.com>
 <9d341a2d-19f8-400c-6674-ef991ab78f62@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <10463cb9a0ae167a89300185c1de348c@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: wangjingyi11@huawei.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, will@kernel.org, catalin.marinas@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, wanghaibin.wang@huawei.com, yezengruan@huawei.com, shameerali.kolothum.thodi@huawei.com, fanhenglong@huawei.com, prime.zeng@hisilicon.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-11-13 07:54, Jingyi Wang wrote:
> Hi all，
> 
> Sorry for the delay. I have been testing the TWED feature performance
> lately. We select unixbench as the benchmark for some items of it is
> lock-intensive(fstime/fsbuffer/fsdisk). We run unixbench on a 4-VCPU
> VM, and bind every two VCPUs on one PCPU. Fixed TWED value is used and
> here is the result.

How representative is this?

TBH, I only know of two real world configurations: one where
the vCPUs are pinned to different physical CPUs (and in this
case your patch has absolutely no effect as long as there is
no concurrent tasks), and one where there is oversubscription,
and the scheduler moves things around as it sees fit, depending
on the load.

Having two vCPUs pinned per CPU feels like a test that has been
picked to give the result you wanted. I'd like to see the full
picture, including the case that matters for current use cases.
I'm specially interested in the cases where the system is
oversubscribed, because TWED is definitely going to screw with
the scheduler latency.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
