Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05D4315B929
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 06:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729687AbgBMFny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 00:43:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:57618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729482AbgBMFny (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 00:43:54 -0500
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C364F217F4
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2020 05:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581572634;
        bh=MeLA6KBsKMNopTpVt73O8Wl7j6vH4TfNZlX2CyoSvrA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tQMa4cy5y61Eqk2HT4RhEU9VuwdcKmwmLV+Pm9dxWTPAgh9MYuU7dVQnXUxZ6Wux+
         vU0nBwtQNGI/ps/3y0l8NVCzoimDaot739BC7xRFDHA1CrZZaxhPkyNd4Uk3cUJsEa
         qbP/QS7COcKS5XVFIhtTOXEk2C2TyXgbaXJgMsxY=
Received: by mail-wm1-f47.google.com with SMTP id a5so4785877wmb.0
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 21:43:53 -0800 (PST)
X-Gm-Message-State: APjAAAWCQ2/FWKBo6sOxeYUY0qEoAVVaAhA9AO6g4Z3B979XF3na61Ky
        VJKoOmRbz1z5MaIRMZ7G0YAy3iILCnCplNd13R8jgA==
X-Google-Smtp-Source: APXvYqyqUoW3kfb8cYofHM8mbkBfIsE5YpgIUhk/mRvexUuzH11inVRX40a4Ns/fahBVe21U0vz1KAbXBJxlE849bAY=
X-Received: by 2002:a1c:bb82:: with SMTP id l124mr3454795wmf.176.1581572632244;
 Wed, 12 Feb 2020 21:43:52 -0800 (PST)
MIME-Version: 1.0
References: <cover.1581555616.git.ashish.kalra@amd.com>
In-Reply-To: <cover.1581555616.git.ashish.kalra@amd.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 12 Feb 2020 21:43:41 -0800
X-Gmail-Original-Message-ID: <CALCETrXE9cWd3TbBZMsAwmSwWpDYFsicLZ=amHLWsvE0burQSw@mail.gmail.com>
Message-ID: <CALCETrXE9cWd3TbBZMsAwmSwWpDYFsicLZ=amHLWsvE0burQSw@mail.gmail.com>
Subject: Re: [PATCH 00/12] SEV Live Migration Patchset.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 12, 2020 at 5:14 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> This patchset adds support for SEV Live Migration on KVM/QEMU.

I skimmed this all and I don't see any description of how this all works.

Does any of this address the mess in svm_register_enc_region()?  Right
now, when QEMU (or a QEMU alternative) wants to allocate some memory
to be used for guest encrypted pages, it mmap()s some memory and the
kernel does get_user_pages_fast() on it.  The pages are kept pinned
for the lifetime of the mapping.  This is not at all okay.  Let's see:

 - The memory is pinned and it doesn't play well with the Linux memory
management code.  You just wrote a big patch set to migrate the pages
to a whole different machines, but we apparently can't even migrate
them to a different NUMA node or even just a different address.  And
good luck swapping it out.

 - The memory is still mapped in the QEMU process, and that mapping is
incoherent with actual guest access to the memory.  It's nice that KVM
clflushes it so that, in principle, everything might actually work,
but this is gross.  We should not be exposing incoherent mappings to
userspace.

Perhaps all this fancy infrastructure you're writing for migration and
all this new API surface could also teach the kernel how to migrate
pages from a guest *to the same guest* so we don't need to pin pages
forever.  And perhaps you could put some thought into how to improve
the API so that it doesn't involve nonsensical incoherent mappings.

(To be blunt: if I had noticed how the SEV code worked before it was
merged, I would have NAKed it.  It's too late now to retroactively
remove it from the kernel, but perhaps we could try not to pile more
complexity on top of the unfortunate foundation we have.)
