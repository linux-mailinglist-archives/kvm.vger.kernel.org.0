Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E11958360F
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 02:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236408AbiG1Asm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 20:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236337AbiG1Ask (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 20:48:40 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771375A2C4;
        Wed, 27 Jul 2022 17:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658969319; x=1690505319;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=n0+u3qQjBHjzD5Z26a1dlESHYO+jSVVySd7JC68F2ew=;
  b=WinUQTHlbAtoUPMqkCmj7Y31HqyharAme/bePjRBBcHzVY9QNG+w6Ouz
   CwGUNjc/ZvMYzx/h4o42JkhimaSur9R3yjOSkgq6qbGwNkYwh4ceLSxwN
   a5r9qyCA5ptfQ0OdWP3rL/8jir03Gxp9z5WDFf3N6rHG+UAwqGJwBXnDP
   XWDSfXsJ1ZjLqp7aZSzyyftEmEtT8eTjkAnsgWeS7aXHT0N3MzRbjkVJm
   /+jxZg9ztP1Ex6OVn1yoXqPf3OcbqL7cSO2MtG5EAnfmJAd9xyq9mqPck
   3iYVB3ydqG1RdXgIMmoWBdTRCgDTnG3W/4+3cmwoEykHzmbWWJq3/kVna
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="314169056"
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="314169056"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 17:48:39 -0700
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="633417803"
Received: from lmcmurch-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.76.147])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 17:48:37 -0700
Message-ID: <a0aaf7458536129fd6fe81417ab43f6dc6b4d4b3.camel@intel.com>
Subject: Re: [PATCH v7 037/102] KVM: x86/mmu: Track shadow MMIO value/mask
 on a per-VM basis
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Thu, 28 Jul 2022 12:48:35 +1200
In-Reply-To: <20220727232058.GB3669189@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <242df8a7164b593d3702b9ba94889acd11f43cbb.1656366338.git.isaku.yamahata@intel.com>
         <20220719084737.GU1379820@ls.amr.corp.intel.com>
         <c9d7f7e0665358f7352e95a7028a8779fd0531c6.camel@intel.com>
         <20220727232058.GB3669189@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-07-27 at 16:20 -0700, Isaku Yamahata wrote:
> > KVM has a global enable_mmio_caching boolean, and I think we should hon=
or it
> > here (in this patch) by doing below first:
> >=20
> > =C2=A0	if (enabling_mmio_caching)
> > =C2=A0		mmio_value =3D 0;
>=20
> This function already includes "if (!enable_mmio_caching) mmio_value =3D =
0;" in
> the beginning. (But not in this hunk, though).=C2=A0 So this patch honors=
 the
> kernel
> module parameter.

Yeah I missed that. Thanks.

--=20
Thanks,
-Kai


