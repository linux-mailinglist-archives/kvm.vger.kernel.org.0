Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF12C36AD
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 16:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388666AbfJAOIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 10:08:09 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:41176 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbfJAOIJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 10:08:09 -0400
Received: by mail-io1-f67.google.com with SMTP id n26so19737474ioj.8
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2019 07:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DM2qd9rwVNe5ohYSsCPbSX145etPoWf7FD8PQHuASpw=;
        b=fKCMpfEBIVdNuKGRPt0ntVIZrebtT3rcTGZU/vsphOt+traJKtZPabqYHb19yjjgU7
         oryufrAJJ6ZK74qfhWRidsSeujevhA7l3cnJSP1Nswar40H8luPPege/cwtMZfVsYd3i
         LkpLkgZbB1TSc94IJnMqORGYCjUbH/hjgx8eCDCPEVC73Bayo4lg7eQZfZzfB/RyrJFT
         3EkTs1iRHI9CTUTmx1tnOa8uW9xgT320OuA5jM8ReiQS9VdyksZDNgkhp1KcCNb+w/Pf
         U3QppuFrIGAoLMGnPBcO3k4Fkc7nurI+eovRZ0RvZIoIIstMZusrFCppq9LbKK+S17jt
         n5CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DM2qd9rwVNe5ohYSsCPbSX145etPoWf7FD8PQHuASpw=;
        b=i/1n1k0E3LZFETGR7x6HSnjouLdLlOJArM80fvjyTfY1pcrcKkd/RrIDbbQNDKYCMv
         HAnl7O/B/E+yaR2UttnVISw1ZYFc7jNkv1BHVlFhT2K5hcHEOc+Nw2pevi2lt5bSF1tO
         bNaUg0nUYBxB2CFChpRA7uSNfLlXgHEBID6s9vXUfdPO3EvvN3vb6Mv+kI6sMyS+exl4
         tjXj36s+s5S5uYhRt7IceeaWc0SH+JgRtnDj382ZkJhAXERV6rzcQuH2hZuidwSivBUS
         f8NgOO5VoF4ebWYO32Vke2/pUNNfM3Mq3gcvHnbxw+SnbA2SHqQmzQ0WT6Do6WFonqtR
         F3IA==
X-Gm-Message-State: APjAAAUGx+KEw9/ewdBpc6sLsgnsyumkd9ySV5SxjYipZLBmqNrJYe8i
        pLVDvL0nTNeJ0wtaZBA53B2RMDJdd7bqYPmxl3AjfA==
X-Google-Smtp-Source: APXvYqys5KhGmNgX/V4teVG6xiqlyBrfZ2cAoGpaWzr34IGkB/71Josi8gGCFydLeeipK5WL8mNjqMDvvFI1xppdsO4=
X-Received: by 2002:a02:a70c:: with SMTP id k12mr24262605jam.75.1569938887740;
 Tue, 01 Oct 2019 07:08:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190930233854.158117-1-jmattson@google.com> <87blv03dm7.fsf@vitty.brq.redhat.com>
 <08e172b2-eb75-04af-0b63-b0516c8455e1@redhat.com>
In-Reply-To: <08e172b2-eb75-04af-0b63-b0516c8455e1@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 1 Oct 2019 07:07:59 -0700
Message-ID: <CALMp9eRu42dSwuZ5ZoGmPd9A5qw7wJmfh-OhCUFaWEke2vcHkg@mail.gmail.com>
Subject: Re: [PATCH] kvm: vmx: Limit guest PMCs to those supported on the host
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Marc Orr <marcorr@google.com>, kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 1, 2019 at 6:29 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 01/10/19 13:32, Vitaly Kuznetsov wrote:
> > Jim Mattson <jmattson@google.com> writes:
> >
> >> KVM can only virtualize as many PMCs as the host supports.
> >>
> >> Limit the number of generic counters and fixed counters to the number
> >> of corresponding counters supported on the host, rather than to
> >> INTEL_PMC_MAX_GENERIC and INTEL_PMC_MAX_FIXED, respectively.
> >>
> >> Note that INTEL_PMC_MAX_GENERIC is currently 32, which exceeds the 18
> >> contiguous MSR indices reserved by Intel for event selectors. Since
> >> the existing code relies on a contiguous range of MSR indices for
> >> event selectors, it can't possibly work for more than 18 general
> >> purpose counters.
> >
> > Should we also trim msrs_to_save[] by removing impossible entries
> > (18-31) then?
>
> Yes, I'll send a patch in a second.
>
> Paolo

I thought you were going to revert that msrs_to_save patch. I've been
working on a replacement.
