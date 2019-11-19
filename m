Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34468102C3F
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 20:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbfKSTAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 14:00:41 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:40143 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbfKSTAk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 14:00:40 -0500
Received: by mail-io1-f67.google.com with SMTP id p6so24463431iod.7
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2019 11:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0tlDOLamzXoB2txFi3bDr1lzl/uIOL5HoxDwsrMLE1Y=;
        b=QxgP7imn6TlYA7oi3x9pxhpZOtUUaToTMcAcmJRBH/dLvkCpP3EdF2QL5G4i2nA8DU
         Cq+DjhaOlof76EnZkWYD2y0d3NEa2cuX34uGwANcP8or0pu2JcTmaUh3imVEevFXQ0oU
         O897Np0pV2Lfk02x/PJCjyFa5f30yLGFkuqm4+nhsflv8PN6PWLoqmlsRWvdYL1oxSj4
         +Kk4EgtTSaAsd1+R6VwqACpKGRgTrKpWxfvCwfx8Rydm7W2xNXO6CWReFmqJ3/J3t3jT
         LaSgIxuo3K3zT6ApVC0ucLKXr6/Q4y/JkdQwvHRwoFYK92mXUVnopO42DcP5XeeHXX9g
         /7cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0tlDOLamzXoB2txFi3bDr1lzl/uIOL5HoxDwsrMLE1Y=;
        b=rckcTMIvyivm/KslTDH4FvAdIZIKPiKdZrvyp/wuD3qdDYOMfsbX4Thw5KzYWpfx/i
         TRFXyb++Gpmgh1KaBimY+j4rY/iIcSmPmHyLUqdqlBNi49lRt9vBuWHThC48kZfimirs
         g3TSF966hWN4SKVvJ3iShv8/GTqC+oRQ5As1z5SG6HKac/PqZP+x1Maz5+aWpHB2YBi6
         e+2z5niBLSymFzWe9KOQjUnaxi1k3oI6bCwBMxR2aqhJQSvivZCy25/PXLizvcBf49vy
         8WcpGkBrDg/c6QB5pdfpXCg4uWnRfO/XDd1LavMcGZefzlMrv7BS1Q4lLir2dyVlHdLV
         /SQg==
X-Gm-Message-State: APjAAAX+GPEzIIwHb2+sKynsZkEF73SPoxY3yKlzDS1L4rzEuczpzAkL
        5Wq+RYHraXl516UompMCyuOTCknDloWufbKr0Av2uw==
X-Google-Smtp-Source: APXvYqxrjt4bI9Z0ev5yPYL85atGFtMdcQsDoCEeiQ6jKiUgcWy9z7waZeREcBFeRT8RtQahzj5rQTQXHIYn4AAp6Ck=
X-Received: by 2002:a6b:e016:: with SMTP id z22mr12327691iog.296.1574190039715;
 Tue, 19 Nov 2019 11:00:39 -0800 (PST)
MIME-Version: 1.0
References: <1574101067-5638-1-git-send-email-pbonzini@redhat.com> <1574101067-5638-3-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1574101067-5638-3-git-send-email-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 19 Nov 2019 11:00:28 -0800
Message-ID: <CALMp9eTzAFYt1wkXT+OEx=vNs0rrCvp=8XG8Jbwwaj3mSPPF+Q@mail.gmail.com>
Subject: Re: [PATCH 2/5] KVM: x86: do not modify masked bits of shared MSRs
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 18, 2019 at 10:17 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> "Shared MSRs" are guest MSRs that are written to the host MSRs but
> keep their value until the next return to userspace.  They support
> a mask, so that some bits keep the host value, but this mask is
> only used to skip an unnecessary MSR write and the value written
> to the MSR is always the guest MSR.
>
> Fix this and, while at it, do not update smsr->values[slot].curr if
> for whatever reason the wrmsr fails.  This should only happen due to
> reserved bits, so the value written to smsr->values[slot].curr
> will not match when the user-return notifier and the host value will
> always be restored.  However, it is untidy and in rare cases this
> can actually avoid spurious WRMSRs on return to userspace.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
