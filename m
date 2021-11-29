Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4883462665
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234673AbhK2Wvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:51:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235741AbhK2WuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:50:14 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49530C061784
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 11:20:15 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id z6so12986550plk.6
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 11:20:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d/VHE146EldVzZNw053jCy2kU4sOJkhWa9AFjMEeYoU=;
        b=YBcKV5I1ym6Pq7HiM97mJe8JffgQeVmv6n81aPdg1LdcXvMb5DDee9hehpcU2S5M3c
         BGJ45psgrvHdHycV0IE+CR3wdkzK8JyomKPu9G6LENGuUDwhP8c7l5RPSxHWi8j+6pAP
         aHuCKFQIrQe4CHw/mhO+Fo0tuMS1jtOQ8d0eR+8L2z9p5XgV0UEnYv5GGS6k6aNnZ8l1
         pJeAuwcOKlVtHzQnpgt3ywE8/xzeHJYFzXZrogBuLN3crQIRgOGMB/baaGB3Bz/aeXrM
         441Ors5L6Z+2Ral71vtIJQ45PP7nt4JCd+0FpSpVs8iEQmJc2NCGXvE1H448S7lZ0kU8
         +T3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d/VHE146EldVzZNw053jCy2kU4sOJkhWa9AFjMEeYoU=;
        b=kM2/xyHOw2zSnoXpggEw/hfq6swag/Sk0HaFEiRLiTUfG2gl5QJOYhcv4tZ0qrcf81
         fT8xv4P5+G/SL6TlJPAyqWoW75qV9G/5oxmNZc4mzm9urQ5+PSFfr6euAgf+0SF38t9l
         8JKYZhkM7g/5iir7GMfl8ds2osFFB9pyXNzaTf9chvkxkmaNpRUgXNeZfVBX/R5Ns3Rp
         jAY+6U468roxrT5HqrkEikz5NvkEsW3rANJ8PPjUmrN+qXd8s44DeIZrsI/J3FVuNOqN
         yllBEbuxwZoI/hAkgrgZN6co1YEAe8zMjs6yuSayfZWXWL1ZRMvRZTSOofjqO7EdnKBF
         a/gQ==
X-Gm-Message-State: AOAM5331FU30DP0lLfJss1p7IvxfcWMOOR9XEEi9UpcLCY3kRKdppjS6
        gU2QC526l8f4wmMkWn8/rrLHew==
X-Google-Smtp-Source: ABdhPJx5mPquBYmd3HZ+xgzwlI10sjg8adXl/sVFthLKnKT7q6ioiplN6tT7LIB+rq1eoWgT3xCe/w==
X-Received: by 2002:a17:90b:1b06:: with SMTP id nu6mr313709pjb.155.1638213614692;
        Mon, 29 Nov 2021 11:20:14 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h15sm19910986pfc.134.2021.11.29.11.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 11:20:14 -0800 (PST)
Date:   Mon, 29 Nov 2021 19:20:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v3 28/59] KVM: x86: Check for pending APICv interrupt
 in kvm_vcpu_has_events()
Message-ID: <YaUn6pqZHrw4Z8zn@google.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <9852ad79d1078088743a57008226c869b0316da1.1637799475.git.isaku.yamahata@intel.com>
 <4708e92c-373b-a07f-c80c-fe194ca706df@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4708e92c-373b-a07f-c80c-fe194ca706df@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 25, 2021, Paolo Bonzini wrote:
> On 11/25/21 01:20, isaku.yamahata@intel.com wrote:
> > From: Sean Christopherson<sean.j.christopherson@intel.com>
> > 
> > Return true for kvm_vcpu_has_events() if the vCPU has a pending APICv
> > interrupt to support TDX's usage of APICv.  Unlike VMX, TDX doesn't have
> > access to vmcs.GUEST_INTR_STATUS and so can't emulate posted interrupts,
> > i.e. needs to generate a posted interrupt and more importantly can't
> > manually move requested interrupts into the vIRR (which it also doesn't
> > have access to).
> 
> Does this mean it is impossible to disable APICv on TDX?  If so, please add
> a WARN.

Yes, APICv is forced.

Rereading this patch, checking only for a pending posted interrupt isn't correct,
a pending interrupt that's below the PPR shouldn't be considered a wake event.

A much better approach would be to have vt_sync_pir_to_irr() redirect to a TDX
implementation to read the PIR but not update the vIRR, that way common x86 doesn't
need to be touched.  Hopefully that can be done in a race-free way.
