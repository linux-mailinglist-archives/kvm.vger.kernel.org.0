Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438435866AC
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 11:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbiHAJDI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 05:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiHAJDG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 05:03:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CB79BC88
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 02:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659344584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ncyaFYJzP9g8NKrBs3wrk9j01RRn6jvYie2crlUdCG0=;
        b=dp1aIyUpcvUAq8TO3PxXMBeK+ml6P+xyNt5h5VxrsTEBsH9wuTfSnlDYbk+ZuGBgFnTwgS
        KUNCYsePf6djVhTc2q21H0EK7M0JCXHeSaTVblaXk8JMvkrPyFWUOhTor02dnNXO0w6m8a
        ZkOmr9OcmNePNu6CId2ivGBqFUNg+iE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-x7wL5vgPOZ-RaFnKjcbTKg-1; Mon, 01 Aug 2022 05:03:02 -0400
X-MC-Unique: x7wL5vgPOZ-RaFnKjcbTKg-1
Received: by mail-wr1-f72.google.com with SMTP id n7-20020adfc607000000b0021a37d8f93aso2391907wrg.21
        for <kvm@vger.kernel.org>; Mon, 01 Aug 2022 02:03:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ncyaFYJzP9g8NKrBs3wrk9j01RRn6jvYie2crlUdCG0=;
        b=oUEL6VPSMtgSdAihXpQJG73dUrASS0xXobkayj3i4H+YuHXdOOxBD2gheJRyGQbakh
         +bjenuSEPTvs9DskGKUmyc1MrVe+GeAkW8ZRt8y8wkD+siil90PTCUkgi9piaAspQqfA
         ytZxyp98mStUG3qjBQq4Luo9peSBR4OriaLy8K+QsLpcIxVi3U6wTfhbpC3mrDbhEIjH
         Ad6GqnofOPrVlaqeOayV0nMZnS8Sltc4mwFoJSORcAxWAdA69PPXUjqkd5AbUm8wFFce
         kwjjdIPyDm0cMjjJT14v568ut1m9D6L/Vhdw14tDSq3bYF6zErFTroOCWNwBXlUvO1mc
         0ILQ==
X-Gm-Message-State: AJIora9nTyWFFRBQtyhG4EIFUCZNYo0sk8qAakb/lEEo5Wzxn7PPuSzD
        ftWoPdR1MwAhtFqjMfXsaYrHiHJmxdX7NRIlSB5vW+k5Rej79h39zjwEi0lY+8xw4ZjMH0zObAG
        09aNjiLiwSNGA
X-Received: by 2002:a05:600c:284a:b0:3a2:ffb7:b56f with SMTP id r10-20020a05600c284a00b003a2ffb7b56fmr10682183wmb.134.1659344581601;
        Mon, 01 Aug 2022 02:03:01 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tsckfo/c3O5sXcoRGktHAw/KB2X00NMz3NhlP5jTXkDvcRrwwoAZMoB8u/IniTRLvnw9ZwPQ==
X-Received: by 2002:a05:600c:284a:b0:3a2:ffb7:b56f with SMTP id r10-20020a05600c284a00b003a2ffb7b56fmr10682148wmb.134.1659344581267;
        Mon, 01 Aug 2022 02:03:01 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h15-20020a05600c414f00b003a49e4e7dd6sm12130606wmm.36.2022.08.01.02.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 02:03:00 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [linux-stable-rc:linux-5.15.y 5373/8464]
 arch/x86/kvm/hyperv.c:2185:5: warning: stack frame size (1036) exceeds
 limit (1024) in 'kvm_hv_hypercall'
In-Reply-To: <202207161843.WnHPjB0l-lkp@intel.com>
References: <202207161843.WnHPjB0l-lkp@intel.com>
Date:   Mon, 01 Aug 2022 11:03:00 +0200
Message-ID: <874jyw2v5n.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kernel test robot <lkp@intel.com> writes:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> head:   baefa2315cb1371486f6661a628e96fa3336f573
> commit: cb188e07105f2216f5efbefac95df4b6ce266906 [5373/8464] KVM: x86: hyper-v: HVCALL_SEND_IPI_EX is an XMM fast hypercall
> config: i386-allyesconfig (https://download.01.org/0day-ci/archive/20220716/202207161843.WnHPjB0l-lkp@intel.com/config)
> compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 07022e6cf9b5b3baa642be53d0b3c3f1c403dbfd)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?id=cb188e07105f2216f5efbefac95df4b6ce266906
>         git remote add linux-stable-rc https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>         git fetch --no-tags linux-stable-rc linux-5.15.y
>         git checkout cb188e07105f2216f5efbefac95df4b6ce266906
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash arch/x86/kvm/
>
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>>> arch/x86/kvm/hyperv.c:2185:5: warning: stack frame size (1036) exceeds limit (1024) in 'kvm_hv_hypercall' [-Wframe-larger-than]
>    int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>        ^
>    1 warning generated.
>
>
> vim +/kvm_hv_hypercall +2185 arch/x86/kvm/hyperv.c
>
> 4ad81a91119df7 Vitaly Kuznetsov         2021-05-21  2184  
> e83d58874ba1de Andrey Smetanin          2015-07-03 @2185  int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
> e83d58874ba1de Andrey Smetanin          2015-07-03  2186  {
> 4e62aa96d6e55c Vitaly Kuznetsov         2021-07-30  2187  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> bd38b32053eb1c Siddharth Chandrasekaran 2021-05-26  2188  	struct kvm_hv_hcall hc;
> bd38b32053eb1c Siddharth Chandrasekaran 2021-05-26  2189  	u64 ret = HV_STATUS_SUCCESS;

That's a bit weird: struct kvm_hv_hcall is 144 bytes only so this is
very, very far from 1024. The referred commit (cb188e07105f) also
doesn't add any on-stack allocations to kvm_hv_hypercall() directly,
however, it leaves only once call site for kvm_hv_send_ipi() and the
compiler may have switched to inlining it. Assuming that's the case, I'm
completely clueless about why such potentially dangerous 'optimization'
make any sense.

In any case, there's a pending patch:

https://lore.kernel.org/kvm/20220714134929.1125828-13-vkuznets@redhat.com/

which is supposed to help here.

> e83d58874ba1de Andrey Smetanin          2015-07-03  2190  
> e83d58874ba1de Andrey Smetanin          2015-07-03  2191  	/*
> e83d58874ba1de Andrey Smetanin          2015-07-03  2192  	 * hypercall generates UD from non zero cpl and real mode
> e83d58874ba1de Andrey Smetanin          2015-07-03  2193  	 * per HYPER-V spec
> e83d58874ba1de Andrey Smetanin          2015-07-03  2194  	 */
> b3646477d458fb Jason Baron              2021-01-14  2195  	if (static_call(kvm_x86_get_cpl)(vcpu) != 0 || !is_protmode(vcpu)) {
> e83d58874ba1de Andrey Smetanin          2015-07-03  2196  		kvm_queue_exception(vcpu, UD_VECTOR);
> 0d9c055eaaf41b Andrey Smetanin          2016-02-11  2197  		return 1;
> e83d58874ba1de Andrey Smetanin          2015-07-03  2198  	}
> e83d58874ba1de Andrey Smetanin          2015-07-03  2199  
>
> :::::: The code at line 2185 was first introduced by commit
> :::::: e83d58874ba1de74c13d3c6b05f95a023c860d25 kvm/x86: move Hyper-V MSR's/hypercall code into hyperv.c file
>
> :::::: TO: Andrey Smetanin <asmetanin@virtuozzo.com>
> :::::: CC: Paolo Bonzini <pbonzini@redhat.com>

-- 
Vitaly

