Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951EB3FF3AB
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 20:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347194AbhIBS6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 14:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbhIBS6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 14:58:19 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC436C061575
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 11:57:20 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id w19-20020a17090aaf9300b00191e6d10a19so2197442pjq.1
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 11:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AkmWZUegUhZEVUOACKSTOdlhb7SyRMPHYAHvTBr+eB4=;
        b=TnMNc8uOhY/OYYSg2N6xNC1fGTSR8kviK5K5YEINI0m2O8Z89Wzzv4DeGq+ml4O59E
         u83UPU0GGnBufLgYxSkuLGTn3UTtmtPT9K0vIwbunw3Tc8gAM0PKAX2ULUTDINl0qlJy
         NZDpV7k62Jvgq2wD02XKQRzQvv1P5Am+ACZFpcNxPyA3/KAbxPfgWlzxpUUQAlxNstAj
         uE4c1fjB7NGrzdIdCxfjd9wC/etG/JJxsfLgC8HtDSJ52ZTGSsCL3l6prPfcaSvO4cmd
         le0FM7CWdX2LcaUGSnom+tHFWyq2gValn0fvbZ+Qzl+rjvDJDCVv7dDaJw71C/kiRwYh
         7dNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AkmWZUegUhZEVUOACKSTOdlhb7SyRMPHYAHvTBr+eB4=;
        b=bMQpi3X21pDgoaKlLBqM/jXW9EoYpCNgm/CExrV4KLY0nAktYJFRgeW5j3q3hBmyBk
         sP2I2nS+Fk43qD+coChHnIj4r3n5B17zwTGCvAYUEoWXrojfjk+hqFDbAp3orgM05c90
         2TqnpMF3sHF1v5I9YTvGs3iEywz3pX7Qtkea6YbJX1jr7lFEts2iw1K5SZg6yCotU945
         pVpd0wY8lTQMvRAhbSNtTQQTJ46SVGiAid3KJFc/KlgMhJsCOAHPaWGSwObWXdkIEQqL
         rkhmZuRDIQV6cvp6WuWONviIThAPyPaFyrAoBnwVLcoMrbr0Ai5x6LQrmPQLoWJCyDPD
         GyxA==
X-Gm-Message-State: AOAM531mMEMjqwtrUigYmC/q76S4jdz28pxLFi/lcXBUN9Sogoer6C7k
        U0EV/gMGHkLk3H1eMjzvz7i4tA==
X-Google-Smtp-Source: ABdhPJzXIt7ZCXNKLguQN7iCvVvLI+EDT/Q0Dj1HLvNPmMNjO2x3c5nxy/MGerUjagXqZcuhjRVKDQ==
X-Received: by 2002:a17:903:1207:b0:138:e2f9:6c98 with SMTP id l7-20020a170903120700b00138e2f96c98mr4153452plh.11.1630609040137;
        Thu, 02 Sep 2021 11:57:20 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y14sm3063120pfp.84.2021.09.02.11.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 11:57:19 -0700 (PDT)
Date:   Thu, 2 Sep 2021 18:57:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Joerg Roedel <jroedel@suse.de>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest
 private memory
Message-ID: <YTEei9RBDHnRfe/B@google.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <20210827023150.jotwvom7mlsawjh4@linux.intel.com>
 <8f3630ff-bd6d-4d57-8c67-6637ea2c9560@www.fastmail.com>
 <20210901102437.g5wrgezmrjqn3mvy@linux.intel.com>
 <f37a61ba-b7ef-c789-5763-f7f237ae41cc@kernel.org>
 <YTCZAjdci5yx+n6l@suse.de>
 <b10b09b0-d5ea-b72a-106a-4e1b0df4dc66@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b10b09b0-d5ea-b72a-106a-4e1b0df4dc66@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 02, 2021, Andy Lutomirski wrote:
> On 9/2/21 2:27 AM, Joerg Roedel wrote:
> > On Wed, Sep 01, 2021 at 09:07:59AM -0700, Andy Lutomirski wrote:
> >> In principle, you could actually initialize a TDX guest with all of its
> >> memory shared and all of it mapped in the host IOMMU.
> > 
> > Not sure how this works in TDX, but in SEV code fetches are always
> > treated as encrypted. So this approach would not work with SEV, not to
> > speak about attestation, which will not work with this approach either
> > :)
> > 
> 
> Oof.

TDX is kinda similar.  _All_ accesses are private if paging is disabled because
the shared bit is either bit 48 or bit 51 in the GPA, i.e. can't be reached if
paging is disabled.  The vCPU is hardcoded to start in unpaged protected mode,
so at least some amount of guest memory needs to be private.

I also could've sworn code fetches from shared memory would #VE, but I can't find
anything in the specs that confirm that.  I may be conflating TDX with SGX's #GP
on a code fetch outside of ELRANGE...
