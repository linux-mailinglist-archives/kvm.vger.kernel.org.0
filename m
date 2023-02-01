Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA1268710F
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 23:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbjBAWjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 17:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjBAWjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 17:39:16 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB16025E39
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 14:39:13 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id e69-20020a253748000000b00845f15be258so3714078yba.9
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 14:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VfjIQrCZKH7ipWOhIHgNB+L4oWQlrAmV0rH/utG3vBk=;
        b=boXv4vPWJe22L/kH6A1SvNazwAqD9IFi3cC/pDgFCVG6zpzlo41Zz/eXFBZFLoEQSi
         Oa4vyEum/kwwhvwiZMuxExhEaq8tHYCcekaz12DWHJ/GEiW2nEC0FJAgYWDi+WMnPo/a
         PXEzenOR0uB4PrqyVlhS75mljuT6ttHEaU66Eqo6mqmqSCktQ89bkWZaAoc9stIc8rMy
         NsakNl5Yia303OTiJMZp1FXiLI0YHRsSKVnvu17WjTWdZ6oETfN19BAXt6Ndtkj3zinY
         Vx2GvGdu/jKkT3JsVZrHcqZ1YZIJ5mW4wkUUpTcKjAQThNejzfhxUQbMmvMR+t29Yd/L
         4GdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VfjIQrCZKH7ipWOhIHgNB+L4oWQlrAmV0rH/utG3vBk=;
        b=Pj83lVlOkwC480bX0XyryP+qioEJcbEdyFdGTnU+TCsaEa8qEbO7jEf7L3jdinep9s
         NFNtU0G6Lb/E8Q2YZjBYgH3AHCUYsLuCwfWFi3QnEDNfsc1UUsWO6ZAzd0pkcajunzok
         zDDmHWX9XfIGWezp9dQPEHb8uDYwoBZr0r/JZD2DCdIR3530FJvfP/Uum81UXUzFvQi5
         bhpdEKbu02TixuWyir3DKhSSa2BTCHvD9Xf5+693xFLIi/USVEkQxJwmLT7gJ4j00t53
         2sQZsu9s+F7QtDeWbLuN4v0vj+ZV/2FcEBT9WF3CXdZPUAz2Fl2HV3C4GvpgjFuqwFxR
         ynoQ==
X-Gm-Message-State: AO0yUKXTWPRl8sZlg4t5cx5nNA/jVArPaKWhhT34skDQoI5SwP+VaLTQ
        HG/NySXqOxHTQmyRs/0ncczG0eCg2PI=
X-Google-Smtp-Source: AK7set+2ZzcbKOe1O/V52p2ikbekoO/wYDG4nkkpAP/pzpws1LTtmiv96cDgiKnBQBlTCi/ozfjSIvFeL28=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:ea87:0:b0:521:daa4:d68c with SMTP id
 t129-20020a0dea87000000b00521daa4d68cmr0ywe.5.1675291151988; Wed, 01 Feb 2023
 14:39:11 -0800 (PST)
Date:   Wed,  1 Feb 2023 22:37:35 +0000
In-Reply-To: <20221219171924.67989-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221219171924.67989-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <167528558345.768469.17759293608992301689.b4-ty@google.com>
Subject: Re: [PATCH] KVM: Destroy target device if coalesced MMIO
 unregistration fails
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "=?UTF-8?q?=E6=9F=B3=E8=8F=81=E5=B3=B0?=" <liujingfeng@qianxin.com>,
        Wei Wang <wei.w.wang@intel.com>, Michal Luczaj <mhal@rbox.co>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 19 Dec 2022 17:19:24 +0000, Sean Christopherson wrote:
> Destroy and free the target coalesced MMIO device if unregistering said
> device fails.  As clearly noted in the code, kvm_io_bus_unregister_dev()
> does not destroy the target device.
> 
>   BUG: memory leak
>   unreferenced object 0xffff888112a54880 (size 64):
>     comm "syz-executor.2", pid 5258, jiffies 4297861402 (age 14.129s)
>     hex dump (first 32 bytes):
>       38 c7 67 15 00 c9 ff ff 38 c7 67 15 00 c9 ff ff  8.g.....8.g.....
>       e0 c7 e1 83 ff ff ff ff 00 30 67 15 00 c9 ff ff  .........0g.....
>     backtrace:
>       [<0000000006995a8a>] kmalloc include/linux/slab.h:556 [inline]
>       [<0000000006995a8a>] kzalloc include/linux/slab.h:690 [inline]
>       [<0000000006995a8a>] kvm_vm_ioctl_register_coalesced_mmio+0x8e/0x3d0 arch/x86/kvm/../../../virt/kvm/coalesced_mmio.c:150
>       [<00000000022550c2>] kvm_vm_ioctl+0x47d/0x1600 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3323
>       [<000000008a75102f>] vfs_ioctl fs/ioctl.c:46 [inline]
>       [<000000008a75102f>] file_ioctl fs/ioctl.c:509 [inline]
>       [<000000008a75102f>] do_vfs_ioctl+0xbab/0x1160 fs/ioctl.c:696
>       [<0000000080e3f669>] ksys_ioctl+0x76/0xa0 fs/ioctl.c:713
>       [<0000000059ef4888>] __do_sys_ioctl fs/ioctl.c:720 [inline]
>       [<0000000059ef4888>] __se_sys_ioctl fs/ioctl.c:718 [inline]
>       [<0000000059ef4888>] __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:718
>       [<000000006444fa05>] do_syscall_64+0x9f/0x4e0 arch/x86/entry/common.c:290
>       [<000000009a4ed50b>] entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> [...]

Applied to kvm-x86 generic, the plan is that Wei will send the bigger
cleanup on top.  Thanks!

[1/1] KVM: Destroy target device if coalesced MMIO unregistration fails
      https://github.com/kvm-x86/linux/commit/b1cb1fac22ab

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
