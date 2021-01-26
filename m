Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAF6304009
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 15:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405703AbhAZOTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 09:19:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405820AbhAZOTF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 09:19:05 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBD0822D58;
        Tue, 26 Jan 2021 14:18:23 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l4PAj-00A97b-WE; Tue, 26 Jan 2021 14:18:22 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 26 Jan 2021 14:18:21 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Yanan Wang <wangyanan55@huawei.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC PATCH v1 0/5] Enable CPU TTRem feature for stage-2
In-Reply-To: <20210126134202.381996-1-wangyanan55@huawei.com>
References: <20210126134202.381996-1-wangyanan55@huawei.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <cc15dabd0d7e0cb25d58101803e2c9a4@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: wangyanan55@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yanan,

On 2021-01-26 13:41, Yanan Wang wrote:
> Hi all,
> This series enable CPU TTRem feature for stage-2 page table and a RFC 
> is sent
> for some comments, thanks.
> 
> The ARMv8.4 TTRem feature offers 3 levels of support when changing 
> block
> size without changing any other parameters that are listed as requiring 
> use
> of break-before-make. And I found that maybe we can use this feature to 
> make
> some improvement for stage-2 page table and the following explains what
> TTRem exactly does for the improvement.
> 
> If migration of a VM with hugepages is canceled midway, KVM will adjust 
> the
> stage-2 table mappings back to block mappings. We currently use BBM to 
> replace
> the table entry with a block entry. Take adjustment of 1G block mapping 
> as an
> example, with BBM procedures, we have to invalidate the old table entry 
> first,
> flush TLB and unmap the old table mappings, right before installing the 
> new
> block entry.

In all honesty, I think the amount of work that is getting added to
support this "migration cancelled mid-way" use case is getting out
of control.

This is adding a complexity and corner cases for a use case that
really shouldn't happen that often. And it is adding it at the worse
possible place, where we really should keep things as straightforward
as possible.

I would expect userspace to have a good enough knowledge of whether
the migration is likely to succeed, and not to attempt it if it is
likely to fail. And yes, it will fail sometimes. But it should be
so rare that adding this various stages of BBM support shouldn't be
that useful.

Or is there something else that I am missing?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
