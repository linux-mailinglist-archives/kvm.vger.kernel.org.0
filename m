Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321276C22FC
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 21:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbjCTUlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 16:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjCTUlK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 16:41:10 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E08565B3
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 13:40:39 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id eg48so51744133edb.13
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 13:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1679344835;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=f/ZypMx/b01ZgNj3OinSf736LSydchf0R68wqu47xTs=;
        b=Hhd46sEaSHU0HwYikVXe+fSnIaRZxVJtPSE/pCqFj72haGohXzr/69LP4SE5LyZDN0
         9VEIcAC2lH/kQLsdMaG6XwMWnc1Dn7VMdSKNs0TxQW16TeodmTZzVabT9PcmfvXf+tgQ
         E/P4gWq6kERZDATWYRFDITZs0uuKD9BmuPjtuOxe4kZZnxoko9UggbtJMrOUkYpZSq3j
         P9Mzzo+VOai3p603weFo5vnHRKHduQpjMFTU6BE/byOl32mGRsKLhn2Wzf0VrXJy2mIU
         yaHC8P9vuum3JWJYA1P9OjxoZy2kKLOCnfJ1LA3kn1OY6LnISpGONaEDxtnCM0xf+cCE
         dyRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679344835;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f/ZypMx/b01ZgNj3OinSf736LSydchf0R68wqu47xTs=;
        b=ykJ6ElpORMMYi/BnkBSiJuKzHPhWai4bwB/Swr4cTYCTz5ESK0wnDEHLw2j8yUqjKx
         MGnSEk9wIaVro/OYpTMUYUDjRXnoKRy9RNdJ9/Rco2BW9o6Pyk4rgPDanzei1Z9IN2EO
         9aUtBDoI6nuZKNH7qGY2LwzDZErSk/6qK5FQwhEauYmbL34sJRqTVRDEYQ3pbYtcVIYU
         TJ6Yb0rMFVVF2ZtT95FMpLPBbpTsN39zzvuYo/H1dDEZJBD+tpL4UXCctElpz0kw8YsE
         Y4E6XvoIRSXpyTpWKoj1Qbv4fujj1U4zNd60s7kq5u06zs9AsVu0EHPHBYF8aDJVE2HW
         ZS3g==
X-Gm-Message-State: AO0yUKVNX1Y/+1f1jZMHiDrv2WOiak5PLLr3xuTQadVRjuukB1AeEgHS
        cvgTDrhQKJo8sx6gBWtAelZydw==
X-Google-Smtp-Source: AK7set9ofWG4xh3BpNaeuCw13nPeto8NQdtvNfH62MJ7wDiAYjGuwcezicUWwgZNIleLGpL2SX0r5Q==
X-Received: by 2002:a17:907:78cd:b0:8f1:4bef:b0e7 with SMTP id kv13-20020a17090778cd00b008f14befb0e7mr10485357ejc.1.1679344834868;
        Mon, 20 Mar 2023 13:40:34 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af11100024b425f5505ca0af.dip0.t-ipconnect.de. [2003:f6:af11:1000:24b4:25f5:505c:a0af])
        by smtp.gmail.com with ESMTPSA id z10-20020a1709060f0a00b009324e7e8b0asm4272252eji.154.2023.03.20.13.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 13:40:34 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Mathias Krause <minipli@grsecurity.net>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 2/6] KVM: VMX: Avoid retpoline call for control
 register caused exits
Date:   Mon, 20 Mar 2023 21:43:44 +0100
Message-Id: <20230320204344.24109-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <ZBI62RUnMB3ppRqO@google.com>
References: <20230201194604.11135-1-minipli@grsecurity.net>
 <20230201194604.11135-3-minipli@grsecurity.net>
 <ZBI62RUnMB3ppRqO@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023 at 02:38:33PM -0700, Sean Christopherson wrote:=0D
> On Wed, Feb 01, 2023, Mathias Krause wrote:=0D
> > Complement commit 4289d2728664 ("KVM: retpolines: x86: eliminate=0D
> > retpoline from vmx.c exit handlers") and avoid a retpoline call for=0D
> > control register accesses as well.=0D
> > =0D
> > This speeds up guests that make heavy use of it, like grsecurity=0D
> > kernels toggling CR0.WP to implement kernel W^X.=0D
> =0D
> I would rather drop this patch for VMX and instead unconditionally make C=
R0.WP=0D
> guest owned when TDP (EPT) is enabled, i.e. drop the module param from pa=
tch 6.=0D
=0D
That's fine with me. As EPT usually implies TDP (if neither of both was=0D
explicitly disabled) that should be no limitation and as the non-EPT=0D
case only saw a very small gain from this change anyways (less than 1%)=0D
we can drop it.=0D
=0D
> =0D
> > Signed-off-by: Mathias Krause <minipli@grsecurity.net>=0D
> > ---=0D
> > =0D
> > Meanwhile I got my hands on a AMD system and while doing a similar chan=
ge=0D
> > for SVM gives a small measurable win (1.1% faster for grsecurity guests=
),=0D
> =0D
> Mostly out of curiosity...=0D
> =0D
> Is the 1.1% roughly aligned with the gains for VMX?  If VMX sees a signif=
icantly=0D
> larger improvement, any idea why SVM doesn't benefit as much?  E.g. did y=
ou double=0D
> check that the kernel was actually using RETPOLINE?=0D
=0D
I measured the runtime of the ssdd test I used before and got 3.98s for=0D
a kernel with the whole series applied and 3.94s with the below change=0D
on top:=0D
=0D
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c=0D
index d13cf53e7390..2a471eae11c6 100644=0D
--- a/arch/x86/kvm/svm/svm.c=0D
+++ b/arch/x86/kvm/svm/svm.c=0D
@@ -3369,6 +3369,10 @@ int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u=
64 exit_code)=0D
 		return intr_interception(vcpu);=0D
 	else if (exit_code =3D=3D SVM_EXIT_HLT)=0D
 		return kvm_emulate_halt(vcpu);=0D
+	else if (exit_code =3D=3D SVM_EXIT_READ_CR0 ||=0D
+		 exit_code =3D=3D SVM_EXIT_WRITE_CR0 ||=0D
+		 exit_code =3D=3D SVM_EXIT_CR0_SEL_WRITE)=0D
+		return cr_interception(vcpu);=0D
 	else if (exit_code =3D=3D SVM_EXIT_NPF)=0D
 		return npf_interception(vcpu);=0D
 #endif=0D
=0D
Inspecting svm_invoke_exit_handler() on the host with perf confirmed it=0D
could use the direct call of cr_interception() most of the time, thereby=0D
could avoid the retpoline for it:=0D
(My version of perf is, apparently, unable to detect tail calls properly=0D
and therefore lacks symbol information for the jump targets in the below=0D
assembly dump. I therefore added these manually.)=0D
=0D
Percent=E2=94=82=0D
       =E2=94=82=0D
       =E2=94=82     ffffffffc194c410 <load0>:	# svm_invoke_exit_handler=0D
  5.00 =E2=94=82       nop=0D
  7.44 =E2=94=82       push   %rbp=0D
 10.43 =E2=94=82       cmp    $0x403,%rsi=0D
  5.86 =E2=94=82       mov    %rdi,%rbp=0D
  1.23 =E2=94=82       push   %rbx=0D
  2.11 =E2=94=82       mov    %rsi,%rbx=0D
  4.60 =E2=94=82       jbe    7a=0D
       =E2=94=82 16:   [svm_handle_invalid_exit() path removed]=0D
  4.59 =E2=94=82 7a:   mov    -0x3e6a5b00(,%rsi,8),%rax=0D
  4.52 =E2=94=82       test   %rax,%rax=0D
       =E2=94=82       je     16=0D
  6.25 =E2=94=82       cmp    $0x7c,%rsi=0D
       =E2=94=82       je     dd=0D
  4.18 =E2=94=82       cmp    $0x64,%rsi=0D
       =E2=94=82       je     f2=0D
  3.26 =E2=94=82       cmp    $0x60,%rsi=0D
       =E2=94=82       je     ca=0D
  4.57 =E2=94=82       cmp    $0x78,%rsi=0D
       =E2=94=82       je     f9=0D
  1.27 =E2=94=82       test   $0xffffffffffffffef,%rsi=0D
       =E2=94=82       je     c3=0D
  1.67 =E2=94=82       cmp    $0x65,%rsi=0D
       =E2=94=82       je     c3=0D
       =E2=94=82       cmp    $0x400,%rsi=0D
       =E2=94=82       je     13d=0D
       =E2=94=82       pop    %rbx=0D
       =E2=94=82       pop    %rbp=0D
       =E2=94=82       jmp    0xffffffffa0487d80	# __x86_indirect_thunk_rax=
=0D
       =E2=94=82       int3=0D
 11.68 =E2=94=82 c3:   pop    %rbx=0D
 10.01 =E2=94=82       pop    %rbp=0D
 10.47 =E2=94=82       jmp    0xffffffffc19482a0	# cr_interception=0D
       =E2=94=82 ca:   incq   0x1940(%rdi)=0D
       =E2=94=82       mov    $0x1,%eax=0D
       =E2=94=82       pop    %rbx=0D
  0.42 =E2=94=82       pop    %rbp=0D
       =E2=94=82       ret=0D
       =E2=94=82       int3=0D
       =E2=94=82       int3=0D
       =E2=94=82       int3=0D
       =E2=94=82       int3=0D
       =E2=94=82 dd:   mov    0x1a20(%rdi),%rax=0D
       =E2=94=82       cmpq   $0x0,0x78(%rax)=0D
       =E2=94=82       je     100=0D
       =E2=94=82       pop    %rbx=0D
       =E2=94=82       pop    %rbp=0D
       =E2=94=82       jmp    0xffffffffc185af20	# kvm_emulate_wrmsr=0D
       =E2=94=82 f2:   pop    %rbx=0D
       =E2=94=82       pop    %rbp=0D
  0.42 =E2=94=82       jmp    0xffffffffc19472b0	# interrupt_window_interce=
ption=0D
       =E2=94=82 f9:   pop    %rbx=0D
       =E2=94=82       pop    %rbp=0D
       =E2=94=82       jmp    0xffffffffc185a6a0	# kvm_emulate_halt=0D
       =E2=94=82100:   pop    %rbx=0D
       =E2=94=82       pop    %rbp=0D
       =E2=94=82       jmp    0xffffffffc18602a0	# kvm_emulate_rdmsr=0D
       =E2=94=82107:   mov    %rbp,%rdi=0D
       =E2=94=82       mov    $0x10,%esi=0D
       =E2=94=82       call   kvm_register_read_raw=0D
       =E2=94=82       mov    0x24(%rbp),%edx=0D
       =E2=94=82       mov    %rax,%rcx=0D
       =E2=94=82       mov    %rbx,%r8=0D
       =E2=94=82       mov    %gs:0x2ac00,%rax=0D
       =E2=94=82       mov    0x95c(%rax),%esi=0D
       =E2=94=82       mov    $0xffffffffc195dc28,%rdi=0D
       =E2=94=82       call   _printk=0D
       =E2=94=82       jmp    31=0D
       =E2=94=8213d:   pop    %rbx=0D
       =E2=94=82       pop    %rbp=0D
       =E2=94=82       jmp    0xffffffffc1946b90	# npf_interception=0D
=0D
What's clear from above (or so I hope!), cr_interception() is *the* reason =
to=0D
cause a VM exit for my test run and by taking the shortcut via a direct cal=
l,=0D
it doesn't have to do the retpoline dance which might be the explanation fo=
r=0D
the ~1.1% performance gain (even in the face of three additional compare=0D
instructions). However! As I realized that these three more instructions=0D
probably "hurt" all other workloads (that don't toggle CR0.WP as often as a=
=0D
grsecurity kernel would do), I didn't include the above change as a patch o=
f=0D
the series. If you think it's worth it nonetheless, as VM exits shouldn't=0D
happen often anyways, I can do a proper patch.=0D
=0D
> =0D
> > it would provide nothing for other guests, as the change I was testing =
was=0D
> > specifically targeting CR0 caused exits.=0D
> > =0D
> > A more general approach would instead cover CR3 and, maybe, CR4 as well=
.=0D
> > However, that would require a lot more exit code compares, likely=0D
> > vanishing the gains in the general case. So this tweak is VMX only.=0D
> =0D
> I don't think targeting on CR0 exits is a reason to not do this for SVM. =
 With=0D
> NPT enabled, CR3 isn't intercepted, and CR4 exits should be very rare.  I=
f the=0D
> performance benefits are marginal (I don't have a good frame of reference=
 for the=0D
> 1.1%), then _that's_ a good reason to leave SVM alone.  But not giving CR=
3 and CR4=0D
> priority is a non-issue.=0D
=0D
Ok. But yeah, the win isn't all the big either, less so in real=0D
workloads that won't exercise this code path so often.=0D
=0D
> =0D
> >  arch/x86/kvm/vmx/vmx.c | 2 ++=0D
> >  1 file changed, 2 insertions(+)=0D
> > =0D
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c=0D
> > index c788aa382611..c8198c8a9b55 100644=0D
> > --- a/arch/x86/kvm/vmx/vmx.c=0D
> > +++ b/arch/x86/kvm/vmx/vmx.c=0D
> > @@ -6538,6 +6538,8 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcp=
u, fastpath_t exit_fastpath)=0D
> >  		return handle_external_interrupt(vcpu);=0D
> >  	else if (exit_reason.basic =3D=3D EXIT_REASON_HLT)=0D
> >  		return kvm_emulate_halt(vcpu);=0D
> > +	else if (exit_reason.basic =3D=3D EXIT_REASON_CR_ACCESS)=0D
> > +		return handle_cr(vcpu);=0D
> >  	else if (exit_reason.basic =3D=3D EXIT_REASON_EPT_MISCONFIG)=0D
> >  		return handle_ept_misconfig(vcpu);=0D
> >  #endif=0D
> > -- =0D
> > 2.39.1=0D
> > =0D
=0D
