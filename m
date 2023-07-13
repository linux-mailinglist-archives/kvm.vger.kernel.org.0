Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14938752A69
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 20:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbjGMSol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 14:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbjGMSoj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 14:44:39 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976DB2D46;
        Thu, 13 Jul 2023 11:44:36 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-53482b44007so709266a12.2;
        Thu, 13 Jul 2023 11:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689273876; x=1691865876;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FlzbEka2wU8r+IIPq0C/1MLd6rbjhZvGX4VmkZaz3Po=;
        b=c3IWrdCES97dEa1eiXbLQkdl4KiPjQ8/X5E/eiHyJ7rKeztC/1jAAl9yjpO+HT4AAt
         hGjiI9VLabS5+n5zFkUM4sX7wFkFdPCLHC8SgeEw9Ktm9b/ELip1ncIGDX9aakgX3XQf
         rl6eVLJDhSh74H7N/07Mc3luxHZNmym3TzOEM1vX1dGPw/IqY3zCaykr1r8OYkC7M2bC
         zNaBW1O2w9ZKHT5nWGXHZM66lHJFbSGzsCb9vqcy9smQ34GYPvcmW1VA/Ek93d0NNOyZ
         xmpacVqUtfc+MXelITIjQZ+mNmEtGMpzfSZmyYPXAcIOCB/Uezz+shrEydainEmnOglR
         k/xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689273876; x=1691865876;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FlzbEka2wU8r+IIPq0C/1MLd6rbjhZvGX4VmkZaz3Po=;
        b=Z834/u8WZlWAb7RZxe1fqmkxQFQvpW8HKSdGCHyh718vmlKksiHh2/Alg5DwDgm7i2
         DixhYog7I7IJf4O5ZYTyZ9svOeD4mMGkH1pbpG9KeggFQoAzOGlrBYu6zA8QlB9mIyxB
         GkkVqqIAOKI1D/wphMalMV/1/Ch5jc8shJQyo8C5oJq0RsqRZf6n4wjOxKpxA9XsK1mo
         tGR4OVOXhrrkvEEldAMi5F5jq0XmXU6T+KrhkNwZKn5iofTAOjV/yuvr/rlk1zK4ZWrH
         RX+n2CC6yx/35BJTcSX4ZRAXXy7M5k17mvTo4mYEAen5/9VV4QX28PdsUJ7J6SzeX6aW
         sOfg==
X-Gm-Message-State: ABy/qLbHIByuHQAWD1SQEv3GR9A+3FWgve11QaA/CK+9rqPdQ/ykBG4H
        I9J0itwBECpoHjS3tYzUxtVgTK1qIrA=
X-Google-Smtp-Source: APBJJlEeE1IDJcgpsKIgvMC3kZq6eiV8FU903GsIIoM8IgCVcr+4sxAJL7tTh8EdqJeIP0a3StxWzQ==
X-Received: by 2002:a05:6a20:6a0c:b0:126:a80d:4936 with SMTP id p12-20020a056a206a0c00b00126a80d4936mr2038014pzk.27.1689273875910;
        Thu, 13 Jul 2023 11:44:35 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id u1-20020aa78381000000b0065434edd521sm5682072pfm.196.2023.07.13.11.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 11:44:35 -0700 (PDT)
Date:   Thu, 13 Jul 2023 11:44:34 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
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
Message-ID: <20230713184434.GH3894444@ls.amr.corp.intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
 <41b7e5503a3e6057dc168b3c5a9693651c501d22.1689151537.git.kai.huang@intel.com>
 <20230712221510.GG3894444@ls.amr.corp.intel.com>
 <4202b26acdb3fe926dd1a9a46c2c7c35a5d85529.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4202b26acdb3fe926dd1a9a46c2c7c35a5d85529.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 13, 2023 at 03:46:52AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Wed, 2023-07-12 at 15:15 -0700, Isaku Yamahata wrote:
> > > The SEAMCALL ABI is very similar to the TDCALL ABI and leverages much
> > > TDCALL infrastructure.  Wire up basic functions to make SEAMCALLs for
> > > the basic TDX support: __seamcall(), __seamcall_ret() and
> > > __seamcall_saved_ret() which is for TDH.VP.ENTER leaf function.
> > 
> > Hi.  __seamcall_saved_ret() uses struct tdx_module_arg as input and output.  For
> > KVM TDH.VP.ENTER case, those arguments are already in unsigned long
> > kvm_vcpu_arch::regs[].  It's silly to move those values twice.  From
> > kvm_vcpu_arch::regs to tdx_module_args.  From tdx_module_args to real registers.
> > 
> > If TDH.VP.ENTER is the only user of __seamcall_saved_ret(), can we make it to
> > take unsigned long kvm_vcpu_argh::regs[NR_VCPU_REGS]?  Maybe I can make the
> > change with TDX KVM patch series.
> 
> The assembly code assumes the second argument is a pointer to 'struct
> tdx_module_args'.  I don't know how can we change __seamcall_saved_ret() to
> achieve what you said.  We might change the kvm_vcpu_argh::regs[NR_VCPU_REGS] to
> match 'struct tdx_module_args''s layout and manually convert part of "regs" to
> the structure and pass to __seamcall_saved_ret(), but it's too hacky I suppose.
> 
> This was one concern that I mentioned VP.ENTER can be implemented by KVM in its
> own assembly in the TDX host v12 discussion.  I kinda agree we should leverage
> KVM's existing kvm_vcpu_arch::regs[NR_CPU_REGS] infrastructure to minimize the
> code change to the KVM's common infrastructure.  If so, I guess we have to carry
> this memory copy burden between two structures.
> 
> Btw, I do find KVM's VP.ENTER code is a little bit redundant to the common
> SEAMCALL assembly, which is a good reason for KVM to use __seamcall() variants
> for TDH.VP.ENTER.
> 
> So it's a tradeoff I think.
> 
> On the other hand, given CoCo VMs normally don't expose all GPRs to VMM, it's
> also debatable whether we should invent another infrastructure to the KVM code
> to handle register access of CoCo VMs too, e.g., we can catch bugs easily when
> KVM tries to access the registers that it shouldn't access.

Yes, we'd like to save/restore GPRs only for TDVMCALL. Otherwise skip
save/restore.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
