Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A35574D729
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 15:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjGJNOa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 09:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjGJNO3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 09:14:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99150C4
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 06:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688994823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/ImDQa0EWypkbyYilMZRBoCfhHc+qyTpXaLpUiDl7QI=;
        b=aRtuFyJt46Tf6z4QtwSX7OrVKeV1EtVCgo9rdyyhW/dn4VxJABzN3xohHpF5ZcXaH3FxIL
        7yaZ8cWbWeTKP94eyztjhavstACw3W9qo+McZvLZNLsrgSs++UhGtDL3I1HPwxkPRNYKrg
        abBGhpKUX9mjH5CoRNEXYM5GjJYtg7M=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-324-ySWtCjzBOhOnAd8a7vM8Kw-1; Mon, 10 Jul 2023 09:13:42 -0400
X-MC-Unique: ySWtCjzBOhOnAd8a7vM8Kw-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-76746f54ba9so572422185a.0
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 06:13:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688994822; x=1691586822;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ImDQa0EWypkbyYilMZRBoCfhHc+qyTpXaLpUiDl7QI=;
        b=TgA3X0JrtSizGHit5R5Xi5BD4pEUXuAe+soJ1b1lRyG5ekMeELV+CFm+LtoWToeUBH
         DymJUWg9HmKe+WKdBnj7oKWMgFfWA+28oe3BLqmHUAYQGk5g6sONTtlcWjqM3H6GoyL8
         eZdit1PYNvC+TqsA+Yxh8iIYRPw0NMUXEIIpkg/kg5kcxo6XHqMK0hjhhkPLnPqgtbFy
         1VoafQV7jyN0wECLBKv9luzCwAjsJFB3hCET4PIvCDkJP0006Kpl8NCYz9xzGaaWugKS
         jo+UapimhKsvJvjJJH3DW0NUFlHWLAzpFk77pTAk02wbnxLXB8BRJUEwjBqAktqnu2D/
         09ZQ==
X-Gm-Message-State: ABy/qLasa2MmlK0I6Abwzq7Fu1zGY3c0NEkq4Caq5b7NJ7HBJSurTSpJ
        CUP4QH4ACvY+5dAz/T70sT89/ufvQKbValYinJwI6Asvr905EM/yyhBhiKr8APC4pYPSHw93of7
        SH/uxIK3xlBzzZkwEWDss5FFSHPoNl0krJAx2IVDaZkBMFWHK3qjl673f9hGh+cx7stEWPY6Elu
        g=
X-Received: by 2002:a05:620a:17a9:b0:765:614a:aa0d with SMTP id ay41-20020a05620a17a900b00765614aaa0dmr13761732qkb.56.1688994822209;
        Mon, 10 Jul 2023 06:13:42 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHZhgqKIZKXgV1RDSk/xsuo9lvs/S+f7G6Iii+FqbXBn5CqQSyBZROmmfgH6B6PkVW/dHZULg==
X-Received: by 2002:a05:620a:17a9:b0:765:614a:aa0d with SMTP id ay41-20020a05620a17a900b00765614aaa0dmr13761705qkb.56.1688994821816;
        Mon, 10 Jul 2023 06:13:41 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id w8-20020a05620a128800b0076639dfca86sm4898224qki.17.2023.07.10.06.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jul 2023 06:13:41 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kernel test robot <lkp@intel.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [stable:linux-5.15.y 55/9999] arch/x86/kvm/hyperv.c:2185:5:
 error: stack frame size (1036) exceeds limit (1024) in 'kvm_hv_hypercall'
In-Reply-To: <202307080326.zDp7E3o0-lkp@intel.com>
References: <202307080326.zDp7E3o0-lkp@intel.com>
Date:   Mon, 10 Jul 2023 15:13:38 +0200
Message-ID: <87y1jn52pp.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kernel test robot <lkp@intel.com> writes:

> Hi Vitaly,
>
> First bad commit (maybe != root cause):
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
> head:   d54cfc420586425d418a53871290cc4a59d33501
> commit: cb188e07105f2216f5efbefac95df4b6ce266906 [55/9999] KVM: x86: hyper-v: HVCALL_SEND_IPI_EX is an XMM fast hypercall
> config: i386-buildonly-randconfig-r006-20230708 (https://download.01.org/0day-ci/archive/20230708/202307080326.zDp7E3o0-lkp@intel.com/config)
> compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project.git 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
> reproduce: (https://download.01.org/0day-ci/archive/20230708/202307080326.zDp7E3o0-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202307080326.zDp7E3o0-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>>> arch/x86/kvm/hyperv.c:2185:5: error: stack frame size (1036) exceeds limit (1024) in 'kvm_hv_hypercall' [-Werror,-Wframe-larger-than]
>    int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>        ^
>    1 error generated.

(sorry for delayed reply)

This used to be a warning (without CONFIG_KVM_WERROR I guess?) :-) E.g.

https://lore.kernel.org/kvm/87zgg6sza8.fsf@redhat.com/#t

where Nathan explained LLVM's behavior:

https://lore.kernel.org/kvm/Yvp87jlVWg0e376v@dev-arch.thelio-3990X/

This was 'fixed' upstream with

commit 7d5e88d301f84a7b64602dbe3640f288223095ea
Author: Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Tue Nov 1 15:53:56 2022 +0100

    KVM: x86: hyper-v: Use preallocated buffer in 'struct kvm_vcpu_hv' instead of on-stack 'sparse_banks'
  
and personally, I'm not against backporting it to 5.15.y but I seriously
doubt it is worth the hassle (i386 KVM + llvm + CONFIG_KVM_WERROR is
likely an impossible combo).

Also, there seems to be another build problem with CONFIG_KVM_WERROR I
met with clan-16 and the same config:

../arch/x86/kvm/x86.c:2315:19: error: unused function 'gtod_is_based_on_tsc' [-Werror,-Wunused-function]
static inline int gtod_is_based_on_tsc(int mode)

TL;DR: Let's ignore this for 5.15, not worth fixing IMO. Cc: kvm@ to
check if anyone thinks differently.

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

