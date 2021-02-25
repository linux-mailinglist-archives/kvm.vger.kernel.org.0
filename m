Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5613249EA
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 05:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235285AbhBYE6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 23:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234831AbhBYE6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 23:58:22 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC8BC061756
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 20:57:42 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id u26so2811581pfn.6
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 20:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=GCPvH/ftBaPKrIrg1SrRaA28WOD5QZfwlnEHwgccJos=;
        b=qcnZZYCJi98bpluIA+Q6PbpZt/DTsw6UAEq6IRMRd1PNOsFM6BO9kPihfoQQQb87Rx
         fsrwNx3FnRYOVp90fuaDu9oOIAHKQZ5JRcw5J4/+z10kW3ty+3KpTL1AUzSuEpCF/9CX
         c2ODR7C0MZAeApvSVIMhXxFEE4oO34Tfc3p1nBRDx/buMluyiYYrdFtAv9BTvjIwkNuL
         P7AGSBh/JZKXRr05hZuaMm7Vp/wH9GiJkDriIApAxmnd3CcoDOrjpj0FWSALeojZv+P/
         0JAirMem5/JvDvQ14shHJRy+NVY7k2H+KT9Fep2BLYxsIHztz/JM1LZDgnAXK8U1qVJf
         fFAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=GCPvH/ftBaPKrIrg1SrRaA28WOD5QZfwlnEHwgccJos=;
        b=Zf+HjA0ml9Bb8oqwUT2ZDzRKCWHPmSv00lz8xrKan7rY9DZVF8P7d/TmbRJo2Xaqiv
         73vqHKPip+w19QhtO1d//obqmD0Wk7dR89fXtasUFT6c097TKQh5j5FrIh5fU2LW4v2o
         zIrLGdEPyi60u74t5Lsg4L3GbZAiALaLRTmlUcsp4pVUXOvTa9ytmlHXA551Gxj5FjLX
         1xkNET1oZtMklZYlXLd/YmrDmrd6+GhGUftum4mex7Z6DfFZpDwixUNdIFP4Taf32lI4
         yrRNffg9Yo3wpt6FG1TXJfzcLLntFPiLMp9+7HZbIJD/zVcZy5wpTB+P70xPq/DLCNBj
         9XjQ==
X-Gm-Message-State: AOAM531/+sqZ5sf6DFZCqeAXBTb+gIWx2V8+1kfANiu58UM1YjUIO6sF
        jc6TXVNmnxLbL9L+HoaVRP6jzA==
X-Google-Smtp-Source: ABdhPJzHz+X6qOY/Ap20Mg+cl6p/k3veTQ4izjUkq9XK8Lc2iDiGHMlEOejfq7dwuBVVLuLS+3zY+w==
X-Received: by 2002:aa7:9dd1:0:b029:1ed:bee2:c65e with SMTP id g17-20020aa79dd10000b02901edbee2c65emr1483923pfq.5.1614229061213;
        Wed, 24 Feb 2021 20:57:41 -0800 (PST)
Received: from google.com ([2620:0:1008:10:9474:84b:e7ae:d5fc])
        by smtp.gmail.com with ESMTPSA id v129sm4399042pfc.110.2021.02.24.20.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 20:57:40 -0800 (PST)
Date:   Wed, 24 Feb 2021 20:57:36 -0800
From:   Vipin Sharma <vipinsh@google.com>
To:     Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        thomas.lendacky@amd.com
Cc:     tj@kernel.org, brijesh.singh@amd.com, jon.grimm@amd.com,
        eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] cgroup: sev: Add misc cgroup controller
Message-ID: <YDcuQFMbe5MaatBe@google.com>
References: <20210218195549.1696769-1-vipinsh@google.com>
 <20210218195549.1696769-2-vipinsh@google.com>
 <YDVIdycgk8XL0Zgx@blackbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YDVIdycgk8XL0Zgx@blackbook>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 23, 2021 at 07:24:55PM +0100, Michal Koutný wrote:
> On Thu, Feb 18, 2021 at 11:55:48AM -0800, Vipin Sharma <vipinsh@google.com> wrote:
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > [...]
> > +#ifndef CONFIG_KVM_AMD_SEV
> > +/*
> > + * When this config is not defined, SEV feature is not supported and APIs in
> > + * this file are not used but this file still gets compiled into the KVM AMD
> > + * module.
> I'm not familiar with the layout of KVM/SEV compile targets but wouldn't
> it be simpler to exclude whole svm/sev.c when !CONFIG_KVM_AMD_SEV?
> 

Tom,
Is there any plan to exclude sev.c compilation if CONFIG_KVM_AMD_SEV is
not set?

> > +++ b/kernel/cgroup/misc.c
> > [...]
> > +/**
> > + * misc_cg_set_capacity() - Set the capacity of the misc cgroup res.
> > + * @type: Type of the misc res.
> > + * @capacity: Supported capacity of the misc res on the host.
> > + *
> > + * If capacity is 0 then the charging a misc cgroup fails for that type.
> > + *
> > + * The caller must serialize invocations on the same resource.
> > + *
> > + * Context: Process context.
> > + * Return:
> > + * * %0 - Successfully registered the capacity.
> > + * * %-EINVAL - If @type is invalid.
> > + * * %-EBUSY - If current usage is more than the capacity.
> When is this function supposed to be called? At boot only or is this
> meant for some kind of hot unplug functionality too?
> 

This function is meant for hot unplug functionality too.

> > +int misc_cg_try_charge(enum misc_res_type type, struct misc_cg **cg,
> > +		       unsigned int amount)
> > [...]
> > +		new_usage = atomic_add_return(amount, &res->usage);
> > +		if (new_usage > res->max ||
> > +		    new_usage > misc_res_capacity[type]) {
> > +			ret = -EBUSY;
> I'm not sure the user of this resource accounting will always be able to
> interpret EBUSY returned from depths of the subsystem.
> See what's done in pids controller in order to give some useful
> information about why operation failed.

Just to be on the same page are you talking about adding an events file
like in pids?

> 
> > +			goto err_charge;
> > +		}
> > +
> > +		// First one to charge gets a reference.
> > +		if (new_usage == amount)
> > +			css_get(&i->css);
> 1) Use the /* comment */ style.
> 2) You pin the whole path from task_cg up to root (on the first charge).
> That's unnecessary since children reference their parents.
> Also why do you get the reference only for the first charger? While it
> may work, it seems too convoluted to me.
> It'd be worth documenting what the caller can expect wrt to ref count of
> the returned misc_cg.

Suppose a user charges 5 resources in a single charge call but uncharges
them in 5 separate calls one by one. I cannot take reference on every
charge and put the reference for every uncharge as it is not guaranteed
to have equal number of charge-uncharge pairs and we will end up with
the wrong ref count.

However, if I take reference at the first charge and remove reference at
last uncharge then I can keep the ref count in correct sync.

I can rewrite if condition to (new_usage == amount && task_cg == i)
this will avoid pinning whole path up to the root. I was thinking that
original code was simpler, clearly I was wrong.

Thanks
Vipin
