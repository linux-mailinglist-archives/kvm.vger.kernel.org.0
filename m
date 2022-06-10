Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39FC9546CC8
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 20:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350190AbiFJSzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 14:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344236AbiFJSzo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 14:55:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9C1E1CAD31
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 11:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654887342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xo+DiF3X53FfIv1ZxPHXs0464GqQecVa9I/ZUWP1FOo=;
        b=FSWjTc8VjRqaV+fPVrhlKv+ue/4BS9EwmterQU5B7aqXGnfos+P4e6HVIx/mZq7a33+56u
        o8/Yxg8sENCSiwJOqPN82+mM2Iy0I9rW489xfufU35Cksrph1f3rkOQ4YU+al1tQDiY40L
        uErpd5APQ+AUw9dSLQo+aTOahzn3/Rw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-fDyF4jPPNDa3GygtWzr4kA-1; Fri, 10 Jun 2022 14:55:41 -0400
X-MC-Unique: fDyF4jPPNDa3GygtWzr4kA-1
Received: by mail-wm1-f72.google.com with SMTP id o3-20020a05600c510300b0039743540ac7so9974774wms.5
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 11:55:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xo+DiF3X53FfIv1ZxPHXs0464GqQecVa9I/ZUWP1FOo=;
        b=1BOKjJA/jzMRYHeY5bLqWTkeAxGQ5YpfeUxIU+JJSt8HrT8xPRSVUSXc0DdI5NOpR2
         NKdD61Z32caqGEA2HWK/XTagbqXeECtm1Rh10xInJv5Jd5lAlRJilxsRzzBOGM9fVSxp
         AJaBJPypgGS5w6gwAPtaaGuFU55coXkOkLb7acGVb7se25myw6mieelqXwSCwdBFmiF3
         V3o35sfLMLkubr0Qf1c/Mb1IyUcE4K2bLWiN0OPDP3n+TDuwqflbt7e+wh77e2Rvmi9R
         EkgwxHPFBHDO1YAVrbTF7yzbwTzX2KjZAFxcmyB9IfRPN8tzB9lsv+91U35Xwq9ifo0Y
         dK2A==
X-Gm-Message-State: AOAM5306f99aTnGVfDNMHlaeARPCDZ4/vrZTGRGzGEpK+616OezJd+0B
        3TS5iev70OGlwHdNngRaFc9s6ai/N51DXOHD02c+xd3Q5WW2FKgeN2E1AJQv4FKlMmWfjpsoLE5
        zE+tS0q4HNqrT
X-Received: by 2002:adf:f902:0:b0:20e:66db:b9d2 with SMTP id b2-20020adff902000000b0020e66dbb9d2mr46557939wrr.682.1654887340520;
        Fri, 10 Jun 2022 11:55:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmReUAzKV7E5P58fAT7mFP57LZDJ7OJfJiMbxiqwsMcpprtD5WdQ+3Lch/8dCfFc6pygkU6A==
X-Received: by 2002:adf:f902:0:b0:20e:66db:b9d2 with SMTP id b2-20020adff902000000b0020e66dbb9d2mr46557921wrr.682.1654887340268;
        Fri, 10 Jun 2022 11:55:40 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id j7-20020a05600c190700b0039c4ba160absm11194736wmq.2.2022.06.10.11.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 11:55:39 -0700 (PDT)
Date:   Fri, 10 Jun 2022 20:55:37 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 000/144] KVM: selftests: Overhaul APIs, purge VCPU_ID
Message-ID: <20220610185537.ivbcwyzlwzbv6zig@gator>
References: <20220603004331.1523888-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 03, 2022 at 12:41:07AM +0000, Sean Christopherson wrote:
> Overhaul KVM's selftest APIs to get selftests to a state where adding new
> features and writing tests is less painful/disgusting.
> 
> Patches 1 fixes a goof in kvm/queue and should be squashed.
> 
> I would really, really, really like to get this queued up sooner than
> later, or maybe just thrown into a separate selftests-specific branch that
> folks can develop against.  Rebasing is tedious, frustrating, and time
> consuming.  And spoiler alert, there's another 42 x86-centric patches
> inbound that builds on this series to clean up CPUID related crud...
> 
> The primary theme is to stop treating tests like second class citizens.
> Stop hiding vcpu, kvm_vm, etc...  There's no sensitive data/constructs, and
> the encapsulation has led to really, really bad and difficult to maintain
> code.  E.g. having to pass around the VM just to call a vCPU ioctl(),
> arbitrary non-zero vCPU IDs, tests having to care about the vCPU ID in the
> first place, etc...
> 
> The other theme in the rework is to deduplicate code and try to set us
> up for success in the future.  E.g. provide macros/helpers instead of
> spamming CTRL-C => CTRL-V (see the -1k LoC), structure the VM creation
> APIs to build on one another, etc...
> 
> The absurd patch count (as opposed to just ridiculous) is due to converting
> each test away from using hardcoded vCPU IDs in a separate patch.  The vast
> majority of those patches probably aren't worth reviewing in depth, the
> changes are mostly mechanical in nature.
> 
> However, _running_ non-x86 tests (or tests that have unique non-x86
> behavior) would be extremely valuable.  All patches have been compile tested
> on x86, arm, risc-v, and s390, but I've only run the tests on x86.  Based on
> my track record for the x86+common tests, I will be very, very surprised if
> I didn't break any of the non-x86 tests, e.g. pthread_create()'s 'void *'
> param tripped me up multiple times.
> 
> I have not run x86's amx_test due to lack of hardware.  I also haven't run
> sev_migration; something is wonky in either the upstream support for INIT_EX
> or in our test machines and I can't get SEV to initialize.
> 
> v2:
>   - Drop the forced -Werror patch. [Vitaly]
>   - Add TEST_REQUIRE to reduce KSFT_SKIP boilerplate.
>   - Rebase to kvm/queue, commit 55371f1d0c01.
>   - Clean up even more bad copy+paste code (x86 was hiding a lot of crud).
>   - Assert that the input to an ioctl() is (likely) the correct struct.
> 
> v1: https://lore.kernel.org/all/20220504224914.1654036-1-seanjc@google.com
>

Hi Sean,

I've completed a thorough skim / review and it looks great to me. Besides
the final patch where I'm wondering about the loss of the type checking
on our ioctl wrappers, I don't think there are any patches where I
wouldn't be happy to add an r-b. So, for the series, except the last patch

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

