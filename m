Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 649644D28A3
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 07:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiCIGCb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 01:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiCIGC3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 01:02:29 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71E514FBE2
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 22:01:31 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id q11so1052249pln.11
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 22:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kcevlsyX45S/Hs4PDG56PNJGS3qbrRGtHL6niPzRHnY=;
        b=HnzXBO4oekApP/g7/vkFeOIByJVtdG5Qws7E+wxbSI68GmPXFUzJRt4GmX95ytIsrd
         BYwzBnjb3CefVFvxfuSSnAmE1koKwzeZrJpvcgi7XVbtw2SMkpqxxjlVg3RcImSWNbsc
         vnXffs3oREuUZGk06U8i0nokJl7DXauIKg0zdjSAxseRSNJcdq5ahzU8FSAo2KldzL1A
         IoamfzRriD6U7IdeVQobndfx2CXEalHjL8YJZxnJGMCMp5xICVjU0twGyr5zTf3NniKV
         dy9MWnI0dO7EL1s+8FT0wwDtF1Lh9eNRdXgBfMHuKtEKR5tq69IhslPQPSJ211m69ywb
         vERQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kcevlsyX45S/Hs4PDG56PNJGS3qbrRGtHL6niPzRHnY=;
        b=cHmLEtd6gBVf21gxkNL2Y91zKAUy51Jid4HPC5CrZEa3HebrXy3gAL9p9tkyRsHmhC
         yByV4Lcy20oC/FeE8V05j3Vnmv8wJCz+9HeTOkfKrJMgeFAHZgRSoSknZ33qlu2WpMnd
         Fqc0+oEoxWioCfZXGb9cbs61+BB9wt2H/F1WwRpyRhIvOpIA10rmyUT5Jo1B3/KJ4uvl
         yMASZkLiACdUxTPsU0Mx8cIOkFVjUD7Itq6yPE7h1/rL/RwkOg2I+f6veasT1IYo+g7a
         PXRmmhmR4UI9ftG++qEgbIUa6/muHbrqCozMsJBNzNjU84ItCiBraKo1+Ezb1tTxZ93+
         a4jw==
X-Gm-Message-State: AOAM5313OSV8fLOV5f5o+7/oYeiqSCUqz23Nf6fr/K15uB5kglclkQoM
        o6UtDsARkkoXYp0tYPgtqdHi/A==
X-Google-Smtp-Source: ABdhPJxHlzjX2z1M+HRZG2YfkjXprz/P3vNuoWngAMGkjIaBQ6Tk6GVwQ0+Q/ZjC9IYTLtFG4JjcNQ==
X-Received: by 2002:a17:902:e889:b0:14f:c4bc:677b with SMTP id w9-20020a170902e88900b0014fc4bc677bmr21129060plg.68.1646805690611;
        Tue, 08 Mar 2022 22:01:30 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d15-20020a056a00198f00b004f7109da1c4sm1044146pfl.205.2022.03.08.22.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 22:01:29 -0800 (PST)
Date:   Wed, 9 Mar 2022 06:01:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v6 6/9] KVM: x86: lapic: don't allow to change APIC ID
 unconditionally
Message-ID: <YihCtvDps/qJ2TOW@google.com>
References: <20220225082223.18288-1-guang.zeng@intel.com>
 <20220225082223.18288-7-guang.zeng@intel.com>
 <Yifg4bea6zYEz1BK@google.com>
 <20220309052013.GA2915@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309052013.GA2915@gao-cwp>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TL;DR: Maxim, any objection to yet another inhibit?  Any potential issues you can think of?

On Wed, Mar 09, 2022, Chao Gao wrote:
> On Tue, Mar 08, 2022 at 11:04:01PM +0000, Sean Christopherson wrote:
> >On Fri, Feb 25, 2022, Zeng Guang wrote:
> >> From: Maxim Levitsky <mlevitsk@redhat.com>
> >> 
> >> No normal guest has any reason to change physical APIC IDs,
> >
> >I don't think we can reasonably assume this, my analysis in the link (that I just
> >realized I deleted from context here) shows it's at least plausible that an existing
> >guest could rely on the APIC ID being writable.  And that's just one kernel, who
> >know what else is out there, especially given that people use KVM to emulate really
> >old stuff, often on really old hardware.
> 
> Making xAPIC ID readonly is not only based on your analysis, but also Intel SDM
> clearly saying writable xAPIC ID is processor model specific and ***software should
> avoid writing to xAPIC ID***.

Intel isn't the only vendor KVM supports, and xAPIC ID is fully writable according
to AMD's docs and AMD's hardware.  x2APIC is even (indirectly) writable, but luckily
KVM has never modeled that...

Don't get me wrong, I would love to make xAPIC ID read-only, and I fully agree
that the probability of breaking someone's setup is very low, I just don't think
the benefits of forcing it are worth the risk of breaking userspace.

> If writable xAPIC ID support should be retained and is tied to a module param,
> live migration would depend on KVM's module params: e.g., migrate a VM with
> modified xAPIC ID (apic_id_readonly off on this system) to one with
> xapic_id_readonly on would fail, right? Is this failure desired?

Hrm, I was originally thinking it's not a terrible outcome, but I was assuming
that userspace would gracefully handle migration failure.  That's a bad assumption.

> if not, we need to have a VM-scope control. e.g., add an inhibitor of APICv
> (XAPIC_ID_MODIFIED) and disable APICv forever for this VM if its vCPUs or
> QEMU modifies xAPIC ID.

Inhibiting APICv if IPIv is enabled (implied for AMD's AVIC) is probably a better
option than a module param.  I was worried about ending up with silently degraded
VM performance, but that's easily solved by adding a stat to track APICv inhibitions,
which would be useful for other cases too (getting AMD's AVIC enabled is comically
difficult).

That would also let us drop the code buggy avic_handle_apic_id_update().

And it wouldn't necessarily have to be forever, though I agree that's a perfectly
fine approach until we have data that shows anything fancier is necessary.

> >Practically speaking, anyone that wants to deploy IPIv is going to have to make
> >the switch at some point, but that doesn't help people running legacy crud that
> >don't care about IPIv.
> >
> >I was thinking a module param would be trivial, and it is (see below) if the
> >param is off by default.  A module param will also provide a convenient opportunity
> >to resolve the loophole reported by Maxim[1][2], though it's a bit funky.
> 
> Could you share the links?

Doh, sorry (they're both in this one).

https://lore.kernel.org/all/20220301135526.136554-5-mlevitsk@redhat.com
