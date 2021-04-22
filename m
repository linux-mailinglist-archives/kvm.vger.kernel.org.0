Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82929367D9D
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 11:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbhDVJWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 05:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbhDVJWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 05:22:32 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C62C06174A;
        Thu, 22 Apr 2021 02:21:58 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id i25-20020a4aa1190000b02901bbd9429832so9821702ool.0;
        Thu, 22 Apr 2021 02:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sTsRqg+iSGDJKgDYHRuF7eGJxXnfL0XzsJ5wibmVRLw=;
        b=eJK31DzkK7e34q83D97+fPgEpUWA1RwTTqhBPgd8uMEL+TwIlhMAb7r7TgSzIEdFJr
         OwPtQV/tG5pJGencC0Drth0wMtOXv9Vgmo8QiUJ02lp7l0t8xbM5v8MdWjOcPuywICpN
         OukM+dIP1hip70Ts8nTRKfH0mQAf+LjtQXKYKkYVN6ME/uEj8H+wcyZbQIQUiBPmjHGd
         00HjgPs0cbVWrSS0Qjt01aP0Im2sKm+Kvhb3e0os6XGv2cDDUWXgWO09oR4iXsK3eAUD
         uyxIElpqbUX7EeKI1V0NIOAoSVgM25y6RvxCLUbk9TTHLmw6nrPWQ4TGqX1f+FRuPi6e
         ojvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sTsRqg+iSGDJKgDYHRuF7eGJxXnfL0XzsJ5wibmVRLw=;
        b=Zd+IvaiNqqQnKPdNCGqOAKjiMy0G9sVsCw2/m7Wr5wemyMyMMNmiwU/Spe8wkROhGD
         31WszLyu5y6DzIOpHP3uI8AIo/NSlS15yb96ijw5Hsi4yLuy5nr3n2hFAJfV4rBB0zxY
         IF/6lXVyVZcc70OkyVoi5M+nY4bi+ryYgNfG8r1oAkrU9rCHmi/T3Jc+zT7bvk6lJtRA
         m75QkwLz8xAF+peBA6Z9baBNJjyR3xEfcdotiBj2bDbwS5wgiBgz1wRlbm2siR8DzJQI
         d7aZJqSwpYf+QqzcG7vf3GmkKu7d2vnPpgJ8i913npWgN+X+DTrcHpWLH1WIVTM0gVV2
         4khg==
X-Gm-Message-State: AOAM532QMpUCduIx+dG4ebdIxzoYk7q6lHjwn4YLbAJj/r0vWahmlP+M
        o/iJZLTSzNVfEl1ZacowMHTz3yK7GtdI6m15ao/3OKUN
X-Google-Smtp-Source: ABdhPJwvz0CZoQiatZ+w4b2Klndf0vu3VS+LB2o4SVXRuHdA/uMeJNufnr08FcHWaBqXZc9VvWFf4BsS/sQRsbFD4g0=
X-Received: by 2002:a4a:8e18:: with SMTP id q24mr1732544ook.66.1619083317800;
 Thu, 22 Apr 2021 02:21:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210421032513.1921-1-lihaiwei.kernel@gmail.com>
In-Reply-To: <20210421032513.1921-1-lihaiwei.kernel@gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 22 Apr 2021 17:21:46 +0800
Message-ID: <CANRm+CyXAjvkR6VBh=Nu1KFS=T+_9NX5bCYEWsB4KfmxPn2kLw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Take advantage of kvm_arch_dy_has_pending_interrupt()
To:     Haiwei Li <lihaiwei.kernel@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 21 Apr 2021 at 11:26, <lihaiwei.kernel@gmail.com> wrote:
>
> From: Haiwei Li <lihaiwei@tencent.com>
>
> `kvm_arch_dy_runnable` checks the pending_interrupt as the code in
> `kvm_arch_dy_has_pending_interrupt`. So take advantage of it.
>
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>

Reviewed-by: Wanpeng Li <wanpengli@tencent.com>
