Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C12A3159DD8
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 01:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbgBLAPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 19:15:10 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35848 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728017AbgBLAPK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 19:15:10 -0500
Received: by mail-pf1-f194.google.com with SMTP id 185so283305pfv.3
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 16:15:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=5W5I2/tliGJReRotTu8QzhtFOiqoykAjsJm5H9qMpkY=;
        b=aLqA2Qf2b5R0VeGpxHSJiz0ggv1GoXh8FkTKNgcixlXD0g0v+K4kZAA5jZFyv0sCI/
         k0dJCcEfwvaKmSPcMS6sYRNmiJipBsJiNcMrzUp11mrEiAinkTJ+ko4yfFP9yXEn4y3s
         dyA96FXoI6LjOw0qu4i2uDrCTfErIfqttgHTCx6WrFtH//2lrSt6dZyYWS4U6K1kX9BV
         xuRArF8oKa7WeB6uDD1J0XE+ev7h8H/ZUv5ik+syqG8rdvvCV3KqoPQegqqiprtWD2kf
         PStGiVD5hcbq6hw+dhNe5Y4uO5at0WVISTk9JNb50USIQWVd+3kKZo+3vyNgEyTZ1xHc
         bl5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=5W5I2/tliGJReRotTu8QzhtFOiqoykAjsJm5H9qMpkY=;
        b=KHDjZLvNuxIIkv+Ca/B3zWUZZ+MY/1BtqvU+Uh9fyQblbkiiwCyEsCUpCburGtc1hk
         xFxAIZF3n+pTHEWoPuETz4cqyf43cQvQcAlORaUPmaorWErzat5207lnBXil5n0icY0w
         SsLdv9YlFSfltXp3quf19bT7KLtoHwTbuqaMwH8eJlk2ZlUzc7g7X0NE3dRrL1m7hvd7
         RmYMXVg/9LlIeiDzuIHbO9GUNfQv0O9gYQlzJFslOuQpu80Q/5F1ow52ZUOXTffi52ym
         ITg3MRwHHe+5Y9HpPpennhWwVBPMOwQg+AggCIXnGaNYR/SktM1aXoSdBbLXlAB52pab
         uyjw==
X-Gm-Message-State: APjAAAVSUrivmcKYHGPjS39buxI8yoZBdPnMcMiauTE+3zPL8Wjr1wEg
        o79i8ZNMIdaaUbWXBp/9N8tpzw==
X-Google-Smtp-Source: APXvYqwKbe3ZKkA0o3k4bVYltcFG8rs9iaVtk+dJZWxF/gbWUmftd2FJbB2uXTGUG7Se4Mvk4yh6GA==
X-Received: by 2002:a63:480f:: with SMTP id v15mr9328311pga.201.1581466509526;
        Tue, 11 Feb 2020 16:15:09 -0800 (PST)
Received: from ?IPv6:2600:1010:b06b:b0e7:939:1384:befb:d8c9? ([2600:1010:b06b:b0e7:939:1384:befb:d8c9])
        by smtp.gmail.com with ESMTPSA id s6sm5044170pgq.29.2020.02.11.16.15.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 16:15:08 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 50/62] x86/sev-es: Handle VMMCALL Events
Date:   Tue, 11 Feb 2020 16:14:53 -0800
Message-Id: <DC865D59-CAD2-4D1C-919B-1C954B1EFFB1@amacapital.net>
References: <20200211135256.24617-51-joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Juergen Gross <JGross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>
In-Reply-To: <20200211135256.24617-51-joro@8bytes.org>
To:     Joerg Roedel <joro@8bytes.org>
X-Mailer: iPhone Mail (17D50)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Feb 11, 2020, at 5:53 AM, Joerg Roedel <joro@8bytes.org> wrote:
>=20
> =EF=BB=BFFrom: Tom Lendacky <thomas.lendacky@amd.com>
>=20
> Implement a handler for #VC exceptions caused by VMMCALL instructions.
> This patch is only a starting point, VMMCALL emulation under SEV-ES
> needs further hypervisor-specific changes to provide additional state.
>=20

How about we just don=E2=80=99t do VMMCALL if we=E2=80=99re a SEV-ES guest? =
 Otherwise we add thousands of cycles of extra latency for no good reason.=
