Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07E02CA1C2
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 12:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgLALtW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 06:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgLALtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Dec 2020 06:49:21 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30C9C0613D6
        for <kvm@vger.kernel.org>; Tue,  1 Dec 2020 03:48:35 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id y4so2783232edy.5
        for <kvm@vger.kernel.org>; Tue, 01 Dec 2020 03:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eNbJBvCjxxSRBqn4PhMd+UKDjwN1evYqMWIzSqsrfYo=;
        b=gkAJYfbacW18D8RmBnyQWhTMl0FGastBsP+jUXcjXVQNx1bfDA3wnkfPgHrG6cO4xI
         ea9PG4GwtYBYqAw/Dtw2cetDX7DidsnmVSqk2ST9n/FsXc2QVvEuSoM+3oAHrdLyQr89
         HXvivab1f0Bx7OZUVrxZy/3aompk4vn8GiJ9Ez8n4lj0oj0PU70c8WX+5aIbZSN35ro9
         qAasaRn355p8ELLT3Qe5uSyVvNBYxL7h0Z94s8b9neuAdWRdnObdjur//8NSOIiXkzEM
         QX3KOF6gXJyvQxMFOUxorDry3GOlCQoEx18j7NHLHnczoUfPtBv/JSQhArdFXBO6LSJi
         NClg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eNbJBvCjxxSRBqn4PhMd+UKDjwN1evYqMWIzSqsrfYo=;
        b=CL0qGFsYNtoBBpdaXrDRBSKu+g4DWYNAehHtpnJjsm5lTnx+Yi0xoOKSTiX3zqXLSz
         /o+lTAL+jPtIuPoxwNEF1rMcF4cf0FLc5GWTZDxb4xX/kKaXS+iRUrJDWUMeXe0gLSh+
         l6Ull8oK3WtUg8FSwlhRPl4swUL7C6HxIv7MRlbbljR+1aHQvmaF2eYvjfqjDOPvJ3xC
         IeucywyWbMZT57Kxloq/v+s1E2TmPajRGr0lgmg/I0b0aaitU0WpumXCg6/+LON3WEg/
         ZfQBeDe11vTNMSNTccTT6pruvYd35ZnGS1vgVms+ho73oDiTcBHLHV7xXwKojX9LfC8p
         Izgg==
X-Gm-Message-State: AOAM531+WPywB43KqEyXBHG57UqwXzYL7Ik1eUGnAO61lbYQm7s1ZUqu
        AxiDBnv3qlDnIyyXVPVVPIm/lIyG5RwwUuTf7DzSLQ==
X-Google-Smtp-Source: ABdhPJwBkmG7ozxwSvvWNZFi+MOMS8ktr4FfGn2HiL/iGAA05ytNimxgRqwHeGV14exT6S4LiJrHxh/OX3TrNuKrnAQ=
X-Received: by 2002:a05:6402:b35:: with SMTP id bo21mr2588071edb.52.1606823314418;
 Tue, 01 Dec 2020 03:48:34 -0800 (PST)
MIME-Version: 1.0
References: <cover.1605316268.git.ashish.kalra@amd.com> <4393d426ae8f070c6be45ff0252bae2dca8bbd42.1605316268.git.ashish.kalra@amd.com>
In-Reply-To: <4393d426ae8f070c6be45ff0252bae2dca8bbd42.1605316268.git.ashish.kalra@amd.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 1 Dec 2020 11:48:23 +0000
Message-ID: <CAFEAcA8=3ngeErUEaR-=qGQymKv5JSd-ZXz+hg7L46J_nWDUnQ@mail.gmail.com>
Subject: Re: [PATCH 02/11] exec: Add new MemoryDebugOps.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, ssg.sos.patches@amd.com,
        Markus Armbruster <armbru@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Nov 2020 at 19:07, Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Introduce new MemoryDebugOps which hook into guest virtual and physical
> memory debug interfaces such as cpu_memory_rw_debug, to allow vendor specific
> assist/hooks for debugging and delegating accessing the guest memory.
> This is required for example in case of AMD SEV platform where the guest
> memory is encrypted and a SEV specific debug assist/hook will be required
> to access the guest memory.
>
> The MemoryDebugOps are used by cpu_memory_rw_debug() and default to
> address_space_read and address_space_write_rom.

This seems like a weird place to insert these hooks. Not
all debug related accesses are going to go via
cpu_memory_rw_debug(). For instance when the gdb stub is in
"PhyMemMode" and all addresses from the debugger are treated as
physical rather than virtual, gdbstub.c will call
cpu_physical_memory_write()/_read().

I would have expected the "oh, this is a debug access, do
something special" to be at a lower level, so that any
address_space_* access to the guest memory with the debug
attribute gets the magic treatment, whether that was done
as a direct "read this physaddr" or via cpu_memory_rw_debug()
doing the virt-to-phys conversion first.

thanks
-- PMM
