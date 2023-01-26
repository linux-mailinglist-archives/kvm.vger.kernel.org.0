Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D4467D3A8
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 18:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjAZR6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 12:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjAZR6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 12:58:49 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFE5298F1
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 09:58:48 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id n8-20020a6bf608000000b007048850aa92so1338794ioh.10
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 09:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CgaKsn4RVDEpOSgH5DEyhW7gCnTkwkj12anY5asYwFI=;
        b=oGrb1HAK712prNTP3ppxVnPYlP6Jc1GgZn1dOpV/o+3BxE2aXM+yIV6WToSuOjIwTI
         0CKfrw4gF56hs0ebwS70rtOVmhZCLhqW9m5cU4+k6GDtJwsYD3KqPIBJuZpobYSh2VZS
         ErP7zT+/adoh4/ZimdaRx+v4GhaPqB7AVO28geTv0t8TaNTOcDOvtr9/lmAeDIKhhinn
         KFdAx/mEx76leNvZOh4LodPb474gSP3puRcP/AYOCqh3VpEaEUmB3ZaYNiezZph60xXY
         9S03Zg+O2VmmbVeWaRHRYxx+U5wmQKVISCH3P0MLBAkksqyc/oqla9rTiGOgwwi8PQjm
         RkvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CgaKsn4RVDEpOSgH5DEyhW7gCnTkwkj12anY5asYwFI=;
        b=E9rCcyqFIOQ8EmvYhrjsKKzfhjHDb6BxB6TSnyOSbOnWki9LM+WlgXwZU2s52JyN+3
         czfGnREhMjfInuBRHfskIQf4N9PhhalYb5/gyFIiH8IQvVSqzWbsGbNSnqXd4387gJ1P
         XJe8K1hwCCnESjKYRJmh4LVIhBlLBykzq4dzxIo6y3STczKGL5bI21QP4uNXQfjME8kh
         O4ocJ/ccdRg/WP08QHKLstb7qns6NsBG/sXZOhRWBf4HZjAXsemEHUpJbp9ROBzFiHmm
         2v8e8ImU63qBky1T0QMnWBx7g8gzsBXQyFxxD36dyx4n6U0Z5zJbpcDVgslswYriqnJk
         GaLA==
X-Gm-Message-State: AFqh2kq5ZW+9fFXiwEA1WeCHMgNgg5ZIsX4qu7ZM0ObGi5Hb9AvFIMVn
        zuF/vKzZM1uv6ewbLLUBZMuB3eVSecBl34JNzw==
X-Google-Smtp-Source: AMrXdXvk73bqraIyQhpcOXTzCzCx+/SXJVRdmCIQq30SpDFNMjnCLmC1Tc8l7nEiOQcFPuadBBegEYWtQEyWltoNUQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a5d:89c6:0:b0:704:bdfe:db72 with SMTP
 id a6-20020a5d89c6000000b00704bdfedb72mr3257020iot.85.1674755928223; Thu, 26
 Jan 2023 09:58:48 -0800 (PST)
Date:   Thu, 26 Jan 2023 17:58:47 +0000
In-Reply-To: <Y8cIdxp5k8HivVAe@google.com> (message from Ricardo Koller on
 Tue, 17 Jan 2023 12:43:35 -0800)
Mime-Version: 1.0
Message-ID: <gsntfsbxqiso.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 2/3] KVM: selftests: Collect memory access latency samples
From:   Colton Lewis <coltonlewis@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, seanjc@google.com, bgardon@google.com,
        oupton@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ricardo Koller <ricarkol@google.com> writes:


> nit: reservoir


Will fix


> Didn't see this before my previous comment. But, I guess it still
> applies: isn't it possible to know the number of events to store?  to
> avoid the "100" obtained via trial and error.


That's what I thought I was calculating with sample_pages =
sizeof(latency_samples) / pta->guest_page_size. Both values are in bytes
so that should give the number of guest pages I need to allocate to hold
latency_samples. The 100 is a fudge factor added to the calculation
after encountering crashes. Any idea why the math above is incorrect?


> reservoir


Will fix.
