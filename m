Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA0331EE41
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhBRS1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232831AbhBRQYn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 11:24:43 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00226C06178A
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 08:24:01 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id kr16so1643068pjb.2
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 08:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7zsJa5G96QbfzfGP1GUeN5cQ6tflYt1YqBlPzygiUVU=;
        b=Op9KFq/D8S6hUm3uN8wid54j0rwTGYg0n1s/L5rbJ3861uOm8LFv1Cr0ItlKReGHlm
         0Oq/cgmC8gF2E/3AAuheF6PlVc8QGi9Y5znFhso54yshc0RKxwBT3MCn2aJGM1hILGoC
         6EQ8kOnPaQL63Ly34Jg80Lk1gqsBvZwPXJfvdGntgAElCI2fFt/4qmiH/TXwAJsOIpsX
         9mQVtwHQ4LsZYV1ka4cEuatiwMTW36nREbbXVjOjIQ8VpCQWCPfNLPzShoPrt1QKGOxG
         VO4wr2X3LawDYhGbTR+eWX3UmFjJ2ydbfhLtNB5SzAji1ijhAAdLV5IC84G1Lntgt2PV
         F+vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7zsJa5G96QbfzfGP1GUeN5cQ6tflYt1YqBlPzygiUVU=;
        b=S3e7meX8GqSmBSOdU0efRzWk4ezM3mHWaUhu5+50cw3IzUQWNDkKKDEepxg84VPPwE
         F9NnlCmlrgVFLKeaaWoy8XjgOQj/V+v9wrDNbSfeBOYjQvpun5gX/9GnypPMSdrSTl3I
         9IyLbcU3Kt31gmgQpChwHPxD0XaWrAa32oWLkI2cx6q7j9zrBMFxfSrRFzzNWcffPFlT
         xXKRjXxUc30h9LZll7JmjQB/uD9blGrDr544PWjBbHDdo++NPjIpxsfL8/P/rQ0ngQov
         zHB+1qcONvA2qZl2aJEHwBAv+STuZef8CWRcTJ11IrZ9Lc43a5mJhRsNzXeLFggvCe8M
         ZOxw==
X-Gm-Message-State: AOAM533QXFxuQesY40AT5pQsQYS9/bcdV5gZBE8vDidv5QDfBBFQy9pc
        x/2OMonUj2CFp1l+Bf+5Kvc4jA==
X-Google-Smtp-Source: ABdhPJwQbfGU3Wbtmu5ZkDWW8j1ysqNCykojI28OXgaOS4Yu8u6jFFg02JjmGh6SpqzKahhgI7b47g==
X-Received: by 2002:a17:90a:ac14:: with SMTP id o20mr4668126pjq.171.1613665441048;
        Thu, 18 Feb 2021 08:24:01 -0800 (PST)
Received: from google.com ([2620:15c:f:10:dc76:757f:9e9e:647c])
        by smtp.gmail.com with ESMTPSA id y12sm5736500pjc.56.2021.02.18.08.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 08:24:00 -0800 (PST)
Date:   Thu, 18 Feb 2021 08:23:54 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Makarand Sonare <makarandsonare@google.com>
Subject: Re: [PATCH 05/14] KVM: x86/mmu: Consult max mapping level when
 zapping collapsible SPTEs
Message-ID: <YC6UmukeFlrdWAxe@google.com>
References: <20210213005015.1651772-1-seanjc@google.com>
 <20210213005015.1651772-6-seanjc@google.com>
 <caa90b6b-c2fa-d8b7-3ee6-263d485c5913@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <caa90b6b-c2fa-d8b7-3ee6-263d485c5913@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 18, 2021, Paolo Bonzini wrote:
> On 13/02/21 01:50, Sean Christopherson wrote:
> > 
> >  		pfn = spte_to_pfn(iter.old_spte);
> >  		if (kvm_is_reserved_pfn(pfn) ||
> > -		    (!PageTransCompoundMap(pfn_to_page(pfn)) &&
> > -		     !kvm_is_zone_device_pfn(pfn)))
> > +		    iter.level >= kvm_mmu_max_mapping_level(kvm, slot, iter.gfn,
> > +							    pfn, PG_LEVEL_NUM))
> >  			continue;
> 
> 
> This changes the test to PageCompound.  Is it worth moving the change to
> patch 1?

Yes?  I originally did that in a separate patch, then changed my mind.

If PageTransCompoundMap() also detects HugeTLB pages, then it is the "better"
option as it checks that the page is actually mapped huge.  I dropped the change
because PageTransCompound() is just a wrapper around PageCompound(), and so I
assumed PageTransCompoundMap() would detect HugeTLB pages, too.  I'm not so sure
about that after rereading the code, yet again.
