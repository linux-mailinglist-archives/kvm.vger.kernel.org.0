Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2BE41E650
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 05:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351854AbhJAD6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 23:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbhJAD6b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 23:58:31 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1907C06176A
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 20:56:47 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id rm6-20020a17090b3ec600b0019ece2bdd20so6313166pjb.1
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 20:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tCIk2rzSAK6/lGmAh+8ZVlsluD8ZtZDvCuWYLUwTxRw=;
        b=KolHYewwxAsc2/709MTf2RfXswtvqv7dB1KsqPRVjdQ3kLJwGv+vE/AZ6Z5XM2yEKV
         UFDwOUg+I3hDzyY2PvO8e6jmPInB1hId0QWprhc6S7ioXN942NJvnEtUc80l46KQ/gCO
         awYFOf7AnIQoPg/sVpghaHRdsKYydWvm5jelP35b9JTmC6oFRYOz2LDRAnPQy5hNu/lr
         ORASjkrhH9hIf/F+DS7WKVZKhqXzjqHQoLvJ1S8xIVnK0xEUFZblsrTCoyl3gMtMYezF
         hvicJ0yTXgdOPe1aKySnGeAuImP1baAJZxdN0oypUsZfil0EnOe4YhyFIejnrHAE6emP
         IWyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tCIk2rzSAK6/lGmAh+8ZVlsluD8ZtZDvCuWYLUwTxRw=;
        b=IskJEpnkrCpWiAnDYtcHm/RNMJ3Iii5aBhryIZ4qzhTRhu8tlF1MRKOgVyX//qf7Bs
         AkE/keq1iuXV3XYuhibrcf9VuTpYdZlholH0fVzhTjhP3WTVZANODdRQtrWKP8j2oZ6A
         RYCfMAeXqM+yzoz6Jr5MyfwKDdniHpr4NFJsrMNBHlGZTWtmvCHlk39foYhM0E3mytS+
         DQ/N3Gg/mUj5pBtCUUqNLi/RqjR3APfuBj4vZs6ADdF5RBnjfSxCkeFhUwSZ8Qp/kb/9
         MN9dpe76coCW32rrT16tZBHb3OCe8QCbnCpCV+KnXu7k4fhn8VkFmFnoCVH2JEnkI227
         2lKQ==
X-Gm-Message-State: AOAM530ATBzu2XYCNtW3yexH8a2pfH7pHeW9/QhQGZNX8izKN3XPmkEw
        FyFCRBac+o9YCCSAmdMtp1O8VpOItT62o1B/XYTWIw==
X-Google-Smtp-Source: ABdhPJxxVTbIAcE8hsUmG1R6PXR6hasV9CPLD2zbS5x4ThW/2KNj+0yzykHBrrXoP3DuZ6QcbRfNwMAg//iLz+o/T9A=
X-Received: by 2002:a17:902:7142:b0:13e:e77:7a26 with SMTP id
 u2-20020a170902714200b0013e0e777a26mr8644884plm.38.1633060607156; Thu, 30 Sep
 2021 20:56:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com> <20210923191610.3814698-3-oupton@google.com>
In-Reply-To: <20210923191610.3814698-3-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 30 Sep 2021 20:56:31 -0700
Message-ID: <CAAeT=FzONsbTw9doo71XQjPdLXhWO+f+OD0FtWc9Ph_0d_vTcA@mail.gmail.com>
Subject: Re: [PATCH v2 02/11] KVM: arm64: Clean up SMC64 PSCI filtering for
 AArch32 guests
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 12:16 PM Oliver Upton <oupton@google.com> wrote:
>
> The only valid calling SMC calling convention from an AArch32 state is
> SMC32. Disallow any PSCI function that sets the SMC64 function ID bit
> when called from AArch32 rather than comparing against known SMC64 PSCI
> functions.
>
> Signed-off-by: Oliver Upton <oupton@google.com>

Looks nice.
Reviewed-by: Reiji Watanabe <reijiw@google.com>
