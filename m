Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 979DF18C38B
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 00:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgCSXRj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 19:17:39 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:46337 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbgCSXRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 19:17:39 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 48k2r11Tvbz9sRR; Fri, 20 Mar 2020 10:17:37 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1584659857; bh=5SJEPmt9/zfqA41fK6MGMxRejyfnXqUtb8uuRiRqaYw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PBxm3XnX0oD+Ogygg2Ak12R3OmdYXvyPDr1CokcMQpn6E7HSfRVW12OcZjRKnZDPQ
         Qv7zamm6zZpub7GmfCLbHNGAA+Ex1bdf0Lk97uVTtaHWCrEugMhYBbqHdAERI6Bt0S
         308Oq8OkU8a4tgUftmAZ02BbovjYc3Z+049YB1jhoEieJrpV1WtkRQxlZIJf6bGQ+a
         UuQpEqV9BMENYyv0u+LQa6gXBGJrPbWjXrwP642+SCG2j8ZHZWHy08Btxbb0kFm8lX
         ynQN7bolu3M2QRhKjT4jCkPGKGJQ9U3fBHKqVMu9WT75LkdJPTaGm8uqgC5LBWo2Y5
         yf8YNScwtkOZw==
Date:   Fri, 20 Mar 2020 10:17:13 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Add a capability for enabling
 secure guests
Message-ID: <20200319231713.GA3260@blackberry>
References: <20200319043301.GA13052@blackberry>
 <20200319194108.GB5563@oc0525413822.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319194108.GB5563@oc0525413822.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 19, 2020 at 12:41:08PM -0700, Ram Pai wrote:
> On Thu, Mar 19, 2020 at 03:33:01PM +1100, Paul Mackerras wrote:
[snip]
> > --- a/arch/powerpc/kvm/powerpc.c
> > +++ b/arch/powerpc/kvm/powerpc.c
> > @@ -670,6 +670,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >  		     (hv_enabled && cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST));
> >  		break;
> >  #endif
> > +#if defined(CONFIG_KVM_BOOK3S_HV_POSSIBLE) && defined(CONFIG_PPC_UV)
> > +	case KVM_CAP_PPC_SECURE_GUEST:
> > +		r = hv_enabled && !!firmware_has_feature(FW_FEATURE_ULTRAVISOR);
> 
> We also need to check if the kvmppc_uvmem_init() has been successfully
> called and initialized.
> 
> 	r = hv_enabled && !!firmware_has_feature(FW_FEATURE_ULTRAVISOR)
> 		&& kvmppc_uvmem_bitmap;

Well I can't do that exactly because kvmppc_uvmem_bitmap is in a
different module (the kvm_hv module, whereas this code is in the kvm
module), and I wouldn't want to depend on kvmppc_uvmem_bitmap, since
that's an internal implementation detail.

The firmware_has_feature(FW_FEATURE_ULTRAVISOR) test ultimately
depends on there being a device tree node with "ibm,ultravisor" in its
compatible property (see early_init_dt_scan_ultravisor()).  So that
means there is an ultravisor there.  The cases where that test would
pass but kvmppc_uvmem_bitmap == NULL would be those where the device
tree nodes are present but not right, or where the host is so short of
memory that it couldn't allocate the kvmppc_uvmem_bitmap.  If you
think those cases are worth worrying about then I will have to devise
a way to do the test without depending on any symbols from the kvm-hv
module.

Paul.
