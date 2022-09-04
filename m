Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D79765AC227
	for <lists+kvm@lfdr.de>; Sun,  4 Sep 2022 05:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiIDDan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Sep 2022 23:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiIDDam (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Sep 2022 23:30:42 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88122419AE
        for <kvm@vger.kernel.org>; Sat,  3 Sep 2022 20:30:40 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id 6-20020a9d0106000000b0063963134d04so4154193otu.3
        for <kvm@vger.kernel.org>; Sat, 03 Sep 2022 20:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=12o6ND8xcnqetqquOvWORDsjaLH/mgDaPvptFjvaTw8=;
        b=Z4+Z8Iwy3MfsJtmOuuIGbQtdI3HpaD+Lt/49XDR9tM3ZwBLdmdQ+BMpTTvPCpdexw6
         SW8/TlnEqochzcuQr2FzI4rg5WD7u6D7/TSGGbWZIaBYpqxeETsbYWYc7uRuwqhCdA8y
         D5mBvDXWa/1qF/nhkpxc6GsaAgMbTDBjdRrhAPSlvmE/33wI6lM8ptbHJpo2zHru2i8r
         spJevHEpoA2oaO7UyvOsc4kQC2qVdVuvz5toSVhoJynaEkBiSd7DFwVnhfVVKyt5dsG+
         cD01DGYi1d2oiy33CqCiAVcN/V14DdRJeYPk6lih+oOUC3YCuN18vT7rktvbXWRrE/xQ
         EGGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=12o6ND8xcnqetqquOvWORDsjaLH/mgDaPvptFjvaTw8=;
        b=p/kvr47ZLrTVncaR5bEfKMJwngWwqWa/P9QleMVCypjCMVGozHBdaQ5zJBig1og9CS
         ZbFfvJ3DSVe+W1PsTlw5nSfsAobGg/EWUYZ5lMNGYnuemFbewE2BH3zBAJewYN0FW6Lf
         zHJgQx2MOpLUH3lZXBywotWnDSSxtVNXnz9NglnPf20YVOO5roRu+f52XIdLU6jNxXI3
         ZEADlzuKbkQoSwWwNrjWdl6IDNmx76AV+ZpGAhjkk7KqdoC4Btu6r25Sdd19G4h5tHkP
         i541ia2Ee+90koM7gEPS+dBM3ZHK+Fm57TioDrlh7i4T0tMSSbm1hadamdxnF6u8MwCO
         0X6A==
X-Gm-Message-State: ACgBeo2EdA9HnQCnrY9CwPfrZrGm30YgASDf7jaesQnWrSkgsfD51tmj
        BWJYrx4yU3Usj5867BNIGHfL7bjmax8S7akhHrZGIQ==
X-Google-Smtp-Source: AA6agR59I6jf4nToIP1X2yLINF6mw3JM5cHIiuyqeHtmae8lFObOtLPir6HaYxYMGj+vo5s9ITFRekcTRLKRpN60tvA=
X-Received: by 2002:a9d:4d99:0:b0:639:1fe0:37c1 with SMTP id
 u25-20020a9d4d99000000b006391fe037c1mr16422230otk.267.1662262239680; Sat, 03
 Sep 2022 20:30:39 -0700 (PDT)
MIME-Version: 1.0
References: <CALMp9eRkuPPtkv7LadDDMT6DuKhvscJX0Fjyf2h05ijoxkYaoQ@mail.gmail.com>
 <20220903235013.xy275dp7zy2gkocv@treble>
In-Reply-To: <20220903235013.xy275dp7zy2gkocv@treble>
From:   Jim Mattson <jmattson@google.com>
Date:   Sat, 3 Sep 2022 20:30:28 -0700
Message-ID: <CALMp9eR+sRARi8Y2=ZEmChSxXF1LEah3fjg57Mg7ZVM_=+_3Lw@mail.gmail.com>
Subject: Re: Guest IA32_SPEC_CTRL on AMD hosts without X86_FEATURE_V_SPEC_CTRL
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Moger, Babu" <Babu.Moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 3, 2022 at 4:50 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:

> [*] Not 100% true - if STIBP gets disabled by the guest, there's a small
>     window of opportunity where the SMT sibling can help force a
>     retbleed attack on a RET between the MSR write and the vmrun.  But
>     that's really unrealistic IMO.

That was my concern. How big does that window have to be before a
cross-thread attack becomes realistic, and how do we ensure that the
window never gets that large?
