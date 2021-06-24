Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3D63B32BB
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 17:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbhFXPjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 11:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbhFXPjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 11:39:04 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D6EC061574
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 08:36:45 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c15so3134352pls.13
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 08:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oSmcLkLaYmb30K4x2o5V0PgF5sReFf2n8jT9UaERRsg=;
        b=bSQo4DhU2KuL3CjUZN64j4WcwdggQch/R7XnEdix2NVuOf40qPGfYHBno8Xm619GAr
         wg2kvoNy4VPNerE1UJQqTO/mn+wSl2WW8B9f7dL8xOzOgdg74JEfehGKdbWSQ0+1rr/t
         2LEY4HKbsscIOGINiR9uO5OVpBxOglyxXqSvwqqzzZpKt1BhIehu/QDEuFSbgcAbmd1A
         2Vn5BfcWryEpw7ny/6e9BAwB13V5uLq3/TeIlPL3nNBaDSZ9vfocg3yuStOuQjDnW2a3
         vbLINUOPqFtht9Zb0kQj2xFTxtidhP/wmPjkGUm290ZvEfhGiSSc1t+MN7azCayA+NIy
         PYiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oSmcLkLaYmb30K4x2o5V0PgF5sReFf2n8jT9UaERRsg=;
        b=Bx4KTOcRwgJS5iQdEffSGEYDvwMjUrmvzp8vtNywghlQbMK7w9q1lCrmF/HTxEYsVU
         ztjr2tpElC+x/ufSKJQIqpPOPf2MWTexjYLU0F6SLQ18YweKmC5n/en9Rba8pnFG68VG
         UCVrrxfCyl+uuBQIhmxraQj9zOhFsH74IjhkfDiEyEYtyEk27s6QfkUwz2BCFfGIrWtq
         OW8PYQPQkMEwoyHg+gFy5qzPUtngq7Oi6I6wOjAemj/XnI+8JDOuelSNy8mthS74PfP6
         nL9AI7N0VufeWzaMvCOKX1U5qecMaQEvOtb/PtePFJpzHlUK9zcYIDP/ZRUf/EJvGAF/
         fWAw==
X-Gm-Message-State: AOAM5329Z5GBfjb/DAZAIrz6Rv/0+/EnZi/pfN//uMJqoII8Yv2qEWLa
        qW0jA6N6QNjsCbg/m7LQx/SvuQ==
X-Google-Smtp-Source: ABdhPJxfmbtVti63yi0rwniZ/V3vp7ddChowhbbwk916pZwapRYWPu+wwBqr+2N8fYjWJaOb0U93+Q==
X-Received: by 2002:a17:90a:8542:: with SMTP id a2mr14115924pjw.185.1624549004763;
        Thu, 24 Jun 2021 08:36:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p1sm3132065pfp.137.2021.06.24.08.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 08:36:44 -0700 (PDT)
Date:   Thu, 24 Jun 2021 15:36:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        David Stevens <stevensd@chromium.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        James Morse <james.morse@arm.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvmarm@lists.cs.columbia.edu,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 1/6] KVM: x86/mmu: release audited pfns
Message-ID: <YNSmiOsmJin4UPcG@google.com>
References: <20210624035749.4054934-1-stevensd@google.com>
 <20210624035749.4054934-2-stevensd@google.com>
 <1624524156.04etgk7zmz.astroid@bobo.none>
 <4816287a-b9a9-d3f4-f844-06922d696e06@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4816287a-b9a9-d3f4-f844-06922d696e06@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 24, 2021, Paolo Bonzini wrote:
> On 24/06/21 10:43, Nicholas Piggin wrote:
> > Excerpts from David Stevens's message of June 24, 2021 1:57 pm:
> > > From: David Stevens <stevensd@chromium.org>
> > 
> > Changelog? This looks like a bug, should it have a Fixes: tag?
> 
> Probably has been there forever... The best way to fix the bug would be to
> nuke mmu_audit.c, which I've threatened to do many times but never followed
> up on.

Yar.  It has only survived because it hasn't required any maintenance.
