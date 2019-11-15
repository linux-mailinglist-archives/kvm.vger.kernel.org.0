Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2FAFDB4C
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 11:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfKOK04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 05:26:56 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:37548 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbfKOK04 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 05:26:56 -0500
Received: by mail-ot1-f68.google.com with SMTP id d5so7605892otp.4;
        Fri, 15 Nov 2019 02:26:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pem47e68QsfR2xvNK79o7bq8NBfMBA9ulZTmR6QPBXQ=;
        b=K1vHfbFJfFav1lGD0zptMCjxNGjlxHQMOTx24Z7vDAV4oGg6LhS7onR1GIpDJm9eew
         OSAYPM64Lekp3X3ycoMo3UD4FYI7hh+16fK/1bYK08Vh4EIbxOSWNSiOMLjYTQIFfU4G
         WqhhwBhtGiU/itI9TEAUspMcy21LbP33lncsFmv+0+jq1J0vfKK6OHM813aVJTS+eWG3
         Am0nSyIyvHS/9gKX8VdtDQpl+fAiPQwo8e08BxwW9cWPgRnK6J4oMV2jbj+q85QcMqF7
         Tsmdy0BtIAS3JYJTVpABZoFGqxiAX07DTTtTUfEiuEn9WPwecLSlyybRQk9MVKWMwDK5
         jtUg==
X-Gm-Message-State: APjAAAV04iwVukIyc2QvqA0K1HoYlIaPFw19vuTYAaWH6dqZwosyj8CO
        B6mDNl1PWWmXDi1Ir0r6KoP0x3gF4O6I0Ym3+ew=
X-Google-Smtp-Source: APXvYqztMO0pme2trK3Xq1OxPCXqw9OHvMhjZFp3BASCzEKVIw6hhkm5ZGbKg8xG2i1KfPlviXBRToiXidUY4AKPnF0=
X-Received: by 2002:a9d:6b91:: with SMTP id b17mr10218038otq.189.1573813613955;
 Fri, 15 Nov 2019 02:26:53 -0800 (PST)
MIME-Version: 1.0
References: <1573041302-4904-1-git-send-email-zhenzhong.duan@oracle.com> <1573041302-4904-2-git-send-email-zhenzhong.duan@oracle.com>
In-Reply-To: <1573041302-4904-2-git-send-email-zhenzhong.duan@oracle.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 15 Nov 2019 11:26:43 +0100
Message-ID: <CAJZ5v0gyszPOvUxd8WX8gxc1OvX_nLUGh3vKn=aXWRj52L76yw@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 1/4] cpuidle-haltpoll: ensure grow start value
 is nonzero
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 6, 2019 at 12:56 PM Zhenzhong Duan
<zhenzhong.duan@oracle.com> wrote:
>
> dev->poll_limit_ns could be zeroed in certain cases (e.g. by
> guest_halt_poll_ns = 0). If guest_halt_poll_grow_start is zero,
> dev->poll_limit_ns will never be bigger than zero.

I would rephrase this in the following way:

"If guest_halt_poll_grow_start is zero and dev->poll_limit_ns becomes
zero for any reason, it will never be greater than zero again, so use
..."

The patch itself looks OK to me.

> Use param callback to avoid writing zero to guest_halt_poll_grow_start.
>
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> ---
>  drivers/cpuidle/governors/haltpoll.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/cpuidle/governors/haltpoll.c b/drivers/cpuidle/governors/haltpoll.c
> index 7a703d2..660859d 100644
> --- a/drivers/cpuidle/governors/haltpoll.c
> +++ b/drivers/cpuidle/governors/haltpoll.c
> @@ -20,6 +20,26 @@
>  #include <linux/module.h>
>  #include <linux/kvm_para.h>
>
> +static int grow_start_set(const char *val, const struct kernel_param *kp)
> +{
> +       int ret;
> +       unsigned int n;
> +
> +       if (!val)
> +               return -EINVAL;
> +
> +       ret = kstrtouint(val, 0, &n);
> +       if (ret || !n)
> +               return -EINVAL;
> +
> +       return param_set_uint(val, kp);
> +}
> +
> +static const struct kernel_param_ops grow_start_ops = {
> +       .set = grow_start_set,
> +       .get = param_get_uint,
> +};
> +
>  static unsigned int guest_halt_poll_ns __read_mostly = 200000;
>  module_param(guest_halt_poll_ns, uint, 0644);
>
> @@ -33,7 +53,7 @@
>
>  /* value in us to start growing per-cpu halt_poll_ns */
>  static unsigned int guest_halt_poll_grow_start __read_mostly = 50000;
> -module_param(guest_halt_poll_grow_start, uint, 0644);
> +module_param_cb(guest_halt_poll_grow_start, &grow_start_ops, &guest_halt_poll_grow_start, 0644);
>
>  /* allow shrinking guest halt poll */
>  static bool guest_halt_poll_allow_shrink __read_mostly = true;
> --
> 1.8.3.1
>
