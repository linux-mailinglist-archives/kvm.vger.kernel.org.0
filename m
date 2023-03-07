Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B09BF6AF68B
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 21:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbjCGUSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 15:18:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbjCGUSN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 15:18:13 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A7D738B6
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 12:18:11 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id p36-20020a056a000a2400b005f72df7d97bso7730265pfh.19
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 12:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678220291;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TBy8uaZdLaA2vuEpvMEgc5Zol1R57/Lhpg4H0LtQutQ=;
        b=ByZC/r9FYzZ656rX3fvn+gjr42ji69/Cfy2+ooWEMUrvz4vmNIW9llG1unN/7ELnfY
         BXbMN9ie3M/crOH0EiVf4l/4WzvrEDI9Mwh7r4mGph9G3bGtNQL8WViFo0bqVyswjS3Z
         1oBJSYQ4erwKC8WNXjepoNZRyH+oEspSK6vmd/gLPflV1t//Nex7efWiU3R6sgFJ87XB
         hj52xTTpaJiPylk5c/gif2fm/iRQLjvU33EjHj+Hp4bAx0RKcd/Ljz0fcm9Z1JEZONGc
         WLaomMpzYlfZsxlziiadmW5ZloKTf7tdg78kPNPXdyEfwxwlJQJGdzQNp1rLqu03sCET
         wDHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678220291;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TBy8uaZdLaA2vuEpvMEgc5Zol1R57/Lhpg4H0LtQutQ=;
        b=vrMX09gaIqFndqlNfGPS02gCDURcy806t9MWOjKnnfAA/NxnwACD0vWSfpRiqNs3Bo
         pULnXjOf1b66BsD1MjFZrgOBE/TJumxc+mvPH4a+Do6KtBbxz5zpwamCtoqxE9Rg7kC2
         Ar+QNy0pw/qq8Q3wjiXMGGHkyFPtoVCSFk2iOtBl1ieNfV4KouWkCBIy1/3COF2J9hF1
         B7fAronoUn/yU+4DVNkUQfSJsNdACPsPC7n5dOVPQGpuZKRiXghoZ064Lvo/cMy4jG4J
         YXtaXAu+S6Bc5F3Ptk+on+O3QJ8jPf/Jx4tDGXB3ZvDJerLVs5XvK6PUdzvlzk5rY9kl
         vtMg==
X-Gm-Message-State: AO0yUKX6XYqlPqAh9xE6v0Uack+7TyXcu8OS6KII/PkJTUHszcdnz1v5
        hndrai3PHf8uC88zK80JWNi7pvhHz58=
X-Google-Smtp-Source: AK7set+dALpfNS9d/EtiXblm62Tp/vh6zce1WOWL1zqGz0ympR4BwgAKhVJQwyU0j2wOGMyzfkI4/u3K1lU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2581:b0:19a:8bc7:d814 with SMTP id
 jb1-20020a170903258100b0019a8bc7d814mr5975096plb.13.1678220290945; Tue, 07
 Mar 2023 12:18:10 -0800 (PST)
Date:   Tue, 7 Mar 2023 12:18:09 -0800
In-Reply-To: <CAHVum0eW+AKoMt2nB=52cDpvoVHX1A4tHmdV-4f21hV49c4o8g@mail.gmail.com>
Mime-Version: 1.0
References: <20230306224127.1689967-4-vipinsh@google.com> <202303071940.sFeQ4FpU-lkp@intel.com>
 <CAHVum0eW+AKoMt2nB=52cDpvoVHX1A4tHmdV-4f21hV49c4o8g@mail.gmail.com>
Message-ID: <ZAecAbOfknV1gS/t@google.com>
Subject: Re: [Patch v4 03/18] KVM: x86/mmu: Track count of pages in KVM MMU
 page caches globally
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     kernel test robot <lkp@intel.com>, pbonzini@redhat.com,
        bgardon@google.com, dmatlack@google.com,
        oe-kbuild-all@lists.linux.dev, jmattson@google.com,
        mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 07, 2023, Vipin Sharma wrote:
> On Tue, Mar 7, 2023 at 3:33=E2=80=AFAM kernel test robot <lkp@intel.com> =
wrote:
> >
> > Hi Vipin,
> >
> > Thank you for the patch! Perhaps something to improve:
> >
> > [auto build test WARNING on kvm/queue]
> > [also build test WARNING on kvmarm/next linus/master v6.3-rc1 next-2023=
0307]
> > [cannot apply to mst-vhost/linux-next kvm/linux-next]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use '--base' as documented in
> > https://git-scm.com/docs/git-format-patch#_base_tree_information]
> >
> > All warnings (new ones prefixed by >>):
> >
> > >> arch/x86/kvm/mmu/mmu.c:676: warning: This comment starts with '/**',=
 but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.r=
st
>=20
> > vim +676 arch/x86/kvm/mmu/mmu.c
> >
> >    674
> >    675  /**
> >  > 676   * Caller should hold mutex lock corresponding to cache, if ava=
ilable.
> >    677   */
>=20
> I will fix it in the next version.

Don't bother reworking the code/comment, I will likely have feedback that r=
esults
in the demise of the comment altogether (comments that say "lock X must be =
held"
are almost always flawed).
