Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96A36DCC8C
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 23:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjDJVFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 17:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjDJVFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 17:05:48 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9E119AF
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 14:05:44 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id jg21so15028924ejc.2
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 14:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1681160743; x=1683752743;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d0NfKXzvfN1t0yzQDyXp4Tt6S8OW8LWhha6YniOFGII=;
        b=cid0oD9qg3LCdEZ9sxXoOqS0JjtK9dp2CxQRy8Au/61Gxq/fjujN2okp7c3DHccUiT
         0rFEKISM5C9BKoSYD2QsFaqiyv4+fJIQPf3wPqFtSP0ZdvfWDrPzLowWpck4nyawM/L8
         CPk7KLM+DGBTgm9mU/f4o07x+ef+wRM8OBen0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681160743; x=1683752743;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d0NfKXzvfN1t0yzQDyXp4Tt6S8OW8LWhha6YniOFGII=;
        b=ObdQzyafQoXQCGYYJtG+fYJROdvHlG4nvMEl7MvZwZpaKscZ5WYo0MQEOfFEmDUeqI
         yRWAfUFbQgKAzOoJ7O3v5vdKBxXxMaPklYdhVkIgM76mjGYuBZwxy0Kz7TMoRIJT2P3G
         QLi9AHawbiwwKI1Ba1oBQGJMZIvTBEktL1xtkZbPGDk4tp+kzuGGAOtNGFVxexpKzs9q
         dGpU+dvIoqeUC5NBO4OIndnfmk/v05P8xKg32YuSraKCcx6tmXf/h64qyfiJWI5LDW92
         VvMsmUNYdZLg0sPZ/vu8aiQGhxcpDa3aE9n+acf5QX3wQ/Oh0WNL4no3S4RGoGwyW77L
         ZyOQ==
X-Gm-Message-State: AAQBX9eBYDxUCCxuifywkg+fP/G4N1HRnJcSeBMO2fnzsqomU3IU7A2k
        osffApC+xgsDcUGQRdLTTKF/bQvAglHkLtbhrCXPXw==
X-Google-Smtp-Source: AKy350aNZ2/DiHuFErLW3xIbkhoACt+6gZ03UnrY8U3M4k6IEkXi8jTDnwankHcjpXH/oedaQFaz9A==
X-Received: by 2002:a17:906:2a48:b0:92d:145a:6115 with SMTP id k8-20020a1709062a4800b0092d145a6115mr8277919eje.38.1681160742917;
        Mon, 10 Apr 2023 14:05:42 -0700 (PDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id bk25-20020a170906b0d900b00947ab65d932sm5377812ejb.83.2023.04.10.14.05.42
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Apr 2023 14:05:42 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id sg7so26780838ejc.9
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 14:05:42 -0700 (PDT)
X-Received: by 2002:a17:906:dac9:b0:933:1967:a984 with SMTP id
 xi9-20020a170906dac900b009331967a984mr3287571ejb.15.1681160741972; Mon, 10
 Apr 2023 14:05:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230410153917.1313858-1-pbonzini@redhat.com>
In-Reply-To: <20230410153917.1313858-1-pbonzini@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 10 Apr 2023 14:05:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiYktfscvihY0k6M=Rs=Xykx9G7=oT5uCy1A80zpmu1Jg@mail.gmail.com>
Message-ID: <CAHk-=wiYktfscvihY0k6M=Rs=Xykx9G7=oT5uCy1A80zpmu1Jg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for Linux 6.3-rc7
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        oliver.upton@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 10, 2023 at 8:39=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
>   https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
>
> for you to fetch changes up to 0bf9601f8ef0703523018e975d6c1f3fdfcff4b9:
>
>   Merge tag 'kvmarm-fixes-6.3-3' of git://git.kernel.org/pub/scm/linux/ke=
rnel/git/kvmarm/kvmarm into HEAD (2023-04-06 13:34:19 -0400)

Nope, not at all.

You seem to have tagged the wrong commit. Instead of pointing to that
"kvmarm fixes" thing, it points to something entirely different.

Please double-check what happened.

                Linus
