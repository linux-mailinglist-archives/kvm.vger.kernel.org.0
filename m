Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF83A37990A
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 23:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbhEJVTO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 17:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbhEJVTD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 17:19:03 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A921C06175F
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 14:17:58 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id b21so7426771pft.10
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 14:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0n88KguwK4u1Tl40XFeYJoKeAxPDsastf87y73L4zpU=;
        b=bA4rMWnN7wm4v/a7EQ9UE5EfJewP1uei2YncP5LVPTIMrZHcbxqJTZncdbPvGuag7M
         SOn9d1m9ir1oUtIaL396Jk2zcmZlgzzq22MqPdrxU23iqWuBUx5SpGG+rh6VhtJlEe9x
         SK0i13IrBunc1t1JqsrmeTCpt4zZ+QcJ2UVDvDleEU2hQnTrVLtNvG2cpk1HELkBlPqn
         ZAHNnrOsx2PtVO7s4UtUPGMTvf+DtBtSLqnXAuSvCewRDTFvlvfWjlPkvVL1nfNqpZFs
         oF3RER3pvNMy08u0Mx+VljVqvnzwL9W7E1OfL4AJPSjdYkWS8STTkmIDTAkgzye8tPHt
         3FTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0n88KguwK4u1Tl40XFeYJoKeAxPDsastf87y73L4zpU=;
        b=J88eAnXNaIrf/Q3L0Egmj9J0E1lvIbLJhkQ7NDSHLl4644AdkPWJyet4hIsaxZvWJ8
         OBIRUJuSzcEGOmqKGkJIkmg+yYS/kcaNihesx3zgE9NP5tGVekj0Z/F2FALVCmBxmReM
         sBU7O/i2ORHkNBfquW6JEuq5zAlq/yd1yrG7hkjauXpknTMAb0UZRY4qoewbIEfNiv00
         j7GEtMOvV/x3vHuCPiflLkHcofkVyu+0D7vNk1YiGwJda16zY8UnTf+/8Wne1SA0lWm3
         c8WCGJzXydkyo81m8R/MSvDE9XrvkEmLh4MrkNKQUcgkRuUyi/Rk0WVWWmhgdHgyrg/s
         m+tA==
X-Gm-Message-State: AOAM533u8k2W9Jmnlx2bTe4xO/CrBTfYmphc08l0Fl7Ej5hrcJ4gcCnq
        EEVx2xVCVfCWJLCBGjRwdtbu3YFwL4c7rw==
X-Google-Smtp-Source: ABdhPJy9w+X4oY2R3aIS+LuC4kgu8dLv7P/58an6EiZEdbMJtO8s28rzY3t1vB20O8L4vKb6gxiKIw==
X-Received: by 2002:a63:9d48:: with SMTP id i69mr27113197pgd.297.1620681477999;
        Mon, 10 May 2021 14:17:57 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id n30sm11679056pfv.52.2021.05.10.14.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 14:17:57 -0700 (PDT)
Date:   Mon, 10 May 2021 21:17:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     Peter Gonda <pgonda@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, jroedel@suse.de,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Rientjes <rientjes@google.com>, peterz@infradead.org,
        "H. Peter Anvin" <hpa@zytor.com>, tony.luck@intel.com
Subject: Re: [PATCH Part2 RFC v2 36/37] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
Message-ID: <YJmjAaogWeFgCEmb@google.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
 <20210430123822.13825-37-brijesh.singh@amd.com>
 <CAMkAt6ottZkx02-ykazkG-5Tu5URv-xwOjWOZ=XMAXv98_HOYA@mail.gmail.com>
 <f357d874-a369-93b6-ffa1-75c643596c81@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f357d874-a369-93b6-ffa1-75c643596c81@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021, Brijesh Singh wrote:
> 
> On 5/10/21 1:57 PM, Peter Gonda wrote:
> >> +e_fail:
> >> +       ghcb_set_sw_exit_info_2(ghcb, rc);
> >> +       return;
> >> +
> >> +e_term:
> >> +       ghcb_set_sw_exit_info_1(ghcb, 1);
> >> +       ghcb_set_sw_exit_info_2(ghcb,
> >> +                               X86_TRAP_GP |
> >> +                               SVM_EVTINJ_TYPE_EXEPT |
> >> +                               SVM_EVTINJ_VALID);
> >> +}
> > I am probably missing something in the spec but I don't see any
> > references to #GP in the '4.1.7 SNP Guest Request' section. Why is
> > this different from e_fail?
> 
> The spec does not say to inject the #GP, I chose this because guest is
> not adhering to the spec and there was a not a good error code in the
> GHCB spec to communicate this condition. Per the spec, both the request
> and response page must be a valid GPA. If we detect that guest is not
> following the spec then its a guest BUG. IIRC, other places in the KVM
> does something similar when guest is trying invalid operation.

The GHCB spec should be updated to define an error code, even if it's a blanket
statement for all VMGEXITs that fail to adhere to the spec.  Arbitrarily choosing
an error code and/or exception number makes the information useless to the guest
because the guest can't take specific action for those failures.  E.g. if there
is a return code specifically for GHCB spec violation, then the guest can panic,
WARN, etc... knowing that it done messed up.

"Injecting" an exception is particularly bad, because if the guest kernel takes
that request literally and emulates a #GP, then we can end up in a situation
where someone files a bug report because VMGEXIT is hitting a #GP and confusion
ensues.
