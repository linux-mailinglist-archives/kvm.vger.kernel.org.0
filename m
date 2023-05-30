Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1DF717174
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 01:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbjE3XQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 19:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233794AbjE3XQN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 19:16:13 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6386BE8
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 16:16:11 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-64d1a0d640cso3842686b3a.1
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 16:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1685488571; x=1688080571;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=q6wOdCsvPcfL1AGuKhq7si1i+l1tB9VGHRhgBuI4hFQ=;
        b=A6P9MRUqWxltKJ9Zgwok7DSDRoOxoww2FWlF6WQO1tYgoM5+Hi0Ez2oEaQQjsD1m8R
         d4fRiNfemEoHsLbKtPfU643qi1eTaIaRbZTrXG8PIKxDT7zOE/fxQqSHWBsVd7zxgsD9
         9LmT/yPeVeEdIlXyQ0jganlgblNgnS7PESvrk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685488571; x=1688080571;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q6wOdCsvPcfL1AGuKhq7si1i+l1tB9VGHRhgBuI4hFQ=;
        b=OECLv3wbuUmg3ALxr0NvF3BTLD8phohOyDs4g4/fBIp3sIep/Eua4z4qtPj9sIfbk9
         bzi3fJrb/qE0OWbkPOyQyI7y+QDupweEgyy5fy0qWVPrPpvjVvnkmABPqvwbhHJXLwEG
         648d3pz+rbAgs6Jf3HO18uYqWAShIUstR3QH1x6KM2Fu9G43u4bXSB9Nz6qISBVhIgSG
         Dz5x7UV4LPj7/Y/EOPTmMgEcBtKnIeOYJMnnpSeXh2cIBGhVv6Bq2k6qAiUPqFHZ8aOf
         vQxcyQMJjz/o3ufzBPj4ubXiv9D3HgnNQw6rH9fo7r8JEZ1ywlJwqXjrXON8c4F8/5s7
         gXTQ==
X-Gm-Message-State: AC+VfDwT9WFIP96wmiMDrVsyAlhtEpDy1HQBYH5rBAL0YkTiYVatpzvq
        L6XhICQac/pl2eILTDxEYDPN+Q==
X-Google-Smtp-Source: ACHHUZ5vUXK2I/pfuTav0TBfWy3DDrvFJsd+7uESTSUanu+Vl50RByVZpLds9PiU8F5GGbjiErQYOQ==
X-Received: by 2002:a05:6a00:10c4:b0:646:663a:9d60 with SMTP id d4-20020a056a0010c400b00646663a9d60mr4308038pfu.10.1685488570875;
        Tue, 30 May 2023 16:16:10 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id v22-20020aa78516000000b0063d3d776910sm2123773pfn.138.2023.05.30.16.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 16:16:10 -0700 (PDT)
Date:   Tue, 30 May 2023 16:16:09 -0700
From:   Kees Cook <keescook@chromium.org>
To:     =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc:     Wei Liu <wei.liu@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Alexander Graf <graf@amazon.com>,
        Forrest Yuan Yu <yuanyu@google.com>,
        James Morris <jamorris@linux.microsoft.com>,
        John Andersen <john.s.andersen@intel.com>,
        "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        Mihai =?utf-8?B?RG9uyJt1?= <mdontu@bitdefender.com>,
        =?utf-8?B?TmljdciZb3IgQ8OuyJt1?= <nicu.citu@icloud.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Thara Gopinath <tgopinath@microsoft.com>,
        Will Deacon <will@kernel.org>,
        Zahra Tarkhani <ztarkhani@microsoft.com>,
        =?utf-8?Q?=C8=98tefan_=C8=98icleru?= <ssicleru@bitdefender.com>,
        dev@lists.cloudhypervisor.org, kvm@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH v1 5/9] KVM: x86: Add new hypercall to lock control
 registers
Message-ID: <202305301614.BF8D80D3D5@keescook>
References: <20230505152046.6575-1-mic@digikod.net>
 <20230505152046.6575-6-mic@digikod.net>
 <ZFlllHjntehpthma@liuwe-devbox-debian-v2>
 <901ff104-215c-8e81-fbae-5ecd8fa94449@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <901ff104-215c-8e81-fbae-5ecd8fa94449@digikod.net>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 29, 2023 at 06:48:03PM +0200, Mickaël Salaün wrote:
> 
> On 08/05/2023 23:11, Wei Liu wrote:
> > On Fri, May 05, 2023 at 05:20:42PM +0200, Mickaël Salaün wrote:
> > > This enables guests to lock their CR0 and CR4 registers with a subset of
> > > X86_CR0_WP, X86_CR4_SMEP, X86_CR4_SMAP, X86_CR4_UMIP, X86_CR4_FSGSBASE
> > > and X86_CR4_CET flags.
> > > 
> > > The new KVM_HC_LOCK_CR_UPDATE hypercall takes two arguments.  The first
> > > is to identify the control register, and the second is a bit mask to
> > > pin (i.e. mark as read-only).
> > > 
> > > These register flags should already be pinned by Linux guests, but once
> > > compromised, this self-protection mechanism could be disabled, which is
> > > not the case with this dedicated hypercall.
> > > 
> > > Cc: Borislav Petkov <bp@alien8.de>
> > > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > > Cc: H. Peter Anvin <hpa@zytor.com>
> > > Cc: Ingo Molnar <mingo@redhat.com>
> > > Cc: Kees Cook <keescook@chromium.org>
> > > Cc: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: Sean Christopherson <seanjc@google.com>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> > > Cc: Wanpeng Li <wanpengli@tencent.com>
> > > Signed-off-by: Mickaël Salaün <mic@digikod.net>
> > > Link: https://lore.kernel.org/r/20230505152046.6575-6-mic@digikod.net
> > [...]
> > >   	hw_cr4 = (cr4_read_shadow() & X86_CR4_MCE) | (cr4 & ~X86_CR4_MCE);
> > >   	if (is_unrestricted_guest(vcpu))
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index ffab64d08de3..a529455359ac 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -7927,11 +7927,77 @@ static unsigned long emulator_get_cr(struct x86_emulate_ctxt *ctxt, int cr)
> > >   	return value;
> > >   }
> > > +#ifdef CONFIG_HEKI
> > > +
> > > +extern unsigned long cr4_pinned_mask;
> > > +
> > 
> > Can this be moved to a header file?
> 
> Yep, but I'm not sure which one. Any preference Kees?

Uh, er, I was never expecting that mask to be non-static. ;) To that
end, how about putting it in arch/x86/kvm/x86.h ?

-- 
Kees Cook
