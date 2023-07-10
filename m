Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B4674DB02
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 18:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjGJQZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 12:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjGJQZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 12:25:48 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57ED94;
        Mon, 10 Jul 2023 09:25:46 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id 3f1490d57ef6-bcb6dbc477eso4303050276.1;
        Mon, 10 Jul 2023 09:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689006346; x=1691598346;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rcUxYhRfSgJ6UJMmI4gvN/iDnQgX6gIvJpFELMHmLcE=;
        b=V8r9oUmNILl8gpI7KePWigjGb6juPhMnDQ/wrv4DQP5As/oXU9XrXK246f9ZHhlBJL
         NgW9whpWQvfU7c+x8gRKyIabFQLq8y1KB/91koW4cjzXCsMLGDiimO1rnhQ4A+SGtHR5
         0qPaQafXZZht0IpaBmneBm8MpeuLhudZwHH96ZviOLxHsfACKzldhpgZodjAA0l922q2
         pnlbiw/dn1xzxjuAiZWozy6KLAqPUfb7KpDVMBORNS1iEcJq7uIR6HeZQpCMJbhktMq6
         tW+actNpC+n4lGbQUGm2PT9us1+XZ/aHXZ8LEEsgbXOFg1elQLdqT5ptELvD1jDfTUxq
         L3bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689006346; x=1691598346;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rcUxYhRfSgJ6UJMmI4gvN/iDnQgX6gIvJpFELMHmLcE=;
        b=c0iWJCeBeGK5/IGy2EXtqVG60n6LiBsLNY++57l1FYElrynBNw3JrJ8AaUVXQ0mETr
         fJdIsHL30AUM93ANv7CNFRmukrghVrXP4x5F8JQRlqxFnfLHJmodLrnkCyt0IdO2Cmjp
         YB7MQHUt7eCkMLTqt9gm4U1MQr939prplMBnh/DlDtXmb6Gvam4DNMNcWIeRSoC1hIJV
         q2pmZubu117k9gHvAyGoZx6w3nXTBzFl1hT4Phi2xxR6xb0Vv/Wy1oVeJfgJ0R9xbLXm
         9R74kSTh8eM+JQ5iu59TlxPErkPoX5ZBM9LO9HdfG8AcnU9vIb2SVvcmcjyiXqswOsQg
         iflw==
X-Gm-Message-State: ABy/qLZwku94AKpV7VfHah4To9vWD1bkjE6ZCQO3kg/pmGp2MUn8XZgl
        3ui2ytJToFzcZS7sIlV1zaeR2APk1Lg1xlAW3dk=
X-Google-Smtp-Source: APBJJlE/krGaema6oAIGHffoO9jr9rNxV2NJ9f2ty64/UeXp1MrrtGwo2Rtyks4ROqL/F/KxuN96NsyBfRrrBujlbXI=
X-Received: by 2002:a25:c0c8:0:b0:c86:55c7:d053 with SMTP id
 c191-20020a25c0c8000000b00c8655c7d053mr2292204ybf.25.1689006345894; Mon, 10
 Jul 2023 09:25:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230710130113.14563-1-tzimmermann@suse.de> <20230710130113.14563-10-tzimmermann@suse.de>
 <CANiq72=9PoV3FOcXx9FdiSLePKXDG4BSY_5-jddBkqDL=ua3FA@mail.gmail.com> <733273ad-89e1-d952-37ee-bb75c3ab8188@suse.de>
In-Reply-To: <733273ad-89e1-d952-37ee-bb75c3ab8188@suse.de>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Mon, 10 Jul 2023 18:25:34 +0200
Message-ID: <CANiq72kPh2KE=ADUxhPyyr7noWhC0fkzmDu8EBn_20focnZqtw@mail.gmail.com>
Subject: Re: [PATCH 09/17] auxdisplay: Remove flag FBINFO_FLAG_DEFAULT from
 fbdev drivers
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     deller@gmx.de, javierm@redhat.com, linux-sh@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-nvidia@lists.surfsouth.com,
        linux-hyperv@vger.kernel.org, linux-omap@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        Miguel Ojeda <ojeda@kernel.org>,
        Robin van der Gracht <robin@protonic.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 10, 2023 at 5:22=E2=80=AFPM Thomas Zimmermann <tzimmermann@suse=
.de> wrote:
>
> I'll append a patch to the series that documents this.
>
> Sure.

Thanks!

If you are planning to take it into some other tree:

Acked-by: Miguel Ojeda <ojeda@kernel.org>

Otherwise, I can take it into the `auxdisplay` tree.

Cheers,
Miguel
