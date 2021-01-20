Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABB12FCB5D
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 08:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbhATHPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 02:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbhATHOi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 02:14:38 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A47BC0613CF
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 23:13:57 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id w14so4903048pfi.2
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 23:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TTV6nYqcO5XSWys9zWm8wnK0Pv6PThaQer4+oGm8NGU=;
        b=HIc1eaI5kMbParlqoxUe710DEIElJcljsyDbh1ppcnKJbXKV202dwYfKtT37vYEsJd
         Igzd1+h2pYuRhJQincqk99FJ7Oi0Wm9IdIVFJ++zyiGx10XzKtS66jPCa7AxoVZejV2c
         hURdb8ummwjbEbDuaQonFCLiiarN8aM8f0PmyI6fka/dVXK6rZWjpLBAs6H340vKVaCM
         k7zNarmhmjrPX/jP+fmDQnR71WNX7fB8drCbiPH45F+dbEWVt+u6DIFOwR0CzZtXFah6
         5gHgWAQ0EhY5hXY/+S3ovR79cyKl37oyqvG6K/KYsz8LzYyDSEyhL3ZxSK3FAohzXA2j
         mG9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TTV6nYqcO5XSWys9zWm8wnK0Pv6PThaQer4+oGm8NGU=;
        b=JG21/UgQRba56mgyj9IuLRc7Bm6GfkXGHrhpYcRL2sB22tlBplSVp1zsW8wpvMcauB
         aZOMKlY719Cew2fkEm9ViQxcLyyA2huT1g15S10kMvDeow5flyjEZD/SizqMgq6+Cssd
         /MompRgslx8QKkrsxPbSMwFu8j9roatyIMKTuBAgZYys+IYfU6olgPC52WN76cvMDTFl
         z6g7aujKdyTEcFCfS6Rxw2nsz0uIfu1NDkp1D+HWeKS5Fgqn1p3UFqRgJ7Zib5R6amsi
         /jA0La5keQHEqS2rM+OXWTOTZfkfIgSGcZtnn9ZOhGG+xuDj5XT8ZkHlfPqP8nd58zCU
         R0hA==
X-Gm-Message-State: AOAM530Ju/+INzGx9GDH9x26yCilxRwoLcjCH62s4bEDHmrLOCihmSu2
        /mAq3N22/BNED7lOynZm+MBiOQ==
X-Google-Smtp-Source: ABdhPJxHfFS1B6tK3MqL4kaKYCFF1Y97lLLSpKRO8uCedQfY23jSDGtFL2myXiH+FWRM43uZ4XW4wg==
X-Received: by 2002:a65:4983:: with SMTP id r3mr8245442pgs.288.1611126836639;
        Tue, 19 Jan 2021 23:13:56 -0800 (PST)
Received: from google.com ([2620:0:1008:10:1ea0:b8ff:fe75:b885])
        by smtp.gmail.com with ESMTPSA id bt8sm6171170pjb.0.2021.01.19.23.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 23:13:55 -0800 (PST)
Date:   Tue, 19 Jan 2021 23:13:51 -0800
From:   Vipin Sharma <vipinsh@google.com>
To:     Tejun Heo <tj@kernel.org>
Cc:     thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com,
        eric.vantassell@amd.com, pbonzini@redhat.com, seanjc@google.com,
        lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, corbet@lwn.net, joro@8bytes.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        gingell@google.com, rientjes@google.com, dionnaglaze@google.com,
        kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Message-ID: <YAfYL7V6E4/P83Mg@google.com>
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-2-vipinsh@google.com>
 <YAICLR8PBXxAcOMz@mtj.duckdns.org>
 <YAIUwGUPDmYfUm/a@google.com>
 <YAJg5MB/Qn5dRqmu@mtj.duckdns.org>
 <YAJsUyH2zspZxF2S@google.com>
 <YAb//EYCkZ7wnl6D@mtj.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAb//EYCkZ7wnl6D@mtj.duckdns.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 19, 2021 at 10:51:24AM -0500, Tejun Heo wrote:
> Hello,
> 
> On Fri, Jan 15, 2021 at 08:32:19PM -0800, Vipin Sharma wrote:
> > SEV-ES has stronger memory encryption gurantees compared to SEV, apart
> > from encrypting the application memory it also encrypts register state
> > among other things. In a single host ASIDs can be distributed between
> > these two types by BIOS settings.
> > 
> > Currently, Google Cloud has Confidential VM machines offering using SEV.
> > ASIDs are not compatible between SEV and SEV-ES, so a VM running on SEV
> > cannot run on SEV-ES and vice versa
> > 
> > There are use cases for both types of VMs getting used in future.
> 
> Can you please elaborate? I skimmed through the amd manual and it seemed to
> say that SEV-ES ASIDs are superset of SEV but !SEV-ES ASIDs. What's the use
> case for mixing those two?

For example, customers can be given options for which kind of protection they
want to choose for their workloads based on factors like data protection
requirement, cost, speed, etc.

In terms of features SEV-ES is superset of SEV but that doesn't mean SEV
ASIDs are superset of SEV ASIDs. SEV ASIDs cannot be used for SEV-ES VMs
and similarly SEV-ES ASIDs cannot be used for SEV VMs. Once a system is
booted, based on the BIOS settings each type will have their own
capacity and that number cannot be changed until the next boot and BIOS
changes.

We are not mixing the two types of ASIDs, they are separate and used
separately.

> 
> > > > > > Other ID types can be easily added in the controller in the same way.
> > > > > 
> > > > > I'm not sure this is necessarily a good thing.
> > > > 
> > > > This is to just say that when Intel and PowerPC changes are ready it
> > > > won't be difficult for them to add their controller.
> > > 
> > > I'm not really enthused about having per-hardware-type control knobs. None
> > > of other controllers behave that way. Unless it can be abstracted into
> > > something common, I'm likely to object.
> > 
> > There was a discussion in Patch v1 and consensus was to have individual
> > files because it makes kernel implementation extremely simple.
> > 
> > https://lore.kernel.org/lkml/alpine.DEB.2.23.453.2011131615510.333518@chino.kir.corp.google.com/#t
> 
> I'm very reluctant to ack vendor specific interfaces for a few reasons but
> most importantly because they usually indicate abstraction and/or the
> underlying feature not being sufficiently developed and they tend to become
> baggages after a while. So, here are my suggestions:

My first patch was only for SEV, but soon we got comments that this can
be abstracted and used by TDX and SEID for their use cases.

I see this patch as providing an abstraction for simple accounting of
resources used for creating secure execution contexts. Here, secure
execution is achieved through different means. SEID, TDX, and SEV
provide security using different features and capabilities. I am not
sure if we will reach a point where all three and other vendors will use
the same approach and technology for this purpose.

Instead of each one coming up with their own resource tracking for their
features, this patch is providing a common framework and cgroup for
tracking these resources.

> 
> * If there can be a shared abstraction which hopefully makes intuitive
>   sense, that'd be ideal. It doesn't have to be one knob but it shouldn't be
>   something arbitrary to specific vendors.

I think we should see these as features provided on a host. Tasks can
be executed securely on a host with the guarantees provided by the
specific feature (SEV, SEV-ES, TDX, SEID) used by the task.

I don't think each H/W vendor can agree to a common set of security
guarantees and approach.

> 
> * If we aren't there yet and vendor-specific interface is a must, attach
>   that part to an interface which is already vendor-aware.
Sorry, I don't understand this approach. Can you please give more
details about it?

Thanks
Vipin
