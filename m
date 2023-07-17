Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53AC07566D4
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 16:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjGQOvy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 17 Jul 2023 10:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjGQOvx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 10:51:53 -0400
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC7FB2;
        Mon, 17 Jul 2023 07:51:51 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-4fdb205baccso467102e87.1;
        Mon, 17 Jul 2023 07:51:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689605509; x=1690210309;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/H8FLxUiB8ty750EOYrIxbZjxJNHc3IuF4wVIXDgdSk=;
        b=SeU3pUlzHGY5CcFo3K4M6mK+lmWXt49r5GykGQiLDnZj1BH1BXM6bj0Zzof0BOHLrh
         ziAu2Y6xTvc9mSZGQaN1rZWiFKr2/ZpBB2sl+vkvQzV4Uw3nWOm7lJL/+jjgddn2Xw5l
         siBZqpLjuBGQiRZcEL9BqSJBVvvuGg2P46em/E16FWmlAidAH4cEL0X9Q5Ym0lMZ0bRw
         8ArTWW4+6/9D0xLTxW40Th6xKWFpBgGHufGet0UF4DrMStNI/w7NTeIg8wISts1J4Jcc
         +g1wVHlBU3YI8uwzkV49I7sDao6hEvy3BHB64yBUNoEMq4o8xp3BblGzrL4oIObrlqon
         uxcA==
X-Gm-Message-State: ABy/qLb/yqabe9AVc2jbUa1ovG7p79O5SFNfohufiRYGX/AjQerUMYqe
        nwoqj+mxks+IAYyt2Z23XqW/mmjseAGdy3jKN4rvqz0L
X-Google-Smtp-Source: APBJJlGwpwZ4js2J+hHI/wir5esmGLTQGLY36rgv5SwFpLwtTHt05EiJBe0G1HY1JQLGfBEJ+/wSRjlfI/Uy1/aZhkA=
X-Received: by 2002:a2e:a790:0:b0:2b6:99a7:2fb4 with SMTP id
 c16-20020a2ea790000000b002b699a72fb4mr10021162ljf.0.1689605509418; Mon, 17
 Jul 2023 07:51:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230605154716.840930-1-arjan@linux.intel.com>
 <20230605154716.840930-4-arjan@linux.intel.com> <5c7de6d5-7706-c4a5-7c41-146db1269aff@intel.com>
 <747dca0b-7e79-738a-c622-3e2df61849ca@linux.intel.com>
In-Reply-To: <747dca0b-7e79-738a-c622-3e2df61849ca@linux.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 17 Jul 2023 16:51:33 +0200
Message-ID: <CAJZ5v0h4PGFKB0kOL7-odNxNnSn-RxyGfj7atEcNLVfzep6pXw@mail.gmail.com>
Subject: Re: [PATCH 3/4] intel_idle: Add support for using intel_idle in a VM
 guest using just hlt
To:     Arjan van de Ven <arjan@linux.intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, linux-pm@vger.kernel.org,
        artem.bityutskiy@linux.intel.com, rafael@kernel.org,
        kvm <kvm@vger.kernel.org>, Dan Wu <dan1.wu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 17, 2023 at 4:10 PM Arjan van de Ven <arjan@linux.intel.com> wrote:
>
> > It leads to below MSR access error on SPR.
> yeah I have a fix for this but Peter instead wants to delete the whole thing...
> ... so I'm sort of stuck in two worlds. I'll send the fix today but Rafael will need to
> chose if he wants to revert or not

I thought that you wanted to fix this rather than to revert, but the
latter is entirely fine with me too.

Given the Peter's general objection to the changes, a revert would
likely be more appropriate until the controversy is resolved.
