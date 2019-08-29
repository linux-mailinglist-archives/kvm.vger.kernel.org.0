Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41D04A2A99
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 01:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfH2XRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 19:17:35 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40629 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbfH2XRf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 19:17:35 -0400
Received: by mail-io1-f68.google.com with SMTP id t6so10347293ios.7
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 16:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oHu9V9umdE8o7UX7zWA8lWy/w+BGHsXqy5zaJKgH3K4=;
        b=CUSA9AK64SIZvnYV0cJwr9cr02+2TPq73aBcZI2dsMy1moX0Wg5pOayWqua7WQF9Ab
         9i5wnUvdhfplCme4SkFJ08hrhgOZjXW8UhI5h/IE7YvLkfMvS997EypJkhIAzTwDlc4k
         vqUP4Ckpceq4yXR/JmLcin0hYnMLzFn/NhBvs55LEpNFN0MSOf5Yu4LsUk/8m713PWRu
         iTVpeO1wXHZS6i9cNiit8eQutpxm6KxrfoCC3bfP8VJjHJp5HT+oijwhi83js7JokHRo
         8jFDvXMq2bw5Xm1P+Greb+6pqYUcOJxlqSW9bS3UvRgxrGMVimVe+t5coEWg842lO96j
         XCAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oHu9V9umdE8o7UX7zWA8lWy/w+BGHsXqy5zaJKgH3K4=;
        b=shcuTsrufBXuRXwVPS6CPgOpd2dyZnndHIIXw6vo3PHEn6QIy2jBMspl1rER6LryM2
         TVn4noqPTdwFNNh90RCyUr6XmR59AJqbn3dQVF3Kx3vUcswIjoPKhEz5xK0cnl7B2yyO
         bZ0XWEg516/yHekaHMsWTpH1vcYGvnFDSpIMmJNLiL3w8yOrIb1sXcGDs5TTYosP2JXV
         QeJmyjTrgxahsPQHDSiuBUPjE9z0x/oel9w7lBFDfo3ucDHuAKL0+ywCrOsgvIAJ0NPX
         YoTj7MWZmZETa7vpNpCLRH7MKljIRco0/HVphdiYb5LhUsfq7iz3BUwDeMzXDWvTH7Df
         NQ+A==
X-Gm-Message-State: APjAAAUacbhcHtSl/qOwTTKfE9FrNRD3gfYUddik4gqCrcXjMdaMc83t
        iHFWV8qtdWJYB/WUOgLqkwczcG8If+qraPM50vpKFw==
X-Google-Smtp-Source: APXvYqx1aTx8WO3w1Gx13zmD9Xq/9rdkqpFKdf7tgS3eRuIeXPfs0+Z3WZEOEt+7FPDTJ+jKR5PdpKU/exrEXRNp0IA=
X-Received: by 2002:a6b:5116:: with SMTP id f22mr2302807iob.108.1567120654049;
 Thu, 29 Aug 2019 16:17:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com> <20190829205635.20189-5-krish.sadhukhan@oracle.com>
In-Reply-To: <20190829205635.20189-5-krish.sadhukhan@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 29 Aug 2019 16:17:23 -0700
Message-ID: <CALMp9eTBwNExJ_7+i6y7XcvQobSbAfhfMCs3u1G0zUZ+nQhkjg@mail.gmail.com>
Subject: Re: [PATCH 4/4] kvm-unit-test: nVMX: Check GUEST_DEBUGCTL and
 GUEST_DR7 on vmentry of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 2:30 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
> According to section "Checks on Guest Control Registers, Debug Registers, and
> and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
> of nested guests:
>
>     If the "load debug controls" VM-entry control is 1,
>
>        - bits reserved in the IA32_DEBUGCTL MSR must be 0 in the field for
>          that register. The first processors to support the virtual-machine
>          extensions supported only the 1-setting of this control and thus
>          performed this check unconditionally.
>
>        - bits 63:32 in the DR7 field must be 0.
>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> ---
> ...
> +#define        DEBUGCTL_RESERVED_BITS  0xFFFFFFFFFFFF203C

For the virtual CPU implemented by kvm today, only bits 0 and 1 are allowed.
