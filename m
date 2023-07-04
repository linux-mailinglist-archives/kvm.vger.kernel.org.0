Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2463E74787B
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 20:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbjGDSyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 14:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjGDSyB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 14:54:01 -0400
Received: from out-61.mta1.migadu.com (out-61.mta1.migadu.com [IPv6:2001:41d0:203:375::3d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BECEE
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 11:54:00 -0700 (PDT)
Date:   Tue, 4 Jul 2023 11:54:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688496837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2Y4FgZXJ7x48QVp6BHNp316Cs4N1KcNcIDsf4Li1btE=;
        b=F1u6d6f2WKhnSqYxFVGE4mrYo0dson7wThHf0ZPAwwzD16L2MumyX6ZZazSkFglX5Ej8Vp
        Cn9WFZWkmrUIpunzBDWlECe/I7W9TCNkdq18uObpgucVFdBVwCz6AcW/orr7tIsNQJmGlG
        hKSf0NJstc/Odcx6iAETtcJ7VxLMGGw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Kristina Martsenko <kristina.martsenko@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, isaku.yamahata@intel.com,
        seanjc@google.com, pbonzini@redhat.com, stable@vger.kernek.org
Subject: Re: [PATCH] KVM: arm64: Disable preemption in
 kvm_arch_hardware_enable()
Message-ID: <ZKRqylHePs3iyIN7@thinky-boi>
References: <20230703163548.1498943-1-maz@kernel.org>
 <4c92ceb6-34a2-3128-9b26-dd58e4d7612a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c92ceb6-34a2-3128-9b26-dd58e4d7612a@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 04, 2023 at 07:32:09PM +0100, Kristina Martsenko wrote:
> On 03/07/2023 17:35, Marc Zyngier wrote:
> > Since 0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect
> > kvm_usage_count with kvm_lock"), hotplugging back a CPU whilst
> > a guest is running results in a number of ugly splats as most
> > of this code expects to run with preemption disabled, which isn't
> > the case anymore.
> > 
> > While the context is preemptable, it isn't migratable, which should
> > be enough. But we have plenty of preemptible() checks all over
> > the place, and our per-CPU accessors also disable preemption.
> > 
> > Since this affects released versions, let's do the easy fix first,
> > disabling preemption in kvm_arch_hardware_enable(). We can always
> > revisit this with a more invasive fix in the future.
> > 
> > Fixes: 0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock")
> > Reported-by: Kristina Martsenko <kristina.martsenko@arm.com>
> > Tested-by: Kristina Martsenko <kristina.martsenko@arm.com>
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Link: https://lore.kernel.org/r/aeab7562-2d39-e78e-93b1-4711f8cc3fa5@arm.com
> > Cc: stable@vger.kernek.org # v6.3, v6.4
> 
> Typo here, didn't make it to the stable list (kernek.org -> kernel.org)

Thanks for catching this Kristina, I'll fix it up when I apply the
patch. So long as the patch appears in Linus' tree with the correct Cc
it'll find its way to the stable trees.

--
Thanks,
Oliver
