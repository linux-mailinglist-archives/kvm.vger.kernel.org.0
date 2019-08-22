Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C64999333
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 14:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388410AbfHVMWD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 08:22:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34212 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728952AbfHVMWC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 08:22:02 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 87F277E421;
        Thu, 22 Aug 2019 12:22:02 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 821B460BF3;
        Thu, 22 Aug 2019 12:21:59 +0000 (UTC)
Date:   Thu, 22 Aug 2019 14:21:57 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
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
Subject: Re: [PATCH v5 10/20] RISC-V: KVM: Handle MMIO exits for VCPU
Message-ID: <20190822122157.qy3e4rhxthfustn2@kamzik.brq.redhat.com>
References: <20190822084131.114764-1-anup.patel@wdc.com>
 <20190822084131.114764-11-anup.patel@wdc.com>
 <13cf8e10-3f54-a50a-0796-ecb2da4577d2@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13cf8e10-3f54-a50a-0796-ecb2da4577d2@amazon.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 22 Aug 2019 12:22:02 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 22, 2019 at 02:10:48PM +0200, Alexander Graf wrote:
> On 22.08.19 10:44, Anup Patel wrote:
...
> > +static int emulate_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
> > +			unsigned long fault_addr)
...
> > +	/* Exit to userspace for MMIO emulation */
> > +	vcpu->stat.mmio_exit_user++;
> > +	run->exit_reason = KVM_EXIT_MMIO;
> > +	run->mmio.is_write = false;
> > +	run->mmio.phys_addr = fault_addr;
> > +	run->mmio.len = len;
> > +
> > +	/* Move to next instruction */
> > +	vcpu->arch.guest_context.sepc += INSN_LEN(insn);
> 
> Doesn't that make more sense on the reentry path? What if you want to inject
> an MCE on access to unmapped addresses from user space?
>

I agree. See commit 0d640732dbeb for arm's justification for moving
the instruction skip. But also see

https://patchwork.kernel.org/patch/11109063/

for a needed fix to avoid skipping the instructions multiple times.
It looks like riscv's KVM_RUN ioctl would be vulnerable to that as
well.

Thanks,
drew
