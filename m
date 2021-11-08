Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A73449E6D
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 22:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240600AbhKHVuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 16:50:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240590AbhKHVuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 16:50:06 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E1CC061714
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 13:47:21 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id u17so17014969plg.9
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 13:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8OQO6oRB/v20IjJtN8MTHcPwmaehnBhTjwZgesS0aJY=;
        b=q6+qt/2BIu8EOetYFoVHhDEyDdQV5s5qCX6YiuC30r8DgJ6jp0cGVWpCVSBDp6FVrN
         DPmmsshVYG2M97Zge1+5CAEVDRevaII7/Izdyz8QFCNob9ujrGau4qaAs9t7SVQWE6Dd
         bRWa1JQStU62M690RZ+Mrb48gqKAXaortZWbW4WHA9E7Y+uTs6Pf48VPmF+Dl2b0KOnB
         ZhwzS2Me591HXVrEL9HZeC17vGRR3nzggzOkwEGrLq3csDMyLp3YHCJn+69Ius93F53W
         pUtkyRRgyXzyCBTq4XOG9xHxfsgpSr7ojcFl6T7Du133m5DwDGxuY+pkiurd8fwZaaX+
         pxHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8OQO6oRB/v20IjJtN8MTHcPwmaehnBhTjwZgesS0aJY=;
        b=ZOZgbD3ykm0d0sWHs9qRttnsoMjDtoOCLmXE2+ZwKFVbVRokz0Oqu+RW2j5Q/XEx0s
         S/oxurqb+fjiH1qgl9PFqFPqEEJKddohhh+LanEaQuYjALm8cFBCS+KeLR8cVdaOuFJY
         7MDmEUePfTu7KKzFdgEM6lJVGNgTbM1K96NjNaXJ8lh6pvZ6uSWsB2nKynUq3dk1uqJ9
         Y6mdM89ZdGVNbu4jgfBal2/mbtc4SifhndNvS3INlpZzM+eiPqcdSWR6F8gqUebyvsHC
         DnPaI7sdXbQU8Gi3iBkVsVN7uLYOQxiKBmJsZQEWxrTTvdArjyge5DZxgmMWU9oGcB02
         Oetw==
X-Gm-Message-State: AOAM533YvL1KYyT+wLFSVTlGcjtjeaAdY9FnnsswAC6fTLfKEUQWDFjT
        jXNSMhEAfZeRGST3kLvyqFATLw==
X-Google-Smtp-Source: ABdhPJwEhyhfbeC/MNHqCWtg/FR+dr4b6RB3Mk6EDI6kjGv1xiTbmOpK8qZ+COSs0BLK3/7bdPcIQQ==
X-Received: by 2002:a17:90a:9295:: with SMTP id n21mr1568891pjo.229.1636408040857;
        Mon, 08 Nov 2021 13:47:20 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u13sm13170875pga.92.2021.11.08.13.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 13:47:20 -0800 (PST)
Date:   Mon, 8 Nov 2021 21:47:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suleiman Souhlal <suleiman@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHV2 3/3] KVM: x86: add KVM_SET_MMU_PREFETCH ioctl
Message-ID: <YYma5O/sifPa9FK9@google.com>
References: <20211019153214.109519-1-senozhatsky@chromium.org>
 <20211019153214.109519-4-senozhatsky@chromium.org>
 <YW7mXF9DNLk4fVkQ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YW7mXF9DNLk4fVkQ@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021, Sergey Senozhatsky wrote:
> On (21/10/20 00:32), Sergey Senozhatsky wrote:
> >  static int kvm_vm_ioctl_get_clock(struct kvm *kvm, void __user *argp)
> >  {
> >  	struct kvm_clock_data data;
> > @@ -6169,6 +6189,15 @@ long kvm_arch_vm_ioctl(struct file *filp,
> >  	case KVM_X86_SET_MSR_FILTER:
> >  		r = kvm_vm_ioctl_set_msr_filter(kvm, argp);
> >  		break;
> > +	case KVM_SET_MMU_PREFETCH: {
> > +		u64 val;
> > +
> > +		r = -EFAULT;
> > +		if (copy_from_user(&val, argp, sizeof(val)))
> > +			goto out;
> > +		r = kvm_arch_mmu_pte_prefetch(kvm, val);
> > +		break;
> > +	}
> 
> A side question: is there any value in turning this into a per-VCPU ioctl?
> So that, say, on heterogeneous systems big cores can prefetch more than
> little cores, for instance.

I don't think so?  If anything, such behavior should probably be tied to the pCPU,
not vCPU.  Though I'm guessing the difference in optimal prefetch size between big
and little cores is in the noise.

I suspect the optimal prefetch size is more dependent on the guest workload than
the core its running on.  There's likely a correlation between the core size and
the workload, but for that to have any meaning the vCPU would have be affined to
a core (or set of cores), i.e having the behavior tied to the pCPU as opposed to
the vCPU would work just as well.

If the optimal setting is based on the speed of the core, not the workload, then
per-pCPU is again preferable as it "works" regardless of vCPU affinity.
