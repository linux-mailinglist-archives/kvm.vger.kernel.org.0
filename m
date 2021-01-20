Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01C52FDE20
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 01:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbhAUAAD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 19:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404175AbhATXZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 18:25:53 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07597C06134D
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 15:18:34 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id b8so92644plx.0
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 15:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NCtWCoTo8mGZeKZotnt4ALec3dQ9/RkUFyVQNK1hMoE=;
        b=NxCvtTTZAcHUjY80B8T/mRXR+ecVc3j49+/cThAhgIMNldAXEiEac1XjdCqjwr8KNN
         EFQbyPbiLvLiFr1Vq5M65rOiTLar4w562qyOg8n7/djIcn6Sxvtl8sYS7yBydLTCmJwj
         yxEKsR57CQ+eeJ51w9m+qmBkxNhu7Y09Wb+SLUBApFhMZLl4DnWR65Ef/2e8jEJ9sL/n
         DKjbb0/eQQFSQ2OCj8ocfOhIQc6JKhcEmeGF0ld5PoaVuz+X1Zsyi2f5z+JyLv7b9gnL
         z7Lho8Yw+GVs7q6rC4siRdgOeOgUYyaDl/s+stRG1t72bs4JORMfYs6Z+x5fNBRiWJdM
         9vrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NCtWCoTo8mGZeKZotnt4ALec3dQ9/RkUFyVQNK1hMoE=;
        b=TK1gHjFG74XSaaCBczKfbNni8axNdZsycrO+HQd37u102jqMV6OeiRd0Cot+A41eci
         gHI86AUGk5tfwn1iFFziR6AdgQO4rNlZ/jeyxbNROMURH3lYlsqMcv8xxhb1Z9DZzQ6T
         toG3XVWHagjAzKIZ/Xo4MJ4XYIfUg8yCt2t71jFRa2xeHkqWEJX7v5NqZManaVQ1jNdk
         9DTxl4WC6ZF/C7JPWnp9ssRpXkHsq4K993dY9VZr0Z0BItFkAcolfDuteihcxxWnimmg
         fT3rpVpJbU4Gh5BvcyqMK7OJ6kpgBCnO8+Q7FhAYIjg951h6X4Sy9Fr/4c0IMGU30ALG
         M0MA==
X-Gm-Message-State: AOAM530/YbVvI7P28xDMtMDT6mEXspRiQU327JGH2iytlnX9SPxsmmHD
        d/yIsYJIHKLKCmH+Ps16JqNk4g==
X-Google-Smtp-Source: ABdhPJzRDE4htyk7QPEMj8bZl6yWXO0FHI8XTpLWG/UTk5Qh/OejVMbcJ8DFH0WSdBb2VwaCDk8sQg==
X-Received: by 2002:a17:902:f703:b029:de:9a3a:6902 with SMTP id h3-20020a170902f703b02900de9a3a6902mr11818514plo.68.1611184714108;
        Wed, 20 Jan 2021 15:18:34 -0800 (PST)
Received: from google.com ([2620:0:1008:10:1ea0:b8ff:fe75:b885])
        by smtp.gmail.com with ESMTPSA id k141sm1067449pfd.9.2021.01.20.15.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 15:18:33 -0800 (PST)
Date:   Wed, 20 Jan 2021 15:18:29 -0800
From:   Vipin Sharma <vipinsh@google.com>
To:     Tejun Heo <tj@kernel.org>
Cc:     thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com,
        eric.vantassell@amd.com, pbonzini@redhat.com, seanjc@google.com,
        hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        corbet@lwn.net, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Message-ID: <YAi6RcbxTSMmNssw@google.com>
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-2-vipinsh@google.com>
 <YAICLR8PBXxAcOMz@mtj.duckdns.org>
 <YAIUwGUPDmYfUm/a@google.com>
 <YAJg5MB/Qn5dRqmu@mtj.duckdns.org>
 <YAJsUyH2zspZxF2S@google.com>
 <YAb//EYCkZ7wnl6D@mtj.duckdns.org>
 <YAfYL7V6E4/P83Mg@google.com>
 <YAhc8khTUc2AFDcd@mtj.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAhc8khTUc2AFDcd@mtj.duckdns.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 20, 2021 at 11:40:18AM -0500, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jan 19, 2021 at 11:13:51PM -0800, Vipin Sharma wrote:
> > > Can you please elaborate? I skimmed through the amd manual and it seemed to
> > > say that SEV-ES ASIDs are superset of SEV but !SEV-ES ASIDs. What's the use
> > > case for mixing those two?
> > 
> > For example, customers can be given options for which kind of protection they
> > want to choose for their workloads based on factors like data protection
> > requirement, cost, speed, etc.
> 
> So, I'm looking for is a bit more in-depth analysis than that. ie. What's
> the downside of SEV && !SEV-ES and is the disticntion something inherently
> useful?

I will leave this for AMD folks to respond, as they can give much better
answer than me.

> > > I'm very reluctant to ack vendor specific interfaces for a few reasons but
> > > most importantly because they usually indicate abstraction and/or the
> > > underlying feature not being sufficiently developed and they tend to become
> > > baggages after a while. So, here are my suggestions:
> > 
> > My first patch was only for SEV, but soon we got comments that this can
> > be abstracted and used by TDX and SEID for their use cases.
> > 
> > I see this patch as providing an abstraction for simple accounting of
> > resources used for creating secure execution contexts. Here, secure
> > execution is achieved through different means. SEID, TDX, and SEV
> > provide security using different features and capabilities. I am not
> > sure if we will reach a point where all three and other vendors will use
> > the same approach and technology for this purpose.
> > 
> > Instead of each one coming up with their own resource tracking for their
> > features, this patch is providing a common framework and cgroup for
> > tracking these resources.
> 
> What's implemented is a shared place where similar things can be thrown in
> bu from user's perspective the underlying hardware feature isn't really
> abstracted. It's just exposing whatever hardware knobs there are. If you
> look at any other cgroup controllers, nothing is exposing this level of
> hardware dependent details and I'd really like to keep it that way.

RDMA cgroup expose hardware details to users. In rdma.{max, current}
interface files we can see actual hardware names. Only difference
compared to Encryption ID cgroup is that latter is exposing that detail
via file names.

Will you prefer that encryption ID cgroup do things similar to RDMA
cgroup? It can have 3 files
1. encids.capacity (only on root)
   Shows features (SEV, SEV-ES, TDX, SEID) available along with capacity
   on the host.
   $ cat encids.capacity
   sev 400
   sev-es 100

2. encids.max (only on non-root)
   Allows setting of the max value of a feature in the cgroup.
   It will only show max for features shown in the capacity file.
   $ cat encids.max
   sev max
   sev-es 100

3. encids.current (all levels)
   Shows total getting used in the cgroup and its descendants.
   $ cat encids.current
   sev 3
   sev-es 0

> 
> So, what I'm asking for is more in-depth analysis of the landscape and
> inherent differences among different vendor implementations to see whether
> there can be better approaches or we should just wait and see.
> 
> > > * If there can be a shared abstraction which hopefully makes intuitive
> > >   sense, that'd be ideal. It doesn't have to be one knob but it shouldn't be
> > >   something arbitrary to specific vendors.
> > 
> > I think we should see these as features provided on a host. Tasks can
> > be executed securely on a host with the guarantees provided by the
> > specific feature (SEV, SEV-ES, TDX, SEID) used by the task.
> > 
> > I don't think each H/W vendor can agree to a common set of security
> > guarantees and approach.
> 
> Do TDX and SEID have multiple key types tho?
To my limited knowledge I don't think so. I don't know their future
plans.

> 
> > > * If we aren't there yet and vendor-specific interface is a must, attach
> > >   that part to an interface which is already vendor-aware.
> > Sorry, I don't understand this approach. Can you please give more
> > details about it?
> 
> Attaching the interface to kvm side, most likely, instead of exposing the
> feature through cgroup.
I am little confused, do you mean moving files from the kernel/cgroup/
to kvm related directories or you are recommending not to use cgroup at
all?  I hope it is the former :)

Only issue with this is that TDX is not limited to KVM, they have
potential use cases for MKTME without KVM.

Thanks
Vipin
