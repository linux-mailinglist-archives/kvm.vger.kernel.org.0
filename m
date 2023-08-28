Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6EAD78B28F
	for <lists+kvm@lfdr.de>; Mon, 28 Aug 2023 16:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbjH1OEv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Aug 2023 10:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbjH1OEj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Aug 2023 10:04:39 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5258A120
        for <kvm@vger.kernel.org>; Mon, 28 Aug 2023 07:04:36 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d77fa2e7771so3939479276.1
        for <kvm@vger.kernel.org>; Mon, 28 Aug 2023 07:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693231475; x=1693836275;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AeZG/LqUiqF0MY2HczEpiH5CLGzioag7c/FugDpORz8=;
        b=VDcqxgpas3p1DadFWmbrWR5W8zqdrer9COaNEUBB1oI49CRtv7rUwXZcz2B1roOES4
         t91WwsHdDptsL2uFPeGzNcTUQzA0J9dHVWDSoyKP9JvvDkzch/vRG2AeCoJHA9P33xKK
         FxHWYdo61qlISm/tXRqNfKrnouiujqpE08oXautkXjpqrNPD1MovrLYO5Ut0LVX8sfnN
         VpqnwISUMAkC5NSHhoQQoZPAwobzneKYYVe8hrJMOBpSdN7EuTsQWItkRL5aywz5VKZ3
         WQUElBwjYV9P785Ipgx1X3/7TH+AqgYDxmOB9qQvTr9CP0GHJ8sgiBnpdjhPK1/UExN6
         wWlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693231475; x=1693836275;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AeZG/LqUiqF0MY2HczEpiH5CLGzioag7c/FugDpORz8=;
        b=NLhTUtgB8KADJajVZM/UN5eanHWl8SEl3xxVCVZI3zKTJao85a2Z20FPZyeFPbwvou
         JMqjIXormVf6MsjOclivBBLfhgLjBE2hj/u32O/LeC56dDyTcrstA8wVL1BLSvfdDQcU
         fBQkq9C1M8f91PfLaJ//VBS9MduSpvauLzAomiYcXmrPeQQGiJ6MsXwDbYZg8j0/wJR9
         SAM6ZpAo+zTF36E17QsDV9uSHP7g0C2Xk4zgKBj1xfqYMIByDrvotdjGoLO2qwMPGK1q
         yvsDIv//+5hhSPbzvZ2hA45gpZCgVbKsJAVm0hfqP4H1/nDQSIkBlQ1QwNyhD7MFt8V4
         qkYg==
X-Gm-Message-State: AOJu0YxHKpfydpO3nbFJr38jwHYm4jRe7wsLTIjNNPRPXBBVw6suo0SK
        sS3i/5fHt8o7Z0DKAeMFe9wUyPKZn/k=
X-Google-Smtp-Source: AGHT+IHKKQw6ctp5TNMc7wshvgitTEG6NUyakQ1wy/mJelNNbJkdGOiLVuLUBvj6d5ocDvVJfaBiaJTiyLM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d890:0:b0:d10:5b67:843c with SMTP id
 p138-20020a25d890000000b00d105b67843cmr832409ybg.4.1693231475583; Mon, 28 Aug
 2023 07:04:35 -0700 (PDT)
Date:   Mon, 28 Aug 2023 07:04:35 -0700
In-Reply-To: <SY4P282MB10841E53BAF421675FCE991D9DE0A@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
Mime-Version: 1.0
References: <SY4P282MB10841E53BAF421675FCE991D9DE0A@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
Message-ID: <ZOypc+LeHdE5u0MC@google.com>
Subject: Re: [PATCH] KVM: VMX: Fix NMI event loss
From:   Sean Christopherson <seanjc@google.com>
To:     Tianyi Liu <i.pear@outlook.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 28, 2023, Tianyi Liu wrote:
> Hi, Sean:
> 
> I have found that in the latest version of the kernel, some PMU events are
> being lost. I used bisect and found out the breaking commit [1], which
> moved the handling of NMI events from `handle_exception_irqoff` to
> `vmx_vcpu_enter_exit`.
> 
> If I revert this part as done in this patch, it works correctly. However,
> I'm not really familiar with KVM, and I'm not sure about the intent behind
> the original patch [1].

FWIW, the goal was to invoke vmx_do_nmi_irqoff() before leaving the "noinstr"
region.  I messed up and forgot that vmx_get_intr_info() relied on metadata being
reset after VM-Exit :-/

> Could you please take a look on this? Thanks a lot.

Please try this patch, it should fix the problem but I haven't fully tested it
against an affected workload yet.  I'll do that later today.

https://lore.kernel.org/all/20230825014532.2846714-1-seanjc@google.com
