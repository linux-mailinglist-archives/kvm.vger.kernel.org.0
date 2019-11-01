Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6FA0EC86B
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 19:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfKASYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 14:24:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726498AbfKASYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 14:24:20 -0400
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1FA021929
        for <kvm@vger.kernel.org>; Fri,  1 Nov 2019 18:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572632659;
        bh=SzUM5NeWAG+E0eqSpj3zuD6ltC8wZE1F+AwKRX2zRSg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=r7HrHj9UZqBsFeT98x68brCm5kINTp72KRT74jbUyMQzq0yV8evb8UUFIIoMbzeh+
         qQeaa+cCLERZQ67DtNu3WqWqvXhhSkMCnR9LVnzKC9mwX53Jfm8geDhMAG0l33WSLZ
         JaUTlg8lR0H4FC5pBTu4nfPSv7SgaR9Uu0UhWDWc=
Received: by mail-wr1-f52.google.com with SMTP id w18so10509386wrt.3
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2019 11:24:19 -0700 (PDT)
X-Gm-Message-State: APjAAAWTNo0LJ69ynT8L+QqrP+hS4aYB1vY6Q2Ka2FK1X+wxLexhf6Cw
        UGo+cOEOpxtrJMqfThrLQnphybKmrrWjGhlI8MhqXQ==
X-Google-Smtp-Source: APXvYqw0rnlRfwdriPZ576aBq0O+9yfzKHeFxM6ELtsX3pHZailT8JBumH5jVuvvbajKbkN8+GHbNieTjD6qZT7bzCU=
X-Received: by 2002:adf:e4c5:: with SMTP id v5mr12220218wrm.106.1572632658034;
 Fri, 01 Nov 2019 11:24:18 -0700 (PDT)
MIME-Version: 1.0
References: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com> <157262962352.2838.15656190309312238595.stgit@naples-babu.amd.com>
In-Reply-To: <157262962352.2838.15656190309312238595.stgit@naples-babu.amd.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 1 Nov 2019 11:24:05 -0700
X-Gmail-Original-Message-ID: <CALCETrUSjbjt=U6OpTFXEZsEJQ6zjcqCeqi6nSFOi=rN91zWmg@mail.gmail.com>
Message-ID: <CALCETrUSjbjt=U6OpTFXEZsEJQ6zjcqCeqi6nSFOi=rN91zWmg@mail.gmail.com>
Subject: Re: [PATCH 2/4] kvm: svm: Enable UMIP feature on AMD
To:     "Moger, Babu" <Babu.Moger@amd.com>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 1, 2019 at 10:33 AM Moger, Babu <Babu.Moger@amd.com> wrote:
>
> AMD 2nd generation EPYC processors support UMIP (User-Mode Instruction
> Prevention) feature. The UMIP feature prevents the execution of certain
> instructions if the Current Privilege Level (CPL) is greater than 0.
> If any of these instructions are executed with CPL > 0 and UMIP
> is enabled, then kernel reports a #GP exception.
>
> The idea is taken from articles:
> https://lwn.net/Articles/738209/
> https://lwn.net/Articles/694385/
>
> Enable the feature if supported on bare metal and emulate instructions
> to return dummy values for certain cases.

What are these cases?
