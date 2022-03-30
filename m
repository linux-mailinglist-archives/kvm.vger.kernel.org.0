Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976194ECD80
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 21:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbiC3TtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 15:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiC3TtX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 15:49:23 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC2049FA3
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 12:47:37 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id j8so11265979pll.11
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 12:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oOXYySrw0TmLydZhFaBm1sSWPMqWsbFjnghNvkA6FaM=;
        b=gbpzu1Z2hU6QehteHeEJKFYONUPWrH2ePmFVq8fBFUmfdYtEiqsX50/mxXE6MurCVz
         JXAqXdvNZvb7vA7qoEoc3FanAyDiRoKv7/syIKrdi6n09xaXb/qIZgA4k61JPaUcBbAY
         SUfoMNlirJfv7ZV/HVRE0iKvnYT0V0CkAEz1G+3n17fFVaVBxVr3ZhxMjObOo6cbFX1W
         lnCCzZ4T0f2CXnM+WbG/wctlV1md8NG+uBIWqM3+eDO3X31aMD3bFQEAU6e+drFhi8qj
         xVoa+Awu1NON5/2ATU7EsXqpafSe/P2WYIYgWuGSTcu7yldqZkm0g6v6L3y/OhP50dsQ
         Ln5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oOXYySrw0TmLydZhFaBm1sSWPMqWsbFjnghNvkA6FaM=;
        b=pvgJY2jywLti2uKpflUGqDcb/ncDUEZ5H8d01B591wayvcMT5M9hSodgW8s3dCXhaP
         RlOw69XbE5Gammc1rfRDWAtRfO0KKVWxb6PIPvQx98vDfTUY/KBFIN2AIXWzhy5Hnbkx
         ZuBlw2aVufq1j4Sz2bBvewwemFJzVi8XJcR5Bs5B9vneflYgjlgFJA1boG+APWkIdC6V
         5+J3qVNUEKDU3imKZwYgy9i/XzTYCqD6m+aT9+VeaqpggQ0WlrON8zby8XN09dCy0MAg
         PQpgM447TP1jRO3vUjQZf174UwdMVFu2RD8HWbi88+uXY8jybCFziNfwfvDQcyzjMHPg
         nazg==
X-Gm-Message-State: AOAM531DQSwObmESu1KvqX/E78LIl1z/soIOD0WmSkryKEGWSP3x20F0
        IzLImVgMP+JLgZYMJzphC3rI7A==
X-Google-Smtp-Source: ABdhPJxk2VhMZr3qV/kmbltDEUGnT8rnmM3fOZ/vJPdGZY8jeavTdQllY8SLAsXjHwz5J/UF08rS1w==
X-Received: by 2002:a17:90b:3846:b0:1c6:841b:7470 with SMTP id nl6-20020a17090b384600b001c6841b7470mr1252259pjb.193.1648669657261;
        Wed, 30 Mar 2022 12:47:37 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ij17-20020a17090af81100b001c67c964d93sm8557230pjb.2.2022.03.30.12.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 12:47:36 -0700 (PDT)
Date:   Wed, 30 Mar 2022 19:47:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Bharata B Rao <bharata@amd.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Mingwei Zhang <mizhang@google.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v1 0/9] KVM: SVM: Defer page pinning for SEV guests
Message-ID: <YkSz1R3YuFszcZrY@google.com>
References: <20220308043857.13652-1-nikunj@amd.com>
 <YkIh8zM7XfhsFN8L@google.com>
 <c4b33753-01d7-684e-23ac-1189bd217761@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4b33753-01d7-684e-23ac-1189bd217761@amd.com>
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

On Wed, Mar 30, 2022, Nikunj A. Dadhania wrote:
> On 3/29/2022 2:30 AM, Sean Christopherson wrote:
> > Let me preface this by saying I generally like the idea and especially the
> > performance, but...
> > 
> > I think we should abandon this approach in favor of committing all our resources
> > to fd-based private memory[*], which (if done right) will provide on-demand pinning
> > for "free".  
> 
> I will give this a try for SEV, was on my todo list.
> 
> > I would much rather get that support merged sooner than later, and use
> > it as a carrot for legacy SEV to get users to move over to its new APIs, with a long
> > term goal of deprecating and disallowing SEV/SEV-ES guests without fd-based private
> > memory.  
> 
> > That would require guest kernel support to communicate private vs. shared,
> 
> Could you explain this in more detail? This is required for punching hole for shared pages?

Unlike SEV-SNP, which enumerates private vs. shared in the error code, SEV and SEV-ES
don't provide private vs. shared information to the host (KVM) on page fault.  And
it's even more fundamental then that, as SEV/SEV-ES won't even fault if the guest
accesses the "wrong" GPA variant, they'll silent consume/corrupt data.

That means KVM can't support implicit conversions for SEV/SEV-ES, and so an explicit
hypercall is mandatory.  SEV doesn't even have a vendor-agnostic guest/host paravirt
ABI, and IIRC SEV-ES doesn't provide a conversion/map hypercall in the GHCB spec, so
running a SEV/SEV-ES guest under UPM would require the guest firmware+kernel to be
properly enlightened beyond what is required architecturally.
