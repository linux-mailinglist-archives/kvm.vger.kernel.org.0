Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBABD6A230B
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 21:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjBXUI2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 15:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjBXUIZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 15:08:25 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738CC1B2E2
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 12:08:17 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id l14-20020a056e021c0e00b003157c7e623cso383189ilh.14
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 12:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lq/fW+1gQO4fLzyopuslQ/5nt8lJLNNZbLNdvJWyg60=;
        b=ZRD06LxPDQh9ndgSUCZKyVPO+p4ZA36dw5+dprfLdTO1Ui40tseTDQjix2pt2YBxxE
         tbqXrbhQTasOXR40M+gIvXG6PO98fL+MTLjngEqkPe942ohJx1kTbRgLMJR6n7SuHVWZ
         sBVUuDZEAzsSY5FCBVtD9c1hXQwn+NRkzhy0uinLsxMyLDGF9DWgg8reJ97cOliMic3M
         Cvbq71846TzqLx9xDWyDRMaLZxaky03us3gIr7RSoHMOCh6Yo5Kteg8K7NUbeW+C+xfs
         cPAYuQNlPMngtJDDZf01j805hKirkQWR2EJyKyvFyTFpSgJTPo3t3ERtHGPPSW3IYmIx
         WCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lq/fW+1gQO4fLzyopuslQ/5nt8lJLNNZbLNdvJWyg60=;
        b=SiL0kc5k8gABoEOQ82lHSDa5Y6tgP+L+pBQ5jm/ifp7qc8mkrmkxQKTjdXXXy/MQ3D
         4AIAjmtJJ5NDKUuDwhwIYhfXiyc7xQmUKNQlyebyRQeFpM0kqyQ1Jn+1FuTZE9nPxkv7
         MfSWer0c0vzfhwK5iAdMdmswY2iF3s8YOCZr5Y/h1hUzl7n7gXvVSPLhlZkhP7cYYncP
         aAN0lvBII1JJ4mDWPd1wIni1406OEYuJz6yaUl9HOXd7bkOfu3R0EH0qGQCzI8a+Pr+8
         4O6tMIggnDtrdl4vW4BiRd/Kj+rT/i8ZZ2gj2LKqw+dlNNrBuDlZ8TSE1EjmW9SGFfw6
         e0Ww==
X-Gm-Message-State: AO0yUKWkFSU8+szamI7819FWC7tIobdqgRrZM/AL6EETsiOIVmxVCJfG
        XMYXZjY3vloQLMKzXUQ+0Om88LpJDjpAJkM0aw==
X-Google-Smtp-Source: AK7set+6She2NcmRmPNnegMaKKLqU4exl69q8s3WqgCHl+QehD+6uDHs/Ir9zbRNO8GYwqkkC/9xJcwgXnvvvkKQEQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a02:a1c5:0:b0:3c4:d4b2:f72 with SMTP
 id o5-20020a02a1c5000000b003c4d4b20f72mr5755289jah.3.1677269296880; Fri, 24
 Feb 2023 12:08:16 -0800 (PST)
Date:   Fri, 24 Feb 2023 20:08:15 +0000
In-Reply-To: <20230216142123.2638675-14-maz@kernel.org> (message from Marc
 Zyngier on Thu, 16 Feb 2023 14:21:20 +0000)
Mime-Version: 1.0
Message-ID: <gsntilfq968g.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 13/16] KVM: arm64: nv: timers: Support hyp timer emulation
From:   Colton Lewis <coltonlewis@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de,
        dwmw2@infradead.org, christoffer.dall@arm.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I hope someone else looks at this one because I don't understand NV.

Marc Zyngier <maz@kernel.org> writes:

> +	struct arch_timer_context *ctx;
> +
> +	ctx = (vcpu_has_nv(vcpu) && is_hyp_ctxt(vcpu)) ? vcpu_hvtimer(vcpu)
> +						       : vcpu_vtimer(vcpu);

I don't think that ternary is the easiest to read and would prefer an if
statement.
