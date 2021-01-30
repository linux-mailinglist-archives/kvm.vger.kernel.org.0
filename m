Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97623096A4
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 17:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhA3Pj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 10:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbhA3PiV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jan 2021 10:38:21 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65902C0613D6
        for <kvm@vger.kernel.org>; Sat, 30 Jan 2021 07:37:39 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id ke15so17424999ejc.12
        for <kvm@vger.kernel.org>; Sat, 30 Jan 2021 07:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=78kOyNsh9PFQ35W6G6J34UFL3WJ0plW3fjCLydvhNGU=;
        b=evI+JCiN4q9fC6wQYJuhNtFMDoH0y/ah6iDJRi+XmLvWYdNKZghG075xgvVS6nEH63
         QdOKU1s/tbYWcdHwDvDugZGRZzCkn/NBqE3cYw+ytxwNgNK7h9d4lF1nfdaX2dqkhC1s
         m4+eSEQWVVB2kCpgZVbmzfVhV2dfOIYlq6Vn8FQITksyJmROd5NLThrkFBPHH5OqjzTl
         COIOuFHypRtV5TiZdLH/9lecUqz5sRcjDl+DEHJb6ojwly5a2AJDEb3Bk7F64IO5s7Q0
         DlGL1cp0xxiiP+UvlIJqJPxke6LXOQduMAUGGia1Z027oaon4bMF7R08U/DuutijOrQs
         ViAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=78kOyNsh9PFQ35W6G6J34UFL3WJ0plW3fjCLydvhNGU=;
        b=QjUWqxxDShGdUN5L+L1RB15HPaOt9w/zNv/cJaCdL4HVF0KermKFnsO7IpVNpH7ati
         J24FXB5OVhuYyjuTB8Ze7FRiA6Q62fSsbZ+zMyLzjuTdmZc/6mRiK5amOxIQ6gkYOzWC
         upmHaXQx3dVtpx7R/HfQQq7EW/nODpsMMtiKNfWQ6AQL8uSjndPzZvgnNycMZ//Ogppi
         IONKQQIDDrFdub2ODF+VH/PasoSUjpz+dCB83/VaxnCcj7t9qM1y2TEnGrYyziWpFXjf
         O4hV5hQD9nmCVglxdp0qCBha6OlY5uhYEiwwHQAu0GmKdsalOUlQztbQOxFVUWUDGY/J
         Vo6Q==
X-Gm-Message-State: AOAM531UTy2Inb3BZpNDR7AWi68EvT1qBAa6PBx+vBNtdLohdj6JMymd
        yUG18nA67mmntGPrQFN2vWp50k7x0NMn40A7DKoSWg==
X-Google-Smtp-Source: ABdhPJyD++UlciKvmROO24kS3r/XXDVKijRu1H7xIYaJRV48MHyTsJtFtdfA1zpizwOdbfEwhqs6mx4IqJ20F8mkBMc=
X-Received: by 2002:a17:906:b215:: with SMTP id p21mr9386002ejz.407.1612021058129;
 Sat, 30 Jan 2021 07:37:38 -0800 (PST)
MIME-Version: 1.0
References: <20210130015227.4071332-1-f4bug@amsat.org> <20210130015227.4071332-4-f4bug@amsat.org>
In-Reply-To: <20210130015227.4071332-4-f4bug@amsat.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Sat, 30 Jan 2021 15:37:26 +0000
Message-ID: <CAFEAcA8UCFghGDb4oMujek_W_wsyYz+duiQ-d8JyN09NYoff-g@mail.gmail.com>
Subject: Re: [PATCH v5 03/11] target/arm: Restrict ARMv4 cpus to TCG accel
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>, Fam Zheng <fam@euphon.net>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Claudio Fontana <cfontana@suse.de>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        qemu-arm <qemu-arm@nongnu.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 30 Jan 2021 at 01:52, Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org>=
 wrote:
>
> KVM requires a cpu based on (at least) the ARMv7 architecture.

These days it requires ARMv8, because we dropped 32-bit host
support, and all 64-bit host CPUs are v8.

thanks
-- PMM
