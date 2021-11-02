Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B6C4439D7
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 00:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhKBXjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 19:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbhKBXjR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 19:39:17 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C58C061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 16:36:41 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id h11so865699ljk.1
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 16:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r/4nzkJMmTDZyc+V/cANtoDFkLP03MjQWCb296uizWE=;
        b=EY2Tll1U3TfHkFoSrC3QxcZUrqKEgh0CTGkntEj5tJXB3IvJI8sAhdNU/lkq1AzUYP
         eKXOg3mtfiV8K82o62fokLa3FGt5Hgxj0nNyEEgZZTnHgnC9S/JMxfIkrINKeLiBkCw8
         r836PJXY79LkC828AOuoGV7GXvPpviWElvit0u0ldLDczozbsFsHbBb2M4EpElWHi5ac
         mhWzR3mftO2qq/Y3wNnOV8EKdmZm0LhQQFHgjlxBvcT3aL5eig7zBd12jR90vt8L8wGE
         FfY9A86mRssxbd6rVmWAkwkOvJhQ2PA/8UBtUV0986IwNRQHGVQOoV6GoCYR8GXS6b6j
         qKCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r/4nzkJMmTDZyc+V/cANtoDFkLP03MjQWCb296uizWE=;
        b=xFC7WEPOu3XKtrGauCJUaWhrG11NyX9OuPI4iJB727Zj7jHiXY+NYrHlr3XjKjEChx
         r7yCzG7GBMNUDTgPlNixeVYa1yGHakn4kn1kXzefoVqw1INFq9i6F0L9SNWRqEJvGh/F
         HwgeL1lt7AksDIfCbp7A+yl2WATbPmkYRRFmWXBkNX2gDdMa0wwxlutHch91mv/d8bIZ
         3l2MSE9TqRsO1MJkRZoUY61KPn6uNwBPI5aiAI+nKYxvreaz6eaMjA//CsPqCOvao7S3
         anJhZFgtjHt/q3Sjb8odd+Yqom5S9GWeVUVzJdSCAIvkvZ0KTyNTWSuDWGavg5mBtN/t
         Ifmw==
X-Gm-Message-State: AOAM5308YtrtJjyXk3MzjHBXJQARpCuye1rxo3jVlNSrKWQ0EBuEEB34
        71X4ue5TmZcVcjXJVL2yjAJUoiz+qp7RwsR8mI9lWQ==
X-Google-Smtp-Source: ABdhPJxZUGvKfPYF/m+Ok8JcJBPm4oZEXLpslPHb6Hk5EWAVGzh6JaKGzP67uq52qmjWXNc/OyCMzsMfwQYBoLJMC9o=
X-Received: by 2002:a05:651c:556:: with SMTP id q22mr29186105ljp.374.1635896199437;
 Tue, 02 Nov 2021 16:36:39 -0700 (PDT)
MIME-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com> <20211102094651.2071532-7-oupton@google.com>
 <YYHJWmQ+RmNZ51dM@google.com>
In-Reply-To: <YYHJWmQ+RmNZ51dM@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 2 Nov 2021 16:36:28 -0700
Message-ID: <CAOQ_Qsj-KOGRdSy9yrosDqO+=wpYhmDeVYxWeY7uuRQAyycQ=A@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] selftests: KVM: Test OS lock behavior
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On Tue, Nov 2, 2021 at 4:27 PM Ricardo Koller <ricarkol@google.com> wrote:
> > +static void enable_os_lock(void)
> > +{
> > +     write_sysreg(oslar_el1, 1);
>
> should be: write_sysreg(val, reg);

Yep, I'll do this once I rebase onto 5.16, as the sysreg rework isn't
available til then.

--
Thanks,
Oliver
