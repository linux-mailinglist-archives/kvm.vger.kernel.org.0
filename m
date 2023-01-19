Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67717673BA3
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 15:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjASOYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 09:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbjASOYo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 09:24:44 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E6C866FB6
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 06:24:41 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CEEEE176A;
        Thu, 19 Jan 2023 06:25:22 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 257523F445;
        Thu, 19 Jan 2023 06:24:40 -0800 (PST)
Date:   Thu, 19 Jan 2023 14:24:37 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Rajnesh Kanwal <rkanwal@rivosinc.com>, apatel@ventanamicro.com,
        atishp@rivosinc.com, kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, maz@kernel.org
Subject: Re: [PATCH kvmtool 1/1] riscv: pci: Add --force-pci option for
 riscv VMs.
Message-ID: <20230119142437.7d5aca89@donnerap.cambridge.arm.com>
In-Reply-To: <Y8lIFLdsAAOqMo0Y@arm.com>
References: <20230118172007.408667-1-rkanwal@rivosinc.com>
        <Y8lIFLdsAAOqMo0Y@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Jan 2023 13:39:32 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi Alex,

> CC'ing the kvmtool maintainers and other people that might be interested in this
> thread. Sorry for hijacking your patch!
> 
> On Wed, Jan 18, 2023 at 05:20:07PM +0000, Rajnesh Kanwal wrote:
> > Adding force-pci option to allow forcing virtio
> > devices to use pci as the default transport.  
> 
> arm is in the same situation, MMIO is the default virtio transport. I was bitten
> by that in the past. It also cought other people unaware, and I remember maz
> complaining about it on the list.
> 
> So I was thinking about adding a new command line parameter, --virtio-transport,
> with the possible values mmio-legacy, mmio, pci-legacy and pci. Then each
> architecture can define the default value for the transport. For arm, that would
> be pci.
> 
> What do you guys think?

That sounds good to me, definitely much better than proliferating the
force-pci parameter, which is a bit of a misnomer anyway.

I also heard people recently asking explicitly for MMIO transport,
since it's leaner and you can remove PCI support from the guest kernel
entirely. So giving the user explicit choice is probably the way to go.

Cheers,
Andre

> > Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
> > ---
> >  riscv/include/kvm/kvm-arch.h        | 6 ++++--
> >  riscv/include/kvm/kvm-config-arch.h | 7 ++++++-
> >  2 files changed, 10 insertions(+), 3 deletions(-)
> > 
> > diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
> > index 1e130f5..2cf41c5 100644
> > --- a/riscv/include/kvm/kvm-arch.h
> > +++ b/riscv/include/kvm/kvm-arch.h
> > @@ -46,8 +46,10 @@
> >  
> >  #define KVM_VM_TYPE		0
> >  
> > -#define VIRTIO_DEFAULT_TRANS(kvm) \
> > -	((kvm)->cfg.virtio_legacy ? VIRTIO_MMIO_LEGACY : VIRTIO_MMIO)
> > +#define VIRTIO_DEFAULT_TRANS(kvm)					\
> > +	((kvm)->cfg.arch.virtio_trans_pci ?				\
> > +	 ((kvm)->cfg.virtio_legacy ? VIRTIO_PCI_LEGACY : VIRTIO_PCI) :	\
> > +	 ((kvm)->cfg.virtio_legacy ? VIRTIO_MMIO_LEGACY : VIRTIO_MMIO))
> >  
> >  #define VIRTIO_RING_ENDIAN	VIRTIO_ENDIAN_LE
> >  
> > diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
> > index 188125c..901a5e0 100644
> > --- a/riscv/include/kvm/kvm-config-arch.h
> > +++ b/riscv/include/kvm/kvm-config-arch.h
> > @@ -6,6 +6,7 @@
> >  struct kvm_config_arch {
> >  	const char	*dump_dtb_filename;
> >  	bool		ext_disabled[KVM_RISCV_ISA_EXT_MAX];
> > +	bool		virtio_trans_pci;
> >  };
> >  
> >  #define OPT_ARCH_RUN(pfx, cfg)						\
> > @@ -26,6 +27,10 @@ struct kvm_config_arch {
> >  		    "Disable Zicbom Extension"),			\
> >  	OPT_BOOLEAN('\0', "disable-zihintpause",			\
> >  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIHINTPAUSE],\
> > -		    "Disable Zihintpause Extension"),
> > +		    "Disable Zihintpause Extension"),			\
> > +	OPT_BOOLEAN('\0', "force-pci",					\
> > +			&(cfg)->virtio_trans_pci,			\
> > +		    "Force virtio devices to use PCI as their "		\
> > +		    "default transport"),
> >  
> >  #endif /* KVM__KVM_CONFIG_ARCH_H */
> > -- 
> > 2.25.1
> >   

