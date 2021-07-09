Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA683C2930
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 20:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbhGISsu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 14:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhGISst (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 14:48:49 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2BEC0613DD
        for <kvm@vger.kernel.org>; Fri,  9 Jul 2021 11:46:05 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id p9so6229222pjl.3
        for <kvm@vger.kernel.org>; Fri, 09 Jul 2021 11:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=03WaUE4yGnrglOC0F5DNDGUDgKfsrgIacITJ1JOoE3E=;
        b=jbNTpYGX+CWu0bJFcsTRIbau9YcGDkGtpNHdzMNgrBJvtt3/rrFAfNTw0Yqjj2vNPp
         keX6txO8TWHbMUbo3MnAQZYZsLPdUQWw/urvhIse7RK+GPaY4coUw294QVghOsuNh3Dg
         A62ezQvW/gnbGvaO/NGYQS0/1xO8DGprqQznLy5zGnDiI1pA9AIop8g/7AfVRERtYcev
         vTh9spzXhNWF3vBKowE4i/LrHhYRtsoZlkIGCwwfxYZkUH9moh4krGgIqqB2YLTDFAy8
         +0Ms4pQ0myhwFoptfT4C6wgCnECiHuNlCe1TRlD7vcG4sRZb5apKmxNcvKEeMi71pJP/
         8HeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=03WaUE4yGnrglOC0F5DNDGUDgKfsrgIacITJ1JOoE3E=;
        b=d06DCVNwn0Bu7/xzqUMBwMmQypc4ybPc1iz/0pT4nTZPtCDXqDCa9ZkHvvYiQsIaN/
         tBT59eRYpyzF0Q1q5lew9jUFrBdaXNAGqH9MSCtK/WiQSfGvbjuL1ROj1ptzJpaRv+0v
         zhC0zjtmaxbGGtqFZVQRfkEqVGqclKnVnhs7xclLBD9DB9tuxZtPem9E58hx+tmsepFV
         eooK2MNQdeRjwxC8G7AGEeJNScfz4sQrbAKcFOgRfdcrihwt1xrUI6/dJFHrrusV+lUZ
         ATQt8Zk8JZ9HsF6RMIo0VAL+KVhBEF7XillRCruBvKmp422XIHM/tqbOl5Fm/CRLv7Zp
         tewA==
X-Gm-Message-State: AOAM532YB6+CXT+nYRiM1nX/t9qVWF4hwDun7sjUVaeY4A6xFtS0+epB
        OYiRVBJLZW0OKMVLGYxC5FkYBbeTWX1KFj2S
X-Google-Smtp-Source: ABdhPJy/8e2ap0WmrqgYGohRoOCcKst4mmupGiqA8b7dH2YxazPtGl2CESRLyVazZFWn2AgjY7QPmw==
X-Received: by 2002:a17:902:e843:b029:129:acb4:2464 with SMTP id t3-20020a170902e843b0290129acb42464mr17713825plg.77.1625856364451;
        Fri, 09 Jul 2021 11:46:04 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id d6sm7916006pgq.88.2021.07.09.11.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 11:46:03 -0700 (PDT)
Date:   Fri, 9 Jul 2021 18:45:59 +0000
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 4/6] KVM: x86/mmu: fast_page_fault support for the TDP
 MMU
Message-ID: <YOiZZ2eIO/0otfst@google.com>
References: <20210630214802.1902448-1-dmatlack@google.com>
 <20210630214802.1902448-5-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630214802.1902448-5-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 30, 2021 at 09:48:00PM +0000, David Matlack wrote:
> Make fast_page_fault interoperate with the TDP MMU by leveraging
> walk_shadow_page_lockless_{begin,end} to acquire the RCU read lock and
> introducing a new helper function kvm_tdp_mmu_get_last_sptep_lockless to
> grab the lowest level sptep.
> 
> Suggested-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     | 55 +++++++++++++++++++++++++++-----------
>  arch/x86/kvm/mmu/tdp_mmu.c | 36 +++++++++++++++++++++++++
>  arch/x86/kvm/mmu/tdp_mmu.h |  2 ++
>  3 files changed, 78 insertions(+), 15 deletions(-)
> 

...

> +/*
> + * Must be called between kvm_tdp_mmu_walk_shadow_page_lockless_{begin,end}.
> + *
> + * The returned sptep must not be used after
> + * kvm_tdp_mmu_walk_shadow_page_lockless_end.
> + */

The function names in the comment are spelled wrong and should be:

   /*
    * Must be called between kvm_tdp_mmu_walk_lockless_{begin,end}.
    *
    * The returned sptep must not be used after kvm_tdp_mmu_walk_lockless_end.
    */
