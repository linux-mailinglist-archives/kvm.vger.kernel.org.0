Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88BC3159DCF
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 01:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgBLAMW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 19:12:22 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:53914 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727979AbgBLAMW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 19:12:22 -0500
Received: by mail-pj1-f66.google.com with SMTP id n96so65252pjc.3
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 16:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=Pr1WOT/2gw7Ui+bqMEREVDpwEXR+a792WriIpzt4B7s=;
        b=hAaKEW5qHGtMe9K0r+9i4uWI4R3ZoMh+/psZvnhtmZTk8JOlUtnKNNqWB1Mirb283u
         tG7MUfH6JiABF4KWtCFqWV73gNqKtPEQKLHogaYe8okqGHgb41jbwJFPJwr3nCY+7Uu0
         T/koDrUYm446tI/FyX3ntJioWz/ASvkIV9/Aqins4Pg65CroAuLWyUqnU0z4/e+lzOGd
         H+tNqNK+H3oELg6622w0cA/vLZHwFQP4DADvL9QeLgEmFSa7g7ujy4w0ZORVsA3W9wdC
         1PX32M5zF1910+L6+bdy1KG8CFVS1lnzY4+mG1qBmljFTOZ+Xdg0gqx4CqnDL8Y7kDGy
         uoiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=Pr1WOT/2gw7Ui+bqMEREVDpwEXR+a792WriIpzt4B7s=;
        b=aztiGUSkZTy95Ry3nD4E17p/mxDI0lxCJu4imSiUQhmnTufwFewf9d1woYu8nhakO0
         b70nbuNU/QPz4RNYMtyimnlIbcIt0CJOZigVsT7Lut5tTHGzXPmTCFgnDPIy4E0UOY9n
         8ZQySRvh3szUd1pm+4qK15/kVpwMfjNy6JDSnoBq05AAVVs8rFYrdFAjfJXYzdhK6m8H
         86RbqhCC5vq2mCM+D4v4KgpQlBbrg0h7GY7YiJW1GurdM6L7t6r8d4Lw5cUghCXWmBL6
         rAQAyhgkcrxdsVD5GYUR56UXQc7VNu5XBYXDmuWfQXeSLmvZ3KX0khtg9GkNjYLB4PJi
         m4YQ==
X-Gm-Message-State: APjAAAXOyd3anuDipQV9bbDhJp3K9CWzM0Zv4KNwl1ECgmoDct+O8VbR
        8d1O/B3FPhdcDtN3GnaOYuTrFQ==
X-Google-Smtp-Source: APXvYqzfWf+52u5ptCvMmUlokh+ZnxotB+Jwjj8OIwwQjng66p5yI7RzfTPGOOK/x7Jm4L9EdIIjEQ==
X-Received: by 2002:a17:90a:db48:: with SMTP id u8mr6623427pjx.54.1581466341415;
        Tue, 11 Feb 2020 16:12:21 -0800 (PST)
Received: from ?IPv6:2600:1010:b06b:b0e7:939:1384:befb:d8c9? ([2600:1010:b06b:b0e7:939:1384:befb:d8c9])
        by smtp.gmail.com with ESMTPSA id r9sm5705115pfl.136.2020.02.11.16.12.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 16:12:20 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 46/62] x86/sev-es: Handle INVD Events
Date:   Tue, 11 Feb 2020 16:12:19 -0800
Message-Id: <EA510462-A43C-4F7E-BFE8-B212003B3627@amacapital.net>
References: <20200211135256.24617-47-joro@8bytes.org>
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
In-Reply-To: <20200211135256.24617-47-joro@8bytes.org>
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
> Implement a handler for #VC exceptions caused by INVD instructions.

Uh, what?  Surely the #VC code can have a catch-all OOPS path for things lik=
e this. Linux should never ever do INVD.=
