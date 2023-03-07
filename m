Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11D56AFA8C
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 00:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjCGXgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 18:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjCGXgY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 18:36:24 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CD894760
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 15:35:53 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id i11-20020a056a00224b00b005d44149eb06so7967327pfu.10
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 15:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678232122;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VIH8Bv5Ykr7/smxSwhKOUZWo2aKYjq3BzEdqNFBOM70=;
        b=f423UdcfrDasHFrLZePcpAz5qCrdTuGn1xD/hhkNaa4mm8glQdWdtpd6nf5dChy6jh
         20WueVt1VTWj1FEruy9hOrrZP1VEu3YRffsyAtsHSD3YxGeJ7zxGxXaGh9ULoWNRlFnD
         2/HaT6rUp39lNXH04UyJKQbxVYTc+1VhpnhxDOANj8i7Si5NvBSGcV7b58ViHJ+CS/bF
         1bluE+5GBwndpMr6olqGVZQXA6C6tbVs4lrg1blZK9PxLD2q+Ufy+3a9ZRUZw2s6uuje
         uI7QfpQeBC1FSIvM84tW49CWiYHoxAM/24ErFheqnsLBFk8Vch+FUK1mJl86prciC2dC
         jZAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678232122;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VIH8Bv5Ykr7/smxSwhKOUZWo2aKYjq3BzEdqNFBOM70=;
        b=DG/uKM7mvdpXWtmFxQVSLBJbKypcUlVsblPryNOsbVyyG6+bsnyHXSa5MurIjupbOx
         Qj7BADAWtKa+3bvJvs0N2LUFhG4PzCLmd8vcqDKFIpuWNg/e1OCJ5F0mAaxg/EGWu9Po
         OctLDSvCRbSK4jUJ317Zd4tqepojBESky6oxHvNN8EieVAwDo0Y0XPNgRmefoVpPNZ0t
         +PWaEcjl3ELvoaD/epsCd4L8NV286ugp40Aj+v+RbgiWlZmNPWlpjiuzZ6hQ6+rX2v3l
         pwrxGUIPdUvy0FgjMqLQ95ogm4ZcddXQItH+olrxkLokmbU47LGEjxP/qW/4MCRJMspd
         +AkA==
X-Gm-Message-State: AO0yUKXJQuFXMloVBHUcaMYzC9NpHG1tOltHrhpN12hqhEykU33P94gH
        QyCaZD0+Ammm170vTvo7O8YdvjRq2qg=
X-Google-Smtp-Source: AK7set9Ju5tpzlTnXY1oXfZjiCM1nmrM2VRSS9w2LzXO0+2nPGi7AlJf1sXEiCgAc5P3QFviYLpOTe2tBYw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2253:b0:603:51de:c0dd with SMTP id
 i19-20020a056a00225300b0060351dec0ddmr6895870pfu.6.1678232122326; Tue, 07 Mar
 2023 15:35:22 -0800 (PST)
Date:   Tue, 7 Mar 2023 15:35:20 -0800
In-Reply-To: <1975308c952236895f2d8f0e56af9db288eaf330.camel@infradead.org>
Mime-Version: 1.0
References: <20230302111227.2102545-1-usama.arif@bytedance.com>
 <faa0eb3bb8ba0326d501516a057ab46eaf1f3c05.camel@infradead.org>
 <effbb6e2-c5a1-af7f-830d-8d7088f57477@amd.com> <269ed38b5eed9c3a259c183d59d4f1eb5128f132.camel@infradead.org>
 <0c56683a-c258-46f6-056e-e85da8a557db@amd.com> <3bfbbd92-b2ed-8189-7b57-0533f6c87ae7@amd.com>
 <1975308c952236895f2d8f0e56af9db288eaf330.camel@infradead.org>
Message-ID: <ZAfDhT97ctXSYiYe@google.com>
Subject: Re: [PATCH v13 00/11] Parallel CPU bringup for x86_64
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Usama Arif <usama.arif@bytedance.com>, tglx@linutronix.de,
        kim.phillips@amd.com, brgerst@gmail.com,
        Sabin Rapan <sabrapan@amazon.com>, piotrgorski@cachyos.org,
        oleksandr@natalenko.name, arjan@linux.intel.com, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 07, 2023, David Woodhouse wrote:
> On Tue, 2023-03-07 at 16:22 -0600, Tom Lendacky wrote:
> > 
> > I did some Qemu/KVM testing. One thing I noticed is that on AMD, CPUID 0xB 
> > EAX will be non-zero only if SMT is enabled. So just booting some guests 
> > without CPU topology never did parallel booting ("smpboot: Disabling 
> > parallel bringup because CPUID 0xb looks untrustworthy"). I would imagine 
> > a bare-metal system that has diabled SMT will not do parallel booting, too 
> > (but I haven't had time to test that).
> 
> Interesting, thanks. Should I change to checking for *both* EAX and EBX
> being zero? That's what I did first, after reading only the Intel SDM.
> But I changed to only EAX because the AMD doc only says that EAX will
> be zero for unsupported leaves.

LOL, nice.  '0' is a prefectly valid output for the shift if there's exactly one
CPU at the current level, which is why Intel states that both EAX and EBX are
cleared.  I assume/hope this is effectively a documentation goof, in that the APM
assumes that all "real" CPUs that support CPUID 0xB also support sub-function 0.

Nit, the AMD says EAX will be zero for unsupported _levels_.  The distinction
matters because if the entire leaf is unsupported, AMD behavior is to zero out
all output registers, even if the input leaf is above the max supported leaf.

Anyways, the kernel already sanity checks the outputs on all x86 CPUs, just
piggyback that logic, e.g. expose detect_extended_topology_leaf() or so.  If AMD
or a VMM is doing something crazy, the kernel is doomed anyways.
