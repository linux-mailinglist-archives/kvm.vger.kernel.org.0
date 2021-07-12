Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31A73C647B
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 22:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236309AbhGLUEE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 16:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbhGLUED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 16:04:03 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34380C0613DD
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 13:01:15 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id z2so6926400plg.8
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 13:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+rLcBhWpirGGNvCBuURemXk2sP7hskheyGkiGbJt51E=;
        b=uBRM2y9jMzS5eZMGUTecYGNHy/72UsRnFEYSHkEeJLQfY0tht4YXbpxoonuorO9Sua
         lDdueUiVseezT9gEtOaQD+QllN+R0hUxG+3FB4GjfX4n7si4brWfwNHV0K+ZyUG/C+bU
         C+X4KFEWUzZzBrNp8C99mmXOwmBMwD7F8zRiWGW5G1enHjDJHtbw2k8FQ6nFHyFjL5WH
         5Cc+a/GJ9mQUFUg+lc7mmIdiSjK/DR+A/xpQxBjum8eS7+c1SVSn4eOv6jzabgMuEU1I
         sq/LF1YsxXu83oBMcKLMq92EeiokzLtVTdPr0CZTz0/A5IcU3aJQwU4+xxtm2Xpprqaw
         7mTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+rLcBhWpirGGNvCBuURemXk2sP7hskheyGkiGbJt51E=;
        b=jyUs3NTBhYoYgusieWkhD7hRM4LVg8XfCRUHZa3OOzBNturU2zMcWEtqnSjkAXJ2Iu
         AHtt/4VJK7qn2jELh5Nh/SwLZ8Mdlq9ozMOvoiNvmVasQY0MwvuyTJC2WRelDVEupJsB
         l1n11CGGFxntfuNRP0YsFD4zIABFHvrwKDfS1VFicwDZzsrqj6zMh86kmghpQ7WJ8Rle
         Ob1ucDYFND+qci0UFqu4En7U0sE+vXp4olUToidEL0wnpGoaqCCiljMUjJ6orua6uTPd
         z0KxA1DRNcfrHm/pyG+crh+FxKj5X3oxqtUhMRSFN3220/bZhF5UTd4HcZSq9mfGIoWj
         vyBw==
X-Gm-Message-State: AOAM530NFDeqd2W8l5KYcmfGvfFP9OD9NpGTUNnTOarozQ2lNvdwSz2I
        XVYeFPpzqErVCNc90ihzkdnjdw==
X-Google-Smtp-Source: ABdhPJx6Pm4LA7xFpQR1Jk/CPVRc4zgaZKmQSO39tYbLAA8oPCVSmUXuS0vZYaN6edRBQGbChdHEwA==
X-Received: by 2002:a17:90a:5306:: with SMTP id x6mr593111pjh.59.1626120074354;
        Mon, 12 Jul 2021 13:01:14 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m19sm6724177pfa.135.2021.07.12.13.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 13:01:13 -0700 (PDT)
Date:   Mon, 12 Jul 2021 20:01:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/6] KVM: x86/mmu: Rename cr2_or_gpa to gpa in
 fast_page_fault
Message-ID: <YOyfhmRyN9H6mSYC@google.com>
References: <20210630214802.1902448-1-dmatlack@google.com>
 <20210630214802.1902448-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630214802.1902448-2-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 30, 2021, David Matlack wrote:
> fast_page_fault is only called from direct_page_fault where we know the
> address is a gpa.
> 
> Fixes: 736c291c9f36 ("KVM: x86: Use gpa_t for cr2/gpa to fix TDP support on 32-bit KVM")
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
