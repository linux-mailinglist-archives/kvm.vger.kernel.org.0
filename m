Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327054F1BB7
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381024AbiDDVWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380391AbiDDT4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 15:56:31 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B80726564
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 12:54:34 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id j20-20020a17090ae61400b001ca9553d073so351654pjy.5
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 12:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wSGFvmojAE5Wwgdbskjebmb4GWisI7pCGYJOHtj8+hU=;
        b=Qz5IOLZhPNYeCPsVpAhskFI+r2Iuy3QXVCHEY1QCqMYBRhOwgYmS0AMm99n3NnRPia
         Yjper3dbJkfse7JwU1MKcByxmmwW8PzSJ5JxCcGfnp13TIeQLlVzucqsPhD6A6mCt+9L
         o12xQLwyBe70MNcbJV3eUQn29qKrr2D1HMqueaAHU4MmsigisnbZPFNGDEa7QVAftA69
         fqbgrLxQ+xR62z7sxtVv2KCOsywxnM1S00uow9DPnu85svo7TYWl6X9/S6ovR/or5mTO
         C2Futupmxny7LGpRDZjjiQo2MdvKNgUJL1nAbv/7IO14t0jo28GgjAr8WAcxduaN+gXJ
         vM7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wSGFvmojAE5Wwgdbskjebmb4GWisI7pCGYJOHtj8+hU=;
        b=SzYXTGcA/jEJ4F1YvvV6FCdtY9NBkVawGljxUN5GzyAIROULXAZMpVjq6WE8eZs85d
         iIcZwoh1clXBY6APTK75kArj+w6lKwOfxaQ23l0loOQjz5w4Ykxg6s0L+IPGgiXcQssT
         eXB1xP8yiafnPk2nRNPp1P/8nmKWshZ4xsoYyi+qXUOvkNok8T2alZPdUScXsNdlQVm6
         VRBTPSvtHsa4BIbOPBusop9zHD8f6tuqZhlQpmonDxEfqyD085NGl1Cq3WWeGsU4x+nY
         Ns6lV/cq1WsA1gqQ2haGgPmA4ZAl5+SgtmR3b7BaZ9FtgLcggWsyQdWtPzkArzwUsu+t
         lO6A==
X-Gm-Message-State: AOAM533zUTvniicFk2O+jWm2wSt80Ni//lF8ckmBUgTPS/CSXzSyQur3
        sEdHbkbwjb/EDJ5ySQA41nSQVQ==
X-Google-Smtp-Source: ABdhPJzYd5qGqcdcbgXRffJjoqjRSzQKEO+Ppnb1RMDP/Ru/Ihpz61dNyUTO8sZaJa00jsz5bvvgbA==
X-Received: by 2002:a17:90b:3ec3:b0:1c7:24c4:e28f with SMTP id rm3-20020a17090b3ec300b001c724c4e28fmr840341pjb.191.1649102073832;
        Mon, 04 Apr 2022 12:54:33 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y16-20020a17090a6c9000b001c993d935e7sm245836pjj.56.2022.04.04.12.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 12:54:33 -0700 (PDT)
Date:   Mon, 4 Apr 2022 19:54:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] KVM: SVM: Re-inject INT3/INTO instead of retrying
 the instruction
Message-ID: <YktM9bnq5HaTMKkV@google.com>
References: <20220402010903.727604-1-seanjc@google.com>
 <20220402010903.727604-6-seanjc@google.com>
 <a47217da0b6db4f1b6b6c69a9dc38350b13ac17c.camel@redhat.com>
 <YkshgrUaF4+MrrXf@google.com>
 <a3cf781b-0b1a-0bba-6b37-12666c7fc154@maciej.szmigiero.name>
 <YktIGHM86jHkzGdF@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YktIGHM86jHkzGdF@google.com>
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

On Mon, Apr 04, 2022, Sean Christopherson wrote:
> On Mon, Apr 04, 2022, Maciej S. Szmigiero wrote:
> > > > > index 47e7427d0395..a770a1c7ddd2 100644
> > > > > --- a/arch/x86/kvm/svm/svm.h
> > > > > +++ b/arch/x86/kvm/svm/svm.h
> > > > > @@ -230,8 +230,8 @@ struct vcpu_svm {
> > > > >   	bool nmi_singlestep;
> > > > >   	u64 nmi_singlestep_guest_rflags;
> > > > > -	unsigned int3_injected;
> > > > > -	unsigned long int3_rip;
> > > > > +	unsigned soft_int_injected;
> > > > > +	unsigned long soft_int_linear_rip;
> > > > >   	/* optional nested SVM features that are enabled for this guest  */
> > > > >   	bool nrips_enabled                : 1;
> > > > 
> > > > 
> > > > I mostly agree with this patch, but think that it doesn't address the
> > > > original issue that Maciej wanted to address:
> > > > 
> > > > Suppose that there is *no* instruction in L2 code which caused the software
> > > > exception, but rather L1 set arbitrary next_rip, and set EVENTINJ to software
> > > > exception with some vector, and that injection got interrupted.
> > > > 
> > > > I don't think that this code will support this.
> > > 
> > > Argh, you're right.  Maciej's selftest injects without an instruction, but it doesn't
> > > configure the scenario where that injection fails due to an exception+VM-Exit that
> > > isn't intercepted by L1 and is handled by L0.  The event_inj test gets the coverage
> > > for the latter, but always has a backing instruction.
> > 
> > Still reviewing the whole patch set, but want to clear this point quickly:
> > The selftest does have an implicit intervening NPF (handled by L0) while
> > injecting the first L1 -> L2 event.
> 
> I'll do some debug to figure out why the test passes for me.  I'm guessing I either
> got lucky, e.g. IDT was faulted in already, or I screwed up and the test doesn't
> actually pass.

Well that was easy.  My code is indeed flawed and skips the wrong instruction,
the skipped instruction just so happens to be a (spurious?) adjustment of RSP.  The
L2 guest function never runs to completion and so the "bad" RSP is never consumed.
 
   KVM: incomplete injection for L2, vector 32 @ 401c70.  next_rip = 0
   KVM: injecting for L2, vector 0 @ 401c70.  next_rip = 401c74

0000000000401c70 <l2_guest_code>:
  401c70:       48 83 ec 08             sub    $0x8,%rsp
  401c74:       83 3d 75 a7 0e 00 01    cmpl   $0x1,0xea775(%rip)        # 4ec3f0 <int_fired>
  401c7b:       74 1e                   je     401c9b <l2_guest_code+0x2b>
  401c7d:       45 31 c0                xor    %r8d,%r8d
  401c80:       b9 32 00 00 00          mov    $0x32,%ecx
  401c85:       ba 90 40 4b 00          mov    $0x4b4090,%edx
  401c8a:       31 c0                   xor    %eax,%eax
  401c8c:       be 02 00 00 00          mov    $0x2,%esi
  401c91:       bf 02 00 00 00          mov    $0x2,%edi
  401c96:       e8 05 ae 00 00          call   40caa0 <ucall>
  401c9b:       0f 01 d9                vmmcall 
  401c9e:       0f 0b                   ud2    
  401ca0:       83 3d 4d a7 0e 00 01    cmpl   $0x1,0xea74d(%rip)        # 4ec3f4 <bp_fired>
  401ca7:       74 1e                   je     401cc7 <l2_guest_code+0x57>
  401ca9:       45 31 c0                xor    %r8d,%r8d
  401cac:       b9 36 00 00 00          mov    $0x36,%ecx
  401cb1:       ba b8 40 4b 00          mov    $0x4b40b8,%edx
  401cb6:       31 c0                   xor    %eax,%eax
  401cb8:       be 02 00 00 00          mov    $0x2,%esi
  401cbd:       bf 02 00 00 00          mov    $0x2,%edi
  401cc2:       e8 d9 ad 00 00          call   40caa0 <ucall>
  401cc7:       f4                      hlt    
  401cc8:       48 83 c4 08             add    $0x8,%rsp
  401ccc:       c3                      ret    
  401ccd:       0f 1f 00                nopl   (%rax)

I don't see why the compiler is creating room for a single variable, but it doesn't
really matter, the easiest way to detect this bug is to assert that the return RIP
in the INT 0x20 handler points at l2_guest_code, e.g. this fails:

diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
index d39be5d885c1..257aa2280b5c 100644
--- a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
+++ b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
@@ -40,9 +40,13 @@ static void guest_bp_handler(struct ex_regs *regs)
 }

 static unsigned int int_fired;
+static void l2_guest_code(void);
+
 static void guest_int_handler(struct ex_regs *regs)
 {
        int_fired++;
+       GUEST_ASSERT_2(regs->rip == (unsigned long)l2_guest_code,
+                      regs->rip, (unsigned long)l2_guest_code);
 }

 static void l2_guest_code(void)
