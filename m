Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF58A11D4AE
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 18:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730261AbfLLR51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 12:57:27 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:45739 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730279AbfLLR5W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 12:57:22 -0500
Received: by mail-io1-f65.google.com with SMTP id i11so3692772ioi.12
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 09:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z3b25UQSnY6IqzYufZw5HPv7RWsFnuJ1qSwiqH0n/5k=;
        b=P/NXCOyuvKPRWV08VvBA1CWwjXOq2454qr5DFs1i0dx4F3LwmHgj/7p/j/+AGA99YD
         XIWPe87cEztItjq6Zn8pXyHQMZzUEyk8kqXBqi68MgB1GzmECBjHyMdn1YF8qh4niHqF
         15iEyVZAXPani4kohcMWSIPOP56G3yUYSGRJL25s3s84BNsfC5kk8KqEHY45RIJQ+km+
         7nHZhB/fWqMWEC6MkyRtbCJy0SemmaaZZQ7fv7RUOd6VaANEf7I7bBZlkcwJwTtSaJyL
         vQnVIlgojZJ3h4eqkao2clnBKHHZBF/oNu3jwsKJCm7C8CENNAUPifuciLGZ/2ZT8P21
         DDpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z3b25UQSnY6IqzYufZw5HPv7RWsFnuJ1qSwiqH0n/5k=;
        b=fUoCX2P5KUpPVHmfiUu61gsxz94lXMeKv5C7+RN7KQoWiZ2S25eXJQvXvtAkx87TaN
         Hs2b9KYkLcLsFo7QGWUDhaCJcmsaKWo0RMLbxgBmhzAspHIad0KLUa9DWpQV4H552ptU
         qR4dIF/hBNL8RBjiUFanXYxwL9RaraXa77UQWCwAZT+NHd5IjOvy7kqPTi95ZlpBAIBE
         vWkQaYjfyOfkHmmVCMPJrU5HDnIImbY1oBZVUZQNeBFf5aor471a8DiEWBO6YToWqncP
         uxNQaAw+yI6B5h6eeNPKEBMEhIiE3DaiKvwzEHZfl+rdvdAPTuCgDJ9TpNJXK9jDtyxz
         wMZw==
X-Gm-Message-State: APjAAAXwnvWzUkPgicTdyxtpvwmT5YsgcSarqQPGO/cHO8PfjGsSgeOJ
        CNzzIIr5EEDxjWRv/BuFEsqHJZg0RTCmAjcHdAPO5g==
X-Google-Smtp-Source: APXvYqyPE6NbezzK+SCpWx81FOcItGOWVU3L02OQJNEvkysZZsXSDO4rXcsGBPHVc3pNcmN4ZTMpi09J8E7N8GzXb0A=
X-Received: by 2002:a5e:9b15:: with SMTP id j21mr3746698iok.108.1576173439923;
 Thu, 12 Dec 2019 09:57:19 -0800 (PST)
MIME-Version: 1.0
References: <20191128014016.4389-1-sean.j.christopherson@intel.com>
 <20191128014016.4389-12-sean.j.christopherson@intel.com> <20191212122646.GE4991@zn.tnic>
 <d0b21e7e-69f5-09f9-3e1c-14d49fa42b9f@redhat.com> <4A24DE75-4E68-4EC6-B3F3-4ACB0EE82BF0@oracle.com>
 <17c6569e-d0af-539c-6d63-f4c07367d8d1@redhat.com> <20191212174357.GE3163@linux.intel.com>
 <52dd758d-a590-52a6-4248-22d6852b75cd@redhat.com> <DA429131-7A4C-4B74-A020-6CE7622ED2F8@oracle.com>
In-Reply-To: <DA429131-7A4C-4B74-A020-6CE7622ED2F8@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 12 Dec 2019 09:57:08 -0800
Message-ID: <CALMp9eRAYj=dKDtnPymkUA_OOMv+9a4WdPNt4hdpFtBgzwNA9w@mail.gmail.com>
Subject: Re: [PATCH v4 11/19] x86/cpu: Print VMX flags in /proc/cpuinfo using VMX_FEATURES_*
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>,
        Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
        Len Brown <lenb@kernel.org>, Shuah Khan <shuah@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-edac@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 12, 2019 at 9:53 AM Liran Alon <liran.alon@oracle.com> wrote:

> Why should CPU VMX features be treated differently than standard CPUID deduced features?

Do we have the right Intel people on the recipient list to answer this
question? Presumably, Intel felt that this information should be
available in supervisor mode only.

Sean?
