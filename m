Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C327B4C11CB
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 12:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239981AbiBWLsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 06:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240214AbiBWLr6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 06:47:58 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6721D32D
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 03:47:30 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id p3-20020a17090a680300b001bbfb9d760eso1940341pjj.2
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 03:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=ctPaxT51GgjUZKsgHy4OVPzHV8cBv3OcsGO1TWhtObM=;
        b=Kwg+FAbxZVnTWRYadHu7F428O4dcBN0YOyEgZRRwsHPlk/nY+JtHUPv/fSW2a8JJwA
         NAjGKUJvXFJDOWcwNYHdvE8LmTv+AtsAcLQgJHG9ZMVEPt4qWxfHn8FgOkGmI3/MHsgj
         tc9HaLKHo+EdF4Hv7sx+4/xz2/ZDmj2bWfPQHNw86ziyRlZjXcpR1fFUIEhpZRiaywQv
         mYdkWpSz0nq9GkmC7ffsP9vgEaX5h/gFAMmmathbDyXos4eFvJmGWC201T1/LL5QWUr0
         Fc1rGZpljGKsCLhAHEX0WikG0GbQmVNxqCbBeTo0QqNmYrs3aGw5zYkei8k+NzKfRo42
         eZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=ctPaxT51GgjUZKsgHy4OVPzHV8cBv3OcsGO1TWhtObM=;
        b=qfJZMIXclizn0oFSjYMEqQl9z90qCKHLWw0/0IHHCaqcvLrRxDgL4XgsEPB/Q+W6dd
         oLShfVdFPkQziF/a81O3iEqfkxcUaN7hdf/1i2tZAlqQTTMFAmlm0nKi6gyn0rPZoB2v
         ls44jyBn44zPZ2pXhybD67dQkJj4W+BYkEggZvkMu0iSw0HRZY9CZ34orEj7gv6YUWol
         7g/KciE1+Wu4NaseKl/oroanMNwKk+DAEVhJFXVd1NV6ksj2wN/uK1X9qNO3EG4NMJjW
         VXQfpqDayxn++HC9jBnKzcZuV0Fp+VOjlHheG+trrV2jsaEpsb4T9ZpfgvC9crJXOLdM
         JSvw==
X-Gm-Message-State: AOAM5301fZOF7v35b3pO9SgPVKO9xrN2ZTdkFvtl5916nVffT1JTcOjS
        GNphj9Vgh1N1WduQuTztqaM=
X-Google-Smtp-Source: ABdhPJxFuG2bYEJsCZx/XWDrSbF2z8bmtCw49evuSl54sQAqjMZ7/sOnng/soDadpiu0qWf2ERn3Sg==
X-Received: by 2002:a17:902:b210:b0:14f:d0ff:46bb with SMTP id t16-20020a170902b21000b0014fd0ff46bbmr9674226plr.47.1645616849691;
        Wed, 23 Feb 2022 03:47:29 -0800 (PST)
Received: from localhost (115-64-212-59.static.tpgi.com.au. [115.64.212.59])
        by smtp.gmail.com with ESMTPSA id bj26sm23328221pgb.81.2022.02.23.03.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 03:47:29 -0800 (PST)
Date:   Wed, 23 Feb 2022 21:47:23 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 0/3] KVM: PPC: Book3S PR: Fixes for AIL and SCV
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>
References: <20220222064727.2314380-1-npiggin@gmail.com>
        <bf6cf0d0-31bd-5751-4fbe-8193dbd716a9@redhat.com>
        <6b123068-c982-1fcd-d09e-1a8f465147e3@linux.ibm.com>
In-Reply-To: <6b123068-c982-1fcd-d09e-1a8f465147e3@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1645616541.qspjukz7s5.astroid@bobo.none>
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

Excerpts from Christian Borntraeger's message of February 23, 2022 7:14 pm:
>=20
>=20
> Am 22.02.22 um 15:11 schrieb Paolo Bonzini:
>> On 2/22/22 07:47, Nicholas Piggin wrote:
>>> Patch 3 requires a KVM_CAP_PPC number allocated. QEMU maintainers are
>>> happy with it (link in changelog) just waiting on KVM upstreaming. Do
>>> you have objections to the series going to ppc/kvm tree first, or
>>> another option is you could take patch 3 alone first (it's relatively
>>> independent of the other 2) and ppc/kvm gets it from you?
>>=20
>> Hi Nick,
>>=20
>> I have pushed a topic branch kvm-cap-ppc-210 to kvm.git with just the de=
finition and documentation of the capability.=C2=A0 ppc/kvm can apply your =
patch based on it (and drop the relevant parts of patch 3).=C2=A0 I'll send=
 it to Linus this week.
>=20
> We to have be careful with the 210 cap that was merged from the s390 tree=
.

Ah thanks, I didn't notice it.

Using 211 is no problem for me, merge will have a conflict now though.
We could avoid it by just sending my patch in a second batch instead of
doing the topic branch this time (I still like the idea of a topic
branch for caps for future).

Thanks,
Nick
