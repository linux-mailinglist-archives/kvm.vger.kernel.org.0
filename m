Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3346D1C508
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 10:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfENIeH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 04:34:07 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37063 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfENIeH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 04:34:07 -0400
Received: by mail-pg1-f195.google.com with SMTP id e6so8249778pgc.4
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 01:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=hDxyx52ZHxybLIaQgqYkgIgM9saZTw3PtnrtMC+I7nY=;
        b=V1fySS88ojdaA5J3kVvNrhouMk585i4pA8vbBVomSrsOi8RHjcgYc7KvrkPXXZNgSV
         OLpeJryWoG+Z8+3ehqnV1obfrxQBzF2iFd1KXeVg3V1BZ2ocLrRihAV4elcX6OOBPOsH
         BridwfMxgjM1a7LU4JUrULKuAzfjFanypx5iYzIeDOj+B966bCEcMkWtBWeCaULiJHgY
         D4wopj3OIqUTsuWy/NWee71NbSfJLuDwHsyQpNoPX19EWvpgueGaASh1pibGPPqrgW7A
         nlb7D7mdsF2VCyicLPcSaXUwID0nqqYEcvVRf69YRGaV5Q0Id4jXgYWdUERJ0MIn+2mD
         a4iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=hDxyx52ZHxybLIaQgqYkgIgM9saZTw3PtnrtMC+I7nY=;
        b=et05+K1ZPkjLM2RAnk9lKoUZ65G7t0EY3SxCWXxV97rr8Kp9Na34H1qA/YboHsZ0JA
         DdFKHU0vDzwICG/Q5noTOl74xGO2AoTYsIf9IQNq3lasWZOODswAtCQdbX3W4Hf01Pa0
         g0LFLTju9I6eR/An+ci60yfQ7YcEDmFawvlBuVurbbSrtn6h/aFEEIDaSzArkegdaxfK
         FtO0fWYcZigHJN1slNVZM2Hszo7ao04zP8exsEL90d96K5OkH8u3G4cxFIJN1spkRsum
         06paoPYXpjKx1KdrT1/3jzAfkGZy/yvMTA4NE6Lx5xFNsfkP8TEciCX7YWUdXlodgO23
         YoqA==
X-Gm-Message-State: APjAAAX3eOURLNxCQqGwvqTaXPR7fs3Pj7gEdQvOIFvKucZEV6FwFpHr
        L6mwp1p210QvH2zXcr8bobjquQ==
X-Google-Smtp-Source: APXvYqxB0DOj3jPg4XTP8ysT/Cm6VZ9xZKvJqY9OspcXVOxXFZC/gIG8dRa0HQwDP7wA9IM/8Cp1og==
X-Received: by 2002:a62:570a:: with SMTP id l10mr38957276pfb.151.1557822846594;
        Tue, 14 May 2019 01:34:06 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:1d0a:33b8:7824:bf6b? ([2601:646:c200:1ef2:1d0a:33b8:7824:bf6b])
        by smtp.gmail.com with ESMTPSA id u75sm40423546pfa.138.2019.05.14.01.34.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 01:34:05 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC KVM 18/27] kvm/isolation: function to copy page table entries for percpu buffer
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16E227)
In-Reply-To: <b8487de1-83a8-2761-f4a6-26c583eba083@oracle.com>
Date:   Tue, 14 May 2019 01:34:05 -0700
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
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
        jan.setjeeilers@oracle.com, Liran Alon <liran.alon@oracle.com>,
        Jonathan Adams <jwadams@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B447B6E8-8CEF-46FF-9967-DFB2E00E55DB@amacapital.net>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com> <1557758315-12667-19-git-send-email-alexandre.chartre@oracle.com> <CALCETrWUKZv=wdcnYjLrHDakamMBrJv48wp2XBxZsEmzuearRQ@mail.gmail.com> <20190514070941.GE2589@hirez.programming.kicks-ass.net> <b8487de1-83a8-2761-f4a6-26c583eba083@oracle.com>
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On May 14, 2019, at 1:25 AM, Alexandre Chartre <alexandre.chartre@oracle.c=
om> wrote:
>=20
>=20
>> On 5/14/19 9:09 AM, Peter Zijlstra wrote:
>>> On Mon, May 13, 2019 at 11:18:41AM -0700, Andy Lutomirski wrote:
>>> On Mon, May 13, 2019 at 7:39 AM Alexandre Chartre
>>> <alexandre.chartre@oracle.com> wrote:
>>>>=20
>>>> pcpu_base_addr is already mapped to the KVM address space, but this
>>>> represents the first percpu chunk. To access a per-cpu buffer not
>>>> allocated in the first chunk, add a function which maps all cpu
>>>> buffers corresponding to that per-cpu buffer.
>>>>=20
>>>> Also add function to clear page table entries for a percpu buffer.
>>>>=20
>>>=20
>>> This needs some kind of clarification so that readers can tell whether
>>> you're trying to map all percpu memory or just map a specific
>>> variable.  In either case, you're making a dubious assumption that
>>> percpu memory contains no secrets.
>> I'm thinking the per-cpu random pool is a secrit. IOW, it demonstrably
>> does contain secrits, invalidating that premise.
>=20
> The current code unconditionally maps the entire first percpu chunk
> (pcpu_base_addr). So it assumes it doesn't contain any secret. That is
> mainly a simplification for the POC because a lot of core information
> that we need, for example just to switch mm, are stored there (like
> cpu_tlbstate, current_task...).

I don=E2=80=99t think you should need any of this.

>=20
> If the entire first percpu chunk effectively has secret then we will
> need to individually map only buffers we need. The kvm_copy_percpu_mapping=
()
> function is added to copy mapping for a specified percpu buffer, so
> this used to map percpu buffers which are not in the first percpu chunk.
>=20
> Also note that mapping is constrained by PTE (4K), so mapped buffers
> (percpu or not) which do not fill a whole set of pages can leak adjacent
> data store on the same pages.
>=20
>=20

I would take a different approach: figure out what you need and put it in it=
s own dedicated area, kind of like cpu_entry_area.

One nasty issue you=E2=80=99ll have is vmalloc: the kernel stack is in the v=
map range, and, if you allow access to vmap memory at all, you=E2=80=99ll ne=
ed some way to ensure that *unmap* gets propagated. I suspect the right choi=
ce is to see if you can avoid using the kernel stack at all in isolated mode=
.  Maybe you could run on the IRQ stack instead.=
