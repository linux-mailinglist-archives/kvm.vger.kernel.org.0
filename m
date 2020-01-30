Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1EB314DDA4
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 16:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgA3PQ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 10:16:29 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37877 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727190AbgA3PQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 10:16:28 -0500
Received: by mail-pg1-f196.google.com with SMTP id q127so1810813pga.4
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 07:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=62RH6i159pjCf5mRYCuM088XJbc6cGaxujQfSC3GLZI=;
        b=HVKHYXhT4o4w+zMQS2AtGEJIhzLbrsMFWeVU0nD2cG/CitiLpIQuuJaxAOu7z4dWH4
         eNPjufH7RWMjuD2L3GwJua8gb8mdq3CNT2aAJJpRLOWM/rIzlajHgoLUhTQPcdk/1al6
         qRb3C3jdFPyTsDl7d9qS4O0fHUA7bA1l+rX51PbXufUGIQN1ku2UTFCCpLcGIj14GhD1
         R4Cti3AcvjdLkQaJ9sCMsmQimr/8o+W6GuM0P2WcP24qg7oS8DH6y+0NTZBHtSnSkJ2O
         KV5u7Za5OR0Q/qg79ROIJWMJfVJKiWee2V2xGEYCru1kyaxLqfuzdolr+JGFmzhlOIOG
         iLtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=62RH6i159pjCf5mRYCuM088XJbc6cGaxujQfSC3GLZI=;
        b=W2T9KoR/0QEdjFoP1uj5fQzE8d+0RVfdfxMpN/bM1FyLosel322Blm5pTsTZe+Eg1+
         J56cZRlBQimZYzGTntV79yXn2ycnPvd4FmPx2w57DXed8VbrfwLVfw7hn2G+OMfYxqLG
         5i35ZjPrKJXyiioZWOeHlJFPjXNq+UbCi9LdPhE4I4PJmZMT+aLU3fYXvLMiUToGwab6
         R9dnY1PK88pp1/Va/xUNwJGgovJx4R0YAabtveVZGvCPrbpvmkIa3ltolaJ5IbxfPMo7
         5InWJjhNsPBWK1FqSTbTWFVSjV6g97Cy1j6xbe2GOi2MA3QHn9V69zfD4P8KBMqsJPwv
         uCfA==
X-Gm-Message-State: APjAAAWJaJX+y3F5QH1bs44LozIdqid7LDFVLxaR7AXJncyAt0vi/yqj
        Cqp5tPhD9xjAmZAdtmWvz9K1+0RLatU=
X-Google-Smtp-Source: APXvYqycZGASwVidXYxavpQ0DMrmgZbf4rvgkdr0PwMbxjAkTRUHx07KL/yoeNuPuvYzsfXRSe2bSQ==
X-Received: by 2002:aa7:9aa5:: with SMTP id x5mr5604266pfi.131.1580397387669;
        Thu, 30 Jan 2020 07:16:27 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:51ac:4d36:2f8d:8208? ([2601:646:c200:1ef2:51ac:4d36:2f8d:8208])
        by smtp.gmail.com with ESMTPSA id z26sm7221537pfa.90.2020.01.30.07.16.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2020 07:16:27 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 1/2] KVM: x86: Emulate split-lock access as a write
Date:   Thu, 30 Jan 2020 07:16:24 -0800
Message-Id: <777C5046-B9DE-4F8C-B04F-28A546AE4A3F@amacapital.net>
References: <db3b854fd03745738f46cfce451d9c98@AcuMS.aculab.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
In-Reply-To: <db3b854fd03745738f46cfce451d9c98@AcuMS.aculab.com>
To:     David Laight <David.Laight@aculab.com>
X-Mailer: iPhone Mail (17C54)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jan 30, 2020, at 4:31 AM, David Laight <David.Laight@aculab.com> wrote:=

>=20
> =EF=BB=BFFrom: Xiaoyao Li
>> Sent: 30 January 2020 12:20
>> If split lock detect is enabled (warn/fatal), #AC handler calls die()
>> when split lock happens in kernel.
>>=20
>> A sane guest should never tigger emulation on a split-lock access, but
>> it cannot prevent malicous guest from doing this. So just emulating the
>> access as a write if it's a split-lock access to avoid malicous guest
>> polluting the kernel log.
>=20
> That doesn't seem right if, for example, the locked access is addx.
> ISTM it would be better to force an immediate fatal error of some
> kind than just corrupt the guest memory.
>=20
>   =20

The existing page-spanning case is just as wrong.=
