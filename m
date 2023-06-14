Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E907E73027F
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 16:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244961AbjFNOzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 10:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245603AbjFNOzo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 10:55:44 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF88C1FFF
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 07:55:40 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-56ffa565092so10845737b3.2
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 07:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686754540; x=1689346540;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7V1DfK2IiNfiJ6A9SuA09e99aiPu5hGJBrKQriatKLw=;
        b=P3MJs55SHNPYRuHaaMsHn7wTydBbtDLmyHmFaHlY00+Zsx/vpA1eWmbCy+31JY9O9d
         fPEj7wT13n2EsFmgJr1tVO76JqXBemecB2BJ4Q+glLjBKS8wyKknqMLkBK26AXQib+8R
         556IGwUSbS9id7HU8dSYrqSp1MvONdbsTf8xeNYcQLz9hXcNaKA5PbpzneJmTeEuTx/6
         p0Sk7nx7XhSvZLkT8+W+hwOhZwTZMV7PsLUKEHTr0r8/lChG1W0+HdGS3grExB6OgVYD
         nm/x+eu6SGbTlFLiuR5C2RGUhS/Ye1ySxvX1IhVPX7dDEAefa3RUUD79vF9L+2vJEPYV
         nIyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686754540; x=1689346540;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7V1DfK2IiNfiJ6A9SuA09e99aiPu5hGJBrKQriatKLw=;
        b=gS+odEMpSg+JLI3fVEOvSpYNUSJdFlSadH5vqh5rqgTLs44d0ZXLPsBsNYgJhx3/kP
         YpYVapiYK6aHyRa0A5psWnBXLi0JFxt2Pu0lWAxg7d/1+7+RhOvTiabHQdBFQyzzCLkz
         7fqdWC3Y/MAM1xvTnbmjQgNPOjEZjgqr0wx1uCB0EbxSwyh8oxP14YGiR/LYIUCEGKYd
         zS0JueN8rTLrS/EOx+Xmn01LjWtX7XDVAY/sQS7IG72SVxxRDsKX+hFySDDOFQrON4Q9
         iAU6OohO1ZmvoYoVaRqXouF/LaLC6doz4By2TRcbbbVGHVHpepGqKfP4t12cDzrp0E5g
         K0Kg==
X-Gm-Message-State: AC+VfDwOxaToEOo7/lIIar4KjJ3QuA6Q/813eFK69U1rck75lo1TGLz2
        ZIFOD72fo+jSvhzrRH7ACExRFkn2wlM=
X-Google-Smtp-Source: ACHHUZ4x4vYdjzA2A3pDYEJjuL0yEXwvNt0xX4mlDqJgLaXjHTWwuIQdyLc2u+d/ANXqk8y0MkWXtA6Ao74=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af65:0:b0:56d:7a5:2889 with SMTP id
 x37-20020a81af65000000b0056d07a52889mr881984ywj.7.1686754539956; Wed, 14 Jun
 2023 07:55:39 -0700 (PDT)
Date:   Wed, 14 Jun 2023 07:55:38 -0700
In-Reply-To: <CAF7b7mr+suxFe63GXJWMK_XX8J1kp5Pi2yg_bNUi_0h0ub_4Jw@mail.gmail.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
 <20230603165802.GL1234772@ls.amr.corp.intel.com> <CAF7b7mr+suxFe63GXJWMK_XX8J1kp5Pi2yg_bNUi_0h0ub_4Jw@mail.gmail.com>
Message-ID: <ZInU6leiv1z6EAPO@google.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>, oliver.upton@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
        maz@kernel.org, robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023, Anish Moorthy wrote:
> On Sat, Jun 3, 2023 at 9:58=E2=80=AFAM Isaku Yamahata <isaku.yamahata@gma=
il.com> wrote:
> >
> > UPM or gmem uses size instead of len. Personally I don't have any stron=
g
> > preference.  It's better to converge. (or use union to accept both?)
>=20
> I like "len" because to me it implies a contiguous range, whereas
> "size" does not: but it's a minor thing. Converging does seem good
> though.

Eh, I don't think we need to converge the two.  "size" is far more common w=
hen
describing the properties of a file (the gmem case), whereas "length" is of=
ten
used when describing the number of bytes being accessed by a read/write.  I=
.e.
they're two different things, so using different words to describe them isn=
't a
bad thing.

Though I suspect by "UPM or gmem" Isakue really meant "struct kvm_memory_at=
tributes".
I don't think we need to converge that one either, though I do agree that "=
size"
isn't the greatest name.  I vote to rename kvm_memory_attributes's "size" t=
o either
"nr_bytes" or "len".
