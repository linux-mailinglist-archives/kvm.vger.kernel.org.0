Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F55F502C0C
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 16:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243255AbiDOOnA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 10:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354522AbiDOOmY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 10:42:24 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443121A3A3
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 07:39:53 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id mm4-20020a17090b358400b001cb93d8b137so11954261pjb.2
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 07:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1MnvIUTCnDUhW/MEcdcS6a3sJGad6CD8T1rW5EsHJho=;
        b=ERP9pfWyY6alNYGhD48Zx2tVKN4LFJdrCOxLl3DgrkY8Uoebc+mqvBHsJ0wNr0H91I
         iJlOikU9SuosDX3fezHVHtW/9TaCkdUJFWtppyap9e4ThipVFTS1UYRIF1XL63AJQ6+b
         N5kAbODQQoSrY0Igts9Vv2ptmwOLZ/rHvl13UotTUsYZoRv9hrSOSlg8l8CjvbdPj6Hk
         wzuOPlYgSwylW5rt+oE4SaY0RAhCm/vIuZKUTC90h3m1Wcg9a9tatSQwi3gEFM83zBr5
         oU1XixgbbeyUZH0/n//qIs8FGfjWlgqM3+cFfQ037bArt8Wct10TDXW2gRoAlx/opM55
         PLrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1MnvIUTCnDUhW/MEcdcS6a3sJGad6CD8T1rW5EsHJho=;
        b=g+PEonteEC0YjmaFt5RHQUNXI7pWDyv1nmm7IJiKrxNFWimuoRJDIRUtdt/2ANqG7p
         zQPLDjCj+uxph9A5zyjp3SryeVbLd04Xkwh4/x1EtF1ggvxls7TNfubNdJGy57XQ605F
         D6hr1dHrlHg08AtYAdezpSHpe6aYsqHx4wzMqT4s8I/MVxltthH6e/75RTenep0Huyyg
         2JPd5CU5I8eubYVTGDGID08a8FgM2qcsWd1VllsEJ/unStG5Mai5CyN+SZa4oQaKWDWu
         d1N4YH43ZQJXQFEp6VRi1MyeOg63yaXNbobDiBzpXHNtGMNiNYuR4TXDJeaEwa5oSg8i
         SzzQ==
X-Gm-Message-State: AOAM530WnCrEQ0tuc19P3uixKBpYR5SLgJWbPJVJ4RdF/gs12UplG2J8
        Te1skycdqMO+NcXtijkutkzfBg==
X-Google-Smtp-Source: ABdhPJxiWSn2FG95SA76dSXfh63IIlA1JbMOT4SlEzlrg7n8lbIUkNG860vEUcouEZ8VKy45Cf5TOQ==
X-Received: by 2002:a17:90a:6501:b0:1ca:a7df:695c with SMTP id i1-20020a17090a650100b001caa7df695cmr4587060pjj.152.1650033592553;
        Fri, 15 Apr 2022 07:39:52 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k4-20020a17090a3e8400b001cd37f6c0b7sm4868835pjc.46.2022.04.15.07.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 07:39:51 -0700 (PDT)
Date:   Fri, 15 Apr 2022 14:39:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
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
        Gao Chao <chao.gao@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v8 6/9] KVM: x86: lapic: don't allow to change APIC ID
 unconditionally
Message-ID: <YlmDtC73u/AouMsu@google.com>
References: <20220411090447.5928-1-guang.zeng@intel.com>
 <20220411090447.5928-7-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411090447.5928-7-guang.zeng@intel.com>
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

On Mon, Apr 11, 2022, Zeng Guang wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
> 
> No normal guest has any reason to change physical APIC IDs, and
> allowing this introduces bugs into APIC acceleration code.
> 
> And Intel recent hardware just ignores writes to APIC_ID in
> xAPIC mode. More background can be found at:
> https://lore.kernel.org/lkml/Yfw5ddGNOnDqxMLs@google.com/
> 
> Looks there is no much value to support writable xAPIC ID in
> guest except supporting some old and crazy use cases which
> probably would fail on real hardware. So, make xAPIC ID
> read-only for KVM guests.

AFAIK, the plan is to add a capability to let userspace opt-in to a fully read-only
APIC ID[*], but I haven't seen patches...

Maxim?

[*] https://lore.kernel.org/all/c903e82ed2a1e98f66910c35b5aabdcf56e08e72.camel@redhat.com
