Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA33E1C3B60
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 15:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgEDNhB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 09:37:01 -0400
Received: from foss.arm.com ([217.140.110.172]:44990 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbgEDNhB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 09:37:01 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9EC611FB;
        Mon,  4 May 2020 06:37:00 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CDAFC3F71F;
        Mon,  4 May 2020 06:36:59 -0700 (PDT)
Subject: Re: [PATCH v3 kvmtool 24/32] pci: Limit configuration transaction
 size to 32 bits
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>,
        kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
 <20200326152438.6218-25-alexandru.elisei@arm.com>
 <c1f0db1a-5df1-492b-8d91-a972fe2a4d42@arm.com>
 <30df4164-f7db-c00d-e67c-5d2cdb696354@arm.com>
Message-ID: <da28f15f-56c3-797d-a5fd-64cb7f3d7295@arm.com>
Date:   Mon, 4 May 2020 14:37:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <30df4164-f7db-c00d-e67c-5d2cdb696354@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 5/4/20 2:00 PM, Alexandru Elisei wrote:
> Hi,
>
> On 4/2/20 9:34 AM, André Przywara wrote:
>> On 26/03/2020 15:24, Alexandru Elisei wrote:
>>> From PCI Local Bus Specification Revision 3.0. section 3.8 "64-Bit Bus
>>> Extension":
>>>
>>> "The bandwidth requirements for I/O and configuration transactions cannot
>>> justify the added complexity, and, therefore, only memory transactions
>>> support 64-bit data transfers".
>>>
>>> Further down, the spec also describes the possible responses of a target
>>> which has been requested to do a 64-bit transaction. Limit the transaction
>>> to the lower 32 bits, to match the second accepted behaviour.
>> That looks like a reasonable behaviour.
>> AFAICS there is one code path from powerpc/spapr_pci.c which isn't
>> covered by those limitations (rtas_ibm_write_pci_config() ->
>> pci__config_wr() -> cfg_ops.write() -> vfio_pci_cfg_write()).
>> Same for read.
> The code compares the access size to 1, 2 and 4, so I think powerpc doesn't expect
> 64 bit accesses either. The change looks straightforward, I'll do it for consistency.
>
Read the code more carefully and powerpc already limits the access size to 4 bytes:

static void rtas_ibm_read_pci_config(struct kvm_cpu *vcpu,
                     uint32_t token, uint32_t nargs,
                     target_ulong args,
                     uint32_t nret, target_ulong rets)
{
    [..]
    if (buid != phb.buid || !dev || (size > 4)) {
        phb_dprintf("- cfgRd buid 0x%lx cfg addr 0x%x size %d not found\n",
                buid, addr.w, size);

        rtas_st(vcpu->kvm, rets, 0, -1);
        return;
    }
    pci__config_rd(vcpu->kvm, addr, &val, size);
    [..]
}

It's the same for all the functions where pci__config_{rd,wr} are called directly.
So no changes are needed.

Thanks,
Alex
