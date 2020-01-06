Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A84DD131924
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 21:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgAFURf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 15:17:35 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:44926 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgAFURc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 15:17:32 -0500
Received: by mail-il1-f195.google.com with SMTP id z12so7171690iln.11
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2020 12:17:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2CX2u59yxqQEiQeQX3TdwASVbTfuTtyRiCwtCS2hV9M=;
        b=r8n4416RC0OjW2zQZKUoUGwBPq+fLIjkEFiWRwI2k9OC6xfH8LexxBEoS0JBAKL4ep
         glcWvgtALerSfVE7MX3hVQsEzoDEMEvdBi2XV5OuFjQ/+rHFaGLv0Y6TVIKJeGE2K4xr
         hPGAu2ZsOO47P84w3U2lb5Pq6FkNZ97fG315dOqz+ZHZ92dKtbrauczGHZ4UiFER5Qzw
         tvRcP0oEPyL8O/VjBoyZq1h3n8jcz936VNWZIW7jJO35SZiO6p4mFIjXs27PSe3mz4hr
         vLfja4o0UrgiZvGv7Wem6QD7qJ7tYB3zq9tgK/CX8e77skiBewq9ETOr5AZrOs8zMWm2
         1CWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2CX2u59yxqQEiQeQX3TdwASVbTfuTtyRiCwtCS2hV9M=;
        b=olKHvGIC7ogwth/c4N2RpH4Ip+n+eHf6DdCpODAAO4NXFj8WWfjpQ/RjCaUxEgo3Pe
         84Egyi6B9BTGwMKOi1ieG9zvBgqwhb2fe4lo6IGcxAE7hBbvNzNmh14FCq2QEoLTXYYY
         xZdiX5ArXtK0XU3OObYXRdXJYpWzOV00WYK1DiZ5n9HE0UdROzH7YGa35U8T5wGN+rsE
         11N3yEqwZuSt7uZbum/vBko/H+epb2fNo58uORBX0zDT+GKm9msXmTtO2Lk2i89tFMpe
         b8vnOAmxf9zp2iEUJ28EzfOvGz9Lteauev5xpJWLaXgomFS/gf84+90v0bUs9Fl+Xkz0
         yBtQ==
X-Gm-Message-State: APjAAAV/9xXum9AtOzI8bH4n7+7mjtgNv+G1qfUS8Ej5F7l+kPfjKSLK
        /NtAGpyVwAZVhcCWhyBj7vuxGFVcTz3W+oY2g6PGUw==
X-Google-Smtp-Source: APXvYqyReQmw36zPln5QfGWBGVhIpVbv13BJN1T5wbGPlk3lk3Azd0+w4PYXRQmNj1E1SHsoTt2laBhaYWd3jSRwsW4=
X-Received: by 2002:a92:8458:: with SMTP id l85mr88666783ild.296.1578341851389;
 Mon, 06 Jan 2020 12:17:31 -0800 (PST)
MIME-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com> <20191211204753.242298-5-pomonis@google.com>
In-Reply-To: <20191211204753.242298-5-pomonis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jan 2020 12:17:20 -0800
Message-ID: <CALMp9eTCTj-V0ihi0sQAkjOpKA2HzNY85WiX9LxRQODGvGN1aw@mail.gmail.com>
Subject: Re: [PATCH v2 04/13] KVM: x86: Protect ioapic_read_indirect() from
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
> This fixes a Spectre-v1/L1TF vulnerability in ioapic_read_indirect().
> This function contains index computations based on the
> (attacker-controlled) IOREGSEL register.
>
> Fixes: commit a2c118bfab8b ("KVM: Fix bounds checking in ioapic indirect register reads (CVE-2013-1798)")
>
> Signed-off-by: Nick Finco <nifi@google.com>
> Signed-off-by: Marios Pomonis <pomonis@google.com>
> Reviewed-by: Andrew Honig <ahonig@google.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Jim Mattson <jmattson@google.com>
