Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543AB6DDD36
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 16:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjDKOEs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 10:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjDKOEq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 10:04:46 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09A1DA
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 07:04:30 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id d75a77b69052e-3e673b5f558so97721cf.1
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 07:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681221869; x=1683813869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ObdoeChQcItUvJoxx6fgM01ChSWGbuNjYZaGy42/Xgc=;
        b=GIUiIo52FxZR/ge9yLpdrHK8Vd7PbFF41B+JDeNqJJYTu1+vWIqAvpHe57uHflj+qY
         6xuJDGaU/uOUSqmNW3SjXvcsZp9Z7jZLzeGZJk0Iv70APj1iFS/Tf4ME89DHcSbiQQJG
         4fG4SsJBOZ4g1Mzv6xCB1k0BF7z9xeOcMdJFyYDbZ/v+mr65FzlAGydKRjsRObv8/oP7
         Edymj7/4gX97C1TX2EUBDV5BbchHfEQ+osh0Xb9WpHPtlINUfuDfSVfZUDPCt10Flr31
         JyMe4NHnmKtKVzrUkHAt9YAFO8dCUthO4QDmsvuYX3gu/DXEk4fxRg2SUKIy5x7zPGXN
         GxpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681221869; x=1683813869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ObdoeChQcItUvJoxx6fgM01ChSWGbuNjYZaGy42/Xgc=;
        b=uu5JQVanUqr7vkoCPEkUO0AmaW90wXys0dxOY+D89qshyUBG3LV5LR+eocsLsRJjbt
         qLRWEgdtpnYoXk93u/6u23wH5fu+jSX5LZ9La3re0P/JrWUsYynXIaUVYQ449AJAGKQy
         nyWoa1rz1AOGhAghtHBfrC4qyihrU8p1548SiRrYWlQg5sSkT02LDlf2IVU82lRp1UYD
         R+SymGUCRIk9mhlDgQBHvhU9AgZ/XVZA1VzrKFeUPPDE6ZuBPenxYtPkRNKfR6rjXsL3
         JYWTKCPknEu8w9S8tcG7Bq0nRqB0w4JoCxyWdn6d5ESQKLJNRCFkClCAbpTgvB2V4X7H
         7IhQ==
X-Gm-Message-State: AAQBX9d4MHwDT9zz2ICV/X5uDTKcickU1j6wazDl6u+DiFRynoXtu60J
        ZS9GAB+fxj9lmvJ8pi09m7lwmY1OKZ5wkD06edQODQ==
X-Google-Smtp-Source: AKy350YoKIK9MRRT7vbBKhvrHgsw3x93yIlZMluXUn4zTSI3HJXprDbOvC6ScBgIz7cl/UxLkgyCoUQPRHYq0NVIJIw=
X-Received: by 2002:ac8:5850:0:b0:3e6:8b27:bac2 with SMTP id
 h16-20020ac85850000000b003e68b27bac2mr287872qth.17.1681221869384; Tue, 11 Apr
 2023 07:04:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230405004520.421768-1-seanjc@google.com> <ZDRIjY2yycby7EZX@google.com>
In-Reply-To: <ZDRIjY2yycby7EZX@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Tue, 11 Apr 2023 14:04:18 +0000
Message-ID: <CAAAPnDH_6EhaXG-TxgPKM-yPTjkNU-Dx7FV_BJs+YLW=t-vMnA@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] KVM: x86: Fix unpermitted XTILE CPUID reporting
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 10, 2023 at 5:34=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Apr 04, 2023, Sean Christopherson wrote:
> > This is v4 of Aaron's "Clean up the supported xfeatures" series.
> >
> > Fix a bug where KVM treats/reports XTILE_CFG as supported without
> > XTILE_DATA being supported if userspace queries the supported CPUID but
> > doesn't request access to AMX, a.k.a. XTILE_DATA.  If userspace reflect=
s
> > that CPUID info back into KVM, the resulting VM may use it verbatim and
> > attempt to shove bad data into XCR0: XTILE_CFG and XTILE_DATA must be
> > set/cleared as a pair in XCR0, despite being enumerated separately.
> >
> > This is effectively compile-tested only on my end.
>
> Aaron, can you give this series a quick spin (and review) to make sure it=
 works
> as intended?  I'd like to get this into 6.4, but I'd really like it to be=
 tested
> on AMX hardware first.

LGTM.  I ran the test on SPR and it worked as intended.  I also tried
it with the dynamic feature enabled, i.e. XTILEDATA, and that also
worked as expected.

The first run the guest XCR0 was 0x2e7 and all tests passed.  The
second run the guest XCR0 was 0x602e7 and all tests passed again.

Reviewed-by: Aaron Lewis <aaronlewis@google.com>
Tested-by: Aaron Lewis <aaronlewis@google.com>
