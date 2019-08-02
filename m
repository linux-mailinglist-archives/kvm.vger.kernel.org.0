Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 553D77F60B
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 13:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732155AbfHBLc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 07:32:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37158 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732085AbfHBLc2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 07:32:28 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8343E5AFD9;
        Fri,  2 Aug 2019 11:32:27 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 98BD25C220;
        Fri,  2 Aug 2019 11:32:25 +0000 (UTC)
Date:   Fri, 2 Aug 2019 13:32:22 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>
Subject: Re: kvm-unit-tests: psci_cpu_on_test FAILed
Message-ID: <20190802113222.l64u2sauiuxvh6be@kamzik.brq.redhat.com>
References: <3ddf8766-6f02-b655-1b80-d8a7fd016509@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ddf8766-6f02-b655-1b80-d8a7fd016509@huawei.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 02 Aug 2019 11:32:27 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 02, 2019 at 06:56:51PM +0800, Zenghui Yu wrote:
> Hi folks,
> 
> Running kvm-unit-tests with Linux 5.3.0-rc2 on Kunpeng 920, we will get
> the following fail info:
> 
> 	[...]
> 	FAIL psci (4 tests, 1 unexpected failures)
> 	[...]
> and
> 	[...]
> 	INFO: unexpected cpu_on return value: caller=CPU9, ret=-2
> 	FAIL: cpu-on
> 	SUMMARY: 4 tests, 1 unexpected failures
> 
> 
> I think this is an issue had been fixed once by commit 6c7a5dce22b3
> ("KVM: arm/arm64: fix races in kvm_psci_vcpu_on"), which makes use of
> kvm->lock mutex to fix the race between two PSCI_CPU_ON calls - one
> does reset on the MPIDR register whilst another reads it.
> 
> But commit 358b28f09f0 ("arm/arm64: KVM: Allow a VCPU to fully reset
> itself") later moves the reset work into check_vcpu_requests(), by
> making a KVM_REQ_VCPU_RESET request in PSCI code. Thus the reset work
> has not been protected by kvm->lock mutex anymore, and the race shows up
> again...
> 
> Do we need a fix for this issue? At least achieve a mutex execution
> between the reset of MPIDR and kvm_mpidr_to_vcpu()?
> 
>

I noticed this too, but I put it pretty low on my TODO because it's a
safe failure (no host crash, just an unexpected PSCI_RET_INVALID_PARAMS
gets returned because the valid MPIDR doesn't look valid for a moment.)
Also, the test is quite pathological, especially when the host has many
CPUs, so I wouldn't expect this to show up on a sane guest. I agree
it would be nice to get it fixed eventually though.

Thanks,
drew
