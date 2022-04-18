Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE65505C6E
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 18:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346150AbiDRQbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 12:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346151AbiDRQbC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 12:31:02 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF55730550
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 09:28:17 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id s14-20020a17090a880e00b001caaf6d3dd1so17659323pjn.3
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 09:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=8nM2jf1CGGE3DnIMs28D4owMdrw5+WAhxQlmYFlxEUo=;
        b=LIsvbw5CEY1J9npdI1tl7WGCdJZ/B1blBL4mGnU7RJXbTyPsNX8dxmZtufohcZ6zq9
         uCRs8Mcf5bwuPj+OzL4hL4OofEt3VbCH6GbmFFvd4nWIPu6A6CWkZB42kz+sKUb9qwUo
         Ht40LR0xZ6IctJWQzNEbpTCuPWU4SGYUnK0Yc+FD++y/EguF7yAEjF19uo9vVAEMCP7P
         IV/AJ/gQl0mriUIKEjZUFyIuIc0oIP0TRON5mQOWeAho1tmqCiRZXGrycyKpHQdAEiMz
         vHastx1F3caFPpfmV0MShUQiEg7Ojg4eu4yYUuN1Rx4KZkuVMoNa2h9GHrBOf8fU57ss
         Tu8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=8nM2jf1CGGE3DnIMs28D4owMdrw5+WAhxQlmYFlxEUo=;
        b=fMnDzBWpP2+GObpZffd6Cjp49N5QojdS17K9w9XRL6b1ezT3hNPqadgqgqxVRMTCWF
         oym86kqUxymeyNz1tQKbtxc989QXGEBjikCUiSAI3zCbMAIkhPjGBgJ2KiCz73FdrRY8
         99A45UWPtUT4hVN9j9h0MQBJJdInH0jMaqeFNDF6pUhpYFbAClswf2xtY9i+aVjfr5Go
         RUSkhKnL6oeG48C5slUd8/7krDYQuimejIku+wH2BzCUevLo5Al7OPkXQVCRTZRZmPyd
         Ej2WYhkFwPKF/Hp/jAai1Ykr0d3IAc4iCn5ngdoke3bO65nf08WDWAus71yg1WfBxLCm
         AYaw==
X-Gm-Message-State: AOAM530wD4518EACMhloj09plzBvv2IOZETBYwrwYrbt7zR5lA/WNuAN
        C/dffrAI3/CoRCww0X2APgoyag==
X-Google-Smtp-Source: ABdhPJylHT3chWGSWgex6OgAP6qN8Gp0Fu8KhEW1O1/RbqFHj9NnKD+k+SluDXx4cMdl29AxH0CUPQ==
X-Received: by 2002:a17:902:f24b:b0:158:f5c3:a210 with SMTP id j11-20020a170902f24b00b00158f5c3a210mr8316728plc.65.1650299297191;
        Mon, 18 Apr 2022 09:28:17 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k11-20020a056a00168b00b004f7e1555538sm13685626pfc.190.2022.04.18.09.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 09:28:16 -0700 (PDT)
Date:   Mon, 18 Apr 2022 16:28:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Balbir Singh <sblbir@amazon.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kim Phillips <kim.phillips@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>,
        Bijan Mottahedeh <bijan.mottahedeh@nutanix.com>
Subject: Re: [PATCH] x86/speculation, KVM: respect user IBPB configuration
Message-ID: <Yl2RnIjUTfQ0Avc9@google.com>
References: <20220411164636.74866-1-jon@nutanix.com>
 <YlmBC6gaGRrAZm3L@google.com>
 <0AB658FD-FA01-4D27-BA17-C3001EC6EA00@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0AB658FD-FA01-4D27-BA17-C3001EC6EA00@nutanix.com>
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

On Fri, Apr 15, 2022, Jon Kohler wrote:
> 
> > On Apr 15, 2022, at 10:28 AM, Sean Christopherson <seanjc@google.com> wrote:
> > But stepping back, why does KVM do its own IBPB in the first place?  The goal is
> > to prevent one vCPU from attacking the next vCPU run on the same pCPU.  But unless
> > userspace is running multiple VMs in the same process/mm_struct, switching vCPUs,
> > i.e. switching tasks, will also switch mm_structs and thus do IPBP via cond_mitigation.
> 
> Good question, I couldn’t figure out the answer to this by walking the code and looking
> at git history/blame for this area. Are there VMMs that even run multiple VMs within
> the same process? The only case I could think of is a nested situation?

Selftests? :-)

> > If userspace runs multiple VMs in the same process, enables cond_ipbp, _and_ sets
> > TIF_SPEC_IB, then it's being stupid and isn't getting full protection in any case,
> > e.g. if userspace is handling an exit-to-userspace condition for two vCPUs from
> > different VMs, then the kernel could switch between those two vCPUs' tasks without
> > bouncing through KVM and thus without doing KVM's IBPB.
> 
> Exactly, so meaning that the only time this would make sense is for some sort of nested
> situation or some other funky VMM tomfoolery, but that nested hypervisor might not be 
> KVM, so it's a farce, yea? Meaning that even in that case, there is zero guarantee
> from the host kernel perspective that barriers within that process are being issued on
> switch, which would make this security posture just window dressing?
> 
> > 
> > I can kinda see doing this for always_ibpb, e.g. if userspace is unaware of spectre
> > and is naively running multiple VMs in the same process.
> 
> Agreed. I’ve thought of always_ibpb as "paranoid mode" and if a user signs up for that,
> they rarely care about the fast path / performance implications, even if some of the
> security surface area is just complete window dressing :( 
> 
> Looking forward, what if we simplified this to have KVM issue barriers IFF always_ibpb?
> 
> And drop the cond’s, since the switching mm_structs should take care of that?
> 
> The nice part is that then the cond_mitigation() path handles the going to thread
> with flag or going from a thread with flag situation gracefully, and we don’t need to
> try to duplicate that smarts in kvm code or somewhere else.

Unless there's an edge case we're overlooking, that has my vote.  And if the
above is captured in a comment, then there shouldn't be any confusion as to why
the kernel/KVM is consuming a flag named "switch_mm" when switching vCPUs, i.e.
when there may or may not have been a change in mm structs.
