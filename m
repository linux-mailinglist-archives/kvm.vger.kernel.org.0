Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A93047D82D
	for <lists+kvm@lfdr.de>; Wed, 22 Dec 2021 21:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345383AbhLVUMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 15:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236592AbhLVUMu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 15:12:50 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7554AC061574
        for <kvm@vger.kernel.org>; Wed, 22 Dec 2021 12:12:50 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id x21so7775484lfa.5
        for <kvm@vger.kernel.org>; Wed, 22 Dec 2021 12:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HCTh+Ynkd5NNv+SCYeR8IP6sWsHKRFOJZRmHSvdeRe4=;
        b=J6GZh5gyi977Co9/bdDs9gs0BNJ/aGkTpaPotA3jgTsNcPRhfdcfL/IlPZZ3ohceRn
         xvFZLMIYJH9ZFauvY2Q/USOnqvi5+FSR54EJA0enhBuk+xadoSrCAUFriTqN7HIOaSn4
         SYqcs5dcw2F/XBNOks+Gwb+c8fl9GxDYnPlMQ0C2gO/RoBElhidjemy7bfm4wM3RuxSp
         tyVNeUmWxBRXUYez/1DcGZuS8Cg8wuF9KHa3QN//MqKm51fcF0p+zlVXTqyzHLOjCAti
         sBzzYJz+jfCo6QtKG3eZ0UqQEmI/HiSbYHEO3J3CRAHw3TdX7xmaNbDiQ4w0oIcpI95m
         CtiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HCTh+Ynkd5NNv+SCYeR8IP6sWsHKRFOJZRmHSvdeRe4=;
        b=XpfSys1SmCpyQeM+UB2mzciHHyvFjPw3mYor+zGAdqUmAmU9fw1WpZiIc53pwbju1h
         F5wX05lsyNY695Fp8FjGtbBZKPysDfjXWh5pPhW0Gqxjva+UglNQRBNvHHk6MNgyOP/t
         qCti0Dhy5/NoVTTDSRuj9mZRAqVkVsoQN1DO6O3/KazeoORUKSoeYDSIJS882ysAVEt6
         7dp4sqquaPhbSdxmU6+Dd000BIPD+Kh47hQUnKP0t48osA2iTHSpnw8LZhISqx/uxYZt
         /Cm44awMUtC0IjnrY+FbleuOzs2LD0t/tfRUP+RYBvm2cp1HzM5MbIutgKeaqt03W060
         QzjQ==
X-Gm-Message-State: AOAM531EyHMdQgjJOk/H+ns4W9hPKp47wekSVtii3/RLkpHA1x+Cenaj
        h9V2C7IBu3f1Jo22Kft1OzSx/F7MGQQbgEz9xlvs6w==
X-Google-Smtp-Source: ABdhPJxVzM018GgI6kD1fDN1OvG5viw/Bv+NRVCvmTiM9OeBOmchibP1YxYZsMajhKmrUkZOG2TLaAb7KxY2z5aHAnA=
X-Received: by 2002:a05:6512:3b96:: with SMTP id g22mr3565836lfv.93.1640203968476;
 Wed, 22 Dec 2021 12:12:48 -0800 (PST)
MIME-Version: 1.0
References: <20211214050708.4040200-1-vipinsh@google.com> <ac81dcba-13db-8286-0f2e-f46a413a09cf@redhat.com>
In-Reply-To: <ac81dcba-13db-8286-0f2e-f46a413a09cf@redhat.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Wed, 22 Dec 2021 12:12:12 -0800
Message-ID: <CAHVum0eh8CvyH7EjsnxzBbHG_UZi-8_OikZv146a7_bvUvUU6A@mail.gmail.com>
Subject: Re: [PATCH] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     seanjc@google.com, "Michael S. Tsirkin" <mst@redhat.com>,
        dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 15, 2021 at 10:27 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> So the issue is that the kthread_stop happens around the time
> exit_task_work() destroys the VM, but the process can go on and signal
> its demise to the parent process before the kthread has been completely
> dropped.  Not even close() can fix it, though it may reduce the window
> completely, so I agree that this is a bug and vhost has the same bug too.
>
> Due to the issue with kthreadd_task not being exported, perhaps you can
> change cgroup_attach_task_all to use kthreadd_task if the "from"
> argument is NULL?

Thanks for the suggestion. This also works, I will send out a patch.
