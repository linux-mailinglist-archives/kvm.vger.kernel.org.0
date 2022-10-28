Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCC861178C
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 18:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbiJ1Qbt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 12:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiJ1Qbr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 12:31:47 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48EA61C73D1
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 09:31:47 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id h185so5257837pgc.10
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 09:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wWm33mQ3hvWArBxOrJMcZ+DdCTdsoZAKdB1hEJ9v+uI=;
        b=L+bcmCymxk9w5qxk3BccZMGbd1j/bVOq7BA/62RvrHfdcEzYnx9y4jDlCLXW2w4aE6
         PiL8kTkRTKVtKkr5ZfHzkPmCem6lIb7Zv2KlV18+IppUoMn7j2wwqIVA9Iy+33N80H2u
         9VNqZvj+4B/4UNtRrrfpQtrHV8Io9WISVtChY+oxim33+LnRYSWZfu+WAcUwWJ67fQ0s
         W2mrCsZGCnAkjMfbZJi51IkbvQL2QJE03sKCYXBDYLOpVyofMXpQm7ho8uusq+EDYkJG
         MTcIiYMdcNoEs9E0ydLtDnfZ1Hzck/0PNK8gKvCITH5sW6AMG8c4EFbTYxGBjId//kXP
         k6Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wWm33mQ3hvWArBxOrJMcZ+DdCTdsoZAKdB1hEJ9v+uI=;
        b=ALtvAkXNPGkoVnQHL/hkNGlBrkcnLO0DANV8Fo0vt2l7VIFVCA3AobWRkgUcso8Mxw
         oJ4PbuOnDv6Py+1cbct21N3XPb4CO6ph1U3wFxjecjpZuGIYE0QzZTWNshj3pkypH20p
         2/U1xiv2GmOa/SornbK6tyKc1zR5jzDwm9np1btM+43ocMxtAEwt7fO+yq6ERpMZklhJ
         fWV3vHd633eU97D5hiMNzOLEWeltwvAjObZ0Ky1hiOF8o4QKQxsYRgue1TzplVUYp+e+
         quvky9sRcSdPpupVXOI9J2lbUN2kiSmK08otHMTx1mW93tzPFotcir7HZh5oozzVnsDv
         iL3w==
X-Gm-Message-State: ACrzQf1lLdWNjhAxfSTnTZZu6dZmPR9D8nAg3hGQqUv5QU3kD88H5VAh
        4wuhGLDCh4G+CCf52gzOYuJLhg==
X-Google-Smtp-Source: AMsMyM45rCIbAJsMXY1hsypPcowAH/2zuvoqq61QCokvbSt1bG18qvvWLe3rPTzzrpp+3TiJ7RDdMA==
X-Received: by 2002:a05:6a00:851:b0:563:6c6a:2b7b with SMTP id q17-20020a056a00085100b005636c6a2b7bmr55178956pfk.45.1666974706684;
        Fri, 28 Oct 2022 09:31:46 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d125-20020a623683000000b0056c0b472c09sm3022854pfa.211.2022.10.28.09.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 09:31:46 -0700 (PDT)
Date:   Fri, 28 Oct 2022 16:31:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Woodhouse, David" <dwmw@amazon.co.uk>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mhal@rbox.co
Subject: Re: [PATCH 03/16] KVM: x86: set gfn-to-pfn cache length consistently
 with VM word size
Message-ID: <Y1wD7hcY/GSA/zHP@google.com>
References: <20221027161849.2989332-1-pbonzini@redhat.com>
 <20221027161849.2989332-4-pbonzini@redhat.com>
 <Y1q+a3gtABqJPmmr@google.com>
 <c61f6089-57b7-e00f-d5ed-68e62237eab0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c61f6089-57b7-e00f-d5ed-68e62237eab0@redhat.com>
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

On Fri, Oct 28, 2022, Paolo Bonzini wrote:
> On 10/27/22 19:22, Sean Christopherson wrote:
> > On Thu, Oct 27, 2022, Paolo Bonzini wrote:
> > > So, use the short size at activation time as well.  This means
> > > re-activating the cache if the guest requests the hypercall page
> > > multiple times with different word sizes (this can happen when
> > > kexec-ing, for example).
> > 
> > I don't understand the motivation for allowing a conditionally valid GPA.  I see
> > a lot of complexity and sub-optimal error handling for a use case that no one
> > cares about.  Realistically, userspace is never going to provide a GPA that only
> > works some of the time, because doing otherwise is just asking for a dead guest.
> 
> We _should_ be following the Xen API, which does not even say that the
> areas have to fit in a single page.

Ah, I didn't realize these are hypercall => userspace => ioctl() paths.

> In fact, even Linux's
> 
>         struct vcpu_register_runstate_memory_area area;
> 
>         area.addr.v = &per_cpu(xen_runstate, cpu);
>         if (HYPERVISOR_vcpu_op(VCPUOP_register_runstate_memory_area,
>                                xen_vcpu_nr(cpu), &area))
> 
> could fail or not just depending on the linker's whims, if I'm not
> very confused.
> 
> Other data structures *do* have to fit in a page, but the runstate area
> does not and it's exactly the one where the cache comes the most handy.
> For this I'm going to wait for David to answer.
> 
> That said, the whole gpc API is really messy 

No argument there.

> and needs to be cleaned up beyond what this series does.  For example,
> 
>         read_lock_irqsave(&gpc->lock, flags);
>         while (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc, gpc->gpa,
>                                            sizeof(x))) {
>                 read_unlock_irqrestore(&gpc->lock, flags);
> 
>                 if (kvm_gfn_to_pfn_cache_refresh(v->kvm, gpc, gpc->gpa, sizeof(x)))
>                         return;
> 
>                 read_lock_irqsave(&gpc->lock, flags);
>         }
> 	...
>         read_unlock_irqrestore(&gpc->lock, flags);
> 
> should really be simplified to
> 
> 	khva = kvm_gpc_lock(gpc);
> 	if (IS_ERR(khva))
> 		return;
> 	...
> 	kvm_gpc_unlock(gpc);
> 
> Only the special preempt-notifier cases would have to use check/refresh
> by hand.  If needed they could even pass whatever length they want to
> __kvm_gpc_refresh with, explicit marking that it's a here-be-dragons __API.
> 
> Also because we're using the gpc from non-preemptible regions the rwlock
> critical sections should be enclosed in preempt_disable()/preempt_enable().
> Fortunately they're pretty small.
> 
> For now I think the best course of action is to quickly get the bugfix
> patches to Linus, and for 6.2 drop this one but otherwise keep the length
> in kvm_gpc_activate().

Works for me.
