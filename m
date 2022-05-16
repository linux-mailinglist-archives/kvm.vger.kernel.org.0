Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4469552928E
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 23:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348937AbiEPVJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 17:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349207AbiEPVIN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 17:08:13 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF67F4A3E8
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 13:49:56 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id i17so15557008pla.10
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 13:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KrZd1d7ZW1bFcikModx6EkxPFI/wL98ky5uKMz/aH5s=;
        b=MONmx06zlMIYc3wCFtScWn/8i4RuJ7ZboFJ76kZhENs65e+45QZ9TJiv8sWMkWiH3i
         oMf04Udsv5xFLVu8pZE6Oi957vt5/1YMSwrOFXbdWqCnWjD3OiHE+stQXPhVfLhrNtUD
         YTr/FlydzldOfEek6k+R0YmmIbjNWSeIWc99Arc2CAig9n+ZY1W3JXsqnHmHZaOU+rce
         sCdtaAQuzebqWxJEffXBMZkzQ+FIg8wmEWPNFp/6+5tC0BpkpszO707w1tYwG2vRUQHs
         4XzCsZAs3Lm+5PtNS0cv7POMWbi8quYX8ck/U6lsOwQ8TanCa4cAzne213tIRV4+xwlF
         Ntwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KrZd1d7ZW1bFcikModx6EkxPFI/wL98ky5uKMz/aH5s=;
        b=R69Vvxnucwl2bLIQF1k/ojCEqtOFnRn1oMOK53Jlany2omtpy9sodAkon4EyHiCT86
         Z10iawNid5wfo81GVlTxCrSeTYnLsh4Gffdj/a1zSA1eCK6wJcFnYjHNKx+/f7EA4Mjf
         /DRD5BoVUmMeVad8nIQ1QztoOhwrJJLCVJZ15JSdF6FiBvveHzaLrfpdbxb61hE/SLV8
         wuLLBny5vG2FRoOStsUw/aYyxfm69TsjuQsfW8s4ks77lpeImFL+AxhRUzF7LpfQMHFZ
         EV8GRg302Pbu9WfyvL2XmeAj949XRm6XjJ/PKJVisYI2XTjQbs+cedfZLlSdrNVTcNYS
         Z25g==
X-Gm-Message-State: AOAM530p2KtYpMgSqBCpPpYoHx1wSI1UVIs7lo2GYXAhFY7XtIEujuyi
        Bb1z4JKSWyR1SqVv13FpPVfe8g==
X-Google-Smtp-Source: ABdhPJyfN+D2uao0MqY3oPEXUKmvH4qWuWl1YZgKcJeE6F9PV+VJP4kEuxpIbb6adk0PONfl+dMizw==
X-Received: by 2002:a17:902:e94e:b0:15b:22a7:f593 with SMTP id b14-20020a170902e94e00b0015b22a7f593mr19047116pll.148.1652734196312;
        Mon, 16 May 2022 13:49:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n12-20020a1709026a8c00b0015ea9aabd19sm7372503plk.241.2022.05.16.13.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 13:49:55 -0700 (PDT)
Date:   Mon, 16 May 2022 20:49:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v9 0/9] IPI virtualization support for VM
Message-ID: <YoK48P2UrrjxaRrJ@google.com>
References: <20220419153155.11504-1-guang.zeng@intel.com>
 <2d33b71a-13e5-d377-abc2-c20958526497@redhat.com>
 <cf178428-8c98-e7b3-4317-8282938976fd@intel.com>
 <f0e633b3-38ea-f288-c74d-487387cefddc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0e633b3-38ea-f288-c74d-487387cefddc@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 03, 2022, Paolo Bonzini wrote:
> On 5/3/22 09:32, Zeng Guang wrote:
> > 
> > I don't see "[PATCH v9 4/9] KVM: VMX: Report tertiary_exec_control field in
> > dump_vmcs()" in kvm/queue. Does it not need ?
> 
> Added now (somehow the patches were not threaded, so I had to catch them one
> by one from lore).
> 
> > Selftests for KVM_CAP_MAX_VCPU_ID is posted in V2 which is revised on top of
> > kvm/queue.
> > ([PATCH v2] kvm: selftests: Add KVM_CAP_MAX_VCPU_ID cap test - Zeng
> > Guang (kernel.org) <https://lore.kernel.org/lkml/20220503064037.10822-1-guang.zeng@intel.com/>)
> 
> Queued, thanks.

Shouldn't we have a solution for the read-only APIC_ID mess before this is merged?
