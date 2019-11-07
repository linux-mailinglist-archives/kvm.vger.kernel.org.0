Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63B27F22FB
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 01:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731959AbfKGABn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 19:01:43 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:39153 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727393AbfKGABn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 19:01:43 -0500
Received: by mail-ot1-f66.google.com with SMTP id e17so407843otk.6
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2019 16:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6xfjgZ4C/EchKlv+V6UpiruJFKsW8K/Ar0hBhPPbJyo=;
        b=dPPfGekOsGWnPNe5+q/qIAAv1sillG9Ugyl9YtAXMbR7Xcba7vT5/QdhQPpOZjj6gy
         ggqB125Ht/4zzgNH7xVWpUqFmZbomgb5e54bIgPqVXMaEpRv40R+h9oDHoGmtR0sUTM/
         Cx1P83NOcdMJyZc+0GDN6jvA0n4dUCt2ji8PuR6ZEkBtHNa4ilYorBNmwrPa0XlbHumL
         /aM2dfKuZTLCt80QTBWHfc9lSx0M/xzerPBjvITZTcE/hzoZ81chvLz8JTzw0JMfihNf
         1rUA2sQStaWtDxI8DPepezCDW3HhnMgx5AU0p7Xo+qNWgsYeRDniVh0Ex7KrGNGKEF0O
         TXaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6xfjgZ4C/EchKlv+V6UpiruJFKsW8K/Ar0hBhPPbJyo=;
        b=AniYx4SLrn1YguSw9RshNWbzrHJuHZ8iixis5GAj20no42ZDbwB9KkcN+Hvtiv4gyn
         2DudWwq4QcDg/jvDaw+RnqID53I8ts1TLv4a1/O8F53hhMpXvq4lwMFXR9at33TSm7Ow
         A3wvKxSOSAAPt5WtiwnUtirmNcVKLS09MS3I1VWudc17gD0T3wGvRyKY4kZgOfqxdD7m
         I8ghUiL/ZtVZl5zcWwuksgqBRepH6RJe6DTIM5az7gyD5ISUonrqyDc9EcR1VUuAYbvI
         mnRfixTt+p1g2v+lmmf/qsMAQb7fNDInQhLTMuMSdjsNLMjARxyNquzSUKh/qcqUirDu
         6RYw==
X-Gm-Message-State: APjAAAW02ymRMag+1IRstXJsLRC3TH2/YJQF3koLdWQha4vcRT23KfKa
        TpfNBzTLj9wRQ8x8k3tXhZVIRaxzrBsrS8z6b1ZKqQ==
X-Google-Smtp-Source: APXvYqz6YJLKIFRcB7Gy1I1pK2v5ojca51ttW+Urubn6MXnIhvG4gp1euFKiQwZ4YOmkONtMzgzLeZmxpUNDGGIiZaE=
X-Received: by 2002:a9d:2d89:: with SMTP id g9mr369121otb.126.1573084902039;
 Wed, 06 Nov 2019 16:01:42 -0800 (PST)
MIME-Version: 1.0
References: <20191106170727.14457-1-sean.j.christopherson@intel.com>
 <20191106170727.14457-2-sean.j.christopherson@intel.com> <CAPcyv4gJk2cXLdT2dZwCH2AssMVNxUfdx-bYYwJwy1LwFxOs0w@mail.gmail.com>
 <1cf71906-ba99-e637-650f-fc08ac4f3d5f@redhat.com> <CAPcyv4hMOxPDKAZtTvWKEMPBwE_kPrKPB_JxE2YfV5EKkKj_dQ@mail.gmail.com>
 <20191106233913.GC21617@linux.intel.com>
In-Reply-To: <20191106233913.GC21617@linux.intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 6 Nov 2019 16:01:31 -0800
Message-ID: <CAPcyv4jysxEu54XK2kUYnvTqUL7zf2fJvv7jWRR=P4Shy+3bOQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: MMU: Do not treat ZONE_DEVICE pages as being reserved
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Adam Borowski <kilobyte@angband.pl>,
        David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 6, 2019 at 3:39 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Wed, Nov 06, 2019 at 03:20:11PM -0800, Dan Williams wrote:
> > After some more thought I'd feel more comfortable just collapsing the
> > ZONE_DEVICE case into the VM_IO/VM_PFNMAP case. I.e. with something
> > like this (untested) that just drops the reference immediately and let
> > kvm_is_reserved_pfn() do the right thing going forward.
>
> This will break the page fault flow, as it will allow the page to be
> whacked before KVM can ensure it will get proper notification from the
> mmu_notifier.  E.g. KVM would install the PFN in its secondary MMU after
> getting the invalidate notification for the PFN.

How do mmu notifiers get held off by page references and does that
machinery work with ZONE_DEVICE? Why is this not a concern for the
VM_IO and VM_PFNMAP case?
