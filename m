Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE0F7D212
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 01:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbfGaXpd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 19:45:33 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37902 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728032AbfGaXpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 19:45:33 -0400
Received: by mail-io1-f68.google.com with SMTP id j6so20433629ioa.5
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 16:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rPPJInGn5mcKaK62eGkVbrjaFAcg+JQw+Axl27ql6vE=;
        b=dM/JvIQODfYw8czZ9IPfxhBOPNK/TztKjUSRlcmFQPeaLDr2O1SNPXVwau4KeZJIeD
         m/bhzguK5AX5MeKLhRXovtQNIW9REEXOeLXLxm7mRIpGAO3PklbLd4A8zSxNwSKP/Oqb
         Lhm5DoA2qGkIscJqEeP65qybIaVNiUktLQjTVPj5+adWFlh0MW5AmYXZd6drGu0JhoYA
         113AoBMq/pMH4EMo4QhQsxmDW+CdxvFkBrJDhUYOINFRik+krsBzJy/iI5M/4BdzOpln
         Pk5MH+LgIH7YpxuJjm+m31TqvEHErBQsaJ3pOMhJLsEusO3UOcla8NBnpiF024TczZay
         3Hag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rPPJInGn5mcKaK62eGkVbrjaFAcg+JQw+Axl27ql6vE=;
        b=T0yLFxMx5eNEgGQAFpPk/oFP1AyS+vdPW7iKOpHiEZUqSbqO+IJnqYELsqCy8sVNGm
         PaaH/AUywVRGXwxD5c6SfJfDd7bjphXQfaTITejgyf3U27UonGacO3iAzTokITaMFRLM
         Uqyw5U/JeD6MAo7Ak0pTNiyp7GgF7hYg2o2WvnQBNFNhi5KQKBD96pdTvbM8I8e9S1YD
         TSXlM6YNDjW/O9rGj6+y9J/5+8TVMmzG0ynOfrpM98lawkARtXU+6seYP3rDuku3PMRD
         /kd4is3hNQ8iJ3OyghfP75OJ0OuaU/hTk4inQDEpV+UdJ6uGvgIfbSBOhF65v1ceXRFD
         CGLw==
X-Gm-Message-State: APjAAAWiJvPKX3/GFQM0S4n2ZsETKQZJrPEEiU3k7dzqOeqLXBOOQsF7
        LIxdpMlmM88s9lHtAv5FDCAUpuTAszOYUr2zN2PZdQ==
X-Google-Smtp-Source: APXvYqxsAnlo0HnFzOoBpzX+/vkVOreIRE1vIVYBe7yxFQriMXMo/a7UaidTN0LxSPRocHjQy0k75hCc8NIXhMTb6Bk=
X-Received: by 2002:a5e:8508:: with SMTP id i8mr122215860ioj.108.1564616732306;
 Wed, 31 Jul 2019 16:45:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190620110240.25799-1-vkuznets@redhat.com> <20190620110240.25799-4-vkuznets@redhat.com>
 <CALMp9eQ85h58NMDh-yOYvHN6_2f2T-wu63f+yLnNbwuG+p3Uvw@mail.gmail.com>
 <87ftmm71p3.fsf@vitty.brq.redhat.com> <36a9f411-f90c-3ffa-9ee3-6ebee13a763f@redhat.com>
 <CALMp9eQLCEzfdNzdhPtCf3bD-5c6HrSvJqP7idyoo4Gf3i5O1w@mail.gmail.com> <20190731233731.GA2845@linux.intel.com>
In-Reply-To: <20190731233731.GA2845@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 31 Jul 2019 16:45:21 -0700
Message-ID: <CALMp9eRRqCLKAL4FoZVMk=fHfnrN7EnTVxR___soiHUdrHLAMQ@mail.gmail.com>
Subject: Re: [PATCH RFC 3/5] x86: KVM: svm: clear interrupt shadow on all
 paths in skip_emulated_instruction()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 31, 2019 at 4:37 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:

> At a glance, the full emulator models behavior correctly, e.g. see
> toggle_interruptibility() and setters of ctxt->interruptibility.
>
> I'm pretty sure that leaves the EPT misconfig MMIO and APIC access EOI
> fast paths as the only (VMX) path that would incorrectly handle a
> MOV/POP SS.  Reading the guest's instruction stream to detect MOV/POP SS
> would defeat the whole "fast path" thing, not to mention both paths aren't
> exactly architecturally compliant in the first place.

The proposed patch clears the interrupt shadow in the VMCB on all
paths through svm's skip_emulated_instruction. If this happens at the
tail end of emulation, it doesn't matter if the full emulator does the
right thing.
