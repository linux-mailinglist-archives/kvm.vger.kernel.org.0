Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBDBE35233A
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 01:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbhDAXMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 19:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbhDAXMS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 19:12:18 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E389BC0613E6
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 16:12:18 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id h20so1742942plr.4
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 16:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZMeGkiE2u1krPiHlSFL6U3IenEWi+WdCEXcmLNEcs2U=;
        b=l3eF7MzDT4eETp6S5Pd8diPK4DULNwHUEJuVX7Cv/3Kz+Bo9Sj+iPDHSLIMUR6VeMD
         z/fV/MHePGE1z/FPU5TqQs481daI3x8Ct8IWC3LQttAdDMWFS5okAztCn2eoHTZYDGLb
         EG7eXT0FXWLrOwHFLDARK5EnHHXQ4euMgPmPKwfevWMPEeqxk01iI+2BbZg3wOhYourO
         74PjlXzJQKNCKjAUKUHX5ecC4Fh32itfgceoJJhU+X36n+a8PiKCk3YGvzCEZj2yMctQ
         9wXF5Jp3Yrsh14m7/0iCI6LlI3hlu9R6zHGWVgBUxTrtOyccNb4J7LQMAFGJ4cZZb7I+
         VxpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZMeGkiE2u1krPiHlSFL6U3IenEWi+WdCEXcmLNEcs2U=;
        b=bLFa68Ram2fXkr6M+o+OOhA66JSFYCrPvNfIrx/ITDiaVwZZbSuqR/+fRv+ppy6YN0
         gfvssKEUDb6fKrYNr1DSB8hNxlCihmoqcaVSmxiaiMuduUTuYMIjSN/ZPsqlLYieEzU8
         /ytA+b6SlRMQ+ft5Un7YQTeKILTZeKT+KG8SaH1Ebb/PMOze+vnXeek56EIHX66323rK
         cNHyWaVatUjZXEGiYw0cKk3KI6SZ4bvQ80kLdg3NN7xNV6C/ksyPWDndYhtBxVzFSd88
         KkNCpKTsP+//vI5vE2/VjyM6p/Nu1IdVTcQ4C0UnDLxI0KLAwWXWMF5bObpa95MMXZKV
         pUnQ==
X-Gm-Message-State: AOAM533U86IoZc9gmz4efx24qEGU47/sQnhUpNoF9NNa2kLhPkKSiiU/
        UzY80w/AoOhyvJMlZ5NywpItlQ==
X-Google-Smtp-Source: ABdhPJw0hgKJk8RKs1JJf+tL9BhTokVlixvEn/1VFK8E+2jgtn1z0WJ/7WjNr1LLeQcLnPnJrwAraQ==
X-Received: by 2002:a17:90a:cb12:: with SMTP id z18mr10534438pjt.132.1617318738345;
        Thu, 01 Apr 2021 16:12:18 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id g72sm6364398pfb.189.2021.04.01.16.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 16:12:17 -0700 (PDT)
Date:   Thu, 1 Apr 2021 23:12:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 0/5 v5] KVM: nSVM: Check addresses of MSR bitmap and IO
 bitmap tables on vmrun of nested guests
Message-ID: <YGZTTvlMuB5Oo63C@google.com>
References: <20210401192033.91150-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401192033.91150-1-krish.sadhukhan@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 01, 2021, Krish Sadhukhan wrote:
> v4 -> v5:
>         1. In patch# 1, the actual size of the MSRPM and IOPM tables are now
> 	   defined. The initialization code for the tables has been adjusted
> 	   accordingly.
> 	2. In patch# 2, the checks have been adjusted based on the actual
> 	   size of the tables. The check for IOPM has also been fixed.
> 	3. In patch# 4, a new test case has been added. This new test uses
> 	   an address whose last byte touched the limit of the maximum
> 	   physical address.
> 
> [PATCH 1/5 v5] KVM: SVM: Define actual size of IOPM and MSRPM tables
> [PATCH 2/5 v5] nSVM: Check addresses of MSR and IO permission maps
> [PATCH 3/5 v5] KVM: nSVM: Cleanup in nested_svm_vmrun()

The kernel patches need to be rebased, their base is very stale and none of them
apply on kvm/queue.
