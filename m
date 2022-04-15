Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 731B1501FE8
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 03:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348305AbiDOBIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 21:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbiDOBII (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 21:08:08 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D12C517C3
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 18:05:42 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id v13so1891184ljg.10
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 18:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i1kEshpY+bfjAzJd2dch21w3U6ODPPX0HvCQv7/rIUk=;
        b=sqtDaPZ6m+iNPTZ6XSqpfdLXxS2nCVLNgM2n5ShWRZ18eJAyu4Gm1LG3kqhMRSbH7C
         faTTzEtyYDi4m+GC9jA3TqDO3uOUqGOxhmCgWEP+SMYuUb/2YXL5b92J5X1eV24Vc9Ll
         uw05Om3PGdeBUA2B2eatuj8Jkf0Sv1/gyR3OkqW8wHgKsD/CI1gRqZ+nV4yPwcN7LqiY
         aQT8ldiFBD/0JMPXBXjbD1oiT/fS2WrkMAy4X7IcKs5JkroNgEAnu7CyA5sKZyTHzlNq
         b/QhSZdegQSz8hH8nd11CkhcIr97jBzxZK/hWrtCrZneXHeGMEKWTObXOTkNOowFu90B
         bf/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i1kEshpY+bfjAzJd2dch21w3U6ODPPX0HvCQv7/rIUk=;
        b=MmKj82Xc1DHvMqjXgF1lCScMNZMCLdpk4Yr1QOv5CrjfLXokO65mgkYm3rH0FJFJZn
         xBc0dv4pDHRo4kNjmDepzBSDZvEiKRU3N22kC6Y1ckmbXcQx3ax3Oyp7jJ0wkSYQ7hkC
         tKb6s8q068Q9IicJdPfNJWsz+c4JK5VeECLRVmPe5xInPkc042tCvBkcEg76SfsTcbKn
         fLJkmLAwJcWvRPBaFE1ksbUoBBiRsMg+rek0Tz6MGKUkQi6DVm34fMDsxzprLK+lTPJc
         0q97JyM3dDZUB7bAaDmfENltpcTAVBe3NuHlZml3CTVhstE4qhlQp69GwVTAWv9mnjk5
         wQeA==
X-Gm-Message-State: AOAM532ar8SDv3MdEgdYE/tO0h0yE3L4pVmRzrabQviLDGHmPKzYMTDd
        wKSogoAWxQacWTl2zDYWCpiR2QGnp4M/+uBOCia0pA==
X-Google-Smtp-Source: ABdhPJxscLs6pF0Pobvqg1a3s++W1ujj8WRkTyvPp3v1CS/+Ifff1wZevtstChTAVVZn/YlvmG2aG70wtnhqBOvHE08=
X-Received: by 2002:a2e:5cc1:0:b0:24b:112f:9b36 with SMTP id
 q184-20020a2e5cc1000000b0024b112f9b36mr3094520ljb.337.1649984740135; Thu, 14
 Apr 2022 18:05:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220415004622.2207751-1-seanjc@google.com>
In-Reply-To: <20220415004622.2207751-1-seanjc@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 14 Apr 2022 18:05:29 -0700
Message-ID: <CAOQ_QsgxyM2SQNuaWaoPD8pj5Mwk0bt15TS=i7=Yc1OFG=fdAQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: Initialize debugfs_dentry when a VM is created to
 avoid NULL deref
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        syzbot+df6fbbd2ee39f21289ef@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
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

Hi Sean,

On Thu, Apr 14, 2022 at 5:46 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Initialize debugfs_entry to its semi-magical -ENOENT value when the VM
> is created.  KVM's teardown when VM creation fails is kludgy and calls
> kvm_uevent_notify_change() and kvm_destroy_vm_debugfs() even if KVM never
> attempted kvm_create_vm_debugfs().  Because debugfs_entry is zero

Boo! I've got a few patches to bring kvm_create_vm_debugfs() in line
with the rest of the VM initialization. Kinda gross it is done in the
ioctl body.

> initialized, the IS_ERR() checks pass and KVM derefs a NULL pointer.
>
>   BUG: kernel NULL pointer dereference, address: 0000000000000018
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 1068b1067 P4D 1068b1067 PUD 1068b0067 PMD 0
>   Oops: 0000 [#1] SMP
>   CPU: 0 PID: 871 Comm: repro Not tainted 5.18.0-rc1+ #825
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>   RIP: 0010:__dentry_path+0x7b/0x130
>   Call Trace:
>    <TASK>
>    dentry_path_raw+0x42/0x70
>    kvm_uevent_notify_change.part.0+0x10c/0x200 [kvm]
>    kvm_put_kvm+0x63/0x2b0 [kvm]
>    kvm_dev_ioctl+0x43a/0x920 [kvm]
>    __x64_sys_ioctl+0x83/0xb0
>    do_syscall_64+0x31/0x50
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>    </TASK>
>   Modules linked in: kvm_intel kvm irqbypass
>
> Fixes: a44a4cc1c969 ("KVM: Don't create VM debugfs files outside of the VM directory")
> Cc: stable@vger.kernel.org
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oupton@google.com>
> Reported-by: syzbot+df6fbbd2ee39f21289ef@syzkaller.appspotmail.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Looks good, grats to the bots for finding my dirty laundry.

Reviewed-by: Oliver Upton <oupton@google.com>
