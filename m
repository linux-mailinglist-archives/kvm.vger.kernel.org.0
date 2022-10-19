Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84534604C17
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 17:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbiJSPse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 11:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbiJSPsE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 11:48:04 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8E81E197C
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 08:42:48 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y8so17563802pfp.13
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 08:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=upqU8Mp9XdsDo2EJGM30j4VPV+Bhei778Pm472C1I4U=;
        b=SxDKOTx2oR4WZDzNkn5ENrIa2t5BzHFNxnseRvwxSQ/kR/PGwyABqYfTzQamvMRFKV
         V8C1GvbP9TBaeuCeVr+Dv/9sLHaKRJoFiCMKqI2MwkOKlXkUPlHuJBv7gViqnglBY8aU
         YDAsuDKyzJmkl/0j0P478G4emjhQ8mganjK1sgzmDWU2fkFVr9zA4lv49mId+c5vrwKN
         MjAshaMS8YVIeevAqPLt1OA+ID3AyF4PAb3whFPSEioiK5BFXxEwOpUZBhJOtSfgMjW1
         ywsaIE1pXyF0fFXf+zmbSpJQaJB7FcMx+JVx80QKN7Z9eI8DcZFZfSgSS39dEKALWRwH
         jsQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=upqU8Mp9XdsDo2EJGM30j4VPV+Bhei778Pm472C1I4U=;
        b=Vf4eiAHICvEfilymDbKqvUrVrz6IHFhmiszBiLC45EN3TiLg6xrkHObGYUFCbBWg51
         DROE+yd+38HY/0XzVtMiGem89ASwBRZVQaENhXmyUKUiCppiBdKWS3CCJIJCJyAwGe/y
         8D+60LZrnkiV3uYjoKYSbyfh8EXdGmLCDANCLJwl1aRxoByYs/c/zSJ33d5WgMtHjnRK
         e4MUBdofj24VFbWrPdWqFD9csshbhEOSYFM+g61ayUfC0NVcUDZt1+jbth5dLzYUAksn
         bbQYIRTODAoG0x2YX/l+fzihs7EwClMorMg42Q9d+mkM9K0DqREr2Brx73k1REQbObas
         ZuZQ==
X-Gm-Message-State: ACrzQf1o4ND5OwTwHUWmn2JaMaw+rit3oOASdavDka045BnYSRvqH02B
        aCIMfZq+E8bNCDPULurQMktcbQ==
X-Google-Smtp-Source: AMsMyM4ceyD6dQ/iTOqPuX4R/oLHd07akKERNAd2+9xhwoNxxoNxfFuHhkRrMJ2VolWs5Hu3lwsPIA==
X-Received: by 2002:a63:5d18:0:b0:462:f77b:cd29 with SMTP id r24-20020a635d18000000b00462f77bcd29mr7855850pgb.9.1666194133718;
        Wed, 19 Oct 2022 08:42:13 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i3-20020aa796e3000000b005633a06ad67sm11462761pfq.64.2022.10.19.08.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 08:42:13 -0700 (PDT)
Date:   Wed, 19 Oct 2022 15:42:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v6 2/5] KVM: x86: Dirty quota-based throttling of vcpus
Message-ID: <Y1Aa0jQWOop2OHtC@google.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
 <20220915101049.187325-3-shivam.kumar1@nutanix.com>
 <Y0B+bPDrMdJQVX6p@google.com>
 <c6700c5d-d942-065b-411c-7f4723836054@nutanix.com>
 <a835d5c3-8742-e8f7-e810-a69a139c4349@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a835d5c3-8742-e8f7-e810-a69a139c4349@nutanix.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 18, 2022, Shivam Kumar wrote:
> > > #ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
> > > static inline bool kvm_check_dirty_quota_request(struct kvm_vcpu *vcpu)
> > > {
> > >     struct kvm_run *run = vcpu->run;
> > > 
> > >     run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
> > >     run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
> > >     run->dirty_quota_exit.quota = READ_ONCE(run->dirty_quota);
> > > 
> > >     /*
> > >      * Re-check the quota and exit if and only if the vCPU still
> > > exceeds its
> > >      * quota.  If userspace increases (or disables entirely) the
> > > quota, then
> > >      * no exit is required as KVM is still honoring its ABI, e.g.
> > > userspace
> > >      * won't even be aware that KVM temporarily detected an
> > > exhausted quota.
> > >      */
> > >     return run->dirty_quota_exit.count >= run->dirty_quota_exit.quota;
> > > }
> > > #endif
> > > 
> > > And then arch usage is simply something like:
> > > 
> > >         if (kvm_check_dirty_quota_request(vcpu)) {
> > >             r = 0;
> > >             goto out;
> > >         }
> > If we are not even checking for request KVM_REQ_DIRTY_QUOTA_EXIT, what's
> > the use of kvm_make_request in patch 1?
> Ok, so we don't need to explicitely check for request here because we are
> checking the quota directly but we do need to make the request when the
> quota is exhausted so as to guarantee that we enter the if block "if
> (kvm_request_pending(vcpu))".
> 
> Please let me know if my understanding is correct or if I am missing
> something.

The request needs to be explicitly checked, I simply unintentionally omitted that
code in the above snippet.  kvm_check_request() also _clears_ the request, which
is very important as not clearing the request will prevent KVM from entering the
guest.

The intent is to check KVM_REQ_DIRTY_QUOTA_EXIT in kvm_check_dirty_quota_request().

> 
> Also, should I add ifdef here:
> 
> 	#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
> 	if (kvm_check_dirty_quota_request(vcpu)) {
> 		r = 0;
> 		goto out;
> 	}
> 	#endif

No need for an #ifdef in the caller, the call is from arch code and architectures
that don't "select HAVE_KVM_DIRTY_QUOTA" shouldn't be checking for a dirty quota
exit.
