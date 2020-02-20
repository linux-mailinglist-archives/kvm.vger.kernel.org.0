Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 933AC166759
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 20:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgBTTmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 14:42:35 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32863 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728248AbgBTTmf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 14:42:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582227754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tAWNmmE2p8lPy3rxVo9dB+I34MLFYDo3EY8B7t8ysKQ=;
        b=G8hRn3PCfC97fESI10x9TznV8cth115dstaTWPwlRMLCTyXIxbUZuy3zWKWEX5oFs4w0R7
        pujo8l48jA3l3YFjy5ES81kSfRABXsJhXUL+HloHU1UmyIfvvwCzQvM5d3ScaXysVac2bF
        bvuOu7cfD5Hdkp8XhGiBYrvt5gfOb1I=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-Q12kSWw8PpWZ-3OKnneKag-1; Thu, 20 Feb 2020 14:42:32 -0500
X-MC-Unique: Q12kSWw8PpWZ-3OKnneKag-1
Received: by mail-qv1-f70.google.com with SMTP id p3so3324637qvt.9
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 11:42:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tAWNmmE2p8lPy3rxVo9dB+I34MLFYDo3EY8B7t8ysKQ=;
        b=JkzDf/WExi52vxHtDJZTzOgyUFT7jlUHNt0H017kFH2SMMPqpY7hwNmN2xMNm3LD3A
         qQ4JTQrIP59ekHPaa0Pbgz36NMJARgcL3IIAVvWaZsZ+MzNP5/RxYnfOGqIRkme7j1/b
         Fl8rDZ5KJhCPbwompy6jOj4RBxfpo8l58bAB/i2RvMDG1iVGrwtw3MB2ciCwPkjaFVsz
         DcSlNaLQKlkvyUdoGArlVKmoGNShlzTQBNexd7jWZCnOxaN/ACePxE5X5EHIdrmCWk2I
         r4TooBMFYyR2dgGr9RgyV8V7JDdBqbCCHlol/APQ9Z2uParGT/Wx7qEZF13vgI4++kTo
         RTBw==
X-Gm-Message-State: APjAAAUgZUR0S0b2+hCwhHsR6L2qeD02NTZ8TMxAolYP7u8lP7RQRQ26
        10YbnMmtmJYQlfzFw/nJuR8NEvu9WDRPc0aRsOA9H2fXyYkXLEu6NtROACzZi6pr9dDI0hufwkC
        Rb02RoaMMwqD3
X-Received: by 2002:a0c:bf0b:: with SMTP id m11mr27364637qvi.63.1582227751605;
        Thu, 20 Feb 2020 11:42:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqwKuk7wTieLM4o7fqcn2TSW0l49y+86fqItcO0TBFs10lsZV4iD+Dyww8o2eLGGo7pQKjO5lg==
X-Received: by 2002:a0c:bf0b:: with SMTP id m11mr27364622qvi.63.1582227751345;
        Thu, 20 Feb 2020 11:42:31 -0800 (PST)
Received: from xz-x1 ([104.156.64.75])
        by smtp.gmail.com with ESMTPSA id v82sm330495qka.51.2020.02.20.11.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 11:42:30 -0800 (PST)
Date:   Thu, 20 Feb 2020 14:42:29 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jay Zhou <jianjay.zhou@huawei.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, wangxinxin.wang@huawei.com,
        weidong.huang@huawei.com, liu.jinsong@huawei.com
Subject: Re: [PATCH v2] KVM: x86: enable dirty log gradually in small chunks
Message-ID: <20200220194229.GB15253@xz-x1>
References: <20200220042828.27464-1-jianjay.zhou@huawei.com>
 <20200220191706.GF2905@xz-x1>
 <20200220192350.GG3972@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200220192350.GG3972@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 20, 2020 at 11:23:50AM -0800, Sean Christopherson wrote:
> On Thu, Feb 20, 2020 at 02:17:06PM -0500, Peter Xu wrote:
> > On Thu, Feb 20, 2020 at 12:28:28PM +0800, Jay Zhou wrote:
> > > @@ -3348,7 +3352,14 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
> > >  	switch (cap->cap) {
> > >  #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> > >  	case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2:
> > > -		if (cap->flags || (cap->args[0] & ~1))
> > > +		if (cap->flags ||
> > > +		    (cap->args[0] & ~KVM_DIRTY_LOG_MANUAL_CAPS) ||
> > > +		    /* The capability of KVM_DIRTY_LOG_INITIALLY_SET depends
> > > +		     * on KVM_DIRTY_LOG_MANUAL_PROTECT, it should not be
> > > +		     * set individually
> > > +		     */
> > > +		    ((cap->args[0] & KVM_DIRTY_LOG_MANUAL_CAPS) ==
> > > +			KVM_DIRTY_LOG_INITIALLY_SET))
> > 
> > How about something easier to read? :)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 70f03ce0e5c1..9dfbab2a9929 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -3348,7 +3348,10 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
> >         switch (cap->cap) {
> >  #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> >         case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2:
> > -               if (cap->flags || (cap->args[0] & ~1))
> > +               if (cap->flags || (cap->args[0] & ~3))
> > +                       return -EINVAL;
> > +               /* Allow 00, 01, and 11. */
> > +               if (cap->args[0] == KVM_DIRTY_LOG_INITIALLY_SET)
> >                         return -EINVAL;
> 
> Oof, "easier" is subjective :-)  How about this?
> 
> 	case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2: {
> 		u64 allowed_options = KVM_DIRTY_LOG_MANUAL_PROTECT;
> 
> 		if (cap->args[0] & KVM_DIRTY_LOG_MANUAL_PROTECT)
> 			allowed_options = KVM_DIRTY_LOG_INITIALLY_SET;
> 
> 		if (cap->flags || (cap->args[0] & ~allowed_options))
> 			return -EINVAL;
> 		kvm->manual_dirty_log_protect = cap->args[0];
> 		return 0;
> 	}

Fine by me! (But I won't tell I still prefer mine ;)

-- 
Peter Xu

