Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E376C375C
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 17:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjCUQtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 12:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjCUQtv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 12:49:51 -0400
Received: from out-16.mta0.migadu.com (out-16.mta0.migadu.com [91.218.175.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB8A196A8
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 09:49:50 -0700 (PDT)
Date:   Tue, 21 Mar 2023 16:49:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679417388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iRv4KxSy5ICJ8WFYKTzTSXVZp4hOdKIcqsDkf9vriQo=;
        b=NZlvPOKuNAceCXVMNQl2bgEct0aQ6EHWDcB1LsBXOysYFgiZ/Atb3l8pzJ9+4zq+u7TEZq
        Yr4pJuEMdoQhO7+8/dy62X7X6RWOg6mvUXNnnkul1jZnEq/ypkPT+n2VRa5ZuymAsc48T+
        E0XjnY1c+SerlLx7OwGeNf55KH5+oMQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>,
        Salil Mehta <salil.mehta@huawei.com>
Subject: Re: [PATCH 03/11] KVM: arm64: Add vm fd device attribute accessors
Message-ID: <ZBngKAqIIyIWTEsB@linux.dev>
References: <20230320221002.4191007-1-oliver.upton@linux.dev>
 <20230320221002.4191007-4-oliver.upton@linux.dev>
 <5f7dcec1-eeeb-811b-d9bc-85ecb7c73aa9@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f7dcec1-eeeb-811b-d9bc-85ecb7c73aa9@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Suzuki,

On Tue, Mar 21, 2023 at 09:53:06AM +0000, Suzuki K Poulose wrote:
> On 20/03/2023 22:09, Oliver Upton wrote:
> > A subsequent change will allow userspace to convey a filter for
> > hypercalls through a vm device attribute. Add the requisite boilerplate
> > for vm attribute accessors.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >   arch/arm64/kvm/arm.c | 29 +++++++++++++++++++++++++++++
> >   1 file changed, 29 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 3bd732eaf087..b6e26c0e65e5 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1439,11 +1439,28 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
> >   	}
> >   }
> > +static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
> > +{
> > +	switch (attr->group) {
> > +	default:
> > +		return -ENXIO;
> > +	}
> > +}
> > +
> > +static int kvm_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
> > +{
> > +	switch (attr->group) {
> > +	default:
> > +		return -ENXIO;
> > +	}
> > +}
> > +
> >   long kvm_arch_vm_ioctl(struct file *filp,
> >   		       unsigned int ioctl, unsigned long arg)
> >   {
> >   	struct kvm *kvm = filp->private_data;
> >   	void __user *argp = (void __user *)arg;
> > +	struct kvm_device_attr attr;
> >   	switch (ioctl) {
> >   	case KVM_CREATE_IRQCHIP: {
> > @@ -1479,6 +1496,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
> >   			return -EFAULT;
> >   		return kvm_vm_ioctl_mte_copy_tags(kvm, &copy_tags);
> >   	}
> > +	case KVM_HAS_DEVICE_ATTR: {
> > +		if (copy_from_user(&attr, argp, sizeof(attr)))
> > +			return -EFAULT;
> > +
> > +		return kvm_vm_has_attr(kvm, &attr);
> > +	}
> > +	case KVM_SET_DEVICE_ATTR: {
> > +		if (copy_from_user(&attr, argp, sizeof(attr)))
> > +			return -EFAULT;
> > +
> > +		return kvm_vm_set_attr(kvm, &attr);
> > +	}
> 
> Is there a reason to exclude KVM_GET_DEVICE_ATTR handling ?

The GET_DEVICE_ATTR would effectively be dead code, as the hypercall filter is
a write-only attribute. The filter is constructed through iterative calls to
the attribute, so conveying the end result to userspace w/ the same UAPI
is non-trivial.

Hopefully userspace remembers what it wrote to the field ;-)

-- 
Thanks,
Oliver
