Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9587F4369B0
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 19:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbhJURuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 13:50:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47886 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232435AbhJURuN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 13:50:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634838476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sdVy6FwDaq466AExZNtZZOl0E2m/+xf4V5tJYwOKByc=;
        b=eugDPjAcOFmIxVsh4ad+0OdKhkR40/LvJTeI92IFk1pXjalZ2RP0xkxKAvn397qtP222t2
        Qz76xSDgujap/RGCf22oabsaRZ8CONB3e2Tbw77TLgTeDR1C5+PoPNp7uUsAzzeLxO3VvH
        FmU4u0Ghc36bQRFYU4zTe7ieDmPQNI8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-Eii-Jdv6P-Sfw_8obDIS6Q-1; Thu, 21 Oct 2021 13:47:55 -0400
X-MC-Unique: Eii-Jdv6P-Sfw_8obDIS6Q-1
Received: by mail-wm1-f72.google.com with SMTP id o22-20020a1c7516000000b0030d6f9c7f5fso183564wmc.1
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 10:47:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sdVy6FwDaq466AExZNtZZOl0E2m/+xf4V5tJYwOKByc=;
        b=EFCwFs4TdOzGEmCGnR76fTMpJcZy6E2SAqT44LaCJArar2RdIdSsUiD7j30XNgDPO6
         enGMpFS5GQDp4ffi1nD5ZJfKBjlAFv2cax2pkv5CVIMpwfCu0So2BaDgUHovUoHG7r/g
         2akrztL84dYg26X9wv6HH8oXSvDMOXnTHPFQtXP88Gy5KKrv8YdLRAEF5KXmxZ7ZSRAF
         mDczNPotoVHfublIzT6/qeH34oCHgjbZsVaQLe0gD+Acy0FhPdpmPfeImRAg8DrX5hWH
         yMLyq/mEuQCnUlJXvZCKtsa3s3C4NoVJlm7ftoDthAMJc8O+z5JIINJHtO747WUErudX
         uAMw==
X-Gm-Message-State: AOAM531PD5vgguEVUIQvm8+0sGto4f3D/N0X5nhHghQor5FYfWoortiZ
        3gTubwEfsANsyRJLlw+yDkTidnsQoLZx/AzmJmdQ95DGAkvinNI25KFFlGyOPfdW1kv+9Noail4
        9PzUZcsCiiLYg
X-Received: by 2002:a7b:cbd1:: with SMTP id n17mr23050389wmi.113.1634838473751;
        Thu, 21 Oct 2021 10:47:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrJOA3K2+jcEdUJkI5yUOvDRbh0LHvWJK/dSXnO5HgNUEG6KoK85UuOyllpMd1Zyh5XoN7lA==
X-Received: by 2002:a7b:cbd1:: with SMTP id n17mr23050368wmi.113.1634838473557;
        Thu, 21 Oct 2021 10:47:53 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id l40sm6144308wms.31.2021.10.21.10.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 10:47:52 -0700 (PDT)
Date:   Thu, 21 Oct 2021 18:47:50 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Michael Roth <michael.roth@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH v6 08/42] x86/sev-es: initialize sev_status/features
 within #VC handler
Message-ID: <YXGnxs0hV3IKGDwP@work-vm>
References: <20211008180453.462291-9-brijesh.singh@amd.com>
 <YW2EsxcqBucuyoal@zn.tnic>
 <20211018184003.3ob2uxcpd2rpee3s@amd.com>
 <YW3IdfMs61191qnU@zn.tnic>
 <20211020161023.hzbj53ehmzjrt4xd@amd.com>
 <YXF9sCbPDsLwlm42@zn.tnic>
 <YXGNmeR/C33HvaBi@work-vm>
 <YXGbcqN2IRh9YJk9@zn.tnic>
 <YXGflXdrAXH5fE5H@work-vm>
 <YXGlPf5OTPzp09qr@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXGlPf5OTPzp09qr@zn.tnic>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Borislav Petkov (bp@alien8.de) wrote:
> On Thu, Oct 21, 2021 at 06:12:53PM +0100, Dr. David Alan Gilbert wrote:
> > OK, so that bit is 8...21 Eax ext2eax bit 6 page 1-109
> > 
> > then 2.1.5.3 CPUID policy enforcement shows 8...21 EAX as
> > 'bitmask'
> > 'bits set in the GuestVal must also be set in HostVal.
> > This is often applied to feature fields where each bit indicates
> > support for a feature'
> > 
> > So that's right isn't it?
> 
> Yap, AFAIRC, it would fail the check if:
> 
> (GuestVal & HostVal) != GuestVal
> 
> and GuestVal is "the CPUID result value created by the hypervisor that
> it wants to give to the guest". Let's say it clears bit 6 there.
                                               ^^^^^^^

> Then HostVal comes in which is "the actual CPUID result value specified
> in this PPR" and there the guest catches the HV lying its *ss off.
> 
> :-)

Hang on, I think it's perfectly fine for it to clear that bit - it just
gets caught if it *sets* it (i.e. claims to be a chip unaffected by the
bug).

i.e. if guestval=0 then (GustVal & whatever) == GuestVal
  fine

?

Dave

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

