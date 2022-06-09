Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF51154463B
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 10:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242157AbiFIIqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 04:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242902AbiFIIoI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 04:44:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E7FC649261
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 01:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654764155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EUXb3OtLQfesjMR2aTZtn/nYj0py51rPllhsatp6KLg=;
        b=Vx/8PbWuzhXIc55WjwXD4v/zgO8uZQ+ZQ/e8BqHOtxX+hLPEa4jtGqlDG+AXnR0N4BYBhc
        PyOa6TPkHsg2gbDdzpcHDH9XGf6sLFoQhqM2Q3rBYhc4Cn/Ad4N4csRxOI6TGCt+mmujRH
        DDq48vrWXreSXvzZBelzw74tWVSGqfo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-53TI-bCiMjmdUhvhZVMsfg-1; Thu, 09 Jun 2022 04:42:34 -0400
X-MC-Unique: 53TI-bCiMjmdUhvhZVMsfg-1
Received: by mail-wr1-f69.google.com with SMTP id u18-20020adfb212000000b0021855847651so1741629wra.6
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 01:42:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:references:cc:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=EUXb3OtLQfesjMR2aTZtn/nYj0py51rPllhsatp6KLg=;
        b=ixtsq661rk5tNmvWkN7T0kNxXOYK5s8gZR2TcIGkW34yy842AVUSl5xeiSlXhZWW7M
         leGLUjBY1XsuWYW2zDXJfMbyrH+tPJbXjK1HifKNjhGaOsPgBD8DKPLZwMVEoxpM3rSW
         rRiLFpW7IyObulyGArm+42v74RhLa5AZHddgHQ8FmBQc0yq/KtfZSsWLlLH5gxjA1XfU
         SMoiV2tfmksXl5+9Y8VWi1srP2IBser/ydH33Zs/NizZm7ZE4tFVzT94Q6zmL1MtZ0Bq
         hxZ0pELnK0yGV5oWEmdJ/AGuDHZRpiO9NQha5P1rNxSZYxw1vEUIiluv1nS9UYkcjcWO
         dJlw==
X-Gm-Message-State: AOAM532htBLFkFf855RX1kDbsU7Evl6S7rsWtNtPmo7U64FRsV8Jv34j
        LmTez+l0mJ2UT4rJWGc9AFH1eF7bSPuHhM7JBxA+JK8g8nFpJrBCnpU7gmmxlXhSHGjExHNYpCc
        B4IfwMyM0S5Id
X-Received: by 2002:a5d:6a92:0:b0:210:3387:23ec with SMTP id s18-20020a5d6a92000000b00210338723ecmr36882999wru.102.1654764152230;
        Thu, 09 Jun 2022 01:42:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwX9SiYs8CeGshCq+oyK5c43j3U3DoJlGXVyZq/2+VB9rKnOKT+FGzdzTsJffnB4AR11tXK4Q==
X-Received: by 2002:a5d:6a92:0:b0:210:3387:23ec with SMTP id s18-20020a5d6a92000000b00210338723ecmr36882976wru.102.1654764152035;
        Thu, 09 Jun 2022 01:42:32 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-42-115-130.web.vodafone.de. [109.42.115.130])
        by smtp.gmail.com with ESMTPSA id k7-20020a7bc407000000b00397402ae674sm9284836wmi.11.2022.06.09.01.42.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 01:42:31 -0700 (PDT)
Message-ID: <14fd32f1-1eb8-8eb3-972a-c1858ee6fdb7@redhat.com>
Date:   Thu, 9 Jun 2022 10:42:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
References: <20220603004331.1523888-1-seanjc@google.com>
 <87wndr9qef.fsf@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [Sean Christopherson] [PATCH v2 000/144] KVM: selftests: Overhaul
 APIs, purge VCPU_ID
In-Reply-To: <87wndr9qef.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3 Jun 2022 00:41, Sean Christopherson wrote:
> 
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

  Hi,

I just checked your series on s390x, and as far as I can see, the tests 
still work fine with the patches applied. Thus:

Tested-by: Thomas Huth <thuth@redhat.com>

