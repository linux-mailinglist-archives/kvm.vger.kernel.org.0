Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B067277B231
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 09:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbjHNHQx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 03:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234066AbjHNHQg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 03:16:36 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9107AE77
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 00:16:35 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-68783004143so2482506b3a.2
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 00:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691997395; x=1692602195;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pxp+IVEo0LKe0kgUuQrVGmpE70BNyACEd+AbijZumyk=;
        b=aGHqzk25bhTA5rrUJpEWfg/0Irz7jPSUNTusETayJFw6z/kArbtpNZHsdJI+US10xH
         igEiQyydGfdRk9izJRawtbK3//yEIV+sL6L9Huf/LNNGqjdDnjkLYy45xlQerEs636fk
         t9nmwOLPEAn3iU5IQL3D/+ZpBsalmDTyNH9aGuSrKZO5UPoKVQyqwbstpTGuD5BvHsm/
         zabciBwL8HIf7OS7+iHALkO1VLQUKrWK8tqo0c2cKRZarrj4ooRHJMUqQMcUI/SQfgI3
         qV1Xjd5VPE4jSQWlwCg1yhYY+Idld/ofMIRRExFVWa4gi4AA0w5WvH1O50c1jLjRvH0c
         e02g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691997395; x=1692602195;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pxp+IVEo0LKe0kgUuQrVGmpE70BNyACEd+AbijZumyk=;
        b=R5vuR6uxciLMIBEg5o+xmAmLonMLcy4GZtnNjZul3oboLcDznn6qYMjfXrjWgWTYEC
         9FpIm4e+LdeleS/v8UnJorBAaNFqSicNOQRnpmRNvyNRBtf2hN3/a8Yl8RhKQAauwU1H
         ed1n8nixsD6XKT/Ik8tzJs36kjs7mxpe9WEm0+rgr/JxJacCUcFPJ6rk6J3urXa5UJOp
         bT7gRulU39Wumh1Yj0I7Rg8kceAoZ1a61bWaXSJd3Yq9mNRFHZKkqV8dMGbFAav02VY5
         1xUC6ddQgepsZMP4sRk5A12CbolAlp/56HYoHwZnbvT2XYSe2PFBMeZkAEEZovU133og
         Gy5g==
X-Gm-Message-State: AOJu0YwHuKIJVXAvDEVhUdiIhug3k6jrjKqfxpy8Woz2trCIR8Xi/vSC
        8LoqQ7w+9yB/EArsikngMtmRhA==
X-Google-Smtp-Source: AGHT+IFy66tVYM+eFPd/cnoMV4AFYDumjWr4SaF0Sp+xYXJpuncgwIiPc+ybmY2I9j3r5sKkt+w+LQ==
X-Received: by 2002:a05:6a20:5487:b0:140:54ab:7f43 with SMTP id i7-20020a056a20548700b0014054ab7f43mr9312549pzk.52.1691997395017;
        Mon, 14 Aug 2023 00:16:35 -0700 (PDT)
Received: from leoy-huanghe ([150.230.248.162])
        by smtp.gmail.com with ESMTPSA id u20-20020a62ed14000000b006870b923fb3sm7213588pfh.52.2023.08.14.00.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 00:16:34 -0700 (PDT)
Date:   Mon, 14 Aug 2023 15:16:27 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huang Shijie <shijie@os.amperecomputing.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: pmu: Resync EL0 state on counter rotation
Message-ID: <20230814071627.GA3963214@leoy-huanghe>
References: <20230811180520.131727-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230811180520.131727-1-maz@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 11, 2023 at 07:05:20PM +0100, Marc Zyngier wrote:
> Huang Shijie reports that, when profiling a guest from the host
> with a number of events that exceeds the number of available
> counters, the reported counts are wildly inaccurate. Without
> the counter oversubscription, the reported counts are correct.
> 
> Their investigation indicates that upon counter rotation (which
> takes place on the back of a timer interrupt), we fail to
> re-apply the guest EL0 enabling, leading to the counting of host
> events instead of guest events.

Seems to me, it's not clear for why the counter rotation will cause
the issue.

In the example shared by Shijie in [1], the cycle counter is enabled for
both host and guest, and cycle counter is a dedicated event which does
not share counter with other events.  Even there have counter rotation,
it should not impact the cycle counter.

I mean if we cannot explain clearly for this part, we don't find the
root cause, and this patch (and Shijie's patch) just walks around the
issue.

Thanks,
Leo

[1] https://lore.kernel.org/lkml/20230810072906.4007-1-shijie@os.amperecomputing.com/
