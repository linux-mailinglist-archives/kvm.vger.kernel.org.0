Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CC04F8E4F
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 08:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234437AbiDHFAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 01:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234381AbiDHFAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 01:00:47 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B3D19B0AA;
        Thu,  7 Apr 2022 21:58:45 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id u14so7639245pjj.0;
        Thu, 07 Apr 2022 21:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=557MEUsdgfignjvRd8r34LD9N122H/h+3LidKwdYmBA=;
        b=HW45i83cuEQXFGe71cN/hhwByTx2d5PFACsT885jfnkY5ycCLdj61hdPN/mZxjfRhX
         U6IH95qSFJSlicUFlP8cE282fh7HJor13fLWMEyk8/YJzOYIvLAf8f5yrcxC8yE2mlrC
         eihE+mfkaIvgshlA7KMZNGPnenloP6ESl0OIs5vUQbeejE5ju4GMiuI8i4ILKb4E+Fvc
         DPU8De1fRupDMxZi9HuD6Nm7QXVMmTxTeZj0I3XjcN/uy35ZAdsMEtF2a7yChshiYcaT
         +vNWAAoemkT9rezDZNbJ4qistlkVEcAYNsguxTbEK2C/unXyRwrsTrw5zUui8RdRCmpD
         sGuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=557MEUsdgfignjvRd8r34LD9N122H/h+3LidKwdYmBA=;
        b=p0s8F0ramWMt46XxH/gNekrf2j8tURXWCDvnSdesPgRouflx7Aex/UkNsoA/j95ObJ
         zXoDWXdcq4zmiO0n5BKKh1FhuZmaZXwcDm+tnLWyZCYxAvC8jvKvkYTqlMInGWyFT9wH
         4vV7TaZ+gLC1C63fWwm1jBN4IRgnpWF4+U3lsbRH7ykAJ2m5y/sISKPn1Gtrma5ueRNA
         rtKoxV2dSCvV5te6cj/Gx6R1I0LRybh3RrSj+/ag4D+CIzlwQCk+AZH633oKbogdKo+9
         V2JB5eF4RhZgDtjC7xzcbWagdRE4hXSQitUnTMp+v9/0G8EX1nA322SsUMAN7vImLwMh
         7M0g==
X-Gm-Message-State: AOAM533PgXvfQILYL7XSq7jGnGG6SQ/2D0IELkQ3HkLqJ+rBjkyxnWkz
        M64Gd6ZD9He8/dxepxaJa5M=
X-Google-Smtp-Source: ABdhPJw2t3RRubpgAoE825RBRDhRO/uaG7jCherKev5XCUCNyJpBzJDEdmF0VGfF2e1QyWJWiWrBRA==
X-Received: by 2002:a17:90b:1bc9:b0:1c7:228a:95ce with SMTP id oa9-20020a17090b1bc900b001c7228a95cemr19668855pjb.3.1649393924829;
        Thu, 07 Apr 2022 21:58:44 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id r8-20020a17090a0ac800b001c9e35d3a3asm10468887pje.24.2022.04.07.21.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 21:58:44 -0700 (PDT)
Date:   Thu, 7 Apr 2022 21:58:42 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v5 092/104] KVM: TDX: Handle TDX PV HLT hypercall
Message-ID: <20220408045842.GI2864606@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <6da55adb2ddb6f287ebd46aad02cfaaac2088415.1646422845.git.isaku.yamahata@intel.com>
 <282d4cd1-d1f7-663c-a965-af587f77ee5a@redhat.com>
 <Yk79A4EdiZoVQMsV@google.com>
 <8e0280ab-c7aa-5d01-a36f-93d0d0d79e25@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8e0280ab-c7aa-5d01-a36f-93d0d0d79e25@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 07, 2022 at 05:56:05PM +0200,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> You didn't answer the other question, which is "Where is R12 documented for
> TDG.VP.VMCALL<Instruction.HLT>?" though...  Should I be worried? :)

It's publicly documented.

Guest-Host-Communication Interface(GHCI) spec, 344426-003US Feburary 2022.
3.8 TDG.VP.VMCALL<Instruction.HLT>
R12 Interrupt Blocked Flag.
    The TD is expected to clear this flag iff RFLAGS.IF == 1 or the TDCALL instruction
    (that invoked TDG.VP.TDVMCALL(Instruction.HLT)) immediately follows an STI
    instruction, otherwise this flag should be set.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
