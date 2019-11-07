Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E40CF352A
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 17:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbfKGQ4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 11:56:38 -0500
Received: from foss.arm.com ([217.140.110.172]:59168 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbfKGQ4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 11:56:38 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B97CB31B;
        Thu,  7 Nov 2019 08:56:37 -0800 (PST)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C3873F719;
        Thu,  7 Nov 2019 08:56:37 -0800 (PST)
Date:   Thu, 7 Nov 2019 17:56:36 +0100
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] KVM: arm64: Reduce occurence of GICv4 doorbells on
 non-oversubscribed systems
Message-ID: <20191107165636.GB17608@e113682-lin.lund.arm.com>
References: <20191107160412.30301-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107160412.30301-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 07, 2019 at 04:04:10PM +0000, Marc Zyngier wrote:
> As I was cleaning up some of the GICv4 code to make way for GICv4.1 it
> occured to me that we could drastically reduce the impact of the GICv4
> doorbells on systems that are not oversubscribed (each vcpu "owns" a
> physical CPU).
> 
> The technique borrows its logic from the way we disable WFE trapping
> when a vcpu is the only process on the CPU run-queue. If this vcpu is
> the target of VLPIs, it is then beneficial not to trap blocking WFIs
> and to leave the vcpu waiting for interrupts in guest state.
> 
> All we need to do here is to track whether VLPIs are associated to a
> vcpu (which is easily done by using a counter that we update on MAPI,
> DISCARD and MOVI).
> 
> It has been *very lightly* tested on a D05, and behaved pretty well in
> my limited test cases (I get almost no doorbell at all in the non
> oversubscribed case, and the usual hailstorm as soon as there is
> oversubscription). I'd welcome some testing on more current HW.
> 
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
