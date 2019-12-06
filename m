Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC0BC115833
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 21:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbfLFUbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 15:31:20 -0500
Received: from mail-ua1-f65.google.com ([209.85.222.65]:41232 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbfLFUbU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 15:31:20 -0500
Received: by mail-ua1-f65.google.com with SMTP id f7so3381858uaa.8
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2019 12:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yvnlefSqRj8i0igFAJ0ONce7TCwxEReu/pZBV8W+whM=;
        b=oVW0Fjp+B5MaZg11s3cmhK2aPQ1KWcfXtaMo6a8oQoocMXcGGXrWvRapGr2S0f/7rf
         ZFItv/Cn4o1R8rWJuU/iNYdsknxij1UXF5pvzKW1QYOSFCRvbYPPZ2fizjm8bYWNj5wN
         Co7tkrePnRD7GVA45qKFaaB1T2Donqpz6WdLrOOjHe5ehIRhJlwEJuYgVZaCzQH8BuW+
         QrtwHaV6IQSd8jLDERLD/yehsZPOfqaez6EGXnFUXlwbL3DdbjRbe+zrArTBC36BPXqz
         Zrgdt4YZ9sjXmGrhyrJoZOvnO01jmXZcx+MLky3mhyw9xkAaQh9VhzsnVVtTu5dlXw3P
         /vig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yvnlefSqRj8i0igFAJ0ONce7TCwxEReu/pZBV8W+whM=;
        b=mCrai0g3TuWLHrEk1ozA323A73fHlwCmUn3YcGBX3MI3bOjTQZH5zCdlriRE3T9iHc
         DQDUDyRrEM3L3gRuPuBCfH1I7QD/AZLrQdsk8su2XZS2nwlhdsTp0r1YYm7qg9XLIDNL
         Z72lfxAnNnIXr3D0VQoZZ2wytjtKKMeAiM7oSxR1D839drw5sartf+YkuPm212j1/kMN
         g8snBECKXFSnGGO/WSkamh0rJVwcqK1UD6qZZskS/+bunZW1e0rKRsDio76dBLaIUzAd
         KA3c4Yi7MKMQIIabZCWfwUCiZb/7MSJIPR1Tv5C8rw9Cjst9pdX8XN2867qe5aiPJmYh
         jcgg==
X-Gm-Message-State: APjAAAU9UbdXISbVmhQfPaVR98llWr7WFfifd8m6yB0GpHG4fEqIaf/P
        Hgtqi4NL5vS5Y8fntUDXm6NzAXhzMSSyj8ZmYPCsjw==
X-Google-Smtp-Source: APXvYqzf3jTI6h7lt1Mt/MOickYrAea19ceZAoDPqv/hnTaPiVrWUmY/zVXRwmWDLADaCQP5XzmRaOuYyJKExF/wIt4=
X-Received: by 2002:a9f:2304:: with SMTP id 4mr14146577uae.69.1575664278931;
 Fri, 06 Dec 2019 12:31:18 -0800 (PST)
MIME-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com> <20190926231824.149014-11-bgardon@google.com>
 <20191202234644.GH8120@linux.intel.com>
In-Reply-To: <20191202234644.GH8120@linux.intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Fri, 6 Dec 2019 12:31:08 -0800
Message-ID: <CANgfPd-TFE8kgicJBXw8JZs6YHGCzRKCenRHeFOSHHkWVVXZnA@mail.gmail.com>
Subject: Re: [RFC PATCH 10/28] kvm: mmu: Flush TLBs before freeing direct MMU
 page table memory
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We've tested this on Skylake, Broadwell, Haswell, Ivybridge,
Sandybridge, and probably some newer platforms. I haven't gone digging
for any super old hardware to test on.

On Mon, Dec 2, 2019 at 3:46 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, Sep 26, 2019 at 04:18:06PM -0700, Ben Gardon wrote:
> > If page table memory is freed before a TLB flush, it can result in
> > improper guest access to memory through paging structure caches.
> > Specifically, until a TLB flush, memory that was part of the paging
> > structure could be used by the hardware for address translation if a
> > partial walk leading to it is stored in the paging structure cache. Ensure
> > that there is a TLB flush before page table memory is freed by
> > transferring disconnected pages to a disconnected list, and on a flush
> > transferring a snapshot of the disconnected list to a free list. The free
> > list is processed asynchronously to avoid slowing TLB flushes.
>
> Tangentially realted to TLB flushing, what generations of CPUs have you
> tested this on?  I don't have any specific concerns, but ideally it'd be
> nice to get testing cycles on older hardware before merging.  Thankfully
> TDP-only eliminates ridiculously old hardware :-)
