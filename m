Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756BC5AFBCB
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 07:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiIGFfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 01:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiIGFf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 01:35:27 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298124B49D;
        Tue,  6 Sep 2022 22:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662528926; x=1694064926;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=s/ws2IVLLDd2yoBtML6C/t5SDZcAcQIo3h0hl+fCkPk=;
  b=AMDxu4eOgCDPC3ZRPKuvt0Pmx+XVEdlXHEQ/UtPxcixdaYSnbpNTo3B8
   4nNHhPgGLUt/+hLGxEBsKaTq8HSa3QRX5mGdj2q9nrY15TXpRUUCImA3W
   5GNzqg/fuOTH3BAh9+C43/qKoLi68aRD0pGBvsxiaFZ64hwdc0Xb/3p4S
   mRefITf0v1wqziI/x2keKun5J8WT4J5lt575JKVOxvAkOive7z0N+E1E+
   YccovW4k10OI3hPmIqxFlO8gkn3AVKVQ6IigFG3Eg2bSbUQEYsxvh3AFa
   XBIkyWdOpEp0tDZFnjQoVVNe+80oHtpQwmTZpb40e7z+1OMe813+6RfMl
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="277177789"
X-IronPort-AV: E=Sophos;i="5.93,295,1654585200"; 
   d="scan'208";a="277177789"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 22:35:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,295,1654585200"; 
   d="scan'208";a="676020466"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga008.fm.intel.com with ESMTP; 06 Sep 2022 22:35:24 -0700
Date:   Wed, 7 Sep 2022 13:35:23 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 1/4] KVM: x86: move the event handling of
 KVM_REQ_GET_VMCS12_PAGES into a common function
Message-ID: <20220907053523.qb7qsbqfgcg2d2vx@yy-desk-7060>
References: <20220828222544.1964917-1-mizhang@google.com>
 <20220828222544.1964917-2-mizhang@google.com>
 <YwzkvfT0AiwaojTx@google.com>
 <20220907025042.hvfww56wskwhsjwk@yy-desk-7060>
 <CAL715WJK1WwXFfbUiMjngV8Z-0jyu_9JeZaK4qvvdJfYvtQEYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL715WJK1WwXFfbUiMjngV8Z-0jyu_9JeZaK4qvvdJfYvtQEYg@mail.gmail.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 06, 2022 at 09:26:33PM -0700, Mingwei Zhang wrote:
> > > @@ -10700,6 +10706,12 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
> > >               if (kvm_cpu_has_pending_timer(vcpu))
> > >                       kvm_inject_pending_timer_irqs(vcpu);
> > >
> > > +             if (vcpu->arch.nested_get_pages_pending) {
> > > +                     r = kvm_get_nested_state_pages(vcpu);
> > > +                     if (r <= 0)
> > > +                             break;
> > > +             }
> > > +
> >
> > Will this leads to skip the get_nested_state_pages for L2 first time
> > vmentry in every L2 running iteration ? Because with above changes
> > KVM_REQ_GET_NESTED_STATE_PAGES is not set in
> > nested_vmx_enter_non_root_mode() and
> > vcpu->arch.nested_get_pages_pending is not checked in
> > vcpu_enter_guest().
> >
> Good catch. I think the diff won't work when vcpu is runnable. It only
> tries to catch the vcpu block case. Even for the vcpu block case,  the
> check of KVM_REQ_UNBLOCK is way too late. Ah, kvm_vcpu_check_block()
> is called by kvm_vcpu_block() which is called by vcpu_block(). The
> warning is triggered at the very beginning of vcpu_block(), i.e.,
> within kvm_arch_vcpu_runnable(). So, please ignore the trace in my
> previous email.
>
> In addition, my minor push back for that is
> vcpu->arch.nested_get_pages_pending seems to be another
> KVM_REQ_GET_NESTED_STATE_PAGES.

Yeah, but in concept level it's not a REQ mask lives in the
vcpu->requests which can be cached by e.g. kvm_request_pending().
It's necessary to check vcpu->arch.nested_get_pages_pending in
vcpu_enter_guest() if Sean's idea is to replace
KVM_REQ_GET_NESTED_STATE_PAGES with nested_get_pages_pending.

>
> Thanks.
> -Mingwei
>
>
> -Mingwei
