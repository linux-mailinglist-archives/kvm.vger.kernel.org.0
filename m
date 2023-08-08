Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15CD7773BB4
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 17:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjHHPyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 11:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjHHPwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 11:52:19 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200FE5267;
        Tue,  8 Aug 2023 08:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691509382; x=1723045382;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=gGHlQb/8Nf65OgJQ0JggilK6QPloizVjYoHfGbMxicM=;
  b=m5oVHB34a8PS1HTv04gZm3pjaY5Aj2DK28a3ntcL+gMXO2GMYsC/sKLD
   y2IOnNtxi/qnPQWdzQBmub1a9WwWx8bdkuh1yDynhNNtqs0JtZ01Z64cL
   KR4CEUCdgzb8osZ9GzqX7DEOdW/cx+oKnsBKBN5EzIqARN9QbiSW1uNUZ
   FjCpD6NQZNUU/C1TxQHxbOt2/CUMzx6Pebjwjl++LSM9bgR9g6ZWfGkpU
   c4nXpiUz5HOm6YZXssPnh15dY8hS4n6iBgBGN126OhLkyspeqibYiv9RP
   4Wb3kr/zCNOx7X3JhRR/eFxSIpMsW+dGJOPTI1SmIRirzHDrd/HXSz4XP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="457151930"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="457151930"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 02:16:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="734447395"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="734447395"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga007.fm.intel.com with ESMTP; 08 Aug 2023 02:16:07 -0700
Date:   Tue, 8 Aug 2023 17:16:06 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
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
Message-ID: <20230808091606.jk667prer5lmtcpm@yy-desk-7060>
References: <cover.1689151537.git.kai.huang@intel.com>
 <41b7e5503a3e6057dc168b3c5a9693651c501d22.1689151537.git.kai.huang@intel.com>
 <20230712221510.GG3894444@ls.amr.corp.intel.com>
 <4202b26acdb3fe926dd1a9a46c2c7c35a5d85529.camel@intel.com>
 <20230713184434.GH3894444@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230713184434.GH3894444@ls.amr.corp.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 13, 2023 at 11:44:34AM -0700, Isaku Yamahata wrote:
> On Thu, Jul 13, 2023 at 03:46:52AM +0000,
> "Huang, Kai" <kai.huang@intel.com> wrote:
>
> > On Wed, 2023-07-12 at 15:15 -0700, Isaku Yamahata wrote:
> > > > The SEAMCALL ABI is very similar to the TDCALL ABI and leverages much
> > > > TDCALL infrastructure.  Wire up basic functions to make SEAMCALLs for
> > > > the basic TDX support: __seamcall(), __seamcall_ret() and
> > > > __seamcall_saved_ret() which is for TDH.VP.ENTER leaf function.
> > >
> > > Hi.  __seamcall_saved_ret() uses struct tdx_module_arg as input and output.  For
> > > KVM TDH.VP.ENTER case, those arguments are already in unsigned long
> > > kvm_vcpu_arch::regs[].  It's silly to move those values twice.  From
> > > kvm_vcpu_arch::regs to tdx_module_args.  From tdx_module_args to real registers.
> > >
> > > If TDH.VP.ENTER is the only user of __seamcall_saved_ret(), can we make it to
> > > take unsigned long kvm_vcpu_argh::regs[NR_VCPU_REGS]?  Maybe I can make the
> > > change with TDX KVM patch series.
> >
> > The assembly code assumes the second argument is a pointer to 'struct
> > tdx_module_args'.  I don't know how can we change __seamcall_saved_ret() to
> > achieve what you said.  We might change the kvm_vcpu_argh::regs[NR_VCPU_REGS] to
> > match 'struct tdx_module_args''s layout and manually convert part of "regs" to
> > the structure and pass to __seamcall_saved_ret(), but it's too hacky I suppose.
> >
> > This was one concern that I mentioned VP.ENTER can be implemented by KVM in its
> > own assembly in the TDX host v12 discussion.  I kinda agree we should leverage
> > KVM's existing kvm_vcpu_arch::regs[NR_CPU_REGS] infrastructure to minimize the
> > code change to the KVM's common infrastructure.  If so, I guess we have to carry
> > this memory copy burden between two structures.
> >
> > Btw, I do find KVM's VP.ENTER code is a little bit redundant to the common
> > SEAMCALL assembly, which is a good reason for KVM to use __seamcall() variants
> > for TDH.VP.ENTER.
> >
> > So it's a tradeoff I think.
> >
> > On the other hand, given CoCo VMs normally don't expose all GPRs to VMM, it's
> > also debatable whether we should invent another infrastructure to the KVM code
> > to handle register access of CoCo VMs too, e.g., we can catch bugs easily when
> > KVM tries to access the registers that it shouldn't access.
>
> Yes, we'd like to save/restore GPRs only for TDVMCALL. Otherwise skip
> save/restore.

And another case to save/restore GPRs: supports DEBUG TD,
which is type of TD guest allows VMM to change its register
context, for debugging purpose.

>
> --
> Isaku Yamahata <isaku.yamahata@gmail.com>
