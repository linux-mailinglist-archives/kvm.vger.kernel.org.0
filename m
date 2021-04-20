Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA6F366278
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 01:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbhDTX1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 19:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234290AbhDTX1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 19:27:11 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAEFC06174A
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 16:26:39 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id g16so3696068plq.3
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 16:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0qlu9dhH/WkK2RT8ePKeim6dOFYFhQZ+dnqPgQR/Yhk=;
        b=SiLphwB7uAPiunj9/PliCt/W2Hn46mXxDXNjCyVoFFOHOGxOfdQeNQUdpqsV7EKlhi
         Ts42KxEYJAYi+XUDl3yTsubuMM5oerCqemxsX4hh2XnKowqrwpOkUp83Rkb9dH7NKD+6
         anv/8V7l3+86kX6ADNPSnN4VskoiKyCyGtTlB3dipFLK5zo63k68lT9B/CRq40fHJdsH
         GHKtM4ZmyBoNvra+VVhVMObAyMF3bUMpXiLCz3J5yrfxU2ldDRrispu0bi2t3MsGj4dU
         zWWbT6X7CyQ7oERMwtvQcrmHCX/j3snVGCUSn+2gah7pGRhfhRsnBbuUtWUHFuINGcCU
         Shww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0qlu9dhH/WkK2RT8ePKeim6dOFYFhQZ+dnqPgQR/Yhk=;
        b=hqupUEBKdMhNvhaWQZteijqsSzfB9mHOA//yfRNqfdy+fKqS0e+kiC65kaRvwbGg/u
         BU39/Hio/7TKxKpG0OC8R1iy/yqXsaS5NmKqdE0r6r84inHuZpkXIfYM0O2/M0gPqTwd
         S3sHlY9n5ViO/t08FDhwPuQpsxo8MK5qel+Amfj36faCgwqRg3VgiKM6X1r49t/mFbkx
         CDbE3lX9ZZ9h4LJwPq6pyQRFI2qn392YaqmLL/+QjLjZ+Mjvh4s6dBe8I7M+l4GVZgRD
         +m8FGHW4GDxafm/TLbT6mdAqGhk527c4bJPQIZrEyi+M87NkwUfLb0iLe54XogIvavSu
         OXMw==
X-Gm-Message-State: AOAM531DsZaoJmJ9C/RtZCzloFXPLXQzzGyGXPpIpCGiuHeoIFwKitil
        B6id1zTSCwOCBxu/mHeumo3+3Q==
X-Google-Smtp-Source: ABdhPJz5sZLLgPRQUdnzKngA02RMKJA94LBFbrExxAIBAVhr4QcTLL7+6YS18cRFkdIGidUyZVR9+Q==
X-Received: by 2002:a17:902:e8ca:b029:ec:bec2:ba6b with SMTP id v10-20020a170902e8cab02900ecbec2ba6bmr3661376plg.42.1618961198626;
        Tue, 20 Apr 2021 16:26:38 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id l22sm176699pjc.13.2021.04.20.16.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 16:26:37 -0700 (PDT)
Date:   Tue, 20 Apr 2021 23:26:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v3 3/9] KVM: x86: Defer tick-based accounting 'til after
 IRQ handling
Message-ID: <YH9jKpeviZtMKxt8@google.com>
References: <20210415222106.1643837-1-seanjc@google.com>
 <20210415222106.1643837-4-seanjc@google.com>
 <20210420231402.GA8720@lothringen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420231402.GA8720@lothringen>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 21, 2021, Frederic Weisbecker wrote:
> On Thu, Apr 15, 2021 at 03:21:00PM -0700, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 16fb39503296..e4d475df1d4a 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9230,6 +9230,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >  	local_irq_disable();
> >  	kvm_after_interrupt(vcpu);
> >  
> > +	/*
> > +	 * When using tick-based accounting, wait until after servicing IRQs to
> > +	 * account guest time so that any ticks that occurred while running the
> > +	 * guest are properly accounted to the guest.
> > +	 */
> > +	if (!vtime_accounting_enabled_this_cpu())
> > +		vtime_account_guest_exit();
> 
> Can we rather have instead:
> 
> static inline void tick_account_guest_exit(void)
> {
> 	if (!vtime_accounting_enabled_this_cpu())
> 		current->flags &= ~PF_VCPU;
> }
> 
> It duplicates a bit of code but I think this will read less confusing.

Either way works for me.  I used vtime_account_guest_exit() to try to keep as
many details as possible inside vtime, e.g. in case the implemenation is tweaked
in the future.  But I agree that pretending KVM isn't already deeply intertwined
with the details is a lie.
