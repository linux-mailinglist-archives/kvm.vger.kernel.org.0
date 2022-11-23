Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 215A06365B9
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 17:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238859AbiKWQ0H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 11:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239081AbiKWQ0A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 11:26:00 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A138FFBB
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 08:25:55 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id q96-20020a17090a1b6900b00218b8f9035cso2276517pjq.5
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 08:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KV0Q2Ve7Y1OLL3McQZ+JXyK8SKXU45c4EVA5C11Sx70=;
        b=f2zZjBEGCk/wq6BfBLHNBZ3t/5SQid7sFIroTWjFYtFoLiPRGKrwUrS25sZnvl2RSM
         pcCjckZUd1o6raMEecackD9kG2/iqz40U+xr1gWbXdkAB8Ht6bn6pnMoNzlJlFDvlJod
         k6voTFvvetSP2VfPnwidPlTQZ58lR9LjvNZmUB79UOuS0k13kQqmIgLvWU2E/9g7zDza
         hoQ6deT9Xzv9Wa7+r4QxnSWtRRGeXq9qvlO/oEm7Rece5aUF87vTey9zXKMjpTeWueV5
         S3kHUnCxNaTbHkCteyM047dhWafgSFWRsWuCXeTswMqrD2XaXBkok9WkWy5tUrL28v7P
         feiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KV0Q2Ve7Y1OLL3McQZ+JXyK8SKXU45c4EVA5C11Sx70=;
        b=u+PSc9en2dOZiroKmFCUMH57mTH6A+gsBSNdoI0CANXhZw8Q8WGGxejlJ0VfyE2+Zb
         WZsIvZAr0QT+n/xyaiOucPMaux/v8MOJyC2GiCFS/NVXPi7pHmBlfhzRqJmL/AdJyJJr
         W6Q5VJhVM/WNGpeknEEQWcrmClfVJjHDgF5cmim0rkfKbDXeZYvpxFeVIg0RKrdqMj/x
         OC+vq3RZfh+q/RSJ3dOnXCJ/PVn0oiCWKBoPQi9OUDU2Snu/Pl7b0NJmgVrl3ivv/Sq+
         KgB+Ku9jt43ZkmMxav09kuZG7qCnDCmfQbEcVz7uruHsHLAVt7Qpu2sHW0f4p08ZXwbb
         3Rnw==
X-Gm-Message-State: ANoB5pkfdwJ6TOE60fBIoShZXZHehc5XIgCDVEfsIf+h9M8SYij5Da0s
        +AVhIRWDcO930E6uCn0m9X31jQ==
X-Google-Smtp-Source: AA0mqf4DSuwV2z7t/X3sqjtCcDC3BLdYs+ksEH5851wGcflfOicve27pp87h1KQX5p925KvF3Td5uQ==
X-Received: by 2002:a17:90a:b38b:b0:214:1328:ac8f with SMTP id e11-20020a17090ab38b00b002141328ac8fmr31092573pjr.198.1669220754471;
        Wed, 23 Nov 2022 08:25:54 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b29-20020aa7951d000000b00561382a5a25sm12958228pfp.26.2022.11.23.08.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 08:25:54 -0800 (PST)
Date:   Wed, 23 Nov 2022 16:25:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Michal Luczaj <mhal@rbox.co>,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: x86/xen: Validate port number in SCHEDOP_poll
Message-ID: <Y35JjlgjvtkAMk7C@google.com>
References: <20221123002030.92716-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123002030.92716-1-dwmw2@infradead.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> We shouldn't allow guests to poll on arbitrary port numbers off the end
> of the event channel table.
> 
> Fixes: 1a65105a5aba ("KVM: x86/xen: handle PV spinlocks slowpath")
> [dwmw2: my bug though; the original version did check the validity as a
>  side-effect of an idr_find() which I ripped out in refactoring.]
> Reported-by: Michal Luczaj <mhal@rbox.co>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Cc: stable@kernel.org
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
