Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6264F6D1CF5
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 11:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbjCaJuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 05:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbjCaJuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 05:50:03 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789892030B
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 02:48:52 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id y7so6719194qky.1
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 02:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680256131;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RQev/2xSHIWb8A43B2OqeWKTXHV8C7phPdeVA/fkIpI=;
        b=lUL3rOATa02+Lf9Uw8RW/eO3cWjS3bgkogMrYBYZFea6mewMLrbcZNSTXyOE4vZ2RU
         0u8/tJ2Cmbj3Pfjjd90P45n9+oj1Y+Cu0Kfu6Mm7efU0tWJNo4nfToK+8Y9brh3/tA2E
         zeIhhYlNnFshDpgIdH0dmh2zhUsUxi6dZDskWv5BmyPynVDpTit4HIiQpBJ8e2InlW8L
         0dV20G97v1qA2h1Cf38+0IUn444xxSVu3LEgOds2/LL9TC1+6Jes/Kgwgp+dTccHn35/
         KkMtreqCtEWoy7oI7GhXUBE2nycTgUJPnYh8uz17F1JGQmD9T4XrgRRPKPxPO5g/UznY
         R1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680256131;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RQev/2xSHIWb8A43B2OqeWKTXHV8C7phPdeVA/fkIpI=;
        b=Snh6w8v75fEh9AAd6l16Y0J+DXDkuZ7jxgNXM9sQHal6WCc61HfFtZe5t/2FLrHkJd
         HCCef/WUNdQyYyt/k6SYcdcCbhvFu4gdxAp4SaKEeUc8DLd+HNb7MbAvCje+bHzBpFvc
         6WLq9V0HbkFSiHS+h2dyDp1YShD5A0AWPT5V4B4VIdJ9GC9o5AEj0gsWSNWR6i8jx5Ha
         N5teXmT5iJ3+V+nD5fNXGnqlMerGLq33/UKTQPZhNmcfqZYh6MuS4qC32Y0tKCikQP1C
         +IWgmvQxq3uziXcMPySSEc75IVFVPauELFpMtyfeuMhcCTDHS325cbpvHuSrc1TyT61E
         QUfw==
X-Gm-Message-State: AO0yUKWnjr/4QV7iEprQhF/EABgYnwQqLfkl1mOscQGo9CUmfNg8FdmH
        m9aSBhCxZHWPiVEo5WEx+5NbLMlXHRsHU7jQHMeV7nmeHAA=
X-Google-Smtp-Source: AK7set9yiMdsN11YoTydDJcCPcC9nZfMzuN4aSRsZ4bNrXisWB1PK86xXtOX8Zy/cdTdCnc4DH7brqU0uXKQQ6rFXhI=
X-Received: by 2002:ae9:ef95:0:b0:745:811c:2aea with SMTP id
 d143-20020ae9ef95000000b00745811c2aeamr5408959qkg.11.1680256131512; Fri, 31
 Mar 2023 02:48:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230310125718.1442088-1-robert.hu@intel.com> <20230310125718.1442088-4-robert.hu@intel.com>
 <ZAtaY8ISOZyXB3V+@google.com>
In-Reply-To: <ZAtaY8ISOZyXB3V+@google.com>
From:   Robert Hoo <robert.hoo.linux@gmail.com>
Date:   Fri, 31 Mar 2023 17:48:40 +0800
Message-ID: <CA+wubQBN0LAW3aqTm8Psja7jBghdi1+9x=R18TpczxTSBXN4xg@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Use the canonical interface to read
 CR4.UMIP bit
To:     Sean Christopherson <seanjc@google.com>
Cc:     Robert Hoo <robert.hu@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> =E4=BA=8E2023=E5=B9=B43=E6=9C=8811=
=E6=97=A5=E5=91=A8=E5=85=AD 00:27=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Mar 10, 2023, Robert Hoo wrote:
> > Use kvm_read_cr4_bits() rather than directly read vcpu->arch.cr4, now t=
hat
> > we have reg cache layer and defined this wrapper.
>
> kvm_read_cr4_bits() predates this code by ~7 years.
>
> > Although, effectively for CR4.UMIP, it's the same, at present, as it's =
not
> > guest owned, in case of future changes, here better to use the canonica=
l
> > interface.
>
> Practically speaking, UMIP _can't_ be guest owned without breaking UMIP e=
mulation.
> I do like not open coding vcpu->arch.cr4, but I don't particuarly like th=
e changelog.
>
> This would also be a good time to opportunistically convert the WARN_ON()=
 to a
> WARN_ON_ONCE() (when it fires, it fires a _lot).
>
> This, with a reworded changelog?
>
>         /*
>          * UMIP emulation relies on intercepting writes to CR4.UMIP, i.e.=
 this
>          * and other code needs to be updated if UMIP can be guest owned.
>          */
>         BUILD_BUG_ON(KVM_POSSIBLE_CR4_GUEST_BITS & X86_CR4_UMIP);
>
>         WARN_ON_ONCE(!kvm_read_cr4_bits(vcpu, X86_CR4_UMIP));
>         return kvm_emulate_instruction(vcpu, 0);

Are you going to have this along with your "[PATCH] KVM: VMX: Treat
UMIP as emulated if and only if the host doesn't have UMIP"?
