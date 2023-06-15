Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6407323C9
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 01:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240049AbjFOXqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 19:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjFOXqA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 19:46:00 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF0D2951
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 16:45:59 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bce1d7a8d2aso63219276.2
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 16:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686872759; x=1689464759;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O1j1/CGdS8c+h0DXj7uvf0ZGWib7G67HcFTSIHLIPys=;
        b=LzTSgFZ5bxxAUUiLZtvC+xclv52Icp8UqayoRrFg2nyTH65UyUnq4epTBd2OnueVbn
         V88w/rVi5XSi2kuLTX5LlFb3sR1kj7qXQV1owJjt+eZFJxsbIQSVbeANDTQop3jHBv7K
         WQXPwQVrtelf4I0ELMJWuXVmHX18uUr4oZ4h7f3c5DZUKKcWDbcl3YUnxxifWbGIFagS
         R+0bLK34KsX1qIXN/HnJzicM5JtUwMdhySyrtLOyD4qYqafjMO32wz0dHPQJx1CUkgtH
         4HlBeM4RKT6pQMR2zR/tqdrXu6Q2y1+io6IpcbZP9tJQvU7OnG30UKQMhOey2ZSjM8wO
         D//w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686872759; x=1689464759;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O1j1/CGdS8c+h0DXj7uvf0ZGWib7G67HcFTSIHLIPys=;
        b=Ob39Z4SOZWmGL4tv/kSEyNRSA7FtHCbscN9NAboTGSeyPCr3Bl5C1BJVyeg+PEKQkg
         PYk3FWOQo2RtcVeThzpmeJ8aNkP8d+Utjs5xIsdIPF+nPwadGewoeoQOEvrI/svZ2wIs
         MTxpiuebOh9IWOp5BJataDVYp9MKAB0tP/dDEefOgScu06VaGVd1cP5VyjzqvMxlsX0o
         sHICfhKQSPR62GVwvwPJZLo+bGVl1DHF3rqF4GdotZC+IkR80DATYXsepIuHjSSEmqbd
         7vBsnzNutNtiHkhXwBfGMCnHoWmv4NNPDiUiCjjX8BB5MvNsg5dRf9t5O7nJfMT96xw/
         +eJQ==
X-Gm-Message-State: AC+VfDxwKvSKBZZRItla3CGZg8mIGxWntOUjTKIpE4iq9K+wpva3YimG
        CYLEG41sdGMJ8aIRiSzW+ErwOGDXH8k=
X-Google-Smtp-Source: ACHHUZ6LzMHzbPy7MHoIXxldNV8tox62l/uAktJMqu1F8P0e185bL4dBqGBRrc+1S2ty0MyQtLPnD8ZlBwE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d08:0:b0:bc5:117e:d4a8 with SMTP id
 8-20020a250d08000000b00bc5117ed4a8mr12050ybn.13.1686872758986; Thu, 15 Jun
 2023 16:45:58 -0700 (PDT)
Date:   Thu, 15 Jun 2023 16:45:57 -0700
In-Reply-To: <6e1e9de9-8def-46c3-a238-c1b4ef52e331@intel.com>
Mime-Version: 1.0
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-8-weijiang.yang@intel.com> <ZG77wu4PyBn1z587@chao-email>
 <23169e5f-9793-9486-fd5f-287e3317b837@intel.com> <ZHXnP5bEvxPrDg3m@chao-email>
 <6e1e9de9-8def-46c3-a238-c1b4ef52e331@intel.com>
Message-ID: <ZIuitcH7P1JpkzFH@google.com>
Subject: Re: [PATCH v3 07/21] KVM:x86: Refresh CPUID on write to guest MSR_IA32_XSS
From:   Sean Christopherson <seanjc@google.com>
To:     Weijiang Yang <weijiang.yang@intel.com>
Cc:     Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023, Weijiang Yang wrote:
> 
> On 5/30/2023 8:08 PM, Chao Gao wrote:
> > > > > --- a/arch/x86/kvm/x86.c
> > > > > +++ b/arch/x86/kvm/x86.c
> > > > > @@ -3776,8 +3776,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > > > > 		 */
> > > > > 		if (data & ~kvm_caps.supported_xss)
> > > > Shouldn't we check against the supported value of _this_ guest? similar to
> > > > guest_supported_xcr0.
> > > I don't think it requires an extra variable to serve per guest purpose.
> > > 
> > > For guest XSS settings, now we don't add extra constraints like XCR0, thus
> > QEMU can impose constraints by configuring guest CPUID.0xd.1 to indicate
> > certain supervisor state components cannot be managed by XSAVES, even
> > though KVM supports them. IOW, guests may differ in the supported values
> > for the IA32_XSS MSR.
> 
> OK, will change this part to align with xcr0 settings. Thanks!

Please write KVM-Unit-Tests to verify KVM correctly handles the various MSRs related
to CET, e.g. a test_cet_msrs() subtest in msr.c would do nicely.  Hmm, though testing
the combinations of CPUID bits will require multiple x86/unittests.cfg entries.
Might be time to split up msr.c into a library and then multiple tests.
