Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659B2493F41
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 18:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356505AbiASRoo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 12:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356525AbiASRo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 12:44:27 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789DAC061746
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 09:44:27 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id t32so3260276pgm.7
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 09:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kjpCz81smuXlqDsUJ+xTPPyd2+p7TwFvzeJvK3dmbfc=;
        b=n4lk16/mQRQhzDlbYOkuxki1pIs9PLcw0+h7yTUJmpIoxgVgyxAx0MQzlCl/b2WvbZ
         1FuWNuWG6x6fP/YTzaGe739ddyJyBv2UF5vVIh5T4M26jGwotGP+KH6pym8y2k6wZZfJ
         9d8LlVoKSAIJRWa3ZYOgwcLYooJVdN4FoX6WqDBWRFm1wbJt6ec8dW62V7WOz5UYyzux
         TZ1Zsjji2JWeaIlpiCMCNMePlVxqA7rPpzmVe6W7LGw8+U2AsJ2KXja+Yfv+7TaTrGvk
         KrZtmD4UjOfclp6WIPKOGWTQJpMim6Z2fYAB0Dp+p5DCCpmrTibcyqu7kcyK6vHxSvil
         5YoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kjpCz81smuXlqDsUJ+xTPPyd2+p7TwFvzeJvK3dmbfc=;
        b=neFaRDuNJR+fVMGPkDR6Xv9oA7AbZwIXObocDEvWZI8MMxeWhUpz6qxD1qgdC5VxB7
         ZgBKerEm4jaQPVV6hochb9cdOJKIi8YGJX3MfKTvbgxrF2maJ99JBoJ7rEu238CQHn9Y
         ONw9BYyYnQb+c3yLhSHpxlojZdNE4HCFCsyKcyAcITpohJiy+pmlCnD/Sw8mp1kP7bal
         v4H6pkIZDgGc4Te3xZG8kczJf3AKRFxwNAaFW19BkgnLlOJ0sv2VbKOizqPGnYjutJzS
         XyRFuvZiwyy/hwK7VDY9g+oXyfN3u3Szy3EOook0X6B/UCw26XDIAaeRSQT70JX7fHap
         junA==
X-Gm-Message-State: AOAM533qHm/ycsU+ijufr+fpRdYPuuwgxaTDV8pDsdSwjaTsCaPYaH5C
        IG+HKh1lSxpdx+iWGzsflQZdOg==
X-Google-Smtp-Source: ABdhPJzUzHmOJnYs8prM/sBikO4z8Cc8PmVmEF8g+1QsVSMkjw673BlqB5V+t5p/weH7+J1vRGRE+g==
X-Received: by 2002:a63:3705:: with SMTP id e5mr27255386pga.258.1642614266722;
        Wed, 19 Jan 2022 09:44:26 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d20sm313134pfv.23.2022.01.19.09.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 09:44:26 -0800 (PST)
Date:   Wed, 19 Jan 2022 17:44:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
Subject: Re: [PATCH v6 0/6] x86/xen: Add in-kernel Xen event channel delivery
Message-ID: <YehN9pmMXy535+qS@google.com>
References: <33f3a978-ae3b-21de-b184-e3e4cd1dd4e3@redhat.com>
 <a727e8ae9f1e35330b3e2cad49782d0b352bee1c.camel@infradead.org>
 <e2ed79e6-612a-44a3-d77b-297135849656@redhat.com>
 <YcTpJ369cRBN4W93@google.com>
 <daeba2e20c50bbede7fbe32c4f3c0aed7091382e.camel@infradead.org>
 <YdjaOIymuiRhXUeT@google.com>
 <Yd5GlAKgh0L0ZQir@xz-m1.local>
 <791794474839b5bcad08b1282998d8a5cb47f0e5.camel@infradead.org>
 <cf2d56a2-2644-31f2-c2a5-07077c66243a@redhat.com>
 <37493a2c50389f7843308685f50a93201f1f39c5.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37493a2c50389f7843308685f50a93201f1f39c5.camel@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 19, 2022, David Woodhouse wrote:
> On Wed, 2022-01-19 at 18:36 +0100, Paolo Bonzini wrote:
> > On 1/19/22 09:14, David Woodhouse wrote:
> > > > Or do we have explicit other requirement that needs to dirty guest pages
> > > > without vcpu context at all?
> > > 
> > > Delivering interrupts may want to do so. That's the one we hit for
> > > S390, and I only avoided it for Xen event channel delivery on x86 by
> > > declaring that the Xen shared info page is exempt from dirty tracking
> > > and should*always*  be considered dirty.
> > 
> > We also have one that I just found out about in 
> > kvm_hv_invalidate_tsc_page, called from KVM_SET_CLOCK. :/

I think we can fix that usage though:

https://lore.kernel.org/all/YcTpJ369cRBN4W93@google.com

> > So either we have another special case to document for the dirty ring 
> > buffer (and retroactively so, even), or we're in bad need for a solution.
> 
> Seems like adding that warning is having precisely the desired effect :)

The WARN is certainly useful.  Part of me actually likes the restriction of needing
to have a valid vCPU, at least for x86, as there really aren't many legitimate cases
where KVM should be marking memory dirty without a vCPU.
