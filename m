Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967A5747850
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 20:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbjGDScV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 14:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjGDScU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 14:32:20 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0CF810C1
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 11:32:18 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD40315BF;
        Tue,  4 Jul 2023 11:33:00 -0700 (PDT)
Received: from [10.1.37.129] (e126864.cambridge.arm.com [10.1.37.129])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA2543F663;
        Tue,  4 Jul 2023 11:32:15 -0700 (PDT)
Message-ID: <4c92ceb6-34a2-3128-9b26-dd58e4d7612a@arm.com>
Date:   Tue, 4 Jul 2023 19:32:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] KVM: arm64: Disable preemption in
 kvm_arch_hardware_enable()
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>, isaku.yamahata@intel.com,
        seanjc@google.com, pbonzini@redhat.com, stable@vger.kernek.org
References: <20230703163548.1498943-1-maz@kernel.org>
From:   Kristina Martsenko <kristina.martsenko@arm.com>
In-Reply-To: <20230703163548.1498943-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/2023 17:35, Marc Zyngier wrote:
> Since 0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect
> kvm_usage_count with kvm_lock"), hotplugging back a CPU whilst
> a guest is running results in a number of ugly splats as most
> of this code expects to run with preemption disabled, which isn't
> the case anymore.
> 
> While the context is preemptable, it isn't migratable, which should
> be enough. But we have plenty of preemptible() checks all over
> the place, and our per-CPU accessors also disable preemption.
> 
> Since this affects released versions, let's do the easy fix first,
> disabling preemption in kvm_arch_hardware_enable(). We can always
> revisit this with a more invasive fix in the future.
> 
> Fixes: 0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock")
> Reported-by: Kristina Martsenko <kristina.martsenko@arm.com>
> Tested-by: Kristina Martsenko <kristina.martsenko@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/aeab7562-2d39-e78e-93b1-4711f8cc3fa5@arm.com
> Cc: stable@vger.kernek.org # v6.3, v6.4

Typo here, didn't make it to the stable list (kernek.org -> kernel.org)

Kristina

