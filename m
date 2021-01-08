Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F772EF61A
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 17:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbhAHQ5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 11:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbhAHQ5J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 11:57:09 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BE1C061380
        for <kvm@vger.kernel.org>; Fri,  8 Jan 2021 08:56:29 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id s15so5937225plr.9
        for <kvm@vger.kernel.org>; Fri, 08 Jan 2021 08:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yNCtO/6yW3p5fzndxhSFUzUAHtK4RmnorBQLqNXZzV0=;
        b=mamyD7aVefxXHSc0LtlmG4t++ZIjOOj3QcVIfNoYoXib0ACTP6nMvBBGoLPkVxJZAD
         s3i+wJYwOl2/MhyDUjdRYFZ2X0CWKrubEbCny9IDjEpklBIW1CB7bNPkHp/j8EpSi2Sh
         G7f0CLyvv8ZZS4PulMkw77VZj5jGTMjqYhjX7z6TZTlplemr1umiN64Ga3xygEfriINH
         IUAh41ld264wccs6Jqk9LieoAAbCBhVvkcUrNhF5sjuubAeVZEuHVh23fzNCmJiKlxQJ
         exJKX9gSa3h/23/9QfVkfG7dto2KHz3CpdQeSuwPPS1uCh/hAIi5Vx+xrmDZXkOJp39/
         ld/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yNCtO/6yW3p5fzndxhSFUzUAHtK4RmnorBQLqNXZzV0=;
        b=ihQh8ZLGdv+RDy01mpxTNB8DZIbbfqN74xCU1ac6TqugWs2IHDnBdcf7dwjZorRIFO
         E+usP/VGa8RAXmdWSUROR/RRVkgfQY7kXEzwOyhwFyNFrSzsKptK+Ay9yvS//EmYC56Y
         v1aXsXSUPBUKY+4A86hi2DizT57tMk/9AdX7HC9ZfFMYLswKNDLHYSny2r5y+bofmD6S
         jgVPNkbrHGQdjkyZo3BGkUIDeIv4dQYxxlv/iv+uAgw1JKdxFBZWOpPpdxapSP47Az3n
         0BDJALgu3OEi568g9YE3JdDvsZa4/P71Xk/2F3LksAMr1Qb8xn1n4Xqj4DPQ9IUms4cX
         6aUQ==
X-Gm-Message-State: AOAM531vStfrvdZSLAsxqG7j8vF5Y6c+DRDR+9T8Jda7+eHRInTyavUY
        nrtoLJGZJERRaxq9I1fKOTQ3ig==
X-Google-Smtp-Source: ABdhPJxFiTyxBb4nEiwal+GHVSCCZg27kwU0605PJ6wD3sxi9pXqBwPKaneArotjNmoKpZUdxoJztQ==
X-Received: by 2002:a17:902:b7c3:b029:da:76bc:2aa9 with SMTP id v3-20020a170902b7c3b02900da76bc2aa9mr7860992plz.21.1610124988722;
        Fri, 08 Jan 2021 08:56:28 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id a19sm8781542pfi.130.2021.01.08.08.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 08:56:27 -0800 (PST)
Date:   Fri, 8 Jan 2021 08:56:20 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Ashish Kalra <ashish.kalra@amd.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "dovmurik@linux.vnet.ibm.com" <dovmurik@linux.vnet.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "frankeh@us.ibm.com" <frankeh@us.ibm.com>,
        "Grimm, Jon" <jon.grimm@amd.com>
Subject: Re: [PATCH v2 1/9] KVM: x86: Add AMD SEV specific Hypercall3
Message-ID: <X/iOtPo7/EoB6ban@google.com>
References: <20201218193956.GJ2956@work-vm>
 <E79E09A2-F314-4B59-B7AE-07B1D422DF2B@amd.com>
 <20201218195641.GL2956@work-vm>
 <20210106230555.GA13999@ashkalra_ubuntu_server>
 <CABayD+dQwaeCnr5_+DUpvbQ42O6cZBMO79pEEzi5WXPO=NH3iA@mail.gmail.com>
 <20210107170728.GA16965@ashkalra_ubuntu_server>
 <X/dEQRZpSb+oQloX@google.com>
 <20210107184125.GA17388@ashkalra_ubuntu_server>
 <X/dfjElmMpiEvr9B@google.com>
 <CABayD+fHUSVCQP7muax5E-ZbAVMt0g1vXYjtJ22+m_+Y5SE=2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+fHUSVCQP7muax5E-ZbAVMt0g1vXYjtJ22+m_+Y5SE=2Q@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 07, 2021, Steve Rutherford wrote:
> Supporting merging of consecutive entries (or not) is less important
> to get right since it doesn't change any of the APIs. If someone runs
> into performance issues, they can loop back and fix this then. I'm
> slightly concerned with the behavior for overlapping regions. 

I'm assuming merging entries will be a near-trivial effort once everything else
is implemented, e.g. KVM will need to traverse the list to remove entries when
address are converted back to private.  Piling on merging functionality at that
point should not be all that hard, especially if the list is sorted and entries
are merged on insertion.
