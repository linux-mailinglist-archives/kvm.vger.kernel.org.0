Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89A27272ED
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 01:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbjFGX1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 19:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbjFGX1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 19:27:00 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF56101
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 16:26:59 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bb2fae9b286so102128276.3
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 16:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686180418; x=1688772418;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hipvymSgC3OX9XscE62QY5GyqZo7Ih960ndTbPccN4E=;
        b=3rk7sXjwFNwdy4CXE+SpgvjG0ai/VWk0FGR1So2AqSnbINfFhC+wOOQtG0xb1LDAgo
         Z0tlUdhEiILjRTQpR+8uHoVLvQIXEAQ2ZEWDLj7etyuKQaWGlT6VYHWbpr6CNPVn1f9j
         zEXy9mH7bRQW18rCOBYILz1awiZXIMn9K1jFwbrpoSoXx8qYqvJN+5zX1PZL8mMwYXMQ
         h7haAV9LNrCoEEJ9vDAefSP2jlx8dHJY7krB4DJA7UmUSGBXVVnxOdUoWdIUcgbKHQaV
         DCPDP5z1GcfKsPVhdizLogNi2g6viWkxLont95HeDG34MX/E0hLN4ZWzWTRqzZ0sFxvj
         1WHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686180418; x=1688772418;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hipvymSgC3OX9XscE62QY5GyqZo7Ih960ndTbPccN4E=;
        b=bhr5ARywiXZOUFzxAyWLvIvKMqmIiTst1NIwSdpuWbqvxTrqEyp3VYiBy+5g/i7Rq2
         BEwBqJol2CvcEhcuScHxP7fnxQMI5NMFYMlCXFuXtTHNtB5hdIYIfbseat83bXwNz3Zm
         ehhyjX3GduPvmHd/NrdcylYTNPSZqweSV80Jfc314xc84toVPxB9ETztUlJnGk3R9o7x
         s3+WLVZWChTZCrpYjODzbaK7UsyrHoTYK/mbcJQjRx0rZnDtzvK/Ios7sqo41/PGsEAb
         d5gGeiuC2ktc54oanKI2Z3LuCo9SQ1DEp8bG39iEVcc441zSlhkUXdvPu6ytBHzYp3re
         T7Iw==
X-Gm-Message-State: AC+VfDzsaE3x2MubKkYyRzszlx+vqjqAPgQPUGwAJ7Y4ZRXSxw64f2kF
        vyzAGy4fodnUcQ6lUBJ4E0Lu7JkcH/s=
X-Google-Smtp-Source: ACHHUZ6MTHjB6Hp5KmA4dZoWVjNkt3pipzfCrA9H5u5vGHlsUSPzIP2IAqUOfwD3QElSLaEiqMdUYuNNVcw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:150e:b0:bac:adb8:a605 with SMTP id
 q14-20020a056902150e00b00bacadb8a605mr2655905ybu.2.1686180418450; Wed, 07 Jun
 2023 16:26:58 -0700 (PDT)
Date:   Wed,  7 Jun 2023 16:25:52 -0700
In-Reply-To: <20221226075412.61167-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20221226075412.61167-1-likexu@tencent.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <168617889079.1602120.263410071839545933.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/2] x86/pmu: Add TSX testcase and fix force_emulation_prefix
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 26 Dec 2022 15:54:10 +0800, Like Xu wrote:
> We have adopted a test-driven development approach for vPMU's features,
> and these two fixes below cover the paths for at least two corner use cases.
> 
> Like Xu (2):
>   x86/pmu: Add Intel Guest Transactional (commited) cycles testcase
>   x86/pmu: Wrap the written counter value with gp_counter_width
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/2] x86/pmu: Add Intel Guest Transactional (commited) cycles testcase
      https://github.com/kvm-x86/kvm-unit-tests/commit/ece17cfebc27
[2/2] x86/pmu: Wrap the written counter value with gp_counter_width
      https://github.com/kvm-x86/linux/commit/15507bb0

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next
