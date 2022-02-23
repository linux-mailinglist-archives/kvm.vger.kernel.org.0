Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A524C0CBC
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 07:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbiBWGok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 01:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbiBWGog (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 01:44:36 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FF36D874
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 22:44:08 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id q1so9223888plx.4
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 22:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=FibZ6lkCwiToTIV/NTWDV1xpOjz/kVQzk1s+tMa1Lh4=;
        b=qFAQSLgSAYx3HF7b518sa97AMGYAn4ihA4J9WNX6RDPE/my/mLgDKXQnu6b5MLdiDC
         QhhmNsg0mcLcHs44Hcsjp6YdhsPbSdDIJhJnlpJf02qnXXKTMdsH8WdmQDuk58re6toM
         DAM68cPPZc7P/MEIXepzou7K5Fg3lvBlTvyFLjXwTMWVzHoJYF0Kh7yRkh0LxuE2ZPH/
         JAtv/y6QYD3ww8TY5CKO9UGnXeczHf555zvxlznay++n/teDw6nQq3zAXjFeIqqRflxS
         GJmVPAYCk7+pimUMmn4Dup/vz5juUjYUExNAEMqvwh3Wnfq3Zsb9HC05b3kq5Try/Fl5
         TUCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=FibZ6lkCwiToTIV/NTWDV1xpOjz/kVQzk1s+tMa1Lh4=;
        b=OKsQX5lxpQUJo30IskE2VzOt8rUduPJcoPwO1hVtc+IQ+hZY8C7xpKa+aoQu+ctiuu
         hFTU7pDTLVCNb2vgP5EsynLNcuXRo+MOYFTk6x78xoEvHykeT3IaIPo41djkpplF0eVz
         BFlYVOjkCEur9ECn4N+p7/9JM6U/0pb7Q8uXJB5uuvANjGW2pL4DURHgOPO7tItWbpIm
         i7wmWNNt8FC5TZffBEveP7xXQ/X+xfCpLzOWUbDJt2X18uoQ3gVIypybddzF0umQmAjL
         8rE2qMXdE9cLT83X5iEXxxPQBjsxkbpEe6FkAwvY2sp8lv7fFrFRVP1RZzSY1q2Zezxz
         JWtw==
X-Gm-Message-State: AOAM531NojI8txS9Vgt2bi4yqArlH34YhNy6Nt0sGQGuV+i4qfUb5HVh
        kUeJs9TbCILrLX3+uLjMDrM=
X-Google-Smtp-Source: ABdhPJwxLNkCduIs5cJFAQHaTPZ5zK5ESIW3mhmQh0szDO3aD6UE2vECv9LbQ7W6CE8MX+5t1KyweA==
X-Received: by 2002:a17:90a:7885:b0:1b9:b61a:aafb with SMTP id x5-20020a17090a788500b001b9b61aaafbmr7874638pjk.202.1645598648283;
        Tue, 22 Feb 2022 22:44:08 -0800 (PST)
Received: from localhost (60-240-120-95.tpgi.com.au. [60.240.120.95])
        by smtp.gmail.com with ESMTPSA id h26sm23268961pgm.72.2022.02.22.22.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 22:44:07 -0800 (PST)
Date:   Wed, 23 Feb 2022 16:44:02 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 0/3] KVM: PPC: Book3S PR: Fixes for AIL and SCV
To:     linuxppc-dev@lists.ozlabs.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>
References: <20220222064727.2314380-1-npiggin@gmail.com>
        <bf6cf0d0-31bd-5751-4fbe-8193dbd716a9@redhat.com>
In-Reply-To: <bf6cf0d0-31bd-5751-4fbe-8193dbd716a9@redhat.com>
MIME-Version: 1.0
Message-Id: <1645598075.5g1cr5hdzf.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Excerpts from Paolo Bonzini's message of February 23, 2022 12:11 am:
> On 2/22/22 07:47, Nicholas Piggin wrote:
>> Patch 3 requires a KVM_CAP_PPC number allocated. QEMU maintainers are
>> happy with it (link in changelog) just waiting on KVM upstreaming. Do
>> you have objections to the series going to ppc/kvm tree first, or
>> another option is you could take patch 3 alone first (it's relatively
>> independent of the other 2) and ppc/kvm gets it from you?
>=20
> Hi Nick,
>=20
> I have pushed a topic branch kvm-cap-ppc-210 to kvm.git with just the=20
> definition and documentation of the capability.  ppc/kvm can apply your=20
> patch based on it (and drop the relevant parts of patch 3).  I'll send=20
> it to Linus this week.

Hey Paolo,

Thanks for this, I could have done it for you! This seems like a good=20
way to reserve/merge caps: when there is a series ready for N+1, then
merge window then the cap number and description could have a topic
branch based on an earlier release. I'm not sure if you'd been doing=20
that before (looks like not for the most recent few caps, at least).

One thing that might improve it is if you used 5.16 as the base for
the kvm-cap branch. I realise it wasn't so simple this time because=20
5.17-rc2 had a new cap merged. But it should be possible if all new caps=20
took this approach. It would give the arch tree more flexibility where=20
to base their tree on without (mpe usually does -rc2). NBD just an idea=20
for next time.

Thanks,
Nick
