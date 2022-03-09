Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8784B4D2D1A
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 11:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiCIK3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 05:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiCIK3C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 05:29:02 -0500
X-Greylist: delayed 24101 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Mar 2022 02:28:02 PST
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF8839BB5
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 02:28:02 -0800 (PST)
Received: from mse-fl2.zte.com.cn (unknown [10.30.14.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4KD7gj09JNz7jZwY;
        Wed,  9 Mar 2022 18:28:01 +0800 (CST)
Received: from szxlzmapp01.zte.com.cn ([10.5.231.85])
        by mse-fl2.zte.com.cn with SMTP id 229ARuqL046075;
        Wed, 9 Mar 2022 18:27:56 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from mapi (szxlzmapp07[null])
        by mapi (Zmail) with MAPI id mid14;
        Wed, 9 Mar 2022 18:27:56 +0800 (CST)
Date:   Wed, 9 Mar 2022 18:27:56 +0800 (CST)
X-Zmail-TransId: 2b096228812c90d01bcd
X-Mailer: Zmail v1.0
Message-ID: <202203091827565144689@zte.com.cn>
In-Reply-To: <2bd92846-381b-f083-754a-89dfcdccc90c@redhat.com>
References: 20220309113025.44469-1-wang.yi59@zte.com.cn,2bd92846-381b-f083-754a-89dfcdccc90c@redhat.com
Mime-Version: 1.0
From:   <wang.yi59@zte.com.cn>
To:     <pbonzini@redhat.com>
Cc:     <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xue.zhihong@zte.com.cn>, <up2wing@gmail.com>,
        <wang.liang82@zte.com.cn>, <liu.yi24@zte.com.cn>
Subject: =?UTF-8?B?UmU6W1BBVENIXSBLVk06IFNWTTogZml4IHBhbmljIG9uIG91dC1vZi1ib3VuZHMgZ3Vlc3QgSVJR?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 229ARuqL046075
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.138.novalocal with ID 62288131.000 by FangMail milter!
X-FangMail-Envelope: 1646821681/4KD7gj09JNz7jZwY/62288131.000/10.30.14.239/[10.30.14.239]/mse-fl2.zte.com.cn/<wang.yi59@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 62288131.000/4KD7gj09JNz7jZwY
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

> On 3/9/22 12:30, Yi Wang wrote:
> > As guest_irq is coming from KVM_IRQFD API call, it may trigger
> > crash in svm_update_pi_irte() due to out-of-bounds:
> > 
> > crash> bt
> > PID: 22218  TASK: ffff951a6ad74980  CPU: 73  COMMAND: "vcpu8"
> >   #0 [ffffb1ba6707fa40] machine_kexec at ffffffff8565b397
> >   #1 [ffffb1ba6707fa90] __crash_kexec at ffffffff85788a6d
> >   #2 [ffffb1ba6707fb58] crash_kexec at ffffffff8578995d
> >   #3 [ffffb1ba6707fb70] oops_end at ffffffff85623c0d
> >   #4 [ffffb1ba6707fb90] no_context at ffffffff856692c9
> >   #5 [ffffb1ba6707fbf8] exc_page_fault at ffffffff85f95b51
> >   #6 [ffffb1ba6707fc50] asm_exc_page_fault at ffffffff86000ace
> >      [exception RIP: svm_update_pi_irte+227]
> >      RIP: ffffffffc0761b53  RSP: ffffb1ba6707fd08  RFLAGS: 00010086
> >      RAX: ffffb1ba6707fd78  RBX: ffffb1ba66d91000  RCX: 0000000000000001
> >      RDX: 00003c803f63f1c0  RSI: 000000000000019a  RDI: ffffb1ba66db2ab8
> >      RBP: 000000000000019a   R8: 0000000000000040   R9: ffff94ca41b82200
> >      R10: ffffffffffffffcf  R11: 0000000000000001  R12: 0000000000000001
> >      R13: 0000000000000001  R14: ffffffffffffffcf  R15: 000000000000005f
> >      ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> >   #7 [ffffb1ba6707fdb8] kvm_irq_routing_update at ffffffffc09f19a1 [kvm]
> >   #8 [ffffb1ba6707fde0] kvm_set_irq_routing at ffffffffc09f2133 [kvm]
> >   #9 [ffffb1ba6707fe18] kvm_vm_ioctl at ffffffffc09ef544 [kvm]
> > #10 [ffffb1ba6707ff10] __x64_sys_ioctl at ffffffff85935474
> > #11 [ffffb1ba6707ff40] do_syscall_64 at ffffffff85f921d3
> > #12 [ffffb1ba6707ff50] entry_SYSCALL_64_after_hwframe at ffffffff8600007c
> >      RIP: 00007f143c36488b  RSP: 00007f143a4e04b8  RFLAGS: 00000246
> >      RAX: ffffffffffffffda  RBX: 00007f05780041d0  RCX: 00007f143c36488b
> >      RDX: 00007f05780041d0  RSI: 000000004008ae6a  RDI: 0000000000000020
> >      RBP: 00000000000004e8   R8: 0000000000000008   R9: 00007f05780041e0
> >      R10: 00007f0578004560  R11: 0000000000000246  R12: 00000000000004e0
> >      R13: 000000000000001a  R14: 00007f1424001c60  R15: 00007f0578003bc0
> >      ORIG_RAX: 0000000000000010  CS: 0033  SS: 002b
> > 
> > Vmx have been fix this in commit 3a8b0677fc61 (KVM: VMX: Do not BUG() on
> > out-of-bounds guest IRQ), so we can just copy source from that to fix
> > this.
> > 
> > Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
> > Signed-off-by: Yi Liu <liu.yi24@zte.com.cn>
> 
> Hi, the Signed-off-by chain is wrong.  Did Yi Liu write the patch (and 
> you are just sending it)?

The Signed-off-by chain is not wrong, I (Yi Wang) wrote this patch and Yi Liu
co-developed it.

> 
> Paolo
