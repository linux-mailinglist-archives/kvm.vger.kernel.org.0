Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592FC3B2212
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 22:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhFWUzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 16:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhFWUzh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 16:55:37 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4BEC061768
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 13:53:16 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id v13so1795440ple.9
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 13:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y36xbe3WJsujVSzScEvLHjGt0hwiw4fc3JAqaosgr04=;
        b=cDYjZBjEqPIoMziHRVH86hrF5R4dCBqimcc/4MMEewnm6OVZG7u4FHJJr5+UXMdjuZ
         5THc0L3XBAsJ3I7WmIB8eXt5sCYKPpvEV27YOOMpMi6ulkyhvREvyr3pf1HiHSkgQpaj
         tZzfjhV63Re+3um7G/2wJ5Fwubfr+rkXM8iJHY33Vc2xVy/WgkuGBd/ZfhxYRP7TNu3O
         7uxLrCDglCSAdS1B38T2HpgTXu0YKBRm/9JJOmuaXIK5UROHlQqghiSb+zidvWSOAvHm
         uolucEcmV1uvmyuiG70LAArRx7XSXoHClFlvszof0izI0HI4xqkU2jZQZ9aGmKg/5r8i
         1evg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y36xbe3WJsujVSzScEvLHjGt0hwiw4fc3JAqaosgr04=;
        b=CxL0PYWW5HhpKycsLKoutrUeOOWNG16FKZBIss/mqSZZ2tRBwr+ajALe4h5adcZTuM
         Zb3Or3tjE5U+33/YPRdxV7MjgodVvYfmNXQIq0yGu8rqTzRZ9EK99KtwjiwUUbqxqqMS
         P+iVpPoLtfKJmvp27FwCN9RghMk0OWwov9CxBHYnlYsTtXC/nZv6gzlkouaqnB/acvOc
         lwDGEbx//c4M7vGGPO2ey8LliJBXwYwqjcScj88S4U47tjCC9+0vhS7UI8xG9CSn0/Sv
         vF+g1OGC7KSEghuS4dWY0CYCxxo+ggMZbXkAsNCOsQp10SvK9tEmR44C4WJ2X8vg75vE
         ltvg==
X-Gm-Message-State: AOAM530P+rtyjW9EmUmUxAjaAb4ehn/46DkBAAeMOFtZ/sdRSmkRZp77
        7kWk0+hZjdvzVub1l9ErCsXhwg==
X-Google-Smtp-Source: ABdhPJx+geZBK0dKMIq4V7Wk3I+sqmSci7VbrgTS4J+LQIrxtxhkO7ypCFotd+vhgmQy7bdv/8KDfg==
X-Received: by 2002:a17:90a:b390:: with SMTP id e16mr1530112pjr.197.1624481595429;
        Wed, 23 Jun 2021 13:53:15 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d13sm646515pfn.136.2021.06.23.13.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 13:53:14 -0700 (PDT)
Date:   Wed, 23 Jun 2021 20:53:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 41/54] KVM: x86/mmu: Consolidate reset_rsvds_bits_mask()
 calls
Message-ID: <YNOfNydVOEYsl04t@google.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-42-seanjc@google.com>
 <b2b61da6-613c-f3cd-d974-a7e30d356244@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2b61da6-613c-f3cd-d974-a7e30d356244@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021, Paolo Bonzini wrote:
> On 22/06/21 19:57, Sean Christopherson wrote:
> > Move calls to reset_rsvds_bits_mask() out of the various mode statements
> > and under a more generic !CR0.PG check
> 
> CR0.PG=1, not =0.

It's always some mundane detail!
