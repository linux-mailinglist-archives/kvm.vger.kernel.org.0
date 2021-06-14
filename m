Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC69F3A6CC0
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 19:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235265AbhFNRKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 13:10:05 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:37521 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235185AbhFNRKD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 13:10:03 -0400
Received: by mail-pf1-f177.google.com with SMTP id y15so11010316pfl.4
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 10:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OZWnLuTCvqyuWhQlLGlTTWiLo7OZl6SsOJr1Z5NIDwU=;
        b=ChNj5omZ4CwqHhyQM0jYHL1k63O8Ck8nElq9ZzoSyMrM0buXbOFs1YNkfsLa53XWsU
         ZD6kcH/T9cYetAVhAKOm+qibmGX/o82nbWljn+eX591R7AU0cVT+EE5j0Ha0z1KM48iY
         SZUSO2t1k5eoL7RXw5Q2YqLCNV8hnGXSo+KjsOlWEm3kYihN0kRf+AitX4+O40KxE1We
         tK1OVyuPnhu01afCquAaz3VBxMAL3Vd6TgzvzUwMZHmtZxNad9pxCCEJ9jRwimG16qH2
         yRbI/R3yoJwA4GL4wRrWXlPJO56g2BCsA/vnhFfxWqVzyz7UZ29JE4QQ4PU1jmsTolaZ
         UyHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OZWnLuTCvqyuWhQlLGlTTWiLo7OZl6SsOJr1Z5NIDwU=;
        b=DU+lxBUvcnqHD636O355kri1pPpnMsyheKla066WQKLQSEYV4HHCw8ijGMPEmj/L25
         kcqTCxj17YcXcgBGHuNgrW88gy9yHn7kZGDEKfgQfwTyMcZ0aoj2DSpfYsMbtM2gHQfd
         BaAyULgDVWT97ervsdQV18sJAMeTphEzSp4jt55oRxp3679x0AZjaI/bIa91KkfcaX01
         5j2qYPK7oR28MA6PPZ5ksdglg19Fq5WMAfsTwAE836jjFAPMPyUPoFJpLugjtUktKjdJ
         Dptke1vw/8s0P3WI+9E3bXEGndIdc2qu56h3QiWQY3/QtPmCZS5j9hpAQ4Zir3ScuCT5
         HL6A==
X-Gm-Message-State: AOAM531NVyMlpSotNdkPy04bptx7cn5yu+PjOthp5cUC0jkPowofuGFs
        0cXptd2baXm9xtX1GNdZOo2VNQ==
X-Google-Smtp-Source: ABdhPJyXa1kkuWkkh+PhRNm0K+7GGEb0LqnzP2+8Gc+1g5C1mQopC9bt2dmtf0lwe6NvAiNi8HNgsw==
X-Received: by 2002:a63:6e87:: with SMTP id j129mr18338809pgc.45.1623690406904;
        Mon, 14 Jun 2021 10:06:46 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k15sm46837pjf.32.2021.06.14.10.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 10:06:46 -0700 (PDT)
Date:   Mon, 14 Jun 2021 17:06:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     stsp <stsp2@yandex.ru>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: guest/host mem out of sync on core2duo?
Message-ID: <YMeMov42fihXptQm@google.com>
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 13, 2021, stsp wrote:
> Hi kvm developers.
> 
> I am having the strange problem that can only be reproduced on a core2duo CPU
> but not AMD FX or Intel Core I7.
> 
> My code has 2 ways of setting the guest registers: one is the guest's ring0
> stub that just pops all regs from stack and does iret to ring3.  That works
> fine.  But sometimes I use KVM_SET_SREGS and resume the VM directly to ring3.
> That randomly results in either a good run or invalid guest state return, or
> a page fault in guest.

Hmm, a core2duo failure is more than likely due to lack of unrestricted guest.
You verify this by loading kvm_intel on the Core i7 with unrestricted_guest=0.

> I tried to analyze when either of the above happens exactly, and I have a
> very strong suspection that the problem is in a way I update LDT. LDT is
> shared between guest and host with KVM_SET_USER_MEMORY_REGION, and I modify
> it on host.  So it seems like if I just allocated the new LDT entry, there is
> a risk of invalid guest state, as if the guest's LDT still doesn't have it.
> If I modified some LDT entry, there can be a page fault in guest, as if the
> entry is still old.

IIUC, you are updating the LDT itself, e.g. an FS/GS descriptor in the LDT, as
opposed to updating the LDT descriptor in the GDT?

Either way, do you also update all relevant segments via KVM_SET_SREGS after
modifying memory?   Best guess is that KVM doesn't detect that the VM has state
that needs to be emulated, or that KVM's internal register state and what's in
memory are not consistent.

> I've found that the one needs to check KVM_CAP_SYNC_MMU to safely write to
> the guest memory, but it doesn't seem to be documented well. Of course maybe
> my problem has nothing to do with that, but I think it does.  So can it be
> that even though I check for the KVM_CAP_SYNC_MMU, writing to the guest
> memory from host is still unsafe? What is this KVM_CAP_SYNC_MMU actually all
> about?

On x86, KVM_CAP_SYNC_MMU means that the primary MMU will notify KVM of any
relevant changes.  As you surmised, this is needed if userspace is making changes
via to mmap()/mprotect()/etc..., but is also used to react to PFN migration, NUMA
balancing, etc...

Anyways, I highly doubt this is a memory synchronization issue, a corner case
related to lack of unrestricted guest is much more likely.
