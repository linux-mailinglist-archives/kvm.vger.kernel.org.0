Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689031D7DAE
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 18:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgERQBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 12:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgERQBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 12:01:43 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C39C061A0C
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 09:01:41 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id a68so8458420otb.10
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 09:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+Csgbxdb0qPLhWsI6+64x/kUGz0KGGbmksUNP6HDZ5k=;
        b=TXAc1gm8E9fWfG1aZ5JEtdBX6ZKEIniB+udkwYEaE/7YZkLO32zNrFFiKGRfUuNqJl
         XYTGH9hVJPGhW9a1wTDYps+tFPe57gj666pce4XxQrmqZqXIe3EqTxydUWyHE2AlI9Ul
         0j7JLMnFOIZHMMap8Iud3NpHglttPrbWB6wieRAKJHXvX9jdspsUAZ7A0oTdUE9bRYy3
         /N6TuMsVnmKmwofQepGq5+kMT6I2aFQZ0RqHG2L7iDkwevY1vQqtQEBLPz3Y3IGaAL4/
         J2L1gx9EdF19viSo41SfCyUT0okLiH5HHIKFcYHrDyfy2IfHaXQ76pNB5zdlv4zOuRsC
         U35g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+Csgbxdb0qPLhWsI6+64x/kUGz0KGGbmksUNP6HDZ5k=;
        b=mOUuuLPYJB1TqDfRmp6u0qTHxpJwtFZv9JM2BT/955JopV3bdKR4ZVxMPkgnt0aqEQ
         P9MR1rTxXMXm/eDRiO7FGTv+B+2T5h/ec5MpB3pe54b/4tWAEHsgihcHKPwcEiMdqLcY
         5EmSFxugsazbLetAb0EG9iDAdeDrngMJS6AYkyJzK5JTvFW6jyCUlRcCMOs3WczBDpDG
         yWRFuBklr61nyxIAC2KVm+NUiDvOnyXEyE6+Ru9aOOf+pykTtHfzS9b5sS1TzONk9VtU
         VgtksVo2x6awUFu3l/X9m7mN9r36m1QpUWayoy+FphupgezKv8V7u4zf1Fn5gsdFLca1
         tSog==
X-Gm-Message-State: AOAM531wo/URPsyOxdZ+Ij2Zjbc+l+p6QRF4eCiWWhJEfQlrwTRA1Fb0
        qiNdAGTbMu8VodtMIHwyHv6Kp69vKS/7XpOQLn8haA==
X-Google-Smtp-Source: ABdhPJwG45G//hr2WRGMOmQM1jDCydP85Jjyk3jk2i0zSwiSjmywwKojJw8Z9GAKCiEDAAYwGneSHKdc5hHjF6PqiRk=
X-Received: by 2002:a05:6830:158b:: with SMTP id i11mr3252405otr.135.1589817700265;
 Mon, 18 May 2020 09:01:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200518155308.15851-1-f4bug@amsat.org> <20200518155308.15851-7-f4bug@amsat.org>
In-Reply-To: <20200518155308.15851-7-f4bug@amsat.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 18 May 2020 17:01:28 +0100
Message-ID: <CAFEAcA8tGgyYgHXT5LVGz675JMq6VWR56H++XO5gtTrcaZiDQQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 6/7] accel/kvm: Let KVM_EXIT_MMIO return error
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>, qemu-arm <qemu-arm@nongnu.org>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 May 2020 at 16:53, Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org>=
 wrote:
>
> Give the hypervisor a possibility to catch any error
> occuring during KVM_EXIT_MMIO.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org>
> ---
> RFC because maybe we simply want to ignore this error instead

The "right" answer is that the kernel should enhance the KVM_EXIT_MMIO
API to allow userspace to say "sorry, you got a bus error on that
memory access the guest just tried" (which the kernel then has to
turn into an appropriate guest exception, or ignore, depending on
what the architecture requires.) You don't want to set ret to
non-zero here, because that will cause us to VM_STOP, and I
suspect that x86 at least is relying on the implict RAZ/WI
behaviour it currently gets.

thanks
-- PMM
