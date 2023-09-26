Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2527AF54A
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 22:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235845AbjIZUft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 16:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjIZUfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 16:35:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A430712A
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 13:35:42 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d7ec535fe42so15128582276.1
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 13:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695760542; x=1696365342; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gBgGdeEWghtFptaMQEsHDDCQhw184YQ6Ycjl2VsrZq4=;
        b=cz1+zUEqYTjIwSG2QhH6JcQinmjzf4670fGZzSNMTpXoeWe2fWgjHXTwauTRYdeFyD
         dsaINeAD0jRZ/U6+m69VESjeFpF17wBkaG9Y91A8YacF1M2P2rEjfqXWwTZDvDMeuMbG
         jfLaXgcyth/27qmZmAyNicCgEtTfOXqBPd7U85HqY4XgsR9p+rSCNpwFjlaXGH7UYFTI
         uIMPsnaz3QMbhJk++7gGzwv0ROlCv+63HhLeeuK3FJEyBLGa/A6mfs/9uST70KgLL+j7
         gP3IVBT5YT97nhZPo9pxiCt0jOJVTb1y/tQ/8EjVuBZyN/CrVa5EvxMQ+Qz4zcLf21z6
         ytag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695760542; x=1696365342;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gBgGdeEWghtFptaMQEsHDDCQhw184YQ6Ycjl2VsrZq4=;
        b=FRTMULk/VHx36NJ6NiGgOhzg6ByUEHf13TJfaiYPXs2rbVCRXZpaO5LfYkY02uhnkx
         YEvWRIojOjdI/O6GAqu6e26+/sm1iXm6TlQecjooBbPlz+0/5Nz8neciJhjQDlNGi8hJ
         GzMgEprebNxtbi5fpr2bW0aDna59Q3LLgXnuGL8VfUbJiob7DpxnZAMjUVqi5KT31Y0b
         7A9gDzFeI5P18Uiiw5fV8dld8MHHDRvttnfZPynXfPwIG7uP/9aSecM2/WOgQOFZ+T8I
         JX50wFj3S4G3XuaGZyUJrKBojnWNUJsL5WPf14cOPY0ZM4MyrJkcgZPTBG7To9xgk804
         +t1g==
X-Gm-Message-State: AOJu0YyE50BmbAD10/KNKPe1Y/0m0sNy1cdTxQ8zEogVr/wExXdkZXvD
        dtnkufARzJ68N+VeOdcWOsa5Sv7nC9v5MOtX7g==
X-Google-Smtp-Source: AGHT+IGjI2QiYKNg5G+Jh+AzDxStZmGOTFezLlj2LgEDS7lrar4VAi7pc9DGlMxlvU+hONN81Pn1xc/3gcuU7CDJuw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:4c8:b0:d85:ae1e:f696 with
 SMTP id v8-20020a05690204c800b00d85ae1ef696mr309ybs.0.1695760541740; Tue, 26
 Sep 2023 13:35:41 -0700 (PDT)
Date:   Tue, 26 Sep 2023 20:35:40 +0000
In-Reply-To: <9bf8d239-2851-087b-9608-0c776b721ed7@huawei.com> (message from
 Zenghui Yu on Mon, 18 Sep 2023 19:16:21 +0800)
Mime-Version: 1.0
Message-ID: <gsntwmwc3c6b.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH] KVM: arm64: selftests: Add arch_timer_edge_cases selftest
From:   Colton Lewis <coltonlewis@google.com>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
        james.morse@arm.com, suzuki.poulose@arm.com, ricarkol@google.com,
        kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Zenghui Yu <yuzenghui@huawei.com> writes:

> Hi Colton,

> On 2023/9/16 0:04, Colton Lewis wrote:
>> It's been a few months with no comment on this. Can someone please
>> review? There was no need to rebase from the original patch. It's all
>> new code so there are no conflicts.

>> I understand it's a bigger patch, but I believe it all falls under the
>> same functional umbrella.

> Thanks for your efforts. I'd like to give it a go but this patch fails
> to compile on the mainline kernel.

> In file included from include/aarch64/delay.h:9,
>                   from lib/aarch64/gic_v3.c:10:
> include/aarch64/arch_timer.h: In function 'timer_get_tval':
> include/aarch64/arch_timer.h:107:3: warning: implicit declaration of
> function 'GUEST_ASSERT_1'; did you mean 'GUEST_ASSERT_NE'?
> [-Wimplicit-function-declaration]
>    107 |   GUEST_ASSERT_1(0, timer);
>        |   ^~~~~~~~~~~~~~
>        |   GUEST_ASSERT_NE

> ... and something like that. It'd be good if you could have a look.

Sorry about that. I'll make those updates right away and rerun the
testing I did when I originally sent the patch.
