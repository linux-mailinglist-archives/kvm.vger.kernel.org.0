Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA71405C73
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 20:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242417AbhIISBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 14:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241252AbhIISBK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 14:01:10 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1775CC061575
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 11:00:01 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id d5so1944748pjx.2
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 11:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GNjXTY5duOz5iXe0iAVr/cU22eBlSdyUTm1y6N/AOUA=;
        b=eZpkE8uHgyLVQ7ZYGW8+2OCnNwbPIVqjw1hB+TtE0X2wh3aOAZMYtxJALgcu59UIm+
         2O5Sz1AezMZYIBCE8r37mHz4hY+fhnyEpkTFm3iH3REZI6b3NVK9nYcj4Rxed80hcbmC
         xOCRj4kIKMgoXSp6GfiJz3GNmnDhGD1Lg2ms6Yt5rhJH+EoQ/50EHbpyVI4OK4CQeoK+
         x36WAgbT5YcEdfmLGo44xZVaoNqP2NjhzZrRagk+bGDyr0F6mOBT30Dv5mze3IYpC9D2
         j0J7nFL4iPUe1CkaPRHusbux4G8Ap1d5mZ8YQAYrBHkZ8fnXe4HmAKnjhQ4eZL56suOR
         E2FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GNjXTY5duOz5iXe0iAVr/cU22eBlSdyUTm1y6N/AOUA=;
        b=kVDsVD3/KbQNlCotivTsYqW5tIH9mXj434RhW1+jZn+4pDYo9iG0PlpVEb1YQTtnfi
         uhn+77SBq6oR4CmFvuWRvXA1IZ0kbD0q5LDiKUtJ1msPtlDSD+2Sezy9f/xf8u5otRUw
         X7A21mDrIn0EPs7ghmR8qO8D4OM5zxSWAb4y7X8O++6ofXayHw9pMxG9OXh3gi8EA2Ra
         mV/NMDJOLa+S4A0IANhSXHR21urIGCl1F+Wp5hsAeLN5uRFvwhlFnmHNlGNlE6Nt3kgb
         CFWjdbVFoK1deigpFo/Zb0ZIczl88oDVjIiA536+psCs85sepErua38+Dnkfa4wXNi9r
         FY+Q==
X-Gm-Message-State: AOAM531XkPbUQBCKdDhtAu0HVI2aO+16DSIuKLbn3SKJx8/1ydDwXtht
        9/ewlsF2ChaAilGaAU+SZ4B4Jw==
X-Google-Smtp-Source: ABdhPJy2TeUC8LicdPd0UfXbOjZP3tQWsUknqYL5wLhjjYBjKbVqO5zl7sVy7YNXIbHv5Rd5u8Bb9Q==
X-Received: by 2002:a17:90a:8b84:: with SMTP id z4mr4863656pjn.60.1631210400447;
        Thu, 09 Sep 2021 11:00:00 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l22sm2812030pjz.54.2021.09.09.10.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 10:59:59 -0700 (PDT)
Date:   Thu, 9 Sep 2021 17:59:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix nested bus lock VM exit
Message-ID: <YTpLmxaR9zLbcyxx@google.com>
References: <20210827085110.6763-1-chenyi.qiang@intel.com>
 <YS/BrirERUK4uDaI@google.com>
 <0f064b93-8375-8cba-6422-ff12f95af656@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f064b93-8375-8cba-6422-ff12f95af656@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 02, 2021, Xiaoyao Li wrote:
> On 9/2/2021 2:08 AM, Sean Christopherson wrote:
> > On Fri, Aug 27, 2021, Chenyi Qiang wrote:
> > > Nested bus lock VM exits are not supported yet. If L2 triggers bus lock
> > > VM exit, it will be directed to L1 VMM, which would cause unexpected
> > > behavior. Therefore, handle L2's bus lock VM exits in L0 directly.
> > > 
> > > Fixes: fe6b6bc802b4 ("KVM: VMX: Enable bus lock VM exit")
> > > Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> > > ---
> > >   arch/x86/kvm/vmx/nested.c | 2 ++
> > >   1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index bc6327950657..754f53cf0f7a 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -5873,6 +5873,8 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
> > >   	case EXIT_REASON_VMFUNC:
> > >   		/* VM functions are emulated through L2->L0 vmexits. */
> > >   		return true;
> > > +	case EXIT_REASON_BUS_LOCK:
> > > +		return true;
> > 
> > Hmm, unless there is zero chance of ever exposing BUS_LOCK_DETECTION to L1, it
> > might be better to handle this in nested_vmx_l1_wants_exit(), e.g.
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index b3f77d18eb5a..793534b7eaba 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -6024,6 +6024,8 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
> >                          SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE);
> >          case EXIT_REASON_ENCLS:
> >                  return nested_vmx_exit_handled_encls(vcpu, vmcs12);
> > +       case EXIT_REASON_BUS_LOCK:
> > +               return nested_cpu_has2(vmcs12, SECONDARY_EXEC_BUS_LOCK_DETECTION);
> 
> yes, for now, it equals
> 
>                   return false;
> 
> because KVM doesn't expose it to L1.
> 
> >          default:
> >                  return true;
> >          }
> > 
> > It's a rather roundabout way of reaching the same result, but I'd prefer to limit
> > nested_vmx_l0_wants_exit() to cases where L0 wants to handle the exit regardless
> > of what L1 wants.  This kinda fits that model, but it's not really that L0 "wants"
> > the exit, it's that L1 can't want the exit.  Does that make sense?
> 
> something like below has to be in nested_vmx_l0_wants_exit()
> 
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5873,6 +5873,8 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu
> *vcpu,
>         case EXIT_REASON_VMFUNC:
>                 /* VM functions are emulated through L2->L0 vmexits. */
>                 return true;
> +       case EXIT_REASON_BUS_LOCK:
> +               return vcpu->kvm->arch.bus_lock_detection_enabled;
>         default:
>                 break;
>         }
> 
> 
> L0 wants this VM exit because it enables BUS LOCK VM exit, not because L1
> doesn't enable it.

No, nested_vmx_l0_wants_exit() is specifically for cases where L0 wants to handle
the exit even if L1 also wants to handle the exit.  For cases where L0 is expected
to handle the exit because L1 does _not_ want the exit, the intent is to not have
an entry in nested_vmx_l0_wants_exit().  This is a bit of a grey area, arguably L0
"wants" the exit because L0 knows BUS_LOCK cannot be exposed to L1.

But if we go with that argument, then the original patch (with a comment), is correct.
Conditioning L0's wants on bus_lock_detection_enabled is not correct because whether
or not the feature is enabled by L0 does not affect whether or not it's exposed to L1.
Obviously BUS_LOCK exits should not happen if bus_lock_detection_enabled==false, but
that's not relevant for why L0 "wants" the exit.

I'm not totally opposed to handling this in nested_vmx_l0_wants_exit(), but handling
the check in nested_vmx_l1_wants_exit() has the advantage of being correct both now
and in the future (if BUS_LOCK is ever exposed to L1).
