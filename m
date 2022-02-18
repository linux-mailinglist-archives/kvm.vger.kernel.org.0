Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343544BBDE2
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 17:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236722AbiBRQ6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 11:58:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbiBRQ6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 11:58:39 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C66B26B7A4
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 08:58:23 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id d9-20020a17090a498900b001b8bb1d00e7so9060071pjh.3
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 08:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IktHu5iN5JmjOfLB1UGUCckxpS+Vy4U9FOJp53Urqvs=;
        b=dlF+yoegUj4oGGAbg6LQmwO98lpn3qy11LCBk+zYzd4+rgiFn3VQxq0u5ajuy/Zbiq
         GS8kHYvtOIjvdIdey3Qvt4VIeVAJay4pikewHsbB8VEU9jejEn5LtoHfFVwdHgXheo3F
         xXWySYGd4skxwWGA96mb6JCXDOQdI7x/yynyCOg5d/F45lOL8/f2mS21oa29d2YGm6Nk
         Dx9MeNtVbdNONahK5G/iguk6OzlATrl8wREhSqILunGDuNPtsu1BFK7ZM76WL6XhmDPm
         4+jE2OoyAg478ERp70Kazu1tX7jGcnQtiLvB2wQGEXiBqN9ZQmuR/nm/H+PQDHKZaN12
         MalA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IktHu5iN5JmjOfLB1UGUCckxpS+Vy4U9FOJp53Urqvs=;
        b=i8WJM/ayZLZrMjJ/E5ftjb+hlluaz+m9lL/pjY33KoVUiXcUo3f7K45ewkQ3by5yuf
         6+0qYZx26j+tby3q6+RcV8IRtwKxPFEe1DOSaf7Lhff4kkwOYfgsOqS25mzb8vOz9Ovf
         d+phvnlgNyLJ/768Feh27T0MR6k0xlXl0gYe7KKoSCs2mgoM6dEvX5GpQ/NQ2npmpjCR
         5yBO/ScVFjBHd/75oGHtqnKdF9WfNgWyhuIlTIZ1T7tUKkljN2OofztIK6R4xPb+yjBP
         q4IMhidUxvrqqhAcMvuNFDmJpQ2f118k2hQetd8qVhS+aYh2Lg9Y0uewjWx0tUoCXUBP
         z8SA==
X-Gm-Message-State: AOAM531wqSs90k6E98/+AvPez4fpvO3ZY4MuEKO7PFwcS6J95oemZIXv
        2kWz8GXk2y9OkLHYawFTehAtGA==
X-Google-Smtp-Source: ABdhPJyKnWMWiokAkNm0fSnEfEJFQzKdKWZPkfvuEnkfpb3TbxH33lbgGyccpfVAvuBm/H6etwyWqw==
X-Received: by 2002:a17:90a:fd10:b0:1bb:8ad7:b351 with SMTP id cv16-20020a17090afd1000b001bb8ad7b351mr13577169pjb.208.1645203502332;
        Fri, 18 Feb 2022 08:58:22 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d8sm3883727pfv.84.2022.02.18.08.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 08:58:21 -0800 (PST)
Date:   Fri, 18 Feb 2022 16:58:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+8112db3ab20e70d50c31@syzkaller.appspotmail.com
Subject: Re: [PATCH] KVM: x86: Forcibly leave nested virt when SMM state is
 toggled
Message-ID: <Yg/QKgxotNyZbYAI@google.com>
References: <20220125220358.2091737-1-seanjc@google.com>
 <db8a9edd-533e-3502-aed1-e084d6b55e48@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db8a9edd-533e-3502-aed1-e084d6b55e48@linaro.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 17, 2022, Tadeusz Struk wrote:
> On 1/25/22 14:03, Sean Christopherson wrote:
> > Forcibly leave nested virtualization operation if userspace toggles SMM
> > state via KVM_SET_VCPU_EVENTS or KVM_SYNC_X86_EVENTS.  If userspace
> > forces the vCPU out of SMM while it's post-VMXON and then injects an SMI,
> > vmx_enter_smm() will overwrite vmx->nested.smm.vmxon and end up with both
> > vmxon=false and smm.vmxon=false, but all other nVMX state allocated.
> > 
> > Don't attempt to gracefully handle the transition as (a) most transitions
> > are nonsencial, e.g. forcing SMM while L2 is running, (b) there isn't
> > sufficient information to handle all transitions, e.g. SVM wants access
> > to the SMRAM save state, and (c) KVM_SET_VCPU_EVENTS must precede
> > KVM_SET_NESTED_STATE during state restore as the latter disallows putting
> > the vCPU into L2 if SMM is active, and disallows tagging the vCPU as
> > being post-VMXON in SMM if SMM is not active.
> > 
> > Abuse of KVM_SET_VCPU_EVENTS manifests as a WARN and memory leak in nVMX
> > due to failure to free vmcs01's shadow VMCS, but the bug goes far beyond
> > just a memory leak, e.g. toggling SMM on while L2 is active puts the vCPU
> > in an architecturally impossible state.
> > 
> >    WARNING: CPU: 0 PID: 3606 at free_loaded_vmcs arch/x86/kvm/vmx/vmx.c:2665 [inline]
> >    WARNING: CPU: 0 PID: 3606 at free_loaded_vmcs+0x158/0x1a0 arch/x86/kvm/vmx/vmx.c:2656
> >    Modules linked in:
> >    CPU: 1 PID: 3606 Comm: syz-executor725 Not tainted 5.17.0-rc1-syzkaller #0
> >    Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> >    RIP: 0010:free_loaded_vmcs arch/x86/kvm/vmx/vmx.c:2665 [inline]
> >    RIP: 0010:free_loaded_vmcs+0x158/0x1a0 arch/x86/kvm/vmx/vmx.c:2656
> >    Code: <0f> 0b eb b3 e8 8f 4d 9f 00 e9 f7 fe ff ff 48 89 df e8 92 4d 9f 00
> >    Call Trace:
> >     <TASK>
> >     kvm_arch_vcpu_destroy+0x72/0x2f0 arch/x86/kvm/x86.c:11123
> >     kvm_vcpu_destroy arch/x86/kvm/../../../virt/kvm/kvm_main.c:441 [inline]
> >     kvm_destroy_vcpus+0x11f/0x290 arch/x86/kvm/../../../virt/kvm/kvm_main.c:460
> >     kvm_free_vcpus arch/x86/kvm/x86.c:11564 [inline]
> >     kvm_arch_destroy_vm+0x2e8/0x470 arch/x86/kvm/x86.c:11676
> >     kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1217 [inline]
> >     kvm_put_kvm+0x4fa/0xb00 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1250
> >     kvm_vm_release+0x3f/0x50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1273
> >     __fput+0x286/0x9f0 fs/file_table.c:311
> >     task_work_run+0xdd/0x1a0 kernel/task_work.c:164
> >     exit_task_work include/linux/task_work.h:32 [inline]
> >     do_exit+0xb29/0x2a30 kernel/exit.c:806
> >     do_group_exit+0xd2/0x2f0 kernel/exit.c:935
> >     get_signal+0x4b0/0x28c0 kernel/signal.c:2862
> >     arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
> >     handle_signal_work kernel/entry/common.c:148 [inline]
> >     exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
> >     exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
> >     __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
> >     syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
> >     do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
> >     entry_SYSCALL_64_after_hwframe+0x44/0xae
> >     </TASK>
> > 
> > Cc: stable@vger.kernel.org
> > Reported-by: syzbot+8112db3ab20e70d50c31@syzkaller.appspotmail.com
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> Sean,
> I can reliably reproduce my original issue [1] that this supposed to fix
> on 5.17-rc4, with the same reproducer [2]. Here is a screen dump [3].
> Maybe we do still need my patch. It fixed the issue.

This SMM-specific patch fixes something different, the bug that you are still
hitting is the FNAME(cmpxchg_gpte) mess.  The uaccess CMPXCHG series[*] that
properly fixes that issue hasn't been merged yet.

  ==================================================================
  BUG: KASAN: use-after-free in ept_cmpxchg_gpte.constprop.0+0x3c3/0x590
  Write of size 8 at addr ffff888010000000 by task repro/5633

[*] https://lore.kernel.org/all/20220202004945.2540433-1-seanjc@google.com

> 
> [1] https://lore.kernel.org/all/3789ab35-6ede-34e8-b2d0-f50f4e0f1f15@linaro.org/
> [2] https://syzkaller.appspot.com/text?tag=ReproC&x=173085bdb00000
> [3] https://termbin.com/fkm8f
> 
> -- 
> Thanks,
> Tadeusz
