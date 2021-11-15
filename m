Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D024509B7
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 17:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhKOQfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 11:35:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27903 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231542AbhKOQfk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Nov 2021 11:35:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636993964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G+1QitFYBWiDQVxeYMxt+2T1PiW/Z24o7Opt5Dq5eOk=;
        b=cvRjN1uJ9zbz3EANIy5jj/ZKg/0m07rjndIurtSVMBe60e68Lk71lvMN8eN9TkeWZDIQ9W
        CTKqkM149rNdFv+MqnZqd+puodY049Iqf7NSC0GCmSKxr4y42BBjRxrFyyAsi493eKQemb
        cp6g/9HbYJPcEddJZ7kPSDoDZfUJSw4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-WgRqVFfQONa0r0mB4qhfcw-1; Mon, 15 Nov 2021 11:32:43 -0500
X-MC-Unique: WgRqVFfQONa0r0mB4qhfcw-1
Received: by mail-wr1-f70.google.com with SMTP id v17-20020adfedd1000000b0017c5e737b02so3759058wro.18
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 08:32:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=G+1QitFYBWiDQVxeYMxt+2T1PiW/Z24o7Opt5Dq5eOk=;
        b=waXHiPZ6watorL3TvCQxMXCkmdbrpO8vN9IPVdnrDhz0YBgO90rWCD2QeBwCzSsz5C
         4WNrYgAK5hO72axtJ5HTksQ5JYcOESF4U/jJKHn+bJTi0X2hN6uytkGsz2KJc/gCtnzY
         ebw774Wc+tfCrQo8hvXNyOhu5IEVLV1At5wQoxZltGx1idLnF9rBpprSs8za6H8Rdh+Z
         dJGnSX9N3uj/u+5AkMHW+1XKuzZq5N8X9rILiqEogVnmbnV+vEvhcLTUZ1C1jcGNqG0g
         lvH7TU8l9cF9bny8rM6EEZ7SYNttc7iSu3P0ljGOJbdBiOMy7su2ZICeo6Eftnffntq0
         hRow==
X-Gm-Message-State: AOAM533FvIguTF1j4wq48TeAvbatqcyVpiRyWpFEhcxxb1m9VJD+xKT2
        3GTQ7AMl7oGBjOtKE7XlUJh7MzXnSjgxPk2/fUmeNxpBXroCvaD79HD5km0jL4/DrchTtquEDy2
        KJFTArbLoxN+w
X-Received: by 2002:adf:ce0e:: with SMTP id p14mr268312wrn.423.1636993962264;
        Mon, 15 Nov 2021 08:32:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx1Ph4EnhC6A/4jYgelMQQLzwEg0cJbYa/8ZINUY3M4co7BZtJigqVuYd26TD4y155eMrBXqQ==
X-Received: by 2002:adf:ce0e:: with SMTP id p14mr268261wrn.423.1636993962082;
        Mon, 15 Nov 2021 08:32:42 -0800 (PST)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id c79sm14527579wme.43.2021.11.15.08.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 08:32:41 -0800 (PST)
Date:   Mon, 15 Nov 2021 16:32:38 +0000
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
Message-ID: <YZKLpiinvKcE896u@work-vm>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com>
 <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
 <YZJTA1NyLCmVtGtY@work-vm>
 <YZJx5PcBZ/izVg8L@suse.de>
 <YZJ9rzNOllCwvNEv@work-vm>
 <YZKI6lPIeniVSMjh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YZKI6lPIeniVSMjh@suse.de>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Joerg Roedel (jroedel@suse.de) wrote:
> On Mon, Nov 15, 2021 at 03:33:03PM +0000, Dr. David Alan Gilbert wrote:
> > How would you debug an unexpected access by the host kernel using a
> > guests kdump?
> 
> The host needs to log the access in some way (trace-event, pr_err) with
> relevant information.

Yeh OK that makes sense if the host-owner could then enable some type of
debugging based on that event for the unfortunate guest owner.

> And with the guest-side kdump you can rule out that it was a guest bug
> which triggered the access. And you learn what the guest was trying to
> do when it triggered the access. This also helps finding the issue on
> the host side (if it is a host-side issue).
> 
> (Guest and host owner need to work together for debugging, of course).

Yeh.

Dave

> Regards,
> 
> -- 
> Jörg Rödel
> jroedel@suse.de
> 
> SUSE Software Solutions Germany GmbH
> Maxfeldstr. 5
> 90409 Nürnberg
> Germany
>  
> (HRB 36809, AG Nürnberg)
> Geschäftsführer: Ivo Totev
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

