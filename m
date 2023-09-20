Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25DB7A88C6
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 17:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236753AbjITPp5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 11:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235498AbjITPp4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 11:45:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD04A9
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 08:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695224705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cGZYuFjdSw+7IgfMrv/noB8jmBNqmEPIrY3uHZWkK7w=;
        b=Kk54+y/v4MEjPfQK0mJEpWRkWxnrhAkaQLJb/6w4ByBiaviJtMdgZbskFtiZoBN/qkrzwQ
        rcuBkkExSsYw17xvjm+v1/l+M/1insbs6pDI1U1CMpyxyH/CVIU+5YIAaN4/SnECz0S5CU
        WEuRfDXBCY9kpz2EeCTiVAQxbZQLmoE=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-MxVr0ploPTyG-CHvKba-Pw-1; Wed, 20 Sep 2023 11:45:03 -0400
X-MC-Unique: MxVr0ploPTyG-CHvKba-Pw-1
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-7a80738ec28so2656904241.0
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 08:45:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695224702; x=1695829502;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cGZYuFjdSw+7IgfMrv/noB8jmBNqmEPIrY3uHZWkK7w=;
        b=h0xM2J81rPDTHk1I2Z9XJvTKybdNDvkYjNu+xXv04pbTFhuaP3ZSYNvkpp2xCLAMcd
         OFUPdRYwGbSS5PtSBzGvRlECNdKmw/NH7vqnCEMzJdxUStceds31IZ/OAjZunfQa2mHX
         oaTwYACoi5HE31Uuh1Zgn4lSEczetHaK6NsKjWrHmlwu0DXUvrdfFDraGNzzc1iAFtmM
         XRDPZsVDv0tIkDuNYG6bk+MhwlF23wq16fM9B65azVN2RtxKd1TrANux1iGHzel41jNO
         3ZTfE3dtlpMTzxTLYMcJScQm9cQ2Is3kxSMttkr9WL9AuQWVqH0HOHDu57ubHxHLYQqE
         uK0g==
X-Gm-Message-State: AOJu0YyoqgnNXcHfwEcVyiIZfTQQT/lY+hb5EIYzJa2+9tPPAkVerP3h
        eHNYB6pbMa/gghqMb2bKwC3HxHNBGaG2jQ7mTqdlobbd2Iv1wCNrnBeLh5j2GTCvINrypu1ydny
        1zIbQONGP1NLv9zMEF4HcTf6/5+JgZuOdTV9w
X-Received: by 2002:a1f:de04:0:b0:495:db2f:f4e7 with SMTP id v4-20020a1fde04000000b00495db2ff4e7mr3173037vkg.1.1695224702276;
        Wed, 20 Sep 2023 08:45:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3vx/LEdU4pP4MJpwiU0IyO/UWelTJ4jAHGNyRLV7gJxot0q2gDS22MkHcPgnHAL/8Nwg3EuwhzVuUmsaXdpo=
X-Received: by 2002:a1f:de04:0:b0:495:db2f:f4e7 with SMTP id
 v4-20020a1fde04000000b00495db2ff4e7mr3173027vkg.1.1695224702015; Wed, 20 Sep
 2023 08:45:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230913235006.74172-1-weijiang.yang@intel.com>
In-Reply-To: <20230913235006.74172-1-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 20 Sep 2023 17:44:50 +0200
Message-ID: <CABgObfb-cfZTW=xb7Vf3Fh0pAsQkkrrxuB2MczrR5X3bTpWr3Q@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/3] Fix test failures caused by CET KVM series
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     seanjc@google.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 14, 2023 at 4:55=E2=80=AFAM Yang Weijiang <weijiang.yang@intel.=
com> wrote:
>
> CET KVM series causes sereral test cases fail due to:
> 1) New introduced constraints between CR0.WP and CR4.CET bits, i.e., sett=
ing
>  CR4.CET =3D=3D 1 fails if CR0.WP =3D=3D 0, and setting CR0.WP =3D=3D 0 f=
ails if CR4.CET
> =3D=3D 1
> 2) New introduced support of VMX_BASIC[bit56], i.e., skipping HW consiste=
nt
> check for event error code if the bit is set.

Queued, thanks.

Paolo

> Opportunistically rename related struct and variable to avoid confusion.
>
> Yang Weijiang (3):
>   x86: VMX: Exclude CR4.CET from the test_vmxon_bad_cr()
>   x86: VMX: Rename union vmx_basic and related global variable
>   x86:VMX: Introduce new vmx_basic MSR feature bit for vmx tests
>
>  x86/vmx.c       | 46 +++++++++++++++++++++++-----------------------
>  x86/vmx.h       |  7 ++++---
>  x86/vmx_tests.c | 31 ++++++++++++++++++++++---------
>  3 files changed, 49 insertions(+), 35 deletions(-)
>
> --
> 2.27.0
>

