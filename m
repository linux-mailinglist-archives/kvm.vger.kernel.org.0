Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A35F572BCB
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 05:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbiGMDQ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 23:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiGMDQy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 23:16:54 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF39AD7A6A;
        Tue, 12 Jul 2022 20:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657682212; x=1689218212;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=1Erh3CyyDV9THBc/EKhKsORANd2MPiX3UyCy+uJR4Fk=;
  b=XfEig+POze3uyqJz1NAyvnwxgLx6erNB/bca4PaSasEpAdfi9xhZa8Jt
   ycFd5sdZG1Afw3hfRtYsnlFwUwYx7I4hvB+S9UsKr+htOIOn9xD/fvfi3
   HqtCSfHpyNeWCXrNMyrUAbMQ6Htel6g77H8EmAdYYMwGq7dhLUoDjTTzy
   I6MJq9nO6bQnywEKajRm6HGUfj3c0JfgMKu+l7LLtTiI56Ukusoij+BML
   inwF12oiFzde56pvlea2geAPgOPM6F48eq6FRfMRpho7OMMU87i2Af5Ih
   hQsrZ3EA/s9dYUedf/zDlHhIzx0Dt9CSMReWs+g/yygJgcPq2reqmrZ3B
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="371411118"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="371411118"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 20:16:52 -0700
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="722194206"
Received: from ifatima-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.1.196])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 20:16:50 -0700
Message-ID: <ce0e84a0504c1af4ad672b7d4802af8b3d27c32c.camel@intel.com>
Subject: Re: [PATCH v7 003/102] KVM: Refactor CPU compatibility check on
 module initialiization
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Wed, 13 Jul 2022 15:16:48 +1200
In-Reply-To: <1b5e06b237ad9f2bcbee320e95b94e336109b484.camel@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <e1f72040effd7b4ed31f9941e009f959d6345129.1656366338.git.isaku.yamahata@intel.com>
         <1b5e06b237ad9f2bcbee320e95b94e336109b484.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> > +	/* hardware_enable_nolock() checks CPU compatibility on each CPUs. */
> > +	r =3D hardware_enable_all();
> > +	if (r)
> > +		goto out_free_2;
> > +	/*
> > +	 * Arch specific initialization that requires to enable virtualizatio=
n
> > +	 * feature.  e.g. TDX module initialization requires VMXON on all
> > +	 * present CPUs.
> > +	 */
> > +	kvm_arch_post_hardware_enable_setup(opaque);
>=20
> Please see my reply to your patch  "KVM: TDX: Initialize TDX module when =
loading
> kvm_intel.ko".
>=20
> The introduce of __weak kvm_arch_post_hardware_enable_setup() should be i=
n that
> patch since it has nothing to do the job you claimed to do in this patch.
>=20
> And by removing it, this patch can be taken out of TDX series and upstrea=
med
> separately.

I tried to dig more about the history.  Please see my another reply and ign=
ore
this.

