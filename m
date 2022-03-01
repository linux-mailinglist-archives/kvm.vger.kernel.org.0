Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61DA54C96BE
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 21:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238207AbiCAUZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 15:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239227AbiCAUYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 15:24:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4EB04C3F
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 12:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646166143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=afO6tVXgk/44QRrigzeqCyc7zYs4NKCHyGdl1A3TxuE=;
        b=TYgyyjucxqu/EJ9gmqCLnKXR46mSgxB4wrHITaWTmLpYXjyHaitgv7TXh4LqC0Xp+fjzO4
        1Ak0p50rJBpds/lUE4LIwXoM9DqSQt39IWPFJNW/c+qpqxVZ8ll00wYb2YMyY44Ksfi/hg
        1zZitXEG9MeD+WG5RYPahlMVJ/niATg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-56FEfme4PKKAuQt0WP40yw-1; Tue, 01 Mar 2022 15:22:22 -0500
X-MC-Unique: 56FEfme4PKKAuQt0WP40yw-1
Received: by mail-wm1-f70.google.com with SMTP id 10-20020a1c020a000000b0037fae68fcc2so1162727wmc.8
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 12:22:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=afO6tVXgk/44QRrigzeqCyc7zYs4NKCHyGdl1A3TxuE=;
        b=m/H0+8Y3aOl3gwnzin5Q62srFJrUsNWjUxbSLFBdlPpRmOH1vVggE4s4totyMFueTW
         Aa9tXJ/ZVW7fAW4BCwJTdgZv30SyaID16dg2XpxKeNLfojJv8FjeN3rv4dmnLIZQjjDw
         AWNUoAn2WoVT3kXpSfI6ycm47DAaYhcMvbt81yAqPTr4ylqE5+6lzLqZkZcOXZwL00lS
         z6jzOpCb1ONYML+KgWC5M+UfUv9gnP1kh18m3/EVO6544Aw2bpa0SkLmVQdHdcaP+SfY
         KhH8difeVwffEIuqebqfHvlWUOtwqkbgr3iN/uTEAQWjI9v/4Umq6DXQAk66yd2MYYNa
         DIgQ==
X-Gm-Message-State: AOAM533gWO3MJHZ/jLDO9TaaX4EAGNz3mqG2w950rEbp8eFLpB3GIME9
        QHGCGYqMJZIB4ewK/CalmPpQsKIuDzdhYgsQJ8JpU2EmSntBE6SnWiOiWy2paVb9DamuBiGqBgq
        AXwWj78WyStuG
X-Received: by 2002:a1c:f617:0:b0:383:5aab:9c51 with SMTP id w23-20020a1cf617000000b003835aab9c51mr291666wmc.79.1646166140526;
        Tue, 01 Mar 2022 12:22:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzwr13telToZtSzN/w7BmWg66Pm80pZ7pLJeriiz+zVQ61Xnj+4nQJLimirDLghYYkM+Wu+6g==
X-Received: by 2002:a1c:f617:0:b0:383:5aab:9c51 with SMTP id w23-20020a1cf617000000b003835aab9c51mr291656wmc.79.1646166140324;
        Tue, 01 Mar 2022 12:22:20 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id r17-20020a056000015100b001ea7db074cdsm20019421wrx.117.2022.03.01.12.22.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 12:22:19 -0800 (PST)
Message-ID: <3fee5315-e55d-278c-e522-d0e6fb2cadd0@redhat.com>
Date:   Tue, 1 Mar 2022 21:22:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH AUTOSEL 5.4 02/11] KVM: Fix lockdep false negative during
 host resume
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org
References: <20220301201951.19066-1-sashal@kernel.org>
 <20220301201951.19066-2-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220301201951.19066-2-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/22 21:19, Sasha Levin wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> [ Upstream commit 4cb9a998b1ce25fad74a82f5a5c45a4ef40de337 ]
> 
> I saw the below splatting after the host suspended and resumed.
> 
>     WARNING: CPU: 0 PID: 2943 at kvm/arch/x86/kvm/../../../virt/kvm/kvm_main.c:5531 kvm_resume+0x2c/0x30 [kvm]
>     CPU: 0 PID: 2943 Comm: step_after_susp Tainted: G        W IOE     5.17.0-rc3+ #4
>     RIP: 0010:kvm_resume+0x2c/0x30 [kvm]
>     Call Trace:
>      <TASK>
>      syscore_resume+0x90/0x340
>      suspend_devices_and_enter+0xaee/0xe90
>      pm_suspend.cold+0x36b/0x3c2
>      state_store+0x82/0xf0
>      kernfs_fop_write_iter+0x1b6/0x260
>      new_sync_write+0x258/0x370
>      vfs_write+0x33f/0x510
>      ksys_write+0xc9/0x160
>      do_syscall_64+0x3b/0xc0
>      entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> lockdep_is_held() can return -1 when lockdep is disabled which triggers
> this warning. Let's use lockdep_assert_not_held() which can detect
> incorrect calls while holding a lock and it also avoids false negatives
> when lockdep is disabled.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> Message-Id: <1644920142-81249-1-git-send-email-wanpengli@tencent.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   virt/kvm/kvm_main.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f31976010622f..adda0c6672b56 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4427,9 +4427,7 @@ static int kvm_suspend(void)
>   static void kvm_resume(void)
>   {
>   	if (kvm_usage_count) {
> -#ifdef CONFIG_LOCKDEP
> -		WARN_ON(lockdep_is_held(&kvm_count_lock));
> -#endif
> +		lockdep_assert_not_held(&kvm_count_lock);
>   		hardware_enable_nolock(NULL);
>   	}
>   }

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

