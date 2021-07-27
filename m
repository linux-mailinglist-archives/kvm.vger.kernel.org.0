Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396343D6A7E
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 02:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhGZXVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 19:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbhGZXVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 19:21:11 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2549C061757;
        Mon, 26 Jul 2021 17:01:39 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id e14so13704984plh.8;
        Mon, 26 Jul 2021 17:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=lUWjZQDXW1+VGvHm1XsC8R6KR/u25Shxim64XwKLYOc=;
        b=uEhXO1WKKa7U5w07vZoUVJ/G/ZV0UXZnLHN+HefwplYIosDp46zvWVaF5zcladnDl0
         F1nbjGv2t4jWtqGGiRG0rdinfdhPbH+ju8ESVkunzvISrjCeI8Y3FsRHRjFfTbVeS7qP
         JwgK2gHQD3pbb147K11UE2cWhy76+Evp2R7apig9CdVjHhpWqn3TPhIwtvaMkC+p+F1T
         XEzgDlicBT7LmNMOtbhe9YwOJC4YNiMdAgf05Rzdr69LitvupORdrpqEZxj1jpqebNUy
         j7iD12JdTxUrhttr9rMF7kUomYJWVX5MftPwDb71rMtxmoEMjmXAFhnBSboSRiKWxW7r
         uYfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=lUWjZQDXW1+VGvHm1XsC8R6KR/u25Shxim64XwKLYOc=;
        b=uJdQ2yuGDOdGUdwdru2Ew7gatGMRji7ViDqHnEUCs37DC0aWrpayxoLJ0NCbnmy0dW
         TNtpJ2EbpM/89HbZ/CaGDIyCE0vX44yPBjF0P+S9hUullMfuYbLFGSJP/o8YHrOBqxSd
         3/3COBHFVVfCJcU5fN8UEWGA/QJTii4qWzbvVDSRy5MxxoE1U3I2UzY5wS7B5AVMsy1E
         yjsjKO+R0O0zMiZZY7wM0ihknIo5wIR+jwHkl1wuypKG4iCE7G0a6HlTZRRMXtRKXfvd
         2YINzznDqdbbaXEVYihHwJ5b8tWImxvd9w3R5DgNxaSv+Nvn/pnoXgNyq1FroiWfbYee
         DrIg==
X-Gm-Message-State: AOAM530W6/jn0Yxe+t1Ep+zrfbRJKiLNNH/mk3+acsSzqO7gI3Hmc1Hp
        vhnD6larKFMmLMCg6b15lgk=
X-Google-Smtp-Source: ABdhPJxhNVQEpYqpNVd+k+C8FWNhN3WAWtV7aOMjjnpGW0pDOnJKwzW14lIHVW7BwU7gDICkPua42w==
X-Received: by 2002:a62:1bc7:0:b029:328:f2c:8ff1 with SMTP id b190-20020a621bc70000b02903280f2c8ff1mr20156762pfb.18.1627344098894;
        Mon, 26 Jul 2021 17:01:38 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id q21sm981911pgk.71.2021.07.26.17.01.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Jul 2021 17:01:38 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH v2 46/46] KVM: x86: Preserve guest's CR0.CD/NW on INIT
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CAAeT=FzGDUr8MK5Uf3jyUxtf+2jCf=bgG760L0mjjM3vRsXKSg@mail.gmail.com>
Date:   Mon, 26 Jul 2021 17:01:36 -0700
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A41676B6-2E9F-4F8E-B91E-8F9A077A2FA8@gmail.com>
References: <20210713163324.627647-1-seanjc@google.com>
 <20210713163324.627647-47-seanjc@google.com>
 <CAAeT=FzGDUr8MK5Uf3jyUxtf+2jCf=bgG760L0mjjM3vRsXKSg@mail.gmail.com>
To:     Reiji Watanabe <reijiw@google.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On Jul 19, 2021, at 9:37 PM, Reiji Watanabe <reijiw@google.com> wrote:
>=20
> On Tue, Jul 13, 2021 at 9:35 AM Sean Christopherson =
<seanjc@google.com> wrote:
>>=20
>> Preserve CR0.CD and CR0.NW on INIT instead of forcing them to '1', as
>> defined by both Intel's SDM and AMD's APM.
>>=20
>> Note, current versions of Intel's SDM are very poorly written with
>> respect to INIT behavior.  Table 9-1. "IA-32 and Intel 64 Processor
>> States Following Power-up, Reset, or INIT" quite clearly lists =
power-up,
>> RESET, _and_ INIT as setting CR0=3D60000010H, i.e. CD/NW=3D1.  But =
the SDM
>> then attempts to qualify CD/NW behavior in a footnote:
>>=20
>>  2. The CD and NW flags are unchanged, bit 4 is set to 1, all other =
bits
>>     are cleared.
>>=20
>> Presumably that footnote is only meant for INIT, as the RESET case =
and
>> especially the power-up case are rather non-sensical.  Another =
footnote
>> all but confirms that:
>>=20
>>  6. Internal caches are invalid after power-up and RESET, but left
>>     unchanged with an INIT.
>>=20
>> Bare metal testing shows that CD/NW are indeed preserved on INIT =
(someone
>> else can hack their BIOS to check RESET and power-up :-D).
>>=20
>> Reported-by: Reiji Watanabe <reijiw@google.com>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>=20
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
>=20
> Thank you for the fix and checking the CD/NW with the bare metal =
testing.

Interesting.

Is there a kvm-unit-test to reproduce the issue by any chance?

