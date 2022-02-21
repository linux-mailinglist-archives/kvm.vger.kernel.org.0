Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D56E64BD7E1
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 09:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiBUINp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 03:13:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiBUINo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 03:13:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F29911170
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 00:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645431200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=udTdgkV0hKF0Ik5YKs7gxuQZxHb952TIWUJKdta1dcw=;
        b=Hd9qhXgpqaZLaMiHShnz65tRy3eHUmNE9bQOk7YhSexHzlPaVIb8iif8UaBJofn8aSZOgl
        In2f0ISCZuY+uZ7G3WWFOmHMm5If3DdWfoKGiofdKLOosK5g4zjH8VeTj+gmKIw5R1Tk90
        1eY5t1T/54JRrhKIThiKfT4XhTdQk3g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-0UDaWN2sOwWHUZQ7pnN-oA-1; Mon, 21 Feb 2022 03:13:18 -0500
X-MC-Unique: 0UDaWN2sOwWHUZQ7pnN-oA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A78552F4B;
        Mon, 21 Feb 2022 08:13:17 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F9F3105C73C;
        Mon, 21 Feb 2022 08:13:16 +0000 (UTC)
Message-ID: <0a0b61c5c071415f213a4704ebd73e65761ec1a3.camel@redhat.com>
Subject: Re: WARN_ON(!svm->tsc_scaling_enabled)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     =?UTF-8?Q?D=C4=81vis_Mos=C4=81ns?= <davispuh@gmail.com>,
        kvm@vger.kernel.org
Date:   Mon, 21 Feb 2022 10:13:15 +0200
In-Reply-To: <CAOE4rSyvnWW6jcGjTvT3Z+=BtykfUN2A9v7d+qGn2rA_fipkTw@mail.gmail.com>
References: <CAOE4rSyvnWW6jcGjTvT3Z+=BtykfUN2A9v7d+qGn2rA_fipkTw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-02-19 at 05:22 +0200, Dāvis Mosāns wrote:
> Hi,
> 
> I'm using:
> 
> kvm ignore_msrs=1
> kvm_amd nested=1
> 
> invtsc=on
> tsc-deadline=on
> tsc-scale=off
> svm=on
> 
> and my dmesg gets spammed with warnings like every second.
> Also sometimes guest VM freezes when booting.
> 
> 
> if (svm->tsc_ratio_msr != kvm_default_tsc_scaling_ratio) {
>     WARN_ON(!svm->tsc_scaling_enabled);
>     nested_svm_update_tsc_ratio_msr(vcpu);
> }
> 
> WARNING: CPU: 6 PID: 21336 at arch/x86/kvm/svm/nested.c:582
> nested_vmcb02_prepare_control (arch/x86/kvm/svm/nested.c:582
> (discriminator 1)) kvm_amd
> RIP: 0010:nested_vmcb02_prepare_control (arch/x86/kvm/svm/nested.c:582
> (discriminator 1)) kvm_amd
> Call Trace:
>  <TASK>
> enter_svm_guest_mode (arch/x86/kvm/svm/nested.c:480 (discriminator 3)
> arch/x86/kvm/svm/nested.c:491 (discriminator 3)
> arch/x86/kvm/svm/nested.c:647 (discriminator 3)) kvm_amd
> nested_svm_vmrun (arch/x86/kvm/svm/nested.c:726) kvm_amd
> kvm_arch_vcpu_ioctl_run (arch/x86/kvm/x86.c:10243 arch/x86/kvm/x86.c:10449) kvm
> kvm_vcpu_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:3908) kvm
> __x64_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:874 fs/ioctl.c:860 fs/ioctl.c:860)
> do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
> ? kvm_on_user_return (./arch/x86/include/asm/paravirt.h:194
> ./arch/x86/include/asm/paravirt.h:227 arch/x86/kvm/x86.c:370) kvm
> ? fire_user_return_notifiers (kernel/user-return-notifier.c:42
> (discriminator 11))
> ? exit_to_user_mode_prepare (./arch/x86/include/asm/entry-common.h:53
> kernel/entry/common.c:209)
> ? syscall_exit_to_user_mode (./arch/x86/include/asm/jump_label.h:55
> ./arch/x86/include/asm/nospec-branch.h:302
> ./arch/x86/include/asm/entry-common.h:94 kernel/entry/common.c:131
> kernel/entry/common.c:302)
> ? do_syscall_64 (arch/x86/entry/common.c:87)
> 
> Maybe this warning is wrong?

The warning is not wrong. The svm->tsc_ratio_msr is the nested TSC scale ratio,
which should never have non default value if you don't exposed TSC scaling to the guest.

What I think is happening though is that svm_set_msr does allow to set MSR_AMD64_TSC_RATIO even if
the guest cpuid doesn't support TSC scaling if the write comes from the  host (that is qemu).

On qemu side I see that when guest tsc scaling is disabled, MSR_AMD64_TSC_RATIO ends up beeing
0, and still uploaded to KVM, which I think triggers this warning.

So the warning should IMHO be removed, but also the code should be changed to ignore
the value of the MSR_AMD64_TSC_RATIO when the nested tsc scaling is disabled.

I'll send a patch to fix this soon.

Best regards,
	Maxim Levitsky

> 
> Best regards,
> Dāvis
> 


