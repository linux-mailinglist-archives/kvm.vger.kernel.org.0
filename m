Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72682F6ABE
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 20:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbhANTSQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 14:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbhANTSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 14:18:16 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0A1C061575
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 11:17:35 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id x126so3925823pfc.7
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 11:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BrtldUOeu+hnXE15tO0kF01exYGRde7kUMNnM3ud9F4=;
        b=cd9onR3Brmte3kL09DzE0Cgh6BPn45EsyBihDJu6gX6usEh8TmbwtpKcBJSSUqFGNh
         1voOWLtw2pBBaw9sHzfW21IQbhzAdAEiQW7heBui7ygrZaiTcMfMHx4UstNbpGh/l15f
         l91UIVsYdHy9V2TOUwosP6u4nN6QhkYfNAztwb47PmA8LCzFTMCl7PXSLj+IYHeUY6Ws
         MFMVUr684KSA7FxFYNSFqYcq/OnPkslp735XBmzvF+LSp8ZN2/sIKWpPseHTiSXg3QEA
         osJ+5khHsGD8KPCz4IX6axFFId+vl/BqIVb59pKrekADB4YoUCibt6jidJ1DEd7nq29l
         EAYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BrtldUOeu+hnXE15tO0kF01exYGRde7kUMNnM3ud9F4=;
        b=Tx1TxvxBHd9Hts6Tv3rDwC0fS+tGO6HxryHf5Bwnj+E7LK/HwJkKnhCmPx/Db+sKQy
         M7uTXZRWvXxr6xYEitgQqCGUr/x7pKw05EOaRr3GDWxwdwYD8Bi36D56DBieZL7g1nRX
         tnEh+mFS1ckQlxn7l8MjLyYBPMRe22IadzS0f0jQiMbDOUQWVQxrc80IKEkuapcJFXBy
         HKwEEs72JGnaLJcsiMNaVgz01KhnXgavBRBPs60h8u8hpJqUbynfZt8THo+K7B6P1ust
         j8HmKsuSQOnMWKoJrUD61u8hB5j60pXdVnPyUIZjOvElYDNDlsYZRNqmVusYk2PGPiHr
         LeOQ==
X-Gm-Message-State: AOAM532Iz1Kp5T1PrczgilpF5o8URr63vaf0+l5qek17+exislEwQZxw
        9piIxfbWKC9zQo4bII2dW/tRzg==
X-Google-Smtp-Source: ABdhPJzbwD0JrHREGhIIZoS98kiThcriePWQtFFWefgrpZhr93P+JXhUBVD+nQwpFcRyYddS+wBxNQ==
X-Received: by 2002:aa7:979d:0:b029:1a4:3b76:a559 with SMTP id o29-20020aa7979d0000b02901a43b76a559mr8716680pfp.49.1610651855097;
        Thu, 14 Jan 2021 11:17:35 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id t23sm6015241pfc.0.2021.01.14.11.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 11:17:34 -0800 (PST)
Date:   Thu, 14 Jan 2021 11:17:27 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2 02/14] KVM: SVM: Free sev_asid_bitmap during init if
 SEV setup fails
Message-ID: <YACYx68nBGOe2ROg@google.com>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-3-seanjc@google.com>
 <b1a6403b-249d-9e98-3a2d-7117ed03f392@amd.com>
 <YAB7ceKeOdfkDnoA@google.com>
 <12cfd19a-7f6f-c422-5d6a-5317c1df72ae@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12cfd19a-7f6f-c422-5d6a-5317c1df72ae@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 14, 2021, Tom Lendacky wrote:
> On 1/14/21 11:12 AM, Sean Christopherson wrote:
> > On Thu, Jan 14, 2021, Tom Lendacky wrote:
> > > On 1/13/21 6:36 PM, Sean Christopherson wrote:
> > > > Free sev_asid_bitmap if the reclaim bitmap allocation fails, othwerise
> > > > KVM will unnecessarily keep the bitmap when SEV is not fully enabled.
> > > > 
> > > > Freeing the page is also necessary to avoid introducing a bug when a
> > > > future patch eliminates svm_sev_enabled() in favor of using the global
> > > > 'sev' flag directly.  While sev_hardware_enabled() checks max_sev_asid,
> > > > which is true even if KVM setup fails, 'sev' will be true if and only
> > > > if KVM setup fully succeeds.
> > > > 
> > > > Fixes: 33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations")
> 
> Oops, missed this last time... I don't think the Fixes: tag is needed
> anymore unless you don't want the memory consumption of the first bitmap,

If Fixes is viewed as purely a "this needs to be backported", then yes, it
should be dropped.  But, since KVM policy is to backport only patches that are
explicitly tagged with stable@, I like to use to Fixes to create a paper trail
for bug fixes even if the bug is essentially benign.

That being said, I have no objection to dropping it if anyone feels strongly
about not playing fast and loose with Fixes.

> should the allocation of the second bitmap fail, until kvm_amd is rmmod'ed.
> Up to you.
