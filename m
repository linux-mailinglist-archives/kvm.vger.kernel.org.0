Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0702F1D96
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 19:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390206AbhAKSIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 13:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389665AbhAKSIc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 13:08:32 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35728C061786
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 10:07:52 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id x126so399379pfc.7
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 10:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FzYi5CFHX7yAe6C21w/ewHOkjzBSVorYsZxNkxZbkLM=;
        b=Cf2SHU/6ht8TunF5tqJEWjahTp11UIqc4oE8ZfJA3t+1AFVBY55f7BO+Ch4Sptba3d
         xoS04jtiBWO6s4KeWpA4DbtGt764iAV6oOXYetqSo8Uh08vD4Vg/C01Vn+ToRq8CfjXX
         CYUpL3p5bg4WAQqEG3iz9nOucPiVm1/PS25QJqiKTJ/79K8pFNgH8P0dq3aG3GIoWhNe
         Azb++dM3F5iuTAlLeKLWLcBuitWjf2c+MKM2C5abRuhnQzWn4MP3CPoVH3hNiw3ZDdYu
         WBGoP6z3/ROXRWBxodFqG5otUxD2x29yT6/lgkThBW7n0j6N+FTeWj2BUUZBLSbivGEW
         r4mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FzYi5CFHX7yAe6C21w/ewHOkjzBSVorYsZxNkxZbkLM=;
        b=ANj+nDzV7ih5OkqzlfwuLqHHefzacjP4++VdZrS8AEppMm8WsbvtVWGx5LPdD0WhCl
         jW2W5bNttDDv9RdiT72JUUfsSTw/o7GkqAHIlvePcrnS9f/Vnn3mw6PxQDSsE5qyDi/z
         IBVf6mbxwafSI4COPDcDPfAfx0ZrUloWBqEPMaklVJuhZbAOXN03pUZuBUTENrfGRz0u
         T3Bg6bVh031kIj4ggAfTB1j/ZwvyLqxQvb1cJo7gG307nqc1KiNjEOCZDOyFmsuZbZi3
         zE3CQ0zYeskvv3j8FknaFLMrjYlZvNFu5vBv614uoyAS+N1HakjE1mKWG3Ol6XBHm+8v
         1lvQ==
X-Gm-Message-State: AOAM530MrNaa2kKry7KA0R8/sLaAFmdL0GsDw1A4mZL46T1nksC6NXU4
        8RIYzChI24H+VlvYTOIWTD/epw==
X-Google-Smtp-Source: ABdhPJy7Yt/kUlgbKAw0hyBc7JlPxMxVO5s9HLF5Xa/jBlMZ2QxouheJnaUbtcDPOqoEdNS0mqU+RQ==
X-Received: by 2002:a63:5023:: with SMTP id e35mr756868pgb.56.1610388471618;
        Mon, 11 Jan 2021 10:07:51 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id z13sm41478pjt.45.2021.01.11.10.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 10:07:50 -0800 (PST)
Date:   Mon, 11 Jan 2021 10:07:44 -0800
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
Subject: Re: [PATCH 01/13] KVM: SVM: Free sev_asid_bitmap during init if SEV
 setup fails
Message-ID: <X/yT8H883tUkQV2M@google.com>
References: <20210109004714.1341275-1-seanjc@google.com>
 <20210109004714.1341275-2-seanjc@google.com>
 <34921a58-ce49-f0fd-e321-c5363e91f3f5@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34921a58-ce49-f0fd-e321-c5363e91f3f5@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 11, 2021, Tom Lendacky wrote:
> On 1/8/21 6:47 PM, Sean Christopherson wrote:
> > Free sev_asid_bitmap if the reclaim bitmap allocation fails, othwerise
> > it will be leaked as sev_hardware_teardown() frees the bitmaps if and
> > only if SEV is fully enabled (which obviously isn't the case if SEV
> > setup fails).
> 
> The svm_sev_enabled() function is only based on CONFIG_KVM_AMD_SEV and
> max_sev_asid. So sev_hardware_teardown() should still free everything if it
> was allocated since we never change max_sev_asid, no?

Aha!  You're correct.  This is needed once svm_sev_enabled() is gone, but is not
an actual bug in upstream.

I created the commit before the long New Years weekend, but stupidly didn't
write a changelog.  I then forgot that my series effectively introduce the bug
and incorrectly moved this patch to the front and treated it as an upstream bug
fix when retroactively writing the changelog.

Thanks!
