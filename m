Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A47A131919
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 21:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgAFUQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 15:16:16 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:47043 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbgAFUQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 15:16:12 -0500
Received: by mail-io1-f65.google.com with SMTP id t26so49964549ioi.13
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2020 12:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3GDssrbOe7NhLbjc31VdhTYmJ4APDSoT1K50tZqydr0=;
        b=MyzLiAmqcB1hgGyIZ2kA3LgpI/ZSjANJzdcs1E5c5RVxxQpmwsDvEnjbnSPf9jbIaW
         aZNpmuz3zw/Z5pUWgUqycvYCSe9haPGYbOfusaBHGgskL1dn/gdIuMkH/QAyWiqepbOQ
         c5sxvDp55U/n1xAMz7p66SDcczWPcU8K9P0u3Fz0pCxmXjd9qEOHeSgngs6MKjOXjDeV
         /Zy3JIpe6USdeCiSjEpNFWN5kUIwJBp0BlHVQHLIdIhny5pNstWpDTQ200QnGdA7PQ9T
         y/8mJlAL5lwTCg/LPC8HLJ1SD1ccAwJ9MMZBjsqtvgzohBC0B6jB2CCZzwYJMQBTK26c
         ekXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3GDssrbOe7NhLbjc31VdhTYmJ4APDSoT1K50tZqydr0=;
        b=imZb8sM85D/2Y5mxAhk8vAakVKB43CMMVx4VUpcl3KHOKMbI/QmDRyWheYMGFtsCvY
         vITp4urm0ksdk8jFTfgjmviUPXeF9kygadJo8ZtsFKFVSIgfw2uF1jTwJ/32cnSHXaIr
         zFm8nWqwd3tITxwSWbhEbiYDpcuSbCuG2ib2OcznGob3Orn3Y+bL7+mKw3pW7Cxp3umz
         qyInyomY6cg5EtLr9B7UNYA2iKW4sO7Lg/uCEmzwjDVPZVIZAMRxcSzyByZmjqj0bwNg
         cLl+6OO3b80GfXXDezO6tQjjp16ixzSMDDzcfTLokjzL9FHK8frOT4Hu1KgaXrxiwlDr
         y8bQ==
X-Gm-Message-State: APjAAAX9TRimwIsPxX8bR9jsjxQkABlsU4s7ddQknc4Epu5hnAFpF1qP
        /OZjuZ8QpliZLHpMWAR9AnsbalrQNgGcCvWXca2kmA==
X-Google-Smtp-Source: APXvYqwR3dKEBj0osCR3tSkV2tqMs2o30CYmbwv2DVudSSvgXPx/sQElULEAO3+ccHMeZ91xIWFF4B+jFbSXGtFy/ig=
X-Received: by 2002:a6b:740c:: with SMTP id s12mr30491676iog.108.1578341771601;
 Mon, 06 Jan 2020 12:16:11 -0800 (PST)
MIME-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com> <20191211204753.242298-2-pomonis@google.com>
In-Reply-To: <20191211204753.242298-2-pomonis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jan 2020 12:16:00 -0800
Message-ID: <CALMp9eQhU5WdDi5h+stS7oCmJSOXrGBhEAGx0mdPvjHV35R9=w@mail.gmail.com>
Subject: Re: [PATCH v2 01/13] KVM: x86: Protect x86_decode_insn from
 Spectre-v1/L1TF attacks
To:     Marios Pomonis <pomonis@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nick Finco <nifi@google.com>, Andrew Honig <ahonig@google.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 11, 2019 at 12:48 PM Marios Pomonis <pomonis@google.com> wrote:
>
> This fixes a Spectre-v1/L1TF vulnerability in x86_decode_insn().
> kvm_emulate_instruction() (an ancestor of x86_decode_insn()) is an exported
> symbol, so KVM should treat it conservatively from a security perspective.
>
> Fixes: commit 045a282ca415 ("KVM: emulator: implement fninit, fnstsw, fnstcw")
>
> Signed-off-by: Nick Finco <nifi@google.com>
> Signed-off-by: Marios Pomonis <pomonis@google.com>
> Reviewed-by: Andrew Honig <ahonig@google.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Jim Mattson <jmattson@google.com>
