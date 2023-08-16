Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D2677E391
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 16:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343616AbjHPO2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 10:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343651AbjHPO1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 10:27:48 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047B12709
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 07:27:47 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58c8b2d6784so9439897b3.3
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 07:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692196066; x=1692800866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ocFVuDAoYa76ZBIYvekfvcCSNlPl+8WKQ7zX3J4QGgs=;
        b=nCDyOoH0oySdjuEsVcz9lUQEbt0d5xVy4T04c2jCprIc8UdB2GwFoxZz1UihZ+8CPg
         RchUF9UVRX/0ijV1r23vCJ9RJtbt225PJnFS1+zPdaWLb69pEXxa5GMMopLuXBVh3+R1
         sI1GJOp8Yub6sMF0nBNjzN7CFf+Ii5MjUbyJkFBmWMRnnNLk4rtsozCNHU3XROmtlzk3
         ETsES3u+oZGHW5tIJukvZ7SakW0f6EChxmcX5V1bkjju+6zhsKN2qR3r722lg/ESZznc
         2ErdicH2oyAau+bkEu+pVQQa95zmnDny8w93x0oGM2RRgSu4R1tHE8vQN35d1UBO1auN
         uxsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692196066; x=1692800866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ocFVuDAoYa76ZBIYvekfvcCSNlPl+8WKQ7zX3J4QGgs=;
        b=DpPLusXNjN3jAeTDAaKDB8ovHVE12AGbleU1EMgUYBUAY8Qtmcpiv5jL7zKlgSeZdu
         xNL++Xh18DRPhwePmkuFTTxyfeIk00wPPW6JtSOy+nWipd2VsYy2V5qXVYTPuk0P7MaB
         oFHu6dKSGLywVusqwMB8N6wEiMeLbPN4p0KavoNCPRAEHEAX6kEpsSRc8w4a6RsPjSE2
         j5WGGpX798hItryMdacn0mvjPofkvH2QUBgpn1Vq71giWhPBdHqYJoobj8Y5PmNax4Ku
         l105muDnUrJ9Gt1eXide7a50hE0DwpfaibmX12CkbKU3wW8u33mExUlxHDFsn4hyVoWm
         eAYg==
X-Gm-Message-State: AOJu0YyiL5K1HOiyJ82tNnx208FEs+T0shlOJ+KeqZspuY2Q1gFAcVkd
        CA6cA7HyYvoIKUV8bUywXb6VY46rPUk=
X-Google-Smtp-Source: AGHT+IGmENvyzABpuuLUU3IFL4Ul5a1yBeBSAE3t8ZD0pBQsXUo3eUdpcxEPHaxQ0CpfwWt/G+VCpF8iq3g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4524:0:b0:58c:8552:458d with SMTP id
 s36-20020a814524000000b0058c8552458dmr28452ywa.3.1692196066288; Wed, 16 Aug
 2023 07:27:46 -0700 (PDT)
Date:   Wed, 16 Aug 2023 07:27:44 -0700
In-Reply-To: <a7ecab8d-a77c-77eb-68cb-383de569fe6d@linux.intel.com>
Mime-Version: 1.0
References: <20230719024558.8539-1-guang.zeng@intel.com> <20230719024558.8539-5-guang.zeng@intel.com>
 <ZNwGKPnTY7hRRy+S@google.com> <a7ecab8d-a77c-77eb-68cb-383de569fe6d@linux.intel.com>
Message-ID: <ZNzc4FMukTamEseJ@google.com>
Subject: Re: [PATCH v2 4/8] KVM: x86: Add X86EMUL_F_INVTLB and pass it in em_invlpg()
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 16, 2023, Binbin Wu wrote:
> 
> 
> On 8/16/2023 7:11 AM, Sean Christopherson wrote:
> > On Wed, Jul 19, 2023, Zeng Guang wrote:
> > > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > > index 8e706d19ae45..9b4b3ce6d52a 100644
> > > --- a/arch/x86/kvm/emulate.c
> > > +++ b/arch/x86/kvm/emulate.c
> > > @@ -3443,8 +3443,10 @@ static int em_invlpg(struct x86_emulate_ctxt *ctxt)
> > >   {
> > >   	int rc;
> > >   	ulong linear;
> > > +	unsigned max_size;
> > 	unsigned int
> Let me think why I use 'unsigned'...
> It's because the exist code uses 'unsigned'.
> I suppose it is considered bad practice?

Yeah, use "unsigned int" when writing new code.

> I will cleanup the exist code as well. Is it OK to cleanup it
> opportunistically inside this patch?

No, don't bother cleaning up existing usage.  If a patch touches the "bad" code,
then by all means do an opportunistic cleanup.  But we have too much "legacy" code
in KVM for a wholesale cleanup of bare unsigned usage to be worth the churn and
git blame pollution.  See also:

https://lore.kernel.org/all/ZNvIRS%2FYExLtGO2B@google.com

> > > diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> > > index c0e48f4fa7c4..c944055091e1 100644
> > > --- a/arch/x86/kvm/kvm_emulate.h
> > > +++ b/arch/x86/kvm/kvm_emulate.h
> > > @@ -93,6 +93,7 @@ struct x86_instruction_info {
> > >   #define X86EMUL_F_FETCH			BIT(1)
> > >   #define X86EMUL_F_BRANCH		BIT(2)
> > >   #define X86EMUL_F_IMPLICIT		BIT(3)
> > > +#define X86EMUL_F_INVTLB		BIT(4)
> > Why F_INVTLB instead of X86EMUL_F_INVLPG?  Ah, because LAM is ignored for the
> > linear address in the INVPCID and INVVPID descriptors.  Hrm.
> > 
> > I think my vote is to call this X86EMUL_F_INVLPG even though *in theory* it's not
> > strictly limited to INVLPG.  Odds are good KVM's emulator will never support
> > INVPCID or INVVPID,
> One case is kvm_handle_invpcid() is in the common kvm x86 code.
> LAM doesn't apply to the address in descriptor of invpcid though, but I am
> not sure if there will be the need for SVM in the future.

Right, but the emulator itself doesn't handle INVPCID or INVVPID, so there's no
direct "conflict" at this time.

> But for now, F_INVLPG is OK if you think F_INVTLB brings confusion.

Yeah, please use F_INVLPG unless someone has a strong objection.
