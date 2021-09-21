Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACCC413DFB
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 01:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhIUXXp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 19:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhIUXXn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 19:23:43 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0938BC061575
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 16:22:15 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id c1so992811pfp.10
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 16:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SrgpsGNJ8rqjyV4/EJo88O9IIQbG0UxIB/O/sCFEHCQ=;
        b=Aek6S4Ex4HL+FlRX8wezQ0nSn8PZPLVSwGFM6Tuf5Vb5PRgM0t3QLU9WUHFeTsdzAU
         QtJBZLxCtSTzHjvsrBDZHuAtRs8M/UcTtn16UVPyICkA/9SmSo6/wgDRXNjilfk6+22r
         W51t+bozYpGIBCS76o+pBdu3BTXYTvAYrWg54kKw/zUklVknkRQaSR+HYh+NPP+yi8y9
         Yb/gjfeOPPT4vB//YCwqd+j/uNNgvnBzGOO9gtxuEZPi7zBRKotpsZHqTtUaIjyqVYgT
         sIUYBMdsmRG8oPPacCtBAXZP+CTj2FLeluAQ6fbuqzgy0II1EfOxhsPqM2kyF7AdcmHW
         W4uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SrgpsGNJ8rqjyV4/EJo88O9IIQbG0UxIB/O/sCFEHCQ=;
        b=bI4v7XiPCYI8s7VXabWTnYj4s1y3TMOAyf23lpKr68ch6SmxdvmrE9aeX9ev3u+hAx
         Du9zzqC8hSbDUjLyvWbR0MvQqZLIgxZcebWv4sEyHpTsC/URnDgoE0LksyoZS+blqtV2
         MyoewDUeaKMIWPM0QVY1VkAE83sPO3hH6qMQbZSgYNkk85rBHeWVBAZwtGpB7DSqxC9r
         TN5kuFZYcuihu5bcKOWSndV9w87X4Y+R0X5ac6uZwLboDzLBODcOgASz3fYWdjHfPZps
         T1olBD108zLhDhHhEpRO2zMKgmsz4HgeJbG9hSAagw6HcMbemYjZY4wvNReJB5gF1Tqm
         1jBg==
X-Gm-Message-State: AOAM533kBRAp+lHLssG+h0DUTlpBfS7lhU0W0K9JjpbxeAIIzUCpP0u+
        QSCtbtxRFBapjKV4p78axFybDw==
X-Google-Smtp-Source: ABdhPJztKWJhnn4ll+uIjZV6ppsKBX5LhsnC09hXPT7pT0HwfgdemziHQj0i0h1tKYzjFbRFxZd+Gw==
X-Received: by 2002:a63:bf07:: with SMTP id v7mr30381034pgf.333.1632266534266;
        Tue, 21 Sep 2021 16:22:14 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gp11sm3483849pjb.2.2021.09.21.16.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 16:22:13 -0700 (PDT)
Date:   Tue, 21 Sep 2021 23:22:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     peterz@infradead.org, pbonzini@redhat.com, bp@alien8.de,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, boris.ostrvsky@oracle.com,
        Like Xu <like.xu@linux.intel.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Guo Ren <guoren@kernel.org>, Nick Hu <nickhu@andestech.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH V10 01/18] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
Message-ID: <YUppIQxphCUK6ZLS@google.com>
References: <20210806133802.3528-1-lingshan.zhu@intel.com>
 <20210806133802.3528-2-lingshan.zhu@intel.com>
 <YSfykbECnC6J02Yk@google.com>
 <186c330e-be42-4c49-545c-8f73573b5869@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <186c330e-be42-4c49-545c-8f73573b5869@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 15, 2021, Zhu, Lingshan wrote:
> 
> 
> On 8/27/2021 3:59 AM, Sean Christopherson wrote:
> > TL;DR: Please don't merge this patch, it's broken and is also built on a shoddy
> >         foundation that I would like to fix.
> Hi Sean,Peter, Paolo
> 
> I will send out an V11 which drops this patch since it's buggy, and Sean is
> working on fix this.
> Does this sound good?

Works for me, thanks!
