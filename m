Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982AC487FEB
	for <lists+kvm@lfdr.de>; Sat,  8 Jan 2022 01:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiAHA0h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 19:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiAHA0h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 19:26:37 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E260CC061574
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 16:26:36 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso8334295pjb.1
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 16:26:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oN9IoclmlzNbuDTb2TmdBSrHPAIluEwiJU3uJynIdUA=;
        b=VkFIh9vkyXAFHBiwc5bl269FHHlk/+KAWjO5ffZB5R22Jf73oh7q4SNdh0gXmmScwK
         f/NI4Thh6P8ROPhBeu0TuYJ/EFcHQNhp9lGZwcMWInogW3GFtLAjJCcakfiIDk478/Q/
         UMNJ4Fybq45SgIK25vPI1YJbn6XmpacoFe5zTBB1/x6ef/Ml8CrLywBvpIjhp26H5n3/
         7QkLbwUENWqJgZNkXzy22f0x1Ja3k5qmKfZEYaIc3cU2oJ87BrCJF+2Lxv2FwmigCy1s
         f41E8mXn200YKOa/7vPF5547ZqKkOhu4lU6MkekNmx6skcAFEXseCp0RbP2fJtnev008
         DBKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oN9IoclmlzNbuDTb2TmdBSrHPAIluEwiJU3uJynIdUA=;
        b=WBGluRaInp4ZMHdgpXkgDGpdRLK1loZ7UAa0jlpZO7r5kcIFeXgrrewBFUS35y+eWq
         +ZZD17odC960Et8lvd0jFsIjKSbqdma8v4p1GVaQwjhQMRmG88zFV3SkUz6iU/5rzdOx
         NAr+2IoRFUuncxY7C5YU6FRiVd91OKJ4hSM5GyDZayLTYLLF7t45NgXKQ6dMXu3f5bL7
         65oYHKpR9IfoTVXg80oHox/HH5v6RfiiDqVCgHKANh3C2PJL0MtUShpWsPlbzZGs5nkw
         wKP2w9nJd8ie5a4KiIT5YdlLJFtAJVD4BtsvjY11hzbu7f0Z9vKCwb/8OwSj0BAY0wDH
         qg3w==
X-Gm-Message-State: AOAM530bHtp26HOqsCidTdiI7vkkLrOES9pOXFqgOyInHHKvfZk1kYhc
        QYs2nRQ/A+5o2/SjqSuAauKojw==
X-Google-Smtp-Source: ABdhPJyVQBOwsnjvsD88a0yJhZPvtEQpLbuYLYiJFidhNM8306m5l/cKlCecpMu57fL/DFol/tQBeA==
X-Received: by 2002:a17:902:bc88:b0:149:2032:6bcf with SMTP id bb8-20020a170902bc8800b0014920326bcfmr64950128plb.44.1641601596310;
        Fri, 07 Jan 2022 16:26:36 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o13sm45091pjq.23.2022.01.07.16.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 16:26:35 -0800 (PST)
Date:   Sat, 8 Jan 2022 00:26:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v6 0/6] x86/xen: Add in-kernel Xen event channel delivery
Message-ID: <YdjaOIymuiRhXUeT@google.com>
References: <20211210163625.2886-1-dwmw2@infradead.org>
 <33f3a978-ae3b-21de-b184-e3e4cd1dd4e3@redhat.com>
 <a727e8ae9f1e35330b3e2cad49782d0b352bee1c.camel@infradead.org>
 <e2ed79e6-612a-44a3-d77b-297135849656@redhat.com>
 <YcTpJ369cRBN4W93@google.com>
 <daeba2e20c50bbede7fbe32c4f3c0aed7091382e.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daeba2e20c50bbede7fbe32c4f3c0aed7091382e.camel@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Peter

On Wed, Jan 05, 2022, David Woodhouse wrote:
> On Thu, 2021-12-23 at 21:24 +0000, Sean Christopherson wrote:
> > Commit e880c6ea55b9 ("KVM: x86: hyper-v: Prevent using not-yet-updated TSC page
> > by secondary CPUs") is squarely to blame as it was added after dirty ring, though
> > in Vitaly's defense, David put it best: "That's a fairly awful bear trap".
> 
> Even with the WARN to keep us honest, this is still awful.
> 
> We have kvm_vcpu_write_guest()... but the vcpu we pass it is ignored
> and only vcpu->kvm is used. But you have to be running on a physical
> CPU which currently owns *a* vCPU of that KVM, or you might crash.
> 
> There is also kvm_write_guest() which doesn't take a vCPU as an
> argument, and looks for all the world like it was designed for you not
> to need one... but which still needs there to be a vCPU or it might
> crash.
> 
> I think I want to kill the latter, make the former use the vCPU it's
> given, add a spinlock to the dirty ring which will be uncontended
> anyway in the common case so it shouldn't hurt (?),

IIRC, Peter did a fair amount of performance testing and analysis that led to
the current behavior.

> and then let people use kvm->vcpu[0] when they really need to, with a
> documented caveat that when there are *no* vCPUs in a KVM, dirty tracking
> might not work.  Which is fine, as migration of a KVM that hasn't been fully
> set up yet is silly.

"when they really need to" can be a slippery slope, using vcpu[0] is also quite
gross.  Though I 100% agree that always using kvm_get_running_vcpu() is awful.

