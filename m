Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4A07BAF6E
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 01:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjJEX6I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 19:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjJEX6G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 19:58:06 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D699F
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 16:58:03 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id 5614622812f47-3ae5a014d78so1359329b6e.1
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 16:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696550282; x=1697155082; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=44rKSvYUH7JAJmQ5V9S1+ZcFwK9XiGadHatQeMpWa7M=;
        b=yZ0V3Mt+O2UcvJf93NHlkpadESECz57DyM91v1uKWY33wkTepgK0h6UUl8hQ6cyC6G
         r/DdGBeXwbpGS1eq1BVKHY0lndhvMy9+Pb/7WK9/E+Ghi3WpJg6dKhOgBYblkI5ZY26V
         z9dfnm3C9jZt547k50ztDdpwg2iJnkwabBFEV+mU5mvZRLGhK7o1l7d5+jkC9z5BO20k
         IYLauq7qafjgejcln4aYB8dIOXDeVfc5b0hwRp7ChIfqnJ03LswlgQVib2GOFVKfNqhq
         SBapy/Kzjb7qudO7mB4WktCMyggjl633vlbExs+xsHR9BRxUgST53cS6Z6DumZN/t6n4
         H+2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696550282; x=1697155082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=44rKSvYUH7JAJmQ5V9S1+ZcFwK9XiGadHatQeMpWa7M=;
        b=tHt2VQboHPY1z5A6w8bgIr/7RQHvpuDvAo7XLz+4AoGWIUjhLIhobKHxeYCQzykiZ3
         Q8mWsjSYzNa5XrgNQNoI3mKBElet6hBZH2uXUa1RGib4iHibOrx/3Xzu1FUIFATtz5eM
         wrJXaZ8ngpNocHwXaYJgCAjYcRPR8vbfbS5ooKAF12Yyns42Qr4sHzeP+oTBjLCPCx2d
         0QsrFniVMYOZ+7AiJe5tV0oqr6L3OdE7gBHXbU/c5+BUF41OeQ7U/WxaEaZbQXvIGwWt
         /Kr6iLU2iYBOhJCT9HlEJTfjS6YpXTtFNzBICtK6FapoGl+63TZwjNTemdT+2j/UImml
         7Hyg==
X-Gm-Message-State: AOJu0Yxx/xy592QlBM76j9DaYCS4SvJjCrIslbCJ5i2gPmGW8+GRu+n4
        R+AfMvuPKfm7rFD4yo0+mvQF3FHkoGOp5FT1G5/iU+I3x/47Rq4xGfP4SA==
X-Google-Smtp-Source: AGHT+IHmJEBw3FEwSKl+ovMIRs4++7rLKFDnnPFE12KkBwrbdRxv2j2rQxvCOnfcPRcXdkpqGTXMw5Ql84/AguKeHyM=
X-Received: by 2002:a05:6808:15a1:b0:3a1:db91:c5ef with SMTP id
 t33-20020a05680815a100b003a1db91c5efmr1811913oiw.23.1696550282493; Thu, 05
 Oct 2023 16:58:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-7-amoorthy@google.com>
 <ZR4Qr4Yzj7nUNIT3@google.com>
In-Reply-To: <ZR4Qr4Yzj7nUNIT3@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Thu, 5 Oct 2023 16:57:26 -0700
Message-ID: <CAF7b7mp9VDu3hEFrOys9-9wfS+nKAJX7vcnBYgk_pBZ-NnJE2g@mail.gmail.com>
Subject: Re: [PATCH v5 06/17] KVM: x86: Annotate -EFAULTs from kvm_handle_error_pfn()
To:     Sean Christopherson <seanjc@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        nadav.amit@gmail.com, isaku.yamahata@gmail.com,
        kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Wed, Oct 4, 2023 at 6:26=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> ...isn't helpful because it doesn't provide any
> insight into the actual impact of the change, i.e. requires the reader to=
 already
> know exactly how and when kvm_handle_error_pfn() is used.

Ah, true. Hopefully the following is better?

> KVM: x86: Annotate hva->hpa translation failures in stage-2 fault path
>
> Set up a KVM_EXIT_MEMORY_FAULT in cases where the stage-2 fault exit
> handler successfully translates a GPA to an HVA, but fails to translate
> the HVA to an HPA via GUP. This provides information to userspace which i=
t
> could potentially use, for instance to resolve the failure.

Maybe the "via GUP" isn't really doing anything there
