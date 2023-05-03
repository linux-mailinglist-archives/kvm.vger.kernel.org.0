Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2606F5FB5
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 22:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjECUJ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 16:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjECUJz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 16:09:55 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685DFDB
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 13:09:54 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-b9a805e82a9so12384194276.3
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 13:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683144593; x=1685736593;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eGmt2vyUuGkmpCbVhWZSJ5eSK3GpTIz9V8J//ylvB7M=;
        b=5Itlb076hfzk2tpwbXXhouV0ED49WTj7zlg9jjFf90Mqn52Lu4ZzwDBPk5qe0GaXC0
         Bjq0g43uvHE5X4nITMUBJfu2blbJFOdVRrKVwpZH0GjPbv01lkhKcx9O3soajxi8ljQk
         ZHPtrOdWyby7dMYefELp+UVWKQoFyR0EN6nOYCNDdD3HjwqQRq8T7IKyfEFI8MXaqRJM
         siOWMuuKq6+3+o7pA4J5PFzS/t18oQgt9qa16PHvY2egCAk0N6ZG/kXGy9CoyBmchIdN
         UK5hj2l7Gw963FR+8dLavY+pjNpDheO8pqkKWq5gMcpGRcBaoRR1uSWG1cQ+fv76fT3U
         zPNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683144593; x=1685736593;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eGmt2vyUuGkmpCbVhWZSJ5eSK3GpTIz9V8J//ylvB7M=;
        b=aZyMorUIHTu+DHsQiJgmlVgAJEVasUScmd18EPMSWHuNCf0jYfF+HDyLuDWOmoI9Os
         L50vBgrnCJAvG/xOk5UJwBV432qOmRgrJC47sxViRYbrtIJ0ETAVfwonHtVrRFmXpHnJ
         E2o30lxJjllg2NXv3ZL9zAJitkJcVEsMl8KZPuVsuRCgYvHD0qYZGa8KTo3cK1DsCIfu
         ++FgcqdYw8PUa/Fh/sqkEcNJ02ovcjWgzJCmDawXIQIVNupoWh2F1+ig/dqrA/Q2ciSB
         FoxiX/JZUZHJ9rn9LIbEs9xHGo6pLJuGoxx7sdObpfq9bqTgnAP4Zv5vlRM2/UgrS6Oz
         y29A==
X-Gm-Message-State: AC+VfDzq1tlrpyhnv8KfuPDZqiAq1fLalqSh7Ry7/RRDXsyvQ0LOQsvF
        OeqbgAW4JgDOPC4CHKnCk10bPkiBhPA=
X-Google-Smtp-Source: ACHHUZ5pv/blUiyPyfMIgcxE0mYSuWOMa0JCpIXDO8pCT1AJhklO6MfaMJHycwYdut6UuO0uVg1UVSmDp0w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:947:0:b0:b9d:8612:a8bd with SMTP id
 u7-20020a250947000000b00b9d8612a8bdmr6880905ybm.4.1683144593691; Wed, 03 May
 2023 13:09:53 -0700 (PDT)
Date:   Wed, 3 May 2023 13:09:51 -0700
In-Reply-To: <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
Mime-Version: 1.0
References: <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
 <ZEBXi5tZZNxA+jRs@x1n> <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
 <ZEGuogfbtxPNUq7t@x1n> <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
 <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
 <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com> <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
 <ZErahL/7DKimG+46@x1n> <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
Message-ID: <ZFK/j8EjGc1v8T5g@google.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Peter Xu <peterx@redhat.com>, Nadav Amit <nadav.amit@gmail.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oliver.upton@linux.dev, James Houghton <jthoughton@google.com>,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        kvm <kvm@vger.kernel.org>, kvmarm@lists.linux.dev
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

On Wed, May 03, 2023, Anish Moorthy wrote:
> On Thu, Apr 27, 2023 at 1:26=E2=80=AFPM Peter Xu <peterx@redhat.com> wrot=
e:
> >
> > Thanks (for doing this test, and also to Nadav for all his inputs), and
> > sorry for a late response.
>=20
> No need to apologize: anyways, I've got you comfortably beat on being
> late at this point :)

LOL, hold my beer and let me you you the true meaning of "late response". :=
-)
