Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 687C790A2E
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2019 23:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfHPVQx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Aug 2019 17:16:53 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45774 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727847AbfHPVQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Aug 2019 17:16:38 -0400
Received: by mail-io1-f67.google.com with SMTP id t3so8974014ioj.12
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2019 14:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Int3qXRxTtMLZpwLZ2e6cbllifhw+j89MK6a4PSSxKs=;
        b=WMsue2VIg8HAKY+hUVTbQ3NledHMv2Vy3n21BHZtmEGvftmjPF9kPlF0azKgkb45rG
         3eJb0K2ofV4rE5ojGEL84Bsuit8rGVd9s6Yk54sbK1lTSrJ6UJhDVGijSw6iFjtPQ9Ad
         aOCu/SA2uFJsSKD4bwejZP1+CAiv1ZZLfcGs6yG1SG1vDSqdntz4GuP1wQhO8nBHeOSI
         KA0PaBXa/qUFxQRwZ/EydvH9dxp0kzagGaBigUmp1kq0nT7lrgqJSOujPQL6mt4Hokxc
         PmNBeLE9XLvIrIxuc9NktzeND/yyTuLHL72DtYhmkGEKIDpjw/IKBfa8QTQllNN/xg+Y
         MUpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Int3qXRxTtMLZpwLZ2e6cbllifhw+j89MK6a4PSSxKs=;
        b=e/uYuveYfzIQIZZJiGMkq87aUA7uniEbUf4U2q6XjFT0Utj7vMwqU6Kfh5Y1SRMFaH
         bwnd3zrfb9eflGllirEVsHSIgShtm//4xUPZntoUqcv8HPVM2dAxqGdZYhtHwcRD0mRW
         J6Ci9mvuOGmb6ZFouWjiloOk4DFYhqBPuMFJFkx7eJFCzjjrPCDI44t38HLbIUFdOltC
         GF86rI0V47J9Kz8/L2DpGiAlkiZkitPb9/yr1nzfdGnD3pP0sHD1UGXXFYeFMYx7gaF2
         aFeJVFBmG7gt1j1+7rYE8yNTOBZnRV4W5qx6nGhmj32FJF4R8Pr5DLmDQWAiGx2kBSTB
         eaWw==
X-Gm-Message-State: APjAAAUHRPvHoO9Jvzjd6GWDz2S3AKDphXE9Tp9MheV1YrmQTTM92OzO
        RnSuVe1L/C8zWvW2y8Fo9zJNCXQQ84fr5xyTI2UnCA==
X-Google-Smtp-Source: APXvYqy9tYsUxi0DNu9mhE/ntscDvxLoXebX+iGLalDZMl6lWKFfoR9p+EaKbRUicrM4nhuxZfGC6FfCiU+KY0yLggQ=
X-Received: by 2002:a02:c65a:: with SMTP id k26mr13146161jan.18.1565990197653;
 Fri, 16 Aug 2019 14:16:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190815162032.6679-1-sean.j.christopherson@intel.com>
In-Reply-To: <20190815162032.6679-1-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 16 Aug 2019 14:16:26 -0700
Message-ID: <CALMp9eTJpzGu=NyTknGUAoxWOfWJiXgJzxZmPJwZEbScJDJqjw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Fix x86_decode_insn() return when fetching insn
 bytes fails
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 15, 2019 at 9:20 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Jump to the common error handling in x86_decode_insn() if
> __do_insn_fetch_bytes() fails so that its error code is converted to the
> appropriate return type.  Although the various helpers used by
> x86_decode_insn() return X86EMUL_* values, x86_decode_insn() itself
> returns EMULATION_FAILED or EMULATION_OK.
>
> This doesn't cause a functional issue as the sole caller,
> x86_emulate_instruction(), currently only cares about success vs.
> failure, and success is indicated by '0' for both types
> (X86EMUL_CONTINUE and EMULATION_OK).
>
> Fixes: 285ca9e948fa ("KVM: emulate: speed up do_insn_fetch")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
