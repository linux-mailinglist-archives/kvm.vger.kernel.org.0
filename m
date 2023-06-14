Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123A372FE77
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 14:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244533AbjFNMXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 08:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244600AbjFNMXk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 08:23:40 -0400
Received: from out-3.mta0.migadu.com (out-3.mta0.migadu.com [91.218.175.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD538109
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 05:23:39 -0700 (PDT)
Date:   Wed, 14 Jun 2023 12:23:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686745418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wQb4z5JVMfEidGknQD3xscf32z72ie53CeaTZ4MqnRo=;
        b=VDJHBwbnWvVpVV2I5wdZ1dSmkV4OW6DcXGB7WkRvbQbH6ER5gTv95Aul+DGOp3MA8pjOAX
        0zLmfb5AUIxalCYMg97MGheRtghN8tPVWj5eSM3htLfyZm7zxBgdLPibhTnINAzEYZORpr
        wAQ4FhHqgISs2x21TFI+MTTB8WH2WY8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wei Wang <wei.w.wang@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Subject: Re: [PATCH RESEND v2] KVM: move KVM_CAP_DEVICE_CTRL to the generic
 check
Message-ID: <ZImxRC3QlLbPhwsC@linux.dev>
References: <20230315101606.10636-1-wei.w.wang@intel.com>
 <ZIjcoOaexz5YAyWT@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIjcoOaexz5YAyWT@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 13, 2023 at 02:16:16PM -0700, Sean Christopherson wrote:
> +<everyone else>
> 
> Please use scripts/get_maintainer.pl to generate the To/Cc lists.  This may be
> trivial, but it still needs eyeballs from the relevant maintainers.

+1000. I'd buy someone a beer if they made a bot that just ran
get_maintainer on patches that hit the list :)

> On Wed, Mar 15, 2023, Wei Wang wrote:
> > KVM_CAP_DEVICE_CTRL allows userspace to check if the kvm_device
> > framework (e.g. KVM_CREATE_DEVICE) is supported by KVM. Move
> > KVM_CAP_DEVICE_CTRL to the generic check for the two reasons:
> > 1) it already supports arch agnostic usages (i.e. KVM_DEV_TYPE_VFIO).
> > For example, userspace VFIO implementation may needs to create
> > KVM_DEV_TYPE_VFIO on x86, riscv, or arm etc. It is simpler to have it
> > checked at the generic code than at each arch's code.
> > 2) KVM_CREATE_DEVICE has been added to the generic code.
> > 
> > Link: https://lore.kernel.org/all/20221215115207.14784-1-wei.w.wang@intel.com
> > Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> > Reviewed-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/arm64/kvm/arm.c       | 1 -
> >  arch/powerpc/kvm/powerpc.c | 1 -
> >  arch/riscv/kvm/vm.c        | 1 -
> >  arch/s390/kvm/kvm-s390.c   | 1 -
> >  virt/kvm/kvm_main.c        | 1 +
> >  5 files changed, 1 insertion(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 3bd732eaf087..96329e675771 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -202,7 +202,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >  		r = vgic_present;
> >  		break;
> >  	case KVM_CAP_IOEVENTFD:
> > -	case KVM_CAP_DEVICE_CTRL:
> >  	case KVM_CAP_USER_MEMORY:
> >  	case KVM_CAP_SYNC_MMU:
> >  	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:

for arm64:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
