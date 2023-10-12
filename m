Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B412B7C7145
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 17:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379205AbjJLPTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 11:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347251AbjJLPTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 11:19:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332E6E1
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 08:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697123894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hv5P43oKEAvFZ6n9aYfnZBkLQfH7TMziNFT/6xuiaHQ=;
        b=ciRC7VLeWp00gfjgOldQTMGBqdBaEAFAVH4iCiDi8V2TxKEy0+VyPMAmHQIEOBar3oJM7C
        zLdnSU7Icwk/I2NDNkVQBD4sw/XU0J35XZaQhmP+9YL7mpMp1f8jSmQojAx0yCHZNwyGkg
        GjoMoSbdSwb0zcZ8/KUCLNwLdNdXTKU=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-cFd4JOP5NjCa7MlrdSyltw-1; Thu, 12 Oct 2023 11:18:12 -0400
X-MC-Unique: cFd4JOP5NjCa7MlrdSyltw-1
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-7ae0cb189e5so351526241.1
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 08:18:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697123892; x=1697728692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hv5P43oKEAvFZ6n9aYfnZBkLQfH7TMziNFT/6xuiaHQ=;
        b=FFd2kLfQOmoqFQtZo0G0T09E4pKifPP92qfiqGb5K2jjIdYIa/hf1SyZw/wudrOu/q
         +1hRXuq5bRExYKzeKoX1EcBgKazWP9IfLdQzjtrzQf+uOjemv19I2OdB+1RO9mLrePED
         DzlwGr95QiFFI1emBu8GRqK67jjdJpIBgXQHwztJs1RRUbcBtKrrk/BDraELfIFKRlYw
         MZiJcLKjcKhtDSDAkHzejnQV4nalFf9zqclCe2JSSSF3YFDtrrH2OGN1LcchMMAuGTSF
         0DggZnBEUPcvNfvsOxAATgj3UJB0OdWtykxGOhtcGcOncn3MNjfLUwzdTyp8L+RllzhI
         aeUw==
X-Gm-Message-State: AOJu0YyW2HerhO1qY87qr3Bh7qwlPyl0Lv5wSBHc0GKExoHGQm8ah4hk
        PqqkTwJU/9z6eGcSprueVeTgmUbDUd3TiqJGTr/RdGepwJgGGX6hQnQhXoWWvKtK6DIGJdVtREb
        VQjVvbvmxJdYkpSLiNIaR4d4gR0b3
X-Received: by 2002:a05:6102:3d0a:b0:44e:8626:71f2 with SMTP id i10-20020a0561023d0a00b0044e862671f2mr22039161vsv.13.1697123892154;
        Thu, 12 Oct 2023 08:18:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBNyWxcZmfVJRlq4Pd9a/3m/udTn/3W6XtpxOGOI/a95VPzronN+92jtFhhPc0gRK2z/j8d60xOLVLvtMLn1g=
X-Received: by 2002:a05:6102:3d0a:b0:44e:8626:71f2 with SMTP id
 i10-20020a0561023d0a00b0044e862671f2mr22039149vsv.13.1697123891899; Thu, 12
 Oct 2023 08:18:11 -0700 (PDT)
MIME-Version: 1.0
References: <20231006205415.3501535-1-kuba@kernel.org> <ZSQ7z8gqIemJQXI6@google.com>
 <20231009110613.2405ff47@kernel.org> <ZSRVoYbCuDXc7aR7@google.com>
 <20231009144944.17c8eba3@kernel.org> <87sf6i6gzh.fsf@intel.com>
 <20231010072359.0df918e9@kernel.org> <ZSXiapPMIPj3ko41@google.com>
In-Reply-To: <ZSXiapPMIPj3ko41@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 12 Oct 2023 17:17:59 +0200
Message-ID: <CABgObfa=k+xHztWPhWU31UqTgnoO=Yn7uT+9W-G9S7VW_HciQA@mail.gmail.com>
Subject: Re: [PATCH] KVM: deprecate KVM_WERROR in favor of general WERROR
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        workflows@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023 at 1:46=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
> > > The DRM_I915_WERROR config depends on EXPERT and !COMPILE_TEST, and t=
o
> > > my knowledge this has never caused issues outside of i915 developers =
and
> > > CI.
> >
> > Ack, I think you do it right. I was trying to establish a precedent
> > so that we can delete these as soon as they cause an issue, not sooner.
>
> So isn't the underlying problem simply that KVM_WERROR is enabled by defa=
ult for
> some configurations?  If that's the case, then my proposal to make KVM_WE=
RROR
> always off by default, and "depends on KVM && EXPERT && !KASAN", would ma=
ke this
> go away, no?

No objection to adding EXPERT. Adding W=3D1 when build-testing KVM
patches is a good
idea, you will still get the occasional patch from someone who didn't
have it but that's fine.

I added KVM_WERROR a relatively long time ago after a warning scrolled
away too quickly (a
harmless one, but also a kind that honestly shouldn't have made it to
Linus). At the time there
were still too many warnings to enable WERROR globally, and I feel
that now we're on the
same boat with W=3D1. I think we should keep KVM_WERROR (which was based on
DRM_I915_WERROR indeed) and maintainers should just add W=3D1 when build-te=
sting
KVM patches.

Paolo

