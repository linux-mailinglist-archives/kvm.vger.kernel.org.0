Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605AB4D88C9
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 17:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238649AbiCNQJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 12:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbiCNQJi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 12:09:38 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FF027FD5
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 09:08:27 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id e186so31718935ybc.7
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 09:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2HGDRUKrwEN1d1K0bkDUZOaGvLo7SAJZqfbA6vVtahI=;
        b=SdKfd/jbfGl52GQYetUtYUdEOsWHs/OwcXpH/I1S9dZeNmPMmDUjhk4fg2k0fckDY0
         t23UvUz0VX5KFhJVhe9QE4pxDN4WgSxdl2ub9UvFNGfWLksZPY3qve78zZUa/T+keflA
         4AqyVh/8j+AuQSOjaa97O9K94KoTPLgUsD1vsKJvk2RgSco0dDjxktClnkVR6rNfUD1j
         zklsyhplOXYFaLqTldx9pYgtu++atT9y1Dw4Ghx51Wl3kAxno8itR1Ko8ofxlm++dFis
         qihdx8K0f1b56+t1POBlkbGHXwMXu7ECfibDcuW0asoel4nuFfOu+/4Uh3pw02Ppe5lO
         w2XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2HGDRUKrwEN1d1K0bkDUZOaGvLo7SAJZqfbA6vVtahI=;
        b=6UeNgG4bksx7xiH9959ahN6u8PtciIT8iDADURrVl7S2hn1X8fws4RtLoeQnQb9aYC
         gXTaMFuKcRKCiEYGYk7w0xEQss3XDMgGhXni5pMEy/Rcs3QfbOQyeuOFHX/cLFPz58lT
         8Wo8PzaK+BODOxy2sVYiFooT00bL54m30omG9EY8c10iX7A/ADS7s66qixdVtQx9G1Hs
         WuoseP7QVb0VeJiPdYjGyz7QblLInvdxph3gOMF9jbXBSYx2IcVqf6nD/Jtc2P00cABm
         vCWk6ZF185YdxJBzpXl77Kb43B1Ecx1fkhFlpGaD8BUnyAncGWTakjJm66NOtr5G8cxV
         B95Q==
X-Gm-Message-State: AOAM531RoR8B8HHUUpiCs+7iPm3bAlnundZnlGxeWld1iSdklrbuiylp
        1vPECcrDdnf/iQEYv/CtxkIhI/hWyVsSUYchJ5/eJw==
X-Google-Smtp-Source: ABdhPJyW6M/Aw8hf4XdJy6WjUtmqQsp6CbpUtiBE5nkkoLRyKFw/dasDSxXiwKCdKxH3YAqMGp/y61XBal4OddxiDeY=
X-Received: by 2002:a5b:350:0:b0:628:86b8:6e09 with SMTP id
 q16-20020a5b0350000000b0062886b86e09mr18269446ybp.39.1647274106395; Mon, 14
 Mar 2022 09:08:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220314160108.1440470-1-armbru@redhat.com> <20220314160108.1440470-4-armbru@redhat.com>
In-Reply-To: <20220314160108.1440470-4-armbru@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 14 Mar 2022 16:08:15 +0000
Message-ID: <CAFEAcA8Tb7e+mJGaietc5si7_xZWxbTixcTSvNpB9wH_LQJ7kQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] Use g_new() & friends where that makes obvious sense
To:     Markus Armbruster <armbru@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>,
        Laurent Vivier <lvivier@redhat.com>,
        Amit Shah <amit@kernel.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?Q?Herv=C3=A9_Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Corey Minyard <cminyard@mvista.com>,
        Patrick Venture <venture@google.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        Jean-Christophe Dubois <jcd@tribudubois.net>,
        Keith Busch <kbusch@kernel.org>,
        Klaus Jensen <its@irrelevant.dk>,
        Yuval Shaia <yuval.shaia.ml@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Magnus Damm <magnus.damm@gmail.com>,
        Fabien Chouteau <chouteau@adacore.com>,
        KONRAD Frederic <frederic.konrad@adacore.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Konstantin Kostiuk <kkostiuk@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Pavel Dovgalyuk <Pavel.Dovgaluk@ispras.ru>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        David Hildenbrand <david@redhat.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Colin Xu <colin.xu@intel.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Eric Blake <eblake@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        John Snow <jsnow@redhat.com>, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, xen-devel@lists.xenproject.org,
        qemu-ppc@nongnu.org, qemu-block@nongnu.org, haxm-team@intel.com,
        qemu-s390x@nongnu.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Mar 2022 at 16:01, Markus Armbruster <armbru@redhat.com> wrote:
>
> g_new(T, n) is neater than g_malloc(sizeof(T) * n).  It's also safer,
> for two reasons.  One, it catches multiplication overflowing size_t.
> Two, it returns T * rather than void *, which lets the compiler catch
> more type errors.
>
> This commit only touches allocations with size arguments of the form
> sizeof(T).
>
> Patch created mechanically with:
>
>     $ spatch --in-place --sp-file scripts/coccinelle/use-g_new-etc.cocci \
>              --macro-file scripts/cocci-macro-file.h FILES...
>
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---

>  104 files changed, 197 insertions(+), 202 deletions(-)

I'm not going to say you must split this patch up. I'm just going to
say that I personally am not looking at it, because it's too big
for me to deal with.

-- PMM
