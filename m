Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE8C5FE38D
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 22:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiJMUxf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 16:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiJMUxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 16:53:33 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6887117938A
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 13:53:32 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id p14so3032283pfq.5
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 13:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4r17VGc1y0KI+bsRJPcWxnYDIeONL0hh/0Ayx7wHqTQ=;
        b=Q9B4O1ctEjN7cMG74XnwM0jKKYbnZlrj4HJMvK1b8AsU+QZn9QUqhC6KbwKlwHsD4X
         1TjIAAcZA+LuPGpMXi+dt8PxUUV5SEVsrdU6njChdq2240vx92CX2NvfViUN0/YNJD+6
         pIWcIvXrdPRTK4G3rHXvJp3S15M7JdgOdG9DzTK+/WhyG5D7N+/Ls8feRoQ9LdasENnm
         4/0bYqXYJbp2Aud9Xs2jL842QvCPuVyUaJf4LeaU+1yAT+MrSqF7qmn9+c4tf4ECwibh
         3JnJvNKUIU8eIzuBBgkYJzrUrbk2gR9WPL2TYaaviaGI5fiJUglRzZByWwcqIiFvXjpJ
         P02A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4r17VGc1y0KI+bsRJPcWxnYDIeONL0hh/0Ayx7wHqTQ=;
        b=KpHdszZcr1xlIy6kFjqI2DOSD+ZLbAM/1aIbo07TJLR7S0m0X+mJnrFu9l+8xT2bc0
         GAKgJb/raP+s8Y8/BSkQlg5Bm0igRc81+mkEg6SCeir6To0ZQJlib2RKxTa3cBTIb6ws
         f8vA8+FyERRPcGKIR5EaXrKbQBRivgQlPn2PppuSElxXTt76OqnFDRPKVyy+GcozjjCt
         xK8z/bSjIw2XPfrQENwbcMnI2j+yFvciOdCs5jCA/7RyVgm0SiBKPn5BwXxvPQdIS3J7
         Ktm1ThzH5iSE8zS3dsHRAijLV8nhIxjGu1tvusbENB1Jt9pyCfNzVBIsTB9n/i/koYZd
         rV+Q==
X-Gm-Message-State: ACrzQf2I4CHCJAzTcgk/o3QFZF0E+Nubp30feJ02jnzmNr9aPuiRhg2V
        XakZKrdl67j+P6HuxtovM/3j/tFyLmp+mw==
X-Google-Smtp-Source: AMsMyM4F/9k8UYWTyBvmUTdMe8JQKDRWp680cP73rA9yvR46/Op9hloMq78n5nExLvTc7h696WznUA==
X-Received: by 2002:a63:2bd4:0:b0:451:5df1:4b15 with SMTP id r203-20020a632bd4000000b004515df14b15mr1554887pgr.518.1665694411830;
        Thu, 13 Oct 2022 13:53:31 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s22-20020a170902b19600b00172f6726d8esm246974plr.277.2022.10.13.13.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 13:53:30 -0700 (PDT)
Date:   Thu, 13 Oct 2022 20:53:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Like Xu <likexu@tencent.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/4] KVM: x86/pmu: Force reprogramming of all counters on
 PMU filter change
Message-ID: <Y0h6x0ZJWYH56Z88@google.com>
References: <20220923001355.3741194-1-seanjc@google.com>
 <20220923001355.3741194-2-seanjc@google.com>
 <86d88222-a70f-49ef-71f3-a7d15ae17d7d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86d88222-a70f-49ef-71f3-a7d15ae17d7d@gmail.com>
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

On Thu, Oct 13, 2022, Like Xu wrote:
> Firstly, thanks for your comments that spewed out around vpmu.
> 
> On 23/9/2022 8:13 am, Sean Christopherson wrote:
> > Force vCPUs to reprogram all counters on a PMU filter change to provide
> > a sane ABI for userspace.  Use the existing KVM_REQ_PMU to do the
> > programming, and take advantage of the fact that the reprogram_pmi bitmap
> > fits in a u64 to set all bits in a single atomic update.  Note, setting
> > the bitmap and making the request needs to be done _after_ the SRCU
> > synchronization to ensure that vCPUs will reprogram using the new filter.
> > 
> > KVM's current "lazy" approach is confusing and non-deterministic.  It's
> 
> The resolute lazy approach was introduced in patch 03, right after this change.

This is referring to the lazy recognition of the filter, not the deferred
reprogramming of the counters.  Regardless of whether reprogramming is handled
via request or in-line, KVM is still lazily recognizing the new filter as vCPUs
won't picke up the new filter until the _guest_ triggers a refresh.

> > @@ -613,9 +615,18 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
> >   	mutex_lock(&kvm->lock);
> >   	filter = rcu_replace_pointer(kvm->arch.pmu_event_filter, filter,
> >   				     mutex_is_locked(&kvm->lock));
> > -	mutex_unlock(&kvm->lock);
> > -
> >   	synchronize_srcu_expedited(&kvm->srcu);
> 
> The relative order of these two operations has been reversed
> 	mutex_unlock() and synchronize_srcu_expedited()
> , extending the execution window of the critical area of "kvm->lock)".
> The motivation is also not explicitly stated in the commit message.

I'll add a blurb, after I re-convince myself that the sync+request needs to be
done under kvm->lock.

> > +	BUILD_BUG_ON(sizeof(((struct kvm_pmu *)0)->reprogram_pmi) >
> > +		     sizeof(((struct kvm_pmu *)0)->__reprogram_pmi));
> > +
> > +	kvm_for_each_vcpu(i, vcpu, kvm)
> > +		atomic64_set(&vcpu_to_pmu(vcpu)->__reprogram_pmi, -1ull);
> 
> How about:
> 	bitmap_copy(pmu->reprogram_pmi, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX);
> to avoid further cycles on calls of
> "static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, bit)" ?

bitmap_copy() was my first choice too, but unfortunately it's doesn't guarantee
atomicity and could lead to data corruption if the target vCPU is concurrently
modifying the bitmap.
