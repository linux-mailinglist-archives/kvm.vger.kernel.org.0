Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48646E34CE
	for <lists+kvm@lfdr.de>; Sun, 16 Apr 2023 05:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjDPDbd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Apr 2023 23:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjDPDbb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Apr 2023 23:31:31 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DD11BC8
        for <kvm@vger.kernel.org>; Sat, 15 Apr 2023 20:31:30 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 185so1587255pgc.10
        for <kvm@vger.kernel.org>; Sat, 15 Apr 2023 20:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681615890; x=1684207890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TjeEy5ULGrDULBX1ItXV0d2QcNX0rRG2/eteK+KuAoI=;
        b=M/nWmTVdu0YxzmSJntss1YOmDxAjmE/GtrRuumB4MpBtw51xAKy8bdcd+T3m4oSLqB
         esNmYz8hBF+hT58WQw9JuJJzR5Eqa9oTLSr2UGtuzhLyycUVtJsHUmgG1+DbumXJu0Rl
         NfkC2mzQUqglCB1WLrNH/r/rNEfr+51L1A0ErR8zAdMDTlZn3O8LeNOxFVWHum9hf9dw
         fxcQ84MKljG6za7M0utyEqT/r3GsrljZl7rDO7V2z2+qXwfKBayMEo1sy5a4/WChYJGF
         RQwBCEKpWgya6ymMPxbwwrkIWbR0HISzNNS+IwOyhDdO7ZwdAMHgBqb6OYJiNY3yWa1v
         BwIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681615890; x=1684207890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TjeEy5ULGrDULBX1ItXV0d2QcNX0rRG2/eteK+KuAoI=;
        b=ai/w0OL/x21BIv2iVpIBX3ciXwdzzgiRRNHiI6Gzh2A+u8NMt4LIPTivZrNwpxNJ39
         oiso23e8ltISGa7GvYzTwKw3kcjlizgVIUt6YRaOVqQQhZ/rryfsXk9Qe+zvhFvtrUag
         dk6TDIy3bk1bG0GHPDo7YPg9jFDhNV/iSNUivtvxjnzX8D4MxyKZlHS0jOH3GuTguOmY
         bsdGdVt9Z5+kxYCfMPKsqeyAlhBySo3Nwkz340JjsPqcC3oGAJs7JtsqWymPrHHGf12h
         zke7MLgQ065It88QZ6Ej/hPAK/ETn8XJH4suU+1kh0TXKq4aMP/eRnnE3FlNNH4lXnR4
         joCw==
X-Gm-Message-State: AAQBX9dDBiIwvalMnanPTxD8ejlaHneV10l/B7VDDYRrFNTOpgzHGDqT
        /BTd0BbQBisC0lrSK5Z+trRBVoIgTRVB2pE9HE/XCA==
X-Google-Smtp-Source: AKy350ZKe14U8RcoJ0rqKV44dc6s9km1gogrAzuwrrkg9jPwdTmhuq6/Rs1+82DYNXnDmzh0v7CW6bXhoMUzguC6a8E=
X-Received: by 2002:a63:1a0f:0:b0:513:9350:c5bd with SMTP id
 a15-20020a631a0f000000b005139350c5bdmr1910375pga.4.1681615889591; Sat, 15 Apr
 2023 20:31:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230415164029.526895-3-reijiw@google.com> <202304160658.Oqr1xZbi-lkp@intel.com>
In-Reply-To: <202304160658.Oqr1xZbi-lkp@intel.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sat, 15 Apr 2023 20:31:13 -0700
Message-ID: <CAAeT=Fy1gvJSDt7J2+NZN=PWdQ_r18vNGkVT+EbSrE5ZkNCzCA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] KVM: arm64: PMU: Don't overwrite PMUSERENR with
 vcpu loaded
To:     kernel test robot <lkp@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kvmarm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Rob Herring <robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 15, 2023 at 3:10=E2=80=AFPM kernel test robot <lkp@intel.com> w=
rote:
>
> Hi Reiji,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Reiji-Watanabe/KVM=
-arm64-PMU-Restore-the-host-s-PMUSERENR_EL0/20230416-004142
> base:   09a9639e56c01c7a00d6c0ca63f4c7c41abe075d
> patch link:    https://lore.kernel.org/r/20230415164029.526895-3-reijiw%4=
0google.com
> patch subject: [PATCH v3 2/2] KVM: arm64: PMU: Don't overwrite PMUSERENR =
with vcpu loaded
> config: arm64-allyesconfig (https://download.01.org/0day-ci/archive/20230=
416/202304160658.Oqr1xZbi-lkp@intel.com/config)
> compiler: aarch64-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=3D1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbi=
n/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/276e15e5db0900394=
4d194da2b2577cff5192884
>         git remote add linux-review https://github.com/intel-lab-lkp/linu=
x
>         git fetch --no-tags linux-review Reiji-Watanabe/KVM-arm64-PMU-Res=
tore-the-host-s-PMUSERENR_EL0/20230416-004142
>         git checkout 276e15e5db09003944d194da2b2577cff5192884
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dgcc-12.1.0 make.cro=
ss W=3D1 O=3Dbuild_dir ARCH=3Darm64 olddefconfig
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dgcc-12.1.0 make.cro=
ss W=3D1 O=3Dbuild_dir ARCH=3Darm64 SHELL=3D/bin/bash
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Link: https://lore.kernel.org/oe-kbuild-all/202304160658.Oqr1xZbi-lkp@i=
ntel.com/
>
> All errors (new ones prefixed by >>):
>
>    aarch64-linux-ld: Unexpected GOT/PLT entries detected!
>    aarch64-linux-ld: Unexpected run-time procedure linkages detected!
>    aarch64-linux-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__k=
vm_nvhe___activate_traps_common':
> >> __kvm_nvhe_switch.c:(.hyp.text+0x14b4): undefined reference to `__kvm_=
nvhe_warn_bogus_irq_restore'
>    aarch64-linux-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__k=
vm_nvhe___deactivate_traps_common':
>    __kvm_nvhe_switch.c:(.hyp.text+0x1f6c): undefined reference to `__kvm_=
nvhe_warn_bogus_irq_restore'

It looks like this happens when CONFIG_DEBUG_IRQFLAGS is enabled.
I am going to introduce another flag to disable this as well.

Thanks,
Reiji
