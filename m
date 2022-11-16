Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCEB562C5A1
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 17:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbiKPQ7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 11:59:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232907AbiKPQ73 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 11:59:29 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F5F167D8
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 08:59:27 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 62so8870643pgb.13
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 08:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TUFCsEixkdCGsIn+uhHCgHlafwcM3IPg0krVnDbhBBg=;
        b=TzEQCV1NVEuLAi963h6vCc2pdKN4lL1UWqYKRzLv4KAu1eiKlZwDevKoEs+v4sYAxa
         CGm5m8jomzNJdb8D2IpAsAcZFif8RL8b2NuYEkJP119O0O1d587uw6s2sNFczQ4QAfeE
         Xp/WTUUq8mAoiIMGdUXbvua2ZwAosCrAKMeWjngjdnO1yuRMdcxuCUsK55Li5WpVzY7r
         Vv5Zbft53B/vFSwJrwbSMWRPAsymwHhTkFkdlDsBQFdhuP80CMxMAM3fcOiLupKhIv4P
         PoKsOmXSqxM51ypbdOfB0y1rusJ3SFBh2Em7LUUeATmr+fQXxCQT1wxI+Rb9Jks1eUjC
         fDlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TUFCsEixkdCGsIn+uhHCgHlafwcM3IPg0krVnDbhBBg=;
        b=RJQw8yMkkZdYfFqluM8TqaYK4UCjQihJD5R2ucSOFkvYCXz8NQLEy9W/gG+URmW+A0
         DKtumSFt79JsibXEDyMBn4CJWerZOxpyCajci8ziUAHv2IJPLzKKxEOyp+WDBITmT7xY
         8FFFMJUS/fcE4cPAfUnTlcOQ+Zael2NW+u0UC4Dj5Wsr0dkDdinihCR30ZDKfw3+5iQI
         63hp0ThpJJsDob7jC6A8rRvDajjZbNC6iOPzi3xNhYvwyGdjuwy86NjVpEH3DgAWnpRb
         OhvBzU8CIFKiLWIWaMTmfHlapFobtzl7miHNxpSa47XqzsMQGztimgnU4MwE66AG+FE8
         URsA==
X-Gm-Message-State: ANoB5pmn1K2VlcCPobanTcOHswhWdyh2euFb75hgWCB5+HELmeX15zw6
        TyayKgrKmg7FH5hvZem5wxgu1A==
X-Google-Smtp-Source: AA0mqf4ymB4YFjGD+xqe9zHEWLq3eMShuRZgv3M345mvM68usLXq8ngFpesgZP6yeCjeiSFC7eGJcw==
X-Received: by 2002:a63:555e:0:b0:46b:8e9:7d5f with SMTP id f30-20020a63555e000000b0046b08e97d5fmr21857090pgm.597.1668617967460;
        Wed, 16 Nov 2022 08:59:27 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m1-20020a1709026bc100b00186c9d17af2sm12348254plt.17.2022.11.16.08.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 08:59:26 -0800 (PST)
Date:   Wed, 16 Nov 2022 16:59:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Santosh Shukla <santosh.shukla@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, pbonzini@redhat.com,
        jmattson@google.com, kvm@vger.kernel.org, joro@8bytes.org,
        linux-kernel@vger.kernel.org, mail@maciej.szmigiero.name,
        vkuznets@redhat.com
Subject: Re: [PATCHv5 0/8] Virtual NMI feature
Message-ID: <Y3UW672P8ruO48Ct@google.com>
References: <20221027083831.2985-1-santosh.shukla@amd.com>
 <d109feb8-7d07-0bf1-f4ad-76d4230ed498@amd.com>
 <869d05b2ce0437efae1cf505cf4028ceb4920ce2.camel@redhat.com>
 <fc8813c6-0091-8571-d934-e33d7d56123d@amd.com>
 <f764c7a1eb4a9fe294f04ea48db2dae9c18116c8.camel@redhat.com>
 <ce8f06df-5c7a-e122-3eb7-0d20207cfd2c@amd.com>
 <bc7fd8db-88e6-ea9c-2266-d0e129025e6b@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc7fd8db-88e6-ea9c-2266-d0e129025e6b@amd.com>
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

On Wed, Nov 16, 2022, Tom Lendacky wrote:
> On 11/16/22 09:44, Santosh Shukla wrote:
> > Hello Maxim,.
> > 
> > On 11/16/2022 2:51 PM, Maxim Levitsky wrote:
> > > On Wed, 2022-11-16 at 11:10 +0530, Santosh Shukla wrote:
> > > > Hi Maxim,
> > > > 
> > > > On 11/14/2022 8:01 PM, Maxim Levitsky wrote:
> > > > > On Mon, 2022-11-14 at 13:32 +0530, Santosh Shukla wrote:
> > > > > I started reviewing it today and I think there are still few issues,
> > > > > and the biggest one is that if a NMI arrives while vNMI injection
> > > > > is pending, current code just drops such NMI.

I don't think it gets dropped, just improperly delayed.

> > > > > We had a discussion about this, like forcing immeditate vm exit
> > > > 
> > > > I believe, We discussed above case in [1] i.e.. HW can handle
> > > > the second (/pending)virtual NMI while the guest processing first virtual NMI w/o vmexit.
> > > > is it same scenario or different one that you are mentioning?
> > > > 
> > > > [1] https://lore.kernel.org/lkml/1782cdbb-8274-8c3d-fa98-29147f1e5d1e@amd.com/>>
> > > You misunderstood the issue.
> > > 
> > > Hardware can handle the case when a NMI is in service (that is V_NMI_MASK
> > > is set) and another one is injected (V_NMI_PENDING can be set),
> > > 
> > > but it is not possible to handle the case when a NMI is already injected
> > > (V_NMI_PENDING set) but and KVM wants to inject another one before the
> > > first one went into the service (that is V_NMI_MASK is not set yet).
> > 
> > In this case, HW will collapse the NMI.

Yes, but practically speaking two NMIs can't arrive at the exact same instance on
bare metal.  One NMI will always arrive first and get vectored, and then the second
NMI will arrive and be pended.  In a virtual environment, two NMIs that are sent
far apart can arrive together, e.g. if the vCPU is scheduled out for an extended
period of time.  KVM mitigates this side effect by allowing two NMIs to be pending.

The problem here isn't that second the NMI is lost, it's that KVM can't get control
when the first NMI completes (IRETs).  KVM can pend both NMIs and queue the first
for injection/vectoring (set V_NMI_PENDING), but AIUI there is no mechanism (and no
code) to force a VM-Exit on the IRET so that KVM can inject the second NMI.

Santosh's response in v2[*] suggested that hardware would allow KVM to "post" an
NMI while the vCPU is running, but I don't see any code in this series to actually
do that.  svm_inject_nmi() is only called from the vCPU's run loop, i.e. requires
a VM-Exit.

[*] https://lore.kernel.org/all/1782cdbb-8274-8c3d-fa98-29147f1e5d1e@amd.com

> > Note that the HW will take the pending NMI at the boundary of IRET instruction such that
> > it will check for the V_NMI_PENDING and if its set then HW will *take* the NMI,
> > HW will clear the V_NMI_PENDING bit and set the V_NMI_MASK w/o the VMEXIT!,.
> > 
> > 
> > > Also same can happen when NMIs are blocked in SMM, since V_NMI_MASK is
> > > set despite no NMI in service, we will be able to inject only one NMI by
> > > setting the V_NMI_PENDING.

I believe this one is a non-issue.  Like bare metal, KVM only allows one NMI to
be pending if NMIs are blocked.

  static void process_nmi(struct kvm_vcpu *vcpu)
  {
	unsigned limit = 2;

	/*
	 * x86 is limited to one NMI running, and one NMI pending after it.
	 * If an NMI is already in progress, limit further NMIs to just one.
	 * Otherwise, allow two (and we'll inject the first one immediately).
	 */
	if (static_call(kvm_x86_get_nmi_mask)(vcpu) || vcpu->arch.nmi_injected)
		limit = 1;

	vcpu->arch.nmi_pending += atomic_xchg(&vcpu->arch.nmi_queued, 0);
	vcpu->arch.nmi_pending = min(vcpu->arch.nmi_pending, limit);
	kvm_make_request(KVM_REQ_EVENT, vcpu);
  }


> > Ditto,. HW will collapse the NMI.
> 
> Note, this is how bare-metal NMIs are also handled. Multiple NMIs are
> collapsed into a single NMI if they are received while an NMI is currently
> being processed.

