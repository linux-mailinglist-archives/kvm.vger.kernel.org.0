Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC79570F7C
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 03:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbiGLBas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 21:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiGLBak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 21:30:40 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0B08D5C4;
        Mon, 11 Jul 2022 18:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657589438; x=1689125438;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=1RZzCBkXJQjWTSgsl9Jv2PCXCDnTfY3JSvo9zqzQcW0=;
  b=Fd4/VzMTOzHNuaevw20XhNEPpwjQJLpZq50LPJ29RxYP5jHIrUapiCyf
   rXiqvI1H0bwe3/FSaNpIr7n+CPhfuLOX8HNAlBztkePKXBE5M5U0CI+B3
   ELnNAAR5hXb9GfpNYXMtL+1W0s1u59LufGflubx5oAcivcmhZbP+bMz2U
   TFdoJqYlR0eo9Jfu79dkJ7eK9P3UHux9+6xUCU6m4L4K/JoY8ifYbq9h4
   nl9NNCSnLH1ujdqSZHSKm5Lrdrs2NNlzXpyK6QCZBGsZ4EwIHWLztaYln
   PtJXPpFWkHt+bZv4oeTibKO5YSl1xhRHKdcrwq5s/jXSPy+6HTtroIE6u
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="267850418"
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="267850418"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 18:30:38 -0700
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="652699409"
Received: from snaskant-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.60.27])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 18:30:36 -0700
Message-ID: <20f87d1f04f71bd2be63519ebf2a2447c07f7e7a.camel@intel.com>
Subject: Re: [PATCH v7 008/102] KVM: x86: Refactor KVM VMX module init/exit
 functions
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue, 12 Jul 2022 13:30:34 +1200
In-Reply-To: <20220712003811.GB1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <b8761fc945630d6f264ff22a388d286394a2904f.1656366338.git.isaku.yamahata@intel.com>
         <46acf87f3980a6f709e191cfc10ff4be78e23553.camel@intel.com>
         <20220712003811.GB1379820@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-07-11 at 17:38 -0700, Isaku Yamahata wrote:
> On Tue, Jun 28, 2022 at 03:53:31PM +1200,
> Kai Huang <kai.huang@intel.com> wrote:
>=20
> > On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > >=20
> > > Currently, KVM VMX module initialization/exit functions are a single
> > > function each.  Refactor KVM VMX module initialization functions into=
 KVM
> > > common part and VMX part so that TDX specific part can be added clean=
ly.
> > > Opportunistically refactor module exit function as well.
> > >=20
> > > The current module initialization flow is, 1.) calculate the sizes of=
 VMX
> > > kvm structure and VMX vcpu structure, 2.) hyper-v specific initializa=
tion
> > > 3.) report those sizes to the KVM common layer and KVM common
> > > initialization, and 4.) VMX specific system-wide initialization.
> > >=20
> > > Refactor the KVM VMX module initialization function into functions wi=
th a
> > > wrapper function to separate VMX logic in vmx.c from a file, main.c, =
common
> > > among VMX and TDX.  We have a wrapper function, "vt_init() {vmx kvm/v=
cpu
> > > size calculation; hv_vp_assist_page_init(); kvm_init(); vmx_init(); }=
" in
> > > main.c, and hv_vp_assist_page_init() and vmx_init() in vmx.c.
> > > hv_vp_assist_page_init() initializes hyper-v specific assist pages,
> > > kvm_init() does system-wide initialization of the KVM common layer, a=
nd
> > > vmx_init() does system-wide VMX initialization.
> > >=20
> > > The KVM architecture common layer allocates struct kvm with reported =
size
> > > for architecture-specific code.  The KVM VMX module defines its struc=
ture
> > > as struct vmx_kvm { struct kvm; VMX specific members;} and uses it as
> > > struct vmx kvm.  Similar for vcpu structure. TDX KVM patches will def=
ine
> > > TDX specific kvm and vcpu structures, add tdx_pre_kvm_init() to repor=
t the
> > > sizes of them to the KVM common layer.
> > >=20
> > > The current module exit function is also a single function, a combina=
tion
> > > of VMX specific logic and common KVM logic.  Refactor it into VMX spe=
cific
> > > logic and KVM common logic.  This is just refactoring to keep the VMX
> > > specific logic in vmx.c from main.c.
> >=20
> > This patch, coupled with the patch:
> >=20
> > 	KVM: VMX: Move out vmx_x86_ops to 'main.c' to wrap VMX and TDX
> >=20
> > Basically provides an infrastructure to support both VMX and TDX.  Why =
we cannot
> > merge them into one patch?  What's the benefit of splitting them?
> >=20
> > At least, why the two patches cannot be put together closely?
>=20
> It is trivial for the change of "KVM: VMX: Move out vmx_x86_ops to 'main.=
c' to
> wrap VMX and TDX" to introduce no functional change.  But it's not trivia=
l
> for this patch to introduce no functional change.

This doesn't sound right.  If I understand correctly, this patch supposedly
shouldn't bring any functional change, right?  Could you explain what funct=
ional
change does this patch bring?


