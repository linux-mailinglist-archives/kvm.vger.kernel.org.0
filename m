Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F0433F6B4
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 18:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhCQRYb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 13:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbhCQRYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 13:24:20 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2A8C06174A
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 10:24:20 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id x26so1596077pfn.0
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 10:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rRAvRzhltoTzPQtf/yR8e3Dd74K9EO0zqzHJWWfU39k=;
        b=TVhHIE8e9q+oWf3oSYc+aY0MU9ukm6lmZmv4FZJ5W4K25ppzFu5it2w8B7qffhzSRv
         Mo+L+b5rrbxu7rn8tABYZcU+fmjNnHjAeKQjjEASrzmEBkTNIGwf8yrtMgqQlSncMfLk
         Eo5O0xosPCyZ/gcJWzQbU6I2ysVv97vbF4+SUEnuTKcQx9ivS9j26pQMCVwXb119U1MB
         GMIe/vdsL1NSqUvlOGGBk8/L/z6BySr8oqabY2yXIBWb6N4VPp81I7M8gpjk51k0e29M
         2BEKUibiB6pKdm4ViXspwPv56Plp5iWabxYawFNILH3cXaMHGu0leuLPErM3i+OSxMsK
         UwAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rRAvRzhltoTzPQtf/yR8e3Dd74K9EO0zqzHJWWfU39k=;
        b=ATx5XyLKNyMa3YBIxum4vHPKcplWu3sppNQi5/5TKZ2LWDfh0/wh3mwhesND2SPzi7
         yLfewnNDEsJ9wwiBF1frO0b/Qm6G6tPm6rdchrRqbsYZwqyViB2XxgjBylzFQUMB4l9g
         HLreCMb7a2j0YPvj8KejnUv+8k3o5D2KxrH8X5+e8bCEMj8Qh7/QKwxuXOpQ7piBC2Vx
         TANOIUCagWSIRsgPCy+2ro5B4J8Oxlz3TqrRGFl7+4StHRCz77c5AfTVpTCXx7WvGn+7
         Sa1wbf5tec+ElvmF8bnHzKBczTU0szWiDQHCsv8kaX1CkVvy4iBmgPDeXep6KZw0KdQF
         c1QA==
X-Gm-Message-State: AOAM5334HZIBSVO6jU2T8UfOzliLCLURRazgnh1AcYsSuhIjFlzxugRK
        VdsmieDilSk2JCYo/I54fKHzAg==
X-Google-Smtp-Source: ABdhPJwBDYT+a/TlslGBNP28WC6W30stDoCs/vWDziufpSQtKsns/uOp9AkNKNZWQxzXg7kaHuZg1g==
X-Received: by 2002:aa7:96cc:0:b029:202:6873:8ab4 with SMTP id h12-20020aa796cc0000b029020268738ab4mr96915pfq.42.1616001859907;
        Wed, 17 Mar 2021 10:24:19 -0700 (PDT)
Received: from google.com ([2620:15c:f:10:e113:95c2:2d1:e304])
        by smtp.gmail.com with ESMTPSA id q184sm19891630pfc.78.2021.03.17.10.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 10:24:19 -0700 (PDT)
Date:   Wed, 17 Mar 2021 10:24:13 -0700
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Yuan Yao <yaoyuan0329os@gmail.com>
Subject: Re: [PATCH 2/4] KVM: nVMX: Handle dynamic MSR intercept toggling
Message-ID: <YFI7PTT5W7vzAK+i@google.com>
References: <20210316184436.2544875-1-seanjc@google.com>
 <20210316184436.2544875-3-seanjc@google.com>
 <66bc75f6-58c5-c67f-f268-220d371022a2@redhat.com>
 <YFIzbz6S5/vyvBJz@google.com>
 <fe8329d4-3b80-7eda-a2ab-be282b4aa31b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe8329d4-3b80-7eda-a2ab-be282b4aa31b@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 17, 2021, Paolo Bonzini wrote:
> On 17/03/21 17:50, Sean Christopherson wrote:
> > > Feel free to squash patch 3 in this one or reorder it before; it makes sense
> > > to make them macros when you go from 4 to 6 functions.
> > I put them in a separate patch so that backporting the fix for the older FS/GS
> > nVMX bug was at least feasible.  Not worth it?
> 
> Going all the way back to 5.2 would almost certainly have other conflicts,
> so probably not.

I'll do a dry run before posting v2; if it's clean I'll leave things as is, if
it's a mess I'll move the macro patch earlier.

Thanks!
