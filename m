Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA052F8B3C
	for <lists+kvm@lfdr.de>; Sat, 16 Jan 2021 05:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbhAPEdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 23:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729742AbhAPEdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 23:33:05 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05714C061795
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 20:32:24 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id z21so7332070pgj.4
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 20:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=78eb91iV6onC6q/hVFxGo4K1XPsW1qS27cVVQW2qr6s=;
        b=AhCJrurJWr5qakhtTFitP0L+ZLAyEUUdfmPca3QpxNzNGFZrZqXzwK7rGFldzEKG/g
         rJg/IJDxekMuO8bfkHTyYr74RzsMadcBKp3YR9g06tgDFSHtXj+chssKalfaIawkjxih
         BRVvlJPQYIvd4KdUAxAhR4o75d35icXrZB/EFP+iGbzySEycNsF4pX+FdJ9wg3SoTuE5
         rFtP8JHAXY+SgOM6dFnjOivvQw+GG6iyCeM1dcpiO6/ytRmGQmhhFtnGXUsk/g7/6di8
         Vd538ChRdWi0U4cRJs4gB1uu7Phm5CVMgdVGwZ8UBewEAtTIVAqqGMDPKErXtfOpnTpg
         SEvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=78eb91iV6onC6q/hVFxGo4K1XPsW1qS27cVVQW2qr6s=;
        b=g57p0CGhDd0vFL1jFxh9kNI9Ubo9oHQ3Pn6mXk3zqDhj9EH2iDEM8VGInocDc3bXVG
         ahXP0psA6EQq/nr7dbCQJIsz4kyjdP3xtctFyhq0NLOg006LkHS73/JoZvCWntk8N+0O
         NJ4MU+5pHp44vq3OuMqX4D8DoELV6PCI66/rYOyQzRuIjXTya/O1tUO+Hq0dZOpmIYBQ
         5hnHXiF43xyyXGBS20yCyNqNaT5MdvMy6e/VIYnv7u0MNGHRbSyeFFy2oWYzV6YvV6Cm
         Eg9bRXyVgbaGudnZr8Fptk8FPgGjvEEc52qnmUuN7joeQiCJnegtkCc1CRXvpp31N2Qx
         GzGg==
X-Gm-Message-State: AOAM532OHfaCCvZlxdqySBxea7WJ4tN+vqewM3kWJ9tVHG9gkFfTmUQk
        Gf7WhIfPYLQmeDPrVRMnBkClwg==
X-Google-Smtp-Source: ABdhPJyKP8sU4ECWM/iW0Xk589JXcKQYdttY9E5LYxNTDUNToqzSmjvyhu/nR8SzTobIC2lS6ErK0A==
X-Received: by 2002:a62:7d90:0:b029:19d:917b:6c65 with SMTP id y138-20020a627d900000b029019d917b6c65mr16224433pfc.28.1610771544088;
        Fri, 15 Jan 2021 20:32:24 -0800 (PST)
Received: from google.com ([2620:0:1008:10:1ea0:b8ff:fe75:b885])
        by smtp.gmail.com with ESMTPSA id a29sm9378348pfr.73.2021.01.15.20.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 20:32:23 -0800 (PST)
Date:   Fri, 15 Jan 2021 20:32:19 -0800
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
Message-ID: <YAJsUyH2zspZxF2S@google.com>
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-2-vipinsh@google.com>
 <YAICLR8PBXxAcOMz@mtj.duckdns.org>
 <YAIUwGUPDmYfUm/a@google.com>
 <YAJg5MB/Qn5dRqmu@mtj.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAJg5MB/Qn5dRqmu@mtj.duckdns.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 15, 2021 at 10:43:32PM -0500, Tejun Heo wrote:
> On Fri, Jan 15, 2021 at 02:18:40PM -0800, Vipin Sharma wrote:
> > > * Why is .sev a separate namespace? Isn't the controller supposed to cover
> > >   encryption ids across different implementations? It's not like multiple
> > >   types of IDs can be in use on the same machine, right?
> > > 
> > 
> > On AMD platform we have two types SEV and SEV-ES which can exists
> > simultaneously and they have their own quota.
> 
> Can you please give a brief explanation of the two and lay out a scenario
> where the two are being used / allocated disjointly?
> 

SEV-ES has stronger memory encryption gurantees compared to SEV, apart
from encrypting the application memory it also encrypts register state
among other things. In a single host ASIDs can be distributed between
these two types by BIOS settings.

Currently, Google Cloud has Confidential VM machines offering using SEV.
ASIDs are not compatible between SEV and SEV-ES, so a VM running on SEV
cannot run on SEV-ES and vice versa

There are use cases for both types of VMs getting used in future.

> > > > Other ID types can be easily added in the controller in the same way.
> > > 
> > > I'm not sure this is necessarily a good thing.
> > 
> > This is to just say that when Intel and PowerPC changes are ready it
> > won't be difficult for them to add their controller.
> 
> I'm not really enthused about having per-hardware-type control knobs. None
> of other controllers behave that way. Unless it can be abstracted into
> something common, I'm likely to object.

There was a discussion in Patch v1 and consensus was to have individual
files because it makes kernel implementation extremely simple.

https://lore.kernel.org/lkml/alpine.DEB.2.23.453.2011131615510.333518@chino.kir.corp.google.com/#t

> 
> > > > +static int enc_id_cg_stat_show(struct seq_file *sf, void *v)
> > > > +{
> > > > +	unsigned long flags;
> > > > +	enum encryption_id_type type = seq_cft(sf)->private;
> > > > +
> > > > +	spin_lock_irqsave(&enc_id_cg_lock, flags);
> > > > +
> > > > +	seq_printf(sf, "total %u\n", enc_id_capacity[type]);
> > > > +	seq_printf(sf, "used %u\n", root_cg.res[type].usage);
> > > 
> > > Dup with .current and no need to show total on every cgroup, right?
> > 
> > This is for the stat file which will only be seen in the root cgroup
> > directory.  It is to know overall picture for the resource, what is the
> > total capacity and what is the current usage. ".current" file is not
> > shown on the root cgroup.
> 
> Ah, missed the flags. It's odd for the usage to be presented in two
> different ways tho. I think it'd make more sense w/ cgroup.current at root
> level. Is the total number available somewhere else in the system?

This information is not available anywhere else in the system. Only
other way to get this value is to use CPUID instruction (0x8000001F) of
the processor. Which also has disdvantage if sev module in kernel
doesn't use all of the available ASIDs for its work (right now it uses
all) then there will be a mismatch between what user get through their
code and what is actually getting used in the kernel by sev.

In cgroup v2, I didn't see current files for other cgroups in root
folder that is why I didn't show that file in root folder.

Will you be fine if I show two files in the root, something like:

encids.sev.capacity
encids.sev.current

In non root folder, it will be:
encids.sev.max
encids.sev.current

I still prefer encids.sev.stat, as it won't repeat same information in
each cgroup but let me know what you think.

Thanks
