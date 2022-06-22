Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817F35540A4
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 04:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355742AbiFVCrl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 22:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbiFVCrl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 22:47:41 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D4A2DA89
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 19:47:39 -0700 (PDT)
Received: from fsav111.sakura.ne.jp (fsav111.sakura.ne.jp [27.133.134.238])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 25M2kwYq093430;
        Wed, 22 Jun 2022 11:46:58 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav111.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav111.sakura.ne.jp);
 Wed, 22 Jun 2022 11:46:58 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav111.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 25M2kvA7093422
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 22 Jun 2022 11:46:58 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <e3a1a213-ea9f-dbd8-93be-74e927794090@I-love.SAKURA.ne.jp>
Date:   Wed, 22 Jun 2022 11:46:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: WARNING in kvm_arch_vcpu_ioctl_run (3)
Content-Language: en-US
To:     syzbot <syzbot+760a73552f47a8cd0fd9@syzkaller.appspotmail.com>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>,
        syzkaller-bugs@googlegroups.com
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Wanpeng Li <kernellwp@gmail.com>
References: <000000000000d05a78056873bc47@google.com>
 <CANRm+Cz9GEhgc_Na3E8DqYBccPTimybeu+idP1hDJSk4jni7ag@mail.gmail.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <CANRm+Cz9GEhgc_Na3E8DqYBccPTimybeu+idP1hDJSk4jni7ag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2018/03/28 16:29, Wanpeng Li wrote:
>> syzbot dashboard link:
>> https://syzkaller.appspot.com/bug?extid=760a73552f47a8cd0fd9
>>
> Maybe the same as this one. https://lkml.org/lkml/2018/3/21/174 Paolo,
> any idea against my analysis?

No progress for 4 years. Did somebody check Wanpeng's analysis ?

Since I'm not familiar with KVM, my questions from different direction...



syzbot is hitting WARN_ON(vcpu->arch.pio.count || vcpu->mmio_needed) added by
commit 716d51abff06f484 ("KVM: Provide userspace IO exit completion callback")
due to vcpu->mmio_needed == true.

Question 1: what is the intent of checking for vcpu->mmio_needed == false?



If we run a reproducer provided by syzbot, we can observe that mutex_unlock(&vcpu->mutex)
in kvm_vcpu_ioctl() is called with vcpu->mmio_needed == true.

Question 2: Is kvm_vcpu_ioctl() supposed to leave with vcpu->mmio_needed == false?
In other words, is doing

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4104,6 +4104,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = kvm_arch_vcpu_ioctl(filp, ioctl, arg);
 	}
 out:
+	WARN_ON_ONCE(vcpu->mmio_needed);
 	mutex_unlock(&vcpu->mutex);
 	kfree(fpu);
 	kfree(kvm_sregs);

appropriate?
