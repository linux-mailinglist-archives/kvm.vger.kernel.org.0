Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDE0697F51
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 16:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjBOPRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 10:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjBOPRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 10:17:17 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5053F32E6C
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 07:17:16 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-52ec7c792b1so192777027b3.5
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 07:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2GWRPMHVeiqOMag7N+CGtJxwUoAtSFjI5MbWgOrFpZ4=;
        b=DIrTC42RWTBZubBn6CRUk0pf27X1NwqhaA22qAP2/rgKTxdcSt1wwkryixrq+QvVX8
         J9Kze6KJWc5+tMHtDBrt0dHDrXo2/1LJfFhnvyrt66vvh5Ud4P/8pGkRrmTRXMKAlDG/
         ASbJT6YcLbaEDYmEMRndtPvde4CmCTNXG2xURWyPYxFIm6O0OTNoUAo0TdcgOZucgGp5
         u/PqWm46+1rlUL+9xLB6EcMyl3ac+YTOevbptNwmqYvRxW1UVxDbuYvG8PsWYjVEyYOL
         QKEq26CXCFyCSdF55Cnh/L6Gt/cJ0CHmaSTdi2ei00wOXdu6TvHsud2xl+0D757m1CSf
         boOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2GWRPMHVeiqOMag7N+CGtJxwUoAtSFjI5MbWgOrFpZ4=;
        b=hLfXksXChFJlaSnlFAbtwOqTZczAGo3Jowd1RfhkZtdVu0S3Ku1LpMdwZTp6U4wO46
         2og9Uy58it5boRBAXGpbwlj32I9+R2hQDPsduagrYMeASN/APThCVqRoh5sEkn6XM9LD
         zARPr/cuUkbjhizt2CZdQ2h5HgWP361SznKRIPCblVNUQ2T/Jg2BCoJ/ZfnxG45NqDz4
         u7a25DDqPtG7u74MJQqWt9hiks/qEj1BrmI4ACoM8rZt3ic0f2UMQlN+BQQlp7JZ662/
         C7EmuU2bL4ZpN0yidNyHGoM/0J0ffqBCckxEGsi6TDVo+FPZgA7P4Ufspk0ve3XQO282
         VuPw==
X-Gm-Message-State: AO0yUKUX/LMXQB0QJwmfv/pV8VEV7/xoIu297f0i9tg2qsdO8SuBNpCW
        Pkv0l4YSIEkRr1X8rpkIvI2QVFLbq8o=
X-Google-Smtp-Source: AK7set/MdswQiu5fOFAT1hMuarY6sAib5CavrAMi8b+P3/gfIyilWUpkViGeL2SlHgAfgXq1HFAjTeoAIDk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4314:0:b0:52f:1c23:ee6 with SMTP id
 q20-20020a814314000000b0052f1c230ee6mr4ywa.2.1676474235192; Wed, 15 Feb 2023
 07:17:15 -0800 (PST)
Date:   Wed, 15 Feb 2023 07:17:13 -0800
In-Reply-To: <73545081-0d82-fce6-43f0-c50aee9416cb@gmail.com>
Mime-Version: 1.0
References: <20230210003148.2646712-1-seanjc@google.com> <20230210003148.2646712-8-seanjc@google.com>
 <73545081-0d82-fce6-43f0-c50aee9416cb@gmail.com>
Message-ID: <Y+z2+5HPTRAa7+5i@google.com>
Subject: Re: [PATCH v2 07/21] KVM: x86/pmu: Zero out LBR capabilities during
 PMU refresh
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023, Like Xu wrote:
> On 10/2/2023 8:31 am, Sean Christopherson wrote:
> > Note, this is a very theoretical bug, there is no known use case where a
> > VMM would deliberately enable the vPMU via KVM_SET_CPUID2, and then later
> > disable the vPMU.
> 
> That's why we're getting more and more comfortable with selftests
> and fuzz testing on KVM interfaces. So is there a test for this ?

Yep, last patch in the series, "KVM: selftests: Verify LBRs are disabled if vPMU
is disabled".
