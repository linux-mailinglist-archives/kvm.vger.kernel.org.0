Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDCF4C4C1A
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 18:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243707AbiBYR2O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 12:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242345AbiBYR1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 12:27:55 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542EC282
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 09:27:21 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id t14so2286338pgr.3
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 09:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TgKDtZ0bO8Y1fwYCzfXljiMJckMItSBZo7l3LM6GcOc=;
        b=a9Yn4qGa/0rCSNK1Vp7W+un1EJY8IPeLKL8wa4ZD4UES6xu5vLuBnU2FdJ8hR5SAd6
         GxywGakYCPIygiwGZpIPzNirfPASu6kHFUfptB542rAxCn7SH6CaB/YEXuAfGg82jjyH
         SUdkncrtGQvzP0xv3obSTxUVv5zxB+tzd0ZClAPzF53mxBkCFFo2G10o6TgAK+KE8VP/
         oxjBHWRRkBQ60MqBf5pbQ6DhGmwPvoVFvIGf7sugJuW95Tude7DTNDVt89hz4vP6InIW
         cyNHoMTN80adW1FwX0ADQprH4Z6AGA+SkqHmuyGFQgwfYgh+ODCVRig7mOfMHaxadCLF
         lXdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TgKDtZ0bO8Y1fwYCzfXljiMJckMItSBZo7l3LM6GcOc=;
        b=mpIWl/39nnOa6FW8d750YE2EZuZW6mJLOXGSxcjAOSCdyP7qtCN1bcX/ZoM9NM6r5G
         eN8YqdOUwf8WggeZHQW6sNMZpU041G0YRLjp7MHQucuwKlQSGdO3eZm7/8wjChYPzmDK
         ywOhRwZEyxc9odZQDoyDt/thOzXJSCX+KonkG+lgwOQP2vsM4B2qSo0j3g7uLl//gBOE
         Vd2kJfZVC3ODOrt8qo4As5u+GUDTPcG6kxV0sOnO17tskgOR+IPnfQHU71cml3DhW48P
         DSvkX7pwkas8k8ZRgLy8kShvMS5RC3BjaVETVLAgQ4TSom7X5eIIT0P4ESc3HrzEqYuj
         bNsA==
X-Gm-Message-State: AOAM533hjMUmONvxVHUC7soO1qUifvf2Ty3Oy1KFvkAD+eFJSG8pzB/o
        suHN4S5OYrFU6VeCohtDJhybLw==
X-Google-Smtp-Source: ABdhPJzDfKJptQd+IAjDEBgwX6SRfOPtxKZt935GDSKZl73taXkwubv64+BclmzHVuYstHfvSuglFg==
X-Received: by 2002:a63:5911:0:b0:36c:4394:5bfa with SMTP id n17-20020a635911000000b0036c43945bfamr6815295pgb.519.1645810040554;
        Fri, 25 Feb 2022 09:27:20 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 25-20020a631859000000b00373df766e76sm3145302pgy.16.2022.02.25.09.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 09:27:19 -0800 (PST)
Date:   Fri, 25 Feb 2022 17:27:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXTERNAL] [PATCH v2] KVM: Don't actually set a request when
 evicting vCPUs for GFN cache invd
Message-ID: <YhkRcK64Jya6YpA9@google.com>
References: <20220223165302.3205276-1-seanjc@google.com>
 <2547e9675d855449bc5cc7efb97251d6286a377c.camel@amazon.co.uk>
 <YhkAJ+nw2lCzRxsg@google.com>
 <915ddc7327585bbe8587b91b8cd208520d684db1.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <915ddc7327585bbe8587b91b8cd208520d684db1.camel@infradead.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022, David Woodhouse wrote:
> On Fri, 2022-02-25 at 16:13 +0000, Sean Christopherson wrote:
> > On Fri, Feb 25, 2022, Woodhouse, David wrote:
> > > Since we need an active vCPU context to do dirty logging (thanks, dirty
> > > ring)... and since any time vcpu_run exits to userspace for any reason
> > > might be the last time we ever get an active vCPU context... I think
> > > that kind of fundamentally means that we must flush dirty state to the
> > > log on *every* return to userspace, doesn't it?
> > 
> > I would rather add a variant of mark_page_dirty_in_slot() that takes a vCPU, which
> > we whould have in all cases.  I see no reason to require use of kvm_get_running_vcpu().
> 
> We already have kvm_vcpu_mark_page_dirty(), but it can't use just 'some
> vcpu' because the dirty ring is lockless. So if you're ever going to
> use anything other than kvm_get_running_vcpu() we need to add locks.

Heh, actually, scratch my previous comment.  I was going to respond that
kvm_get_running_vcpu() is mutually exclusive with all other ioctls() on the same
vCPU by virtue of vcpu->mutex, but I had forgotten that kvm_get_running_vcpu()
really should be "kvm_get_loaded_vcpu()".  I.e. as long as KVM is in a vCPU-ioctl
path, kvm_get_running_vcpu() will be non-null.

> And while we *could* do that, I don't think it would negate the
> fundamental observation that *any* time we return from vcpu_run to
> userspace, that could be the last time. Userspace might read the dirty
> log for the *last* time, and any internally-cached "oh, at some point
> we need to mark <this> page dirty" is lost because by the time the vCPU
> is finally destroyed, it's too late.

Hmm, isn't that an existing bug?  I think the correct fix would be to flush all
dirty vmcs12 pages to the memslot in vmx_get_nested_state().  Userspace _must_
invoke that if it wants to migrated a nested vCPU.

> I think I'm going to rip out the 'dirty' flag from the gfn_to_pfn_cache
> completely and add a function (to be called with an active vCPU
> context) which marks the page dirty *now*.

Hrm, something like?

  1. Drop @dirty from kvm_gfn_to_pfn_cache_init()
  2. Rename @dirty => @old_dirty in kvm_gfn_to_pfn_cache_refresh()
  3. Add an API to mark the associated slot dirty without unmapping

I think that makes sense.

> KVM_GUEST_USES_PFN users like nested VMX will be expected to do this
> before returning from vcpu_run anytime it's in L2 guest mode. 

As above, I think the correct thing to do is enlightent the flows that retrieve
the state being cached.
