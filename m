Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAA82F6AA0
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 20:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729701AbhANTLs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 14:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729632AbhANTLr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 14:11:47 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54553C061575
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 11:11:07 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id b8so3416732plx.0
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 11:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+ReVIElF0ug2hspVF8MhGrtt8tX4cPTcM7laaE3Mkn4=;
        b=HyQPHZUme1aLutRzh4m+G49+4PStkg/ebEra578C6AXdOamIQY6q2Gz33JYYuZ5l49
         0Ypd2OvzoUa7irmLZUn0hQGzjLtuWAft+Masj0n9nyLrIbqYQmpCW7ju11baWMs5KgDQ
         hxXi7gnlNYT5gMuKStvhg2X3kxM8/M/IcImhtwix4r+C/g7dOgpOvlvtjHJNIaCncdQ3
         qy//GtTrOYJyhWEOCqz1J2BGpjNh7u+wvfcbn5DGh9mbSBiT2U1i4VDayzGCW6YiR+Uc
         0BQktkXhJCPl5UKR8QFs5VPLZKz3JElz4wvfXaHsGAFiGgtHLi75ZThoaEb1G9siTapK
         HBlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+ReVIElF0ug2hspVF8MhGrtt8tX4cPTcM7laaE3Mkn4=;
        b=Gl0HDClanBbhhxz1queR44rVJypZd6r8UdPj0iDA3Y7oEd/9Jc0vJQz6wpCfB6aJ9k
         QysIum2nLlT69J5xwGLD8tdXvXmQuqb5WZ9Sl0lXB6jzHzHhOGTTABcj0pDXcOaBbRGO
         LJJmio11YERawnHGgfAvBiVKz01P5b+MJjRRfDV3S3Bqfs7pFas5hlb6ZirBxJPp7+36
         xpFCS28AHxC7G0hBQpr91lRJWm3sf5pnocirAqvri7X3spclj69ySrRRBcjiYSQll8XF
         nSi+d7geS5iAOEhv1aiOUssULYnpDXNj3XN0PXRZoqEjE4NnymkTEUg4eq2QVvlWM4r8
         vSFw==
X-Gm-Message-State: AOAM532IdPV4TNawQDvmiWMC5GtUfC/38M59+9xGz8TeSnZaM39lUGYd
        yx2kU171riUhrR8HSFh/SuugSjm7ECBZIw==
X-Google-Smtp-Source: ABdhPJwuHmV2q+NvRIuZSsYI6CNiyUcx1ahBqTEkR7YR+cDX9VpwdeFEKU143CZ778FJ0S+i2Lsu+A==
X-Received: by 2002:a17:90a:31c3:: with SMTP id j3mr6259951pjf.25.1610651466709;
        Thu, 14 Jan 2021 11:11:06 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id c18sm5867353pfj.200.2021.01.14.11.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 11:11:06 -0800 (PST)
Date:   Thu, 14 Jan 2021 11:10:59 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/17] KVM: x86/pmu: Add support to enable Guest PEBS
 via DS
Message-ID: <YACXQwBPI8OFV1T+@google.com>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104131542.495413-1-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 04, 2021, Like Xu wrote:
> 2) Slow path (part 3, patch 0012-0017)
> 
> This is when the host assigned physical PMC has a different index
> from the virtual PMC (e.g. using physical PMC1 to emulate virtual PMC0)
> In this case, KVM needs to rewrite the PEBS records to change the
> applicable counter indexes to the virtual PMC indexes, which would
> otherwise contain the physical counter index written by PEBS facility,
> and switch the counter reset values to the offset corresponding to
> the physical counter indexes in the DS data structure. 
> 
> Large PEBS needs to be disabled by KVM rewriting the
> pebs_interrupt_threshold filed in DS to only one record in
> the slow path.  This is because a guest may implicitly drain PEBS buffer,
> e.g., context switch. KVM doesn't get a chance to update the PEBS buffer.

Are the PEBS record write, PEBS index update, and subsequent PMI atomic with
respect to instruction execution?  If not, doesn't this approach still leave a
window where the guest could see the wrong counter?

The virtualization hole is also visible if the guest is reading the PEBS records
from a different vCPU, though I assume no sane kernel does that?

> The physical PMC index will confuse the guest. The difficulty comes
> when multiple events get rescheduled inside the guest. Hence disabling
> large PEBS in this case might be an easy and safe way to keep it corrects
> as an initial step here. 
