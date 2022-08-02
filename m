Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846965874B1
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 02:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235211AbiHBAFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 20:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235433AbiHBAFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 20:05:45 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE96632A;
        Mon,  1 Aug 2022 17:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659398744; x=1690934744;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=rWuQPCu40e7gDnk51I9xaScsexta3PguED9KE//tWpI=;
  b=fDJLHrptnYkvZNmDOlek/jf19QzA4LIV+r/mYZUhAuHqYiUnlfJIRf3b
   ZY93agzveLCkHA4goNk7KHdv2QAahCzlC+IREhvuZ1XXkYUGtDbbENytz
   XY8I31WmFT4XRZSpTirnuCsfoQ9rrDTsNaYh32sxzXHgqczueU+LWkQWl
   /AcgyC8t5lgTpKpjm4hZIaU4aKNEISwA6OtXQJRVx18CevC1bzzDRJE9/
   VdoJQF1jp0LL0+McNSYBSr7Apg0Y+F9I0sZk3iUjruFpx1DDNKHbC9us3
   IUIVrgiacXoRTuiiyReCH9QLhwi6Bvg42F/kr3jQEFZ+GBA0Lrun3qCCk
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="269660282"
X-IronPort-AV: E=Sophos;i="5.93,209,1654585200"; 
   d="scan'208";a="269660282"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 17:05:44 -0700
X-IronPort-AV: E=Sophos;i="5.93,209,1654585200"; 
   d="scan'208";a="635091573"
Received: from vgutierr-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.22.230])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 17:05:42 -0700
Message-ID: <4fd3cea874b69f1c8bbcaf19538c7fdcb9c22aab.camel@intel.com>
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Fully re-evaluate MMIO caching when
 SPTE masks change
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Date:   Tue, 02 Aug 2022 12:05:39 +1200
In-Reply-To: <YuhfuQbHy4P9EZcw@google.com>
References: <20220728221759.3492539-1-seanjc@google.com>
         <20220728221759.3492539-3-seanjc@google.com>
         <9104e22da628fef86a6e8a02d9d2e81814a9d598.camel@intel.com>
         <YuP3zGmpiALuXfW+@google.com>
         <f313c41ed50e187ae5de87b32325c6cd4cc17c79.camel@intel.com>
         <YufgCR9CpeoVWKF7@google.com>
         <244f619a4e7a1c7079830d12379872a111da418d.camel@intel.com>
         <YuhfuQbHy4P9EZcw@google.com>
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

On Mon, 2022-08-01 at 23:20 +0000, Sean Christopherson wrote:
> On Tue, Aug 02, 2022, Kai Huang wrote:
> > On Mon, 2022-08-01 at 14:15 +0000, Sean Christopherson wrote:
> > > Another thing to note is that only the value needs to be per-VM, the =
mask can be
> > > KVM-wide, i.e. "mask =3D SUPPRESS_VE | RWX" will work for TDX and non=
-TDX VMs when
> > > EPT is enabled.
> >=20
> > Yeah, but is more like VMX and TDX both *happen* to have the same mask?=
=20
> > Theoretically,  VMX only need RWX to trigger EPT misconfiguration but d=
oesn't
> > need SUPPRESS_VE.
>=20
> Right, SUPPRESS_VE isn't strictly necessary, but KVM already deliberately=
 avoids
> bit 63 because it has meaning, e.g. SUPPRESS_VE for EPT and NX for PAE an=
d 64-bit
> paging. =20
>=20
> > I don't see making mask/value both per-vm is a big issue?
>=20
> Yes and no.
>=20
> No, in the sense that it's not a big issue in terms of code. =20
>=20
> Yes, because of the connotations of having a per-VM mask.  While having S=
UPPRESS_VE
> in the mask for non-TDX EPT isn't strictly necessary, it's also not stric=
tly necessary
> to _not_ have it in the mask. =C2=A0
>=20

I think the 'mask' itself is ambiguous, i.e. it doesn't say in what circums=
tance
we should include one bit to the mask.  My understanding is any bit in the
'mask' should at least be related to the 'value' that can enable MMIO cachi=
ng.

So if SUPPRESS_VE bit is not related to non-TDX EPT (as we want EPT
misconfiguration, but not EPT violation), I don't see why we need to includ=
e it
to the  'mask'.

> In other words, having a per-VM mask incorrectly
> implies that TDX _must_ have a different mask.

I interpret as TDX _can_, but not _must_.=20

>=20
> It's also one more piece of information that developers have to track dow=
n and
> account for, i.e. one more thing we can screw up.
>=20
> The other aspect of MMIO SPTEs are that the mask bits must not overlap th=
e generation
> bits or shadow-present bit, and changing any of those bits requires caref=
ul
> consideration, i.e. defining the set of _allowed_ mask bits on a per-VM b=
asis would
> incur significant complexity without providing meaningful benefit. =C2=A0
>=20

Agreed on this.

But we are not checking any of those in kvm_mmu_set_mmio_spte_mask(), right=
? :)

Also Isaku's patch extends kvm_mmu_set_mmio_spte_mask() to take 'kvm' or 'v=
cpu'
as parameter so it's easy to check there -- not 100% sure about other place=
s,
though.

> As a result,
> it's highly unlikely that we'll ever want to opportunsitically "reclaim" =
bit 63
> for MMIO SPTEs, so there's practically zero cost if it's included in the =
mask for
> non-TDX EPT.

Sorry I don't understand this.  If we will never "reclaim" bit 63 for MMIO =
SPTEs
(for non-TDX EPT), then why bother including it to the mask?

--=20
Thanks,
-Kai


