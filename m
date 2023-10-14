Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0DF7C91D2
	for <lists+kvm@lfdr.de>; Sat, 14 Oct 2023 02:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbjJNAb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 20:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjJNAb5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 20:31:57 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15F091
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 17:31:55 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a813755ef4so28483597b3.2
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 17:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697243515; x=1697848315; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wup1ljyUWeQFKZrcp5IVFWzCnbDe777WHGk4V9tmRQM=;
        b=oKTjSwI5pykMkJKbV5u4ng9pBbEfMVBFAUt+zxT594mUo/2tv/vwQetvtN6vWE59q9
         phwz6YtUBCyySRCDhy+SxzEWfBrF1GHRmWB90bw9MVG8oigSL/FkURAp+obG7kgeaySD
         BPKeqXRyUXQ9UrGG0HPLgRvVdQUD64C38azgR1dSC73/c9qGymfrABOVov9XsBlPA0wi
         AaVDiTrt7nLSxWI9FuvLSsxCDeFDlrblgB768BUeC/78LrDH3Q7W1vEAw0Pk+vMt1epl
         AyH0gjozHqzDNWFTsPYmpTqDFy+awFxp4/44bZh8W4cgUIyYDY1b3AE+Ac2FOHVbMqln
         g8Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697243515; x=1697848315;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wup1ljyUWeQFKZrcp5IVFWzCnbDe777WHGk4V9tmRQM=;
        b=bYBtua2OIGuL7/Kdep4O64fgwjg32j9U/JMkXwtJR3ACShxo/dQBubnuPApWK3NJMn
         l4ff1yKNd0/Aeltsiwr6CRj7UI/0avOHvjGOlsZu58V49iOpdkr1tTMYuNtoW5saIM8Y
         N8v7Ln6Un7Tq/sEMG0cwWnyQWN3OY1zXdXHvL5jh7D1LPi8SYmQjw8HdTy6T3D1e4HtZ
         fCHEfEFrQoVNEgVKbuSgAQnuCoSVK63rSAOwkoaSKDF16I3hRgEYEklw81v4ot/rIP5a
         oWk6w0piEYnO/EmUCrE2A/SpDjy8cQR+g++nS76q5t8ddxoaitxwhYbRmw8wIgLLon2C
         1P0g==
X-Gm-Message-State: AOJu0YzNxfri23GETBAuBY9HbMHeNEXeQJJUmyiEABGuTXcJQCJQgqGz
        6z7q7OoTYs8IpvN4c7npqemri3iGEJk=
X-Google-Smtp-Source: AGHT+IHQQYB+851NvjeGmGuKbGvRshCOqjfyFaYJj9UwpSg0M1KsN+HerqjxrMu5GRxGP5xT5pAfjDRedWg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:212:b0:d89:b072:d06f with SMTP id
 j18-20020a056902021200b00d89b072d06fmr531497ybs.7.1697243514939; Fri, 13 Oct
 2023 17:31:54 -0700 (PDT)
Date:   Fri, 13 Oct 2023 17:31:53 -0700
In-Reply-To: <20231010200220.897953-7-john.allen@amd.com>
Mime-Version: 1.0
References: <20231010200220.897953-1-john.allen@amd.com> <20231010200220.897953-7-john.allen@amd.com>
Message-ID: <ZSnheYDyzhZ1DOW5@google.com>
Subject: Re: [PATCH 6/9] KVM: SVM: Add MSR_IA32_XSS to the GHCB for hypervisor kernel
From:   Sean Christopherson <seanjc@google.com>
To:     John Allen <john.allen@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, x86@kernel.org,
        thomas.lendacky@amd.com, bp@alien8.de
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023, John Allen wrote:
> When a guest issues a cpuid instruction for Fn0000000D_x0B
> (CetUserOffset), KVM will intercept and need to access the guest
> MSR_IA32_XSS value. For SEV-ES, this is encrypted and needs to be
> included in the GHCB to be visible to the hypervisor.
> 
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
> @@ -3032,6 +3037,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>  		if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP))
>  			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
>  	}
> +
> +	if (kvm_caps.supported_xss)
> +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 1, 1);

This creates a giant gaping virtualization hole for the guest to walk through.
Want to hide shadow stacks from the guest because hardware is broken?  Too bad,
the guest can still set any and all XFeature bits it wants!  I realize "KVM"
already creates such a hole by disabling interception of XSETBV, but that doesn't
make it right.  In quotes because it's not like KVM has a choice for SEV-ES guests.

This is another example of SEV-SNP and beyond clearly being designed to work with
a paravisor, SVM_VMGEXIT_AP_CREATE being the other big one that comes to mind.

KVM should at least block CET by killing the VM if the guest illegally sets
CR4.CET.  Ugh, and is that even possible with SVM_VMGEXIT_AP_CREATE?  The guest
can shove in whatever CR4 it wants, so long as it the value is supported by
hardware.

At what point do we bite the bullet and require a paravisor?  Because the more I
see of SNP, the more I'm convinced that it's not entirely safe to run untrusted
guest code at VMPL0.
