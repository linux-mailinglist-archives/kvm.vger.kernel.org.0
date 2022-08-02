Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A998058841C
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 00:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234937AbiHBWTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 18:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiHBWTk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 18:19:40 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461D8F584;
        Tue,  2 Aug 2022 15:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659478779; x=1691014779;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=rVk3Q1NSe0FUTqWPvIopaXse8VnflA9IUoUyNUenB6g=;
  b=gOlu/Ca1qluypRBfl8Ul9L1XgT98cOdLlUUa3kwgpBAT6HEdM8Rohe51
   f2nhkrcGEz27J1gCMCbIS9XBdmZavxnpcdnr7/vMFajgGBDukD36MD0ec
   aZDenkK7x8pal+GnbGgf6X5dELQPlFumVquKh4g1nfNI9VVrFUfBf0WnC
   Hv4s5Pk8U8voJqh9RYmnC9SFukWhCxJwTZwtXKNdBJebVh20JFa0BkvsN
   DJ+SDj+vbxG8+VRylFnr870hd5M1JIv4IIONQQgEs3r14KBJplQyhY0Lv
   Iu4SUkedMJaPIDhaepIMXe5avq9g7iu66mj0uPfH2wG4Yvj+J+Sc2RTDn
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10427"; a="353534423"
X-IronPort-AV: E=Sophos;i="5.93,212,1654585200"; 
   d="scan'208";a="353534423"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 15:19:38 -0700
X-IronPort-AV: E=Sophos;i="5.93,212,1654585200"; 
   d="scan'208";a="692015435"
Received: from gvenka2-desk.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.85.17])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 15:19:36 -0700
Message-ID: <ebbccf92d7ab97bd79dac5529f109aa5b92542ab.camel@intel.com>
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Fully re-evaluate MMIO caching when
 SPTE masks change
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Date:   Wed, 03 Aug 2022 10:19:35 +1200
In-Reply-To: <YumT+6joTz2M1zZP@google.com>
References: <20220728221759.3492539-1-seanjc@google.com>
         <20220728221759.3492539-3-seanjc@google.com>
         <9104e22da628fef86a6e8a02d9d2e81814a9d598.camel@intel.com>
         <YuP3zGmpiALuXfW+@google.com>
         <f313c41ed50e187ae5de87b32325c6cd4cc17c79.camel@intel.com>
         <YufgCR9CpeoVWKF7@google.com>
         <244f619a4e7a1c7079830d12379872a111da418d.camel@intel.com>
         <YuhfuQbHy4P9EZcw@google.com>
         <4fd3cea874b69f1c8bbcaf19538c7fdcb9c22aab.camel@intel.com>
         <YumT+6joTz2M1zZP@google.com>
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

On Tue, 2022-08-02 at 21:15 +0000, Sean Christopherson wrote:
> On Tue, Aug 02, 2022, Kai Huang wrote:
> > On Mon, 2022-08-01 at 23:20 +0000, Sean Christopherson wrote:
> > > On Tue, Aug 02, 2022, Kai Huang wrote:
> > > > On Mon, 2022-08-01 at 14:15 +0000, Sean Christopherson wrote:
> > > > > Another thing to note is that only the value needs to be per-VM, =
the mask can be
> > > > > KVM-wide, i.e. "mask =3D SUPPRESS_VE | RWX" will work for TDX and=
 non-TDX VMs when
> > > > > EPT is enabled.
> > > >=20
> > > > Yeah, but is more like VMX and TDX both *happen* to have the same m=
ask?=20
> > > > Theoretically,  VMX only need RWX to trigger EPT misconfiguration b=
ut doesn't
> > > > need SUPPRESS_VE.
> > >=20
> > > Right, SUPPRESS_VE isn't strictly necessary, but KVM already delibera=
tely avoids
> > > bit 63 because it has meaning, e.g. SUPPRESS_VE for EPT and NX for PA=
E and 64-bit
> > > paging. =20
> > >=20
> > > > I don't see making mask/value both per-vm is a big issue?
> > >=20
> > > Yes and no.
> > >=20
> > > No, in the sense that it's not a big issue in terms of code. =20
> > >=20
> > > Yes, because of the connotations of having a per-VM mask.  While havi=
ng SUPPRESS_VE
> > > in the mask for non-TDX EPT isn't strictly necessary, it's also not s=
trictly necessary
> > > to _not_ have it in the mask. =C2=A0
> > >=20
> >=20
> > I think the 'mask' itself is ambiguous, i.e. it doesn't say in what cir=
cumstance
> > we should include one bit to the mask.  My understanding is any bit in =
the
> > 'mask' should at least be related to the 'value' that can enable MMIO c=
aching.
>=20
> The purpose of the mask isn't ambiguous, though it's definitely not well =
documented.
> The mask defines what bits should be included in the check to identify an=
 MMIO SPTE.

Yes this is true.

> =20
> > So if SUPPRESS_VE bit is not related to non-TDX EPT (as we want EPT
> > misconfiguration, but not EPT violation), I don't see why we need to in=
clude it
> > to the  'mask'.
>=20
> Again, it's not strictly necessary, but by doing so we don't need a per-V=
M mask.
> And KVM should also never set SUPPRESS_VE for MMIO SPTEs, i.e. checking t=
hat bit
> by including it in the mask adds some sanitcy check (albeit a miniscule a=
mount).

OK.

>=20
> > > In other words, having a per-VM mask incorrectly implies that TDX _mu=
st_
> > > have a different mask.
> >=20
> > I interpret as TDX _can_, but not _must_.=20
>=20
> Right, but if we write the KVM code such that it doesn't have a different=
 mask,
> then even that "can" is wrong/misleading.
>=20
> > > It's also one more piece of information that developers have to track=
 down and
> > > account for, i.e. one more thing we can screw up.
> > >=20
> > > The other aspect of MMIO SPTEs are that the mask bits must not overla=
p the generation
> > > bits or shadow-present bit, and changing any of those bits requires c=
areful
> > > consideration, i.e. defining the set of _allowed_ mask bits on a per-=
VM basis would
> > > incur significant complexity without providing meaningful benefit. =
=C2=A0
> > >=20
> >=20
> > Agreed on this.
> >=20
> > But we are not checking any of those in kvm_mmu_set_mmio_spte_mask(), r=
ight? :)
>=20
> No, but we really should.

I can come up a patch if you are not planning to do so?

>=20
> > Also Isaku's patch extends kvm_mmu_set_mmio_spte_mask() to take 'kvm' o=
r 'vcpu'
> > as parameter so it's easy to check there -- not 100% sure about other p=
laces,
> > though.
> >=20
> > > As a result,
> > > it's highly unlikely that we'll ever want to opportunsitically "recla=
im" bit 63
> > > for MMIO SPTEs, so there's practically zero cost if it's included in =
the mask for
> > > non-TDX EPT.
> >=20
> > Sorry I don't understand this.  If we will never "reclaim" bit 63 for M=
MIO SPTEs
> > (for non-TDX EPT), then why bother including it to the mask?
>=20
> Because then we don't need to track a per-VM mask.

OK.

--=20
Thanks,
-Kai


