Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17B6BC961D
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 03:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfJCBWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 21:22:51 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:45186 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfJCBWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 21:22:51 -0400
Received: by mail-pl1-f175.google.com with SMTP id u12so670629pls.12
        for <kvm@vger.kernel.org>; Wed, 02 Oct 2019 18:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=oE6/KtM0bbjr0oOa0XWwgeXOckoiJH0BnuoszRX1IEQ=;
        b=AZOHBjp6ogmwaMT70PJaTPMNLd7FQ5KrK1hL+PegbaCUGJC6BDonp+K5cOnjZTifAt
         jtVYL6z3+Du0IzMnnLZQa0IecrpjkpaM/AcuRMa1zxgkz94SeEqc08CBx1aWcCIgOBUB
         aCpAJGWad2EdibUZU1NxKRVFZdwj1pIC6UP7zXN8dzUTKQY2iYdsXZzGclNzyEPDJg45
         t4uwPUK0o45QbmKppEb6KFLNS0Sor5Mri1njeiSo+kfDyZgXc0WHY9H504JP29LD195G
         oxZjKZztFxBsHEMEY/lmNw3dCLgMF8E+RIS+SiTrp0ZcUplW+cebSkv3I+UDELkWz4ML
         /fJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=oE6/KtM0bbjr0oOa0XWwgeXOckoiJH0BnuoszRX1IEQ=;
        b=AeFq0gudHX44wLWdsiJrEogK2AAc6F1zEpgKOiLPDM0eOkKCTv7hqCbnWzU9qFYNzX
         1ILUu2DqrEvTlwV/iuVJxtX6qMMXqjsrxDE/EAos/EMeyviUdZvqSephfAD6BWZ4nh/5
         O3oasE5Mm8Ac6iq/M200xMMRwGnwt1KGPjQh0ap30DfRStGn5g921fSYE0YbdWwQaz+G
         +o4qf8jMOH5QXa/W3yEsfInrRx/GaG0QLYur3cPSuwGp4h4zei7e5X2mfkFD7zuhXGYh
         HsO8RaT5PmWrHnYWIcjDm1aFbm8+iXHIsHt+ZzfIfsOUczyfs+UEKI1VR82z8NgyTn3o
         Q9lg==
X-Gm-Message-State: APjAAAUZu9B+KQ850Q5b1AfWmYtHDEtxLJNlzAvNL4ZlL+zNHsCkQCt8
        jJzreMDEbGRn80AKWk4Hu38=
X-Google-Smtp-Source: APXvYqxwbUuhyfANZp1jUkG8osiY6isrYtO/9tfZANVZsbFFMoFmMoEUpL7A+Vf1Bcagux0aEfOYHg==
X-Received: by 2002:a17:902:aa07:: with SMTP id be7mr6993791plb.172.1570065770298;
        Wed, 02 Oct 2019 18:22:50 -0700 (PDT)
Received: from [10.2.144.69] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id cx22sm426954pjb.19.2019.10.02.18.22.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 18:22:49 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Determining whether LVT_CMCI is supported
Message-Id: <2CF61715-CA79-4578-BD09-A0B6E2B2222F@gmail.com>
Date:   Wed, 2 Oct 2019 18:22:48 -0700
Cc:     Marc Orr <marcorr@google.com>, kvm list <kvm@vger.kernel.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Sean,

Sorry for keep bothering you, but I am a bit stuck with fixing one
kvm-unit-tests that fails on Skylake bare-metal.

The reason for the failure is that I assumed that APIC_CMCI (MSR 0x82f)
support is reported in MSR_IA32_MCG_CAP[10].

However, on my machine, I get:  MSR_IA32_MCG_CAP (0x179) = 0x7000816

And although MSR_IA32_MCG_CAP[10] is clear, APIC_CMCI is still accessible.

Is there a way to determine whether LVT_CMCI is supported on a CPU?

Thanks,
Nadav
