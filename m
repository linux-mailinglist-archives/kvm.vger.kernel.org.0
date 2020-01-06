Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6D61131935
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 21:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgAFUTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 15:19:04 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:34662 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726895AbgAFUTD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 15:19:03 -0500
Received: by mail-il1-f196.google.com with SMTP id s15so43700918iln.1
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2020 12:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=On8S/jqcqhWm1gA75kni93hxDaFgmyxXA8OYLeg6pRw=;
        b=pj5xEWC2k1f0PDOEDl4ycNhV9/3mEeqCFoZlQ6jKJtbe77lzXp8pzFq26ztwSG9V+V
         Kq/A6Em27Lt9MrhZKAC3Nw+qJogSJDU9M+w73gCuds+KJEOjYORSWyCbiG2QNVIx8nAX
         MZk0LhnqI+m2EvlcOCUkv20bX9qw8Cv39Bbtnby/EMmb+Sz8+HwI13s1a8U7X01f3Hq1
         Dxc9ndFQw4DlH2N3jG1H/6eSOiNhnSd90uRIh8ZzcvSAmwqHzqDwPOL5T3ZPKWp5y7bf
         QZqCDDlB3FxjzOcqPePxq8ksuPYFPL0YS0AO41kD+eoBlTCpPDcnrZYkyCnkzbl5sgLy
         OJKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=On8S/jqcqhWm1gA75kni93hxDaFgmyxXA8OYLeg6pRw=;
        b=Rs4YNHcQLfz2xo4my/ADLg7YtyS2wcThp/GwFMKb3oIzJUZ6b3ka+3DggG6WVYAIz1
         LOFziaUsHWXYi/1UcSPOhrh2iqKHGp85IDeMHL5LUcq3skrsUnDbk7T4Z7gYHf9wXJTE
         7dJGx1k4ouxYzexqycGJsQbGkCnhBn4j+sahVm4qquE7ef4LqiiUWrzjIEfc5pZW7IfL
         Np8NdJRbiWGLqiLER1u6rXns2PhjWyjV+iVdWmZd2qpnHS5402fckURRRy99tMtg2GuK
         ZicQhEMCkR/tkvzFxNb9spKcnF+jQBz4HpWDDk2YbQKfp38JyV0eebb0fdSCgV4gmZy5
         Df7A==
X-Gm-Message-State: APjAAAX++UBtak3e6JlQq85/DjMiekdtcbam+l1VB4nyA45BP1DsOo3m
        GlzmYIw9smAjAnc3HXCpvNcAV28EYVnwPEq+1whauQ==
X-Google-Smtp-Source: APXvYqw/uA456NSw77dxi0HDBubRLZXT5catRpIZeEV7h/AuDPtK8k5E+UuB/HK9diCwlWzkyenxKNoQyTYwehnh+ls=
X-Received: by 2002:a92:3b98:: with SMTP id n24mr67439328ilh.108.1578341942677;
 Mon, 06 Jan 2020 12:19:02 -0800 (PST)
MIME-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com> <20191211204753.242298-10-pomonis@google.com>
In-Reply-To: <20191211204753.242298-10-pomonis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jan 2020 12:18:51 -0800
Message-ID: <CALMp9eRTLMM17nVvGD9P38uP=886hgck1YabpnPXqyuFb1n0Jg@mail.gmail.com>
Subject: Re: [PATCH v2 09/13] KVM: x86: Protect MSR-based index computations
 from Spectre-v1/L1TF attacks in x86.c
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

On Wed, Dec 11, 2019 at 12:49 PM Marios Pomonis <pomonis@google.com> wrote:
>
> This fixes a Spectre-v1/L1TF vulnerability in set_msr_mce() and
> get_msr_mce().
> Both functions contain index computations based on the
> (attacker-controlled) MSR number.
>
> Fixes: commit 890ca9aefa78 ("KVM: Add MCE support")
>
> Signed-off-by: Nick Finco <nifi@google.com>
> Signed-off-by: Marios Pomonis <pomonis@google.com>
> Reviewed-by: Andrew Honig <ahonig@google.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Jim Mattson <jmattson@google.com>
