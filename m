Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A058B405D01
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 20:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245120AbhIIStm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 14:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343571AbhIIStS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 14:49:18 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C139C061757
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 11:48:02 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id t1so2738915pgv.3
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 11:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dg0r0liUbOmGHsQc3vfJ9m4p0cWpSRLKqxX4E9SFtgk=;
        b=g5eRKlBnihT8ztbBDJopIavUkwhRhnlBMhe2YaN9dmHm78RIHxpFhkNoTdJPljvITL
         lQ2jAuzpxxk96ExS19fLwBatAsVZScrin4Io1ttgMh0B39HyeZM4PQQTA0PADA7P6/MM
         VARBkP9SHIt1P9CvOBYFkufdUmR4xUDlgbcd5gzvM5y/usHsu6JtRSeZOnsLVXHIfEHT
         jjNtZGF7IfQRgJY1tt+YfzkRjbKP3AzZIqGnFN229SqOoIYstUQaosIGLaxYzJRbjSSE
         U8yozCQQFwnuuEzCYQmp6zQttNwW0k4URO4HSNr1WqTKzEzR1gcp5/tBiZcaRThRil0p
         r4yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dg0r0liUbOmGHsQc3vfJ9m4p0cWpSRLKqxX4E9SFtgk=;
        b=LYM0hdewWlkpoGE46Fly9g7SgH2xyvypBwKGsyV7JoDhQiSDtF5c2Hj5ot5w0BmXNo
         h0QBYfP2snWe+noemrXyn7M90IhroQU6kKs+hYJZ+WMV0+ogPe5YSwZhtKHkKdkTSvYn
         P2nrLqHrbQ4TUqHucQoBGGI3npWC5hK2XhxdeX52y4Ro0GL5S+QjZatg0r6tL9Ei4jF1
         IU5nwF7Svc+g4M19rK9YUwK6RfwZ7eJf4QkYFPdBA5UF6Kzu/o5qZmYsQBUuzMP6i/PY
         YNyFTwnjARhXCp+37Egs0G12JV2SGt79lNgz6ZoNVW+oxySAIcL9uxNAFUJKCTlwVi6K
         T9FQ==
X-Gm-Message-State: AOAM531nRFoU+BdxikuH5LG7qp7N8k2B1HYkkPGM4Krs5hReu6JNhSj8
        mOVmCi9o3D2TVLdiMCPLUQOiWw==
X-Google-Smtp-Source: ABdhPJzMhX6PdoT2nHQMfXq1CsG5HU9SihUA9Rs73ScHL9N+w64F41n7oGp1zet8FJAAwQhpOLg2WQ==
X-Received: by 2002:a63:d10b:: with SMTP id k11mr3996557pgg.26.1631213281422;
        Thu, 09 Sep 2021 11:48:01 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e5sm2838094pjv.44.2021.09.09.11.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 11:48:00 -0700 (PDT)
Date:   Thu, 9 Sep 2021 18:47:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, Tao Xu <tao3.xu@intel.com>,
        pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: VMX: Enable Notify VM exit
Message-ID: <YTpW3M8Iyh8kLpyx@google.com>
References: <20210525051204.1480610-1-tao3.xu@intel.com>
 <YQRkBI9RFf6lbifZ@google.com>
 <b0c90258-3f68-57a2-664a-e20a6d251e45@intel.com>
 <YQgTPakbT+kCwMLP@google.com>
 <080602dc-f998-ec13-ddf9-42902aa477de@intel.com>
 <4079f0c9-e34c-c034-853a-b26908a58182@intel.com>
 <YTD7+v2t0dSZqVHF@google.com>
 <c7ff247a-0046-e461-09bf-bcf8b5d0f426@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7ff247a-0046-e461-09bf-bcf8b5d0f426@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 07, 2021, Xiaoyao Li wrote:
> On 9/3/2021 12:29 AM, Sean Christopherson wrote:
> > > After syncing internally, we know that the internal threshold is not
> > > architectural but a model-specific value. It will be published in some place
> > > in future.
> > 
> > Any chance it will also be discoverable, e.g. via an MSR?
> 
> I also hope we can expose it via MSR. If not, we can maintain a table per
> FMS in KVM to get the internal threshold. However, per FMS info is not
> friendly to be virtualized (when we are going to enable the nested support).

Yeah, FMS is awful.  If the built-in buffer isn't discoverable, my vote is to
assume the worst, i.e. a built-in buffer of '0', and have the notify_window
param default to a safe value, e.g. 25k or maybe even 150k (to go above what the
hardware folks apparently deemed safe for SPR).  It's obviously not idea, but
it's better than playing FMS guessing games.

> I'll try to persuade internal to expose it via MSR, but I guarantee nothing.

...

> > On a related topic, this needs tests.  One thought would be to stop unconditionally
> > intercepting #AC if NOTIFY_WINDOW is enabled, and then have the test set up the
> > infinite #AC vectoring scenario.
> > 
> 
> yes, we have already tested with this case with notify_window set to 0. No
> false positive.

Can you send a selftest or kvm-unit-test?
