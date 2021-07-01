Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A0C3B9883
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 00:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236885AbhGAWNv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 18:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234270AbhGAWNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 18:13:51 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E94C061762
        for <kvm@vger.kernel.org>; Thu,  1 Jul 2021 15:11:20 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id s14so7307196pfg.0
        for <kvm@vger.kernel.org>; Thu, 01 Jul 2021 15:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j0JY4R59DdEC5Z/dFbX7UkGfq0OH8BRjLV/W1lE2/Z4=;
        b=DZOuOSOmhWJ7/U7H4iQzggb9wQbQkNONXNeULilNP19spzZNg9MppvBLSqEOWZKqAa
         190oaP3HwQQJwFBFHbYHAc19RvZ7Vrf1X4/UmnoepGw3sGvvv2CK71VsSkJuPN2rs/Et
         jFsqVKuPrTrquYlGKIDr0m86u3ZvOiWN9URJS5NuqDy9zBsedXbwKP3gEgg+plRKiA1E
         80NO97JODRJDlav14B74H3g0LSl38aUm6vrwaGndcx9CjqoMlEUpaF4Slmep+jdvVw7h
         QxtK7hy6LRSaWcaAa335vyFsT7LiA6Q3x9hEAdM9n9wEfuzPvJh/1/WRfkvFe1LhW6lD
         sHbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j0JY4R59DdEC5Z/dFbX7UkGfq0OH8BRjLV/W1lE2/Z4=;
        b=HNy5lbdUJI2HPIswjO+XIi54GkOnn+lXheMUJjd/k4NirNaByemklDQC6O/pJPkvPT
         75LnMvxrKi3fLwWO4IHidS4TAVgL0PrLei+HpLLUexF1KWThL3zunl738ALmYhryFlZ2
         ynB1eG+ldQrQDqKNIT8/D+SQgVZqXLN9o3plKWzEDjdYnAEBLltkwbCnkPCUpHOk6ExB
         NaAzqhTaBdXM4vJBXGQGWrmvNQ6OlFxArb3rQbfPr2avz5qP41qHaM9xteaT930Yp3E6
         dntNCwBPrQNHfEVo6odzaJcqVHgsVQZinoJvOYfcj1UdXsB1l9SuB4/UF6zDT8t5hyuo
         OYxg==
X-Gm-Message-State: AOAM533Ls7qKsOCblqWbbAlkvnew9t8H4zPQnaLPieomXD25wPKE3bw5
        XyhhB619KltxG0sTAlu+k0Y3cA==
X-Google-Smtp-Source: ABdhPJyhlZQn5SVXbp1aEOAeF+fVBXqk/FSE4hbDmhGEotXdALntpTq46WyBtPz8Xm7WOHFIVxlBWw==
X-Received: by 2002:a05:6a00:b43:b029:312:817a:41ff with SMTP id p3-20020a056a000b43b0290312817a41ffmr2119287pfo.59.1625177479867;
        Thu, 01 Jul 2021 15:11:19 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id l12sm1018412pff.105.2021.07.01.15.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 15:11:18 -0700 (PDT)
Date:   Thu, 1 Jul 2021 22:11:15 +0000
From:   David Matlack <dmatlack@google.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 0/6] KVM: x86/mmu: Fast page fault support for the TDP
 MMU
Message-ID: <YN49g7nW4pDUMiE8@google.com>
References: <20210630214802.1902448-1-dmatlack@google.com>
 <3568552b-f72d-b158-dc49-3721375c18d5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3568552b-f72d-b158-dc49-3721375c18d5@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 01, 2021 at 07:00:51PM +0200, David Hildenbrand wrote:
> On 30.06.21 23:47, David Matlack wrote:
> > This patch series adds support for the TDP MMU in the fast_page_fault
> > path, which enables certain write-protection and access tracking faults
> > to be handled without taking the KVM MMU lock. This series brings the
> > performance of these faults up to par with the legacy MMU.
> > 
> > Since there is not currently any KVM test coverage for access tracking
> > faults, this series introduces a new KVM selftest,
> > access_tracking_perf_test. Note that this test relies on page_idle to
> > enable access tracking from userspace (since it is the only available
> > usersapce API to do so) and page_idle is being considered for removal
> > from Linux
> > (https://lore.kernel.org/linux-mm/20210612000714.775825-1-willy@infradead.org/).
> 
> Well, at least a new selftest that implicitly tests a part of page_idle --
> nice :)
> 
> Haven't looked into the details, but if you can live with page tables
> starting unpopulated and only monitoring what gets populated on r/w access,
> you might be able to achieve something similar using /proc/self/pagemap and
> softdirty handling.
> 
> Unpopulated page (e.g., via MADV_DISCARD) -> trigger read or write access ->
> sense if page populated in pagemap
> Populated page-> clear all softdirty bits -> trigger write access -> sense
> if page is softdirty in pagemap

Thanks for the suggestion. I modified by test to write 4 to
/proc/self/clear_refs rather than marking pages in page_idle. However,
by doing so I was no longer able to exercise KVM's fast_page_fault
handler [1].

It looks like the reason why is that clear_refs issues the
invalidate_range mmu notifiers, which will cause KVM to fully refault
the page from the host MM upon subsequent guest memory accesses.  In
contrast, page_idle uses clear_young which KVM can handle with
fast_page_fault.

Let me know if I misunderstood your suggestion though.

[1] https://www.kernel.org/doc/html/latest/virt/kvm/locking.html#exception

> 
> See https://lkml.kernel.org/r/20210419135443.12822-6-david@redhat.com for an
> example.
> 
> But I'm actually fairly happy to see page_idel getting used. Maybe you could
> extend that test using pagemap, if it's applicable to your test setup.
> 
> -- 
> Thanks,
> 
> David / dhildenb
> 
