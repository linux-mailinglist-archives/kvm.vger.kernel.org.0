Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBE4278FA3
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 19:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbgIYRbS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 13:31:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33937 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729620AbgIYRbS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 13:31:18 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601055076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kgoDrp/Imua9rkBntWaYSIW0+QvG7ttl6BenhB/EUzM=;
        b=cj00RDE6mNraJcMoE0SAPDfNQWhAYVR6rz+86Szbz7KxdDtXdLuvlU0RZWqJPvpjsDbwDx
        gbjZn0lfh3Jck08CZ61W2TYSfXMO0QsZs570729zOtFGfajAr7q9bNzY82W2Lm9GMXMlOw
        BcHJjY/ijbhinhBEN1WuUMVl6BxonH4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-Gn9wk9XqNHyWoEVBzaMdLw-1; Fri, 25 Sep 2020 13:31:14 -0400
X-MC-Unique: Gn9wk9XqNHyWoEVBzaMdLw-1
Received: by mail-wr1-f69.google.com with SMTP id y3so1325925wrl.21
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 10:31:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kgoDrp/Imua9rkBntWaYSIW0+QvG7ttl6BenhB/EUzM=;
        b=ETrCQYoA+7G5+e0qLujv8nDE5y1UCrSAl0bo3mO1f89Tb5Umx6Pk6vHjgF6pbG4wxT
         lrE5H8dd3kerge20nX4T9z5s2pfpXwBypIv7wxI64RGlO95Dfq6FJIdMSd5VF9dlrqWM
         O5q2ixS6qUxlBbREe+nY9Xw8McburyexGi7MVi7Oz9EEH9L6A51ReJn8WdS9zBx1v8FR
         fUVPlMjcoLDFVVQm52kFccDmaHT1f97AGrx3U/J2jMyk4dSNMy61GmafuCFAEUqYsDWx
         5Tf3OHRR9gxj6v4p1wptBepckcUYoLxPDpylU8AUnyUK3xUzO/7FH95j0J4/3EMOFmE5
         pgvQ==
X-Gm-Message-State: AOAM530uDQd6fdH/qkLIexrufIRSDqgvi6umCGGJsRXlFUjjfc7MA860
        Sp7pgD5nIk9F+sDYrUe9IgmywVS2QRW4mKS6hZJu6FoDDllM4jRcBA7wk2bDtRMCTVdigtkWR9+
        hS+BJ9lVYUuVy
X-Received: by 2002:a1c:4c0d:: with SMTP id z13mr4020259wmf.113.1601055073294;
        Fri, 25 Sep 2020 10:31:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPTDkbJwYC2USu6HcpR/XlLvGZo9MtasrQB1dk8DmaTxAl37UdJ+X+8ppmKhjjYed/hBPwxQ==
X-Received: by 2002:a1c:4c0d:: with SMTP id z13mr4020240wmf.113.1601055073075;
        Fri, 25 Sep 2020 10:31:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id p11sm3389322wma.11.2020.09.25.10.31.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 10:31:12 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] INVD intercept change to skip instruction
To:     Jim Mattson <jmattson@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <cover.1600972918.git.thomas.lendacky@amd.com>
 <CALMp9eS2C398GUKm9FP6xdVLN=NYTO3y+EMKv0ptGJ_dzxkP+g@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e8aa489b-493c-87d2-3d26-a34d6eef810f@redhat.com>
Date:   Fri, 25 Sep 2020 19:31:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eS2C398GUKm9FP6xdVLN=NYTO3y+EMKv0ptGJ_dzxkP+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/20 23:20, Jim Mattson wrote:
> On Thu, Sep 24, 2020 at 11:42 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> This series updates the INVD intercept support for both SVM and VMX to
>> skip the instruction rather than emulating it, since emulation of this
>> instruction is just a NOP.
> 
> Isn't INVD a serializing instruction, whereas NOP isn't? IIRC, Intel
> doesn't architect VM-entry or VM-exit as serializing, though they
> probably are in practice. I'm not sure what AMD's stance on this is.

Of course that isn't changed by this patch, though.

Queuing both, but a clarification would be useful.  The same applies
even to CPUID.

Paolo

