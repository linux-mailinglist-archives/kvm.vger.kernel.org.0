Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4315B66FCF
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 15:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfGLNON (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 09:14:13 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42042 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbfGLNON (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 09:14:13 -0400
Received: by mail-wr1-f65.google.com with SMTP id j8so5857277wrj.9
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2019 06:14:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VfT/FB70SYUZvSibHy6qxOxJHNCuzEaHFG9lYiqHVks=;
        b=NUgSq4lFWAPZiPVCyyfH9Dl9Y8BL0qsegYvGVEXDNlLXb0IqJ6HQhvbKEbiju3ahP9
         AjXAyCNM7zB1UmFgU8pHO8OSzDXyEceGAu3iXdUaeZSwhAQndvekQs5wwKpoTPEk84Rq
         3HSPT2tSUy85ZeK8h3JkJIUdWEbGRXtyCmPhcH8PHGHVqSM1sVevQw8jRODBaR/XnmtR
         sUTL9O2hfBQcRSG0UHLh0eh1/znO6ATP+5hPrUD2J+631XeC98o6v+5agm3/0jgwZzEF
         usMlCtFIxS35zrliMvhS798Us173rFwJC0HZYD2n7PhfPTxlQ8XJJWvEUES9YLNXdmbV
         Fkfw==
X-Gm-Message-State: APjAAAVIiJnQUtUgi//z2F4cyxMVoENa9G5XpBxxnXqxu4VN0rgJiztI
        qpDtwaSP+27KceEq5FBY9Frs3A==
X-Google-Smtp-Source: APXvYqxnCJN8ifBfaBldPbdVFdYWJmrV4AScCeUD8wYtYP4cKMb0VPikXLVesfil1bA6/91dAetwrw==
X-Received: by 2002:a5d:564e:: with SMTP id j14mr11365756wrw.1.1562937251761;
        Fri, 12 Jul 2019 06:14:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id b2sm10615526wrp.72.2019.07.12.06.14.10
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 06:14:11 -0700 (PDT)
Subject: Re: [PATCH 1/2] x86: kvm: avoid -Wsometimes-uninitized warning
To:     Arnd Bergmann <arnd@arndb.de>, Roman Kagan <rkagan@virtuozzo.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
References: <20190712091239.716978-1-arnd@arndb.de>
 <20190712120249.GA27820@rkaganb.sw.ru>
 <CAK8P3a3+QSRQkitXiDFLYvyYvOS+Q4sXb=xA_XPeX2O2zQ5kgw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b7da5e91-f23c-9f5d-2c61-07e7fc7af9b1@redhat.com>
Date:   Fri, 12 Jul 2019 15:14:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAK8P3a3+QSRQkitXiDFLYvyYvOS+Q4sXb=xA_XPeX2O2zQ5kgw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/07/19 15:02, Arnd Bergmann wrote:
> I think what happens here is that clang does not treat the return
> code of track the return code of is_64_bit_mode() as a constant
> expression, and therefore assumes that the if() condition
> may or may not be true, for the purpose of determining whether
> the variable is used without an inialization. This would hold even
> if it later eliminates the code leading up to the if() in an optimization
> stage. IS_ENABLED(CONFIG_X86_64) however is a constant
> expression, so with the patch, it understands this.
> 
> In contrast, gcc seems to perform all the inlining first, and
> then see if some variable is used uninitialized in the final code.
> This gives additional information to the compiler, but makes the
> outcome less predictable since it depends on optimization flags
> and architecture specific behavior.
> 
> Both approaches have their own sets of false positive and false
> negative warnings.

True, on the other hand constant returns are not really rocket science. :)

Maybe change is_long_mode to a macro if !CONFIG_X86_64?  That would be
better if clang likes it.

Paolo
