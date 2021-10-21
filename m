Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3894368CF
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 19:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbhJURPR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 13:15:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34889 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231524AbhJURPQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 13:15:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634836380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XK8lsFGIy7ux6qnbNN7kYySECN4eAp1hXXWqZfwXvfI=;
        b=BG0be1cLzysYI4OBZB1nVlBclRylMWATpnmdRq9wGjNgUkn3fXW8SJj+iJcPlkRlWbJRhH
        IvpHlGhK3v2lpsKWlOs8zJsZQEFatb1aXkb678BhWs3o9VSrhtgczE86NIBuKUoxzZ1bhN
        SJKe3gf3PKaT0Y8KN5paPd2beMOjShc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-7mEypkQlPAS2e8x-oZ0pzg-1; Thu, 21 Oct 2021 13:12:58 -0400
X-MC-Unique: 7mEypkQlPAS2e8x-oZ0pzg-1
Received: by mail-wm1-f71.google.com with SMTP id k9-20020a7bc409000000b0030d978403e9so130350wmi.7
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 10:12:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XK8lsFGIy7ux6qnbNN7kYySECN4eAp1hXXWqZfwXvfI=;
        b=2jYcCwVJT0sPYVS/Tvq/LEDwnR4ePzzXS3moGpyHB7zFmcuuo8Y+b+rW+oypkXmUOt
         ou1FXaa9aSoD16VE96mnCyE/3YZJk/bFSWqXCq2RC1mOk9t8qMbUktUO7EJuzvkRfXu4
         SkbzzED0YyM8RRnXs/98KAr80Ia5qmseRwE+vd5Ytmpk7wVVxj4Zr2Qaiiic4ypPgIrt
         fOrXZM0zvZFdwjE/CiINVkyJwTnEMgHzDlFleD4t29ZgqG10omAxcNIrqkqqzVqNibD/
         iGAdS7G/pG3V4XZEOL/t6te2pbjyrJ1bZJJ7meVQqAoNVVjWrowSfMLCifKzk+9RxVpy
         Rw8A==
X-Gm-Message-State: AOAM530tQ1N/kpUBddwy3FsAAgNmEPas73pPyaph4V50wFLyPaijJq32
        27Vr6DD5hP9Dm1jD6rSz4Hn1VSh9R0ojtW/cSTtvz4FG0dtDxp2/LmCL5FddP+Qhq1q8VsqHJSL
        958n+VlDohKI3
X-Received: by 2002:adf:d84d:: with SMTP id k13mr9086400wrl.276.1634836377359;
        Thu, 21 Oct 2021 10:12:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIz2xc4dlFybQ+Itlm8MuVX7/TKhmdXDokBG8vkqS60XCLS5Pa1uXT6kLyhVWWxhAy7jGivg==
X-Received: by 2002:adf:d84d:: with SMTP id k13mr9086349wrl.276.1634836377142;
        Thu, 21 Oct 2021 10:12:57 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id d1sm5657617wrr.72.2021.10.21.10.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 10:12:56 -0700 (PDT)
Date:   Thu, 21 Oct 2021 18:12:53 +0100
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
Message-ID: <YXGflXdrAXH5fE5H@work-vm>
References: <20211008180453.462291-1-brijesh.singh@amd.com>
 <20211008180453.462291-9-brijesh.singh@amd.com>
 <YW2EsxcqBucuyoal@zn.tnic>
 <20211018184003.3ob2uxcpd2rpee3s@amd.com>
 <YW3IdfMs61191qnU@zn.tnic>
 <20211020161023.hzbj53ehmzjrt4xd@amd.com>
 <YXF9sCbPDsLwlm42@zn.tnic>
 <YXGNmeR/C33HvaBi@work-vm>
 <YXGbcqN2IRh9YJk9@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXGbcqN2IRh9YJk9@zn.tnic>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Borislav Petkov (bp@alien8.de) wrote:
> On Thu, Oct 21, 2021 at 04:56:09PM +0100, Dr. David Alan Gilbert wrote:
> > I can imagine a malicious hypervisor trying to return different cpuid
> > answers to different threads or even the same thread at different times.
> 
> Haha, I guess that will fail not because of SEV* but because of the
> kernel not really being able to handle heterogeneous CPUIDs.

My worry is if it fails cleanly or fails in a way an evil hypervisor can
exploit.

> > Well, the spec (AMD 56860 SEV spec) says:
> > 
> >   'If firmware encounters a CPUID function that is in the standard or extended ranges, then the
> > firmware performs a check to ensure that the provided output would not lead to an insecure guest
> > state'
> > 
> > so I take that 'firmware' to be the PSP; that wording doesn't say that
> > it checks that the CPUID is identical, just that it 'would not lead to
> > an insecure guest' - so a hypervisor could hide any 'no longer affected
> > by' flag for all the CPUs in it's migration pool and the firmware
> > shouldn't complain; so it should be OK to pessimise.
> 
> AFAIU this, I think this would depend on "[t]he policy used by the
> firmware to assess CPUID function output can be found in [PPR]."
> 
> So if the HV sets the "no longer affected by" flag but the firmware
> deems this set flag as insecure, I'm assuming the firmare will clear
> it when it returns the CPUID leafs. I guess I need to go find that
> policy...

<digs - ppr_B1_pub_1 55898 rev 0.50 >

OK, so that bit is 8...21 Eax ext2eax bit 6 page 1-109

then 2.1.5.3 CPUID policy enforcement shows 8...21 EAX as
'bitmask'
'bits set in the GuestVal must also be set in HostVal.
This is often applied to feature fields where each bit indicates
support for a feature'

So that's right isn't it?

Dave

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

