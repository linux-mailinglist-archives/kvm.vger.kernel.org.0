Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D957214C268
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 22:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgA1V7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 16:59:41 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:42720 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgA1V7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 16:59:40 -0500
Received: by mail-il1-f193.google.com with SMTP id x2so8426703ila.9
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2020 13:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5qE2yGDar/QO89ZtmbEwV0agYaFSTn6aRkOLzm6MdDM=;
        b=KnDzVDoX/735WRiNifi2vMkpwGbkqY73NCKHH2E7ldvV16oBi22WMClKG0mBbMlGoP
         agf6TI3e+yFWCxKVjYsWoadqbKcJ2Y/FWp0721tdhrwJ9PXevZB1t61oMCg4H7DpShbA
         LYf2DFWQTfn9Em0DZZweVfszDmmnGSE6SeLYTGeQmUpFn82c+4huguBLrWvgNi6giiSt
         QsCoreTxs1E/HkcMHUFTcbq1npKL2NMPCY0LbbqcqTFOxJ1H2r4KUJVu0CBREgM47dcx
         yeMKjAg704GP99/Z2dIS5/oePgycIA2fudk8NWYJzVtRWVJAYPhFH/QKET5c1O3ZRtAJ
         SaLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5qE2yGDar/QO89ZtmbEwV0agYaFSTn6aRkOLzm6MdDM=;
        b=kgA6x6mr8ue97KxPbKf32yawPRjSIgX2Ro+L6zLgjgg3S5KSVbto8ipbu0klzQh8e6
         vyyVU09C1q05xPEa4Z7QZkntlIFAX/kBLv2DPNY3b//p3mq+Mq46eTjbxJm28F0PlIaO
         kNIxb9E5Adxcgfu11fsXaASjNftuhfCfeL9B/8qN7mQn5O8MpmOCANNYPuTYG1yHrvAE
         IEsildmTvY5haDGWAoieq8qMiBg52UeGpPNL/2WWmbL39oHkjZ1uUisqpnh4JlUslCH5
         wPdXPrY2QW9j8IkluMxfUGaaHbvOonJzQKO9S3wPPt8dn017va9l2cMSsjDLQRTvZYXa
         Fb2Q==
X-Gm-Message-State: APjAAAUvEmy3LksxC7QcdlkB3/oK17Gi9TbxrqHrHXkd+nK2yK84648T
        LiNKWtwgAYtfdKPTMd7CNdrEcLTAcf2AC5WvKwlbxA==
X-Google-Smtp-Source: APXvYqya8Ty/3A9imY+gRu5qeRRZ4MwOyuIOlPAzOz3kBJ9Jn7sXOuYGYnovYbSG1jsWbvYccvovJ3B1i4a9Sepp7QQ=
X-Received: by 2002:a92:8141:: with SMTP id e62mr21629924ild.119.1580248779692;
 Tue, 28 Jan 2020 13:59:39 -0800 (PST)
MIME-Version: 1.0
References: <20200127212256.194310-1-ehankland@google.com>
In-Reply-To: <20200127212256.194310-1-ehankland@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Jan 2020 13:59:28 -0800
Message-ID: <CALMp9eRfeFFb6n22Uf4R2Pf8WW7BVLX_Vuf04WFwiMtrk14Y-Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Fix perfctr WRMSR for running counters
To:     Eric Hankland <ehankland@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 27, 2020 at 1:23 PM Eric Hankland <ehankland@google.com> wrote:
>
> Correct the logic in intel_pmu_set_msr() for fixed and general purpose
> counters. This was recently changed to set pmc->counter without taking
> in to account the value of pmc_read_counter() which will be incorrect if
> the counter is currently running and non-zero; this changes back to the
> old logic which accounted for the value of currently running counters.
>
> Signed-off-by: Eric Hankland <ehankland@google.com>

Fixes: 2924b52117b2 ("KVM: x86/pmu: do not mask the value that is
written to fixed PMUs")

Reviewed-by: Jim Mattson <jmattson@google.com>
