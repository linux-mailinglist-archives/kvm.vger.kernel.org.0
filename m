Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3716EA648E
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 10:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbfICI63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 04:58:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33712 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725888AbfICI62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 04:58:28 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 741718665D;
        Tue,  3 Sep 2019 08:58:28 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A9FF160C18;
        Tue,  3 Sep 2019 08:58:25 +0000 (UTC)
Date:   Tue, 3 Sep 2019 10:58:23 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Anup Patel <Anup.Patel@wdc.com>
Cc:     Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 10/21] RISC-V: KVM: Handle MMIO exits for VCPU
Message-ID: <20190903085823.s4amn27pewc54hl2@kamzik.brq.redhat.com>
References: <20190829135427.47808-1-anup.patel@wdc.com>
 <20190829135427.47808-11-anup.patel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829135427.47808-11-anup.patel@wdc.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 03 Sep 2019 08:58:28 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 01:56:18PM +0000, Anup Patel wrote:
>  int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
> -	/* TODO: */
> +	u8 data8;
> +	u16 data16;
> +	u32 data32;
> +	u64 data64;
> +	ulong insn;
> +	int len, shift;
> +
> +	insn = vcpu->arch.mmio_decode.insn;
> +
> +	if (run->mmio.is_write)
> +		goto done;
> +
> +	len = vcpu->arch.mmio_decode.len;
> +	shift = vcpu->arch.mmio_decode.shift;
> +
> +	switch (len) {
> +	case 1:
> +		data8 = *((u8 *)run->mmio.data);
> +		SET_RD(insn, &vcpu->arch.guest_context,
> +			(ulong)data8 << shift >> shift);
> +		break;
> +	case 2:
> +		data16 = *((u16 *)run->mmio.data);
> +		SET_RD(insn, &vcpu->arch.guest_context,
> +			(ulong)data16 << shift >> shift);
> +		break;
> +	case 4:
> +		data32 = *((u32 *)run->mmio.data);
> +		SET_RD(insn, &vcpu->arch.guest_context,
> +			(ulong)data32 << shift >> shift);
> +		break;
> +	case 8:
> +		data64 = *((u64 *)run->mmio.data);
> +		SET_RD(insn, &vcpu->arch.guest_context,
> +			(ulong)data64 << shift >> shift);
> +		break;
> +	default:
> +		return -ENOTSUPP;
> +	};
> +
> +done:
> +	/* Move to next instruction */
> +	vcpu->arch.guest_context.sepc += INSN_LEN(insn);
> +

As I pointed out in the last review, just moving this instruction skip
here is not enough. Doing so introduces the same problem that 2113c5f62b74
("KVM: arm/arm64: Only skip MMIO insn once") fixes for arm.

Thanks,
drew
