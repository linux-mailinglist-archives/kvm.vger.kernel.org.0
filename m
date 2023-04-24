Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFB5D6EC9A0
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 11:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbjDXJ7Q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 24 Apr 2023 05:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbjDXJ7P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 05:59:15 -0400
Received: from senda.mailex.chinaunicom.cn (senda.mailex.chinaunicom.cn [123.138.59.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36749196
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 02:59:11 -0700 (PDT)
Received: from M10-XA-MLCEN01.MailSrv.cnc.intra (unknown [10.236.3.197])
        by senda.mailex.chinaunicom.cn (SkyGuard) with ESMTPS id 4Q4gcm0NXmz6RC5v
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 18:00:56 +0800 (CST)
Received: from smtpbg.qq.com (10.237.2.96) by M10-XA-MLCEN01.MailSrv.cnc.intra
 (10.236.3.197) with Microsoft SMTP Server id 15.0.1497.47; Mon, 24 Apr 2023
 17:59:02 +0800
X-QQ-mid: Ymail-xx24b003-t1682330340tol
Received: from localhost.localdomain (unknown [10.3.224.193])
        by smtp.qq.com (ESMTP) with 
        id ; Mon, 24 Apr 2023 17:58:59 +0800 (CST)
X-QQ-SSF: 0090000000000040I520050A0000000
X-QQ-GoodBg: 0
From:   =?gb18030?B?yM7D9MP0KMGqzai8r83FwarNqMr919a/xry809A=?=
         =?gb18030?B?z965q8u+sb6yvyk=?= <renmm6@chinaunicom.cn>
To:     =?gb18030?B?a3Zt?= <kvm@vger.kernel.org>
CC:     =?gb18030?B?cm1tMTk4NQ==?= <rmm1985@163.com>,
        =?gb18030?B?ZHJqb25lcw==?= <drjones@redhat.com>,
        =?gb18030?B?cGJvbnppbmk=?= <pbonzini@redhat.com>,
        =?gb18030?B?cmtyY21hcg==?= <rkrcmar@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] arch-run: Fix run_qemu return correct error code
Date:   Mon, 24 Apr 2023 17:58:16 +0800
Message-ID: <20230424095816.3022644-1-renmm6@chinaunicom.cn>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <hzn5rocplnouiuemnxnvznhvvqbvwepqggymgevfwiqal24zt7@62nemxepzzqo>
References: <hzn5rocplnouiuemnxnvznhvvqbvwepqggymgevfwiqal24zt7@62nemxepzzqo>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-QQ-SENDSIZE: 520
Feedback-ID: Ymail-xx:chinaunicom.cn:mail-xx:mail-xx24b003-zhyw44w
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>On Sun, Apr 23, 2023 at 12:34:36PM +0800, 任敏敏(联通集团联通数字科技有限公司本部) wrote:
>> From: rminmin <renmm6@chinaunicom.cn>
>>
>> run_qemu should return 0 if logs doesn't
>> contain "warning" keyword.
>
>Why? What are you trying to fix?
>

I encountered a problem that the differet results when I run the same
test case using standalone mode, "run_test.sh -t -g", "run_test.sh -g".
When I use "run_test.sh -g", it always returns a FAIL message.
In my env, qemu version is 6.2.

e.g. runnig debug test cases.

# without "-t"
./run_tests.sh -g debug
FAIL debug (22 tests)

# "-t"
./run_tests.sh -t -g debug
TAP version 13
ok 1 - debug: DR4==DR6 with CR4.DE == 0
ok 2 - debug: DR4 read got #UD with CR4.DE == 1
ok 3 - debug: #BP
ok 4 - debug: hw breakpoint (test that dr6.BS is not set)
ok 5 - debug: hw breakpoint (test that dr6.BS is not cleared)
ok 6 - debug: Single-step #DB basic test
ok 7 - debug: Usermode Single-step #DB basic test
ok 8 - debug: Single-step #DB on emulated instructions
ok 9 - debug: Usermode Single-step #DB on emulated instructions
ok 10 - debug: Single-step #DB w/ STI blocking
ok 11 - debug: Usermode Single-step #DB w/ STI blocking
ok 12 - debug: Single-step #DB w/ MOVSS blocking
ok 13 - debug: Usermode Single-step #DB w/ MOVSS blocking
ok 14 - debug: Single-Step + ICEBP #DB w/ MOVSS blocking
ok 15 - debug: Usermode Single-Step + ICEBP #DB w/ MOVSS blocking
ok 16 - debug: Single-step #DB w/ MOVSS blocking and DR7.GD=1
ok 17 - debug: hw watchpoint (test that dr6.BS is not cleared)
ok 18 - debug: hw watchpoint (test that dr6.BS is not set)
ok 19 - debug: icebp
ok 20 - debug: MOV SS + watchpoint + ICEBP
ok 21 - debug: MOV SS + watchpoint + int $1
ok 22 - debug: MOV SS + watchpoint + INT3
1..22

# standalone

tests/debug
BUILD_HEAD=02d8befe
timeout -k 1s --foreground 90s /usr/bin/qemu-kvm --no-reboot -nodefaults -device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device pci-testdev -machine accel=kvm -kernel /tmp/tmp.1GdMZXhTTs -smp 1 # -initrd /tmp/tmp.LzHnmXchfO
configure accelerator pc-i440fx-6.2 start
machine init start
device init start
add qdev pc-testdev:none success
add qdev pc-testdev:none success
add qdev isa-debug-exit:none success
add qdev isa-debug-exit:none success
add qdev pci-testdev:none success
add qdev pci-testdev:none success
reset all devices
qmp cont is received and vm is started
qemu enter main_loop
enabling apic
smp: waiting for 0 APs
PASS: DR4==DR6 with CR4.DE == 0
PASS: DR4 read got #UD with CR4.DE == 1
PASS: #BP
PASS: hw breakpoint (test that dr6.BS is not set)
PASS: hw breakpoint (test that dr6.BS is not cleared)
PASS: Single-step #DB basic test
PASS: Usermode Single-step #DB basic test
PASS: Single-step #DB on emulated instructions
PASS: Usermode Single-step #DB on emulated instructions
PASS: Single-step #DB w/ STI blocking
PASS: Usermode Single-step #DB w/ STI blocking
PASS: Single-step #DB w/ MOVSS blocking
PASS: Usermode Single-step #DB w/ MOVSS blocking
PASS: Single-Step + ICEBP #DB w/ MOVSS blocking
PASS: Usermode Single-Step + ICEBP #DB w/ MOVSS blocking
PASS: Single-step #DB w/ MOVSS blocking and DR7.GD=1
PASS: hw watchpoint (test that dr6.BS is not cleared)
PASS: hw watchpoint (test that dr6.BS is not set)
PASS: icebp
PASS: MOV SS + watchpoint + ICEBP
PASS: MOV SS + watchpoint + int $1
PASS: MOV SS + watchpoint + INT3
SUMMARY: 22 tests
FAIL debug (22 tests)


>>
>> Fixes: b2a2aa5d ("arch-run: reduce return code ambiguity")
>> Signed-off-by: rminmin <renmm6@chinaunicom.cn>
>> ---
>>  scripts/arch-run.bash | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
>> index 51e4b97..9878d32 100644
>> --- a/scripts/arch-run.bash
>> +++ b/scripts/arch-run.bash
>> @@ -61,7 +61,7 @@ run_qemu ()
>>                 # Even when ret==1 (unittest success) if we also got stderr
>>                 # logs, then we assume a QEMU failure. Otherwise we translate
>>                 # status of 1 to 0 (SUCCESS)
>> -               if [ -z "$(echo "$errors" | grep -vi warning)" ]; then
>> +               if [ -z "$(echo "$errors" | grep -i warning)" ]; then
>
>This will now filter out all the errors, leaving only warnings or nothing.
>If you want the check to include warnings, then it should be
>
> if [ -z "$(echo "$errors")" ]
>

I found the root case is that "$(echo "$errors" | grep -vi warning)"
is always not zero, because the $errors include qemu log(
configure accelerator pc-i440fx-6.2 start .......) without any
errors or warning keywords.

Did I misunderstand something or miss some information?

>>                         ret=0
>>                 fi
>>         fi
>> --
>> 2.33.0
>>
>
>Thanks,
>drew

如果您错误接收了该邮件，请通过电子邮件立即通知我们。请回复邮件到 hqs-spmc@chinaunicom.cn，即可以退订此邮件。我们将立即将您的信息从我们的发送目录中删除。 If you have received this email in error please notify us immediately by e-mail. Please reply to hqs-spmc@chinaunicom.cn ,you can unsubscribe from this mail. We will immediately remove your information from send catalogue of our.
