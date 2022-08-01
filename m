Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905AC5866CF
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 11:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiHAJYr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 05:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiHAJYq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 05:24:46 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4662B262;
        Mon,  1 Aug 2022 02:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659345885; x=1690881885;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=QWVvjey/dksFQW/RTfsfgO50b7Vmv3Qkk+RxCKGjmcE=;
  b=UGHZKGxIYuiJAiF4CadFvkjPplCn1lY5RCqWRAIOfH70CxtGD2iG69Pb
   F6sS9eyBK7zZGVt/nMsaEXIi/Iw3ZvLmnyeoEybeVSiV/6a0sYaHo6MNf
   RoUqRg6Nz0ANuqqKscx4ZQIVCkRmhv0Ck/55mts8WSWgjUgoYVHSPguNP
   FvTTxR0n1zxflijvLLs6bI4zgO/1pfAhkgXReZoPIcpOd65fLYGdaSTKV
   oL+SFO9pa+DT4grfm0VFG461vEvkOEMs/wgUNF/1/W3addB14aRsAkafc
   OBhWyHep93b1ydiM1j5W9S19cCeO7UOJtTVCP2MgGgHo7BccUBF50bCxv
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10425"; a="290312625"
X-IronPort-AV: E=Sophos;i="5.93,206,1654585200"; 
   d="scan'208";a="290312625"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 02:24:45 -0700
X-IronPort-AV: E=Sophos;i="5.93,206,1654585200"; 
   d="scan'208";a="630168167"
Received: from dmikhail-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.187.210])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 02:24:43 -0700
Message-ID: <f313c41ed50e187ae5de87b32325c6cd4cc17c79.camel@intel.com>
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Fully re-evaluate MMIO caching when
 SPTE masks change
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Date:   Mon, 01 Aug 2022 21:24:41 +1200
In-Reply-To: <YuP3zGmpiALuXfW+@google.com>
References: <20220728221759.3492539-1-seanjc@google.com>
         <20220728221759.3492539-3-seanjc@google.com>
         <9104e22da628fef86a6e8a02d9d2e81814a9d598.camel@intel.com>
         <YuP3zGmpiALuXfW+@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-07-29 at 15:07 +0000, Sean Christopherson wrote:
> On Fri, Jul 29, 2022, Kai Huang wrote:
> > On Thu, 2022-07-28 at 22:17 +0000, Sean Christopherson wrote:
> > > Fully re-evaluate whether or not MMIO caching can be enabled when SPT=
E
> > > masks change; simply clearing enable_mmio_caching when a configuratio=
n
> > > isn't compatible with caching fails to handle the scenario where the
> > > masks are updated, e.g. by VMX for EPT or by SVM to account for the C=
-bit
> > > location, and toggle compatibility from false=3D>true.
> > >=20
> > > Snapshot the original module param so that re-evaluating MMIO caching
> > > preserves userspace's desire to allow caching.  Use a snapshot approa=
ch
> > > so that enable_mmio_caching still reflects KVM's actual behavior.
> > >=20
>=20
> ..
>=20
> > > @@ -340,6 +353,12 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, =
u64 mmio_mask, u64 access_mask)
> > >  	BUG_ON((u64)(unsigned)access_mask !=3D access_mask);
> > >  	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
> > > =20
> > > +	/*
> > > +	 * Reset to the original module param value to honor userspace's de=
sire
> > > +	 * to (dis)allow MMIO caching.  Update the param itself so that
> > > +	 * userspace can see whether or not KVM is actually using MMIO cach=
ing.
> > > +	 */
> > > +	enable_mmio_caching =3D allow_mmio_caching;
> >=20
> > I think the problem comes from MMIO caching mask/value are firstly set =
in
> > kvm_mmu_reset_all_pte_masks() (which calls kvm_mmu_set_mmio_spte_mask()=
 and may
> > change enable_mmio_caching), and later vendor specific code _may_ or _m=
ay_not_
> > call kvm_mmu_set_mmio_spte_mask() again to adjust the mask/value.  And =
when it
> > does, the second call from vendor specific code shouldn't depend on the
> > 'enable_mmio_caching' value calculated in the first call in=20
> > kvm_mmu_reset_all_pte_masks().
>=20
> Correct.
>=20
> > Instead of using 'allow_mmio_caching', should we just remove
> > kvm_mmu_set_mmio_spte_mask() in kvm_mmu_reset_all_pte_masks() and enfor=
ce vendor
> > specific code to always call kvm_mmu_set_mmio_spte_mask() depending on =
whatever
> > hardware feature the vendor uses?
>=20
> Hmm, I'd rather not force vendor code to duplicate the "basic" functional=
ity.
> It's somewhat silly to preserve the common path since both SVM and VMX ne=
ed to
> override it, but on the other hand those overrides are conditional.

OK.=20

>=20
> Case in point, if I'm reading the below patch correctly, svm_shadow_mmio_=
mask will
> be left '0' if the platform doesn't support memory encryption (svm_adjust=
_mmio_mask()
> will bail early).  That's a solvable problem, but then I think KVM just e=
nds up
> punting this issue to SVM to some extent.

That patch is not supposed to have any functional change to AMD. Yes this n=
eeds
to be fixed if we go with solution.

>=20
> Another flaw in the below patch is that enable_mmio_caching doesn't need =
to be
> tracked on a per-VM basis.  VMX with EPT can have different masks, but ba=
rring a
> massive change in KVM or hardware, there will never be a scenario where c=
aching is
> enabled for one VM but not another.

Yeah it looks so, if we always treat TDX guest must have enable_mmio_cachin=
g
enabled (reading your reply to patch 4).

>=20
> And isn't the below patch also broken for TDX?  For TDX, unless things ha=
ve changed,
> the mask+value is supposed to be SUPPRES_VE=3D=3D0 && RWX=3D=3D0.  So eit=
her KVM is generating
> the wrong mask (MAXPHYADDR < 51), or KVM is incorrectly marking MMIO cach=
ing as disabled
> in the TDX case.

The MMIO mask/value set for TDX will come in another patch.  My suggestion =
is
this patch is some kinda infrastructural patch which doesn't bring any
functional change.
=20
>=20
> Lastly, in prepration for TDX, enable_mmio_caching should be changed to k=
ey off
> of the _mask_, not the value.  E.g. for TDX, the value will be '0', but t=
he mask
> should be SUPPRESS_VE | RWX.

Agreed.  But perhaps in another patch.  We need to re-define what does
mask/value mean to enable_mmio_caching.

--=20
Thanks,
-Kai


