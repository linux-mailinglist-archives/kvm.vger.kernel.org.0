Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1395884D3
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 01:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbiHBXnB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 19:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiHBXnA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 19:43:00 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755AD51A37;
        Tue,  2 Aug 2022 16:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659483779; x=1691019779;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=k1gNX86YincOcL9VRCK/r4AXXqCHM/b4AG11KWtCuDY=;
  b=WmqGv8SlJxLkEFy0UeAb6izDAfkkTAz3TtTOJbf2fWWrDUAmebDM+Zo/
   ceV2xWxcBH7HrtokDyL9CajbJARFFpJ1jU90We0ktTxPdDzyxq4aD7/Dj
   wnSiRBctTUkvJEARZ8+zK5uBikQNEpBzKCKEveT8yYrpIOzKEpjTecn9w
   SjUkC1psv8enKIYnJA09w3j5crsPy3hMRzaPinDeIP97hAQHnBw03Zjl9
   nsdm+skB/RaEcBl1P52vIXbqWJeCPclHobnCdt4djkZ/36LlZTwh0QTvR
   jv3bPVLPm/SCnZNQ16C2rd2w0DH53AcKsco5LjT1vKgYRprLxWCkVFObB
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10427"; a="351256633"
X-IronPort-AV: E=Sophos;i="5.93,212,1654585200"; 
   d="scan'208";a="351256633"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 16:42:59 -0700
X-IronPort-AV: E=Sophos;i="5.93,212,1654585200"; 
   d="scan'208";a="630917735"
Received: from gvenka2-desk.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.85.17])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 16:42:57 -0700
Message-ID: <72b51c373e09fe8f0a6a65c40d75753348c64ce1.camel@intel.com>
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Fully re-evaluate MMIO caching when
 SPTE masks change
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Date:   Wed, 03 Aug 2022 11:42:55 +1200
In-Reply-To: <YumtzyBgNLWGh466@google.com>
References: <20220728221759.3492539-3-seanjc@google.com>
         <9104e22da628fef86a6e8a02d9d2e81814a9d598.camel@intel.com>
         <YuP3zGmpiALuXfW+@google.com>
         <f313c41ed50e187ae5de87b32325c6cd4cc17c79.camel@intel.com>
         <YufgCR9CpeoVWKF7@google.com>
         <244f619a4e7a1c7079830d12379872a111da418d.camel@intel.com>
         <YuhfuQbHy4P9EZcw@google.com>
         <4fd3cea874b69f1c8bbcaf19538c7fdcb9c22aab.camel@intel.com>
         <YumT+6joTz2M1zZP@google.com>
         <ebbccf92d7ab97bd79dac5529f109aa5b92542ab.camel@intel.com>
         <YumtzyBgNLWGh466@google.com>
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

On Tue, 2022-08-02 at 23:05 +0000, Sean Christopherson wrote:
> On Wed, Aug 03, 2022, Kai Huang wrote:
> > On Tue, 2022-08-02 at 21:15 +0000, Sean Christopherson wrote:
> > > On Tue, Aug 02, 2022, Kai Huang wrote:
> > > > But we are not checking any of those in kvm_mmu_set_mmio_spte_mask(=
), right? :)
> > >=20
> > > No, but we really should.
> >=20
> > I can come up a patch if you are not planning to do so?
>=20
> Hmm, I'll throw one together, it's simple enough (famous last words) and =
it'll
> need to be tested on AMD as well.

Sure.

--=20
Thanks,
-Kai


