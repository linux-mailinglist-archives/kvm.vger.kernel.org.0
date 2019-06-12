Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 450C142B53
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 17:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbfFLPzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 11:55:12 -0400
Received: from mga06.intel.com ([134.134.136.31]:63860 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729772AbfFLPzM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 11:55:12 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jun 2019 08:55:12 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga001.jf.intel.com with ESMTP; 12 Jun 2019 08:55:12 -0700
Date:   Wed, 12 Jun 2019 08:55:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: remove invalid check for debugfs_create_dir()
Message-ID: <20190612155512.GG20308@linux.intel.com>
References: <20190612145033.GA18084@kroah.com>
 <20190612154021.GF20308@linux.intel.com>
 <20190612154622.GA22739@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190612154622.GA22739@kroah.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 12, 2019 at 05:46:22PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Jun 12, 2019 at 08:40:21AM -0700, Sean Christopherson wrote:
> > On Wed, Jun 12, 2019 at 04:50:33PM +0200, Greg Kroah-Hartman wrote:
> > > debugfs_create_dir() can never return NULL, so no need to check for an
> > > impossible thing.
> > > 
> > > It's also not needed to ever check the return value of this function, so
> > > just remove the check entirely, and indent the previous line to a sane
> > > formatting :)
> > > 
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> > > Cc: kvm@vger.kernel.org
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  virt/kvm/kvm_main.c | 4 +---
> > >  1 file changed, 1 insertion(+), 3 deletions(-)
> > > 
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index ca54b09adf5b..4b4ef642d8fa 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -2605,9 +2605,7 @@ static int kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
> > >  
> > >  	snprintf(dir_name, sizeof(dir_name), "vcpu%d", vcpu->vcpu_id);
> > >  	vcpu->debugfs_dentry = debugfs_create_dir(dir_name,
> > > -								vcpu->kvm->debugfs_dentry);
> > > -	if (!vcpu->debugfs_dentry)
> > > -		return -ENOMEM;
> > > +						  vcpu->kvm->debugfs_dentry);
> > >  
> > >  	ret = kvm_arch_create_vcpu_debugfs(vcpu);
> > >  	if (ret < 0) {
> > > -- 
> > > 2.22.0
> > 
> > Any objection to me pulling this into a series to clean up similar issues
> > in arch/x86/kvm/debugfs.c -> kvm_arch_create_vcpu_debugfs(), and to
> > change kvm_create_vcpu_debugfs() to not return success/failure?  It'd be
> > nice to fix everything in a single shot.
> 
> It was on my todo list to do the cleanup of the x86 kvm stuff.  I
> figured this arch-neutral fix was independent, but if you want me to do
> it all at once, I'll be glad to do so later this week.

My preference would be to get it done all at once, having a discrepancy
between kvm_main and x86 leads to a bit of head scratching.

The x86 change would be independent, the piece that's not is converting
kvm_create_vcpu_debugfs() to handle failure internally and not return
errors, which would depend on this patch's removal of "return -ENOMEM".
At a minimum I think that change should be paired with this fix.
