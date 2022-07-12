Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A74570F6A
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 03:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbiGLBYQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 21:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbiGLBYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 21:24:14 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0967C20F48;
        Mon, 11 Jul 2022 18:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657589053; x=1689125053;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=t/rZzEhN/luqnDo+goJEWDGNHozkvcN+wJndb+YzP8U=;
  b=kG3EJc48NJjfycVW0Bsh3O3SCOxjfA2RTBOb/0SIemSq5FPNi3dJ6Kig
   6wuiVGvhrrdWalw4so4D2YyN1z46Ckl6zC7XJYWhFpnZhI1ZqFid+0m7h
   IQxv+NwQvJlLOSAyRaSxHLK1Bia1MffRf/KlO/0McNZt1sTlpSN4sFwkE
   Re1L3ivoYpk00HMMkTv3JEnidPpwBQPESXHFecPQgY7UOTVbCmoHC+r1H
   EFJhzsgtWrBWlhq5qNcNu0H9OVfa5i4Cp7e7RkaK7wATZrRD98bCXUiJg
   gV0YA/73/3tkxhq4J2qZcpT+VgTeKu4t+LHLIsELH/29A581tqLxU7Iq9
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="265223266"
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="265223266"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 18:24:12 -0700
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="545235317"
Received: from snaskant-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.60.27])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 18:24:10 -0700
Message-ID: <21d982b56e3958ae85c308defd13ec5f5e2edd39.camel@intel.com>
Subject: Re: [PATCH v7 012/102] KVM: x86: Introduce vm_type to differentiate
 default VMs from confidential VMs
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Date:   Tue, 12 Jul 2022 13:24:08 +1200
In-Reply-To: <20220712010115.GE1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <5979d880dc074c7fa57e02da34a41a6905ebd89d.1656366338.git.isaku.yamahata@intel.com>
         <3c5d4e38b631a921006e44551fe1249339393e41.camel@intel.com>
         <20220712010115.GE1379820@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-07-11 at 18:01 -0700, Isaku Yamahata wrote:
> On Tue, Jun 28, 2022 at 02:52:28PM +1200,
> Kai Huang <kai.huang@intel.com> wrote:
>=20
> > On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > >=20
> > > Unlike default VMs, confidential VMs (Intel TDX and AMD SEV-ES) don't=
 allow
> > > some operations (e.g., memory read/write, register state access, etc)=
.
> > >=20
> > > Introduce vm_type to track the type of the VM to x86 KVM.  Other arch=
 KVMs
> > > already use vm_type, KVM_INIT_VM accepts vm_type, and x86 KVM callbac=
k
> > > vm_init accepts vm_type.  So follow them.  Further, a different polic=
y can
> > > be made based on vm_type.  Define KVM_X86_DEFAULT_VM for default VM a=
s
> > > default and define KVM_X86_TDX_VM for Intel TDX VM.  The wrapper func=
tion
> > > will be defined as "bool is_td(kvm) { return vm_type =3D=3D VM_TYPE_T=
DX; }"
> > >=20
> > > Add a capability KVM_CAP_VM_TYPES to effectively allow device model,
> > > e.g. qemu, to query what VM types are supported by KVM.  This (introd=
uce a
> > > new capability and add vm_type) is chosen to align with other arch KV=
Ms
> > > that have VM types already.  Other arch KVMs uses different name to q=
uery
> > > supported vm types and there is no common name for it, so new name wa=
s
> > > chosen.
> > >=20
> > > Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > > ---
> > >  Documentation/virt/kvm/api.rst        | 21 +++++++++++++++++++++
> > >  arch/x86/include/asm/kvm-x86-ops.h    |  1 +
> > >  arch/x86/include/asm/kvm_host.h       |  2 ++
> > >  arch/x86/include/uapi/asm/kvm.h       |  3 +++
> > >  arch/x86/kvm/svm/svm.c                |  6 ++++++
> > >  arch/x86/kvm/vmx/main.c               |  1 +
> > >  arch/x86/kvm/vmx/tdx.h                |  6 +-----
> > >  arch/x86/kvm/vmx/vmx.c                |  5 +++++
> > >  arch/x86/kvm/vmx/x86_ops.h            |  1 +
> > >  arch/x86/kvm/x86.c                    |  9 ++++++++-
> > >  include/uapi/linux/kvm.h              |  1 +
> > >  tools/arch/x86/include/uapi/asm/kvm.h |  3 +++
> > >  tools/include/uapi/linux/kvm.h        |  1 +
> > >  13 files changed, 54 insertions(+), 6 deletions(-)
> > >=20
> > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/=
api.rst
> > > index 9cbbfdb663b6..b9ab598883b2 100644
> > > --- a/Documentation/virt/kvm/api.rst
> > > +++ b/Documentation/virt/kvm/api.rst
> > > @@ -147,10 +147,31 @@ described as 'basic' will be available.
> > >  The new VM has no virtual cpus and no memory.
> > >  You probably want to use 0 as machine type.
> > > =20
> > > +X86:
> > > +^^^^
> > > +
> > > +Supported vm type can be queried from KVM_CAP_VM_TYPES, which return=
s the
> > > +bitmap of supported vm types. The 1-setting of bit @n means vm type =
with
> > > +value @n is supported.
> >=20
> >=20
> > Perhaps I am missing something, but I don't understand how the below ch=
anges
> > (except the x86 part above) in Documentation are related to this patch.
>=20
> This is to summarize divergence of archs.  Those archs (s390, mips, and
> arm64) introduce essentially same KVM capabilities, but different names. =
This
> patch makes things worse.  So I thought it's good idea to summarize it. P=
robably
> this documentation part can be split out into its own patch. thoughts?

I will leave to maintainers here.  Thought personally I would split differe=
nt
things into different patches.

>=20
>=20
> > > diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> > > index 54d7a26ed9ee..2f43db5bbefb 100644
> > > --- a/arch/x86/kvm/vmx/tdx.h
> > > +++ b/arch/x86/kvm/vmx/tdx.h
> > > @@ -17,11 +17,7 @@ struct vcpu_tdx {
> > > =20
> > >  static inline bool is_td(struct kvm *kvm)
> > >  {
> > > -	/*
> > > -	 * TDX VM type isn't defined yet.
> > > -	 * return kvm->arch.vm_type =3D=3D KVM_X86_TDX_VM;
> > > -	 */
> > > -	return false;
> > > +	return kvm->arch.vm_type =3D=3D KVM_X86_TDX_VM;
> > >  }
> >=20
> > If you put this patch before patch:
> >=20
> > 	[PATCH v7 009/102] KVM: TDX: Add placeholders for TDX VM/vcpu structur=
e
> >=20
> > Then you don't need to introduce this chunk in above patch and then rem=
ove it
> > here, which is unnecessary and ugly.
> >=20
> > And you can even only introduce KVM_X86_DEFAULT_VM but not KVM_X86_TDX_=
VM in
> > this patch, so you can make this patch as a infrastructural patch to re=
port VM
> > type.  The KVM_X86_TDX_VM can come with the patch where is_td() is intr=
oduced
> > (in your above patch 9). =C2=A0
> >=20
> > To me, it's more clean way to write patch.  For instance, this infrastr=
uctural
> > patch can be theoretically used by other series if they have similar th=
ing to
> > support, but doesn't need to carry is_td() and KVM_X86_TDX_VM burden th=
at you
> > made.
>=20
> There are two choices. One is to put this patch before 9 as you suggested=
, other
> is to  put it here right before the patch 13 that uses vm_type_supported(=
).
>=20
> Thanks,

To me this belongs to category of "infrastructural patch", which does "Add =
new
ABI to support reporting VM types".  It can originally support default VM o=
nly.
TDX VM can come later.  But will leave to maintainers.



