Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 069007F59D
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 13:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392165AbfHBLAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 07:00:05 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59366 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392118AbfHBLAF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 07:00:05 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0CA50E7A5A43691467DE;
        Fri,  2 Aug 2019 19:00:03 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Fri, 2 Aug 2019
 18:59:56 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
Subject: kvm-unit-tests: psci_cpu_on_test FAILed
To:     Marc Zyngier <maz@kernel.org>, <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        <julien.thierry.kdev@gmail.com>, <suzuki.poulose@arm.com>
CC:     <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>
Message-ID: <3ddf8766-6f02-b655-1b80-d8a7fd016509@huawei.com>
Date:   Fri, 2 Aug 2019 18:56:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi folks,

Running kvm-unit-tests with Linux 5.3.0-rc2 on Kunpeng 920, we will get
the following fail info:

	[...]
	FAIL psci (4 tests, 1 unexpected failures)
	[...]
and
	[...]
	INFO: unexpected cpu_on return value: caller=CPU9, ret=-2
	FAIL: cpu-on
	SUMMARY: 4 tests, 1 unexpected failures


I think this is an issue had been fixed once by commit 6c7a5dce22b3
("KVM: arm/arm64: fix races in kvm_psci_vcpu_on"), which makes use of
kvm->lock mutex to fix the race between two PSCI_CPU_ON calls - one
does reset on the MPIDR register whilst another reads it.

But commit 358b28f09f0 ("arm/arm64: KVM: Allow a VCPU to fully reset
itself") later moves the reset work into check_vcpu_requests(), by
making a KVM_REQ_VCPU_RESET request in PSCI code. Thus the reset work
has not been protected by kvm->lock mutex anymore, and the race shows up
again...

Do we need a fix for this issue? At least achieve a mutex execution
between the reset of MPIDR and kvm_mpidr_to_vcpu()?


Thanks,
zenghui

