Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF82442B37
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 17:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437689AbfFLPq0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 11:46:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437621AbfFLPq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 11:46:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4086A215EA;
        Wed, 12 Jun 2019 15:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560354385;
        bh=x4b84rsltDbkns/tjkmQ34eiJep5zNEqmA4yOaE8Gm8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i/7HwceAAztshkmCdcZGx8VcfTGwgN1mxk95/ekUkMvYNHGQk8eYqtww80vKjGB9P
         tgrIm313POdvjpUDMWdjYkCdYuqh/3gYpxv0Ogf39dop6dx6NTy7cBq5AcnvqMD3p1
         QNEyrviviah58vwWnLUO5tDnWvHI5dGk6ODPgYaQ=
Date:   Wed, 12 Jun 2019 17:46:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: remove invalid check for debugfs_create_dir()
Message-ID: <20190612154622.GA22739@kroah.com>
References: <20190612145033.GA18084@kroah.com>
 <20190612154021.GF20308@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190612154021.GF20308@linux.intel.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 12, 2019 at 08:40:21AM -0700, Sean Christopherson wrote:
> On Wed, Jun 12, 2019 at 04:50:33PM +0200, Greg Kroah-Hartman wrote:
> > debugfs_create_dir() can never return NULL, so no need to check for an
> > impossible thing.
> > 
> > It's also not needed to ever check the return value of this function, so
> > just remove the check entirely, and indent the previous line to a sane
> > formatting :)
> > 
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> > Cc: kvm@vger.kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  virt/kvm/kvm_main.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index ca54b09adf5b..4b4ef642d8fa 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2605,9 +2605,7 @@ static int kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
> >  
> >  	snprintf(dir_name, sizeof(dir_name), "vcpu%d", vcpu->vcpu_id);
> >  	vcpu->debugfs_dentry = debugfs_create_dir(dir_name,
> > -								vcpu->kvm->debugfs_dentry);
> > -	if (!vcpu->debugfs_dentry)
> > -		return -ENOMEM;
> > +						  vcpu->kvm->debugfs_dentry);
> >  
> >  	ret = kvm_arch_create_vcpu_debugfs(vcpu);
> >  	if (ret < 0) {
> > -- 
> > 2.22.0
> 
> Any objection to me pulling this into a series to clean up similar issues
> in arch/x86/kvm/debugfs.c -> kvm_arch_create_vcpu_debugfs(), and to
> change kvm_create_vcpu_debugfs() to not return success/failure?  It'd be
> nice to fix everything in a single shot.

It was on my todo list to do the cleanup of the x86 kvm stuff.  I
figured this arch-neutral fix was independent, but if you want me to do
it all at once, I'll be glad to do so later this week.

thanks,

greg k-h
