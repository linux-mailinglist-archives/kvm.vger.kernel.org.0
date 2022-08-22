Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 643F159C1FE
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 17:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235713AbiHVPAO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 11:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235560AbiHVPAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 11:00:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54292872D
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 08:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661180409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ztKOeB8BytpGS9oJ4KOu449CuGX9ihFu6jNtz6UJJoA=;
        b=c/7ZVxzgNkVhmRGRntVIWZMyqxbWMd25qE+927vPk42qRm5TM6BSCp9dVrXwYAEbwnBxTY
        YmMSIEAC+yNP3lxA25/dU9aR2/vtVSU738GuwTG36JSF+WlSj21tUHilwFM+ngcz9NAKIX
        xxapnLSh0XzBd4QO7ZeyYS63FWu2qqI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-126-x1-2azh_OhyX7yfcIM4agg-1; Mon, 22 Aug 2022 11:00:07 -0400
X-MC-Unique: x1-2azh_OhyX7yfcIM4agg-1
Received: by mail-ed1-f69.google.com with SMTP id b13-20020a056402350d00b0043dfc84c533so7045609edd.5
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 08:00:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=ztKOeB8BytpGS9oJ4KOu449CuGX9ihFu6jNtz6UJJoA=;
        b=5lneV5O11aAcXdujgRmMuLrTX76sJPkqPzZQ2977Vf+kwrouGaYzEGajhTCwbIaZED
         /wcJpbMz7zhC/m9sryOnAgpXO7XTDZqAn27NBnJgm96b9QGWma3fKGwxtJOKE8EW/CKr
         VVOA3twuwfTjkCSJU5e879eqnpOtG1t1OY+wWOhdKdaE1WERGRsmDn3sClUkfoPocT8Y
         heDygcyfQeOwpjtFAgqEzGm+KBBVguJ5ISfSahTJaNa05tA27Ej13zpG7DWN/2nuyrkG
         djBEtZQHGJXhSlEPTs2Bf433mwgSXbyLHxg4c0Y6dQm3c4EjmKOx1KAKtwwc+q3frEdH
         pP5g==
X-Gm-Message-State: ACgBeo3QfDT+18nkDhiZOeTSkbNVGzUBQnxG6jj086+zVNSGNeGbfzIC
        iurcsY+ejLnTsDPcIF/Up4fu2oBnVkvO9jhbP0R6wt74zXZBlbNXPymhK5hf1cl5NKSeTOJweD0
        g8yhgoniVtIqq
X-Received: by 2002:a05:6402:2755:b0:43d:7568:c78e with SMTP id z21-20020a056402275500b0043d7568c78emr16839836edd.104.1661180406405;
        Mon, 22 Aug 2022 08:00:06 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5Px/A3k/BhgO3tcIds2Ce5YHxwTCTCoZ5Kl0BNrakOcDOMdhCTB5Ff2bXe4/Mdn29r6hJ22g==
X-Received: by 2002:a05:6402:2755:b0:43d:7568:c78e with SMTP id z21-20020a056402275500b0043d7568c78emr16839821edd.104.1661180406202;
        Mon, 22 Aug 2022 08:00:06 -0700 (PDT)
Received: from [10.43.2.39] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id j7-20020aa7c407000000b004465d1db765sm5516295edq.89.2022.08.22.08.00.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Aug 2022 08:00:05 -0700 (PDT)
Message-ID: <f3bc61c8-d491-f79c-15d7-191208c57224@redhat.com>
Date:   Mon, 22 Aug 2022 17:00:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v5 1/3] Update linux headers to 6.0-rc1
Content-Language: en-US
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220817020845.21855-1-chenyi.qiang@intel.com>
 <20220817020845.21855-2-chenyi.qiang@intel.com>
From:   =?UTF-8?B?TWljaGFsIFByw612b3puw61r?= <mprivozn@redhat.com>
In-Reply-To: <20220817020845.21855-2-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/17/22 04:08, Chenyi Qiang wrote:
> commit 568035b01cfb107af8d2e4bd2fb9aea22cf5b868
>=20
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>  include/standard-headers/asm-x86/bootparam.h  |   7 +-
>  include/standard-headers/drm/drm_fourcc.h     |  73 +++++++-
>  include/standard-headers/linux/ethtool.h      |  29 +--
>  include/standard-headers/linux/input.h        |  12 +-
>  include/standard-headers/linux/pci_regs.h     |  30 ++-
>  include/standard-headers/linux/vhost_types.h  |  17 +-
>  include/standard-headers/linux/virtio_9p.h    |   2 +-
>  .../standard-headers/linux/virtio_config.h    |   7 +-
>  include/standard-headers/linux/virtio_ids.h   |  14 +-
>  include/standard-headers/linux/virtio_net.h   |  34 +++-
>  include/standard-headers/linux/virtio_pci.h   |   2 +
>  linux-headers/asm-arm64/kvm.h                 |  27 +++
>  linux-headers/asm-generic/unistd.h            |   4 +-
>  linux-headers/asm-riscv/kvm.h                 |  22 +++
>  linux-headers/asm-riscv/unistd.h              |   3 +-
>  linux-headers/asm-s390/kvm.h                  |   1 +
>  linux-headers/asm-x86/kvm.h                   |  33 ++--
>  linux-headers/asm-x86/mman.h                  |  14 --
>  linux-headers/linux/kvm.h                     | 172 +++++++++++++++++-=

>  linux-headers/linux/userfaultfd.h             |  10 +-
>  linux-headers/linux/vduse.h                   |  47 +++++
>  linux-headers/linux/vfio.h                    |   4 +-
>  linux-headers/linux/vfio_zdev.h               |   7 +
>  linux-headers/linux/vhost.h                   |  35 +++-
>  24 files changed, 523 insertions(+), 83 deletions(-)
>=20


> diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
> index bf6e96011d..46de10a809 100644
> --- a/linux-headers/asm-x86/kvm.h
> +++ b/linux-headers/asm-x86/kvm.h
> @@ -198,13 +198,13 @@ struct kvm_msrs {
>  	__u32 nmsrs; /* number of msrs in entries */
>  	__u32 pad;
> =20
> -	struct kvm_msr_entry entries[0];
> +	struct kvm_msr_entry entries[];
>  };
> =20

I don't think it's this simple. I think this needs to go hand in hand wit=
h kvm_arch_get_supported_msr_feature().

Also, this breaks clang build:

clang -m64 -mcx16 -Ilibqemu-x86_64-softmmu.fa.p -I. -I.. -Itarget/i386 -I=
=2E./target/i386 -Iqapi -Itrace -Iui -Iui/shader -I/usr/include/pixman-1 =
-I/usr/include/spice-server -I/usr/include/spice-1 -I/usr/include/glib-2.=
0 -I/usr/lib64/glib-2.0/include -fcolor-diagnostics -Wall -Winvalid-pch -=
Werror -std=3Dgnu11 -O0 -g -isystem /home/zippy/work/qemu/qemu.git/linux-=
headers -isystem linux-headers -iquote . -iquote /home/zippy/work/qemu/qe=
mu.git -iquote /home/zippy/work/qemu/qemu.git/include -iquote /home/zippy=
/work/qemu/qemu.git/tcg/i386 -pthread -D_GNU_SOURCE -D_FILE_OFFSET_BITS=3D=
64 -D_LARGEFILE_SOURCE -Wstrict-prototypes -Wredundant-decls -Wundef -Wwr=
ite-strings -Wmissing-prototypes -fno-strict-aliasing -fno-common -fwrapv=
 -Wold-style-definition -Wtype-limits -Wformat-security -Wformat-y2k -Win=
it-self -Wignored-qualifiers -Wempty-body -Wnested-externs -Wendif-labels=
 -Wexpansion-to-defined -Wno-initializer-overrides -Wno-missing-include-d=
irs -Wno-shift-negative-value -Wno-string-plus-int -Wno-typedef-redefinit=
ion -Wno-tautological-type-limit-compare -Wno-psabi -fstack-protector-str=
ong -O0 -ggdb -fPIE -isystem../linux-headers -isystemlinux-headers -DNEED=
_CPU_H '-DCONFIG_TARGET=3D"x86_64-softmmu-config-target.h"' '-DCONFIG_DEV=
ICES=3D"x86_64-softmmu-config-devices.h"' -MD -MQ libqemu-x86_64-softmmu.=
fa.p/target_i386_kvm_kvm.c.o -MF libqemu-x86_64-softmmu.fa.p/target_i386_=
kvm_kvm.c.o.d -o libqemu-x86_64-softmmu.fa.p/target_i386_kvm_kvm.c.o -c .=
=2E/target/i386/kvm/kvm.c
=2E./target/i386/kvm/kvm.c:470:25: error: field 'info' with variable size=
d type 'struct kvm_msrs' not at the end of a struct or class is a GNU ext=
ension [-Werror,-Wgnu-variable-sized-type-not-at-end]
        struct kvm_msrs info;
                        ^
=2E./target/i386/kvm/kvm.c:1701:27: error: field 'cpuid' with variable si=
zed type 'struct kvm_cpuid2' not at the end of a struct or class is a GNU=
 extension [-Werror,-Wgnu-variable-sized-type-not-at-end]
        struct kvm_cpuid2 cpuid;
                          ^
=2E./target/i386/kvm/kvm.c:2868:25: error: field 'info' with variable siz=
ed type 'struct kvm_msrs' not at the end of a struct or class is a GNU ex=
tension [-Werror,-Wgnu-variable-sized-type-not-at-end]
        struct kvm_msrs info;
                        ^
3 errors generated.


Michal

