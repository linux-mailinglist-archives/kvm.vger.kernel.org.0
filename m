Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084DA4C961B
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 21:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238051AbiCAUTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 15:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237798AbiCAUSk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 15:18:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 03FD43B3FC
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 12:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646165876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kbtnGrIoAXkidAZTj8FmIyhuel5W031FIJwbUY20FAA=;
        b=KX0sy/kqZC17jjgiNHTT7vyJUplq4KKxmD0+v0Qy3OTO4kNrey8ZIkj+urZPyvS2dIOf3W
        fr603PkHB9CuUdV0zTpYs7v5NyXlDkl4/XOuH+NqzI7pIAmKo6xnTkz2tte6E0yAtSyR9G
        /V2TGjEPb38BBfyo3QYQUgzJbw6rclw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-g2iEAyzWMIytCKlgCiaKiQ-1; Tue, 01 Mar 2022 15:17:52 -0500
X-MC-Unique: g2iEAyzWMIytCKlgCiaKiQ-1
Received: by mail-wr1-f69.google.com with SMTP id o1-20020adfe801000000b001f023455317so671911wrm.3
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 12:17:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kbtnGrIoAXkidAZTj8FmIyhuel5W031FIJwbUY20FAA=;
        b=MiPm9PT1OtBMLna6hJ0ICTv+XSlLDP4zvl9eH21Py/HQisbbfM9Cq8VwKUmXw3tOay
         vDV0ZwN+P1s1N496WyG11tLQoYBCLxOp8Wbx+DuQrsCpoJ64X3KNUeq8WzFyAT34EfUc
         SxEDPo5bUd9doTNOL3L3YyL76DSUpPVhJKQRcwKtG6uYtZjfDOEaKG4O9hTGssvyKYmu
         Je8sqYabLyTOBSgOm1qOyy7wu5Jb+iAEAHcWGm5Pk/83mAb1P66S1os9J1pGhJ8thpDP
         lkYN3kEKyr5fm1okblChOUpP3Gg9KerCHoS/kySyBs4AvMFEONc5dyX4wuvJCdZa/Er9
         vtYg==
X-Gm-Message-State: AOAM532kutQGoZNtH+sbm/s0MrfhEEUV7gw8xII9S4ZTab2uXBfcEA6n
        N8gJQrQtM07Z8AfaGpe/0vuZ5KebKkQV9RMYFCfkumD2Kzekde5DjIZEGMcCh0hA4JhS14GSThY
        GJOGb4Dje03Tm
X-Received: by 2002:a05:600c:4e08:b0:381:9094:6b3c with SMTP id b8-20020a05600c4e0800b0038190946b3cmr3338836wmq.103.1646165871000;
        Tue, 01 Mar 2022 12:17:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyHRA1O1tPDB9klqjpvqfr2MK6rdobahePsJyhIS2BUsCgaysLn9yR7ZHPI3cYyFrk3Va3iAQ==
X-Received: by 2002:a05:600c:4e08:b0:381:9094:6b3c with SMTP id b8-20020a05600c4e0800b0038190946b3cmr3338828wmq.103.1646165870783;
        Tue, 01 Mar 2022 12:17:50 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id k15-20020adff5cf000000b001e4b8fde355sm14482929wrp.73.2022.03.01.12.17.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 12:17:50 -0800 (PST)
Message-ID: <2619b94d-d1e8-5185-5533-506421ca7281@redhat.com>
Date:   Tue, 1 Mar 2022 21:17:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH AUTOSEL 5.15 05/23] KVM: Fix lockdep false negative during
 host resume
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org
References: <20220301201629.18547-1-sashal@kernel.org>
 <20220301201629.18547-5-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220301201629.18547-5-sashal@kernel.org>
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

On 3/1/22 21:16, Sasha Levin wrote:
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
> index 13aff136e6eef..5309b3eaa0470 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5416,9 +5416,7 @@ static int kvm_suspend(void)
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

