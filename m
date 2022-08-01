Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1504A58728B
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 22:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbiHAUyp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 16:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234182AbiHAUyo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 16:54:44 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607AE25E87;
        Mon,  1 Aug 2022 13:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659387283; x=1690923283;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=pQhtdszcHMGPbia0y/FuipLo7GGj6lQUsaAbpfds0dc=;
  b=eOjxCqn2vyvleCIsPjOCMKTppeoF3r36zoei7n1HftRgDGrK9B4XwBJ1
   kJvRtll5WojeK5ERSLz5RLYax1AL3Pyi8SaMXOZIFjJuS5IgMZFZLyx4q
   cSolAviAUrcuFD2SDrMBNhYFT2mBQR8HtFe63maZZmY4O3zW6tyLk+Nn4
   ZcByAlrLOa9F7LTt3KrHEbMIeusP3NnpbZSAcXtli/XwOo7iGuxVRdjBZ
   5YRUWnnIyKC8hQU2X9iB/x5EuTTsypKqLHBQTIvMqsB+zk+38JN2L2jQn
   apNQ6R1iPGt3cZm9HonQgIA2e39s5Cj7WqQaoNYf/MNyH6dBFFTkrEzca
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="269629921"
X-IronPort-AV: E=Sophos;i="5.93,209,1654585200"; 
   d="scan'208";a="269629921"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 13:46:29 -0700
X-IronPort-AV: E=Sophos;i="5.93,209,1654585200"; 
   d="scan'208";a="929698557"
Received: from vgutierr-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.22.230])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 13:46:28 -0700
Message-ID: <244f619a4e7a1c7079830d12379872a111da418d.camel@intel.com>
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Fully re-evaluate MMIO caching when
 SPTE masks change
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Date:   Tue, 02 Aug 2022 08:46:26 +1200
In-Reply-To: <YufgCR9CpeoVWKF7@google.com>
References: <20220728221759.3492539-1-seanjc@google.com>
         <20220728221759.3492539-3-seanjc@google.com>
         <9104e22da628fef86a6e8a02d9d2e81814a9d598.camel@intel.com>
         <YuP3zGmpiALuXfW+@google.com>
         <f313c41ed50e187ae5de87b32325c6cd4cc17c79.camel@intel.com>
         <YufgCR9CpeoVWKF7@google.com>
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

On Mon, 2022-08-01 at 14:15 +0000, Sean Christopherson wrote:
> On Mon, Aug 01, 2022, Kai Huang wrote:
> > On Fri, 2022-07-29 at 15:07 +0000, Sean Christopherson wrote:
> > > Lastly, in prepration for TDX, enable_mmio_caching should be changed =
to key off
> > > of the _mask_, not the value.  E.g. for TDX, the value will be '0', b=
ut the mask
> > > should be SUPPRESS_VE | RWX.
> >=20
> > Agreed.  But perhaps in another patch.  We need to re-define what does
> > mask/value mean to enable_mmio_caching.
>=20
> There's no need to redefine what they mean, the only change that needs to=
 be made
> is handle the scenario where desire value is '0'.  Maybe that's all you m=
ean by
> "redefine"?

My thinking is only when mask and value both are 0, enable_mmio_caching is
considered disabled.  vlaue=3D0 is valid when enable_mmio_caching is true a=
s you
said.

>=20
> Another thing to note is that only the value needs to be per-VM, the mask=
 can be
> KVM-wide, i.e. "mask =3D SUPPRESS_VE | RWX" will work for TDX and non-TDX=
 VMs when
> EPT is enabled.

Yeah, but is more like VMX and TDX both *happen* to have the same mask?=20
Theoretically,  VMX only need RWX to trigger EPT misconfiguration but doesn=
't
need SUPPRESS_VE.

I don't see making mask/value both per-vm is a big issue?

--=20
Thanks,
-Kai


