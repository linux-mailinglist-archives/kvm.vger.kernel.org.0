Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0640C662A3
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 02:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730453AbfGLAGB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 20:06:01 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:32849 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728102AbfGLAGB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 20:06:01 -0400
Received: by mail-io1-f65.google.com with SMTP id z3so16634527iog.0
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 17:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=62nH5oWkGzOQ06SAu95rykYn8etGFCzWFiF4NkIvxBQ=;
        b=x6iGf4L5yWS+TipgGMZaTstAJSFZHmt4jOCyVxJXA05tn4AvQqO7XQ9jA/D7ymwATG
         PWuN9SzO9zG1m+PEuyKII10uOSL9gg/O57hI2huctP6Og913oIrwhV2UID0IFwMymSEZ
         pSxo0Php2i+/JqZ9P5rh6HvaKN6HtjCSw/3qwxiVDhGnI3DArpoc4m0F9IctT6DD1Di1
         wu4AMH5pCym6cMoCHPWOZAcSY3xU4Avs8wRgU0TwfTmIVmwdhlW+aos08799MA2ewuTT
         YwY5vBW2TokBxQCwis69AwDoXaOek1HHnLZ9u/AICEFSungrKFs4ck9yFBleKW797VV8
         NCMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=62nH5oWkGzOQ06SAu95rykYn8etGFCzWFiF4NkIvxBQ=;
        b=W/VgpJka/kPIpRiGFMGP4rCqDEiCDOcSCa66BoK5+ucHHGNEdj27EOnJQ2G5kZh2lw
         rtqJSFgtQGa9bIzo3aEn8NXnfsLJuQfI6FAOF0NvonjAKkEVLAj646BtPRbzo1YIqyEe
         8KrAQAQe8zcC5SBEOJtbIU8us2O1SDRZjTlf9/0XilV5XuY5+bsXm1WkQnJRMys1cA2u
         Gj5vEWp67qONOrIGMBrg+GMGhwwEaYdWEzYV1WOhY4gMlZmppsu4AhRHIHjcDsD9OqLg
         OiKAbWkHi3SyJthUNZG1ORXjZv+iEXbbQZKgH9G98ZuJ/tI5GHTAV+xHwtFuT1eDPL+c
         LlHQ==
X-Gm-Message-State: APjAAAUYuaj7ZA2VrX7FqaxsP/a3HUuvulVKmD3IBP+15+xjNfSKZ5C+
        s0wcZYAvyB8JkdIMbUVgmWhORg==
X-Google-Smtp-Source: APXvYqyEv1kc809mAGLveMhoHxeqWbWWXmWJlBsCCsN3LPsii0kASeeYoYXmRIGy/00rllieyCi4zA==
X-Received: by 2002:a02:5a89:: with SMTP id v131mr8057345jaa.130.1562889960481;
        Thu, 11 Jul 2019 17:06:00 -0700 (PDT)
Received: from ?IPv6:2601:281:200:3b79:24dc:faf7:acdc:387a? ([2601:281:200:3b79:24dc:faf7:acdc:387a])
        by smtp.gmail.com with ESMTPSA id l5sm12084721ioq.83.2019.07.11.17.05.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 17:05:59 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC v2 02/26] mm/asi: Abort isolation on interrupt, exception and context switch
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16F203)
In-Reply-To: <1562855138-19507-3-git-send-email-alexandre.chartre@oracle.com>
Date:   Thu, 11 Jul 2019 18:05:58 -0600
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        jan.setjeeilers@oracle.com, liran.alon@oracle.com,
        jwadams@google.com, graf@amazon.de, rppt@linux.vnet.ibm.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <B8AF6DF6-8D39-40F6-8624-6F67EDA4E390@amacapital.net>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com> <1562855138-19507-3-git-send-email-alexandre.chartre@oracle.com>
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On Jul 11, 2019, at 8:25 AM, Alexandre Chartre <alexandre.chartre@oracle.c=
om> wrote:
>=20
> Address space isolation should be aborted if there is an interrupt,
> an exception or a context switch. Interrupt/exception handlers and
> context switch code need to run with the full kernel address space.
> Address space isolation is aborted by restoring the original CR3
> value used before entering address space isolation.
>=20

NAK to the entry changes. That code you=E2=80=99re changing is already known=
 to be a bit buggy, and it=E2=80=99s spaghetti. PeterZ and I are gradually w=
orking on fixing some bugs and C-ifying it. ASI can go on top.

