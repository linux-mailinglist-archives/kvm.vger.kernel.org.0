Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502C9204B65
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 09:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731627AbgFWHkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 03:40:01 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41316 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731041AbgFWHkA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Jun 2020 03:40:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592897998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bRQOtyl6lVhUbOXwbZ0j6gA48P7oZ6lHfj3tURdm+Qk=;
        b=gdHwKr6OZeqvTdxU1DD1FyPMzdpqtBlyAMnmkayYENOdGBbamjBDGGS5kJ4LXO0/vICqRR
        DgoV60zAniRwPj40f+98WQbWAdsGYuYHVFBlaf6X/r6MvDHNVlAM3lh+zrDhQoUypfFcT7
        ksPUgccZUFxldzq2FZ5HDLFbUcz16Nw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-w9MmQMIHOd6ISXgO2YJyuA-1; Tue, 23 Jun 2020 03:39:57 -0400
X-MC-Unique: w9MmQMIHOd6ISXgO2YJyuA-1
Received: by mail-wm1-f69.google.com with SMTP id c66so3145593wma.8
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 00:39:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bRQOtyl6lVhUbOXwbZ0j6gA48P7oZ6lHfj3tURdm+Qk=;
        b=rOAlk6LAH6zVMUdxLNy5xiIxB8A9oNhtjXlW056yujYEpoGlATfoQTErXaivRTnrhp
         249NBKQKBjcp+smqgTw9aKIXGAPW8nJZq59f+i5C7A79VNd28bRez7RPNgbfllNZ5Zbd
         RdZmZadNraATnwFtyjmbGfKOrWjpYLZxb6NKtY4egekanNH1Ykw304SG0FB1Fp0443zq
         8kyIbZNupys0dvR/r6wiq59Dri3YAIgaLucFvAQG5TS+SxXIcS/9/0fEq49C5UYzeSir
         jdFwCWT0vpzuaM4ZwfU/06uUIY9SoPop8jM8mokZDoOZwWwet8YSFA87ICNtVbudcKzG
         xNxg==
X-Gm-Message-State: AOAM533gsXOOGnJjYupElZMtnA5XEeAh5DQyICdte/OIw6mVyDncSzNB
        ii7QrfHaDEgo8TudcUBS792IbJo+papf14V1NBkXGG6bQ+vni9/bfEdlFY7Mtq3dvXFvNTpyRfC
        ruYf5wUuBlTCA
X-Received: by 2002:adf:f68d:: with SMTP id v13mr22045561wrp.291.1592897996032;
        Tue, 23 Jun 2020 00:39:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyROt/FdYOL7D3F3GIScbHmS1rmvcw9/x/W6kr1tp+rrM2/YM/ISk0VKoa0qpUQrUlimzfQsQ==
X-Received: by 2002:adf:f68d:: with SMTP id v13mr22045539wrp.291.1592897995798;
        Tue, 23 Jun 2020 00:39:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:24f5:23b:4085:b879? ([2001:b07:6468:f312:24f5:23b:4085:b879])
        by smtp.gmail.com with ESMTPSA id d9sm21004342wre.28.2020.06.23.00.39.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 00:39:55 -0700 (PDT)
Subject: Re: [PATCH v2] kvm: Fix false positive RCU usage warning
To:     madhuparnabhowmik10@gmail.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        tglx@linutronix.de, bp@alien8.de
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@joelfernandes.org, paulmck@kernel.org, frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
References: <20200516082227.22194-1-madhuparnabhowmik10@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9fff3c6b-1978-c647-16f7-563a1cdf62ff@redhat.com>
Date:   Tue, 23 Jun 2020 09:39:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200516082227.22194-1-madhuparnabhowmik10@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/05/20 10:22, madhuparnabhowmik10@gmail.com wrote:
> From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> 
> Fix the following false positive warnings:
> 
> [ 9403.765413][T61744] =============================
> [ 9403.786541][T61744] WARNING: suspicious RCU usage
> [ 9403.807865][T61744] 5.7.0-rc1-next-20200417 #4 Tainted: G             L
> [ 9403.838945][T61744] -----------------------------
> [ 9403.860099][T61744] arch/x86/kvm/mmu/page_track.c:257 RCU-list traversed in non-reader section!!
> 
> and
> 
> [ 9405.859252][T61751] =============================
> [ 9405.859258][T61751] WARNING: suspicious RCU usage
> [ 9405.880867][T61755] -----------------------------
> [ 9405.911936][T61751] 5.7.0-rc1-next-20200417 #4 Tainted: G             L
> [ 9405.911942][T61751] -----------------------------
> [ 9405.911950][T61751] arch/x86/kvm/mmu/page_track.c:232 RCU-list traversed in non-reader section!!
> 
> Since srcu read lock is held, these are false positive warnings.
> Therefore, pass condition srcu_read_lock_held() to
> list_for_each_entry_rcu().
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> ---
> v2:
> -Rebase v5.7-rc5
> 
>  arch/x86/kvm/mmu/page_track.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index ddc1ec3bdacd..1ad79c7aa05b 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -229,7 +229,8 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
>  		return;
>  
>  	idx = srcu_read_lock(&head->track_srcu);
> -	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
> +	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node,
> +				srcu_read_lock_held(&head->track_srcu))
>  		if (n->track_write)
>  			n->track_write(vcpu, gpa, new, bytes, n);
>  	srcu_read_unlock(&head->track_srcu, idx);
> @@ -254,7 +255,8 @@ void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
>  		return;
>  
>  	idx = srcu_read_lock(&head->track_srcu);
> -	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
> +	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node,
> +				srcu_read_lock_held(&head->track_srcu))
>  		if (n->track_flush_slot)
>  			n->track_flush_slot(kvm, slot, n);
>  	srcu_read_unlock(&head->track_srcu, idx);
> 

Hi, sorry for the delay in reviewing this patch.  I would like to ask
Paul about it.

While you're correctly fixing a false positive, hlist_for_each_entry_rcu
would have a false _negative_ if you called it under
rcu_read_lock/unlock and the data structure was protected by SRCU.  This
is why for example srcu_dereference is used instead of
rcu_dereference_check, and why srcu_dereference uses
__rcu_dereference_check (with the two underscores) instead of
rcu_dereference_check.  Using rcu_dereference_check would add an "||
rcu_read_lock_held()" to the condition which is wrong.

I think instead you should add hlist_for_each_srcu and
hlist_for_each_entry_srcu macro to include/linux/rculist.h.

There is no need for equivalents of hlist_for_each_entry_continue_rcu
and hlist_for_each_entry_from_rcu, because they use rcu_dereference_raw.
 However, it's not documented why they do so.

Paul, do you have any objections to the idea?  Thanks,

Paolo

