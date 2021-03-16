Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF06E33DBA8
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 18:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239482AbhCPR5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 13:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239470AbhCPR4H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 13:56:07 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F0DC061765
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 10:56:06 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id f8so3806097plg.10
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 10:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1Fb2x79U5zaHbdcvBiPOeYxbZaxlZ4awwzl5b67JIsM=;
        b=m2j6LyS9YlCfS3STNf7qlGcxc1tXrWIcBoUy3NQ4dKmevWQabCEkq/qd0r63RSAiuC
         lBXpXtFGc/IvwQL6J1ONaPV8nP/EMtgZQOnq1/GDAhFgDoJMGqUTq99Gh5w5DgZFlAKR
         GUjRwj2ekreC4yZIHWXklYup63XEoIbSowlLMYeRg1a9viw/vBaLAA1+3AdrU1bFaMPt
         LhXH7V3YIJ60B9wiLRPUJIcMHYZMzzjQBgDti9bZfILeI0aK7M97vfLpK2YcPwihIpQh
         2SeBze0R7N4gEosu7o0tYDo+ztj5sBwJuMFEDEO0UIqE7Axq1a4si5vwkN33qkDVJF/0
         J0aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1Fb2x79U5zaHbdcvBiPOeYxbZaxlZ4awwzl5b67JIsM=;
        b=cR+ltCToCSovi/0yvktjMXufYpaTdMMcqmjmsu4zwInwfv2V/hC+CtH/AqR2xVvhcD
         MuU4QYWKi38/E4oAHDfAOjs9hOs31GgPqrASG99VbbLgisbpZkMLGq+xFJjRs5yMV/Wt
         S5tgjLjFFcjnAG6Qi3CZlAll9iIgbG3MbBihl3q095gMDk1E1MdyUeCAmKfJct1Nbkuo
         j5vEN7rIMml4JAADyV+89bwdZ/lAMPKeSTus8UowPEG8toTWubvuVGyWqJ1uVNNsQ37E
         ScEWzFr1KpdpraOUx7CuTI8VnmJrOZSi4vXDgcGoSRdHSMtwKBMhPQZ16zaLutp3SO5M
         D04A==
X-Gm-Message-State: AOAM532JMHeiCuFaSPkcL1C8C783z3IEzp/quqUQYlD31umizU7NIjoB
        cduwvPsNX1Ci4v1jOaXBNhuR7g==
X-Google-Smtp-Source: ABdhPJxsL6PpqPY6ix5HMRn40GECN+ZQ+YyV42zz/Qa0uymjHU0buUNurr3OUlzCGS0ODC+r05iJFA==
X-Received: by 2002:a17:903:1cb:b029:e5:f712:c13c with SMTP id e11-20020a17090301cbb02900e5f712c13cmr583155plh.22.1615917366104;
        Tue, 16 Mar 2021 10:56:06 -0700 (PDT)
Received: from google.com ([2620:15c:f:10:e113:95c2:2d1:e304])
        by smtp.gmail.com with ESMTPSA id gg22sm90105pjb.20.2021.03.16.10.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 10:56:05 -0700 (PDT)
Date:   Tue, 16 Mar 2021 10:55:59 -0700
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v3 3/4] KVM: x86/mmu: Factor out tdp_iter_return_to_root
Message-ID: <YFDxL657K7ApIto0@google.com>
References: <20210315233803.2706477-1-bgardon@google.com>
 <20210315233803.2706477-4-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315233803.2706477-4-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 15, 2021, Ben Gardon wrote:
> No functional change intended.

I want royalties.

> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
