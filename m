Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C04C6FE0AE
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 15:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfKOO5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 09:57:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21769 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727380AbfKOO5T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 09:57:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573829838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=7yaQNJ8X54UYsPLTvNej/Nq1sCyhyf+pI+xb8LZA29U=;
        b=d6qE0jX2tYh3/1SUYMOD5DyOneoxK7Hmt14NWtpJ2FOikMqCKSo1SaQtnnrvXH05zmM7h3
        GSMR+jwIB5NJUkCgJQjA42CJ+g1nav8hXPSZf0ewuDptrykQzfA4RA1P322tRytq4FYtic
        hPrg81NSc71yeOOYlBnQCZwrJ+pwesU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-qQonIUDyNZSAJByEldESMg-1; Fri, 15 Nov 2019 09:57:17 -0500
Received: by mail-wr1-f71.google.com with SMTP id y1so7862059wrl.0
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 06:57:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NHSaRMkpKeY2SxGajobYzdTdWRHhMF96bMRzVGwmE50=;
        b=dBuSEWwLmfUGE5Z3nxCASXEo591nD7VGWZztC+xJbrfQt2FFV1RRbDtvnJmvpWhy5u
         5bBCKOZkrWh1Q9Z5JZcQjv/X0Zdhxky0MbiEDERKjRa39sRcU2LSrtX2crNjZmbaU2x8
         Mgco541rw7+X7779lKitTBLgf+jC2VZnWVWZqKlaTQYlqlJONV5J54zm4Mhks8MxlZsL
         0kVLzwaiuIhCxmKP2kjj5+MVBf6MFV4ZYGLGpugAWTlT3k7IedcsuoFGzxGriyaCz/7r
         err0R3MbLTSZt+mr4tedENQfY/i+Tx57qdWHuUSJpfJxdQwGPkQ3m6AkJT4EUTZlxZeX
         qGhw==
X-Gm-Message-State: APjAAAUUIVWK8e6FFcdbfoBLZFsKOV+iYn88DbY9lGm9mgW+G3Wl5OD0
        JkXVA0WSnK9v6J7Bco9OEEmrOHY5spys1jZHHkLqduIGh3Yi+HxATcjrpccbfV8oHGzBz6+eDRI
        0ilSvgwQxqcAW
X-Received: by 2002:a5d:490c:: with SMTP id x12mr1693147wrq.301.1573829835878;
        Fri, 15 Nov 2019 06:57:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqz/sxtOZl8KvdtwlMrKr6awpeczHh+vXUft8Nj2dpsHdx/Hp8pQi/9ANx5xLxmrcSoLr6uWzQ==
X-Received: by 2002:a5d:490c:: with SMTP id x12mr1693120wrq.301.1573829835587;
        Fri, 15 Nov 2019 06:57:15 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:857e:73f6:39a8:6f94? ([2001:b07:6468:f312:857e:73f6:39a8:6f94])
        by smtp.gmail.com with ESMTPSA id i25sm6551445wmd.25.2019.11.15.06.57.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 06:57:15 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] x86: Fix the register order to match
 struct regs
To:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>
References: <20191025170056.109755-1-aaronlewis@google.com>
 <CAAAPnDFcS+SCrLK1wGGEiBBc+yy1bGOKsw4oKnXgXFwUb9p0CQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <6cc377cf-289e-08d8-d2d0-e57535df1574@redhat.com>
Date:   Fri, 15 Nov 2019 15:57:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAAAPnDFcS+SCrLK1wGGEiBBc+yy1bGOKsw4oKnXgXFwUb9p0CQ@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: qQonIUDyNZSAJByEldESMg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/11/19 15:27, Aaron Lewis wrote:
> On Fri, Oct 25, 2019 at 10:01 AM Aaron Lewis <aaronlewis@google.com> wrot=
e:
>>
>> Fix the order the registers show up in SAVE_GPR and SAVE_GPR_C to ensure
>> the correct registers get the correct values.  Previously, the registers
>> were being written to (and read from) the wrong fields.
>>
>> Reviewed-by: Jim Mattson <jmattson@google.com>
>> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
>> ---
>>  x86/vmx.h | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/x86/vmx.h b/x86/vmx.h
>> index 8496be7..8527997 100644
>> --- a/x86/vmx.h
>> +++ b/x86/vmx.h
>> @@ -492,9 +492,9 @@ enum vm_instruction_error_number {
>>
>>  #define SAVE_GPR                               \
>>         "xchg %rax, regs\n\t"                   \
>> -       "xchg %rbx, regs+0x8\n\t"               \
>> -       "xchg %rcx, regs+0x10\n\t"              \
>> -       "xchg %rdx, regs+0x18\n\t"              \
>> +       "xchg %rcx, regs+0x8\n\t"               \
>> +       "xchg %rdx, regs+0x10\n\t"              \
>> +       "xchg %rbx, regs+0x18\n\t"              \
>>         "xchg %rbp, regs+0x28\n\t"              \
>>         "xchg %rsi, regs+0x30\n\t"              \
>>         "xchg %rdi, regs+0x38\n\t"              \
>> @@ -511,9 +511,9 @@ enum vm_instruction_error_number {
>>
>>  #define SAVE_GPR_C                             \
>>         "xchg %%rax, regs\n\t"                  \
>> -       "xchg %%rbx, regs+0x8\n\t"              \
>> -       "xchg %%rcx, regs+0x10\n\t"             \
>> -       "xchg %%rdx, regs+0x18\n\t"             \
>> +       "xchg %%rcx, regs+0x8\n\t"              \
>> +       "xchg %%rdx, regs+0x10\n\t"             \
>> +       "xchg %%rbx, regs+0x18\n\t"             \
>>         "xchg %%rbp, regs+0x28\n\t"             \
>>         "xchg %%rsi, regs+0x30\n\t"             \
>>         "xchg %%rdi, regs+0x38\n\t"             \
>> --
>> 2.24.0.rc0.303.g954a862665-goog
>>
>=20
> Ping.
>=20

Pushed, thanks.

Paolo

