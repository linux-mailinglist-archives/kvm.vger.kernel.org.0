Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986642D0270
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 11:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbgLFKLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 05:11:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52656 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725804AbgLFKLP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 6 Dec 2020 05:11:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607249388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xji8+FhOghfu2/XZrvV9/OViBfo6B1ROea5bmQqV1JA=;
        b=a4g/Es2XRiHIuizYz65dtt1pOwMnBtY45rJzzclp0f3uTuLzKqXOmniVJhWWaSq3K5tFMj
        wa2pUxar3TNweYqgV/2+wrz+68qM+zhkiRjyPkOtYlKwHCkSoLoX52nSSvVjaM7OXNXmRI
        DC0vEYKbWW936xITvdQUd+72EPs9ljs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-brgPspAsO1u2dsbI4hIXRw-1; Sun, 06 Dec 2020 05:09:47 -0500
X-MC-Unique: brgPspAsO1u2dsbI4hIXRw-1
Received: by mail-wm1-f69.google.com with SMTP id a130so7880714wmf.0
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 02:09:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xji8+FhOghfu2/XZrvV9/OViBfo6B1ROea5bmQqV1JA=;
        b=C4cnO86/nA+g7tbVH2J6dAPaTN3NW7W/ooAM889p+UF+cUnl+g65odHDloEDaVx3fK
         g9ykssO5Son2FqMYIX1xlVljL9r+5J3TPFUynWH5oj2hj9yhadDqjqftsPR+mCUkb6Y6
         z71O/m5Bu4dOJJm4bECfdvu1Q9X4KcFJgMg5cXtZVFTv2ySfMPXCX355s+URkxPFEbTf
         CjRbg3nkylnZnbaBKQ4pk9wj1r5gzZcwHBKyCpC46bx8Qnn2AyQ+ZaIzZLqDD3vagAry
         +RJgvDtF2a0MC6J0elxKNE3umBDKQbYRH1oJxWozWEMpbv39dLBNta95CEtUQ46uDONz
         BLyg==
X-Gm-Message-State: AOAM532Dl4A5MWYD6zQSqY10MFD53rmt3EWuJ8aNx4oYBVXW8LaKVUZl
        VPjcqLiDfDOkFwCiTYSf27+uAVx4PL0lYW2HOh41z3tSaviZdt5gbDGT9M5qxNarRXYWrw6kLNM
        0XRaimxxLyLAf
X-Received: by 2002:adf:ec0c:: with SMTP id x12mr14416573wrn.307.1607249385956;
        Sun, 06 Dec 2020 02:09:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy6VBLcLDbM240XPEJbqvQy/D9PtV57yuW3xEvKi5G+E3Gz9EZOlYSr6q6a9ziYlzURpJ9FlA==
X-Received: by 2002:adf:ec0c:: with SMTP id x12mr14416555wrn.307.1607249385766;
        Sun, 06 Dec 2020 02:09:45 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id d3sm10226839wrr.2.2020.12.06.02.09.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Dec 2020 02:09:45 -0800 (PST)
Subject: Re: [PATCH] KVM: mmu: Fix SPTE encoding of MMIO generation upper half
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <156700708db2a5296c5ed7a8b9ac71f1e9765c85.1607129096.git.maciej.szmigiero@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <370db207-7216-ae26-0c33-dab61e0fdaab@redhat.com>
Date:   Sun, 6 Dec 2020 11:09:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <156700708db2a5296c5ed7a8b9ac71f1e9765c85.1607129096.git.maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/12/20 01:48, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> Commit cae7ed3c2cb0 ("KVM: x86: Refactor the MMIO SPTE generation handling")
> cleaned up the computation of MMIO generation SPTE masks, however it
> introduced a bug how the upper part was encoded:
> SPTE bits 52-61 were supposed to contain bits 10-19 of the current
> generation number, however a missing shift encoded bits 1-10 there instead
> (mostly duplicating the lower part of the encoded generation number that
> then consisted of bits 1-9).
> 
> In the meantime, the upper part was shrunk by one bit and moved by
> subsequent commits to become an upper half of the encoded generation number
> (bits 9-17 of bits 0-17 encoded in a SPTE).
> 
> In addition to the above, commit 56871d444bc4 ("KVM: x86: fix overlap between SPTE_MMIO_MASK and generation")
> has changed the SPTE bit range assigned to encode the generation number and
> the total number of bits encoded but did not update them in the comment
> attached to their defines, nor in the KVM MMU doc.
> Let's do it here, too, since it is too trivial thing to warrant a separate
> commit.
> 
> Fixes: cae7ed3c2cb0 ("KVM: x86: Refactor the MMIO SPTE generation handling")
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> ---


Good catch.  What do you think about this alternative definition?  It 
computes everything from the bit ranges.

#define MMIO_SPTE_GEN_LOW_START         3
#define MMIO_SPTE_GEN_LOW_END           11

#define MMIO_SPTE_GEN_HIGH_START        PT64_SECOND_AVAIL_BITS_SHIFT
#define MMIO_SPTE_GEN_HIGH_END          62

#define MMIO_SPTE_GEN_LOW_MASK          GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
 
MMIO_SPTE_GEN_LOW_START)
#define MMIO_SPTE_GEN_HIGH_MASK 
GENMASK_ULL(MMIO_SPTE_GEN_HIGH_END, \
 
MMIO_SPTE_GEN_HIGH_START)

#define MMIO_SPTE_GEN_LOW_BITS          (MMIO_SPTE_GEN_LOW_END - 
MMIO_SPTE_GEN_LOW_START + 1)
#define MMIO_SPTE_GEN_HIGH_BITS         (MMIO_SPTE_GEN_HIGH_END - 
MMIO_SPTE_GEN_HIGH_START + 1)

#define MMIO_SPTE_GEN_LOW_SHIFT         (MMIO_SPTE_GEN_LOW_START - 0)
#define MMIO_SPTE_GEN_HIGH_SHIFT        (MMIO_SPTE_GEN_HIGH_START - 
MMIO_SPTE_GEN_LOW_BITS)

#define MMIO_SPTE_GEN_MASK 
GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)


Thanks,

Paolo

