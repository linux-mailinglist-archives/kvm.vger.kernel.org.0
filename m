Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF3E530906
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 07:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbiEWFyW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 01:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiEWFyO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 01:54:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6D48731210
        for <kvm@vger.kernel.org>; Sun, 22 May 2022 22:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653285251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SyQ0q/1cfv9Dr9N4yrSfFi2vvZn6zBLKl1GWo7CSuOw=;
        b=I5PjK5BCz7IvbSaXJPnJvRgV7AgmtgQwp4sdD1G1JU8Bj59oxtT3Mnj6d2ofKGNO8fFS49
        /ZK/3qtc5dg/aPzbwmeey2PwaLGsURTJ/0rJWOqSgkFMtC8O1jOAtuubli8B6ncG1JwIXv
        cqzi7TXcF5tT1BiIEXQCtmnosqyxDgc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-494-F-_xaWkAPsulqI4X2-JDkQ-1; Mon, 23 May 2022 01:54:09 -0400
X-MC-Unique: F-_xaWkAPsulqI4X2-JDkQ-1
Received: by mail-ed1-f72.google.com with SMTP id w23-20020aa7da57000000b0042acd76347bso9912036eds.2
        for <kvm@vger.kernel.org>; Sun, 22 May 2022 22:54:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=SyQ0q/1cfv9Dr9N4yrSfFi2vvZn6zBLKl1GWo7CSuOw=;
        b=VuM7ZtfZvxiEwF0QtiJli9XqLzwzlxX1QqtfyoUEu0dCOFcWMuLtmutFIUtbylEkU4
         67U8kjzXvH2n6w4yDehi0/ulY5AlNr3aSp7H/WuwU4zN2lPn/qEVKaj8+Q15o2MYDUed
         bGH9mjKn4smIqR9hwKEewKnv3L/3jDea47l+P1GTKfa1n58trTgwAd+i8qsSQLTEPgFH
         D/zEfrn1VlojpsQefFzNgY98o+PSnnQOflPdudwxIHNDWylnW4dwSgEW0KiqZ6zXiMqE
         Sqrs2ABIUsECjnDBMtc/cG+FniKdEN9mQ4OpvzujesqNOk3QOpwtVlJAkZjsqyHYehih
         hYRw==
X-Gm-Message-State: AOAM531B7zNOhzEoi4adLYJDdKoAdycQc5UP8iIoHfN7ozz2HKiDRkFe
        LLlUgfKgyOXtmE5H1ckwDyG0raUecPb2k68Jo3pPjo4o5twOM9y0JthF80Ne5nDPFDh8zk4HNaf
        l/EBVEqkTonDw
X-Received: by 2002:a05:6402:34c2:b0:42b:66d3:7b07 with SMTP id w2-20020a05640234c200b0042b66d37b07mr4193947edc.275.1653285248592;
        Sun, 22 May 2022 22:54:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1DWjG8FpraJzWe8ZWQtBDbo1n8T4WVu+1eU3YiF9hI1NP7Z7jCEltTqr7+vod4nIwDlJdzA==
X-Received: by 2002:a05:6402:34c2:b0:42b:66d3:7b07 with SMTP id w2-20020a05640234c200b0042b66d37b07mr4193941edc.275.1653285248330;
        Sun, 22 May 2022 22:54:08 -0700 (PDT)
Received: from [127.0.0.1] (93-55-6-57.ip261.fastwebnet.it. [93.55.6.57])
        by smtp.gmail.com with ESMTPSA id 1-20020a170906100100b006f506ed0b42sm5650794ejm.48.2022.05.22.22.54.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 May 2022 22:54:07 -0700 (PDT)
Date:   Mon, 23 May 2022 07:54:01 +0200
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Yury Norov <yury.norov@gmail.com>
CC:     kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
        kbuild-all@lists.01.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, lkft-triage@lists.linaro.org
Subject: =?US-ASCII?Q?Re=3A_=5Blinux-next=3Amaster_12308/12886=5D_arch/x86/kvm/hyp?= =?US-ASCII?Q?erv=2Ec=3A1983=3A22=3A_warning=3A_sh?= =?US-ASCII?Q?ift_count_=3E=3D_width_of_type?=
In-Reply-To: <CA+G9fYtaz2MO_-yxwtqQx+Gxm460mr2S++fFCYAqObacEL1X-Q@mail.gmail.com>
References: <202205201624.A4IhDdYX-lkp@intel.com> <Yoe4WQCV9903aQRP@dev-arch.thelio-3990X> <CA+G9fYtaz2MO_-yxwtqQx+Gxm460mr2S++fFCYAqObacEL1X-Q@mail.gmail.com>
Message-ID: <3A8C8235-7FC0-4FDF-921A-E53B57096256@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The patch is already merged in 5=2E18=2E

Paolo


Il 23 maggio 2022 07:49:42 CEST, Naresh Kamboju <naresh=2Ekamboju@linaro=
=2Eorg> ha scritto:
>On Fri, 20 May 2022 at 21:18, Nathan Chancellor <nathan@kernel=2Eorg> wro=
te:
>>
>> Hi Yury,
>>
>> On Fri, May 20, 2022 at 04:24:32PM +0800, kernel test robot wrote:
>> > tree:   https://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/next/linu=
x-next=2Egit master
>> > head:   21498d01d045c5b95b93e0a0625ae965b4330ebe
>> > commit: 81db71a60292e9a40ae8f6ef137b17f2aaa15a52 [12308/12886] KVM: x=
86: hyper-v: replace bitmap_weight() with hweight64()
>> > config: i386-randconfig-a011 (https://download=2E01=2Eorg/0day-ci/arc=
hive/20220520/202205201624=2EA4IhDdYX-lkp@intel=2Ecom/config)
>> > compiler: clang version 15=2E0=2E0 (https://github=2Ecom/llvm/llvm-pr=
oject e00cbbec06c08dc616a0d52a20f678b8fbd4e304)
>> > reproduce (this is a W=3D1 build):
>> >         wget https://raw=2Egithubusercontent=2Ecom/intel/lkp-tests/ma=
ster/sbin/make=2Ecross -O ~/bin/make=2Ecross
>> >         chmod +x ~/bin/make=2Ecross
>> >         # https://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/next/li=
nux-next=2Egit/commit/?id=3D81db71a60292e9a40ae8f6ef137b17f2aaa15a52
>> >         git remote add linux-next https://git=2Ekernel=2Eorg/pub/scm/=
linux/kernel/git/next/linux-next=2Egit
>> >         git fetch --no-tags linux-next master
>> >         git checkout 81db71a60292e9a40ae8f6ef137b17f2aaa15a52
>> >         # save the config file
>> >         mkdir build_dir && cp config build_dir/=2Econfig
>> >         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make=2Ecr=
oss W=3D1 O=3Dbuild_dir ARCH=3Di386 SHELL=3D/bin/bash
>> >
>> > If you fix the issue, kindly add following tag as appropriate
>> > Reported-by: kernel test robot <lkp@intel=2Ecom>
>> >
>> > All warnings (new ones prefixed by >>):
>> >
>> > >> arch/x86/kvm/hyperv=2Ec:1983:22: warning: shift count >=3D width o=
f type [-Wshift-count-overflow]
>> >                    if (hc->var_cnt !=3D hweight64(valid_bank_mask))
>> >                                       ^~~~~~~~~~~~~~~~~~~~~~~~~~
>> >    include/asm-generic/bitops/const_hweight=2Eh:29:49: note: expanded=
 from macro 'hweight64'
>> >    #define hweight64(w) (__builtin_constant_p(w) ? __const_hweight64(=
w) : __arch_hweight64(w))
>> >                                                    ^~~~~~~~~~~~~~~~~~=
~~
>> >    include/asm-generic/bitops/const_hweight=2Eh:21:76: note: expanded=
 from macro '__const_hweight64'
>> >    #define __const_hweight64(w) (__const_hweight32(w) + __const_hweig=
ht32((w) >> 32))
>> >                                                                      =
         ^  ~~
>> >    include/asm-generic/bitops/const_hweight=2Eh:20:49: note: expanded=
 from macro '__const_hweight32'
>> >    #define __const_hweight32(w) (__const_hweight16(w) + __const_hweig=
ht16((w) >> 16))
>> >                                                    ^
>> >    note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-l=
imit=3D0 to see all)
>> >    include/asm-generic/bitops/const_hweight=2Eh:10:9: note: expanded =
from macro '__const_hweight8'
>> >             ((!!((w) & (1ULL << 0))) +     \
>> >                   ^
>> >    include/linux/compiler=2Eh:56:47: note: expanded from macro 'if'
>> >    #define if(cond, =2E=2E=2E) if ( __trace_if_var( !!(cond , ## __VA=
_ARGS__) ) )
>> >                                                  ^~~~
>> >    include/linux/compiler=2Eh:58:52: note: expanded from macro '__tra=
ce_if_var'
>> >    #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) =
: __trace_if_value(cond))
>> >                                                       ^~~~
>
>LKFT build system found these build warnings / errors on Linux next-20220=
520=2E
>
>> I think this is the proper fix, as valid_bank_mask is only assigned u64
>> values=2E Could you fold it into that patch to clear this warning up?
>
>The proposed patch below was tested and it fixed the reported problem on =
32-bit
>
>> Cheers,
>> Nathan
>>
>> diff --git a/arch/x86/kvm/hyperv=2Ec b/arch/x86/kvm/hyperv=2Ec
>> index b652b856df2b=2E=2Ee2e95a6fccfd 100644
>> --- a/arch/x86/kvm/hyperv=2Ec
>> +++ b/arch/x86/kvm/hyperv=2Ec
>> @@ -1914,7 +1914,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu,=
 struct kvm_hv_hcall *hc)
>>         struct hv_send_ipi_ex send_ipi_ex;
>>         struct hv_send_ipi send_ipi;
>>         DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
>> -       unsigned long valid_bank_mask;
>> +       u64 valid_bank_mask;
>>         u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
>>         u32 vector;
>>         bool all_cpus;
>
>Reported-by: Linux Kernel Functional Testing <lkft@linaro=2Eorg>
>Tested-by: Linux Kernel Functional Testing <lkft@linaro=2Eorg>
>
>--
>Linaro LKFT
>https://lkft=2Elinaro=2Eorg
>

