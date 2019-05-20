Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBD82316D
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 12:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731653AbfETKge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 06:36:34 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44142 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731216AbfETKge (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 06:36:34 -0400
Received: by mail-wr1-f65.google.com with SMTP id w13so3239805wru.11
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 03:36:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mu2Z3UHH7f9ccDUy0/A9TZhUKTVMZskH29YGAuodbA0=;
        b=C9F23vep/Vwvzs5a2Ufo3H7ZGjG8UYhynl0X4OqjwqhLoAaqrA+VY5wc5oLt7dUVGE
         Ejdbmr4w89NeOqObHErmgOokHJdnYN7VRQ2pZ4qxz696rsmcfDkd3zjj45sA0mLgNE8j
         wB1YfoS0N0mQirB2Y2j+OkIvAkUH7LhVavPS1MhO6NU0mVrBzfYYI+bzn2RDxswP2gpB
         xjUUbWgpRWkpv4OVUYkfDNy9y6gAmiA+vE1UDKtdAISRTOZz0Xf6M+brry4kfo7eyYPh
         lI7+8LpLRCcPpq7eWMXiBQOHDKz6K/rhVcE8eDHRNwuxvsSxkg93qDSE1BV42+1jPilE
         5y1g==
X-Gm-Message-State: APjAAAUMjz7qGqUC+U0fM4viynoPdhjjNK2bySwiUmjpnL9S3oSRu88X
        9pjEybultoGxyPTpSX7L/3cRLg==
X-Google-Smtp-Source: APXvYqxVifVEVflPIpthzfCRaNpbf0QfwZg7hpDF9hT0mMHu42X0q0gZvqU16/M7Zkxjk2ApohQ3OA==
X-Received: by 2002:adf:e311:: with SMTP id b17mr25372761wrj.11.1558348592580;
        Mon, 20 May 2019 03:36:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id y17sm14563641wrp.70.2019.05.20.03.36.31
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 03:36:32 -0700 (PDT)
Subject: Re: [PATCH 3/4] KVM: Fix spinlock taken warning during host resume
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>
References: <1558082990-7822-1-git-send-email-wanpengli@tencent.com>
 <1558082990-7822-3-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7cce6762-006a-a21c-6400-6c0166428cf1@redhat.com>
Date:   Mon, 20 May 2019 12:36:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1558082990-7822-3-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/05/19 10:49, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
>  WARNING: CPU: 0 PID: 13554 at kvm/arch/x86/kvm//../../../virt/kvm/kvm_main.c:4183 kvm_resume+0x3c/0x40 [kvm]
>   CPU: 0 PID: 13554 Comm: step_after_susp Tainted: G           OE     5.1.0-rc4+ #1
>   RIP: 0010:kvm_resume+0x3c/0x40 [kvm]
>   Call Trace:
>    syscore_resume+0x63/0x2d0
>    suspend_devices_and_enter+0x9d1/0xa40
>    pm_suspend+0x33a/0x3b0
>    state_store+0x82/0xf0
>    kobj_attr_store+0x12/0x20
>    sysfs_kf_write+0x4b/0x60
>    kernfs_fop_write+0x120/0x1a0
>    __vfs_write+0x1b/0x40
>    vfs_write+0xcd/0x1d0
>    ksys_write+0x5f/0xe0
>    __x64_sys_write+0x1a/0x20
>    do_syscall_64+0x6f/0x6c0
>    entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Commit ca84d1a24 (KVM: x86: Add clock sync request to hardware enable) mentioned 
> that "we always hold kvm_lock when hardware_enable is called.  The one place that 
> doesn't need to worry about it is resume, as resuming a frozen CPU, the spinlock 
> won't be taken." However, commit 6706dae9 (virt/kvm: Replace spin_is_locked() with 
> lockdep) introduces a bug, it asserts when the lock is not held which is contrary 
> to the original goal. 
> 
> This patch fixes it by WARN_ON when the lock is held.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Paul E. McKenney <paulmck@linux.ibm.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 5fb0f16..c7eab5f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4096,7 +4096,7 @@ static int kvm_suspend(void)
>  static void kvm_resume(void)
>  {
>  	if (kvm_usage_count) {
> -		lockdep_assert_held(&kvm_count_lock);
> +		WARN_ON(lockdep_is_held(&kvm_count_lock));
>  		hardware_enable_nolock(NULL);
>  	}
>  }
> 

Queued, thanks.

Paolo
