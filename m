Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575537D5AB1
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 20:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344164AbjJXShp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 14:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234912AbjJXShm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 14:37:42 -0400
Received: from out-208.mta0.migadu.com (out-208.mta0.migadu.com [91.218.175.208])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142951720
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 11:37:23 -0700 (PDT)
Date:   Tue, 24 Oct 2023 18:37:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698172642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MhJ7hpYNLv+MdX49dQXGYnhsXLwtvTKjEUlM/EEP2AE=;
        b=HmTAi3vX6+c6qUUSeCE5bUS/PW6Yb7yhrXKc58eaEv/9GVTUSXOuF6uNnysiKo0GoNPB4+
        wllIwNj9PbBKFHyTluy6Qg5zJaD4norqGkRmo9F0H9VtpK+aClTT4P2Q9V6v2Z+mlImQVr
        JneDsDassGEe43ScK3hMSWUrpVNfKZE=
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
Subject: Re: [PATCH v8 07/13] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
Message-ID: <ZTgO3SHzvd_mQTI9@linux.dev>
References: <20231020214053.2144305-1-rananta@google.com>
 <20231020214053.2144305-8-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231020214053.2144305-8-rananta@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023 at 09:40:47PM +0000, Raghavendra Rao Ananta wrote:

[...]

> +	/*
> +	 * Make PMCR immutable once the VM has started running, but
> +	 * do not return an error to meet the existing expectations.
> +	 */
> +	if (kvm_vm_has_ran_once(vcpu->kvm)) {
> +		mutex_unlock(&kvm->arch.config_lock);
> +		return 0;
> +	}

Marc pointed out offline that PMCR_EL0 needs to be mutable at runtime as
well. I'll admit, the architecture isn't very helpful as it is both used
for identification _and_ configuration.

What I had in mind a few revisions ago when I gave the suggestion was to
ignore writes to _just_ the PMCR_EL0.N field after the VM has started.

-- 
Thanks,
Oliver
