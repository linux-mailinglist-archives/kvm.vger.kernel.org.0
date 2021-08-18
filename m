Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C073F0E8B
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 01:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234753AbhHRXLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 19:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbhHRXLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 19:11:37 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070A1C061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 16:11:02 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id n18so3974349pgm.12
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 16:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jDu8jxFBuMpm9jQLmw8NmGNAn0afusb3kacY0uTCEs0=;
        b=Tn2to1aNoWgU5SE4yqxXh5q2pajTwW/ibkxmCIPeFqqMp9vlgb7HpqLghezNw8Se8U
         aYNwiqsJZudd/lyUfKeKtF6ga9feN5HosQ4yucZsJoa82vwdM+vAwgqiVe4cMx3/RF1B
         vxHwCq9zB7xMbH1TIXqhk/FvfIEkGjTENTGZ89icRsUnjHI/2xA5u4UPJVH9080EG8MT
         RNnJrbqIo7kgs4qfmgZt8Hq7EiHa3RFBWb7EIMrkLOk+HJRumdY7pSkpiF4rIXH+qzj9
         ag9eAyYLR6Gkkxzln9LvWYX2NZjGlMuPMLdkFef6o3meEV/O1dYumjXqgzpAy1WDFX2F
         DYEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jDu8jxFBuMpm9jQLmw8NmGNAn0afusb3kacY0uTCEs0=;
        b=bG8s+jrXqCZq8DzR7DzB2zIZ8Aw8x7Jzwrr3HppDGT/9oNPExuCsLPfa+IPkgd//o+
         Gje2FmZ6LdBlLOrMfj+xUaKINVyHv3wW0V5kOBJKYHD2wdk99eeA8jg+oEJbsSVeJJhz
         DYyvJTKArlfPZ0dkAIg7CAJuXAzSLtpBYb7IAkt/7/5fOgtH7wP/8kKbQ9V1m5AVFcSZ
         24T/F+8GB53tOYFxXo7Qz8/d0MZGhccvZy309ImCFilhj+AEXiRJDHkEMMpV5dRc9Nax
         uH96NLe87m2++A1Kv2uRDVB/3odHbOmkJJTPwlI1x+UV7n5OuCRgNVjL6ckGOw1d0aR9
         OMrQ==
X-Gm-Message-State: AOAM531BtBQcqJlAGF9YEIXvl3XUG+a0d5ax/KnKGiaAsq0KAbHK2dQE
        QKZtg26OBbPUOR2SlQOFNTng2g==
X-Google-Smtp-Source: ABdhPJxGQB+rgWiHhSnhAAzygqK9Se0NzBAaZvNSAqa2C3WQRR6szf2/DdfaFBcZ6EmnS/1N3myxvg==
X-Received: by 2002:a65:47c3:: with SMTP id f3mr11053654pgs.85.1629328261410;
        Wed, 18 Aug 2021 16:11:01 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t5sm869458pfd.133.2021.08.18.16.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 16:11:00 -0700 (PDT)
Date:   Wed, 18 Aug 2021 23:10:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write
 respects field existence bitmap
Message-ID: <YR2Tf9WPNEzrE7Xg@google.com>
References: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
 <1629192673-9911-4-git-send-email-robert.hu@linux.intel.com>
 <YRvbvqhz6sknDEWe@google.com>
 <b2bf00a6a8f3f88555bebf65b35579968ea45e2a.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2bf00a6a8f3f88555bebf65b35579968ea45e2a.camel@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 18, 2021, Robert Hoo wrote:
> > Limiting this to VMREAD/VMWRITE means we shouldn't need a bitmap and
> > can use a more static lookup, e.g. a switch statement.  
> Emm, hard for me to choose:
> 
> Your approach sounds more efficient for CPU: Once VMX MSR's updated, no
> bother to update the bitmap. Each field's existence check will directly
> consult related VMX MSR. Well, the switch statement will be long...

How long?  Honest question, off the top of my head I don't have a feel for how
many fields conditionally exist.

> My this implementation: once VMX MSR's updated, the update needs to be
> passed to bitmap, this is 1 extra step comparing to aforementioned
> above. But, later, when query field existence, especially the those
> consulting vm{entry,exit}_ctrl, they usually would have to consult both
> MSRs if otherwise no bitmap, and we cannot guarantee if in the future
> there's no more complicated dependencies. If using bitmap, this consult
> is just 1-bit reading. If no bitmap, several MSR's read and compare
> happen.

Yes, but the bitmap is per-VM and likely may or may not be cache-hot for back-to-back
VMREAD/VMWRITE to different fields, whereas the shadow controls are much more likely
to reside somewhere in the caches.

> And, VMX MSR --> bitmap, usually happens only once when vCPU model is
> settled. But VMRead/VMWrite might happen frequently, depends on guest
> itself. I'd rather leave complicated comparison in former than in
> later.

I'm not terribly concerned about the runtime performance, it's the extra per-VM
allocation for something that's not thaaat interesting that I don't like.

And for performance, most of the frequently accessed VMCS fields will be shadowed
anyways, i.e. won't VM-Exit in the first place.

And that brings up another wrinkle.  The shadow VMCS bitmaps are global across
all VMs, e.g. if the preemption timer is supported in hardware but hidden from
L1, then a misbehaving L1 can VMREAD/VMWRITE the field even with this patch.
If it was just the preemption timer we could consider disabling shadow VMCS for
the VM ifthe timer exists but is hidden from L1, but GUEST_PML_INDEX and
GUEST_INTR_STATUS are also conditional :-(

Maybe there's a middle ground, e.g. let userspace tell KVM which fields it plans
on exposing to L1, use that to build the bitmaps, and disable shadow VMCS if
userspace creates VMs that don't match the specified configuration.  Burning
three more pages per VM isn't very enticing...

This is quite the complicated mess for something I'm guessing no one actually
cares about.  At what point do we chalk this up as a virtualization hole and
sweep it under the rug?
