Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C367D3C30
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 18:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbjJWQUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 12:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbjJWQTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 12:19:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8C719BE
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 09:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698077920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ut5czDDze7j+1Ijghpb8c61xr1AzZHB+GaM5+Au8mg8=;
        b=HQDx/AAzMvX7CvOFRzNb90N5VJ9efghPDOX1Exu2WNkh3naXWxI/SzSTr8/noWQbQE4C9M
        We1BKHVgW5uOvujbz4hpogZmeVZdmZ6l4WOX2YBqC6jgVxkbFUgHIlCoDLak98MOyq1n3H
        PJyaFgF90OFh9WgmS+zr1j76IJAOzYo=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-185-LDItnfQMOoSEEGaexvSGEA-1; Mon, 23 Oct 2023 12:18:39 -0400
X-MC-Unique: LDItnfQMOoSEEGaexvSGEA-1
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-7abaae41e6dso2088026241.1
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 09:18:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698077918; x=1698682718;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ut5czDDze7j+1Ijghpb8c61xr1AzZHB+GaM5+Au8mg8=;
        b=feEmUgDjO9gLsKBSYaumpcLMG0XGp361mecpW1ZUcB1MDAZTIMs9ZZykJjA6VKQnee
         AiHnD4l79U+9WS/2WMQnecUvF0suvX+uIgARlYNOmwDimf+ozx1m8VDz3LEurABPew6d
         lz8NPaa7S/3mxaTdz8mb1SvUPNTMfIyBdDKBuesZ2GhAM7IPRcqVXY7/aXQfZR1Z516f
         TVkGPtf/7rPqhkfU2REgBsY01s1dHpUKe7LdmnE4m/bHAxA3/lwJLRj/TeoMBzNs62J5
         2dGepreWP/5CYIVP8vY5EkPJnfzl+ybORoN6uJvmA5BfaMfYjjgR2lj3Dwzes32qngQf
         Dt3A==
X-Gm-Message-State: AOJu0YxfRY+TTHkd2y07ppF/XR1SC9aY0cnBuAVEzUzvNx7woE6+mNOE
        unlM7K9yS2a9Uj+wJYkCnkl/LQBgFqkzpu3s82ulWRNZuLugMQXP1PfYBvQaqiTbLEPbcnDUsY5
        yS4ctX8f1ip76
X-Received: by 2002:a67:c10e:0:b0:457:c9d2:4624 with SMTP id d14-20020a67c10e000000b00457c9d24624mr8598339vsj.31.1698077918700;
        Mon, 23 Oct 2023 09:18:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFy1dmvGf+TonaCRs35u3TvwOvOFfRZJMQ/9/d4CfnqFCwWVFMvLeUqOSxJgjtTj2FHYBzaXw==
X-Received: by 2002:a67:c10e:0:b0:457:c9d2:4624 with SMTP id d14-20020a67c10e000000b00457c9d24624mr8598309vsj.31.1698077918408;
        Mon, 23 Oct 2023 09:18:38 -0700 (PDT)
Received: from rh (p200300c93f0047001ec25c15da4a4a7b.dip0.t-ipconnect.de. [2003:c9:3f00:4700:1ec2:5c15:da4a:4a7b])
        by smtp.gmail.com with ESMTPSA id d9-20020a0cf0c9000000b0066d12d1351fsm2925982qvl.143.2023.10.23.09.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 09:18:38 -0700 (PDT)
Date:   Mon, 23 Oct 2023 18:18:32 +0200 (CEST)
From:   Sebastian Ott <sebott@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v8 03/13] KVM: arm64: PMU: Add a helper to read a vCPU's
 PMCR_EL0
In-Reply-To: <20231020214053.2144305-4-rananta@google.com>
Message-ID: <07c09e70-a337-aa41-f022-7ea43be2c0c0@redhat.com>
References: <20231020214053.2144305-1-rananta@google.com> <20231020214053.2144305-4-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Oct 2023, Raghavendra Rao Ananta wrote:
> From: Reiji Watanabe <reijiw@google.com>
>
> Add a helper to read a vCPU's PMCR_EL0, and use it whenever KVM
> reads a vCPU's PMCR_EL0.
>
> Currently, the PMCR_EL0 value is tracked per vCPU. The following
> patches will make (only) PMCR_EL0.N track per guest. Having the
> new helper will be useful to combine the PMCR_EL0.N field
> (tracked per guest) and the other fields (tracked per vCPU)
> to provide the value of PMCR_EL0.
>
> No functional change intended.
>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

