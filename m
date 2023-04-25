Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8C16EDE5B
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 10:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbjDYIli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 04:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbjDYIlK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 04:41:10 -0400
Received: from out-39.mta1.migadu.com (out-39.mta1.migadu.com [95.215.58.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4CB146CC
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 01:38:58 -0700 (PDT)
Date:   Tue, 25 Apr 2023 10:38:10 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682411897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xYq7TmbvdNQ3HLBoWC5d8iyDLFK/F41KmKqUpMgTt4U=;
        b=JLUnaR1ovZa5YYyiN2KWTIDel48gVulI9d5qygCevKBgsTQw6j0ciibVMs5zUTMk1iK/RJ
        byEV8ySIKFWyRUK5Ha2D/vDv600KlirhFy4mn+HVURvrrfGhle6oe8QMveM+c4lJ/a9lQb
        fzcrO8RDEz3iuviez/RO326v+oF+us4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     =?utf-8?B?5Lu75pWP5pWPKOiBlOmAmumbhuWbouiBlOmAmuaVsOWtl+enkeaKgOaciQ==?=
         =?utf-8?B?6ZmQ5YWs5Y+45pys6YOoKQ==?= <renmm6@chinaunicom.cn>
Cc:     kvm <kvm@vger.kernel.org>, rmm1985 <rmm1985@163.com>,
        bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] arch-run: Fix run_qemu return correct
 error code
Message-ID: <27vn2dxrikahvhw7bw4d77jnhlqpt724j6xjpqi6adqbi7hoct@p74pzrweypkn>
References: <hzn5rocplnouiuemnxnvznhvvqbvwepqggymgevfwiqal24zt7@62nemxepzzqo>
 <20230424095816.3022644-1-renmm6@chinaunicom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230424095816.3022644-1-renmm6@chinaunicom.cn>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 24, 2023 at 05:58:16PM +0800, 任敏敏(联通集团联通数字科技有限公司本部) wrote:
> >On Sun, Apr 23, 2023 at 12:34:36PM +0800, 任敏敏(联通集团联通数字科技有限公司本部) wrote:
> >> From: rminmin <renmm6@chinaunicom.cn>
> >>
> >> run_qemu should return 0 if logs doesn't
> >> contain "warning" keyword.
> >
> >Why? What are you trying to fix?
> >
> 
> I encountered a problem that the differet results when I run the same
> test case using standalone mode, "run_test.sh -t -g", "run_test.sh -g".
> When I use "run_test.sh -g", it always returns a FAIL message.
> In my env, qemu version is 6.2.
> 
> e.g. runnig debug test cases.
> 
> # without "-t"
> ./run_tests.sh -g debug
> FAIL debug (22 tests)
> 
> # "-t"
> ./run_tests.sh -t -g debug
> TAP version 13
> ok 1 - debug: DR4==DR6 with CR4.DE == 0
> ok 2 - debug: DR4 read got #UD with CR4.DE == 1
> ok 3 - debug: #BP
> ok 4 - debug: hw breakpoint (test that dr6.BS is not set)
> ok 5 - debug: hw breakpoint (test that dr6.BS is not cleared)
> ok 6 - debug: Single-step #DB basic test
> ok 7 - debug: Usermode Single-step #DB basic test
> ok 8 - debug: Single-step #DB on emulated instructions
> ok 9 - debug: Usermode Single-step #DB on emulated instructions
> ok 10 - debug: Single-step #DB w/ STI blocking
> ok 11 - debug: Usermode Single-step #DB w/ STI blocking
> ok 12 - debug: Single-step #DB w/ MOVSS blocking
> ok 13 - debug: Usermode Single-step #DB w/ MOVSS blocking
> ok 14 - debug: Single-Step + ICEBP #DB w/ MOVSS blocking
> ok 15 - debug: Usermode Single-Step + ICEBP #DB w/ MOVSS blocking
> ok 16 - debug: Single-step #DB w/ MOVSS blocking and DR7.GD=1
> ok 17 - debug: hw watchpoint (test that dr6.BS is not cleared)
> ok 18 - debug: hw watchpoint (test that dr6.BS is not set)
> ok 19 - debug: icebp
> ok 20 - debug: MOV SS + watchpoint + ICEBP
> ok 21 - debug: MOV SS + watchpoint + int $1
> ok 22 - debug: MOV SS + watchpoint + INT3
> 1..22
> 
> # standalone
> 
> tests/debug
> BUILD_HEAD=02d8befe
> timeout -k 1s --foreground 90s /usr/bin/qemu-kvm --no-reboot -nodefaults -device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device pci-testdev -machine accel=kvm -kernel /tmp/tmp.1GdMZXhTTs -smp 1 # -initrd /tmp/tmp.LzHnmXchfO
> configure accelerator pc-i440fx-6.2 start
> machine init start
> device init start
> add qdev pc-testdev:none success
> add qdev pc-testdev:none success
> add qdev isa-debug-exit:none success
> add qdev isa-debug-exit:none success
> add qdev pci-testdev:none success
> add qdev pci-testdev:none success
> reset all devices
> qmp cont is received and vm is started
> qemu enter main_loop

All the above messages are debug messages that QEMU doesn't output. So
you're running your own QEMU build with extra messages which
kvm-unit-tests has to assume are errors.

Please don't try to debug test frameworks without using known-good
software-under-test.

It also appears you modified kvm-unit-tests, because there is no 'debug'
group.

Thanks,
drew
