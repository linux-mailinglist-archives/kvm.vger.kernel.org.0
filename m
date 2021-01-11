Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF3A2F20C9
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 21:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730520AbhAKU3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 15:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730079AbhAKU3U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 15:29:20 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8192C061794
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 12:28:40 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id v3so92554plz.13
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 12:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=iI1rIqMfwu1P4fzKj9/kRKSVEqcKsOkLrborReGYEMY=;
        b=n//tBuPfufjrPGNJXimcbOspw3o6JHeeJgul4/wExnnP7yEohCopxZJdpmS/N3xGs1
         jC12nWIQusxHhtJaHdbXXugkwhS25diUWmISXfKnFmqbWTcm5Ybdvgc9ngrbkYGmFn+3
         aznnz9kqMDwRIitTKgPuRdQNyWzpWHYJl/s2Nl8MPUVV3A3RrBtUQXQqjW5LieB67Ysq
         8qYGk7jD76Qmpe6o9nIoysK/O6Ct94Gr6NNbTsL7kfWMQUXzxeHWRDaDQmjmuMGR/7dU
         J6MQB6BauelnswIQQax5lnYo+P2d1CntVXjxAo5bQsp3DFsWGm2gGjFe3NAwPYX2s3oB
         3ikw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=iI1rIqMfwu1P4fzKj9/kRKSVEqcKsOkLrborReGYEMY=;
        b=VWKJnoRUQ4QPf7XpWBtftwSgqnaAC4A73uYoet1KPI3D510CyZ0lFFdzE5j18OJmUZ
         unGSICcLHgrBLZOVINWIXqhOuGXh8weO80h+WjAMiPqFtAGfvljwRcrM8OkfMZInqJQJ
         UnD4xLLI7cEAzYWsOOsdEbarbILfXbIXuqlmh+mNDEqZruf9i7EcxCR5HEL2wRLvE/ee
         A5i4gEHnwk2uPGL/+UGYhAUVXuaqHAcL1jej37POLxsY/nUDjXy7qbDO1yaQ4bc5a+Fk
         gP9lT1H8Zzo+x1uuVQT6bGzFqdSrOgsOkxcbkzvWPKdNYDQc/GzCP3GX5qshcCxVPDZY
         SzVw==
X-Gm-Message-State: AOAM532PJNzxHYbUUPzNLshAzGIzZ92n2vDkaBrjI09SVWo+/y21xtDC
        Z7XcH4tMZtAdjXtuZCaJ0Qe4WA==
X-Google-Smtp-Source: ABdhPJxLa4YAAAAxOU0c3cvwB++tHRjVUn4t6n6xS0vZyxzTZIdEn4q2B+D/klf5X3Ttp7TLsNfY2w==
X-Received: by 2002:a17:902:ee11:b029:db:c0d6:581a with SMTP id z17-20020a170902ee11b02900dbc0d6581amr1069008plb.54.1610396920141;
        Mon, 11 Jan 2021 12:28:40 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id w18sm471444pfj.120.2021.01.11.12.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 12:28:39 -0800 (PST)
Date:   Mon, 11 Jan 2021 12:28:32 -0800
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
Subject: Re: [PATCH 06/13] x86/sev: Rename global "sev_enabled" flag to
 "sev_guest"
Message-ID: <X/y08JZkm/+TJCHr@google.com>
References: <20210109004714.1341275-1-seanjc@google.com>
 <20210109004714.1341275-7-seanjc@google.com>
 <f6ed8566-6521-92f0-927e-1764d8074ce6@amd.com>
 <5b3a5d5e-befe-8be2-bbc4-7e7a8ebbe316@amd.com>
 <X/yRxYCrEuaq2oVX@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <X/yRxYCrEuaq2oVX@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 11, 2021, Sean Christopherson wrote:
> On Mon, Jan 11, 2021, Tom Lendacky wrote:
> > On 1/11/21 10:02 AM, Tom Lendacky wrote:
> > > On 1/8/21 6:47 PM, Sean Christopherson wrote:
> > > > Use "guest" instead of "enabled" for the global "running as an SEV guest"
> > > > flag to avoid confusion over whether "sev_enabled" refers to the guest or
> > > > the host.  This will also allow KVM to usurp "sev_enabled" for its own
> > > > purposes.
> > > > 
> > > > No functional change intended.
> > > > 
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > 
> > > Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
> > 
> > Ah, I tried building with CONFIG_KVM=y and CONFIG_KVM_AMD=y and got a build
> > error:
> > 
> > In file included from arch/x86/kvm/svm/svm.c:43:
> > arch/x86/kvm/svm/svm.h:222:20: error: ‘sev_guest’ redeclared as different
> > kind of symbol
> 
> Dang, didn't consider that scenario, obviously.  The irony of introducing a
> conflict while trying to avoid conflicts...

Even better than coming up with a new name, sev_enabled can be removed entirely
as it's really just sev_active() stored in a separate bool.
