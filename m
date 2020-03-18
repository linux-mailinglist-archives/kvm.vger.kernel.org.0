Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 415F218A36E
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 21:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgCRUEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 16:04:20 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:30641 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726647AbgCRUET (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 16:04:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584561858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0xpZ3zAXO8VSPcveIW3cgTKZpnWgucU9u/urAvYcVOA=;
        b=Pdpr14sexkie9h5cSS5DbJ0xpva1n2OqGDKmtLvAKDypBruVlC5zbI/wUQIa44zZvI5Je5
        TLAL7FwrVpOYkKImCon5j4bae4sqeAOhVGcJGuTPYUDHlRNk7ME3eJVzApCFVT/rAlqR3T
        1ABjgEBq8JM2/8+Eud0o5FXLOO+wKbY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-rndD23ZWMfCEeJD2ERwTpA-1; Wed, 18 Mar 2020 16:04:14 -0400
X-MC-Unique: rndD23ZWMfCEeJD2ERwTpA-1
Received: by mail-wr1-f72.google.com with SMTP id h17so3222430wru.16
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 13:04:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0xpZ3zAXO8VSPcveIW3cgTKZpnWgucU9u/urAvYcVOA=;
        b=qFVVNAeBtGlrtUlSmoc0+dN9B0V71QFVDreKFMks6NOkasIF7F2VtS6DRVZz/xuV1x
         wQE81GVw7Y/YM0y7mUw9CHDWYWoZeLXk3p1jy0BKtK4xAlr0pxbs9MjS5LslVJrfvZEa
         gyCoMXlvcBLN+IX6hKtaer/Ndq9/RLw6R8PthTkycR6cvKVtLVOFVb7ZX/fVl3oeaSsZ
         RTV0vuNiMs1Pkk1Os9j+2Xr0+jn8M+uGO0p23HHcFhHR+Y7CcU6ye10RlYm+KZmukHaA
         QPMEo/zJ6cWq5jxFfmz4rcCA9gD8xpYn3DqWzxzp/siIU20zvX/eTjFRoIyh1AM1LpcZ
         4GrQ==
X-Gm-Message-State: ANhLgQ1sko6ArxImjq3Jw4Km86fxeep6yREaBaJcFIvpYl1wNOuuoB29
        KyxwU5e+mgLqMuyUzBg80oXSw9u0QoQkhbaCfYjCbmaDqugwPRjlhNrcddY4iL4emiPZ8UKX9lu
        jbshL5qgv9qvG
X-Received: by 2002:a1c:b7c2:: with SMTP id h185mr7073106wmf.67.1584561852734;
        Wed, 18 Mar 2020 13:04:12 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuhZIINopkV/I2Rp63cmArVM07sr1FfqYPsmcaVefnj1ka4kXzkjZ4RiFxbqgukP/5SJormNw==
X-Received: by 2002:a1c:b7c2:: with SMTP id h185mr7073083wmf.67.1584561852432;
        Wed, 18 Mar 2020 13:04:12 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id u144sm3723075wmu.39.2020.03.18.13.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 13:04:11 -0700 (PDT)
Date:   Wed, 18 Mar 2020 16:04:07 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kbuild test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v6 03/14] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200318200407.GA103005@xz-x1>
References: <20200309214424.330363-4-peterx@redhat.com>
 <202003110908.UE6SBwLU%lkp@intel.com>
 <20200311163906.GG479302@xz-x1>
 <20200311170940.GH21852@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200311170940.GH21852@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 11, 2020 at 10:09:40AM -0700, Sean Christopherson wrote:
> On Wed, Mar 11, 2020 at 12:39:06PM -0400, Peter Xu wrote:
> > On Wed, Mar 11, 2020 at 09:10:04AM +0800, kbuild test robot wrote:
> > > Hi Peter,
> > > 
> > > Thank you for the patch! Perhaps something to improve:
> > > 
> > > [auto build test WARNING on tip/auto-latest]
> > > [also build test WARNING on vhost/linux-next linus/master v5.6-rc5 next-20200310]
> > > [cannot apply to kvm/linux-next linux/master]
> > > [if your patch is applied to the wrong git tree, please drop us a note to help
> > > improve the system. BTW, we also suggest to use '--base' option to specify the
> > > base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> > > 
> > > url:    https://github.com/0day-ci/linux/commits/Peter-Xu/KVM-Dirty-ring-interface/20200310-070637
> > > base:   https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git 12481c76713078054f2d043b3ce946e4814ac29f
> > > reproduce:
> > >         # apt-get install sparse
> > >         # sparse version: v0.6.1-174-g094d5a94-dirty
> > >         make ARCH=x86_64 allmodconfig
> > >         make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
> > > 
> > > If you fix the issue, kindly add following tag
> > > Reported-by: kbuild test robot <lkp@intel.com>
> > > 
> > > 
> > > sparse warnings: (new ones prefixed by >>)
> > > 
> > >    arch/x86/kvm/x86.c:2599:38: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const [noderef] <asn:1> * @@    got  const [noderef] <asn:1> * @@
> > >    arch/x86/kvm/x86.c:2599:38: sparse:    expected void const [noderef] <asn:1> *
> > >    arch/x86/kvm/x86.c:2599:38: sparse:    got unsigned char [usertype] *
> > >    arch/x86/kvm/x86.c:7501:15: sparse: sparse: incompatible types in comparison expression (different address spaces):
> > >    arch/x86/kvm/x86.c:7501:15: sparse:    struct kvm_apic_map [noderef] <asn:4> *
> > >    arch/x86/kvm/x86.c:7501:15: sparse:    struct kvm_apic_map *
> > > >> arch/x86/kvm/x86.c:9794:31: sparse: sparse: incorrect type in return expression (different address spaces) @@    expected void [noderef] <asn:1> * @@    got n:1> * @@
> > 
> > I'm not sure on how I can reproduce this locally, and also I'm not
> > very sure I understand this warning.  I'd be glad to know if anyone
> > knows...
> > 
> > If without further hints, I'll try to remove the __user for
> > __x86_set_memory_region() and use a cast on the callers next.
> 
> Ah, it's complaining that the ERR_PTR() returns in __x86_set_memory_region()
> aren't explicitly casting to a __user pointer.
> 
> Part of me wonders if something along the lines of your original approach
> of keeping the "int" return and passing a "void __user **p_hva" would be
> cleaner overall, as opposed to having to cast everywhere.  The diff would
> certainly be smaller.  E.g.
> 
> int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size,
> 			    void __user **p_hva)
> {
> 	...
> 
> 	if (p_hva)
> 		*p_hva = (void __user *)hva;
> 
>         return 0;
> }

Returning an adress still has some advantage on one less param.  To
avoid going back and forth, I defined ERR_PTR_USR() and used there to
fix the sparse warnings.  Thanks,

-- 
Peter Xu

