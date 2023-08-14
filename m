Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7E577C197
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 22:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbjHNUh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 16:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbjHNUhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 16:37:36 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BD0170B;
        Mon, 14 Aug 2023 13:37:35 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1bc8045e09dso29535545ad.0;
        Mon, 14 Aug 2023 13:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692045454; x=1692650254;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8uPcd7vi+XmxVyTrv3YM7Lu69aTpodBb1P/2mWRyLDk=;
        b=RWLa6KA90zuKIc0q8BZvrngLTAW5gETvb5oNUH9Pq/RpSvazw3SyF6ERITkqlstHXi
         SnvQgjJfKnsAcF4yUq+Mg63b4IFzV0NG2rK1nc6z2DCAbMIBWmDugDnNGEyXP0EIYme5
         vByW4uUP3rEVuPXTYNUgAAhOusoA11AXqtxfzjhZz99E8mB6ZpP/8PIY90K39VvB21Ap
         /BiWx1dcL9qqIfPsPTe+uGAYk95GGPd+wfp6jv4xrO3kWPoadHh407IRGzAjrCpajfPi
         3dBcN1OEeIJ17a1rQDYNt2D9bAIjACjkHdD6MkKVNxxOnXNEEOUf5u1e/E6Kkqu2zVoU
         2Wew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692045454; x=1692650254;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8uPcd7vi+XmxVyTrv3YM7Lu69aTpodBb1P/2mWRyLDk=;
        b=kfr0TtKpAsNtSoZlyH+eojE4oBJbqHnHGrDCh1HERt11A+iaDPa7Xko5Ju2BnOLxG6
         slGjQeY4mT5TK9U+EF9En/loQw4fFgV38FPDsG8cg9ziutSyPtcCz2h5MaNKJ3VBBA8y
         1mgf4IT1q6saFwZhbsEGlP1tqHkj8ihWwV+LL8nlrf3xyCULokE8r7zzQJviQBR5DDM7
         bvP0rhYDsb7B1vTbDa6rc6kH9jfvmp83vXgdMXu0K8iPkvY+hB//BGmNXZ0zb9QP+wrp
         k25UsbFTGpyhjrF1BTJwBJPYeU6JdqedGNO4klpRLd1e2j0JUiZAFZBomlhutH8WI2Vc
         DcMg==
X-Gm-Message-State: AOJu0YyW7Jb9bGPZadOw1Og6B9vyIYmtb7WaLRtB9HxCy4Eat9EUtODa
        gkNO8vJq+zRmtbmoFLgvU3s=
X-Google-Smtp-Source: AGHT+IGwJ8PLN1gJbnVFzZ7Ji8FunKvpdZ7Xo5ONFNUozyiWCqVAuNY7UblcngaHnVSiLj69ohXYxQ==
X-Received: by 2002:a17:902:a411:b0:1bb:6875:5a73 with SMTP id p17-20020a170902a41100b001bb68755a73mr7412171plq.2.1692045454549;
        Mon, 14 Aug 2023 13:37:34 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id p3-20020a170902c70300b001b243a20f26sm9854404plp.273.2023.08.14.13.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 13:37:33 -0700 (PDT)
Date:   Mon, 14 Aug 2023 13:37:32 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH 09/10] x86/virt/tdx: Wire up basic SEAMCALL functions
Message-ID: <20230814203732.GC2257301@ls.amr.corp.intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
 <41b7e5503a3e6057dc168b3c5a9693651c501d22.1689151537.git.kai.huang@intel.com>
 <20230712221510.GG3894444@ls.amr.corp.intel.com>
 <4202b26acdb3fe926dd1a9a46c2c7c35a5d85529.camel@intel.com>
 <20230713184434.GH3894444@ls.amr.corp.intel.com>
 <20230808091606.jk667prer5lmtcpm@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230808091606.jk667prer5lmtcpm@yy-desk-7060>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 08, 2023 at 05:16:06PM +0800,
Yuan Yao <yuan.yao@linux.intel.com> wrote:

> On Thu, Jul 13, 2023 at 11:44:34AM -0700, Isaku Yamahata wrote:
> > On Thu, Jul 13, 2023 at 03:46:52AM +0000,
> > "Huang, Kai" <kai.huang@intel.com> wrote:
> >
> > > On Wed, 2023-07-12 at 15:15 -0700, Isaku Yamahata wrote:
> > > > > The SEAMCALL ABI is very similar to the TDCALL ABI and leverages much
> > > > > TDCALL infrastructure.  Wire up basic functions to make SEAMCALLs for
> > > > > the basic TDX support: __seamcall(), __seamcall_ret() and
> > > > > __seamcall_saved_ret() which is for TDH.VP.ENTER leaf function.
> > > >
> > > > Hi.  __seamcall_saved_ret() uses struct tdx_module_arg as input and output.  For
> > > > KVM TDH.VP.ENTER case, those arguments are already in unsigned long
> > > > kvm_vcpu_arch::regs[].  It's silly to move those values twice.  From
> > > > kvm_vcpu_arch::regs to tdx_module_args.  From tdx_module_args to real registers.
> > > >
> > > > If TDH.VP.ENTER is the only user of __seamcall_saved_ret(), can we make it to
> > > > take unsigned long kvm_vcpu_argh::regs[NR_VCPU_REGS]?  Maybe I can make the
> > > > change with TDX KVM patch series.
> > >
> > > The assembly code assumes the second argument is a pointer to 'struct
> > > tdx_module_args'.  I don't know how can we change __seamcall_saved_ret() to
> > > achieve what you said.  We might change the kvm_vcpu_argh::regs[NR_VCPU_REGS] to
> > > match 'struct tdx_module_args''s layout and manually convert part of "regs" to
> > > the structure and pass to __seamcall_saved_ret(), but it's too hacky I suppose.
> > >
> > > This was one concern that I mentioned VP.ENTER can be implemented by KVM in its
> > > own assembly in the TDX host v12 discussion.  I kinda agree we should leverage
> > > KVM's existing kvm_vcpu_arch::regs[NR_CPU_REGS] infrastructure to minimize the
> > > code change to the KVM's common infrastructure.  If so, I guess we have to carry
> > > this memory copy burden between two structures.
> > >
> > > Btw, I do find KVM's VP.ENTER code is a little bit redundant to the common
> > > SEAMCALL assembly, which is a good reason for KVM to use __seamcall() variants
> > > for TDH.VP.ENTER.
> > >
> > > So it's a tradeoff I think.
> > >
> > > On the other hand, given CoCo VMs normally don't expose all GPRs to VMM, it's
> > > also debatable whether we should invent another infrastructure to the KVM code
> > > to handle register access of CoCo VMs too, e.g., we can catch bugs easily when
> > > KVM tries to access the registers that it shouldn't access.
> >
> > Yes, we'd like to save/restore GPRs only for TDVMCALL. Otherwise skip
> > save/restore.
> 
> And another case to save/restore GPRs: supports DEBUG TD,
> which is type of TD guest allows VMM to change its register
> context, for debugging purpose.

For Debug TD case, we can use TDH.VP.RD(general purpose register) specifically.
We don't need to optimize for Debug TD case.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
