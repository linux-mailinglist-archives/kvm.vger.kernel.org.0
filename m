Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16C301CC12
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 17:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbfENPnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 11:43:47 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39511 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbfENPnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 11:43:47 -0400
Received: by mail-pl1-f196.google.com with SMTP id g9so8462185plm.6
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 08:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=v0nvVqgy68rs5XKTL1qS0XTg9vbvJX75DMTfHz65o7k=;
        b=o4uo3BL2FJTiVqjqCYWGK7TMMV+lwcOVDCNWJTqe+tsflDaF1yLX/e9s+YSEdV9a/X
         0LABKAoi0StS36W6oGQpGj2P9Ct672agdHbaJD3SQjoZ0jW0NpD1tvHmfqZg3k3gEIMm
         pD3Y0PN2veoFVEcAjudbuFBK4ihHBhxjGmFrArDMaQOSdIoNf0wbzeoWhlxvo11h8EQj
         5+ePJDr+YQ3YkBtn6wnDJCoLAujldWH4NLM1lyC6LyWFIUDCdOPrWhUQBDcmMaKmwirX
         GLQ96LzLwwi7s2MUdjqt+joWr3rsVAX/g44QiL28zCZdC3f8nx6CKfXtYBWsA//YqsXb
         s4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=v0nvVqgy68rs5XKTL1qS0XTg9vbvJX75DMTfHz65o7k=;
        b=EQVEHgreeWBMNrQuqrcbluXwFX2HqKzHa8MxhW/MguNQkHSgc0zUJSPlGVeWHiVYnQ
         bvdR4w0IXHiNZntyf6Kx8nwuKfF8cZtYwdUfthjHmw+n8m54r1JOzbRwMTz8eU3wiOax
         TQIIzc/7/mKZjRcnDxI8I76hC2Xy6wxF5YJTvlwfGISkUWPKVN6JKhBC0O0qurPluczJ
         FwgcLN+VxekpvRD3bC/xJM8niALfwwTeawlE5KczK5sVo0z2j/HJQeDr77SQ+lxT1gO2
         g2MzMbtY6YlcNWp2+yQ7WUpERCXzDpt6vPryrhy+tlDJWyVqBCL/KdQIp/G74BLr2bNB
         lzcg==
X-Gm-Message-State: APjAAAV6Nbld7r5wGWpZHf/3j/4aaaKp8TiAIvsacpwu2Pxt/cOegc2k
        MSXEMAnvs4X6KQQOS/ISHnDbig==
X-Google-Smtp-Source: APXvYqzfFBQAOq4cxgvOLcK8bcyy/NCFnT7eLClak8c7V4eglmQgE2DbsTwqSnHYj5t5cw7CJVy3Wg==
X-Received: by 2002:a17:902:4203:: with SMTP id g3mr19140823pld.288.1557848626663;
        Tue, 14 May 2019 08:43:46 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:1d0a:33b8:7824:bf6b? ([2601:646:c200:1ef2:1d0a:33b8:7824:bf6b])
        by smtp.gmail.com with ESMTPSA id o2sm36069339pgq.1.2019.05.14.08.43.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 08:43:45 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC KVM 24/27] kvm/isolation: KVM page fault handler
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16E227)
In-Reply-To: <95f462d4-37d3-f863-b7c6-2bcbb92251ec@oracle.com>
Date:   Tue, 14 May 2019 08:43:44 -0700
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Jonathan Adams <jwadams@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8DBEACE9-AB4C-4891-8522-A474CA59E325@amacapital.net>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com> <1557758315-12667-25-git-send-email-alexandre.chartre@oracle.com> <20190513151500.GY2589@hirez.programming.kicks-ass.net> <13F2FA4F-116F-40C6-9472-A1DE689FE061@oracle.com> <CALCETrUcR=3nfOtFW2qt3zaa7CnNJWJLqRY8AS9FTJVHErjhfg@mail.gmail.com> <20190514072110.GF2589@hirez.programming.kicks-ass.net> <95f462d4-37d3-f863-b7c6-2bcbb92251ec@oracle.com>
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On May 14, 2019, at 8:36 AM, Alexandre Chartre <alexandre.chartre@oracle.c=
om> wrote:
>=20
>=20
>> On 5/14/19 9:21 AM, Peter Zijlstra wrote:
>>> On Mon, May 13, 2019 at 07:02:30PM -0700, Andy Lutomirski wrote:
>>> This sounds like a great use case for static_call().  PeterZ, do you
>>> suppose we could wire up static_call() with the module infrastructure
>>> to make it easy to do "static_call to such-and-such GPL module symbol
>>> if that symbol is in a loaded module, else nop"?
>> You're basically asking it to do dynamic linking. And I suppose that is
>> technically possible.
>> However, I'm really starting to think kvm (or at least these parts of it
>> that want to play these games) had better not be a module anymore.
>=20
> Maybe we can use an atomic notifier (e.g. page_fault_notifier)?
>=20
>=20

IMO that=E2=80=99s worse. I want to be able to read do_page_fault() and unde=
rstand what happens and in what order.

Having do_page_fault run with the wrong CR3 is so fundamental to its operati=
on that it needs to be very obvious what=E2=80=99s happening.=
