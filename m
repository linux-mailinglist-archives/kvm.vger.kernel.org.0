Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70FB510655
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 20:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350097AbiDZSOH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 14:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349858AbiDZSNo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 14:13:44 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B16519C1A
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 11:10:36 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id j8so30956115pll.11
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 11:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZORZySDLTvyCNgdBbwRFHcwEwqBwbIWR7Tx5QzVSWGE=;
        b=nRy4uP+UnJR573Ccvvv+00rjQe9yzjfcSZHjF6ZszjZVwJ+74kxeqicdddSwA4AySW
         QiywMnfiRKQJoYAbe0818PihuTCRLZtC+AakP9TZ/odgItW0iwIoPnJet0E4LfDuO1tI
         djolKaBODkElc4KwCm0uph7QM0Sjw27czOW+yCf5h1wnQ8eq6IbfBsyNahmzZWuhzzGJ
         emnegDKSQVWpWX+0+abP7/v5Pt/8zbnapHuOi0skQR61t5b+29DMTJNr9TJR+gP3HD1Y
         g0zEaJP2/vShGBxGQFhkh39e6R7xzBJ3CyihXHS2qhGTgL511vBLiaRDHHrr2lnTAltK
         ORcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZORZySDLTvyCNgdBbwRFHcwEwqBwbIWR7Tx5QzVSWGE=;
        b=0lX30/lrwsr58y2F5WLQ75CwSMS2NbkUnT90YRxSGmuRfiq1gN1olJv508vOK1gmPP
         MIxURVtX+ClFKzTTpl6iPTLbHfZKWDrrV02iktFUsDIksnsYf+hiPvS+D6w/oOST0t9+
         mff5U60nymVDC7IDhl7FyM0Ma2Pij6+BVQVoeGaDAc1qfE4OFbyt7CJmFhK0yT54YUNA
         kob0aakjzycNk135LOFeZekg63VF3vqhVMCtdQWUxrzV6XJtVfLT7MdVNd4h+N/um2lD
         BSov03pNRChaVM2Q3HwYDv1Q5S9FL1yODMNmRD66qr2erlhl8W07zlth//BqCZg82Bmp
         FwNg==
X-Gm-Message-State: AOAM530x3lfWTg4I64DmN9UBaKWAN/DAo3sQOQElAhcxvCJpuBmgL7uZ
        zC79No2pvomgMT7A019ZTp7vnQ==
X-Google-Smtp-Source: ABdhPJyQti4UDb8SIgvOehAYVOKly99ZaS3C26oABwMp0uyd+LenHASMj2b+khqcefb52xC3qwJLpg==
X-Received: by 2002:a17:902:a981:b0:156:52b2:40d6 with SMTP id bh1-20020a170902a98100b0015652b240d6mr24856860plb.34.1650996635603;
        Tue, 26 Apr 2022 11:10:35 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f8-20020a17090aa78800b001d9781de67fsm3552353pjq.31.2022.04.26.11.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 11:10:35 -0700 (PDT)
Date:   Tue, 26 Apr 2022 18:10:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mingwei Zhang <mizhang@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: add lockdep check before
 lookup_address_in_mm()
Message-ID: <Ymg1lzsYAd6v/vGw@google.com>
References: <20220327205803.739336-1-mizhang@google.com>
 <YkHRYY6x1Ewez/g4@google.com>
 <CAL715WL7ejOBjzXy9vbS_M2LmvXcC-CxmNr+oQtCZW0kciozHA@mail.gmail.com>
 <YkH7KZbamhKpCidK@google.com>
 <7597fe2c-ce04-0e21-bd6c-4051d7d5101d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7597fe2c-ce04-0e21-bd6c-4051d7d5101d@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26, 2022, Paolo Bonzini wrote:
> On 3/28/22 20:15, Sean Christopherson wrote:
> > > lookup_address_in_mm() walks the host page table as if it is a
> > > sequence of_static_  memory chunks. This is clearly dangerous.
> > Yeah, it's broken.  The proper fix is do something like what perf uses, or maybe
> > just genericize and reuse the code from commit 8af26be06272
> > ("perf/core: Fix arch_perf_get_page_size()).
> > 
> 
> Indeed, KVM could use perf_get_pgtable_size().  The conversion from the
> result of *_leaf_size() to level is basically (ctz(size) - 12) / 9.
> 
> Alternatively, there are the three difference between perf_get_page_size()
> and lookup_address_in_pgd():
> 
> * the *_offset_lockless() macros, which are unnecessary on x86
> 
> * READ_ONCE, which is important but in practice unlikely to make a
> difference

It can make a difference for this specific case.  I can't find the bug/patch, but
a year or two back there was a bug in a similar mm/ path where lack of READ_ONCE()
led to deferencing garbage due re-reading an upper level entry.  IIRC, it was a
page promotion (to huge page) case, where the p*d_large() check came back false
(saw the old value) and then p*d_offset() walked into the weeds because it used
the new value (huge page offset).

> * local_irq_{save,restore} around the walk
> 
> 
> The last is the important one and it should be added to
> lookup_address_in_pgd().

I don't think so.  The issue is that, similar to adding a lockdep here, simply
disabling IRQs is not sufficient to ensure the resolved pfn is valid.  And again,
like this case, disabling IRQs is not actually required when sufficient protections
are in place, e.g. in KVM's page fault case, the mmu_notifier invalidate_start
event must occur before the primary MMUs modifies its PTEs.

In other words, disabling IRQs is both unnecessary and gives a false sense of security.

I completely agree that lookup_address() and friends are unnecessarily fragile,
but I think that attempting to harden them to fix this KVM bug will open a can
of worms and end up delaying getting KVM fixed.
