Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055F727F1A5
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 20:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgI3SyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 14:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3SyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 14:54:03 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50742C0613D0
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 11:54:01 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id q1so2939848ilt.6
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 11:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xTNb6k0KTUZX28SgX8/5ctYvSHWMCeVd2LxNdQK0xQ4=;
        b=mNVt7KwILbHTFKGN8sOmwybaVaBebXwgaoyhB8MY7W8UJSmfh8sYHOBYfD7qMeXpeq
         yHCgziCffMDqBY3VlGTYRmx99EMIRzHyzouWCV2ElzliV7zYyCK9F4aHtTe54od5qSvc
         hNsNXScsb5Pr9iUr5vlqdD5LI6T4v3gTcDMAFwT5XQevBh6GTq6RzNOPTKxCXH2ITh8S
         LgQwitquZXQP8QMrdxDhr4/OFAyviHNGvplWZpsZdaWHbbxannDN5sWcFeJojzYGBn6U
         mEk5Vqw/BILqfV49RJEwgQTD/tadT3zUg3/Wn2whqB2XV9LH5gXDf05cOh02o2ApdJSK
         1ghQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xTNb6k0KTUZX28SgX8/5ctYvSHWMCeVd2LxNdQK0xQ4=;
        b=KdX0kqR9RU+m9u2ROyBEo90KR61KlTYKnkF+0NX+u2q463P4DF5nA5XWaWOiyqmC5O
         v5JwvRRwkJxPOy0QJcDjswxFE5m1JzVJ68we6sfb9T1QvN5iyu3ttoQ/8TT23jVnFZHS
         AbxsIshM6t0qglHfISm8DwDGOl5u5q/Tk2zUiKvyDmYobUxm5cic56DuXLLbunwqGMQz
         fr5wtxJS5yD41RiF6oViGC2RmVWohQMO7iNKTj97lPCHJKgh9MZpDjg9rqrtLR6Esplk
         Dx/qT5dnGSjt23QS2Xm9L+cMoEwDBVeGbcadA4K5ADk894VwGTB1remyebZfBoT8y8/k
         1+Mg==
X-Gm-Message-State: AOAM530DmSam6CyaJTt9K3R512iGYjUBTbdgYGqrOlUGJAk+8qNagjGj
        57H71uPfFSY6qx6JjXtizdAhY3kZcIVC/S4m3DW29w==
X-Google-Smtp-Source: ABdhPJy6gFwSvJfYUnaQReXTw7OFukqCdbfGFdk4FOB5w1igPVzF3wcyMnYrwZVkhHIYJcIv0oDqmukb8rucUACJtxE=
X-Received: by 2002:a92:cbcd:: with SMTP id s13mr3111986ilq.306.1601492040319;
 Wed, 30 Sep 2020 11:54:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com> <20200925212302.3979661-12-bgardon@google.com>
 <66db4185-d794-4b3e-89c2-c07f4f2b5f2a@redhat.com>
In-Reply-To: <66db4185-d794-4b3e-89c2-c07f4f2b5f2a@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 30 Sep 2020 11:53:49 -0700
Message-ID: <CANgfPd8A4VS0Mq-QR7wgzNDMd_UYwxja=Vn7oW0KMoce8RXVww@mail.gmail.com>
Subject: Re: [PATCH 11/22] kvm: mmu: Factor out allocating a new tdp_mmu_page
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 5:22 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 25/09/20 23:22, Ben Gardon wrote:
> > Move the code to allocate a struct kvm_mmu_page for the TDP MMU out of the
> > root allocation code to support allocating a struct kvm_mmu_page for every
> > page of page table memory used by the TDP MMU, in the next commit.
> >
> > Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
> > machine. This series introduced no new failures.
> >
> > This series can be viewed in Gerrit at:
> >       https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538
>
> Maybe worth squashing into the earlier patch.
>
> Paolo
>

That sounds good to me. Definitely reduces churn in the series.
