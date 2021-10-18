Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A6F432556
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 19:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbhJRRto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 13:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbhJRRtm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 13:49:42 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39593C06161C
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 10:47:31 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id j190so10215175pgd.0
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 10:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RJEmKBXd/7Dkkvku9fuOKPqFTbiOGUZ+aU8WL5AMAfI=;
        b=PosO1bEKAC1GB80J3AEfYxUNEu86KmvfHqParuDJFuirZjWq7UxyNAiHTY1gc3ZJbp
         g3Sg0/2KLj2+z1tU1Em+vST0bm+Nf1AXTNCA9ONaKWA9zee5eODDuPNTG0UYpJiK6Kk/
         uk8b4cPICU3riZKLS2ugoAcyYK768HKV0zgINs7cczCLSUdxx5LBarvpUvPCzHOogxf7
         ruN6U9tgeJeyUYnzEaDnB0Ep1HFT1636mwM0VKvEnjwWVgsw29LsYTnD4bV4EgBlNHsX
         WQK+xdPBDt3DivTN60BQmOQd4H+uUxsdkyIWTFNW5HxKho1JoR60DpBkvfJ2tNFUkH0R
         wXXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RJEmKBXd/7Dkkvku9fuOKPqFTbiOGUZ+aU8WL5AMAfI=;
        b=XWxjk7qFKylzLeLn1P/pKtPU2/jOP7va6tI2O4Fzql3w1cslaBD7KSsE1vfprupzWK
         OrutLPdR2SkUjASQ58VDEXNQ/9KAPVVBdNibAkEnLf2TPoAPEjPBJfbQEtTUJS2FSR1Y
         varTLWJJ8kO8PjMs7auduHHTtoVXAbdvtH6Rp5uakLFNhoWhBiWMEzPNfdphFomthcT0
         FoHuWlqXKuzqr1enILcTw0dLvT/fgjcO99zdGUV23u4kzq5kY9z2eSXwpw3Jo/ePPEcy
         7df1dBZW3qmXlpItpLLnVAGiNiUxVxY3pJ+Hu4zxht1sNrmml1vmoEO8YxlyPC5yH15U
         v9HA==
X-Gm-Message-State: AOAM530pI2f8p/snb0YgRDzS0xqzHYBroQR/FgyYQMwID4mAhr1eiwaN
        fMNJAoolQiSZaV8AffGfyj8h44CigWwNKA==
X-Google-Smtp-Source: ABdhPJy1U9M6WX4Za84gx+QSD10BfXvvdLnh09T7AsxYvnDyRY7UGYJySE8nBpZXCOBbXpWlUeVjdA==
X-Received: by 2002:a05:6a00:c8c:b0:44d:c583:9b45 with SMTP id a12-20020a056a000c8c00b0044dc5839b45mr9539014pfv.28.1634579250552;
        Mon, 18 Oct 2021 10:47:30 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b8sm14476225pfm.65.2021.10.18.10.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 10:47:29 -0700 (PDT)
Date:   Mon, 18 Oct 2021 17:47:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@linux.intel.com, x86@kernel.org, yang.zhong@intel.com,
        jarkko@kernel.org, bp@suse.de
Subject: Re: [PATCH v3 2/2] x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE ioctl
Message-ID: <YW2zLoFCq4l2w4p6@google.com>
References: <20211016071434.167591-1-pbonzini@redhat.com>
 <20211016071434.167591-3-pbonzini@redhat.com>
 <YW2sKq1pXkuiG1rb@google.com>
 <e9af2f2e-a0cf-1916-c960-2a663e6f4596@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9af2f2e-a0cf-1916-c960-2a663e6f4596@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 18, 2021, Paolo Bonzini wrote:
> On 18/10/21 19:17, Sean Christopherson wrote:
> > 			/*
> > 			 * Report errors due to #GP or SGX_ENCLAVE_ACT, but do
> > 			 * not WARN as userspace can induce said failures by
> > 			 * calling the ioctl concurrently on multiple vEPCs or
> > 			 * while one or more CPUs is running the enclave.  Only
> > 			 * a #PF on EREMOVE indicates a kernel/hardware issue.
> > 			 */
> > 			WARN_ON_ONCE(encls_faulted(ret) &&
> > 				     ENCLS_TRAPNR(ret) == X86_TRAP_PF);
> 
> or != X86_TRAP_GP, just to avoid having a v5? :)

LOL, good point, that's indeed better.
