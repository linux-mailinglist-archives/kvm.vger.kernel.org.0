Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDFDA159C8F
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 23:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgBKWun (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 17:50:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:34038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727041AbgBKWun (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 17:50:43 -0500
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5F07215A4
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 22:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581461443;
        bh=XV1MMCtQP/VUtU4M6HqgIW/VlmatPHwn+NBw1GlBfxE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ploUTxCjV3VZ6tRSQcERV/2TkHxK4a61WSt0RGq4gUTpKMu1W1hLhTbWDXl30txGR
         vCmP4QO6itTbAGDg+EqexNRphI3QMVIY4Q3Wz7WZ0o5H7abZnHtqTVSRuxOqn5o2dF
         7lbJQQGylkDDRs7ouXBoO8wkt7ZIl+bnEt2iQi0U=
Received: by mail-wr1-f48.google.com with SMTP id z3so14628813wru.3
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 14:50:42 -0800 (PST)
X-Gm-Message-State: APjAAAVN5bhPn2ADCScAuSXPkl4hG1yRwbrAE8OJikHMkYX/uDwXjGhJ
        I8f/LTlEq0/W9Zp6eeBk6OZK2SUWOX8JRkIdtzHgdw==
X-Google-Smtp-Source: APXvYqzqJ1AlSDY2ZRDO05AMScFqgtaEyb1UuVzqt0WKNedpg8GD4u5J3WkIoYB+03YMjv6Q0h3O47HFfxgY+9Q1m0c=
X-Received: by 2002:adf:a354:: with SMTP id d20mr10861134wrb.257.1581461441006;
 Tue, 11 Feb 2020 14:50:41 -0800 (PST)
MIME-Version: 1.0
References: <20200211135256.24617-1-joro@8bytes.org> <20200211135256.24617-63-joro@8bytes.org>
In-Reply-To: <20200211135256.24617-63-joro@8bytes.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 11 Feb 2020 14:50:29 -0800
X-Gmail-Original-Message-ID: <CALCETrWV15+YTGsEwUHBSjT2MYappLANw4fQHjgZgei2UyV1JQ@mail.gmail.com>
Message-ID: <CALCETrWV15+YTGsEwUHBSjT2MYappLANw4fQHjgZgei2UyV1JQ@mail.gmail.com>
Subject: Re: [PATCH 62/62] x86/sev-es: Add NMI state tracking
To:     Joerg Roedel <joro@8bytes.org>
Cc:     X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 5:53 AM Joerg Roedel <joro@8bytes.org> wrote:
>
> From: Joerg Roedel <jroedel@suse.de>
>
> Keep NMI state in SEV-ES code so the kernel can re-enable NMIs for the
> vCPU when it reaches IRET.

This patch is overcomplicated IMO.  Just do the magic incantation in C
from do_nmi or from here:

        /*
         * For ease of testing, unmask NMIs right away.  Disabled by
         * default because IRET is very expensive.

If you do the latter, you'll need to handle the case where the NMI
came from user mode.

The ideal solution is do_nmi, I think.

if (static_cpu_has(X86_BUG_AMD_FORGOT_ABOUT_NMI))
  sev_es_unmask_nmi();

Feel free to use X86_FEATURE_SEV_ES instead :)

--Andu
