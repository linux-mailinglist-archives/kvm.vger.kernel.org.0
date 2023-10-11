Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E70F7C4BA9
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 09:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344742AbjJKH0F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 03:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344424AbjJKH0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 03:26:04 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A45C8F;
        Wed, 11 Oct 2023 00:25:59 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CD2C433C7;
        Wed, 11 Oct 2023 07:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1697009159;
        bh=I+hjt1PIAmeTlSR8yMwMC5kINnpTg7kd2uxBgq828hE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vvUjAcwiuU1Y7Tj7a0D35EZe0SxqN+mW7fhJhdPKPZHsA7bkpi+kq6XyZgKWRJkuv
         wFoBLopdpeV8uJrtE3LTjN5hQ4GGXvHKw8zhDirGSmsdZTrIVkOmuPDRDKHXj1+LnL
         4btIOyNUCM+4qGWuJA+oAlJPtLbETjMO8IeYC9sw=
Date:   Wed, 11 Oct 2023 09:25:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Conor Dooley <conor@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] RISC-V: KVM: Forward SBI DBCN extension to user-space
Message-ID: <2023101105-oink-aerospace-989e@gregkh>
References: <20231010170503.657189-1-apatel@ventanamicro.com>
 <20231010170503.657189-4-apatel@ventanamicro.com>
 <2023101048-attach-drift-d77b@gregkh>
 <CAK9=C2UEcQpHg8WZM3XxLa5yCEZ6wtWJj=8g5_m_0_RkiNMkTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK9=C2UEcQpHg8WZM3XxLa5yCEZ6wtWJj=8g5_m_0_RkiNMkTA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023 at 12:02:30PM +0530, Anup Patel wrote:
> On Tue, Oct 10, 2023 at 10:45 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Oct 10, 2023 at 10:35:00PM +0530, Anup Patel wrote:
> > > The SBI DBCN extension needs to be emulated in user-space
> >
> > Why?
> 
> The SBI debug console is similar to a console port available to
> KVM Guest so the KVM user space tool (i.e. QEMU-KVM or
> KVMTOOL) can redirect the input/output of SBI debug console
> wherever it wants (e.g.  telnet, file, stdio, etc).
> 
> We forward SBI DBCN calls to KVM user space so that the
> in-kernel KVM does not need to be aware of the guest
> console devices.

Hint, my "Why" was attempting to get you to write a better changelog
description, which would include the above information.  Please read the
kernel documentation for hints on how to do this so that we know what
why changes are being made.

> > > so let
> > > us forward console_puts() call to user-space.
> >
> > What could go wrong!
> >
> > Why does userspace have to get involved in a console message?  Why is
> > this needed at all?  The kernel can not handle userspace consoles as
> > obviously they have to be re-entrant and irq safe.
> 
> As mentioned above, these are KVM guest console messages which
> the VMM (i.e. KVM user-space) can choose to manage on its own.

If it chooses not to, what happens?

> This is more about providing flexibility to KVM user-space which
> allows it to manage guest console devices.

Why not use the normal virtio console device interface instead of making
a riscv-custom one?

Where is the userspace side of this interface at?  Where are the patches
to handle this new api you added?

> 
> >
> > >
> > > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > > ---
> > >  arch/riscv/include/asm/kvm_vcpu_sbi.h |  1 +
> > >  arch/riscv/include/uapi/asm/kvm.h     |  1 +
> > >  arch/riscv/kvm/vcpu_sbi.c             |  4 ++++
> > >  arch/riscv/kvm/vcpu_sbi_replace.c     | 31 +++++++++++++++++++++++++++
> > >  4 files changed, 37 insertions(+)
> > >
> > > diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > > index 8d6d4dce8a5e..a85f95eb6e85 100644
> > > --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > > +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > > @@ -69,6 +69,7 @@ extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi;
> > >  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence;
> > >  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst;
> > >  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
> > > +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_dbcn;
> > >  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
> > >  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
> > >
> > > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> > > index 917d8cc2489e..60d3b21dead7 100644
> > > --- a/arch/riscv/include/uapi/asm/kvm.h
> > > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > > @@ -156,6 +156,7 @@ enum KVM_RISCV_SBI_EXT_ID {
> > >       KVM_RISCV_SBI_EXT_PMU,
> > >       KVM_RISCV_SBI_EXT_EXPERIMENTAL,
> > >       KVM_RISCV_SBI_EXT_VENDOR,
> > > +     KVM_RISCV_SBI_EXT_DBCN,
> > >       KVM_RISCV_SBI_EXT_MAX,
> >
> > You just broke a user/kernel ABI here, why?
> 
> The KVM_RISCV_SBI_EXT_MAX only represents the number
> of entries in "enum KVM_RISCV_SBI_EXT_ID" so we are not
> breaking "enum KVM_RISCV_SBI_EXT_ID" rather appending
> new ID to existing enum.

So you are sure that userspace never actually tests or sends that _MAX
value anywhere?  If not, why is it even needed?

thanks,

greg k-h
