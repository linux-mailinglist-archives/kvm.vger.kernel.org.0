Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9281ADE03
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 15:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbgDQNIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 09:08:09 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46647 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729799AbgDQNIJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 09:08:09 -0400
Received: by mail-wr1-f65.google.com with SMTP id f13so2927887wrm.13;
        Fri, 17 Apr 2020 06:08:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0xitfCt44NpX/zHg++7+cxiDZSUTq6AViagZQ7XxH/s=;
        b=pr9CMS5OwOqhVyHaSZUkRHuEtNa8enP6P9K8IhmKFc1K75ZSMGx8i2hIkW6+Gd5CWZ
         fr6OAA20RMnKlQWqG0rsqEvQYV66SQ4LhW0Wf2bhxI/5sLOuizcTIN1qroj09Y1bCC8p
         8Trve533y6o+9FTNBFXFsjtWoli8i6qd8skjozY7KwmMPy2wzYjCH0qcIV2lj8HiwOzM
         0MqWpW4YtqcWoC69TYdxJSpR3ghZ/HBwmKD44Xg9LFzNxKeOY2Ilzu4tvUcMO6URVA2m
         1mTqhcdNUHZL93jnVKs0IGIXecEBg2fwkajS31ioOAhURZAsNpIXhxB1VAe/SbFc2Itz
         l3SA==
X-Gm-Message-State: AGi0PuYUZDPFYvBfqnbebgMbGRYj6toOMbMCzG5xcaREkny2CNAQBKPs
        mktCALCOsRqCubri7pAVb/ZCochg
X-Google-Smtp-Source: APiQypIti7bfzNiuiDl5ZIOJ90yq2LCbDxv2TSX7eAGxppwiDKE+l+L9K/O8MI3/qNMS9Ht1k90zzw==
X-Received: by 2002:adf:f5c4:: with SMTP id k4mr3832796wrp.294.1587128886968;
        Fri, 17 Apr 2020 06:08:06 -0700 (PDT)
Received: from debian (44.142.6.51.dyn.plus.net. [51.6.142.44])
        by smtp.gmail.com with ESMTPSA id a7sm15244713wrs.61.2020.04.17.06.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 06:08:06 -0700 (PDT)
Date:   Fri, 17 Apr 2020 14:08:03 +0100
From:   Wei Liu <wei.liu@kernel.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        bp@alien8.de, haiyangz@microsoft.com, hpa@zytor.com,
        kys@microsoft.com, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        sthemmin@microsoft.com, tglx@linutronix.de, x86@kernel.org,
        mikelley@microsoft.com, kvm@vger.kernel.org
Subject: Re: [PATCH] x86/hyperv: Suspend/resume the VP assist page for
 hibernation
Message-ID: <20200417130803.ci2orezcrb64z64m@debian>
References: <1587104999-28927-1-git-send-email-decui@microsoft.com>
 <87blnqv389.fsf@vitty.brq.redhat.com>
 <20200417105558.2jkqq2lih6vvoip2@debian>
 <87wo6etj39.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wo6etj39.fsf@vitty.brq.redhat.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 17, 2020 at 02:03:38PM +0200, Vitaly Kuznetsov wrote:
> Wei Liu <wei.liu@kernel.org> writes:
> 
> > On Fri, Apr 17, 2020 at 12:03:18PM +0200, Vitaly Kuznetsov wrote:
> >> Dexuan Cui <decui@microsoft.com> writes:
> >> 
> >> > Unlike the other CPUs, CPU0 is never offlined during hibernation. So in the
> >> > resume path, the "new" kernel's VP assist page is not suspended (i.e.
> >> > disabled), and later when we jump to the "old" kernel, the page is not
> >> > properly re-enabled for CPU0 with the allocated page from the old kernel.
> >> >
> >> > So far, the VP assist page is only used by hv_apic_eoi_write().
> >> 
> >> No, not only for that ('git grep hv_get_vp_assist_page')
> >> 
> >> KVM on Hyper-V also needs VP assist page to use Enlightened VMCS. In
> >> particular, Enlightened VMPTR is written there.
> >> 
> >> This makes me wonder: how does hibernation work with KVM in case we use
> >> Enlightened VMCS and we have VMs running? We need to make sure VP Assist
> >> page content is preserved.
> >
> > The page itself is preserved, isn't it?
> >
> 
> Right, unlike hyperv_pcpu_input_arg is is not freed.
> 
> > hv_cpu_die never frees the vp_assit page. It merely disables it.
> > hv_cpu_init only allocates a new page if necessary.
> 
> I'm not really sure that Hyper-V will like us when we disable VP Assist
> page and have an active L2 guest using Enlightened VMCS, who knows what
> it caches and when. I'll try to at least test if/how it works.
> 

I'm curious to know that as well. :-)

> This all is not really related to Dexuan's patch)

Right.

Wei.

> 
> -- 
> Vitaly
> 
