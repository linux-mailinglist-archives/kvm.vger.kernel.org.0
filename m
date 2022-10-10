Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCEB5FA198
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 18:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiJJQLD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 12:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJJQLB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 12:11:01 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8456763F0
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 09:11:00 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-134072c15c1so9734938fac.2
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 09:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x2nED0+TQLc6U31Ti6w2dwFd1Eoxx9h276QS/yTWAeg=;
        b=H1d+0IqiTfJE6pgU+Etr8NnugoIhRaBkrSlFmQ+BF9PiY4aB0jtoLLCIq2wIR26Kh8
         c+r02dRVAPYNevZbGyWomsNoaD2dIx/xeKQZMAoGnXYadi9W3ToP/TA5YJAI1kI68jmg
         dil0xKG9ARg9Jn3UoPmUTQEFoh12l4CUBjstvFw5Ubj1dRaMuLIOVbY9S4vcdLRMJgHI
         tZrxEgIIOjT5BwkCrkSS0wkYnXIdddKxgo2y6QBXbbJ8/S9SdAcnUMtWlFeWlduXYINp
         pLpp44DZJWISbkrLM1C/qMF1vx3Nu3efk3otozi9wE/Airj1/H/qyCanWH6sRwOFVzfW
         Xgdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x2nED0+TQLc6U31Ti6w2dwFd1Eoxx9h276QS/yTWAeg=;
        b=Y5N/SatwEoDNJ5q+n6WXrGzwwa++QR/PWCU41J9bG97VRHXI7b86ueAeKBNTU/8YoS
         T+/Tqr8eKKUh6P/ZADEmyAYjbaScMILPU5WR+oYySjdQc+IDmAZ0amiM4HqH3fjQ7U8O
         gWozh87L2aiVF2nLmObO0Z8vdWM8wZWeDgJ/VdZJVK1hPOlYlTL2ukmGwrR66D55nWv1
         hdHRMnEg4kX8jUdn9HSzkOdFj9Xwfhlrh0OHij5vXTnhZvPF0fLE+trTnFlHXWbwbctr
         0DiLsQjPEif/uHtV+9fdPpVgGyIA5CXRewg0NkpQHLjhPu8DWlR1pssC3TFBIfAf6/Wj
         ryAA==
X-Gm-Message-State: ACrzQf1bfh+abNGoeZPMBEO56O6ciN6bZCnVSvupQEqUR4jLj05lhbGn
        GLobXMVxCkVi9WYw6mCLyJO2BGA6rRWP8A==
X-Google-Smtp-Source: AMsMyM4ceeFFlo2pvQrhpdhr6HAL2iuOB01FnTfL8FgTC4OlgkcUdIk71RQuEq2jz/iYTPW0VecCRw==
X-Received: by 2002:a17:90b:2246:b0:205:97a5:520e with SMTP id hk6-20020a17090b224600b0020597a5520emr32850183pjb.244.1665418170772;
        Mon, 10 Oct 2022 09:09:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id l2-20020a170902f68200b0017a0f40fa19sm6860531plg.191.2022.10.10.09.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 09:09:30 -0700 (PDT)
Date:   Mon, 10 Oct 2022 16:09:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v6 1/5] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <Y0RDtu+8v5G/hm81@google.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
 <20220915101049.187325-2-shivam.kumar1@nutanix.com>
 <Y0B5RFI25TotwWHT@google.com>
 <Y0B753GVEgGP/Iqg@google.com>
 <7e3a978c-381c-5090-0620-40b7d6ef6fc0@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e3a978c-381c-5090-0620-40b7d6ef6fc0@nutanix.com>
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

On Mon, Oct 10, 2022, Shivam Kumar wrote:
> 
> 
> On 08/10/22 12:50 am, Sean Christopherson wrote:
> > On Fri, Oct 07, 2022, Sean Christopherson wrote:
> > > On Thu, Sep 15, 2022, Shivam Kumar wrote:
> > > Let's keep kvm_vcpu_check_dirty_quota(), IMO that's still the least awful name.
> > > 
> > > [*] https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_all_Yo-2B82LjHSOdyxKzT-40google.com&d=DwIBAg&c=s883GpUCOChKOHiocYtGcg&r=4hVFP4-J13xyn-OcN0apTCh8iKZRosf5OJTQePXBMB8&m=0-XNirx6DRihxIvWzzJHJnErbZelq39geArwcitkIRgMl23nTXBs57QP543DuFnw&s=7zXRbLuhXLpsET-zMv7muSajxOFUoktaL97P3huVuhA&e=
> > 
> > Actually, I take that back.  The code snippet itself is also flawed.  If userspace
> > increases the quota (or disables it entirely) between KVM snapshotting the quota
> > and making the request, then there's no need for KVM to exit to userspace.
> > 
> > So I think this can be:
> > 
> > static void kvm_vcpu_is_dirty_quota_exchausted(struct kvm_vcpu *vcpu)
> > {
> > #ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
> > 	u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
> > 
> > 	return dirty_quota && (vcpu->stat.generic.pages_dirtied >= dirty_quota);
> > #else
> > 	return false;
> > #endif
> > }
> > 
> > and the usage becomes:
> > 
> > 		if (kvm_vcpu_is_dirty_quota_exhausted(vcpu))
> > 			kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);
> > 
> > More thoughts in the x86 patch.
> 
> Snapshotting is not a requirement for now anyway. We have plans to lazily
> update the quota, i.e. only when it needs to do more dirtying. This helps us
> prevent overthrottling of the VM due to skewed cases where some vcpus are
> mostly reading and the others are mostly wirting.

I don't see how snapshotting can ever be a sane requirement.  Requiring KVM to
exit if KVM detects an exhausted quota even if userspace changes the quota is
nonsensical as the resulting behavior is 100% non-determinstic unless userspace
is spying on the number of dirty pages.  And if userspace is constly polling the
number of dirty pages, what's the point of the exit?  Requiring KVM to exit in
this case puts extra burden on KVM without any meaningful benefit.

In other words, we need consider about how KVM's behavior impacts KVM's uABI, not
just about what userspace "needs".
