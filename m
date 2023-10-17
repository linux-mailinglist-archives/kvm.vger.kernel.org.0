Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1557CC365
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 14:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbjJQMl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 08:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234896AbjJQMQ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 08:16:29 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CDA6A40
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 05:15:30 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-53ebf429b4fso3868368a12.1
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 05:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697544929; x=1698149729; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RYJFy+a6sx3s6+zSIv8CY0p4W3xeTRNrNo9sBoS0Q1I=;
        b=kb81ADSXPes80XxomdZXxsQH2vgipSj96hSt60qQD7o6/hMPAlkqbRu5Ic/b4EM0Y4
         XILFJ/NG4Zi/aLjeGRXv0UbY2CCzM5qnzrpG1QOt9ONPqEoBo1jAtpbWTcAUlmsCL5rv
         9ByqjFdbGQoMyHfXA//IessedT3Khr5uU2Nr6tWFwIEij9P8Ez5W4vV5D0jPCCh8xnL1
         sS/LZTQaf1SA/Z4Ve75cSXqJkUyUY1Q8CmLxMOGhZYfmcz1MvZX9OF00NjXlb/rnRfWx
         aj/uJodT2v1joSpR12FFLgcQSIaq+vQryqiY7XSTpsyNDzf80rL/cY0Xt/pLNvdtQxiQ
         gsAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697544929; x=1698149729;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RYJFy+a6sx3s6+zSIv8CY0p4W3xeTRNrNo9sBoS0Q1I=;
        b=Y4g9M9tllTsOVDuQN4IVsf/+bxHXOWNLVuovJ8iPu9VhATCMLWwvcf7H/MJFPb8wmj
         m2FO/oydcKEE0ktx8WjC27Xxeoqr5/3ocdp4L4WCDKME6LRH1N78WeHsBQjbC4zE7LFr
         1nBawtzBR8RhKKTK0794BJTq5Xmyj/NfB0lxyXL3s0Prfv1FssQqKBuozn6RkJzTIWBo
         Nnob9z0uCNXMFsEye+PbBZ/gnvkGcvlF034wFgpeDbCBAkjofji2CKIxFW0gDi9/77Lx
         0QDGhMgL/WxUxBFV5B/XY4Yc7DEKBJZyexiqbMgA7mQCk1iubiQXVo/QyNPhV9lEAetb
         DPGA==
X-Gm-Message-State: AOJu0Yxtb04ycfdmkpA8Bgg98IeMK3GzY8TqfLFutNUvP28who1OnwKS
        UmBgTFWQacpwSVfA2w2UyFjvKTt8ELliKYZHMoCG0LJ6C1sIKok6
X-Google-Smtp-Source: AGHT+IFrFohaoeVJXzgdVCjVBnTyftrl6MTwgfE6/9BPXMAOGWvWK/OPob4dQh7LMdjndQIllX2J8m/t7bZwQ2wlpJk=
X-Received: by 2002:a50:cc9c:0:b0:53d:f180:3cc5 with SMTP id
 q28-20020a50cc9c000000b0053df1803cc5mr1744853edi.20.1697544928848; Tue, 17
 Oct 2023 05:15:28 -0700 (PDT)
MIME-Version: 1.0
References: <20231010142453.224369-1-cohuck@redhat.com>
In-Reply-To: <20231010142453.224369-1-cohuck@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 17 Oct 2023 13:15:17 +0100
Message-ID: <CAFEAcA9cLZ-Q5-oPqSgt2GdR=J4yGo6BD4nWoeNnwj-ZXfBHaw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] arm/kvm: use kvm_{get,set}_one_reg
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Gavin Shan <gshan@redhat.com>,
        qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 Oct 2023 at 15:25, Cornelia Huck <cohuck@redhat.com> wrote:
>
> I sent this cleanup first... in mid-July (ugh). But better late than never, I guess.
>
> From v1:
> - fix buglets (thanks Gavin)
> - add patch 3 on top
>
> The kvm_{get,set}_one_reg functions have been around for a very long
> time, and using them instead of open-coding the ioctl invocations
> saves lines of code, and gives us a tracepoint as well. They cannot
> be used by invocations of the ioctl not acting on a CPUState, but
> that still leaves a lot of conversions in the target/arm code.

I've applied patches 1 and 2 to target-arm.next.

thanks
-- PMM
