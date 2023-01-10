Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2061664C9E
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 20:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbjAJThZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 14:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbjAJThS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 14:37:18 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC73A54DA7
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 11:37:14 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id cp9-20020a17090afb8900b00226a934e0e5so1935413pjb.1
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 11:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JvZ7i7CR0bYpOIFlkGsbXQDC3XdWIGTjEMZmKy8hjIU=;
        b=Yv24ehSnX4LGye9vcGKKIWFvUoCdrsecL8FxmN8PAYhovS0gNO7kxhn9uokqEV1KDC
         OZ2JYgfRmWn5oteXt9CSETgvhe5wB35fnGhsg+CfNwByMNdZA+EXbOmOhya0SQinHhCy
         KtCqO4WmfLp0QN3pz/iA5l0GWEZ96+71O2Yo66/q7xyG4cEkh9qqzeVSA/MGRsXQT9Gn
         GDSS9Tq8XxuO/a1FimKMbtQhghq8w8WMRxRBYszOHoEmUVXQzmBH5sgCiQ0wIwB4LD9s
         1nGmNq47jMd5QhAU838J581e2wu/rjxKWhyATOLA1VdP7cF2bBsevRAzUq8q2tV01zYq
         6XGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JvZ7i7CR0bYpOIFlkGsbXQDC3XdWIGTjEMZmKy8hjIU=;
        b=k7t4GimaDHBg6DKflmDzw9FBWi9SM2q/KN3m/6+9T1y6EAqGGvI3amIoryiAN0YWQW
         PyjGhTELWUiYI42iIEAdJaiM+1TzpL1/T/fcMN7T3C/RXjC/HaAwdSIteaoTuLJQeMG3
         E8tqZuMhPTe4ffw8Lg4bNQSVAN20xKfIdj0V862qRQ2/ciPGEWb0ZZFIWFr8ICDS4H8h
         59r5YELoX+CXgRyiUYCM3Kv+wsFOJ3rphZ+TdE8iyG/kLzTBjr/OAK0IgDr9kJD4Eku9
         xL54zV0qhzuILuJX5/7KawmmRJ1pWs+ykSThAk5HW5m4M+CKaEYlYWdBcl/tEx5KgbLa
         IbtQ==
X-Gm-Message-State: AFqh2kqyBC7vcTzsAjnZRCGaXZHicZoWBycgDG3jpgrNJIEVusb4liPx
        hA3PSAQfYs9O7Il5UMS5I22v3g==
X-Google-Smtp-Source: AMrXdXubSSGGwhngvLUi2FB2tFMCNDtJwa/uNr+TBAgkM8LP5j2XSvywX4frV7ox2Age4ADlgZTMpg==
X-Received: by 2002:a17:903:2614:b0:193:256d:8afe with SMTP id jd20-20020a170903261400b00193256d8afemr109613plb.2.1673379434110;
        Tue, 10 Jan 2023 11:37:14 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f9-20020a170902ce8900b0019258bcf3ffsm8557480plg.56.2023.01.10.11.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 11:37:13 -0800 (PST)
Date:   Tue, 10 Jan 2023 19:37:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Michal Luczaj <mhal@rbox.co>,
        kvm@vger.kernel.org, paul@xen.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] KVM: x86: Fix deadlock in
 kvm_vm_ioctl_set_msr_filter()
Message-ID: <Y72+ZVwp5Gxy4asX@google.com>
References: <a03a298d-dfd0-b1ed-2375-311044054f1a@redhat.com>
 <20221229211737.138861-1-mhal@rbox.co>
 <20221229211737.138861-2-mhal@rbox.co>
 <Y7RjL+0Sjbm/rmUv@google.com>
 <c33180be-a5cc-64b1-f2e5-6a1a5dd0d996@rbox.co>
 <Y7dN0Negds7XUbvI@google.com>
 <3a4ab7b0-67f3-f686-0471-1ae919d151b5@redhat.com>
 <f3b61f1c0b92af97a285c9e05f1ac99c1940e5a9.camel@infradead.org>
 <9cd3c43b-4bfe-cf4e-f97e-a0c840574445@redhat.com>
 <825aef8e14c1aeaf1870ac3e1510a6e1fe71129d.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <825aef8e14c1aeaf1870ac3e1510a6e1fe71129d.camel@infradead.org>
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

On Tue, Jan 10, 2023, David Woodhouse wrote:
> On Tue, 2023-01-10 at 15:10 +0100, Paolo Bonzini wrote:
> > On 1/10/23 13:55, David Woodhouse wrote:
> > > > However, I
> > > > completely forgot the sev_lock_vcpus_for_migration case, which is the
> > > > exception that... well, disproves the rule.
> > > > 
> > > But because it's an exception and rarely happens in practice, lockdep
> > > didn't notice and keep me honest sooner? Can we take them in that order
> > > just for fun at startup, to make sure lockdep knows?
> > 
> > Sure, why not.  Out of curiosity, is this kind of "priming" a thing 
> > elsewhere in the kernel
> 
> I did this:
> 
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -461,6 +461,11 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
>  static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
>  {
>         mutex_init(&vcpu->mutex);
> +
> +       /* Ensure that lockdep knows vcpu->mutex is taken *inside* kvm->lock */
> +       mutex_lock(&vcpu->mutex);
> +       mutex_unlock(&vcpu->mutex);

No idea about the splat below, but kvm_vcpu_init() doesn't run under kvm->lock,
so I wouldn't expect this to do anything.
