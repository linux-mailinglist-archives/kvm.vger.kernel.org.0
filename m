Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACDBB10A334
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 18:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbfKZROR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 12:14:17 -0500
Received: from mga14.intel.com ([192.55.52.115]:28954 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727532AbfKZROR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 12:14:17 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Nov 2019 09:14:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,246,1571727600"; 
   d="scan'208";a="206514949"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 26 Nov 2019 09:14:16 -0800
Date:   Tue, 26 Nov 2019 09:14:16 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Leonardo Bras <leonardo@linux.ibm.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: Add separate helper for putting borrowed reference
 to kvm
Message-ID: <20191126171416.GA22233@linux.intel.com>
References: <20191021225842.23941-1-sean.j.christopherson@intel.com>
 <de313d549a5ae773aad6bbf04c20b395bea7811f.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de313d549a5ae773aad6bbf04c20b395bea7811f.camel@linux.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 26, 2019 at 01:44:14PM -0300, Leonardo Bras wrote:
> On Mon, 2019-10-21 at 15:58 -0700, Sean Christopherson wrote:

...

> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 67ef3f2e19e8..b8534c6b8cf6 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -772,6 +772,18 @@ void kvm_put_kvm(struct kvm *kvm)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_put_kvm);
> > 
> > +/*
> > + * Used to put a reference that was taken on behalf of an object associated
> > + * with a user-visible file descriptor, e.g. a vcpu or device, if installation
> > + * of the new file descriptor fails and the reference cannot be transferred to
> > + * its final owner.  In such cases, the caller is still actively using @kvm and
> > + * will fail miserably if the refcount unexpectedly hits zero.
> > + */
> > +void kvm_put_kvm_no_destroy(struct kvm *kvm)
> > +{
> > +	WARN_ON(refcount_dec_and_test(&kvm->users_count));
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_put_kvm_no_destroy);
> > 
> >  static int kvm_vm_release(struct inode *inode, struct file *filp)
> >  {
> > @@ -2679,7 +2691,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm
> > *kvm, u32 id)
> >  	kvm_get_kvm(kvm);
> >  	r = create_vcpu_fd(vcpu);
> >  	if (r < 0) {
> > -		kvm_put_kvm(kvm);
> > +		kvm_put_kvm_no_destroy(kvm);
> >  		goto unlock_vcpu_destroy;
> >  	}
> > 
> > @@ -3117,7 +3129,7 @@ static int kvm_ioctl_create_device(struct kvm
> > *kvm,
> >  	kvm_get_kvm(kvm);
> >  	ret = anon_inode_getfd(ops->name, &kvm_device_fops, dev, O_RDWR
> > | O_CLOEXEC);
> >  	if (ret < 0) {
> > -		kvm_put_kvm(kvm);
> > +		kvm_put_kvm_no_destroy(kvm);
> >  		mutex_lock(&kvm->lock);
> >  		list_del(&dev->vm_node);
> >  		mutex_unlock(&kvm->lock);
> 
> Hello,
> 
> I see what are you solving here, but would not this behavior cause the
> refcount to reach negative values?
>
> If so, is not there a problem? I mean, in some archs (powerpc included)
> refcount_dec_and_test() will decrement and then test if the value is
> equal 0. If we ever reach a negative value, this will cause that memory
> to never be released. 
>
> An example is that refcount_dec_and_test(), on other archs than x86,
> will call atomic_dec_and_test(), which on include/linux/atomic-
> fallback.h will do:
> 
> return atomic_dec_return(v) == 0;
> 
> To change this behavior, it would mean change the whole atomic_*_test
> behavior, or do a copy function in order to change this '== 0' to 
> '<= 0'. 
> 
> Does it make sense? Do you need any help on this?

I don't think so.  refcount_dec_and_test() will WARN on an underflow when
the kernel is built with CONFIG_REFCOUNT_FULL=y.  I see no value in
duplicating those sanity checks in KVM.

This new helper and WARN is to explicitly catch @users_count unexpectedly
hitting zero, which is orthogonal to an underflow (although odds are good
that a bug that triggers the WARN in kvm_put_kvm_no_destroy() will also
lead to an underflow).  Leaking the memory is deliberate as the alternative
is a guaranteed use-after-free, i.e. kvm_put_kvm_no_destroy() is intended
to be used when users_count is guaranteed to be valid after it is
decremented.
