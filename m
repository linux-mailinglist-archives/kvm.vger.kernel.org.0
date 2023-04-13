Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63BF6E15BC
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 22:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjDMUWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 16:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjDMUWO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 16:22:14 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7153376B9
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 13:22:13 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id bh10so12491929uab.13
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 13:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681417332; x=1684009332;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bSiuE1pTIGd8fPQsZZ1Hnpoj7qtJ29yevjnpiNKiB1c=;
        b=Wzt3hPSnCj4oKztWkqr18q0LBfcLe6KIL9/BP+S3YbWQyjs8qsKgWL8NpszXPDIKKl
         Ft9r8sTc5/dA7lz2IasWlPkZoZ1NtXxvR+Ixr8BTAw9Ye79g0Hqf43JQ7WC1fMdIaBd5
         lTnNpGA+LcxCoBvqU00s9PPAhXze8mYZNGtPsyOBoQXanb2HGJ/lCraTGhMWtrGSD0Vo
         ZC6caJWBx8UR22PJ5v2mAvtFLNhunD5UIlN+oN2PqNboJ7c1w3iEi+Zrd/qP2VVZ18Oa
         U/o+z+0v5Yg0Sy1itCLOn7N8pDk1+rin6OoE+WeC9Za+4EXe6hQccImC2lzLcmLAFkdf
         pfCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681417332; x=1684009332;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bSiuE1pTIGd8fPQsZZ1Hnpoj7qtJ29yevjnpiNKiB1c=;
        b=UXBOXNVy1ndwqz20ZB1Ce589DdOe9540VkCfo1puH/O5ooocQpEG0j7DJhaRfNxQMy
         FmPgqMN7pHMY9XLtRXnBFU3D/0zntCcf+NyFDTqZih9NAfjh0coe0Ggc5kIedcJEYsNt
         L7A6hcYxQg6ZxbGQq2Ti3ypw0TCtjilUEmVa4R1Rfwc1ZUm12vYgOPrC9KCypwoElcwK
         OnmfaHAvZWElateHRvOZ12vFDPjrGxawkJFSLZ0Mu5HrK5+eVidrbyk1U5jmBugZYyCn
         YnQ7FX9hFSleQzHSUTTiqcqCZMNhmVVkj4dOh6Xd6JLk2BrKHHZIJg3F8hmSAyDuXiIq
         NeHw==
X-Gm-Message-State: AAQBX9dOytPq/b8gSE+g2dFxdyDVNix2Ja3YOA32K4I79akBd6vjGhQj
        C3quZzOmGpY+b4Mmp//tcTFnfFxjEeQdw0hyA8UzQA==
X-Google-Smtp-Source: AKy350Yo5+ih/nbBBhhtYR0NkFGqet+SgE11Xkbx6fTqA2uQp5wVx3t5saviRgUw9h1WalRXpKKcCYEqirjV3rp/NIc=
X-Received: by 2002:a9f:3143:0:b0:68b:9eed:1c7c with SMTP id
 n3-20020a9f3143000000b0068b9eed1c7cmr2038407uab.0.1681417332084; Thu, 13 Apr
 2023 13:22:12 -0700 (PDT)
MIME-Version: 1.0
References: <20230227171751.1211786-1-jpiotrowski@linux.microsoft.com>
 <ZAd2MRNLw1JAXmOf@google.com> <959c5bce-beb5-b463-7158-33fc4a4f910c@linux.microsoft.com>
 <ZDSa9Bbqvh0btgQo@google.com> <ecd3d8de-859b-e5dd-c3bf-ea9c3c0aac60@linux.microsoft.com>
 <ZDWEgXM/UILjPGiG@google.com> <61d131da-7239-6aae-753f-2eb4f1b84c24@linux.microsoft.com>
 <ZDg6w+1v4e/uRDfF@google.com> <ZDhTeIXRdcXDaD54@google.com>
In-Reply-To: <ZDhTeIXRdcXDaD54@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 13 Apr 2023 13:21:44 -0700
Message-ID: <CALzav=dv2MhoZ1BLqJWmmJv=H6vRaRUEcAJPydjrzJf1wdYEOA@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: Disable TDP MMU when running on Hyper-V
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 13, 2023 at 12:10=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Thu, Apr 13, 2023, Sean Christopherson wrote:
> > Aha!  Idea.  There are _at most_ 4 possible roots the TDP MMU can encou=
nter.
> > 4-level non-SMM, 4-level SMM, 5-level non-SMM, and 5-level SMM.  I.e. n=
ot keeping
> > inactive roots on a per-VM basis is just monumentally stupid.
>
> One correction: there are 6 possible roots:
>
>   1. 4-level !SMM !guest_mode (i.e. not nested)
>   2. 4-level SMM !guest_mode
>   3. 5-level !SMM !guest_mode
>   4. 5-level SMM !guest_mode
>   5. 4-level !SMM guest_mode
>   6. 5-level !SMM guest_mode
>
> I forgot that KVM still uses the TDP MMU when running L2 if L1 doesn't en=
able
> EPT/TDP, i.e. if L1 is using shadow paging for L2.  But that really doesn=
't change
> anything as each vCPU can already track 4 roots, i.e. userspace can satur=
ate all
> 6 roots anyways.  And in practice, no sane VMM will create a VM with both=
 4-level
> and 5-level roots (KVM keys off of guest.MAXPHYADDR for the TDP root leve=
l).

Why do we create a new root for guest_mode=3D1 if L1 disables EPT/NPT?
