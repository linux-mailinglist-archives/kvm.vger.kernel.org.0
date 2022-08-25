Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714F75A18CE
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 20:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243431AbiHYS3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 14:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243401AbiHYS3l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 14:29:41 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44066B72B3
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 11:29:40 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id p9-20020a17090a2d8900b001fb86ec43aaso5643809pjd.0
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 11:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=vMsfZYdMbyIbAb131crwZyGwcqSsbs0rEXIVQLSfp9U=;
        b=NmEo+NBtNprG6ryzu66jOaoGsDEzCWUBSVR4njX135WAMBvqy9CXBEV8KJZIbOkEOd
         Zv3c9OH9uGJuP4LVw92crGuZU3FyjMmbRLapxrNn5hIVlhSXPBkTkpjZxXTf1EHz56T5
         ZKSNn8N0gT4ggrZYA3a+VSEai5gSpI2tYmjxKxazlAuHmQylpXixQ9s/ITbOkDr42Pnt
         zWOPYbjva4sa0Ml/Gztl6nQZeeQifJRJJq19sm5eL54Nq15lMUp+UMN6k8Pf/kfdzwuw
         DFgoZhnE3f0knMAYvDr4b1pSElb1z9MnuxfHQml2TcVOQHYOstFgiicnYPZyCtkLUCWu
         O2nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=vMsfZYdMbyIbAb131crwZyGwcqSsbs0rEXIVQLSfp9U=;
        b=Q6sDVDlURGVvDMBDwKtAnTWfrdG1hDF8hAcbyK2+II1wdDVnsk6uvJzRBlE+W8RZtP
         R4qwCXuKTSV8/iRoeUtEPpUfFvd88jxteMniQxll2Ogd954xT6BJYBaZcJorwpTlYsUg
         UJ3Csw4wXw5RbiwfaRcNXSyaPC40YROLh7bZTLzwFWS7/t2Zf7uSPXD/ihhxjn6yuZiZ
         I0tDcSe8ULXTLRAgICT7mCAYeZG8F7eAALfK8z4IRT4sd0xEHkQjHwoI2Ml2XFnI+ZrA
         JnbH2QJHE09y60T7ePNzA9t1WHjeRBWxUd/1/KQkoMtOf5JBg2HhTDaTvnWeSnfwTRp3
         phzg==
X-Gm-Message-State: ACgBeo07WBHdseIwuKR0K0BUQw2Aabe4XCJjYqR3AvoMGeXY3reh1eet
        MmWvewDFuqcE9VnEqY04kIgKpA==
X-Google-Smtp-Source: AA6agR4N8wVMmrOT9+4NRlqDlcUsRn8g1k7Ei3HnLNXjQPvh28kfPONXBXfFnSKfeBg64rW65FACSQ==
X-Received: by 2002:a17:903:11c9:b0:172:6ea1:b728 with SMTP id q9-20020a17090311c900b001726ea1b728mr345277plh.95.1661452179638;
        Thu, 25 Aug 2022 11:29:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z12-20020aa7990c000000b00536431c6ae0sm11833077pff.101.2022.08.25.11.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 11:29:39 -0700 (PDT)
Date:   Thu, 25 Aug 2022 18:29:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v6 00/36] KVM: x86: eVMCS rework
Message-ID: <Ywe/j3fqfj9qJgEV@google.com>
References: <20220824030138.3524159-1-seanjc@google.com>
 <87fshkw5zo.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fshkw5zo.fsf@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > This is what I ended up with as a way to dig ourselves out of the eVMCS
> > conundrum.  Not well tested, though KUT and selftests pass.  The enforcement
> > added by "KVM: nVMX: Enforce unsupported eVMCS in VMX MSRs for host accesses"
> > is not tested at all (and lacks a changelog).
> 
> Trying to enable KVM_CAP_HYPERV_ENLIGHTENED_VMCS2 in its new shape in
> QEMU so I can test it and I immediately stumble upon
> 
> ~/qemu/build/qemu-system-x86_64 -machine q35,accel=kvm,kernel-irqchip=split -cpu host,hv-evmcs-2022,hv-evmcs,hv-vpindex,hv-vapic 
> qemu-system-x86_64: error: failed to set MSR 0x48d to 0xff00000016
> qemu-system-x86_64: ../target/i386/kvm/kvm.c:3107: kvm_buf_set_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
> 
> Turns out, at least with "-cpu host" QEMU reads VMX feature MSRs first
> and enables eVMCS after.

Heh, of course there had to be a corner case.

> This is fixable, I believe but it makes me think that maybe eVMCS enablement
> (or even the whole Hyper-V emulation thing) should be per-VM as it makes
> really little sense to have Hyper-V features enabled on *some* vCPUs only. As
> we're going to add a new CAP anyway, maybe it's a good time to make a switch?

Works for me as long as the KVM code doesn't end up being a mess trying to smush
the two things together (I don't see any reason why it would).
