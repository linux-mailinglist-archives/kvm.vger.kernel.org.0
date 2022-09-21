Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4175BF1B2
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 02:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbiIUAHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 20:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiIUAHA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 20:07:00 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010C26113E
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:06:58 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id d64so2950341oia.9
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=aDXDJv0PiVlu2MaphcSlhIa7kj9qTqu4WRX6MdDaSeI=;
        b=KI5Kor4XJ+E6V6jTH2yVn0FBhhj9xD7UIuGPlj5DmwLy1eccLl9b8sCVT6VpX3mGw8
         RgkE1+ewqG4ckA4Zflm6wZrkpfD8CKMusVSybyOGIgsL+Gvaucy78npVfSKuDgYq//vy
         6GNV1E8GKsO/8JEh7ISaeg62IAbXYnjgj2ehBQEwMbA0CpWZ6zcoDyKekrXCpliuBzDZ
         6ohpmrrg9wYWSy8fhTUQB2DcZo4kdSsbno4676XZNkwpfoAi1AGsCbvSWn2FBbYRZQ1w
         XrSl5AxtBD3/V2BqctirSb7qCP1b0KY0NKJvp9emA9KDWXx50fLApNM5yaxAVDTnLCg9
         bjiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=aDXDJv0PiVlu2MaphcSlhIa7kj9qTqu4WRX6MdDaSeI=;
        b=ZR+DSwuPmeB9rE2AjiwKHBKJHpJiLIPrZxqJ/R4jQCibAWMcQivabB7C1lt4zNChM/
         dbW18/Z0B1sbmiakJo5NCuLPb9nEoZGCeewz//ihWe6FIFl2Z/Y3nAxvy8Gv6up3wQqh
         dJfWkdu+loCWIldGYuchtMrUz/rzj/aomPfbFpzyg6pa+VZG5z6YEL9/T3y6grMZ5XQC
         5ogc59ljQvWOCs+xIybR051ExUAqUNeBjlmkPEZWbRkWEdHDyEVF8ylB5C0OJMVjDdt9
         Z3jizTbc4/+1y9PrndkxmP9tdYn/7byOhfuQSpWgWydNBb4u4uMhs9MoDVlMwwbSRu7+
         4lrQ==
X-Gm-Message-State: ACrzQf2JL9VHMaeQSXtoY5T2jSsWIE1xu5CShArfGS2OzmfzZbQxvxl4
        DT8RCKqehzF+BKs8+fmwPxkxApefEBlUxcn2/ayllw==
X-Google-Smtp-Source: AMsMyM7AWHtq6wIvSd1mCteY/A8A9kShPpWdDD8mlB2afF/LGFrFBU0hGiWSRAmTgdFYmHUMQGVIpJ8vx1XCkAEz9kY=
X-Received: by 2002:aca:b205:0:b0:34f:3303:4014 with SMTP id
 b5-20020acab205000000b0034f33034014mr2718170oif.269.1663718818135; Tue, 20
 Sep 2022 17:06:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220919093453.71737-1-likexu@tencent.com> <20220919093453.71737-3-likexu@tencent.com>
In-Reply-To: <20220919093453.71737-3-likexu@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 20 Sep 2022 17:06:47 -0700
Message-ID: <CALMp9eTnAsi7xYDPkN02wK23ndH5mZxoTNj39uS1s05UdLeQVQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: x86/svm/pmu: Add AMD PerfMonV2 support
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 19, 2022 at 2:35 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> From: Like Xu <likexu@tencent.com>
>
> If AMD Performance Monitoring Version 2 (PerfMonV2) is detected
> by the guest, it can use a new scheme to manage the Core PMCs using
> the new global control and status registers.
>
> In addition to benefiting from the PerfMonV2 functionality in the same
> way as the host (higher precision), the guest also can reduce the number
> of vm-exits by lowering the total number of MSRs accesses.
>
> In terms of implementation details, amd_is_valid_msr() is resurrected
> since three newly added MSRs could not be mapped to one vPMC.
> The possibility of emulating PerfMonV2 on the mainframe has also
> been eliminated for reasons of precision.
>
> Co-developed-by: Sandipan Das <sandipan.das@amd.com>
> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
