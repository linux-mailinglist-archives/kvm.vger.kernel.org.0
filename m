Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7E2E52CBFE
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 08:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiESGdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 02:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiESGdv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 02:33:51 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643D133894;
        Wed, 18 May 2022 23:33:50 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id v11so4134299qkf.1;
        Wed, 18 May 2022 23:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JWAVdayu73KUbkTP+3uedkJlcNOyLvU+zwog6pNshuM=;
        b=YkxdhpWg8Xwu8tFFkE8u8wOgjDWYmcddVQwOQowA0TQUjuX3EMD0loi8u/F96e9XPY
         DfjP72L83/4VwmpDrPJbavH3m5ID18Wbin5MSceI2EWTsEXkRjWvGhPkcLifsrh+smqK
         p0sVND84VlMMDtbF2pUAur8psK8mC+28LkgFOOy5MKrkWZKJ8Vq5hkPU+T79jtdFVYco
         TMPRd4lWgucGIcXKACIjRAr3ti6V/bVmghLw1Zlj9GDeOOETmUEM9jPwUoz8DjG0Lz8G
         NSdIty9VB6GECTNEcB8lugGB2Ru7HnBWaghWOOILDFb9jnxe0i7oIUeBPU1l0f05d9zS
         rLGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JWAVdayu73KUbkTP+3uedkJlcNOyLvU+zwog6pNshuM=;
        b=f5l+eoDU37QPUnF8JkNYk1673xqeET8kW2qWwsxMoraSbMHofJzBgcP1utTA1fRH/x
         DTI5sfcOcrlpbGxbGDeYn4SWmfObMyPzoD1Rple8cTWGqojnRQGU8SVuUK39lNO8eXxX
         f6k4ZzGBOcatzhWgFRjEOcKRtzM8/V2DT2caW3yyNp/9f0H41ebU5dCLZuN1BimeG7aO
         56g+HlLuSK4rP7FPV3QbKcrKjIpvhrIRJ00J5v330WHHPmJybAWsa//GEsZqsecj4HXe
         Z0r510cic2KOstNlse9aMUuqq20pYwbB8Qy/04+adymHkNpj63ZFqCP1q1CHi8IJ4FKN
         PzCg==
X-Gm-Message-State: AOAM533TNmEthWa8pD/+VUnOm6phojb46Hm6tPOD9456BwEvG/PDE1io
        9MzyAv9wDG54XL/IrPJhDz/+re1cRYdW5lB2ymc=
X-Google-Smtp-Source: ABdhPJx98h5lE8fYJRTOwp8/ncfIdW/TJ7bXn1XYEQWwQxUk+vXANRZnHVlvhrJ184kOQlU3leZcYMB1UmTjcoExTjs=
X-Received: by 2002:a37:b51:0:b0:69f:c378:e1e1 with SMTP id
 78-20020a370b51000000b0069fc378e1e1mr2060036qkl.180.1652942029444; Wed, 18
 May 2022 23:33:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220518134550.2358-1-ubizjak@gmail.com> <202205190852.VUijQkwc-lkp@intel.com>
In-Reply-To: <202205190852.VUijQkwc-lkp@intel.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Thu, 19 May 2022 08:33:38 +0200
Message-ID: <CAFULd4bf9EzbhO=Kbexiq6zS7c=pzZ_LxBhLkeWP4HTcUqKD2A@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Use try_cmpxchg64 in pi_try_set_control
To:     kernel test robot <lkp@intel.com>
Cc:     kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kbuild-all@lists.01.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 19, 2022 at 3:05 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Uros,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on kvm/master]
> [also build test ERROR on mst-vhost/linux-next linux/master linus/master v5.18-rc7 next-20220518]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Uros-Bizjak/KVM-VMX-Use-try_cmpxchg64-in-pi_try_set_control/20220518-214709
> base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git master
> config: i386-debian-10.3-kselftests (https://download.01.org/0day-ci/archive/20220519/202205190852.VUijQkwc-lkp@intel.com/config)
> compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
> reproduce (this is a W=1 build):
>         # https://github.com/intel-lab-lkp/linux/commit/2af4f7c4ecfcaedf9b98ba30ee508dc0d9002955
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Uros-Bizjak/KVM-VMX-Use-try_cmpxchg64-in-pi_try_set_control/20220518-214709
>         git checkout 2af4f7c4ecfcaedf9b98ba30ee508dc0d9002955
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash arch/x86/kvm/
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):

As stated in the patch submission, this patch needs locking
infrastructure patches that are currently in the tip git, so there is
a small patch ordering issue between tip and KVM trees.

Uros.
