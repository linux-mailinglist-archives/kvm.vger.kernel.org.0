Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314F86D591B
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 09:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbjDDHDg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 03:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233711AbjDDHDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 03:03:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0140130D5
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 00:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680591760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I3MVmNjjTrzkV62oECuu2nmnGPuxnQPyCsf8ynhsugY=;
        b=QBLjGc9vLCZ6qOGib/Uc/R6S5XNhDVrBEmZ9IXstRJVPHWp9GlqH5uqmuAWy2MYP1b7LS0
        8c9QkQ+mgpkzaIiTuEWD+dD72+/PEbqjA0nQpMG4u8eVC3T1S1+dgIAULXOXj/QwvI+wU0
        3wVrJ9ZITlDjOcjq+6/KBmO3Kd5SUdc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-yl9_pSAMNHem7pf-P7rS7w-1; Tue, 04 Apr 2023 03:02:38 -0400
X-MC-Unique: yl9_pSAMNHem7pf-P7rS7w-1
Received: by mail-qt1-f198.google.com with SMTP id a11-20020ac85b8b000000b003e3979be6abso21321495qta.12
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 00:02:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680591758;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I3MVmNjjTrzkV62oECuu2nmnGPuxnQPyCsf8ynhsugY=;
        b=WvR7PfnuUtIkloVCSZR8/6FUqkoZSJ+TnRK6QsatfgBfQKC2Yj+Mab0XUX5frxKA9R
         LoDHmk/B/XRnAiDHmifdsRz/W5KoHnOPvWnJgLo40HyEjhZd3cN5cYnddoyRziOk2wZt
         FBybV8hdyneDcT3ub/dl3KeZqlXQMXmBP0hiyMvCOVUlwfh6lF4Psw64bJxieFQt5Yp9
         0aJw5XLglCkv1FpcPjrqV0H9e/sk8TtC/042IGqfUMiIJgStaXVqrr6n9IJ2+ChT2dRN
         Znje4wfWzfKRGGL+RPQZv9/AJszbyX+r4VkH9WtN8PvsEcn8JpaJBABMQQVDU7U/OlL0
         NhRw==
X-Gm-Message-State: AAQBX9cvudVQkfoJMzBmd1zn5mUsW97WFh35301Qd8dBpBVdSdgmmY4R
        H3DhMvVAzi3IG36mOYysnxA9xsiRMvXneuabFPOEKMuM4XUSAj88q9iXxCicqk99Qzc3kxH4/8C
        gd8lw+YQzSMkE
X-Received: by 2002:a05:622a:1014:b0:3bd:db4:b967 with SMTP id d20-20020a05622a101400b003bd0db4b967mr1605080qte.58.1680591758436;
        Tue, 04 Apr 2023 00:02:38 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZeBly8guyCmoO5xOctGAQXU6DItAkqiG1Wa+dT9GI6WOjdnqjMxk2CNPmIGaB4Rl1jZDmaUw==
X-Received: by 2002:a05:622a:1014:b0:3bd:db4:b967 with SMTP id d20-20020a05622a101400b003bd0db4b967mr1605062qte.58.1680591758243;
        Tue, 04 Apr 2023 00:02:38 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-178-74.web.vodafone.de. [109.43.178.74])
        by smtp.gmail.com with ESMTPSA id t20-20020ac85314000000b003e3870008c8sm3045284qtn.23.2023.04.04.00.02.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 00:02:36 -0700 (PDT)
Message-ID: <1a2de9e8-3536-17d8-e6b3-7312c7ca7f46@redhat.com>
Date:   Tue, 4 Apr 2023 09:02:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests v3 07/13] powerpc/sprs: Specify SPRs with data
 rather than code
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>
References: <20230327124520.2707537-1-npiggin@gmail.com>
 <20230327124520.2707537-8-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230327124520.2707537-8-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/03/2023 14.45, Nicholas Piggin wrote:
> A significant rework that builds an array of 'struct spr', where each
> element describes an SPR. This makes various metadata about the SPR
> like name and access type easier to carry and use.
> 
> Hypervisor privileged registers are described despite not being used
> at the moment for completeness, but also the code might one day be
> reused for a hypervisor-privileged test.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> 
> This ended up a little over-engineered perhaps, but there are lots of
> SPRs, lots of access types, lots of changes between processor and ISA
> versions, and lots of places they are implemented and used, so lots of
> room for mistakes. There is not a good system in place to easily
> see that userspace, supervisor, etc., switches perform all the right
> SPR context switching so this is a nice test case to have. The sprs test
> quickly caught a few QEMU TCG SPR bugs which really motivated me to
> improve the SPR coverage.
> ---
> Since v2:
> - Merged with "Indirect SPR accessor functions" patch.
> 
>   powerpc/sprs.c | 643 ++++++++++++++++++++++++++++++++++---------------
>   1 file changed, 450 insertions(+), 193 deletions(-)

Acked-by: Thomas Huth <thuth@redhat.com>

