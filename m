Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7222F1D15
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 18:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389867AbhAKRte (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 12:49:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389852AbhAKRte (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 12:49:34 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9406C061786
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 09:48:53 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id 3so42345wmg.4
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 09:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=HjFjB02VUOcj2JDmR/K56mtMUPw1JqKruxO3gsfgtG0=;
        b=Z1BLHnk/IllfoIqIlxKJ0XD2wgjI2evX/5XsMH9aGtoY/foB5Zp0OZr8+O18Z54N3P
         vFsoIVlUr7x9Y30UZt1g+VOvY8vJ0NhhFFf2vN/wzVP3Kpz1pVqYsTLQ3muqdwj0v8Y5
         F9VbBO51j75TEHi3Hsgg7/C+0sYNIOp0sLXBtkDC9Q/35JGz6cyiqvyi3+ptkFR33Rvf
         3RBT2H7VMu8ETRySwN8DK70ixgS2jWeoVWpQS1Wylo7thAyY7nH2Kq28D8Zatl3+Bobs
         TdnNFPVrst4l7kXfPxCLsQ62wZ5e8A8OpP+u3d7lU4jKfBn2zsMJ+iKqTpkuPX5Vqm2S
         db4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=HjFjB02VUOcj2JDmR/K56mtMUPw1JqKruxO3gsfgtG0=;
        b=iNwVsC3FV9EK7D0rrxzEkoSg4LT7jHJSpUtb0ue0/OxTtrJiOY/iyVzbuBGvOlGWGH
         G8+LggWIIeNRJTQ/GmsC348qFxpgiBw16Tt7x5b4SM9tnUxnBtKh1lnpH4G3Lmr147+9
         FB7hbvN7dHXmwkngH2MHZHmxVXh58txGVUD4qRWhgqfp03ZrxImBu6Znbu0E8Mmfi0Is
         KfGr4H1NzRpSCyOggJ5IHPLYprx7MT3Bvo7xZvziLL3rn/i5N+x0PtLu4GTAIX6Tqmeg
         +O4/I3YkqXkdc/tE0kMB9ySW5imfU/ILu6MsBDUpo0m8+LZtc0Mg6uOxKdBaWWX60MOR
         LDmw==
X-Gm-Message-State: AOAM531WcRYOyFCAYzy/crlcWso2UeXFNLz8OlCwsMLp2Q9Wx4soGYhq
        fv3VJJVkmIcbP1JAzlE4hVVaDQ==
X-Google-Smtp-Source: ABdhPJxFl0pGJIm5UheooE53gyVfAACVfyEjNoEnS7yM3rBuAokl0gYAMKI4jSlEoOleDrcPABVpeg==
X-Received: by 2002:a1c:7213:: with SMTP id n19mr15554wmc.14.1610387332427;
        Mon, 11 Jan 2021 09:48:52 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id o3sm396503wrc.93.2021.01.11.09.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 09:48:51 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id B2CE01FF7E;
        Mon, 11 Jan 2021 17:48:50 +0000 (GMT)
References: <20210111152020.1422021-1-philmd@redhat.com>
 <20210111152020.1422021-3-philmd@redhat.com>
User-agent: mu4e 1.5.7; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Huacai Chen <chenhuacai@kernel.org>,
        Greg Kurz <groug@kaod.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-trivial@nongnu.org,
        Amit Shah <amit@kernel.org>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        qemu-arm@nongnu.org, John Snow <jsnow@redhat.com>,
        qemu-s390x@nongnu.org, Paul Durrant <paul@xen.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        Halil Pasic <pasic@linux.ibm.com>, Fam Zheng <fam@euphon.net>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>, qemu-block@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <richard.henderson@linaro.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Thomas Huth <thuth@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: Re: [PATCH 2/2] sysemu: Let VMChangeStateHandler take boolean
 'running' argument
Date:   Mon, 11 Jan 2021 17:48:41 +0000
In-reply-to: <20210111152020.1422021-3-philmd@redhat.com>
Message-ID: <87lfcznz3x.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> writes:

> The 'running' argument from VMChangeStateHandler does not require
> other value than 0 / 1. Make it a plain boolean.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>

Seems reasonable

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
