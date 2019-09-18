Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0451B62AB
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 14:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729656AbfIRMDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 08:03:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729627AbfIRMDz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 08:03:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C059B2054F;
        Wed, 18 Sep 2019 12:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568808234;
        bh=4bS4vQGRl4R5tsRX0vZKSFN5Wb5+OQtj4Aq++O0+0gg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YIi2OK1Obg+QKN8Vi7HuyNuDE3ayU7wxxTr7TuYUHd6LVXrROlmPvlxl30RfHrpti
         uvUI48+SOrpak0q+Bq+U8Wdy8hG8kFXhjoLoT192SjavJeiigp33H7hpAcctLVTG7T
         RFF2V5jNnIQaiTsmNHTYeQ+P/dHYYLS/xvbvMzHA=
Date:   Wed, 18 Sep 2019 14:03:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     wang.yi59@zte.com.cn
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xue.zhihong@zte.com.cn, up2wing@gmail.com, wang.liang82@zte.com.cn
Subject: Re: [PATCH] kvm: x86: Use DEFINE_DEBUGFS_ATTRIBUTE for debugfs files
Message-ID: <20190918120352.GB1901208@kroah.com>
References: <31eec57f-2bc8-0ea0-e5fb-6b21ce902aae@redhat.com>
 <201909180819440437759@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201909180819440437759@zte.com.cn>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 18, 2019 at 08:19:44AM +0800, wang.yi59@zte.com.cn wrote:
> Hi Paolo,
> 
> > On 22/07/19 09:33, Yi Wang wrote:
> > > We got these coccinelle warning:
> > > ./arch/x86/kvm/debugfs.c:23:0-23: WARNING: vcpu_timer_advance_ns_fops
> > > should be defined with DEFINE_DEBUGFS_ATTRIBUTE
> > > ./arch/x86/kvm/debugfs.c:32:0-23: WARNING: vcpu_tsc_offset_fops should
> > > be defined with DEFINE_DEBUGFS_ATTRIBUTE
> > > ./arch/x86/kvm/debugfs.c:41:0-23: WARNING: vcpu_tsc_scaling_fops should
> > > be defined with DEFINE_DEBUGFS_ATTRIBUTE
> > > ./arch/x86/kvm/debugfs.c:49:0-23: WARNING: vcpu_tsc_scaling_frac_fops
> > > should be defined with DEFINE_DEBUGFS_ATTRIBUTE
> > >
> > > Use DEFINE_DEBUGFS_ATTRIBUTE() rather than DEFINE_SIMPLE_ATTRIBUTE()
> > > to fix this.
> > >
> > > Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
> >
> > It sucks though that you have to use a function with "unsafe" in the name.
> 
> Yes, it does, but I found some patches in the git log:
> https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?qt=grep&q=DEFINE_DEBUGFS_ATTRIBUTE+
> 
> And, do you think the function name "debugfs_create_file_unsafe" is not proper?

Only if you _KNOW_ you are creating/removing these files in a way that
is safe is it ok to use these calls.  Hint, what is your locking
strategy for when these files are removed?

Is that the case here?  If not, please stick with what is there today,
as we know it works, and it is "safe" to do so.

thanks,

greg k-h
