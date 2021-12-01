Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8DAE4653D8
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 18:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351861AbhLAR0O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 12:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351863AbhLAR0M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 12:26:12 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CF1C061748
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 09:22:51 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id o14so18253423plg.5
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 09:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+2Yym3MHDEjAN0em2bHTA07FQdpnBvaYXRIK8pM+fMo=;
        b=HpgPyQMksD4X48opflxmeFTbxieGo1MTb4o1d1Lvaer8Nrkh7WBrgtJR0yuD1mPmFA
         aNa+Wmwg1kuhpWeMNH1jzJbe4P29WoBGF2i8Xd6JAvolcHm4/zClNzcmAL+6FQkw11Tj
         OCEXmVQrwXQcaohIMwFM0m36gp/8Xk1eOYoeuMQ8UZTZPKyp5rcy1gmtJG+i3QBWiV3N
         dyA5hPTpVuwro3KWFb0aDlVx/T0FpNrM2e7zubFBGt6DLWHtw8rNdhjNjlqU5vtplFRP
         GopJ2wrXOy1OtlnwuEzhV80/G3ALhNMr5D/i72lt+4ZXIcl1SYqN7QaPF80DL4O3c5Dn
         f3CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+2Yym3MHDEjAN0em2bHTA07FQdpnBvaYXRIK8pM+fMo=;
        b=4PMG9YVg4X176/qFP2FIDlXfOtCiliTLJMG6CfvtprQaXUImcNecqvJbGZAYttrr8c
         eJDjdJBSr5jBX5+lxqiKgFGvTXwJGH0c0CUNuT2MRdIwAvAyb+sGWFwDUhD/yw+jhtkX
         suZME2TICxMN77xGinT6ZM2h7XQIMu4Q1ZB3n0rxz2dzUrhC3kAzZhHSgn+tZPKPM7wS
         3hb4Z8IsmESmmHzN91DaZZHM20hV6klufdomD6Nfozy/x33tZdl0ZVOb77Z/4NiVVVqX
         rQWM4XTdkzTurIE4KTR6JHUCykAwCSfqiY82P+ku48q8z9nWl4JocO2GSvqyF6fDU7ao
         VZkA==
X-Gm-Message-State: AOAM531o4XydQ6Sn4ZDjsMlGji7sXLJElIDS4yaqA0LWgDCRrt7Imc43
        3W/4WlzT0056CLonM7Rhbt1CPQ==
X-Google-Smtp-Source: ABdhPJzaEL9AfAIxU0efSE4x82EiU6ENWkD9Az6MRv25S25Daxq9QsiC9H37UlECTfGKU3S0lC0SrA==
X-Received: by 2002:a17:90b:1d0e:: with SMTP id on14mr9238550pjb.119.1638379370560;
        Wed, 01 Dec 2021 09:22:50 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mn15sm162910pjb.35.2021.12.01.09.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 09:22:49 -0800 (PST)
Date:   Wed, 1 Dec 2021 17:22:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>
Subject: Re: [PATCH 3/6] Add KVM_CAP_DIRTY_QUOTA_MIGRATION and handle vCPU
 page faults.
Message-ID: <YaevZjcW7bMsrBPg@google.com>
References: <20211114145721.209219-1-shivam.kumar1@nutanix.com>
 <20211114145721.209219-4-shivam.kumar1@nutanix.com>
 <YZaUENi0ZyQi/9M0@google.com>
 <02b8fa86-a86b-969e-2137-1953639cb6d2@nutanix.com>
 <YZgD0D4536s2DMem@google.com>
 <2a329e03-1b44-1cb3-f00c-1ee138bb74de@nutanix.com>
 <d9129cda-ebd9-aec3-3f04-bb989c509ac1@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d9129cda-ebd9-aec3-3f04-bb989c509ac1@nutanix.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 25, 2021, Shivam Kumar wrote:
> 
> On 20/11/21 1:51 am, Shivam Kumar wrote:
> > 
> > On 20/11/21 1:36 am, Sean Christopherson wrote:
> > > Actually, if we go the route of using kvm_run to report and update the
> > > count/quota, we don't even need a capability.  Userspace can signal each
> > > vCPU to induce an exit to userspace, e.g. at the start of migration, then
> > > set the desired quota/count in vcpu->kvm_run and stuff exit_reason so
> > > that KVM updates the quota/count on the subsequent KVM_RUN.  No locking
> > > or requests needed, and userspace can reset the count at will, it just
> > > requires a signal.
> > > 
> > > It's a little weird to overload exit_reason like that, but if that's a
> > > sticking point we could add a flag in kvm_run somewhere.  Requiring an
> > > exit to userspace at the start of migration doesn't seem too onerous.
> >
> > Yes, this path looks flaw-free. We will explore the complexity and how
> > we can simplify its implementation.
>
> Is it okay to define the per-vcpu dirty quota and dirty count in the kvm_run
> structure itself? It can save space and reduce the complexity of the
> implemenation by large margin.

Paolo, I'm guessing this question is directed at you since I made the suggestion :-)
