Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAE34D2358
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 22:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350483AbiCHVaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 16:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350458AbiCHVaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 16:30:07 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808D749F91
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 13:29:09 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id e15so466658pfv.11
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 13:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LMQ8AOMqqmqopzig17jUsU9/I303Wa2KV8iSyK2C8QA=;
        b=WNDbXoXIOar/wXxjMrbLZybR4KUBP9I7doIbDaHXlaOZvNyWWyEki6sfU6jGydFaRk
         eXOv1p69nRIvQy5jat7OAdT48dIFywwEon4KKy1nYiLVVs+i6fMpNzUbGueLFWYLr6I9
         2rQbA023WRUUnsPQW32MJnzDsUOYuvgwdHOrDBgHBVU6mOJX4XfkQG7S2orpc15vMA9G
         0krpTjx4KgzEzHwMv4rJOZmsTRKBZ/ks2icky8g2MiZ7cCnou26T1teHclapxVJAGYIG
         nXqx4joM5vxY6I4TLRX4ZFKuOd0IerD3ZeF6h1/jPnGRcGYo0D1BTsHJucbuZ9xlFQAY
         4mpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LMQ8AOMqqmqopzig17jUsU9/I303Wa2KV8iSyK2C8QA=;
        b=G7eAAmnUHkkxADJGFVHdTAui/rtVTGpQ2ibBSuQPk9YWFS3YBQhPGw9Udftd17XRsB
         ESrOOaUhZ02SnICCqlf7YSn7aZQnQ/a9CdYJzL/Z9coZcBSyJlgvym5uIZQPwgQENCQX
         c7c6pNSOVt742u7beuU4LJ55Ocq8JoF80F0uERuhEPOJeyVROyDA9TQDnrDgtu9azjA1
         dfySobilPOQU5tTJJne85HvhFGM786L2cG1SccxqLV6DrQLWJOtmiIY4S+Aqk3NPO8mC
         ZS7APGq8oJhHKKOUEEfojlGZtT7uMHQ7cbuxTKy5wf19xYV/0ICkc/2MjN3jGaiitHGk
         mFMQ==
X-Gm-Message-State: AOAM532h0vb7eoKInAcnveAiXSLti0ke8mDqi8SyDeGZlqkYQU7/TPwm
        hxuE9/nzneQhyz/I/MwAbkXUPA==
X-Google-Smtp-Source: ABdhPJxaudcIUUVL6UZGM/dSdkzC6iFnk2758wDZzs2B1y5Sgh+P0ylUpx0H2Bb0QaOPv2Z/zEl48w==
X-Received: by 2002:a63:e84b:0:b0:372:a079:302 with SMTP id a11-20020a63e84b000000b00372a0790302mr15745200pgk.272.1646774948794;
        Tue, 08 Mar 2022 13:29:08 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o1-20020a637e41000000b003804d0e2c9esm51728pgn.35.2022.03.08.13.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 13:29:07 -0800 (PST)
Date:   Tue, 8 Mar 2022 21:29:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v4 21/30] KVM: x86/mmu: Zap invalidated roots via
 asynchronous worker
Message-ID: <YifKoCZAmymIxDTQ@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-22-pbonzini@redhat.com>
 <YiExLB3O2byI4Xdu@google.com>
 <YiEz3D18wEn8lcEq@google.com>
 <eeac12f0-0a18-8c63-1987-494a2032fa9d@redhat.com>
 <YiI4AmYkm2oiuiio@google.com>
 <8b8c28cf-cf54-f889-be7d-afc9f5430ecd@redhat.com>
 <YiKwFznqqiB9VRyn@google.com>
 <20497464-0606-7ea5-89b8-8f5cd56a1a68@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20497464-0606-7ea5-89b8-8f5cd56a1a68@redhat.com>
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

On Sat, Mar 05, 2022, Paolo Bonzini wrote:
> On 3/5/22 01:34, Sean Christopherson wrote:
> > On Fri, Mar 04, 2022, Paolo Bonzini wrote:
> > > On 3/4/22 17:02, Sean Christopherson wrote:
> > > > On Fri, Mar 04, 2022, Paolo Bonzini wrote:
> > > > > On 3/3/22 22:32, Sean Christopherson wrote:
> > > > > I didn't remove the paragraph from the commit message, but I think it's
> > > > > unnecessary now.  The workqueue is flushed in kvm_mmu_zap_all_fast() and
> > > > > kvm_mmu_uninit_tdp_mmu(), unlike the buggy patch, so it doesn't need to take
> > > > > a reference to the VM.
> > > > > 
> > > > > I think I don't even need to check kvm->users_count in the defunct root
> > > > > case, as long as kvm_mmu_uninit_tdp_mmu() flushes and destroys the workqueue
> > > > > before it checks that the lists are empty.
> > > > 
> > > > Yes, that should work.  IIRC, the WARN_ONs will tell us/you quite quickly if
> > > > we're wrong :-)  mmu_notifier_unregister() will call the "slow" kvm_mmu_zap_all()
> > > > and thus ensure all non-root pages zapped, but "leaking" a worker will trigger
> > > > the WARN_ON that there are no roots on the list.
> > > 
> > > Good, for the record these are the commit messages I have:
> 
> I'm seeing some hangs in ~50% of installation jobs, both Windows and Linux.
> I have not yet tried to reproduce outside the automated tests, or to bisect,
> but I'll try to push at least the first part of the series for 5.18.

Out of curiosity, what was the bug?  I see this got pushed to kvm/next.
