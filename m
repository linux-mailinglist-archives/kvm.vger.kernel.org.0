Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456866D9F66
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 20:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240047AbjDFSAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 14:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240061AbjDFSAd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 14:00:33 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9E88689
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 11:00:30 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id d83-20020a25e656000000b00b8befc985b5so4292307ybh.22
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 11:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680804030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VDS5rumLEKu0toA0jNax9C97QASzXEN0xosq/hqUcKk=;
        b=CLHp/4LQ7cu0IlMz/tUDjOygvHYPKVYiB8FwL4w8bhDtDhIa9dxl9L/Pazrf5jIgT0
         7MOcr0SeL4N0PlTEL9yM5vGjgimD1/kVH7iYNBjExuacOhNCbjwPjpxa9Kq8JJBkoOYF
         f5o7f/IcMMUr3SVZjKUhUKc5Q/48j5XKeQ/iD0LDCbpcN95z2fWgPR3fNqUOuId5VUlP
         C6mJu3ablyiRuVhqwTToK8cP0712xUEksd3cqwnZML8nCFU08V+4cWHRLAGYTLiLiVjQ
         NFYN0RmgnSOFtJDpS85cryrNBhN+hspZIRDiYkIJCz7PY+QDm2K+2VQahoAHADTUXayu
         tvMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680804030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VDS5rumLEKu0toA0jNax9C97QASzXEN0xosq/hqUcKk=;
        b=UxKYH7sKbq5Bw6dUd9iLKFOb7gsf2BuorGTTCTa6qwwxOP6oasB5aIuFrZZZ2taYWy
         qM2Bs7o+yM6jaRB9WhK6amoNNlSZp1U7Rq0c5bxWuatDDEU0q0DyopWD1UZaajv08t6K
         QqXsgVrLkDfiZs/6ch4jupkndyzVILX3SjNtOUKZA2iznplBrcEyKoWBZLSznhZJpWhc
         XRNle66kq9qxzRMzWoND6bw8ndzJnEQZD+w+7esexGegtxNoDkqNjh0/mls/sC0aT6cR
         ORQACM3n7R8K30xOoSI1Knh9KNGaGhKLN2bNNR7A1zajS/O0xtrSbSZgb6akD82Cml8M
         2htg==
X-Gm-Message-State: AAQBX9djUXCKhAPJ4hUkQva5sNPLnhKBN/jTJxEXnt7qguk4YNwYwy1w
        +BYEVFEoSKEx4W4S6gHmgqJQiJQ6b5Q=
X-Google-Smtp-Source: AKy350aEt/9xw/P6awsqc/MFIc2ugA4jFk9M3SOO/AURFcgzkBTwDYMSeBJvn0v3OnTQA6YMDJf7xqHDExc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d8d0:0:b0:b6e:d788:eba7 with SMTP id
 p199-20020a25d8d0000000b00b6ed788eba7mr139746ybg.6.1680804030152; Thu, 06 Apr
 2023 11:00:30 -0700 (PDT)
Date:   Thu, 6 Apr 2023 11:00:28 -0700
In-Reply-To: <03504796e42badbb39d34b9e99c62ac4c2bb9b6f.camel@intel.com>
Mime-Version: 1.0
References: <20230405234556.696927-1-seanjc@google.com> <20230405234556.696927-3-seanjc@google.com>
 <03504796e42badbb39d34b9e99c62ac4c2bb9b6f.camel@intel.com>
Message-ID: <ZC8IsP5ehaJXQOnu@google.com>
Subject: Re: [PATCH 2/2] KVM: VMX: Inject #GP, not #UD, if SGX2 ENCLS leafs
 are unsupported
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 06, 2023, Huang, Kai wrote:
> On Wed, 2023-04-05 at 16:45 -0700, Sean Christopherson wrote:
> > Per Intel's SDM, unsupported ENCLS leafs result in a #GP, not a #UD.
> > SGX1 is a special snowflake as the SGX1 flag is used by the CPU as a
> > "soft" disable, e.g. if software disables machine check reporting, i.e.
> > having SGX but not SGX1 is effectively "SGX completely unsupported" and
> > and thus #UDs.
> 
> If I recall correctly, this is an erratum which can clear SGX1 in CPUID while
> the SGX flag is still in CPUID?

Nope, not an erratum, architectural behavior.

> But I am not sure whether this part is relevant to this patch?  Because SDM
> already says ENCLS causes #UD if SGX1 isn't present.  This patch changes
> "unsupported leaf" from causing #UD to causing #GP, which is also documented in
> SDM.

I wanted to capture why SGX1 is different and given special treatment in the SDM.
I.e. to explain why SGX1 leafs are an exception to the "#GP if leaf unsupported"
clause.

> > Fixes: 9798adbc04cf ("KVM: VMX: Frame in ENCLS handler for SGX virtualization")
> > Cc: Binbin Wu <binbin.wu@linux.intel.com>
> > Cc: Kai Huang <kai.huang@intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/vmx/sgx.c | 15 +++++++++------
> >  1 file changed, 9 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
> > index f881f6ff6408..1c092ab89c33 100644
> > --- a/arch/x86/kvm/vmx/sgx.c
> > +++ b/arch/x86/kvm/vmx/sgx.c
> > @@ -350,11 +350,12 @@ static int handle_encls_einit(struct kvm_vcpu *vcpu)
> >  
> >  static inline bool encls_leaf_enabled_in_guest(struct kvm_vcpu *vcpu, u32 leaf)
> >  {
> > -	if (!enable_sgx || !guest_cpuid_has(vcpu, X86_FEATURE_SGX))
> > -		return false;
> > -
> > +	/*
> > +	 * ENCLS #UDs if SGX1 isn't supported, i.e. this point will be reached
> 
> Why #UDs instead of #UD?  Is #UD a verb?

Heh, it is now ;-)  I can reword to something like

	/*
	 * ENCLS generates a #UD if SGX1 isn't supported ...
	 */

if my made up grammar is confusing.

> > +	 * if and only if the SGX1 leafs are enabled.
> > +	 */
> 
> Is it better to move "ENCLS #UDs if SGX1 isn't supported" part to ...
> 
> >  	if (leaf >= ECREATE && leaf <= ETRACK)
> > -		return guest_cpuid_has(vcpu, X86_FEATURE_SGX1);
> > +		return true;
> >  
> >  	if (leaf >= EAUG && leaf <= EMODT)
> >  		return guest_cpuid_has(vcpu, X86_FEATURE_SGX2);
> > @@ -373,9 +374,11 @@ int handle_encls(struct kvm_vcpu *vcpu)
> >  {
> >  	u32 leaf = (u32)kvm_rax_read(vcpu);
> >  
> > -	if (!encls_leaf_enabled_in_guest(vcpu, leaf)) {
> > +	if (!enable_sgx || !guest_cpuid_has(vcpu, X86_FEATURE_SGX) ||
> > +	    !guest_cpuid_has(vcpu, X86_FEATURE_SGX1)) {
> >  		kvm_queue_exception(vcpu, UD_VECTOR);
> 
> ... above here, where the actual code reside?

My goal was to document why encls_leaf_enabled_in_guest() unconditionally returns
true for SGX1 leafs, i.e. why it doesn't query X86_FEATURE_SGX1.  I'm definitely
not opposed to also adding a comment here, but I do want to keep the comment in
encls_leaf_enabled_in_guest().
