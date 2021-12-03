Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A165C467E16
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 20:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382791AbhLCT0B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 14:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353611AbhLCT0A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 14:26:00 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D744C061751
        for <kvm@vger.kernel.org>; Fri,  3 Dec 2021 11:22:36 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id j11so4047618pgs.2
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 11:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/90PCdFLYo7iabwSg/5r4Oa0mkLy5fk4gqP0uy7XyaQ=;
        b=LEgwlZN0NSitU9fDxS6Uu49vw2fLHNNi5i4ybvCu8PX5td6BhB8D3MPzr8I3yPb/MZ
         7VJvEADOuKMKsRL4oVY70B4/E2haJeIj0kGEVbuk8uLXNa7NU58QSKJrZFxC96qCo16b
         V4/o58b0tqJycHrx/x6BjFjsjlFNetNSNZJXsrHzvJpzAGaaGXCpezuGDOVPW3DQTdQd
         nvJTWPV9E+uGXKpCn6eju2PcXJ1s6FvQflhN0lWQebxR3pcpO2knyjrC/9cz+56FPkMk
         5muCpD9PI9pWhaIqPrWv/7nMl29xzMLx/k9xG5i448kmnnhOMwey0Hhwrow0OAd1HZ6z
         lhyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/90PCdFLYo7iabwSg/5r4Oa0mkLy5fk4gqP0uy7XyaQ=;
        b=Ca/8WICwzlQAdlyc+TFFwuzKqKBVs4wGTJg5PqQRDxKot3rNvqt7znOv1adTV4crUE
         l0OxvBHU50S3a1NvhkyBjYnf9tOx6U+jKvpu9JK/XOU4qA1y6JS5z3jIY0FhJC6Vo3PI
         hbpyF9nPedPzaZl3CqxjMkaVc6lJjzAsEdi+OJu51U40vJkYedUh1WBHSY+NZxS8W2LK
         +y5SHHt0zJuu+PsihOQExLE9PYLysl+v6v5MSH/ke9Iq17EU0XwcbCc++H2+GR+5UFN9
         nhxb0y5wFIl1M+xmRYrP20fSZEpXDsUviIei2Y0d1KG/W2vuQ6NOgs3DupYt9m2Kf7ee
         HhmQ==
X-Gm-Message-State: AOAM5326JMCustrHp0F1wqUEzE2iREi5ymAKXOQYl3BPiw9vq85fIGXX
        71rGhKcTwGcHg9OwaCuMc/seHg==
X-Google-Smtp-Source: ABdhPJwSMQSLYnVpQfE2DqpTRcbO41suJFGcIGZaIrVpjeF0pLM58qiyEyk5atUB/Oz7fZZpnT5dog==
X-Received: by 2002:aa7:88d6:0:b0:49f:dd4b:ddbc with SMTP id k22-20020aa788d6000000b0049fdd4bddbcmr20865509pff.31.1638559355814;
        Fri, 03 Dec 2021 11:22:35 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z22sm4463902pfe.93.2021.12.03.11.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 11:22:35 -0800 (PST)
Date:   Fri, 3 Dec 2021 19:22:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH] KVM: SVM: Do not terminate SEV-ES guests on GHCB
 validation failure
Message-ID: <Yapud4DmBwvNHXBi@google.com>
References: <b57280b5562893e2616257ac9c2d4525a9aeeb42.1638471124.git.thomas.lendacky@amd.com>
 <YapIMYiJ+iIfHI+c@google.com>
 <9ac5cf9c-0afb-86d1-1ef2-b3a7138010f2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ac5cf9c-0afb-86d1-1ef2-b3a7138010f2@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 03, 2021, Tom Lendacky wrote:
> On 12/3/21 10:39 AM, Sean Christopherson wrote:
> > On Thu, Dec 02, 2021, Tom Lendacky wrote:
> > > +			goto e_scratch;
> > >   		if (kvm_read_guest(svm->vcpu.kvm, scratch_gpa_beg, scratch_va, len)) {
> > >   			/* Unable to copy scratch area from guest */
> > >   			pr_err("vmgexit: kvm_read_guest for scratch area failed\n");
> > >   			kvfree(scratch_va);
> > > -			return -EFAULT;
> > > +			goto e_scratch;
> > 
> > Same here, failure to read guest memory is a userspace issue and needs to be
> > reported to userspace.
> 
> But it could be a guest issue as well...  whichever is preferred is ok by me.

Arguably, any guest issue is a violation of the guest's contract with userspace,
and thus userspace needs to decide how to proceed.  E.g. userspace defines what
is RAM vs. MMIO and communicates that directly to the guest, KVM is not involved
in deciding what is/isn't RAM nor in communicating that information to the guest.
If the scratch GPA doesn't resolve to a memslot, then the guest is not honoring
the memory configuration as defined by userspace.

And if userspace unmaps an hva for whatever reason, then exiting to userspace
with -EFAULT is absolutely the right thing to do.  KVM's ABI currently sucks and
doesn't provide enough information to act on the -EFAULT, but I really want to
change that as there are multiple use cases, e.g. uffd and virtiofs truncation,
that shouldn't require any work in KVM beyond returning -EFAULT with a small
amount of metadata.

KVM could define its ABI such that failure to access the scratch area is reflected
into the guest, i.e. establish a contract with userspace, but IMO that's undesirable
as it limits KVM's options in the future, e.g. IIRC, in the potential uffd case any
failure on a uaccess needs to kick out to userspace.  KVM does have several cases
where it reflects these errors into the guest, e.g. kvm_pv_clock_pairing() and
Hyper-V emulation, but I would prefer we change those instead of adding more code
that assumes any memory failure is the guest's fault.
