Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E537B27A6
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 23:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbjI1Vmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 17:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbjI1Vml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 17:42:41 -0400
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5697DF3
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 14:42:40 -0700 (PDT)
Received: by mail-vk1-xa29.google.com with SMTP id 71dfb90a1353d-48feedb90d2so4888999e0c.1
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 14:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695937359; x=1696542159; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FswnOoOXeEsalatJe5X2/JRhGy21U6wG0hXKt3mgVEk=;
        b=u1M/oSQMPa0Wx2UIYIKanfEw5CEuKYBkj8OLl9yQx+RI1VDdxLIpnoR04wz8KfNPWa
         qj+zZARlestuYjJ1ElDYk1PbNFXCf5vZ/zoROJrQaTw68EKcnB9L5dJgIYS2zHb1mgYC
         wmfcKHv5VVePf+vJ8glgNiLO2QwYmwWHBHCQkg3/YpvLDCZH2N7VdkXmfZgf0+5TxEnK
         j6cNhn2fs2ZE2hey7j+1MImmvvS+X3ISEdYbeYQMEBgbCAHRDAnxEYuEi5uP3z4KFEDE
         WrHW+Ppb+n3XNwA9w8ccJkReKVqUV+/6NW1hnZEECX90FeM0txtSLjdeRYUnd8Hyjeek
         6o4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695937359; x=1696542159;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FswnOoOXeEsalatJe5X2/JRhGy21U6wG0hXKt3mgVEk=;
        b=R0GDN6n1OBDO3qVoIM4bwDCU0u8pzBe6YkLZGRRHDvo8M3E4NX1mLq89TAhGonW52Q
         10bk/+j+bX+GDA1b+/9Q3K6Bf+TojxQpobq0J3xe1FBMYb/uhzhMy2zdsbH86RXhtKrc
         4Tx99wDNq+R8sDEQNXRWC9e38n11kCG33jc+AOanA2b98f1oGsFIgApySJ9w5E52iwfK
         TAFS8lTev9zZOVaMeWqDMoHQKnbEG24u7TwDtORUVEtemUy2+/tIYmEsP8BC+NGaCdcZ
         wZPLA4/XY6YP3oiouukooMWiqH9mwQGAQzDWu6nYXBtwn7R1m4Z92dxLzME5h4h/xNbY
         zJHA==
X-Gm-Message-State: AOJu0YyD58tfEgYF4DPCZZR2OEi2Y8n8h0ADsexcze2XnGIfDlX2qwzD
        yMBDk2QKPvfYtcj8cYVIx9d7JlrTjPyvZU6VtBvCkw==
X-Google-Smtp-Source: AGHT+IEgbHvzHg5ZQzfVuJan5OwEQ79HXtsJpgJES78QYXLN3QfZFhxwNpWsNWYVXEpEl0TpdHgTQxr9MlC2w8n4UmU=
X-Received: by 2002:a05:6122:1804:b0:49b:289a:cc3f with SMTP id
 ay4-20020a056122180400b0049b289acc3fmr2269535vkb.3.1695937359233; Thu, 28 Sep
 2023 14:42:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-8-amoorthy@google.com>
In-Reply-To: <20230908222905.1321305-8-amoorthy@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Thu, 28 Sep 2023 14:42:03 -0700
Message-ID: <CAF7b7moh_wAQ6SB8ES9=VWDeKbm_MRX40+zEyiN1xs_0hsRO=g@mail.gmail.com>
Subject: Re: [PATCH v5 07/17] KVM: arm64: Annotate -EFAULT from user_mem_abort()
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +               if (write_fault)
> +                       memory_fault_flags = KVM_MEMORY_FAULT_FLAG_EXEC;
> +               else if (exec_fault)
> +                       memory_fault_flags = KVM_MEMORY_FAULT_FLAG_EXEC;

Ugh I could have sworn I already fixed this, thanks Oliver for bringing it up
