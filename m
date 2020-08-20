Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D4D24C47D
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 19:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730535AbgHTR1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 13:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730276AbgHTR1D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 13:27:03 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FB1C061386
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 10:27:02 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id m22so3426305eje.10
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 10:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ewf+8/r8T+ocxKAIGX5h4PS/z3AFtkho8eATC5y+uhk=;
        b=Obfep8GDwJOj8YMmWlFSdQIaFfUZJNxuZ5wnp6NBFTdGC1SWtA7KpTHvf8PBpiWPAn
         JqBBAh1AwFctNZhfCq+fpMqkU79ayvttXSKA9YKcYkbispcHyReyR43IT1odLe623ZdL
         WxHmxQ95LGYxJkWiSyFsTSKr347gPRgj0DMF5OmyTL74Sl/Ug0zxcC4voImal8izbf+V
         WXCvCHG2db4v6DoE1dkkXT8UFoIy63ZFuOhfHawK8hOlKM9m43nkhJd59QFhM7a8N2yO
         OWF6GLQHwH5KMB1q5GdRLrsxztCQUjBdlwhB+IWWjLze8q0LHgLzQDsEztxo62B438eZ
         Dtdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ewf+8/r8T+ocxKAIGX5h4PS/z3AFtkho8eATC5y+uhk=;
        b=SpLloR2buUCaAI/BtAhI/bhCkdc1bk4aulwNoUps90bMRiuSU1iECV1riQ0Gsq42uM
         hFhJmC5pcdlSwdIzHyCgQLSBuCco/zxcSTZ9o6Nu2FjdKT1r4RQSRncdKkX4tVIhcQSm
         Ic6Pdm7uJvMRvjDoQr9FPQLHcU9BlNZwV/T9fb63PDJKdMIcKd+lxsEcB4390HTFDQ5Z
         cffjRZSZCyKv3O128P+951CKQQyvFIho4hGzbrA3Hbd6ohN4xDSBwWpaEstWSTugIyIr
         K7S6YH7VGlc7gpH4LUaNbjW7UvVDrsjYF0EZR25Mk46RfCgNaVrTVozOKdXDKKncizmr
         7eiw==
X-Gm-Message-State: AOAM531vPq3IGTVQeXIRYWt24r+8f12fkaKx/R80FXn4ajnqmtax0ZS6
        K9QFrOpkSpCvoIQZJrGERUOB8VYYwvR8qG7DBof6SQ==
X-Google-Smtp-Source: ABdhPJxvAaKLLKKwXl1PefuwOJJemDCdpMhoIxK+ZZQ0EotjoFeAdC2HBCnvUkCHnM+WkXakEtqpibQt5p8Q6LwTQbc=
X-Received: by 2002:a17:906:d187:: with SMTP id c7mr4456457ejz.196.1597944421480;
 Thu, 20 Aug 2020 10:27:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAP045Arc1Vdh+n2j2ELE3q7XfagLjyqXji9ZD0jqwVB-yuzq-g@mail.gmail.com>
 <87blj6ifo8.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87blj6ifo8.fsf@nanos.tec.linutronix.de>
From:   Kyle Huey <me@kylehuey.com>
Date:   Thu, 20 Aug 2020 10:26:47 -0700
Message-ID: <CAP045ApB9Ju+V2HsTb=z19Y5+AgB9eHhS_QEiv1E8cLdreewzw@mail.gmail.com>
Subject: Re: [REGRESSION] x86/entry: Tracer no longer has opportunity to
 change the syscall number at entry via orig_ax
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Kees Cook <keescook@chromium.org>,
        "Robert O'Callahan" <rocallahan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-arch@vger.kernel.org, Will Deacon <will@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Keno Fischer <keno@juliacomputing.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 19, 2020 at 12:44 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Wed, Aug 19 2020 at 10:14, Kyle Huey wrote:
> > tl;dr: after 27d6b4d14f5c3ab21c4aef87dd04055a2d7adf14 ptracer
> > modifications to orig_ax in a syscall entry trace stop are not honored
> > and this breaks our code.
>
> My fault and I have no idead why none of the silly test cases
> noticed. Fix below.

That'll do it, thanks.

- Kyle

> Thanks,
>
>         tglx
> ---
> diff --git a/kernel/entry/common.c b/kernel/entry/common.c
> index 9852e0d62d95..fcae019158ca 100644
> --- a/kernel/entry/common.c
> +++ b/kernel/entry/common.c
> @@ -65,7 +65,8 @@ static long syscall_trace_enter(struct pt_regs *regs, long syscall,
>
>         syscall_enter_audit(regs, syscall);
>
> -       return ret ? : syscall;
> +       /* The above might have changed the syscall number */
> +       return ret ? : syscall_get_nr(current, regs);
>  }
>
>  noinstr long syscall_enter_from_user_mode(struct pt_regs *regs, long syscall)
