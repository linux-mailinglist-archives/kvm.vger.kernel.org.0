Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2141A753FE9
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 18:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235470AbjGNQkR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 12:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235673AbjGNQkQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 12:40:16 -0400
Received: from out-52.mta1.migadu.com (out-52.mta1.migadu.com [95.215.58.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BB830EA
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 09:40:15 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689352813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mM3Yg48NFa+D2LoOnZ1L1kCdrFfUaYCzsidjkRTZz0Y=;
        b=M1lhNaWkAm7c9Fx70S/ExpSO3tvt26cOFul7lrqXLRFuuvO1R/SBh7K7VjqDSf8ovNJDp6
        EyMG6WRn8BbPuR0cL0XVt3/pL/rBHcmyWFQiQJg/KZ8Z2UN+AcMGUIOFD0WibGNPLINsKi
        q7UnTuPkUzEDR1tYPOqP2Zsnwb5yL8M=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     linux-arm-kernel@lists.infradead.org,
        Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Xiang Chen <chenxiang66@hisilicon.com>, stable@vger.kernel.org,
        James Morse <james.morse@arm.com>
Subject: Re: [PATCH] KVM: arm64: vgic-v4: Make the doorbell request robust w.r.t preemption
Date:   Fri, 14 Jul 2023 16:40:01 +0000
Message-ID: <168935279432.510537.2896936960411016313.b4-ty@linux.dev>
In-Reply-To: <20230713070657.3873244-1-maz@kernel.org>
References: <20230713070657.3873244-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Jul 2023 08:06:57 +0100, Marc Zyngier wrote:
> Xiang reports that VMs occasionally fail to boot on GICv4.1 systems when
> running a preemptible kernel, as it is possible that a vCPU is blocked
> without requesting a doorbell interrupt.
> 
> The issue is that any preemption that occurs between vgic_v4_put() and
> schedule() on the block path will mark the vPE as nonresident and *not*
> request a doorbell irq. This occurs because when the vcpu thread is
> resumed on its way to block, vcpu_load() will make the vPE resident
> again. Once the vcpu actually blocks, we don't request a doorbell
> anymore, and the vcpu won't be woken up on interrupt delivery.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: vgic-v4: Make the doorbell request robust w.r.t preemption
      https://git.kernel.org/kvmarm/kvmarm/c/b321c31c9b7b

--
Best,
Oliver
