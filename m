Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07EF26F490F
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 19:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbjEBRSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 13:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234409AbjEBRSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 13:18:25 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97794171C
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 10:18:17 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f19a80a330so25442145e9.2
        for <kvm@vger.kernel.org>; Tue, 02 May 2023 10:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683047897; x=1685639897;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UC4a8f6Gne9pM4hFXpNmDoLhQCLeKV3rAUXB78ueUnI=;
        b=uiELwNIBB9aR1aczpkjeXKkVoU2sLftqcWZlOdh5bi3PsoclPZ+ARRrJEbVKVVYuBh
         JCs47I70fqOk3pqKhSLL2RDkCD5933AHaLa6R0r/E0Bgn3mq8YuUVdX08CXNf7Vk6H8T
         WyIprujAXbYHjFtDDUV8Z7bQQ+xRB67Y+3/f7T1LDvghhbovyzufVkCyYzCEfywzCBU7
         TfP2WIioZQjlDyzk1ry9mc+IldDP5CH0OCMzdKR4ndbdzmbc0kKK+Ie/FzO3W1VfJSkO
         TKHMkrY7B769c1/QGNBIYe71toXQSQHCzEGsqLISVargDPsmEFfpI6qSKf4jO2YP4uLF
         RyDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683047897; x=1685639897;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UC4a8f6Gne9pM4hFXpNmDoLhQCLeKV3rAUXB78ueUnI=;
        b=GjqfgTzWTzcop9GYtyd/Jbj2ydmnQ57DeThBQC8DjPM+mifpvUhQbf0CLqrSoipPko
         8LgAy5gU2vTy5oe0Zibju/MNZ75Xi1Rcfuf5XkH89YpJ57fHFr33j5aMSrbbJH20WmOV
         YoonIbAJMxMcr+cthtRz3ucEr2Od2mqDH4TwIuOH71dJCLece7Uzf+RatTDUYL0NWd2d
         IMbTX4Dia6rTfSoAayFSS3Hw0IBaJwZYfrpqawg+51ftUIqHk0OBnxD0BeAYGsCYkrjc
         tRnG1/DoD4g5x8oMXZVlQg20drDOgU4ow5ZQ5dMWBT6Op+aJJY82fzyn3MBRBoEhZBfp
         KLNg==
X-Gm-Message-State: AC+VfDxiGDJyztHU3xXgWGLpeXgubZz4Z2o9r+3Xv61zmcUwqUv67PVL
        aGnIFjh0p2Qyzo2bxjJadbhi9bm1caA8dDOgbikY2g==
X-Google-Smtp-Source: ACHHUZ6iyEsL7ZSIW0wVeXdbh79sKok0v4A3gQDG0iCZ6EAs2k7GXApQ4djHsSyVEvFt9ZPZRbTQYFvosV1Su6fKRME=
X-Received: by 2002:a1c:f203:0:b0:3f1:72dc:8bae with SMTP id
 s3-20020a1cf203000000b003f172dc8baemr12412266wmc.21.1683047897016; Tue, 02
 May 2023 10:18:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-5-amoorthy@google.com>
In-Reply-To: <20230412213510.1220557-5-amoorthy@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Tue, 2 May 2023 10:17:40 -0700
Message-ID: <CAF7b7mqq3UMeO3M-Fy8SqyL=mjxY4-TyA_PjgGsdVWZrsU2LLQ@mail.gmail.com>
Subject: Re: [PATCH v3 04/22] KVM: x86: Set vCPU exit reason to
 KVM_EXIT_UNKNOWN at the start of KVM_RUN
To:     pbonzini@redhat.com, maz@kernel.org
Cc:     oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During some testing yesterday I realized that this patch actually
breaks the self test, causing an error which the later self test
changes cover up.

Running "./demand_paging_test -b 512M -u MINOR -s shmem -v 1" from
kvm/next (b3c98052d469) with just this patch applies gives the
following output

> # ./demand_paging_test -b 512M -u MINOR -s shmem -v 1
> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> guest physical test memory: [0x7fcdfffe000, 0x7fcffffe000)
> Finished creating vCPUs and starting uffd threads
> Started all vCPUs
> ==== Test Assertion Failure ====
>  demand_paging_test.c:50: false
>  pid=13293 tid=13297 errno=4 - Interrupted system call
>  // Some stack trace stuff
>  Invalid guest sync status: exit_reason=UNKNOWN, ucall=0

The problem is the get_ucall() part of the following block in the self
test's vcpu_worker()

> ret = _vcpu_run(vcpu);
> TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
> if (get_ucall(vcpu, NULL) != UCALL_SYNC) {
>    TEST_ASSERT(false,
>                               "Invalid guest sync status: exit_reason=%s\n",
>                               exit_reason_str(run->exit_reason));
> }

I took a look and, while get_ucall() does depend on the value of
exit_reason, the error's root cause isn't clear to me yet.

Moving the "exit_reason = kvm_exit_unknown" line to later in the
function, right above the vcpu_run() call "fixes" the problem. I've
done that for now and will bisect later to investigate: if anyone
has any clues please let me know.
