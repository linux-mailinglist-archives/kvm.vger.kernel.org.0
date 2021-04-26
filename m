Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA3B36B1C2
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 12:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbhDZKlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 06:41:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232933AbhDZKlx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 06:41:53 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B05AF61185;
        Mon, 26 Apr 2021 10:41:11 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1layft-009SvS-Fz; Mon, 26 Apr 2021 11:41:09 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 26 Apr 2021 11:41:09 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, James Morse <james.morse@arm.com>,
        Sumit Gupta <sumitg@nvidia.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] KVM: arm64: Skip CMOs when updating a PTE pointing to
 non-memory
In-Reply-To: <20210426103605.616908-1-maz@kernel.org>
References: <20210426103605.616908-1-maz@kernel.org>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <fa71b02d1a7c8be97968be1461749649@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, jean-philippe@linaro.org, suzuki.poulose@arm.com, kernel-team@android.com, james.morse@arm.com, sumitg@nvidia.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-04-26 11:36, Marc Zyngier wrote:
> Sumit Gupta and Krishna Reddy both reported that for MMIO regions
> mapped into userspace using VFIO, a PTE update can trigger a MMU
> notifier reaching kvm_set_spte_hva().
> 
> There is an assumption baked in kvm_set_spte_hva() that it only
> deals with memory pages, and not MMIO. For this purpose, it
> performs a cache cleaning of the potentially newly mapped page.
> However, for a MMIO range, this explodes as there is no linear
> mapping for this range (and doing cache maintenance on it would
> make little sense anyway).
> 
> Check for the validity of the page before performing the CMO
> addresses the problem.
> 
> Reported-by: Krishna Reddy <vdumpa@nvidia.com>
> Reported-by: Sumit Gupta <sumitg@nvidia.com>,
> Tested-by: Sumit Gupta <sumitg@nvidia.com>,
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: 
> https://lore.kernel.org/r/5a8825bc-286e-b316-515f-3bd3c9c70a80@nvidia.com

FWIW, I've locally added:

Fixes: 694556d54f35 ("KVM: arm/arm64: Clean dcache to PoC when changing 
PTE due to CoW")
Cc: stable@vger.kernel.org

         M.
-- 
Jazz is not dead. It just smells funny...
