Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A04C41CB53
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 19:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345135AbhI2R4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 13:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244712AbhI2Rz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 13:55:58 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D374CC061764
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 10:54:13 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id lp15-20020a17090b4a8f00b0019f4059bd90so1139676pjb.3
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 10:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NsM0QYbB2vUeU6XpTENYRxMtFbeMZ3QJUEScRtQsMSU=;
        b=A43brtOAGWdbiGMmjU/KjDyojLXi0Q4ZBFDfw88tTfcdHmvg2RxbOQQfAhy6nBMZ3/
         AhrmNzsGT32VeaAd44VjOcfneFf+TbuLjoOlqmfVY0mxoSHPdHupGgJPD8y+X+odsHkd
         XykxJvUdi1cJ9QcUXOmc6ro4N00DG+F8FRWnE8L8lKw6e+b9LJdQVJyBhv0iLzonOqar
         a6XQ3fD6knY4a3+BWHNsODfQjEiz8NtkZxfzGqHSmNl/ZWQ9iVzn5vsRfszDepTihK4Y
         cKE+73mayyq1slTd7cwzV6+OWQ6xSrnjOaSWf8Y3dEkJbzs46a+hxXZix7CLNapxfr+/
         qk8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NsM0QYbB2vUeU6XpTENYRxMtFbeMZ3QJUEScRtQsMSU=;
        b=yrvh617eIFEPF8EC0zg1xH/O466qNcwTFVEDpwjKvrU8QeDQfISrxMTVAQMNnRQXUf
         v8QOnITN3gkB3MF87j5qKlfztEZlNhUvikqxTbZqNA1NaTtVZjBSRsajWB5XKu+8hkH4
         eL08w8+xVamKN+Eo0NovQ3Wu3cPVfvp0JhqWaF/c8GewhDRIv0XMpcuHFUiM8GEyBQit
         2OhRIzbc7VIsAOHesyUreTMbY8qHaDii5EZpHJkuzIfgDl8XUwhEU48aT7RcHXo34QLz
         yftyRRjVRHhy1PKc7rlkekFq7n/HhctMZjItM5LYX05DlaM9OLbhjvFX0O+rzH2SDujv
         Sh9Q==
X-Gm-Message-State: AOAM533xV//UDwdLv5MoNczEQOHnMoou48XPtWiK36YM+vf/1rsesD+j
        TLwV7hl1TmOQTUlNa8RvX5l3vQ==
X-Google-Smtp-Source: ABdhPJzp40tu/G9HqnvotUw/jMzwx9XNCWus/4f0EXr5sSTYTeNKg2Zwh/1URL4JStL4NZqRMJ5Zrg==
X-Received: by 2002:a17:90a:307:: with SMTP id 7mr1316264pje.176.1632938053093;
        Wed, 29 Sep 2021 10:54:13 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a27sm409833pfk.192.2021.09.29.10.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 10:54:12 -0700 (PDT)
Date:   Wed, 29 Sep 2021 17:54:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        pbonzini@redhat.com, shuah@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] selftests: KVM: set affinity of VM to right CPUs
Message-ID: <YVSoQD+yuQzlKLoM@google.com>
References: <20210924233037.4329-1-dongli.zhang@oracle.com>
 <YVIZ/67cfjk18mbe@google.com>
 <5b0a16a9-e98e-368f-4ecd-359c58ae34c4@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b0a16a9-e98e-368f-4ecd-359c58ae34c4@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 28, 2021, Dongli Zhang wrote:
> 
> On 9/27/21 12:22 PM, Sean Christopherson wrote:
> Perhaps a linked list is more suitable to here (when there are 1024 cpus and the
> task is bound to both 1 and 1022) ... to pre-save the possible cpus in a list
> and to only move to next cpu in the list for each iteration.
> 
> However, I think min_cpu/max_cpu is good enough for selttests case.

Yeah, it's annoying that there's no CPU_SET_FOR_EACH so that x86 could optimize
it to use BSF :-/

> Would you please let me know if you would like to send above with my
> Reported-by, or if you would like me to send with your Suggested-by.

If you don't mind, I'll send a patch, I want to fiddle with the migration loop to
see if I can make it less magical/ugly.
