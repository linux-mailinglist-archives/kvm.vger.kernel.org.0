Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012FF7CB0CC
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234527AbjJPQ6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbjJPQ6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:58:04 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BA92D75
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 09:55:34 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d9a3e5f1742so7021704276.0
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 09:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697475333; x=1698080133; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8GT/z1ak4XuGAz/SY84LFvhbfN3QKtjdD824dfmf1Ho=;
        b=ktcAhKXJyTjYihST/28QnaiP6mAdSzWiW1Fe5a1ooONlwkCR2fKk+thiDmj5R4uKFt
         4kvPkdA4MngQqdwovAC+o5PfJRG+m3UIa7+FMGn18kzGAAo1kW97a7YMuYJSCrLpGtx7
         3knXhDdIsECohJov+rJr77fScYlx2Gft/kq/J06Ffw6Ewszm6hakJK2TuF0PJGwXPKpl
         bzqgE7Y2ezrMyvPYVyqbpaG6R/Tb9xMhiC1UoUiq26/DoOWcvFQiqDgfxxWU6WdCn6ay
         27wXFdh2+qjCa0y5xbWZ3xuXk1GAYc682NFXekc36BHgdi5NOu50mQjYEsHiC3d5U8GA
         L8zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697475333; x=1698080133;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8GT/z1ak4XuGAz/SY84LFvhbfN3QKtjdD824dfmf1Ho=;
        b=gjfQo37KLCbmI6Ppl28GU7IJuHiWMBMOQEK3G9hlkxYyMwA6kWxQshzgnzCszIuzi2
         bEfCuZYKLGVrjOTZKFoUh9xTGyovptErNqgRJtLpyzaaWnPm93qCtQsMpcMva1Ju9vxL
         QFAcCL/o0UYUWcdviaB9ic+1rdVy9zr1ufqgfFAHUO6ZenfqAnLGgIFzY7smZb84E5Px
         8iW0U4uFfcm4Q3767R2p/0VK3ar8T3Q+/zF9IV0i8C6uEpiAPrm09ayMvSjFr3Oyq4HO
         CgdSz83IkgTVSmqYHdKHsh5VTRn3fAbhQY5WSuY9Cy2ANM1Gmt6Qv39/JFjnOwZ8XUYg
         AajA==
X-Gm-Message-State: AOJu0YyGlj58dZUt3GrOZaudvhdbpvVGz5g2VTAg84C3t/CNa+6eCycw
        bGBU7ZFgx7KMMYNx1F/NjD+dif7pD+g=
X-Google-Smtp-Source: AGHT+IFGWqa5ayuh9VVkxZ5Ayl/aVGx+n4GQCBQ9Uczr4uSCdcIZ9w43tae31i5swOOzW2PKhYknuAtm6Vc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:b08f:0:b0:d9a:4a62:69e9 with SMTP id
 f15-20020a25b08f000000b00d9a4a6269e9mr405724ybj.13.1697475333586; Mon, 16 Oct
 2023 09:55:33 -0700 (PDT)
Date:   Mon, 16 Oct 2023 09:55:32 -0700
In-Reply-To: <87edhu8yoj.fsf@redhat.com>
Mime-Version: 1.0
References: <20231010160300.1136799-1-vkuznets@redhat.com> <20231010160300.1136799-9-vkuznets@redhat.com>
 <406f20dc55db24dffda2e01a1ccf7a7135c61604.camel@redhat.com> <87edhu8yoj.fsf@redhat.com>
Message-ID: <ZS1rBKU5nArisdS7@google.com>
Subject: Re: [PATCH RFC 08/11] KVM: nVMX: hyper-v: Introduce
 nested_vmx_evmptr() accessor
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 16, 2023, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
>=20
> > =D0=A3 =D0=B2=D1=82, 2023-10-10 =D1=83 18:02 +0200, Vitaly Kuznetsov =
=D0=BF=D0=B8=D1=88=D0=B5:
> >> 'vmx->nested.hv_evmcs_vmptr' accesses are all over the place so hiding
> >> 'hv_evmcs_vmptr' under 'ifdef CONFIG_KVM_HYPERV' would take a lot of
> >> ifdefs. Introduce 'nested_vmx_evmptr()' accessor instead.
> >
> >
> > It might also make sense to have 'nested_evmptr_valid(vmx)'

"is_valid" please so that it's clear the helper is a check, not a declarati=
on.

> > so that we could use it instead of 'evmptr_is_valid(nested_vmx_evmptr(v=
mx))'?
> >
>=20
> Makes sense, thanks!

Would it be accurate to call it nested_vmx_is_evmptr12_valid()?  If so, tha=
t has
my vote.  It's a bit verbose, but it should be fully self-explanatory for a=
nyone
that's familiar with KVM's vmcs12 and vmcb12 terminology.
