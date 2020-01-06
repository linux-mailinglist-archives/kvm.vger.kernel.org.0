Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9020213192D
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 21:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgAFUSX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 15:18:23 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:37119 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbgAFUSX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 15:18:23 -0500
Received: by mail-io1-f68.google.com with SMTP id k24so19604618ioc.4
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2020 12:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Rcg5ibwjG8y5aZAcf4B6F5Z9gExCdMlFDQO0Lciu24=;
        b=lqiq0v9HxFYQSzvoTItL5VboCgvXcPwJrDfjRt4tRzrNP91NfyDXsOiJ0/fojLIeK3
         cZDHOPcKfYWr1Imrjm4ukSv9jgmuqIUFul4cWpToTfFisGt9agV5pyTQYUhw/d56TCA1
         TED+wvKRPwaaajR6wEOAcNtQqO4eOcvinx1dX2jdTd2Kemd8PzCsuPJGravprw31HYd/
         /Q4rQfBCmTNo24mSI3jiIJdTm1ysoZI5RejQGz1yQd0FjM+dJ3zBPY7kWWX0BAepujEy
         B0rIjdFhlP24gElV5/X3YMNSxkww59fgjkVGTad5O92J+/njh17oPYTfbM5B7a3NrsxH
         MpTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Rcg5ibwjG8y5aZAcf4B6F5Z9gExCdMlFDQO0Lciu24=;
        b=GcLdp20Orv6lT69A6HXmoJQu0eXPTR0g+3ptUmBg+9PkN/AD2rnlzhnBZwmzExc+Fd
         xCSteEfMtQmlvLVrJdfxXRr2XHGsD1w6rKtSeKZEld0KdQ31Ky2l83WRqciBm8V8WEwo
         GZcB9mLZZCooHPsx2FZPMNZ7wcxfMNW5EB/GNaGZdFFJX+IDMaliber/KNSbQ45ALCJf
         w2IENRA7AFjHFT8oqBWkHe/b6ONO73LhrocWKQn2WA29nc2sMmFUcAX8cF3kcxjNYIQn
         YGgJqsmj76Li2h+XxHLtawPe0+Zs4h9qbfYk/hFBRQfJMYpuuX41Ghq7Ie2q0PlSCNhi
         PJ5A==
X-Gm-Message-State: APjAAAUNUJOaBASD7Js7A6eC7pPy+YBeI74eWqooHgyJLw07pvWfOFPw
        fs1YWW88VvKucPoLg61qwkuKFo0QJNdGiTeQK82EwA==
X-Google-Smtp-Source: APXvYqxjZclUu0eB6nMi8sSpfdOj8OZ6c2MrV6ct440WVHQXTLBSRRbC9HlKNRn8NRGFiuthiYpgPudrQf4lSXaDVdI=
X-Received: by 2002:a02:c906:: with SMTP id t6mr73461739jao.75.1578341902473;
 Mon, 06 Jan 2020 12:18:22 -0800 (PST)
MIME-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com> <20191211204753.242298-8-pomonis@google.com>
In-Reply-To: <20191211204753.242298-8-pomonis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jan 2020 12:18:11 -0800
Message-ID: <CALMp9eSvJYzuYmn6sUo5zNGLAmA=d_Pu4DcmCQTMAFCP_dBHsg@mail.gmail.com>
Subject: Re: [PATCH v2 07/13] KVM: x86: Protect MSR-based index computations
 in fixed_msr_to_seg_unit() from Spectre-v1/L1TF attacks
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
> This fixes a Spectre-v1/L1TF vulnerability in fixed_msr_to_seg_unit().
> This function contains index computations based on the
> (attacker-controlled) MSR number.
>
> Fixes: commit de9aef5e1ad6 ("KVM: MTRR: introduce fixed_mtrr_segment table")
>
> Signed-off-by: Nick Finco <nifi@google.com>
> Signed-off-by: Marios Pomonis <pomonis@google.com>
> Reviewed-by: Andrew Honig <ahonig@google.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Jim Mattson <jmattson@google.com>
