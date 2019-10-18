Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEFE5DD0EA
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 23:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506140AbfJRVM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Oct 2019 17:12:28 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:35623 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2506112AbfJRVM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Oct 2019 17:12:27 -0400
Received: by mail-il1-f196.google.com with SMTP id j9so6807627ilr.2
        for <kvm@vger.kernel.org>; Fri, 18 Oct 2019 14:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3bTakgz7LEZbnsJ6SfGZfkJdZLXTmdE5E7CAN0l9zGs=;
        b=OYrB4dw9gOsYCWo4syH/MFfrRmj7gjPcUk56pQPkSYzcnoehqVtqgxGyue5h2rJ/5q
         UrUGacNmUXkYVIz3VhI47mM5wM07gcYNzepR6WUplr9/++Xxel4iALzGaABMJyBOdA/z
         Siyyis/hQS0PCFgZjFpboDCeHAytZqXKyaK6qhr/kN72KeoU92BwxX6J1asfNIGfZ9oV
         vOyGL10KFrWxezdDaSPw7lcTMXKu90Mif3b4fxuiZt84YXbduxPV8cplAzOLJekLBjPQ
         bweDKonrJrnCjJxRUC9YKAH7VMD7pu77W+N5X93Mdhq2F8J3uXx4x8poH3sCyQ6J/O7v
         M/XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3bTakgz7LEZbnsJ6SfGZfkJdZLXTmdE5E7CAN0l9zGs=;
        b=JuCu2cpcwQaTEXlOyGg6dj9GIhgpSIUBsAfuH11lYr/Yg9mbHDbgzLtIgPLSktmITV
         uRioFn1O9NoPCBJ5KUL17Wl0zA5i6mamJ0GImf64yem/Xs98pjxD06OtgtO9WSErbBrQ
         1kttRudY1kubmXhgP1Z3AQAXUaLiZPHwO1NS4XBxsF0VZSWBMM5O5NqHrcsxbIgMg4ES
         9Gdn9zCJnxdZ2lOdga/EZoJzC9q4Ta2OxetKdePpxBL3q38zDho4JZ03OBH3nBCxH4KD
         2Y4sqrCVSNIEkSH+Z4SuaNRFaJTFohp6fQRiBkLw1X+dO+5RPKM6/ZdAMJcSW/9iokzT
         YPHg==
X-Gm-Message-State: APjAAAVr5gJXIcMSlaoC9B1Evddp5sz+N9Y2OrZy1qy64YJG2s3dhlfD
        diG9sp9NdCXFl2sRBUCU+7pChnzMlwAcBfPLGurWwA==
X-Google-Smtp-Source: APXvYqx4nWj+eAEbk35IMVkYUmMOK2BiEKPGwuO4Ri0S0ybvpc8yNzjzRZFXSETBp1i0VPTzCgZ1Kms4ugQwQcdPBaI=
X-Received: by 2002:a92:475a:: with SMTP id u87mr12844914ila.26.1571433147021;
 Fri, 18 Oct 2019 14:12:27 -0700 (PDT)
MIME-Version: 1.0
References: <1501554327-3608-1-git-send-email-wanpeng.li@hotmail.com>
 <20170803134636.GG32403@flask> <CANRm+Cw9+zBrk24MZo5YSw4j2KxyRsuk+dh8QNT9q0orVo7egA@mail.gmail.com>
In-Reply-To: <CANRm+Cw9+zBrk24MZo5YSw4j2KxyRsuk+dh8QNT9q0orVo7egA@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 18 Oct 2019 14:12:15 -0700
Message-ID: <CALMp9eTrhnWJpROGiCuR4TDHzW+CqRpBm4YV5hXQEdAbPN-fzw@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: nVMX: Fix attempting to emulate "Acknowledge
 interrupt on exit" when there is no interrupt which L1 requires to inject to L2
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpeng.li@hotmail.com>,
        Dan Cross <dcross@google.com>, Marc Orr <marcorr@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 3, 2017 at 6:23 PM Wanpeng Li <kernellwp@gmail.com> wrote:

> Thanks Radim. :) In addition, I will think more about it and figure
> out a finial solution.

Have you had any thoughts on a final solution? We're seeing incorrect
behavior with an L1 hypervisor running under qemu with "-machine
q35,kernel-irqchip=split", and I believe this may be the cause.

In particular, VMCS12 has ACK_INTERRUPT_ON_EXIT set, but L1 is seeing
an L2 exit for "external interrupt" with the VMCS12 VM-exit
interruption information cleared to 0.
