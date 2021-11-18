Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E256E455F18
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 16:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhKRPNA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 10:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbhKRPNA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 10:13:00 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CA1C061574
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 07:10:00 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id p17so5591819pgj.2
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 07:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J8IPal5CPgqIRoKzAMEyXEPYKcwtJxIgQtb+uxgMkiA=;
        b=JybN+Nmi8qa2q6q9oSfb2OCPM9v0PWs07vyM9akHlDeoaAFeyXJqmojVPNG6V3TiFB
         8/YxiZcxIzlmGHclRttYyudOz7t3rorBUCdmjUwC4qsGbutdYZUo8ChB4YfcUo7Q4JZQ
         ILAyCcfduDJ58VPsxLySLTRTgeBcLqVptgvxOKd3hawhhtW3LnBcF+PxWrov/RQ5Q+mo
         3FFrB3az+Bw1NnVipmDPusEHQbYwDbtazO24S8a1HhIk7nm174KqdMi+hcxJ0n+XkSab
         127rHLQiSFB5Z4rYhRUbLz4nNGu9IeHogCfb2MS+weo/S7HAUTG/XlGvYZqhvUVuF9WK
         CkGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J8IPal5CPgqIRoKzAMEyXEPYKcwtJxIgQtb+uxgMkiA=;
        b=bJFcdXT42RIwPmAisFZ9YVZsRrDUYBJYvpqOk5DipfgUGcF/rSppzBHjgPA8Js1a4V
         EQ3BJXjPswa2+TMieNmAqwAvBvOovAyxC9ZwwWqVxgL1WtugneoS9Z2D4AB/KYyYPIPH
         wSLOSICyM+9x++ie97ZdpvTAvjE5Cmxm4axL5HfTRQ0yiuAxcNDxeQ9qn9Q5yPQuO5pP
         0bQjYA+RQ+hNUuC7cO0fsCrKVWn0NH77chsqgqiuDWHkq+TbL/2Oo8nZdnRnJcIoZQpU
         cjpsdWnQ1EVGGCzdZwfjp2k3aXAffq9Tzpk9tKh4cTx8kK+LflnDSV9Om3sT52HL3Hfa
         k/qg==
X-Gm-Message-State: AOAM531zO4hcRkXCrHaDYPe3O9wEgpkxJYNzfcYIOiAsVbYPFDMEnJBu
        XXUQW6lIbRjFPfYdIeb4TQ1lWA==
X-Google-Smtp-Source: ABdhPJz/SJy/5gD7KJCsPU0WjjjdcRVJMdZ36mFrY3wJd+2jshtGVV02RHAoBxdyTS+zwtdDvtjq+A==
X-Received: by 2002:a63:2402:: with SMTP id k2mr1245554pgk.353.1637248199379;
        Thu, 18 Nov 2021 07:09:59 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b19sm3936698pfv.63.2021.11.18.07.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 07:09:58 -0800 (PST)
Date:   Thu, 18 Nov 2021 15:09:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 1/4] x86/kvm: add boot parameter for adding vcpu-id
 bits
Message-ID: <YZZsw6b2iquFpF9P@google.com>
References: <20211116141054.17800-1-jgross@suse.com>
 <20211116141054.17800-2-jgross@suse.com>
 <7f10b8b4-e753-c977-f201-5ef17a6e81c8@suse.com>
 <YZWUV2jvoOS9RSq8@google.com>
 <731540b4-e8fc-0322-5aa0-e134bc55a397@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <731540b4-e8fc-0322-5aa0-e134bc55a397@suse.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021, Juergen Gross wrote:
> On 18.11.21 00:46, Sean Christopherson wrote:
> > On Wed, Nov 17, 2021, Juergen Gross wrote:
> > > On 16.11.21 15:10, Juergen Gross wrote:
> > > > Today the maximum vcpu-id of a kvm guest's vcpu on x86 systems is set
> > > > via a #define in a header file.
> > > > 
> > > > In order to support higher vcpu-ids without generally increasing the
> > > > memory consumption of guests on the host (some guest structures contain
> > > > arrays sized by KVM_MAX_VCPU_IDS) add a boot parameter for adding some
> > > > bits to the vcpu-id. Additional bits are needed as the vcpu-id is
> > > > constructed via bit-wise concatenation of socket-id, core-id, etc.
> > > > As those ids maximum values are not always a power of 2, the vcpu-ids
> > > > are sparse.
> > > > 
> > > > The additional number of bits needed is basically the number of
> > > > topology levels with a non-power-of-2 maximum value, excluding the top
> > > > most level.
> > > > 
> > > > The default value of the new parameter will be 2 in order to support
> > > > today's possible topologies. The special value of -1 will use the
> > > > number of bits needed for a guest with the current host's topology.
> > > > 
> > > > Calculating the maximum vcpu-id dynamically requires to allocate the
> > > > arrays using KVM_MAX_VCPU_IDS as the size dynamically.
> > > > 
> > > > Signed-of-by: Juergen Gross <jgross@suse.com>
> > > 
> > > Just thought about vcpu-ids a little bit more.
> > > 
> > > It would be possible to replace the topology games completely by an
> > > arbitrary rather high vcpu-id limit (65536?) and to allocate the memory
> > > depending on the max vcpu-id just as needed.
> > > 
> > > Right now the only vcpu-id dependent memory is for the ioapic consisting
> > > of a vcpu-id indexed bitmap and a vcpu-id indexed byte array (vectors).
> > > 
> > > We could start with a minimal size when setting up an ioapic and extend
> > > the areas in case a new vcpu created would introduce a vcpu-id outside
> > > the currently allocated memory. Both arrays are protected by the ioapic
> > > specific lock (at least I couldn't spot any unprotected usage when
> > > looking briefly into the code), so reallocating those arrays shouldn't
> > > be hard. In case of ENOMEM the related vcpu creation would just fail.
> > > 
> > > Thoughts?
> > 
> > Why not have userspace state the max vcpu_id it intends to creates on a per-VM
> > basis?  Same end result, but doesn't require the complexity of reallocating the
> > I/O APIC stuff.
> > 
> 
> And if the userspace doesn't do it (like today)?

Similar to my comments in patch 4, KVM's current limits could be used as the
defaults, and any use case wanting to go beyond that would need an updated
userspace.  Exceeding those limits today doesn't work, so there's no ABI breakage
by requiring a userspace change.

Or again, this could be a Kconfig knob, though that feels a bit weird in this case.
But it might make sense if it can be tied to something in the kernel's config?
