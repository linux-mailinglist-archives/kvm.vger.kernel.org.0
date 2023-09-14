Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75BB17A063C
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 15:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239837AbjINNkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 09:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239287AbjINNjo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 09:39:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285054497
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 06:37:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97FBC433C8;
        Thu, 14 Sep 2023 13:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694698632;
        bh=Fl6RNpJimEuHpL5sPJLw45C8oocbmvKU729su9Dk9wo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pt+eN9LPhV/y8mBV/XzMPHIkcxgQ/uO4qEu4xUKH+bsnFneOCl1sOpF8jmddmRMvy
         PdiplUPKQdJaFy9ecE1NRUTl8zODWSLmxzNiXCPVkKZcn9CMvJTW5wQFpSe9lZozJW
         6lJh6edujGtDNPh4VoGYSJA1TXVYvK7Q0aBRKQwlgog1vwyeKxogjWmjKhmk1yxlsY
         PgHh3sHt6BpTSYNx72z6L/z9/MmjAUVOko7lti/QABrHl1A6I+ir9noq8hDxzoXkvZ
         JAzOTqfG6waKPiMv2TPcugjQc7H3YBo89GikUnf4FWYzrOA/Nu7QaT9F5DAs45SPvY
         LacycEtpqU7fw==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qgmWr-00CvtI-LK;
        Thu, 14 Sep 2023 14:37:09 +0100
MIME-Version: 1.0
Date:   Thu, 14 Sep 2023 14:37:09 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        D Scott Phillips <scott@os.amperecomputing.com>
Subject: Re: [PATCH v10 29/59] KVM: arm64: nv: Unmap/flush shadow stage 2 page
 tables
In-Reply-To: <8d0f77a8-00db-93f7-aeae-bf96190b6f5b@os.amperecomputing.com>
References: <20230515173103.1017669-1-maz@kernel.org>
 <20230515173103.1017669-30-maz@kernel.org>
 <8d0f77a8-00db-93f7-aeae-bf96190b6f5b@os.amperecomputing.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <3454100b4bb927a24b380f442f02d178@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: gankulkarni@os.amperecomputing.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, christoffer.dall@arm.com, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, scott@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ganapatrao,

On 2023-09-14 14:10, Ganapatrao Kulkarni wrote:
> Hi Marc,
> 
> On 15-05-2023 11:00 pm, Marc Zyngier wrote:
>> From: Christoffer Dall <christoffer.dall@linaro.org>
>> 
>> Unmap/flush shadow stage 2 page tables for the nested VMs as well as 
>> the
>> stage 2 page table for the guest hypervisor.
>> 
>> Note: A bunch of the code in mmu.c relating to MMU notifiers is
>> currently dealt with in an extremely abrupt way, for example by 
>> clearing
>> out an entire shadow stage-2 table. This will be handled in a more
>> efficient way using the reverse mapping feature in a later version of
>> the patch series.
> 
> We are seeing spin-lock contention due to this patch when the
> Guest-Hypervisor(L1) is booted with higher number of cores and
> auto-numa is enabled on L0.
> kvm_nested_s2_unmap is called as part of notifier call-back when numa
> page migration is happening and this function which holds lock becomes
> source of contention when there are more vCPUs are processing the
> auto-numa page fault/migration.

This is fully expected. Honestly, expecting any sort of performance at
this stage is extremely premature (and I have zero sympathy for hacks
like auto-numa...).

[...]

>>   +	kvm_nested_s2_unmap(kvm);
> 
> This kvm_nested_s2_unmap/kvm_unmap_stage2_range is called for every
> active L2 and page table walk-through iterates for long iterations
> since kvm_phys_size(mmu) is pretty big size(atleast 48bits).
> What would be the best fix if we want to avoid this unnessary long
> iteration of page table lookup?

The fix would be to have a reverse mapping for any canonical IPA to
any shadow IPA, which would allow us to not fully tear down the shadow
PTs but only the bit we need to remove. This is clearly stated in the
commit message you quoted.

However, this plan is pretty far down the list, and I have no plan to
work on performance optimisations until we have basic support merged
upstream.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
