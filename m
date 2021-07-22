Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F73B3D1DCC
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 07:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhGVFOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 01:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbhGVFOm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 01:14:42 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE25EC061575;
        Wed, 21 Jul 2021 22:55:17 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id t4-20020a05683014c4b02904cd671b911bso4317932otq.1;
        Wed, 21 Jul 2021 22:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QN1ev8xMwchF2OgXjdPYWOEMPX7NTDgCOlrkD31eHy4=;
        b=jXrxmZJNZKZMR9nJLKg12DQL0nmaYL9hhCUQqsvCCpU3MDlWGd6W3L0KAv4A1l0Bxs
         O49BNZHWTOm59l8a1tb0ls/CCE2d6pGrXOCfLbkdd7FMdE9YZg366mgZ/xdosogjpOdh
         s6suBfuI7N6pXy2e3DnP+h10C2HojMr0uuxPscbgly6TeJv4Amd9muuFFOWmxzvQXq6W
         pvoE+f8nrj7TtK60TULkckULR2Z09kB0CBZiGDp9c8A//O29LmykMZQUijA3EPanl4WA
         fSrDiCEQk9aToeKCtpeAaJqdcmMaJWlJzXdkrOhRdTxmn/o/jeBl/KPLWDqyL18IwQbV
         h59w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QN1ev8xMwchF2OgXjdPYWOEMPX7NTDgCOlrkD31eHy4=;
        b=L+U5QZl7F9hz+YpezWZ8APr7qqN3APdRhszzvH7sHMZjrkyet4ZXKjfmeEJPq6veAk
         QORNnMBM0c/lJmtsehZ1ulk7AKZupN2uMjM/sjHOGU3vg+gccoI5gpwRHRqqp+MssC5M
         OJ+KOWC1tg4VGsuRm4vnjDSFpfeb+OMwsR1hEScQQWlTi8gyrCgZXnnbTA4VTGnkhJn+
         rvNaXpA00DyRSkWf2ckfWWrxH510HhPjKrwvM00umKXGT1mbrnZcBkXjXEtJM+b28VM0
         4aovmR70FfDP163qsjmYG9seA/IGg0QSEvW5UUCQ46yojMrkxgN6opzwSGG4g7z7zDCX
         f56w==
X-Gm-Message-State: AOAM532oUAFNGUsdJgo8QVVNJVzW7sXY0S7z172V8T1+HT0v+WHftEMZ
        QuYGK/kk0QoW9UJj1zN34kxSPPlyKvnaY8b3NSk=
X-Google-Smtp-Source: ABdhPJzWBO3wCgmM9LAYq4MVGYjry+20++zWVDC3YkTy5ZPLMEFRey4r54ODWnh6J3rVhDdP+71E4dhyPBVca9VFHjY=
X-Received: by 2002:a9d:4f02:: with SMTP id d2mr21148711otl.254.1626933317333;
 Wed, 21 Jul 2021 22:55:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210722035807.36937-1-lirongqing@baidu.com>
In-Reply-To: <20210722035807.36937-1-lirongqing@baidu.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 22 Jul 2021 13:55:06 +0800
Message-ID: <CANRm+Cx-5Yyxx5A4+qkYa01MG4BCdwXPd++bmxzOid+XL267cQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: Consider SMT idle status when halt polling
To:     Li RongQing <lirongqing@baidu.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 22 Jul 2021 at 12:07, Li RongQing <lirongqing@baidu.com> wrote:
>
> SMT siblings share caches and other hardware, halt polling
> will degrade its sibling performance if its sibling is busy

Do you have any real scenario benefits? As the polling nature, some
cloud providers will configure to their preferred balance of cpu usage
and performance, and other cloud providers for their NFV scenarios
which are more sensitive to latency are vCPU and pCPU 1:1 pin=EF=BC=8Cyou
destroy these setups.

    Wanpeng
