Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F31435436
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 21:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhJTUAZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 16:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhJTUAY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 16:00:24 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BBFC06161C
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 12:58:09 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id a15-20020a17090a688f00b001a132a1679bso1384283pjd.0
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 12:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G6IfeeDqmFRv+VNtJlNo9DpC30gRRzFoDk1z7x5hNO8=;
        b=UOA8a+4Np44D2xq735OqnRfuypdBh3qtBnA5O1r6TG2IBy5JLXCbbQBtXZaUGQAsz7
         g60sVHTWjwXheRuKDOw5bijCe+c5QSBpzJoQXJ2czBe3d5nLOxE9HYjL2pFHzAhp7/1o
         RHdYync3Q1JECBxEOSz6ss9YhVboo5Yewcv/VXao+WVtXlsKNPVRfIwBWA26FMD7uPMT
         pfGdruTujugwtLyj5Zv9w+f+Vv5/JnGCf67andCr7j0MVoMgyDrOzcqi/wLjWxYNQwmc
         yfC5I6Btv5zEsauEnoP/Q9jqL3ueKF1rrAcdSm82yO82LGtWEp0IL8GFm3RRwnLd0E1e
         ICDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G6IfeeDqmFRv+VNtJlNo9DpC30gRRzFoDk1z7x5hNO8=;
        b=RzP/no6XET2vcPm2L22Okl8lSdVMfWw3OAt+35LoxvbRFHB+v5ozClHEWN04TGdaOo
         jsiLUFdhESgcR6BGbQVHFBlrMPOHIRLeCWNxvgMtgqmRB9p1tIPfRkz8x+GeZUcxr2tD
         ryCQL8u3PKD3fb7AXbdq2Snx+Nu0qR6jQWbaDbZp0QBRv99Dof91JqY4NoVS9g0nw3uQ
         08tOoc8wPHp3EkGADBmZTyuTxuNlVqVgSMcV6WZQi15O9ammdNDzYH/OXBCk/O6+7T/r
         ZLb8gCHPqGKUr//f4HTgXv/sZaVAXt3I+hDrCVLGXzCiF6nUcXrR02lhjFL3bdcjIysS
         AdLw==
X-Gm-Message-State: AOAM533UxzzY33fUi7H0Vzjckhfe398McXSM36rK91zeDfzVAX7BY9FT
        E7UyYGbHt8X1WRFzPwaE2L2o3g==
X-Google-Smtp-Source: ABdhPJyN4i2sjcHHWfmZFOTg5QI2Q/wSRpwCD3REu1VHOvdghL0F/YPTj2wIJqRSXt2EhLRzrdBg9A==
X-Received: by 2002:a17:903:234d:b0:13f:3180:626a with SMTP id c13-20020a170903234d00b0013f3180626amr1089626plh.49.1634759889029;
        Wed, 20 Oct 2021 12:58:09 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id js18sm6855603pjb.3.2021.10.20.12.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 12:58:08 -0700 (PDT)
Date:   Wed, 20 Oct 2021 19:58:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/13] KVM: Scalable memslots implementation
Message-ID: <YXB0yHIdyeZA1kIb@google.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <YW9Bq1FzlZHCzIS2@google.com>
 <23a68186-8154-0e9e-b27a-5df5ab1c6546@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23a68186-8154-0e9e-b27a-5df5ab1c6546@maciej.szmigiero.name>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021, Maciej S. Szmigiero wrote:
> On 20.10.2021 00:07, Sean Christopherson wrote:
> I have always used the chronological order but your argument about
> reviewers being able to quickly see the delta makes sense - will switch
> to having the latest changes on the top in the next version.
> 
> By the way, looking at the current https://lore.kernel.org/lkml/ at the
> time I am writing this, while most of v3+ submissions are indeed
> using the "latest on the top" order, some aren't:
> https://lore.kernel.org/lkml/20210813145302.3933-1-kevin3.tang@gmail.com/T/
> https://lore.kernel.org/lkml/20211015024658.1353987-1-xianting.tian@linux.alibaba.com/T/
> https://lore.kernel.org/lkml/YW%2Fq70dLyF+YudyF@T590/T/ (this one uses a
> hybrid approach - current version changes on the top, remaining changeset
> in chronological order).

Some people are heathens that have yet to be enlightened.  Rest assured I'll do
plenty of prosthelytizing should they ever post to arch/x86/kvm ;-)
