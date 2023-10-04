Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE557B85B8
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 18:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243475AbjJDQwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 12:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243307AbjJDQwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 12:52:19 -0400
Received: from out-195.mta1.migadu.com (out-195.mta1.migadu.com [IPv6:2001:41d0:203:375::c3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E433AAB
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 09:52:15 -0700 (PDT)
Date:   Wed, 4 Oct 2023 16:52:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696438332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lyrW/eDz6j3FPPRhBgKSpiIS1X9+faqbc2d97RqcH1k=;
        b=IieHVdd0Oofl6u9tY+dufR7ApVCUx8SMMSCMlUhV8GwTT9dsuno2SC10OvdRB/EoFY+Z99
        uO4FSYlg7G5iKLa8Srtg0y1nCxy0KYtR9MqH4EjB7C1w7LPGFG7fcK+oturZRoH8IvkYzG
        XnNwXkRJLG5JDOVmU4XyXLgpqnNl+FI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Jing Zhang <jingzhangos@google.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v11 10/12] KVM: arm64: Document vCPU feature selection
 UAPIs
Message-ID: <ZR2YOF1lMGLraR1Q@linux.dev>
References: <20231003230408.3405722-1-oliver.upton@linux.dev>
 <20231003230408.3405722-11-oliver.upton@linux.dev>
 <86o7heohjh.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86o7heohjh.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 04, 2023 at 10:36:50AM +0100, Marc Zyngier wrote:
> On Wed, 04 Oct 2023 00:04:06 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:

[...]

> > +The ID Registers
> > +================
> > +
> > +The Arm architecture specifies a range of *ID Registers* that describe the set
> > +of architectural features supported by the CPU implementation. KVM initializes
> > +the guest's ID registers to the maximum set of CPU features supported by the
> > +system. The ID register values are VM-scoped in KVM, meaning that the values
> > +are identical for all vCPUs in a VM.
> 
> I'm a bit reluctant to give this guarantee. Case in point: MPIDR_EL1
> is part of the Feature ID space, and is definitely *not* a register
> that we can make global, even on a fully homogeneous system.

Oh, very good point.

> I'd also like to give us more flexibility to change the implementation
> in the future without having to change the API again. IMO, the fact
> that we make our life simpler by only tracking a single copy is an
> implementation detail, not something that userspace should rely on.
> 
> I would simply turn the "The ID register values are VM-scoped" into
> "The ID register values may be VM-scoped", which gives us that
> flexibility.

Agreed, I'm happy to duck behind some vague language here :)

> > +
> > +KVM allows userspace to *opt-out* of certain CPU features described by the ID
> > +registers by writing values to them via the ``KVM_SET_ONE_REG`` ioctl. The ID
> > +registers are mutable until the VM has started, i.e. userspace has called
> > +``KVM_RUN`` on at least one vCPU in the VM. Userspace can discover what fields
> > +are mutable in the ID registers using the ``KVM_ARM_GET_REG_WRITABLE_MASKS``.
> > +See the :ref:`ioctl documentation <KVM_ARM_GET_REG_WRITABLE_MASKS>` for more
> > +details.
> > +
> > +Userspace is allowed to *limit* or *mask* CPU features according to the rules
> > +outlined by the architecture in DDI0487J 'D19.1.3 Principles of the ID scheme
> 
> nit: consider spelling out the *full* version of the ARM ARM (DDI
> 0487J.a), just in case we get a J.b this side of Xmas and that this
> reference is renumbered...

Going to fix both of these with the following diff:

diff --git a/Documentation/virt/kvm/arm/vcpu-features.rst b/Documentation/virt/kvm/arm/vcpu-features.rst
index 2d2f89c5781f..f7cc6d8d8b74 100644
--- a/Documentation/virt/kvm/arm/vcpu-features.rst
+++ b/Documentation/virt/kvm/arm/vcpu-features.rst
@@ -24,8 +24,8 @@ The ID Registers
 The Arm architecture specifies a range of *ID Registers* that describe the set
 of architectural features supported by the CPU implementation. KVM initializes
 the guest's ID registers to the maximum set of CPU features supported by the
-system. The ID register values are VM-scoped in KVM, meaning that the values
-are identical for all vCPUs in a VM.
+system. The ID register values may be VM-scoped in KVM, meaning that the
+values could be shared for all vCPUs in a VM.
 
 KVM allows userspace to *opt-out* of certain CPU features described by the ID
 registers by writing values to them via the ``KVM_SET_ONE_REG`` ioctl. The ID
@@ -36,9 +36,9 @@ See the :ref:`ioctl documentation <KVM_ARM_GET_REG_WRITABLE_MASKS>` for more
 details.
 
 Userspace is allowed to *limit* or *mask* CPU features according to the rules
-outlined by the architecture in DDI0487J 'D19.1.3 Principles of the ID scheme
-for fields in ID register'. KVM does not allow ID register values that exceed
-the capabilities of the system.
+outlined by the architecture in DDI0487J.a D19.1.3 'Principles of the ID
+scheme for fields in ID register'. KVM does not allow ID register values that
+exceed the capabilities of the system.
 
 .. warning::
    It is **strongly recommended** that userspace modify the ID register values

-- 
Thanks,
Oliver
