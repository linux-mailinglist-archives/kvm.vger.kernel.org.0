Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98D93EDD93
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 12:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbfKDLSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 06:18:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38952 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbfKDLSO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 06:18:14 -0500
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B2725368CF
        for <kvm@vger.kernel.org>; Mon,  4 Nov 2019 11:18:13 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id b4so10221582wrn.8
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 03:18:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tjh9olQgahzwzj0M0Iuuf9b2PFhQNU5RKbl2/F2MSnE=;
        b=lJIRECWssBT16ioWKZHO0fFrFVV/w9EHAkrLyUMB+laB6WeC6axZXfVhs1dSJTmeAf
         zKwaH47mXsQ/hDThXFsJWivYf9XtMeJP1e1damFaYgCF6oju4VMLMY5aP91JgVoxKCjn
         53xsmlPlywPDMYpqyNROuHchZHWs1Ix79iFMtrTjybmLCNyPS9WsciPlStQtOVdR+22k
         Jmm2dB/W1oKYxZoLIasWVHfLLdTHBH/BfuqvVwd5FLpfpTiT1hliMcQvUExcMTUACNVw
         IdDPQym3B1MBERoaZJ02lyr7zRJbnB1xijD3JMpcBro1RmvcPHNT9oDb62cvqUxsNHw5
         gdXQ==
X-Gm-Message-State: APjAAAWRchMDv01gZh3hvFQCZcydXMmvlehK0j4POTtyDrxu0245PGIB
        4dd4v4wbHRpV01kVF5cZ/1KNcyUIkpOzFm5P1OX4P0n55CM7Io7NrLzhcoIn4wrgaVQsdPpHFFI
        TtpVWRI9WKcYg
X-Received: by 2002:a1c:9a81:: with SMTP id c123mr21333527wme.118.1572866292237;
        Mon, 04 Nov 2019 03:18:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqy7tIFTFPZwnaW75wp0LpGbyQrIIz5Dg2nZLh2pakGkHJ7adbfMTbGN+0kwlhpqk4p3mdOSdA==
X-Received: by 2002:a1c:9a81:: with SMTP id c123mr21333495wme.118.1572866291895;
        Mon, 04 Nov 2019 03:18:11 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:4051:461:136e:3f74? ([2001:b07:6468:f312:4051:461:136e:3f74])
        by smtp.gmail.com with ESMTPSA id q9sm9962059wru.83.2019.11.04.03.18.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 03:18:11 -0800 (PST)
Subject: Re: [PATCH 2/2] KVM: Fix rcu splat if vm creation fails
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1572848879-21011-1-git-send-email-wanpengli@tencent.com>
 <1572848879-21011-2-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <c32d632b-8fb0-f7c6-4937-07c30769b924@redhat.com>
Date:   Mon, 4 Nov 2019 12:18:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1572848879-21011-2-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/11/19 07:27, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Reported by syzkaller:
> 
>    =============================
>    WARNING: suspicious RCU usage
>    -----------------------------
>    ./include/linux/kvm_host.h:536 suspicious rcu_dereference_check() usage!
>    
>    other info that might help us debug this:
> 
>    rcu_scheduler_active = 2, debug_locks = 1
>    no locks held by repro_11/12688.
>     
>    stack backtrace:
>    Call Trace:
>     dump_stack+0x7d/0xc5
>     lockdep_rcu_suspicious+0x123/0x170
>     kvm_dev_ioctl+0x9a9/0x1260 [kvm]
>     do_vfs_ioctl+0x1a1/0xfb0
>     ksys_ioctl+0x6d/0x80
>     __x64_sys_ioctl+0x73/0xb0
>     do_syscall_64+0x108/0xaa0
>     entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Commit a97b0e773e4 (kvm: call kvm_arch_destroy_vm if vm creation fails)
> sets users_count to 1 before kvm_arch_init_vm(), however, if kvm_arch_init_vm()
> fails, we need to dec this count. Or, we can move the sets refcount after 
> kvm_arch_init_vm().

I don't understand this one, hasn't

        WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));

decreased the conut already?  With your patch the refcount would then
underflow.

Paolo
