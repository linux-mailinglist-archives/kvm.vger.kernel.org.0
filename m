Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557E36365AB
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 17:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239053AbiKWQYU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 11:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239004AbiKWQYT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 11:24:19 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCA588F95
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 08:24:18 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id k5so16280910pjo.5
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 08:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L+6ppVIqqbNb02maVSXdZmZVIyzAVJ79ha839OUO0cA=;
        b=f/RfJ7lFv/MTQKJya9oVQyJr03wOCjShEQkN5OhgObroHh7BDFf7f0izssVx6oOI4Z
         /noX/O9lSTrq+KGUDbE0816ALj+ilmrEnehwZ1O6X6qfUhxRgXbfMxvaoXhEEPYNYIiQ
         X5CawSpzsw6rlCYaO+LG8G4sirpxkdEiZtgJWgG0MWuxGCyR70BE3gAYW9VCzkJVJnpR
         0p/EeBYK+TiVtkAdKT6Xe7eIcbF8nBhKLVn4pnKcwk9d3Uh+5iJ5xwnjB8ZK73+ERjVT
         jbaElHzSaYexAOsx89R+xxxgcEEHJksAH3U9ILWLS0/mP/KrQm4AQ+K8cwNalQsBfwbz
         RM3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L+6ppVIqqbNb02maVSXdZmZVIyzAVJ79ha839OUO0cA=;
        b=TFe51Arc361VOAhAeNHbZG2XdpE4knBIyz8Kd7Vv2JdHSOh/fZ9gaLEDuvqipoiySy
         +iibHSy4+6cfSRJGs+IZ+l2IFJClCX+UBvHc1bApRcYoyFpgpWzVDjuIXv4qfh2xEUsW
         qXBb+VV0yb3HsEZCNon65jVf+BsvDfRpe0s1niUsdyiiY0diqTQcbeuC9T59ox38zIRA
         Wk4zduJrM0lD8I0/FslTrLZO5JY0hTGQrmmTjaTBmYNHgTy+Zm/XmxwUkLUGuXsfVg2v
         gYZBm/1wXw20QewpveNuqxfeQI3U78Nv2se2638tOOMPD3uM7bTfWBomMt7ZlFFcNOAP
         sKcA==
X-Gm-Message-State: ANoB5pl3McQZCVkZh9lS2LK00nLffkJQk8dlaSMBLr3jyOyiVbhjH1Hp
        7gFecL0ramkRt5KY4DnJ+CA+5A==
X-Google-Smtp-Source: AA0mqf5VS/h4A73iHgZYDMfT9P5J23PD6gSRRSSMj40uq1Mn1RE1S7EhmzziFGRZek2lUzfJWdKPNA==
X-Received: by 2002:a17:902:bd04:b0:189:38a1:30fe with SMTP id p4-20020a170902bd0400b0018938a130femr6638487pls.47.1669220657738;
        Wed, 23 Nov 2022 08:24:17 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 135-20020a62178d000000b0056e8eb09d58sm13233391pfx.170.2022.11.23.08.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 08:24:17 -0800 (PST)
Date:   Wed, 23 Nov 2022 16:24:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Wang, Lei" <lei4.wang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 036/144] KVM: selftest: Add proper helpers for
 x86-specific save/restore ioctls
Message-ID: <Y35JLYD8uU2x7OpG@google.com>
References: <20220603004331.1523888-1-seanjc@google.com>
 <20220603004331.1523888-37-seanjc@google.com>
 <e6fdcfeb-bd78-6906-f2b2-94c765be7902@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6fdcfeb-bd78-6906-f2b2-94c765be7902@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022, Wang, Lei wrote:
> 
> On 6/3/2022 8:41 AM, Sean Christopherson wrote:
> > Add helpers for the various one-off helpers used by x86's vCPU state
> > save/restore helpers, and convert the other open coded ioctl()s to use
> > existing helpers.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  .../selftests/kvm/include/x86_64/processor.h  |  54 ++++++++
> >  .../selftests/kvm/lib/x86_64/processor.c      | 126 +++++-------------
> >  2 files changed, 91 insertions(+), 89 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> > index e4268432cfe8..1d46d60bb480 100644
> > --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> > @@ -432,6 +432,60 @@ const struct kvm_msr_list *kvm_get_feature_msr_index_list(void);
> >  bool kvm_msr_is_in_save_restore_list(uint32_t msr_index);
> >  uint64_t kvm_get_feature_msr(uint64_t msr_index);
> >  
> > +static inline void vcpu_msrs_get(struct kvm_vm *vm, uint32_t vcpuid,
> > +				 struct kvm_msrs *msrs)
> > +{
> > +	int r = __vcpu_ioctl(vm, vcpuid, KVM_GET_MSRS, msrs);
> > +
> > +	TEST_ASSERT(r == msrs->nmsrs,
> > +		    "KVM_GET_MSRS failed, r: %i (failed on MSR %x)",
> > +		    r, r < 0 || r >= msrs->nmsrs ? -1 : msrs->entries[r].index);
> > +}
> > +static inline void vcpu_msrs_set(struct kvm_vm *vm, uint32_t vcpuid,
> > +				 struct kvm_msrs *msrs)
> > +{
> > +	int r = __vcpu_ioctl(vm, vcpuid, KVM_SET_MSRS, msrs);
> > +
> > +	TEST_ASSERT(r == msrs->nmsrs,
> > +		    "KVM_GET_MSRS failed, r: %i (failed on MSR %x)",
> 
> Hi, Sean, this should be the "KVM_SET_MSRS failed", right?

Yep.  I wish I could say I was cleverly justifying use of macro magic, but it was
just a copy+paste goof.
