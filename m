Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF26932C6D8
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346706AbhCDAaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234199AbhCCSGe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 13:06:34 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45C8C061756
        for <kvm@vger.kernel.org>; Wed,  3 Mar 2021 10:05:48 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id u12so4845556pjr.2
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 10:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fi0uubBVxUB+GuaJG69hF0VmSki/WHsri58nDTTvB9Y=;
        b=OFBbBC/qbuy5DVoTDWKAbIz+evhGUmngQud/1bqxDNXQEMNT1ErJvyZdetAQssoB8V
         w90jHsRqLy9ZJSBFSa+8YaMR4VBwhokSubrPfwfc6sNsr8FJIuLYDZpySkq1zP41xDnZ
         ip2zGb6V2byY+jXHnsndQTTEFE8/Tkpl2L9qre4GYYRNyqAoy5BBZyRl4O92ksTIFGBJ
         G9FEdYtOgCzXoKEhJDyaxoVLZFt1ZeBUbxYTl3ZBLJcV4/nsZDEFUuz3mPNBmUAFxpI+
         vSVXnOT4C6hp/vgs84OQhAzwiCVq02aEmot3yZxZPF0CB9xYwNEi4d53jTJXAPBnRwg6
         ws4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fi0uubBVxUB+GuaJG69hF0VmSki/WHsri58nDTTvB9Y=;
        b=gsNQYFyoTf/6iWfzmj6cti8AX2Jw9xiO02Dgkm/IcrPYYdUUgbzJmRId3NHeWry65E
         r4I65aawBOcmmP9NU0VMgDv6OZ8w+1lnb8qS7pqbx5Ays6iflqHrGC+4jzfyFhDPXeZh
         J9ms/OqfXHyk2DTaDFmhp26B30vsiGjhst8kG2PrPmFMka3H3aPqWBDWzYHIhgC71t0w
         iz7wwOGUawtajy8ky1xzw31hAzBDMNz1344Jr5He6B50lgXFRf1VwG4eG6l8XsWiMCvM
         KNrx7vIHCGQpVnhgiZgjf0MapWtHVMr0OK+VOFxf7VfMWuqx2ABPOJvvEb6W2mamBTnS
         2fag==
X-Gm-Message-State: AOAM532MNfzBJhhanS1Z7spv97Ss8loAtTLr+WpsVm5z/bjM9CFlCmgy
        KUqaQZCJkv1k4o0AZ8h6bti9hQ==
X-Google-Smtp-Source: ABdhPJxbC8wsZPd378cO0hva1cNnbCyc3RT9K0geIiwmjepkvWVRMfJGjacgj5mU/jhfb3+1+7+USw==
X-Received: by 2002:a17:902:108:b029:e4:9e1b:b976 with SMTP id 8-20020a1709020108b02900e49e1bb976mr191625plb.67.1614794748200;
        Wed, 03 Mar 2021 10:05:48 -0800 (PST)
Received: from google.com ([2620:15c:f:10:805d:6324:3372:6183])
        by smtp.gmail.com with ESMTPSA id z12sm7329506pjz.16.2021.03.03.10.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 10:05:47 -0800 (PST)
Date:   Wed, 3 Mar 2021 10:05:40 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, wei.w.wang@intel.com,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86: Update guest LBR tests for
 Architectural LBR
Message-ID: <YD/P9EkihjNHqrLb@google.com>
References: <20210303135756.1546253-1-like.xu@linux.intel.com>
 <20210303135756.1546253-11-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303135756.1546253-11-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 03, 2021, Like Xu wrote:
> This unit-test is intended to test the KVM's support for the
> Architectural LBRs which is a Architectural performance monitor
> unit (PMU) feature on Intel processors.

These really need negative testing, especially on the MSR values.  IMO, negative
tests should be mandatory for merging arch LBR support in KVM, it shouldn't be
too much additional effort.
