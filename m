Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9750296E22
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 14:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370068AbgJWMCA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 08:02:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32256 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S369960AbgJWMCA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 08:02:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603454519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+T8I0jNVBNJFOZTug7Hno1Fe0JWTKHlCqa4g8/dHMVc=;
        b=VV8g+69vCT4IlKZxVXhO9HjnDixG5e44ULb/AadU1z8GOBvPHtt09DFFXZ/U3XhOimY55Z
        iM8dZQc9o69FUKUuiWjnNF5SUL8ZCnd2rznfSj1PG1JbLRIr0KxfKarqYGfpB02/XcHvPf
        P9fiE0Zf+M6/LgDg+JKoao5yoaUzkYk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-XxFH7Q-ePlSnQtDWtRPRdQ-1; Fri, 23 Oct 2020 08:01:57 -0400
X-MC-Unique: XxFH7Q-ePlSnQtDWtRPRdQ-1
Received: by mail-ed1-f70.google.com with SMTP id b16so469436edn.6
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 05:01:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=+T8I0jNVBNJFOZTug7Hno1Fe0JWTKHlCqa4g8/dHMVc=;
        b=C2hlnIyYt55DApKoIKNUChoov+9SpkPDVVWP8jt5HCis2ZOtOBvk/7H2uKuXEaYM5j
         fGcjhNnXlYNQPHdJH+siFp5Ox1+cwqOkv1eAhm0pVgcdQZcqWqCo3v9rNGkSiPADhWCw
         FxSxfVpWZ2dd6Z9l6P9TurHvKQyMlJMGlWvM5to+D+t2pqN00EUNdQIXaIpZC7Tn+DUQ
         JrrfeoHzZzA3FFzQI117yr9sqAYNibsRgbgx4lAtcCNmpnDdNR/yP9OAkPzTr5F9GB+m
         hJGulTnKRD9ZzrpdLiNTFvwKI0tHMJn84AbqpE4VearfI16CkJxE6gbRjzVT0fj5yIGT
         XCmg==
X-Gm-Message-State: AOAM533fw8JDgxa2EBJvltVuvf+LVKFL2ltEt2X2UEqDj4OlxEvD4rAY
        6xDFRo7apXx2w6MCyaWHKdNnBeGf4FJkCKKWYGPrSn4AuM4p0IX/Y2bv2IJKygChQnDLNG27LFF
        ptdGBxDVIgWNe
X-Received: by 2002:a17:906:51d0:: with SMTP id v16mr1613515ejk.493.1603454515431;
        Fri, 23 Oct 2020 05:01:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWj/IH2qG1/G46kgLoOFSkW0cPWu+PRxOBTYjbHxfBibpdohWghdzXq1cXPRl/OHFLo79U9g==
X-Received: by 2002:a17:906:51d0:: with SMTP id v16mr1613476ejk.493.1603454515155;
        Fri, 23 Oct 2020 05:01:55 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id k25sm723342ejz.93.2020.10.23.05.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 05:01:54 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe\, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen\, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [RFCv2 00/16] KVM protected memory extension
In-Reply-To: <20201023113517.j543e77hmqenjvgw@box>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com> <87ft6949x8.fsf@vitty.brq.redhat.com> <20201020134924.2i4z4kp6bkiheqws@box> <87eelr4ox3.fsf@vitty.brq.redhat.com> <20201023113517.j543e77hmqenjvgw@box>
Date:   Fri, 23 Oct 2020 14:01:53 +0200
Message-ID: <87sga52lse.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Kirill A. Shutemov" <kirill@shutemov.name> writes:

> On Wed, Oct 21, 2020 at 04:46:48PM +0200, Vitaly Kuznetsov wrote:
>> "Kirill A. Shutemov" <kirill@shutemov.name> writes:
>> 
>> > Maybe it would be cleaner to handle reboot in userspace? If we got the VM
>> > rebooted, just reconstruct it from scratch as if it would be new boot.
>> 
>> We are definitely not trying to protect against malicious KVM so maybe
>> we can do the cleanup there (when protection was enabled) so we can
>> unprotect everything without risk of a leak?
>
> Do you have any particular codepath in mind? I didn't find anything
> suitable so far.

I didn't put much thought in it but e.g. on x86, what if we put this to
kvm_vcpu_reset() under 'if (kvm_vcpu_is_bsp())' condition? 

The main problem I see is that we can't clean up *all* memory,
e.g. firmware related stuff should stay intact and this contraducts your
KVM_HC_ENABLE_MEM_PROTECTED which protects everything. We can, probably,
get rid of it leaving KVM_HC_MEM_SHARE/KVM_HC_MEM_UNSHARE only shifting
responsibility to define what can be cleaned up on the guest kernel
(stating in the doc that all protected memory will get whiped out on
reboot).

-- 
Vitaly

