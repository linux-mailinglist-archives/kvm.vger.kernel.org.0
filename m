Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A24340BA2
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 18:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbhCRRWT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 13:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232281AbhCRRWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 13:22:06 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2314FC06175F
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 10:22:06 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id x126so3951711pfc.13
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 10:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+zrC/2pN/qc0ZP+joKAbaps/MruXf28Rv4f5cOXi7Dc=;
        b=Lr4w7CS01/YiT8pPA94i4qxdH8NUb6mRWSa4tgsgw/pQLsKrWkot9A236IjKLqRztU
         tBLCqbeY1r6/MfWsMYTKmClPPqPyduDADnujqPm033KQlvthHF06knyLlG1ru9jXz1t0
         ZChrV8zTKJCppm+dKwJeTA5LpaSMBMxlSw2CODlKGZieWpu47bw6/3qrYRh6QBr2VwEx
         GT0xUCR57aCN97aA6LtkNpXOjJ4E78DgJqcPiIvcg4oEc5iy+egr87JYLvGjTInd4fpg
         gaUZATkxr8TRlstns+fcJhcX/mXFEbqBRyWGvRLUX8WuSZTo7usP0tGXNXYAYYTal4Lz
         TA1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+zrC/2pN/qc0ZP+joKAbaps/MruXf28Rv4f5cOXi7Dc=;
        b=JullS88H5bvKXIeOMxO98ZdCU++pSZeOViis3Nfynu4HQzC2drfxXlpdeCF+pRr98y
         UDqeK/Se03QwNzOJQn2zm6etPT9wlaXOWn1UdTxE7Cm90RjguujB9jGiotY1T63hM8xd
         PTGA3YUfEl1HAFtAeWEK46NsJADybQr7TM4wyBqEzo/bvetkpMmyAxIBwzVQ7A36RHzg
         PuQ/pU/p0AIvQEvYsJgc8F4I3cTsMtei8dbpqvs9plb2toAafoWZDIjK3V10xLGUT11q
         KW60EDlGwqLz0rD/Vj8/ysL7FufsVMl2d5vsbVyMhJ+gs2ycwtBk4PAhc2IZFTKfqgsm
         WS8A==
X-Gm-Message-State: AOAM5309zaH20sekfp4ZYvpkFfFr1/2A3Mk8/fMjd2W1SOOR/t9Uxod2
        d5n3duSex0eVNJQnY9nk3+3b3dIJr2OMFQ==
X-Google-Smtp-Source: ABdhPJxn+Splpv0+LjpjvGFtyxXBgvHGN8pdP+SLW1lNh8ZUGZnyJwrs6nJzn62U6fuuKsf4fQdnFA==
X-Received: by 2002:a63:2582:: with SMTP id l124mr7893687pgl.338.1616088125511;
        Thu, 18 Mar 2021 10:22:05 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id z4sm2713747pgv.73.2021.03.18.10.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 10:22:04 -0700 (PDT)
Date:   Thu, 18 Mar 2021 17:22:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 3/3] KVM: SVM: allow to intercept all exceptions for debug
Message-ID: <YFOMOV/u69LEpnh8@google.com>
References: <20210315221020.661693-1-mlevitsk@redhat.com>
 <20210315221020.661693-4-mlevitsk@redhat.com>
 <YFBtI55sVzIJ15U+@8bytes.org>
 <4116d6ce75a85faccfe7a2b3967528f0561974ae.camel@redhat.com>
 <YFMbLWLlGgbOJuN/@8bytes.org>
 <8ba6676471dc8c8219e35d6a1695febaea20bb0b.camel@redhat.com>
 <YFN2HGG7ZTdamM7k@8bytes.org>
 <YFOBTITk7EkGdzR2@google.com>
 <7169229dde171c8e10fb276ff8e1a869af99b39d.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7169229dde171c8e10fb276ff8e1a869af99b39d.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 18, 2021, Maxim Levitsky wrote:
> On Thu, 2021-03-18 at 16:35 +0000, Sean Christopherson wrote:
> > Skipping SEV-ES guests should not be difficult; KVM could probably even
> > print a message stating that the debug hook is being ignored.  One thought would
> > be to snapshot debug_intercept_exceptions at VM creation, and simply zero it out
> > for incompatible guests.  That would also allow changing debug_intercept_exceptions
> > without reloading KVM, which IMO would be very convenient.
> > 
> So all right I'll disable this for SEV-ES. 

Belated thought.  KVM doesn't know a guest will be an SEV-ES guest until
sev_es_guest_init(), and KVM currently doesn't prevent creating vCPUs before
KVM_SEV_ES_INIT.  But, I'm 99% confident that's a KVM bug.  For your purposes,
I think you can assume kvm->arch.debug_intercept_exceptions will _not_ change
after vCPU creation.

> The idea to change the debug_intercept_exceptions on the fly is also a good idea,
> I will implement it in next version of the patches.

Can you also move the module param to x86?  It doesn't need to be wired up for
VMX right away, but it makes sense to do it at some point, and ideally folks
won't have to update their scripts when that happens.
