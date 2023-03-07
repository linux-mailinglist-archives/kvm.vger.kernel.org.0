Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00D66AF187
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 19:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbjCGSpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 13:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbjCGSo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 13:44:57 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9159B7D8D
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 10:34:41 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-536c2a1cc07so260712137b3.5
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 10:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678214027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rg2FISR77Z7dgYeTdMLcyV3dESYMixBuhmAXOtI+uHw=;
        b=ExV7ViaAOBBXagiF6/J53uxuxaIwHEcwF5g/XVpP9XoqxRDQ6E1/gmBJpbDRuHPYZy
         kWe+wtbbDBXmH/ZMx7FMA9AIvnEjUEJ2DmGVN2RV0Ar8Q4xYFPRqDniMV/xS2gQsSbfZ
         pB98Cl9efiRPtwR/5hhBFwaW7JP3uO2e1YW5liY7vcBiTAxfw1lBgsHO+SYlIb44r9tB
         jIxot7ADoeNW3MhBoi2W68kKi2EOtljlgOeMGJCe4xLIF5uGhjC4RKnxkUYMXhYhxs6U
         msaE//EIqh4sIcduBJtKEzVdEhwW2iQF8NCR9moBZh85MyHdXB0wmnYeN3AXp0EDB7vD
         gKiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678214027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rg2FISR77Z7dgYeTdMLcyV3dESYMixBuhmAXOtI+uHw=;
        b=p2rSHrB43vY/70kCY27HWGEr9CrDPK8OuyrYPwwNvFUJWyz3C5ZQ5ijwY08duDIbOg
         B6FxtDg1D8hEr6NXvy90dIsrvsnl4XnWbRPCQONk/7qL9dN9wlgi19jzubjCwiGjm1EF
         xONxzn8iViZTBXROSpVRQgcNNOT5nRRwgZFiyYkLtPsiXsLgALjnlYxc3P8KS6mZW7L1
         ojyhm+yC3yoFix1Rue+b/7qvcCZ7G0l79dMYez5GMJ7k7ljH/N7NF3jKJobab6ymPbi5
         BMANumhYw3O6IWeKGDQG6hQtSX/ZKNKuUR9IRmgf2947CsMNC4BIs3FgZnLV3c1wUBCB
         YXQA==
X-Gm-Message-State: AO0yUKXW3D2VyWKqAIYuCwuMeJxTGOQrjYVLM6ACPBHshIPsETyFZNUF
        2lLcbmQcDrRCKSiA3wTgr6aL7WSLPLbqiPKSNG13mQ==
X-Google-Smtp-Source: AK7set8v/uO7SvLxcBQMO7klpqz2+Jh5VDILCPS9ZgAf7NT3tVdyWdmzg3vupTnULvL3B7bzKmDyr5c9tuAkFeSW7lI=
X-Received: by 2002:a81:a786:0:b0:52e:b74b:1b93 with SMTP id
 e128-20020a81a786000000b0052eb74b1b93mr10061145ywh.0.1678214026899; Tue, 07
 Mar 2023 10:33:46 -0800 (PST)
MIME-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com> <ZAeAQEaJW9kwjBA2@google.com>
In-Reply-To: <ZAeAQEaJW9kwjBA2@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 7 Mar 2023 10:33:10 -0800
Message-ID: <CAHVum0daZ-FUs4A1TMj5uSrW32YrLZVqkSU4CyY6evep_cocdg@mail.gmail.com>
Subject: Re: [Patch v4 00/18] NUMA aware page table allocation
To:     Mingwei Zhang <mizhang@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Tue, Mar 7, 2023 at 10:19=E2=80=AFAM Mingwei Zhang <mizhang@google.com> =
wrote:
>
> On Mon, Mar 06, 2023, Vipin Sharma wrote:

> > v4:
> > - Removed module parameter for enabling NUMA aware page table.
>
> Could you have a space before the dash? I think the mutt mistakenly
> treats it as a 'diff' where you removes a line.

From next version I will add a space before dash.


> > --
> > 2.40.0.rc0.216.gc4246ad0f0-goog
> >
>
> May I know your base? It seems I cannot apply the series to kvm/master
> or kvm/queue without manual manipulation.

My patch series is on the latest kvm/queue branch which is currently
on commit 45dd9bc75d9a ("KVM: SVM: hyper-v: placate modpost section
mismatch error")

What manual manipulation do you have to do to apply this series?
