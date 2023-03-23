Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53DE56C72EB
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 23:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbjCWWTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 18:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbjCWWTX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 18:19:23 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB832007C
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:19:22 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id g7-20020a056602242700b00758e7dbd0dbso67525iob.16
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679609962;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rxAZ+kxQPGWQc3YGGq+yage7hrM7pnvCTwm028DTm6Y=;
        b=NW0m8Ir4zOOM8A86pYqspbfj+W72uBiCxIRgqtLKK2lWS88B47VXSBzd5ZxD35rL1r
         ItLwIHZzfLaQRMyKX16p0bpW5Rz0RXbuYrnb74e+zXW9S9argS1YyJ0ccjEjQdU9lsKY
         6dlouhnggOah86WzS6fleOtxscdQNumx7N3cZTFtRdLSkpLDPsPN3fF5sjkVvhmMo0UG
         j4ZUvAGUyRWorAQzCkpMduFMSbEokIT5z5J+WmUyUd4i925biPh76p8dSry2h4pVPdhK
         grW8obmsxiqkls9II71+GorlG//Tz45R2nTon96hdQ1q93Ox8z1pCv2ClCSZ3ubRwVNk
         1VCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679609962;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rxAZ+kxQPGWQc3YGGq+yage7hrM7pnvCTwm028DTm6Y=;
        b=q1Kj7riJtEAPdN00QrHlZe4tBODHZomx68DiQvRwNeL0xfzYgHMg9bxFUpN2JNfCQU
         Yzqi7DSUEQGl+DIugmvUzCdGZCHzgEeUgAmRCqYypLRdu+PJK9pWgK0fbHlEMJm2qQvB
         u8XmOSVMsbC2pMqlEOZ2//Vv8unLH2rGDpC4pNCbnS0sydOVGN/If+/aEOIhUevgpJnC
         N1yCZ2GmdZ4libBsFxS6i0kvfr8CJULj+/rCKmuWWv9E47zznKqubeyx6b2SmfZF8Y/K
         1JpkNTcmoZL4HR6W9Gk0e0yjtAmBUvQyvLvxegj/Zlfs/KmROsc9G5GzMVE+yarR5acU
         FRCA==
X-Gm-Message-State: AO0yUKWu/agbc46lwLNrVztHT/mp1AvC6S6B2imvGGqd5DbT8jZHz62Z
        EMO/4lYUdmYxapOx6IW5IkPuyysawN/JN1k3Jw==
X-Google-Smtp-Source: AK7set+7z+U+rkzFtkXD/4bTtoGCn6aSxcDEVTE8Vnn+drCicOJE7RRqBO7O9kzJvihAK7pbF/li/oTAcNNJVadRqw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:4984:b0:406:37fb:43eb with
 SMTP id cv4-20020a056638498400b0040637fb43ebmr5255573jab.1.1679609961976;
 Thu, 23 Mar 2023 15:19:21 -0700 (PDT)
Date:   Thu, 23 Mar 2023 22:19:21 +0000
In-Reply-To: <20230313124837.2264882-1-maz@kernel.org> (message from Marc
 Zyngier on Mon, 13 Mar 2023 12:48:18 +0000)
Mime-Version: 1.0
Message-ID: <gsntbkkjcdqu.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 00/19] KVM: arm64: Rework timer offsetting for fun and profit
From:   Colton Lewis <coltonlewis@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de,
        reijiw@google.com, joey.gouly@arm.com, dwmw2@infradead.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Marc,

I had thought I sent this earlier but our conversation today made me
aware I hadn't.

Marc Zyngier <maz@kernel.org> writes:

> way. Colton reported some other issues with this test, but I cannot
> reproduce them here, making me think this might be related to CNTPOFF
> (but again, I don't have such HW at hand).

I can no longer reproduce any issues on any platform with this version.

Two minor comments:

- I'm not sure you ever addressed my comment from v1 asking if you
   should add CNTPOFF_EL2 to vcpu_sysreg in
   arch/arm64/include/asm/kvm_host.h

- You left the capital O flag in your selftest changes even though it is
   no longer used.

Otherwise,

Reviewed-by: Colton Lewis <coltonlewis@google.com>
