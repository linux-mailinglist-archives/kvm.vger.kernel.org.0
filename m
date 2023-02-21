Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D12169EB6B
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 00:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjBUXsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 18:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBUXsL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 18:48:11 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EC52CFE7
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 15:48:10 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id s6-20020a17090aba0600b00230ffd3f340so1940579pjr.9
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 15:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FKHD9w++1iVuhYfxOVDdBLMieuZyIFNT3mgyhpxbqns=;
        b=eBWPBv6zqC9S2TCZnzVrk11Yv20vGyoBsftd/TdFT9xQz9TCKkEhyYTNdC5hGDiIRl
         x/ps5KCZGw2t/IpJUNzX20oLCzAl+VhklaukJ3mpCJ4Gy4UigIvRvVOHkC8NeDYZkuoB
         A4QFwGb8ST/c7XHvK1B+f/uD/sL2ed5pwdBcdEzdeO/zDUYjPa6Y5XfMQ4Nz6flK8+2m
         1DlOP/3XQmiWa5iTCz/STHK6cw5nCtFFPE2o6jpE/+6MjrokOlhMczLtzX5MejBZgJaS
         y4tgH9IKchOut5aWTcuN064t2h719PSLJWWorIAlpk3nqNb1Ifd9wmDJXJgltba/rinp
         uwXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FKHD9w++1iVuhYfxOVDdBLMieuZyIFNT3mgyhpxbqns=;
        b=OODGKQ8ljK+IVLGYyN0mnbFZpTxUeIKhLC7HgohrhESfMlXKhRP+h8duHaciLegjZb
         DyAE6Px8DzeNA7QQZKXbsB19inc/qgE3OkGac/9CJ2GFm+7vd7osvEqU6Ze0juv31Wma
         Xued6Xgb4F1WVi2BqpLr2rXRTQa78yPfJ9s3l+0MMuJuzvIwVrRl9mrkWuu7ENiweaYp
         w3G31+tT2kRbLM9X7casKYZqTVIoJsSNFV35YCD1+HMCxjm1ce+jJzb6RNPkxKJtV9Wd
         +Mu7HK9wKF3OlNCe5qRnxXgJjv2dtIIBlBgeiBs8xkmfVqv0oOlusBYgt7rIf/GV7KOG
         lW/A==
X-Gm-Message-State: AO0yUKVcDrg6QKtGKG20SGx+SQHEHT1rnveI+9bVBvMl96BcW57ONSYM
        Wky98sK5yJcWrV+lNYlXdDcK+NCBqlU=
X-Google-Smtp-Source: AK7set+Cg0iykTqbfRncgiPhCcdsCPs/7JbfUaYzo7NtkH6FClxH7qxvXKcmusQ5+xB2xqxXf6EccZPU8h4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:334d:0:b0:4fb:ba81:7143 with SMTP id
 z74-20020a63334d000000b004fbba817143mr857806pgz.0.1677023289391; Tue, 21 Feb
 2023 15:48:09 -0800 (PST)
Date:   Tue, 21 Feb 2023 15:48:07 -0800
In-Reply-To: <20230221153306.qubx7tfmasnvodeu@linux.intel.com>
Mime-Version: 1.0
References: <20230217231022.816138-1-seanjc@google.com> <20230217231022.816138-9-seanjc@google.com>
 <20230221152349.ulcjtbnvziair7ff@linux.intel.com> <20230221153306.qubx7tfmasnvodeu@linux.intel.com>
Message-ID: <Y/VYN3n/lHePiDxM@google.com>
Subject: Re: [PATCH 08/12] KVM: nSVM: Use KVM-governed feature framework to
 track "vVM{SAVE,LOAD} enabled"
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 21, 2023, Yu Zhang wrote:
> > Sorry, why guest_cpuid_is_intel(vcpu)? Is it becasue that a AMD host with virtual
> > VMSAVE/VMLOAD capability will always expose this feature for all AMD guests? 
> 
> Oh, sorry. I missed the guest_cpuid_has() in kvm_governed_feature_check_and_set().
> So please just ignore my 2nd question.
> 
> As to the check of guest_cpuid_is_intel(), is it necessary?

Yes?  The comment in init_vmcb_after_set_cpuid() says:

		/*
		 * We must intercept SYSENTER_EIP and SYSENTER_ESP
		 * accesses because the processor only stores 32 bits.
		 * For the same reason we cannot use virtual VMLOAD/VMSAVE.
		 */

but I'm struggling to connect the dots to SYSENTER.  I suspect the comment is
misleading and has nothing to do 32-bit vs. 64-bit (or I'm reading it wrong) and
should be something like:

	/*
	 * Disable virtual VMLOAD/VMSAVE and intercept VMLOAD/VMSAVE if the
	 * guest CPU is Intel in order to inject #UD.
	 */

In other words, a non-SVM guest shouldn't be allowed to execute VMLOAD/VMSAVE.
