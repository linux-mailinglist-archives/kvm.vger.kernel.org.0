Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24043EB9E3
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 18:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhHMQSZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 12:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhHMQSY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 12:18:24 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CA2C061756
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 09:17:57 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z11so16147081edb.11
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 09:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u/fXuSTf/7nmSfAPH75rFa4Zgui6hAM0XOdM2IGchK0=;
        b=qEdrsc6sVnMCk57uQk9QHcz70n6V6Fr4mtqnky5UEI1CoEz2rT0N3c7d3QFAofTPPV
         sr6QyYAbb/9IMNnIWgsSr89ieGLwV+lS7cr459vNlfrMlee9nwsJZd+85UP4D0vdRsok
         +5Wa3iCI4SfiIfVK6UiyCmrPjYeH4uRxGYcbbqY4q3YidsdwaIHxjdv4iC835qld0uGX
         VuiZdLZGM5wnYRb/93iQFvfFInqlRUXVsPfakcF6AAySyLDCsIVeUMVINIyE17NYt7Fr
         MfC9+kwupW/Tq8Uwj1aD4ONSSBF8N8BkrnwGSXZ2RaCI/0W3sadWiNeF/APLqycmrtxC
         rMDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u/fXuSTf/7nmSfAPH75rFa4Zgui6hAM0XOdM2IGchK0=;
        b=ICvh5PGc1k4v5J84OAHl21bX572XbqQGInYXnc0ZtB2K2WOZuCb/3XC428/euuSQ0N
         jEIdV8599EMC6crCAukPdhxcflelCWLFReN5QTZMcGCVZ4SKI1tMN9izKGD/EhYDo8z/
         kvD8oeUO4tJwIbwE7OYDfrzxABd0wzEFA+48XD4PSe6Z5DL67gFIgFioiIDuTvessQRj
         Wut80lXdDIQ83mTlPX0/AUYfanC+yTkcUOhGi/rOD+sKn7PTVsOPNSAlLLuwoQFMn5Fk
         zkjhL/UFZzK+V+ay/1XVgXXy0Rkbbzg03/GKjrIi1fj2isWvDZDRzVWGVHm50eoHxJtI
         L2Bw==
X-Gm-Message-State: AOAM530oPWcEnO/PV/ZmJaWP3L9eccO8LHH8OM6REVsl8sxEe3/u/0zD
        KvS5Fgcits+0C3VjYXvuXgNnlh06VqWtcGH9Bdwy84r9xU0=
X-Google-Smtp-Source: ABdhPJzXb3H5cGQfMDpVz5MXqcsjTQk6WYedKZlTDpY+Hzrb8KLqZ/zXTbZ+Ged83jnzvnTFWEuqe2Gs16yLC3PVTuA=
X-Received: by 2002:aa7:c4cd:: with SMTP id p13mr4010792edr.251.1628871476321;
 Fri, 13 Aug 2021 09:17:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210727235201.11491-1-someguy@effective-light.com> <e84e3fe7-e644-7059-22cc-ddefd8bfc8c4@redhat.com>
In-Reply-To: <e84e3fe7-e644-7059-22cc-ddefd8bfc8c4@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 13 Aug 2021 17:17:11 +0100
Message-ID: <CAFEAcA_WL4MLsgA-u+oaMOtxkchb2qrnpojsUEsGcNziXZF7sw@mail.gmail.com>
Subject: Re: [PATCH] target/arm: kvm: use RCU_READ_LOCK_GUARD() in kvm_arch_fixup_msi_route()
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Hamza Mahfooz <someguy@effective-light.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        kvm-devel <kvm@vger.kernel.org>, qemu-arm <qemu-arm@nongnu.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 28 Jul 2021 at 08:30, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 28/07/21 01:52, Hamza Mahfooz wrote:
> > As per commit 5626f8c6d468 ("rcu: Add automatically released rcu_read_lock
> > variants"), RCU_READ_LOCK_GUARD() should be used instead of
> > rcu_read_{un}lock().
> >
> > Signed-off-by: Hamza Mahfooz <someguy@effective-light.com>
> > ---
>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>



Applied to target-arm.next for 6.2, thanks.

-- PMM
