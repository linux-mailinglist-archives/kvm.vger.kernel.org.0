Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57CE3798821
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 15:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241597AbjIHNvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 09:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjIHNvL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 09:51:11 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE4A1BC6
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 06:51:06 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-52bcb8b199aso2832561a12.3
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 06:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694181065; x=1694785865; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J8pjd1/df+s3RtkGAmFa4NAq964Oj2OD0bhtrmrAYJc=;
        b=bme02ggeJSf2w/VOO9Kd/nvpSXOrlANBhmhJPqqjGcxRQTAK4D0K4bFii/32diQR5s
         ZJlWPoZxGqC/ZtN84ZJsWxJ3JsHOOmPsP6P2u4t9H7uqB0z0vSNBlFqGlLVBpzY21lgy
         OCNTy3l/OtC6FLHhBIj+UMggO0RPuMfwz8cdraux0SSx8/ArWQd2SD7bJSem+uEQGfsz
         GURPIgIZgsR9FmoBu5nU2hwiaNehMdg6JZ6TKxU5Qn4u9TYOMEH09HgO3PWtSVij1n2w
         0sndReYIqXSBQzmRx8oYWqNv+qQBVEMmlwWnVSDub1jcH6hTflLSKCxlWV/AdHaSMSHn
         AL5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694181065; x=1694785865;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J8pjd1/df+s3RtkGAmFa4NAq964Oj2OD0bhtrmrAYJc=;
        b=ogVqsou4fYBqYv+MCK3wAweaENhRN/PwucQsv+h/ZYD25RvALc/Mabx4zWqCSgQ3VR
         PQJ5FwrxSfRbCuerAljLIAgEUidOyq5uZ5AAmzIPhkBE9xVe6r6l1j6Fp1joqdW6pfnZ
         dd+eIIrt8TRTODGDHHAJXQM/rmEdjDo+2y6JlsCokBSRyywq7R+GJmj5mJOcdaXB46hm
         QZi7KGsA0HgJzDses/0jp333g6hsMzqpma8jbQIm4BFsNUqKV8NaxkK3/Omz2scyBSze
         BXRfbRZaSDPZsWAmWYpbqZt6Q18tTFX8dIYMKv7/f22wnCcIUg7FJ6I87yzY4eq/yJnf
         70mA==
X-Gm-Message-State: AOJu0Yw+Gr1iiGZy+crHWjnzDmvyjoiIDcu5CGweCg/oi+bq1PETsuoQ
        TFA1IuQZOoZRLq6mODZxrvQJhvj5bY9ZjhfRmDHZbA==
X-Google-Smtp-Source: AGHT+IEQjj9TQ4wV38n8jiVxEkPB4pqx7hwLWUAIz58yT1lE3WfiLYWREcppqs7fooBw09ZICMN/hMQP3yvRSngT8F8=
X-Received: by 2002:aa7:d90b:0:b0:51b:d567:cfed with SMTP id
 a11-20020aa7d90b000000b0051bd567cfedmr1955373edr.5.1694181065267; Fri, 08 Sep
 2023 06:51:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230905091246.1931-1-shameerali.kolothum.thodi@huawei.com>
In-Reply-To: <20230905091246.1931-1-shameerali.kolothum.thodi@huawei.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 8 Sep 2023 14:50:54 +0100
Message-ID: <CAFEAcA-av-LmRw1f=cU4Mb9r-TS5gfmGBeKdcrsxHMtdJ7-bHQ@mail.gmail.com>
Subject: Re: [PATCH v4] arm/kvm: Enable support for KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, gshan@redhat.com,
        ricarkol@google.com, jonathan.cameron@huawei.com,
        kvm@vger.kernel.org, linuxarm@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 5 Sept 2023 at 10:13, Shameer Kolothum
<shameerali.kolothum.thodi@huawei.com> wrote:
>
> Now that we have Eager Page Split support added for ARM in the kernel,
> enable it in Qemu. This adds,
>  -eager-split-size to -accel sub-options to set the eager page split chunk size.
>  -enable KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE.
>
> The chunk size specifies how many pages to break at a time, using a
> single allocation. Bigger the chunk size, more pages need to be
> allocated ahead of time.
>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
> Changes:
> v3: https://lore.kernel.org/qemu-devel/20230830114818.641-1-shameerali.kolothum.thodi@huawei.com/
>    -Added R-by by Gavin and replaced kvm_arm_eager_split_size_valid()
>     with a direct check.
> v2: https://lore.kernel.org/qemu-devel/20230815092709.1290-1-shameerali.kolothum.thodi@huawei.com/
>    -Addressed commenst from Gavin.
> RFC v1: https://lore.kernel.org/qemu-devel/20230725150002.621-1-shameerali.kolothum.thodi@huawei.com/
>   -Updated qemu-options.hx with description
>   -Addressed review comments from Peter and Gavin(Thanks).



Applied to target-arm.next, thanks.

-- PMM
