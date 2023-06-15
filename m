Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7530E73219D
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 23:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236509AbjFOVYn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 17:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjFOVYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 17:24:42 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8C11FC2
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 14:24:41 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53f44c2566dso59557a12.2
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 14:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686864280; x=1689456280;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BTZ5wBqtEZTdQvE+t4svmHg7qfGpYuHSch0PJIYuwpc=;
        b=UAVsbD+rOMz++YgcW9tDED5JpE4OtPhi8YPdcJXBtp9QX/IuUNehT65/Ow0C2MVATA
         EGkOw9+hzLJ/cne35+LiVmqq2VTyNPYprLQrF9PLovES/6rq+ysn1ynLSIPg9dxR0QcP
         ohnL9z8scervdEXxdk8w4DmpOq30/cvInSmT5Gg8XN4EymRebuq04qWWupQWdLUWsAl9
         /oLD4P/6IaBzJWYwS1JXtGKIvkCsJwaGsLRIh5HRYg26diQc+RPmV3rRY2yHtn5phe+V
         00L3TnFD95hRUUoX3sWZZv7weYp4e19oOTv/Axg4x7EepYQ1PmPoMjahS3ar1I7WQNkm
         guqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686864280; x=1689456280;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BTZ5wBqtEZTdQvE+t4svmHg7qfGpYuHSch0PJIYuwpc=;
        b=gcnQ3FsjUjI1gBbIRjR96XXd6udWdf+Y0n7tWhV0tfM1YU3mXS+SKVjryH+M3D8Ql5
         cgOHzrcdjji40oFrPqn1zGphW6uREGWzrcqhWy2Q7rS6DMczbdnyairI/kj3w1Y0oiNu
         dXjfpJxZCp/IPpUjMGsE47LScPi+q7412aci/RJOUq/oxRX5jSLySTNjHg41D6w7cF35
         sAN8YueFmJ1EtMmXL/PQhHcsLAT4wmraM4MEpSfYslwGJRnJFB+aoANghi4WmrebRPoa
         rBqwLurSuUF2jS0kR9fKur9ht4UOUAs9msLdVC+A8QpyFvvKR+9wg2jXCP8yotaXErvZ
         yg4A==
X-Gm-Message-State: AC+VfDxYp4EYoLtU88rdEk84qX2eNSCufIAIyBaIfwpDJjJPai1BLh5c
        Y8O9FSJ1ZR2a0S6J01yR/7tovye9U7M=
X-Google-Smtp-Source: ACHHUZ7KzdQOHShTf1QUgNGdz/w2OVyoX+Tv6bGUzNqpJKuWr7Ua1EYxLokpQ+pxGv3Ta28uZLEjEQEgwWQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:5559:0:b0:54f:73ef:f3a with SMTP id
 f25-20020a635559000000b0054f73ef0f3amr2104031pgm.9.1686864280542; Thu, 15 Jun
 2023 14:24:40 -0700 (PDT)
Date:   Thu, 15 Jun 2023 14:24:38 -0700
In-Reply-To: <20230615054259.14911-1-gshan@redhat.com>
Mime-Version: 1.0
References: <20230615054259.14911-1-gshan@redhat.com>
Message-ID: <ZIuBliqWsgGmXpzJ@google.com>
Subject: Re: [PATCH v3] KVM: Avoid illegal stage2 mapping on invalid memory slot
From:   Sean Christopherson <seanjc@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        mtosatti@redhat.com, maz@kernel.org, will@kernel.org,
        c.dall@virtualopensystems.com, peterx@redhat.com, david@redhat.com,
        aarcange@redhat.com, shahuang@redhat.com, hshuai@redhat.com,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 15, 2023, Gavin Shan wrote:
> Cc: stable@vger.kernel.org # v3.9+
> Fixes: d5d8184d35c9 ("KVM: ARM: Memory virtualization setup")
> Reported-by: Shuai Hu <hshuai@redhat.com>
> Reported-by: Zhenyu Zhang <zhenyzha@redhat.com>
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---

With Oliver's comment suggestion,

Reviewed-by: Sean Christopherson <seanjc@google.com>
