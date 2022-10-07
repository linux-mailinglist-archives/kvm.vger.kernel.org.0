Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7465F7DFC
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 21:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiJGTbA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 15:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJGTa6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 15:30:58 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167D918398
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 12:30:58 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id r18so5439359pgr.12
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 12:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=scFP8viWROQtZo8lDVrvZusHv8V/TxMfSv6RxJrmmFk=;
        b=DoaXErIMWhRrtSk8zQRAoKYqIhyenfTavAkOtbhMOFdej1Y3Pi8hsvELJ8BiQrhvu9
         vPu0Hbss4gvzCbKDEQOoyj+Ox3mPv1KEX5Y5kHX4UFz4MtSf1i5F0UwiK19b1P4WCrfl
         1RiAci1PVgDALD1SHyA58u6J4hyvJWAIonBJdsUz0RfE+HlIlZUgJbGXnXeCjXWoWXfZ
         9GBHJnqICZDHtFEv0jOIbRsGdfXMhotKHi12QWmWlypH2kZFgeP1zH48KL9jgmt5Dx57
         ODkp5jxIg09k23oxuECuUyWCVnzwYtU3/U6GA7N1EIQnFszhQVgXqaQ0940BsCVGy/9l
         wHSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=scFP8viWROQtZo8lDVrvZusHv8V/TxMfSv6RxJrmmFk=;
        b=AGciDNNsa0SGHCQqij2/Ac1IPXjmZIoE49SwXBw9xwmwYXK92N6undZop3WR1zPQuC
         NYoQYR9LzWtU6NPCUfSpxss2Q5tGbEk2qFRKUe1ZenoWU4kb1LOdBr6E5E20tMsYd/r3
         pWxRhTscI5/PGdiUz5Y7LADyACqh9ogE1bwntGSns04tQMbKhncn05IIAFlBhBnnn9FC
         E+to7d+pA3rOYbFQqEecz1UuvIVIE11zYBqF9UOjAWX4rYyH5fMEkxXtVnfCGP/ZpjuV
         rslAqF3DIHr2dICZP79PPfBrrTqyYnVS3jY9vourIhK8LqmmGaplVKU6Ym2qfl+h64XX
         RClQ==
X-Gm-Message-State: ACrzQf3PwRhTZqN6r9qEP84+XY2fJmLADQLG4WOTLMq9VwW9FU9rwqGp
        h1Ku63w2GJl8YnNci3bsAjnmcg==
X-Google-Smtp-Source: AMsMyM4BT3HQ8HsEjCLU5ZfP+Gd4ksfkV+f325GFFxQRhK+DRZKlonHQ6xJywaMU9Ad3QeVIt2wQlg==
X-Received: by 2002:a63:f305:0:b0:43f:6af:7553 with SMTP id l5-20020a63f305000000b0043f06af7553mr5913778pgh.570.1665171057463;
        Fri, 07 Oct 2022 12:30:57 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n5-20020aa79845000000b0056149203b60sm2025027pfq.46.2022.10.07.12.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 12:30:56 -0700 (PDT)
Date:   Fri, 7 Oct 2022 19:30:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v6 2/5] KVM: x86: Dirty quota-based throttling of vcpus
Message-ID: <Y0B+bPDrMdJQVX6p@google.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
 <20220915101049.187325-3-shivam.kumar1@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220915101049.187325-3-shivam.kumar1@nutanix.com>
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

On Thu, Sep 15, 2022, Shivam Kumar wrote:
> index c9b49a09e6b5..140a5511ed45 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5749,6 +5749,9 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
>  		 */
>  		if (__xfer_to_guest_mode_work_pending())
>  			return 1;
> +
> +		if (!kvm_vcpu_check_dirty_quota(vcpu))

A dedicated helper is no longer necessary, this can _test_ the event, a la
KVM_REQ_EVENT above:

		if (kvm_test_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu))
			return 1;

> +			return 0;
>  	}
>  
>  	return 1;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 43a6a7efc6ec..8447e70b26f5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10379,6 +10379,15 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  			r = 0;
>  			goto out;
>  		}
> +		if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
> +			struct kvm_run *run = vcpu->run;
> +

> +			run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
> +			run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
> +			run->dirty_quota_exit.quota = vcpu->dirty_quota;

As mentioned in patch 1, the code code snippet I suggested is bad.  With a request,
there's no need to snapshot the quota prior to making the request.  If userspace
changes the quota, then using the new quota is perfectly ok since KVM is still
providing sane data.  If userspace lowers the quota, an exit will still ocurr as
expected.  If userspace disables or increases the quota to the point where no exit
is necessary, then userspace can't expect and exit and won't even be aware that KVM
temporarily detected an exhausted quota.

And all of this belongs in a common KVM helper.  Name isn't pefect, but it aligns
with kvm_check_request().

#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
static inline bool kvm_check_dirty_quota_request(struct kvm_vcpu *vcpu)
{
	struct kvm_run *run = vcpu->run;

	run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
	run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
	run->dirty_quota_exit.quota = READ_ONCE(run->dirty_quota);

	/*
	 * Re-check the quota and exit if and only if the vCPU still exceeds its
	 * quota.  If userspace increases (or disables entirely) the quota, then
	 * no exit is required as KVM is still honoring its ABI, e.g. userspace
	 * won't even be aware that KVM temporarily detected an exhausted quota.
	 */
	return run->dirty_quota_exit.count >= run->dirty_quota_exit.quota; 
}
#endif

And then arch usage is simply something like:

		if (kvm_check_dirty_quota_request(vcpu)) {
			r = 0;
			goto out;
		}
