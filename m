Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3D07B297A
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 02:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjI2AYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 20:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjI2AYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 20:24:23 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D4B180
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 17:24:21 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59c0dd156e5so271453877b3.3
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 17:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695947060; x=1696551860; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VK3yYTqUyZzwJjWPYCCiURL3L8OGDHEDjPYeZ/hC2E0=;
        b=mmMNIUSIK9ogmfEqekMJsGEmHumJpq1reG39BeRVF5vPjn0eTx3ucj/LfHsP1mU5DT
         UFQ2XFiH37eJhfzvQnOSrhMBy7DapVdFU2P+MdNnEFZj/+SVeLT3nzA6YksxOFvBSdgX
         5o7oEXIKdyCyIxjgPn4zleFl+j61MuSlTUQvxidpnpgxKxqHgVxHbf0B+Iz5xsPx71F2
         4LWB7urMmXiO2Ke1n4vPBfzy7rmxMSSEonfuX7XY4E4y1C9aKg7PyuBeoPyuPilnY3SR
         xCMZEv9au89TxAWrGYUIvNnTXmlcsqE5XCFHpa0wOvPYNgH14C3hsXd8UGynKT+vHHCk
         uUTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695947060; x=1696551860;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VK3yYTqUyZzwJjWPYCCiURL3L8OGDHEDjPYeZ/hC2E0=;
        b=VAOs7FmWLX2msPKJYqVGI1902zVLrF/zqGsEOi8LyYhSULTLtY+vrZ1ccH8hH28O6o
         2NePUULzO7DszSWSIb0WeoPNfpjXtY7Vb2ukE3S54e8CKG4hwGjpfcpC5ibXJEj+lOBT
         dDjsud6tCtVWDprSvA6L7Zj7tRJG6GH5jEyd1oWQx1bZZFYcE/SSQx/dTbG85EeQDsnI
         /z4N4uh62yVFDY7QKG8Bb7HoSebAguihglIhnSKriwyoZRsbg2uB+VyzRV/kAsovUroE
         kLv0cfUGTDUrhJzsSMp4pACJ/km7xCEdTjZ8O6teOex99ZA3u+sJuYTR1UVYf4FTAG80
         +nIg==
X-Gm-Message-State: AOJu0Yz0cBd1z5PHcREjWNWlkd8wj1KgUo75MADkxRD3eI6OExw3Qqp6
        lsZVsVJY/nJii+kn/qGQHtcfgcVw5sE=
X-Google-Smtp-Source: AGHT+IEOayytUoGF6yiau9EKJIk7fPZSTKse/XCvu4K9plygAETxpWB9IOofC6SPGiHL7SAKxLP/YXrGXcc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:aa48:0:b0:59b:f493:813c with SMTP id
 z8-20020a81aa48000000b0059bf493813cmr44356ywk.9.1695947060234; Thu, 28 Sep
 2023 17:24:20 -0700 (PDT)
Date:   Thu, 28 Sep 2023 17:24:18 -0700
In-Reply-To: <20230928173354.217464-2-mlevitsk@redhat.com>
Mime-Version: 1.0
References: <20230928173354.217464-1-mlevitsk@redhat.com> <20230928173354.217464-2-mlevitsk@redhat.com>
Message-ID: <ZRYZMr4fuaywW7fP@google.com>
Subject: Re: [PATCH v2 1/4] x86: KVM: SVM: always update the x2avic msr interception
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 28, 2023, Maxim Levitsky wrote:
> The following problem exists since x2avic was enabled in the KVM:
> 
> svm_set_x2apic_msr_interception is called to enable the interception of

Nit, svm_set_x2apic_msr_interception().

Definitely not worth another version though.

> the x2apic msrs.
> 
> In particular it is called at the moment the guest resets its apic.
> 
> Assuming that the guest's apic was in x2apic mode, the reset will bring
> it back to the xapic mode.
> 
> The svm_set_x2apic_msr_interception however has an erroneous check for
> '!apic_x2apic_mode()' which prevents it from doing anything in this case.
> 
> As a result of this, all x2apic msrs are left unintercepted, and that
> exposes the bare metal x2apic (if enabled) to the guest.
> Oops.
> 
> Remove the erroneous '!apic_x2apic_mode()' check to fix that.
> 
> This fixes CVE-2023-5090
> 
> Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
> Cc: stable@vger.kernel.org
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
