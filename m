Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9A2674704
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 00:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjASXO1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 18:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjASXNq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 18:13:46 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740C03590
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 15:11:34 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id 12so1009491plo.3
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 15:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HeBX4hWuJsaHps7UYjGH1TLVfHHQaTbbfoKxw9Fb+mk=;
        b=OzyQ7BOijAJL49Qa36dbhVv6eDsyXYSJbiPEeGykSdviurgBNnPy1lh9Z1cSkdN3GB
         ohFFD4yRz/wNITkF4KCvnuk+OpQ72jgmquCsDnsE0mJTm/ClkmVB3FgeI1pWicBRjQCY
         0ZnR3mT5AAfHNPydbkRqFIQdFgSbJOosa+hEaeywKuQs8h5TDSut5looUG85PQw+v8Fb
         4B/L7qJbD5eXmq+xx49TOZo2Z0dmJq4VwEVgYSvGu59c7m8ZBWD2JCoIcrhZjslDZZZd
         YXuLnu2kIVOjncMEJlJZlHgjlutcCkM5dDRWKfWCzRomr9OY2brVpqr1VawGLmwKOxsq
         oh3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HeBX4hWuJsaHps7UYjGH1TLVfHHQaTbbfoKxw9Fb+mk=;
        b=sWJ3957O8swkA9Rze/tUIIib+eWwFuWeDuofQ+5cBPx8dfHdQk37heXV19ths4DeFp
         upey5wPP1Gqv3Oh1OFt3/1HEoWaXWllmEzxKe1CpkCcHL99HwmQG2WNLtI2Vs1F+ZH1h
         zkPLSrjpdqFZr0biFrus4bhNJQaTQHY4vGuuKYSE8joOf7dRPST6NJiWK+nJ6UPFa3QU
         cQq/QrZuIEge1WjxBWuY/US027hUvFOMzmVJt1aKeSXjuPcQ72imkXm6KuSAVLgL6c33
         vXXxUeU38tb732NBpn4Ngk5YTOhAotv35qKvoGYmuCBdbVMX/86vzoa1gdYgsN6rrcso
         CdLw==
X-Gm-Message-State: AFqh2kpiMqqqBEne3CrFqsb0WYmS/l0pWb1vYTVMrBELm4GF6O/S7vQe
        jXQwvy/tgRhP1VXq/DudXCJWjg==
X-Google-Smtp-Source: AMrXdXufbHO0WUsXs3R5noeo8Wk9F9L4vR8i9iFK9wPdVllQ8vFaN9HlHKx2/e44IIYuEjKEqE1Phg==
X-Received: by 2002:a17:902:c947:b0:191:1543:6b2f with SMTP id i7-20020a170902c94700b0019115436b2fmr18994pla.3.1674169893768;
        Thu, 19 Jan 2023 15:11:33 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u9-20020a170903124900b00174c1855cd9sm25575902plh.267.2023.01.19.15.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 15:11:33 -0800 (PST)
Date:   Thu, 19 Jan 2023 23:11:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "dmatlack@google.com" <dmatlack@google.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Message-ID: <Y8nOIjkskcXAi00V@google.com>
References: <20230114111621.00001840@gmail.com>
 <Y8bFCb+rs25dKcMY@google.com>
 <20230117214414.00003229@gmail.com>
 <Y8cLcY12zDWqO8nd@google.com>
 <Y8cMnjHFNIFaoX27@google.com>
 <eadc4a4e37ea0b04b8348395244b792bd34a762d.camel@intel.com>
 <Y8ljwsrrBBdh1aYw@google.com>
 <02b0e551647beed9ec3a2fefd3b659eb52c4846c.camel@intel.com>
 <Y8m34OEVBfL7Q4Ns@google.com>
 <38f506575caacd5488f73315b231c3282f893d46.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38f506575caacd5488f73315b231c3282f893d46.camel@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 19, 2023, Huang, Kai wrote:
> On Thu, 2023-01-19 at 21:36 +0000, Sean Christopherson wrote:
> > On Thu, Jan 19, 2023, Huang, Kai wrote:
> > > On Thu, 2023-01-19 at 15:37 +0000, Sean Christopherson wrote:
> > > > On Thu, Jan 19, 2023, Huang, Kai wrote:
> > > > > On Tue, 2023-01-17 at 21:01 +0000, Sean Christopherson wrote:
> > > > > > On Tue, Jan 17, 2023, Sean Christopherson wrote:
> > > > > > > On Tue, Jan 17, 2023, Zhi Wang wrote:
> > > > > > Oh, the other important piece I forgot to mention is that dropping mmu_lock deep
> > > > > > in KVM's MMU in order to wait isn't always an option.  Most flows would play nice
> > > > > > with dropping mmu_lock and sleeping, but some paths, e.g. from the mmu_notifier,
> > > > > > (conditionally) disallow sleeping.
> > > > > 
> > > > > Could we do something similar to tdp_mmu_iter_cond_resched() but not simple busy
> > > > > retrying "X times",  at least at those paths that can release mmu_lock()?
> > > > 
> > > > That's effectively what happens by unwinding up the stak with an error code.
> > > > Eventually the page fault handler will get the error and retry the guest.
> > > > 
> > > > > Basically we treat TDX_OPERAND_BUSY as seamcall_needbreak(), similar to
> > > > > rwlock_needbreak().  I haven't thought about details though.
> > > > 
> > > > I am strongly opposed to that approach.  I do not want to pollute KVM's MMU code
> > > > with a bunch of retry logic and error handling just because the TDX module is
> > > > ultra paranoid and hostile to hypervisors.
> > > 
> > > Right.  But IIUC there's legal cases that SEPT SEAMCALL can return BUSY due to
> > > multiple threads trying to read/modify SEPT simultaneously in case of TDP MMU. 
> > > For instance, parallel page faults on different vcpus on private pages.  I
> > > believe this is the main reason to retry.
> > 
> > Um, crud.  I think there's a bigger issue.  KVM always operates on its copy of the
> > S-EPT tables and assumes the the real S-EPT tables will always be synchronized with
> > KVM's mirror.  That assumption doesn't hold true without serializing SEAMCALLs in
> > some way.  E.g. if a SPTE is zapped and mapped at the same time, we can end up with:
> > 
> >   vCPU0                      vCPU1
> >   =====                      =====
> >   mirror[x] = xyz
> >                              old_spte = mirror[x]
> >                              mirror[x] = REMOVED_SPTE
> >                              sept[x] = REMOVED_SPTE
> >   sept[x] = xyz
> 
> IIUC this case cannot happen, as the two steps in the vcpu0 are within read
> lock, which prevents from vcpu1, which holds the write lock during zapping SPTE.

Zapping SPTEs can happen while holding mmu_lock for read, e.g. see the bug fixed
by commit 21a36ac6b6c7 ("KVM: x86/mmu: Re-check under lock that TDP MMU SP hugepage
is disallowed").
