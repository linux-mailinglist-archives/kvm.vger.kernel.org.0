Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970A84B39CF
	for <lists+kvm@lfdr.de>; Sun, 13 Feb 2022 07:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbiBMGDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Feb 2022 01:03:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233868AbiBMGDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Feb 2022 01:03:20 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2587F5E778;
        Sat, 12 Feb 2022 22:03:14 -0800 (PST)
Received: from [192.168.0.2] (ip5f5aebcd.dynamic.kabel-deutschland.de [95.90.235.205])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 05C8D61E64846;
        Sun, 13 Feb 2022 07:03:11 +0100 (CET)
Message-ID: <d3e6a461-5b37-ecfb-d63c-d35af27f2682@molgen.mpg.de>
Date:   Sun, 13 Feb 2022 07:03:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        rcu@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Zhouyi Zhou <zhouzhouyi@gmail.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Set environment variable `KVM` makes build fail
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Linux folks,


Playing with rcutorture 
(`tools/testing/selftests/rcutorture/bin/torture.sh`), a Linux kernel 
build failed, because the script sets and exports the environment 
variable `KVM`. I was able to reproduce that manually (on x86_64):

     $ make defconfig
     $ scripts/config -m KVM
     $ scripts/config -m KVM_INTEL
     $ scripts/config -d KVM_AMD
     $ scripts/config -d KVM_XEN
     $ scripts/config -d KVM_MMU_AUDIT
     $ export KVM=XXX
     $ make arch/x86/kvm/kvm.o
     […]
       LINK    /dev/shm/linux-kvm/tools/objtool/objtool
     make[2]: *** No rule to make target 'arch/x86/kvm/XXX/kvm_main.o', 
needed by 'arch/x86/kvm/kvm.o'.  Stop.
     make[1]: *** [scripts/Makefile.build:550: arch/x86/kvm] Error 2
     make: *** [Makefile:1831: arch/x86] Error 2

The directory `arch/x86/kvm/XXX` is created somehow.

Is that expected? Do you know what is going on? I wasn’t able to 
reproduce this with other variables like `SND_HDA` for example.


Kind regards,

Paul
