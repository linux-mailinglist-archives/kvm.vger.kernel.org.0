Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136906D13F1
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 02:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjCaAR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 20:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjCaAR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 20:17:27 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4B6184
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 17:16:21 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id p15so25645151ybl.9
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 17:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680221663;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MBMF8d3KU0G8qPZvlz1c4zQRMBJ9C0FEP2SNIdT2xZ0=;
        b=cS3Eaolwiraj4/C/iRTPhv8AyRVCk4bDQUcZ+Hf9WJjZSEpxO97MtggHDfphUAAdIG
         t88uPMZ32fN0tm9nmRZZGRFah45LhbgZEx10ZsGbv0fTpCFusTd4QZHHDitBb5ouCWS2
         rX08D/y4DDZ9hXIzD7VedmM7c7mJGDiY4oCez9s519HWwuzzdzy6JREB4N0JKJd2KtSK
         Mt3BuVtTfDyoZtai66d8eUjEDmOBuX62WF+9OqQqzRkywpD6i0mmxyJRfSjansSgGRBO
         KNXX4p5MfXct86xlK2kVOLTzcIf6se1bu9uElGS1KkvLZA+5ccnTOoF+TCY/dh0Cxx4t
         mr3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680221663;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MBMF8d3KU0G8qPZvlz1c4zQRMBJ9C0FEP2SNIdT2xZ0=;
        b=Qcj7JP5kQiVuSzNcV/45tqKvxl5R1NdwJOPjplMcFVV8njnIiu98SJSh0Fvw/9tUpb
         ZPyefAK03+uDtSMAUUh0u6zUOdsIufD4jS6U+o3uOJ83fqZztUmyChJz/CKvzV81Y7g/
         l98d0kTWEgyHUMQJVnLND5DInV401w8ZFNo4MuJnO9LbAfExE2X7K9mMUQ/55IBXObsG
         /VFz9IbRCqDdvpKqwbnBvnqG2A1A70HOQ0URm5MGTolqKgGdvZkS4okZRz56+Bfcp2c+
         ggx8wueOS0aV4k/E3slw//HvdJ4Se29gAkf5/lPh6zyqpEag/5WZW3vxkmnqgLri9dhe
         k8UQ==
X-Gm-Message-State: AAQBX9fIcS9jaJMjCj8Ld9NcQCvIDpDKjs7AnaSX4iIamR21W+oUNrIq
        20J3h0SXW8LtNB2vSU+9/7O43gHKI5nYW+A5Lvg4iw==
X-Google-Smtp-Source: AKy350bEaOIL0O6VdQ3BtEPEKEsjkXhwzXmVxhB3RmDcClAyTMyZhCtOSXz9h10VAa9kJ2C/x0GsjCRfsm1qjTAViY4=
X-Received: by 2002:a05:6902:102b:b0:b6c:48c3:3c1c with SMTP id
 x11-20020a056902102b00b00b6c48c33c1cmr17224970ybt.13.1680221662624; Thu, 30
 Mar 2023 17:14:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230321220021.2119033-1-seanjc@google.com>
In-Reply-To: <20230321220021.2119033-1-seanjc@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 30 Mar 2023 17:13:46 -0700
Message-ID: <CAHVum0dV+fjgK-3mcABKACJQrTYNLjaYj-euV4+T6PrFGGd0OA@mail.gmail.com>
Subject: Re: [PATCH v4 00/13] KVM: x86/mmu: Optimize clear dirty log
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
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

On Tue, Mar 21, 2023 at 3:00=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> This is a massaged version of Vipin's series to optimize clearing dirty
> state in the TDP MMU.  It's basically the same as v3, just spread out ove=
r
> more patches.  The only meaningful difference in the end is that
> clear_dirty_gfn_range() also gets similar treatment in handling Dirty vs.
> Writable logic.
>
> Vipin, I'm still planning on applying this for 6.4, but the changes ended
> up being a wee bit bigger than I'm comfortable making on the fly, thus th=
e
> formal posting.
>

Changes look good to me and verified by running perf test also that
the improvement is still similar to previous version. Thanks for the
v4 work.
