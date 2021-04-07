Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41807357750
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 00:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhDGWFL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 18:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhDGWFL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 18:05:11 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1850DC061760
        for <kvm@vger.kernel.org>; Wed,  7 Apr 2021 15:05:00 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id l76so14054806pga.6
        for <kvm@vger.kernel.org>; Wed, 07 Apr 2021 15:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wH47jkj5S01XtLG9mqIn/0RS8pjr8zTeS3YRDC+IerM=;
        b=cbvFByG+VGs0Zws3AKH8tM3Vb9ziVhXmXafsPjAdvsok4vtedKTwj6VTqONg+3OZRo
         3ip6UggFgETc/hCIr551tQ2Unkb2AaAYD1ZRyn5cu0lddqZGBJC/3ON5yWKKKK0cexcT
         RPEf/LOPjMKF9S8wk7HfkG5TK7+ul9HD6sZQ3w9gz7NhtOmZsA6sIt2qSZzTK04HiCI0
         XKGAM2yZ1LQKr/sE22SmXC8pjPqLQ+IwlM+bMM3QNRS7fDAdFbzSCPJnpG4JW6ZZDiac
         gBnzoorjNRQ6ydD4B1vBlASwBM4NwJDsuPkTilvdrbnQ67UdzzIhuJyhXmWskcchY5Lk
         Vr7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wH47jkj5S01XtLG9mqIn/0RS8pjr8zTeS3YRDC+IerM=;
        b=Zo4+efE1Z3Dl1rW6YFS/1Ggv7YfHTf+xZ+Cw3HS2J1XKFGkS+0ofPdSTBenH7TNh4A
         /xb3oHNuefjL7cK/cJZ53rNy3GghqAcMBaktG8icOVTni0FEpI2qONMhi1QDua3kpDIk
         MUpLEMsTTQLbcd/KzAjshvRIEV+ZYGtaAMSdfzj5Q/FaCltrLNlupP6rOeAPVy2Y3bfI
         jIV9aAqHvXxc49OmpWM9PXEMRZFuPnPhqosFCFi7ea9Z9lmdC1XepCnMsKc+qtJOwcbw
         sXhazWlmUsZPtq0e4zGKFX8twnUxPoQWMBUjFN4BrCGRAX9q8sKOCJp9D6Blvwd/zK10
         7skw==
X-Gm-Message-State: AOAM533h5AkvGZRgjdKIUEUR6XfhPecNwrXG3jANWZjTobAIiIv/rZ2I
        nSslja2x4Kcmq5+OmInnkUoTAg==
X-Google-Smtp-Source: ABdhPJycw3Ip2ZYVbU5IdBWfM80vuSAGI32jxVnYO6j0W1f8udMokCjUCNVmtxIH6B7uvRZzyXbT9g==
X-Received: by 2002:a62:7f02:0:b029:244:152b:99a5 with SMTP id a2-20020a627f020000b0290244152b99a5mr782397pfd.46.1617833099506;
        Wed, 07 Apr 2021 15:04:59 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id mu6sm6056208pjb.35.2021.04.07.15.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 15:04:58 -0700 (PDT)
Date:   Wed, 7 Apr 2021 22:04:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org,
        pbonzini@redhat.com, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
Subject: Re: [PATCH v4 07/11] KVM: VMX: Add SGX ENCLS[ECREATE] handler to
 enforce CPUID restrictions
Message-ID: <YG4sh72soS6JC107@google.com>
References: <cover.1617825858.git.kai.huang@intel.com>
 <963a2416333290e23773260d824a9e038aed5a53.1617825858.git.kai.huang@intel.com>
 <YG4pslLOybyOIDTC@google.com>
 <20210408095822.24d0c709c2680bb78b689ed1@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408095822.24d0c709c2680bb78b689ed1@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021, Kai Huang wrote:
> On Wed, 7 Apr 2021 21:52:50 +0000 Sean Christopherson wrote:
> > On Thu, Apr 08, 2021, Kai Huang wrote:
> > > +	/*
> > > +	 * Copy contents into kernel memory to prevent TOCTOU attack. E.g. the
> > > +	 * guest could do ECREATE w/ SECS.SGX_ATTR_PROVISIONKEY=0, and
> > > +	 * simultaneously set SGX_ATTR_PROVISIONKEY to bypass the check to
> > > +	 * enforce restriction of access to the PROVISIONKEY.
> > > +	 */
> > > +	contents = (struct sgx_secs *)__get_free_page(GFP_KERNEL);
> > 
> > This should use GFP_KERNEL_ACCOUNT.
> 
> May I ask why? The page is only a temporary allocation, it will be freed before
> this function returns. I guess a 4K page is OK?

A hard limit should not be violated, even temporarily.  This is also per vCPU,
e.g. a 256 vCPU VM could go 1mb over the limit.  
