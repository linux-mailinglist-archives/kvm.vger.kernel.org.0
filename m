Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411CA45089B
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 16:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236815AbhKOPge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 10:36:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31403 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236639AbhKOPgI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Nov 2021 10:36:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636990389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=APBRR/Tu29EEMq5VPRu2UikpYWd3k5GAcRpc7iagv8Y=;
        b=iSq5dZ11iKlabDh5S81yAjysNZaK05j+T/3Db3PfuPoWHz+O2DDtCbLnJNoL5Bmm3bf+e3
        PYnvmk2ruRsjVyrFhr6BCYnvHOx9eCpptvzazpmLTWqq1qwvhX6aHMj1O7ax00tAynE1DY
        t1MJZUC5uszmBAnOmVeBfxEJeB2nF/k=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-NKfOAKyGNb-Cs_NAv18RAQ-1; Mon, 15 Nov 2021 10:33:07 -0500
X-MC-Unique: NKfOAKyGNb-Cs_NAv18RAQ-1
Received: by mail-wm1-f70.google.com with SMTP id o18-20020a05600c511200b00332fa17a02eso61891wms.5
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 07:33:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=APBRR/Tu29EEMq5VPRu2UikpYWd3k5GAcRpc7iagv8Y=;
        b=dBMvIrGQBBfhwp8gvgdXyS5MQfCDsydLWTPCEH9WbkXueSKAZeZjn9ttKYHi7YTFfs
         H3tVohUZ943hLrTi00xYBx3VTCrRaalm0TrKbrLo/gdG5OpBYQw95lk6EArbvFe8Rxcd
         ACtd4iuieaiEBOQqkveJAmXoEG6F5GkB5zEAeLATsJOLvDGPgZlCbNK4J/RoTcfne72/
         efxLYcZjlP6gw7rrdPd/Pxd8DQnVp4CmQ0gIJRvQze9VaH7xv/wCWH5a7AZQprTZalNe
         LpNbf99ncfheKlXcgCu+UMuXHYNWqrro093UIhf3Qo21F600Zi0Apnz+PtOqMHwnahOP
         xaZQ==
X-Gm-Message-State: AOAM533qKEWrhYetPfpD+JHzszQhIZE9XcyDG0h2uKxK15gRusj4zA/y
        BN5V2JrtCEEoviBk3QNy6mhvTGCEc2Q3yNvw75MnNDifRo+gf//styMLDSRNwvSrz/pihqSPXbq
        ovfgklD58KA2i
X-Received: by 2002:a1c:f416:: with SMTP id z22mr3828161wma.121.1636990386548;
        Mon, 15 Nov 2021 07:33:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzVEfAw7ZxqSyPXBoql05G+DuRg+Mia/ijEWI8l4vzLqLBTzBiaKW9nePq93987lkPciDsGDA==
X-Received: by 2002:a1c:f416:: with SMTP id z22mr3828132wma.121.1636990386389;
        Mon, 15 Nov 2021 07:33:06 -0800 (PST)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id t8sm17359470wmq.32.2021.11.15.07.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 07:33:05 -0800 (PST)
Date:   Mon, 15 Nov 2021 15:33:03 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <YZJ9rzNOllCwvNEv@work-vm>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com>
 <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
 <YZJTA1NyLCmVtGtY@work-vm>
 <YZJx5PcBZ/izVg8L@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZJx5PcBZ/izVg8L@suse.de>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Joerg Roedel (jroedel@suse.de) wrote:
> On Mon, Nov 15, 2021 at 12:30:59PM +0000, Dr. David Alan Gilbert wrote:
> > Still; I wonder if it's best to kill the guest - maybe it's best for
> > the host to kill the guest and leave behind diagnostics of what
> > happened; for someone debugging the crash, it's going to be less useful
> > to know that page X was wrongly accessed (which is what the guest would
> > see), and more useful to know that it was the kernel's vhost-... driver
> > that accessed it.
> 
> I is best to let the guest #VC on the page when this happens. If it
> happened because of a guest bug all necessary debugging data is in the
> guest and only the guest owner can obtain it.
> 
> Then the guest owner can do a kdump on this unexpected #VC and collect
> the data to debug the issue. With just killing the guest from the host
> side this data would be lost.

How would you debug an unexpected access by the host kernel using a
guests kdump?

Dave

> Regards,
> 
> 	Joerg
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

