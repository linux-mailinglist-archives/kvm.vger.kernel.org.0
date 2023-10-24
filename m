Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10F37D4BE0
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 11:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbjJXJWo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 05:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjJXJWm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 05:22:42 -0400
Received: from out-209.mta0.migadu.com (out-209.mta0.migadu.com [IPv6:2001:41d0:1004:224b::d1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9993C2
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 02:22:40 -0700 (PDT)
Date:   Tue, 24 Oct 2023 09:22:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698139358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iQHrjam2voLfNM7Ldr1znGEGuCMfWMBUcs8WR9mD83Y=;
        b=tAF4FrKSXjarPxwHmKlimoCFuzzYK58GpnmGJMTnupIUrxXxHh/UH1SmwLPaWd25Lp990u
        E0Zwt0c1wKr87A3/It1Nu8FEAJOj7JtPvxsdA3BqUqYSwiIFteHPDzhbPPwQDcIHbJJyL4
        nK43fI4eFYu6mI8+wkkgs9vtf3gddic=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v8 04/13] KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based
 on the associated PMU
Message-ID: <ZTeM2RnMCRFoGsZd@linux.dev>
References: <20231020214053.2144305-1-rananta@google.com>
 <20231020214053.2144305-5-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231020214053.2144305-5-rananta@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023 at 09:40:44PM +0000, Raghavendra Rao Ananta wrote:

[...]

> +int kvm_arm_pmu_get_max_counters(struct kvm *kvm)
> +{
> +	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
> +
> +	lockdep_assert_held(&kvm->arch.config_lock);

This lockdep assertion is misleading. Readers of kvm_arch::arm_pmu *are
not* serialized by the config_lock.

-- 
Thanks,
Oliver
