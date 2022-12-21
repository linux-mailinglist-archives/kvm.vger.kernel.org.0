Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E76D652B0D
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 02:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbiLUBi5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 20:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiLUBiz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 20:38:55 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE4E19295
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 17:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671586735; x=1703122735;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qD7m/SbiPOuKEQIXu3TYJ1CiSGwGa8pvZuIcV1mECWo=;
  b=ZzWn2dFC62YP2ySiOMRLJ8DCaQ8VZpp1tUE1wnOi62hNvegwAh+YGOzE
   nwqZeAVgWbVfh3QaLFdMfx96mF8eqeziMODAeXhFj3vVQUQBJjhD5+7Bp
   uQSp3IhGS4plM4r4LYPqjNP2RIb+COPc3+CRl95aY2wZPbqddk2Lshqta
   rvkk0Rg5L3nS53FFzcg1HMqQZgdUueB6wLlteRS12768S+pVUzWQicz34
   noc5FYUtOBjVGCKlBLAPbuyCqfey1rUoAUac0E1PQrd0s43kwsN+l0fWv
   EFgMjbYw+6sKg1EEt9OaH/bzw5m8sbxQn0NIvFx+Gr7hHTFsY7hXT3Dx5
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="317396673"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="317396673"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 17:38:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="601318037"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="601318037"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 20 Dec 2022 17:38:52 -0800
Message-ID: <ebd5415244e7e7a22866bd621f496a2b885bdc03.camel@linux.intel.com>
Subject: Re: [PATCH v3 6/9] KVM: x86: Untag LAM bits when applicable
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     "Yang, Weijiang" <weijiang.yang@intel.com>
Cc:     "Liu, Jingqi" <jingqi.liu@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date:   Wed, 21 Dec 2022 09:38:51 +0800
In-Reply-To: <4bff3b59-c18b-85d1-2164-cf31076780b6@intel.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
         <20221209044557.1496580-7-robert.hu@linux.intel.com>
         <4bff3b59-c18b-85d1-2164-cf31076780b6@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-12-21 at 08:35 +0800, Yang, Weijiang wrote: 
> > +static inline u64 get_canonical(u64 la, u8 vaddr_bits)
> > +{
> > +	return ((int64_t)la << (64 - vaddr_bits)) >> (64 - vaddr_bits);
> > +}
> > +
> 
> 
> There's already a helper for the calculation: __canonical_address(),
> and 
> it's used in KVM
> 
> before set MSR_IA32_SYSENTER_ESP/MSR_IA32_SYSENTER_EIP.
> 
Nice, thanks Weijiang.

