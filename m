Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C18D784C13
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 23:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjHVVcz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 17:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjHVVcy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 17:32:54 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B233E4B
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 14:32:27 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d74a6dfb0deso3221462276.0
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 14:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692739946; x=1693344746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+kXQeYuaEB8eQGTPE8TJhF1IJMoBjwJFG4tlNYlPNmo=;
        b=QFyoOafknXE3bXCQj6ob3DCg0bNjeFTSNHknpCLHd3GL1hY8D0yAZ4yPlbOtSV6H6R
         k4h6+nMa671DLU8sSgXKgSWX4SBDnSHyxL54/1AyZbPcQ2GJoBwPU15YKMZ3EmA6b1vZ
         bY7HjYy662HV6XHxDSTEAadYXdp/Y2rfhn7nm7dCpv48tfd05ezwxBRpj8/wXryvgZoY
         U8Ajq/irwnZN2X+ktXLX+kwtEJGAz6vc2DQZYCfsmF4+wBm5mN8VveqX76dGBeJyz4q1
         K1WX8ur1Ayqq1jxu7uJd4plLr3IpGgtGaM0MNLfM26FgQ0PHRx549yr64461qvEx8est
         uReg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692739946; x=1693344746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+kXQeYuaEB8eQGTPE8TJhF1IJMoBjwJFG4tlNYlPNmo=;
        b=bMVx9dLu9JZyBEqABF5kTRwBL+QumrSpfiejOutUnSUH4c96FYsWXksXHe02a7+esy
         UB1GZcA4QHH4qr8sjjw0sFRgAKWffNcgChGBpDuerCcef/VCjo+xUdWaBwYwa/20kgzA
         fKxAth96lrX98+8wcNUxiIwe11QQPojYMFaTTJfKBll1BI/9Zl1z4V0jfGMe3Q8uuiIa
         fLVIIbVu4QfotStpCtYst5PCP1dCDvQ1OmrLOwkCVwhGnkq5gGB/XzXa079vS3OmiBJU
         qIc9DkKSvbC7zgCHZgm/AhpNnAbpQhUUPTN24Yx5E2jmG8MEzEyg4+QYwjjln7U3N2C6
         muNg==
X-Gm-Message-State: AOJu0Yza707FByuzeW/QWpgRGrcMVvabcZ2Lmla2MaBMG6lr6sL4CJXi
        n09z0H+6Rr9VGh8bUwsxKOdFMT3Y25o=
X-Google-Smtp-Source: AGHT+IFgR/ELUxjCLjgK0GrNeKuX7nKocuUk7DzSr6+7vmL76Al+t1cs7Gpr4MWpa3OH7EEIgrWg1FpSnok=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:106:b0:d77:984e:c770 with SMTP id
 o6-20020a056902010600b00d77984ec770mr48747ybh.5.1692739946669; Tue, 22 Aug
 2023 14:32:26 -0700 (PDT)
Date:   Tue, 22 Aug 2023 14:32:25 -0700
In-Reply-To: <353c2fce-c81b-74c-c1cb-4bbdb3ab1c26@ewheeler.net>
Mime-Version: 1.0
References: <5e678d57-66b-a18d-f97e-b41357fdb7f@ewheeler.net>
 <ZN5lD5Ro9LVgTA6M@google.com> <3ee6ddd4-74ad-9660-e3e5-a420a089ea54@ewheeler.net>
 <ZN+BRjUxouKiDSbx@google.com> <418345e5-a3e5-6e8d-395a-f5551ea13e2@ewheeler.net>
 <5fc6cea-9f51-582c-8bb3-21e0b4bf397@ewheeler.net> <ZOP4lwiMU2Uf89eQ@google.com>
 <468b1298-e43e-2397-5f3-4b6af6e2f461@ewheeler.net> <ZOTQPUk5kxskDcsi@google.com>
 <353c2fce-c81b-74c-c1cb-4bbdb3ab1c26@ewheeler.net>
Message-ID: <ZOUpafKm+1EQa2kt@google.com>
Subject: Re: Deadlock due to EPT_VIOLATION
From:   Sean Christopherson <seanjc@google.com>
To:     Eric Wheeler <kvm@lists.ewheeler.net>
Cc:     Amaan Cheval <amaan.cheval@gmail.com>, brak@gameservers.com,
        kvm@vger.kernel.org
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

On Tue, Aug 22, 2023, Eric Wheeler wrote:
> On Tue, 22 Aug 2023, Sean Christopherson wrote:
> > On Mon, Aug 21, 2023, Eric Wheeler wrote:
> > Note!  Enable trace_kvm_exit before/when running this to ensure KVM grabs the guest RIP
> > from the VMCS.  Without that enabled, RIP from vcpu->arch.regs[16] may be stale.
> 
> Thanks, we'll try it out.
> 
> To confirm, when you say "Enable trace_kvm_exit", is it this:
> 
> 	echo 1 > /sys/kernel/tracing/events/kvm/kvm_exit/enable
> 
> or this (which might be the same):
> 
> 	echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_exit/enable
> 
> or something else?

Yep, you got it.  They're the same thing, the two paths are just different (common)
places to mount the kernel's debufs.
