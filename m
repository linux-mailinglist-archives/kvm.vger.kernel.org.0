Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623126AF5AF
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 20:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbjCGT2o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 14:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234073AbjCGT2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 14:28:14 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DC1CB676
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 11:14:15 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id i6so12462281ybu.8
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 11:14:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678216453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WiDH7FJkKPaJyC+pV4xCyIR+9zxms7G24HbfyQXYfQU=;
        b=Rj+V5qCx4H6DSLiXNF7NIxmJYyNgSATd6yjgszkMyFK8UBJIMCjq30dEyZLMBttN9t
         Y5/8uoD7cZCMD+/hXU9EIK6u0esASjwDCscjr1v2CDHykgR3uE3wp0G2C1RYNbfIP5uu
         OfDWqS7N9qGf+LvtczJWOBCWEour5Gx62oHut1BxRPdNzBTu1TgJKRKrLo8VtFWYh3Qx
         tMM8xlIJJliFfuRz6kXenX+AASKmr6jEZ2biIuDQFo3cm3rL8MWIfX9wd/Sp7D3wNNXh
         LaKO0OQgWY6TYJlDGHWlx5pORyUPxkN2fp4RxmDnE9HGt4Dt0rCWNddGWf/vqPuwSCC4
         afYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678216453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WiDH7FJkKPaJyC+pV4xCyIR+9zxms7G24HbfyQXYfQU=;
        b=lBLvKYxjK5Z7k5Qf9NIJMlGMTIknKVThLvG9i91MzjlgpNXfKPj7fLMONZVn9zYIqt
         5VezNTs68il1kvD7ATvyBDdN0u56O17aKzsEBTwcC3/W+rXs2zNzBdCDEALALUuilFYv
         Bw8AmoEsI+C5fskgRnSYikCib3RhYTTUsiDMhGE7LbpjeUJJRHH7u31j42XHfr4JZCD5
         iBLd1jdfaUMxkalYIZDrgsSZirPSxyjcwRPi6B/Iki7AEgMoYk2wuxZATbKnuQnfnJDr
         hQrzSXhBKbBe6JOqGCrdDdpXqHHIDYl58Ctx/I3Nor+OWRVnFwSUmOonfQu+yn7SQGZe
         8Ifw==
X-Gm-Message-State: AO0yUKXNXa92t24gsu4/ehdiqnEPUzk1E5x8rT554GRM730L7tOslOFX
        mTrVyvg8YtSEgm2LeRHKQ1485muD/JGXGN5xePEEVw==
X-Google-Smtp-Source: AK7set96UY/Tcty5owJ/5XoxfcKCevFzPi32g6qI1hX5ei+Cn/Zb8QJMcFiunAwkvNdeaCMbW+7hGPa0I23wFrmveJ0=
X-Received: by 2002:a05:6902:c3:b0:9f1:6c48:f95f with SMTP id
 i3-20020a05690200c300b009f16c48f95fmr7499398ybs.5.1678216453133; Tue, 07 Mar
 2023 11:14:13 -0800 (PST)
MIME-Version: 1.0
References: <20230306224127.1689967-4-vipinsh@google.com> <202303071940.sFeQ4FpU-lkp@intel.com>
In-Reply-To: <202303071940.sFeQ4FpU-lkp@intel.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 7 Mar 2023 11:13:37 -0800
Message-ID: <CAHVum0eW+AKoMt2nB=52cDpvoVHX1A4tHmdV-4f21hV49c4o8g@mail.gmail.com>
Subject: Re: [Patch v4 03/18] KVM: x86/mmu: Track count of pages in KVM MMU
 page caches globally
To:     kernel test robot <lkp@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com, oe-kbuild-all@lists.linux.dev,
        jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 7, 2023 at 3:33=E2=80=AFAM kernel test robot <lkp@intel.com> wr=
ote:
>
> Hi Vipin,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on kvm/queue]
> [also build test WARNING on kvmarm/next linus/master v6.3-rc1 next-202303=
07]
> [cannot apply to mst-vhost/linux-next kvm/linux-next]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> All warnings (new ones prefixed by >>):
>
> >> arch/x86/kvm/mmu/mmu.c:676: warning: This comment starts with '/**', b=
ut isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst

> vim +676 arch/x86/kvm/mmu/mmu.c
>
>    674
>    675  /**
>  > 676   * Caller should hold mutex lock corresponding to cache, if avail=
able.
>    677   */

I will fix it in the next version.
