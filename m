Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9012304A18
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 21:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730912AbhAZFPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:15:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39497 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726883AbhAYJ5G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Jan 2021 04:57:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611568463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BQWXsTywCg/HpuhUqGg4Mb/h0MABQoSPqp38t2qFTo4=;
        b=Q0XQnHe+N7pBRuPwzz4seLChQv4aTG9SDNb1Xo20KH/mDBvntu/JWw2bAJ2qi7At6MgezS
        bt0TtU/xQNmKXSvqmo5WduPxztTLAAM/IlYeBnvoaw/pB2MdIM8fJx+U5ymPXxXe+B1roq
        zk7FCXR2A7O42opmv06STMCO0+PsfJ0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-va-ku4yvOAmjPIxgodhyjw-1; Mon, 25 Jan 2021 04:54:21 -0500
X-MC-Unique: va-ku4yvOAmjPIxgodhyjw-1
Received: by mail-ed1-f70.google.com with SMTP id a24so7029587eda.14
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 01:54:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BQWXsTywCg/HpuhUqGg4Mb/h0MABQoSPqp38t2qFTo4=;
        b=cVbwCKdHoaCX+wIAqbFxC87emk4Scfg3Ows+CstPeb0RigGxL3Csz/7DY8VKetTmeZ
         ofxdDWFZA4tWB8eVV6/J6G16YQbnNymlJ0f6sSuInxHnWdgO6x2EuaRURLEU9Qqjy67s
         xyja59XI8E7Q6HxixwiytF5c6oqiIjRXU5I4aCBOsbr/bdQshnzR/zIujksLUVI4rZmb
         6dAn74AWQr06w9OYhcTrS8rEvNxVY7HHgkAe4XTPlKj7jh57UNASK8MJOqa8R8iVfUjR
         fDVUkRT7tqArMjaJw1aCK+LOqB6vnyPgWJ69yH1gJNfzdcIoRGeH/ai0ZoMqaL7KZ9Di
         /y7A==
X-Gm-Message-State: AOAM530Wyxcb6gNUss7cbR/7JNxndIIhiTxLzbCAnjcky3QaxNk9uXqU
        8rKqsZGPvIT/wxxTVXgZW+IZt2L+z+8nieXJ03eL0hK/PFQOtCCt2JqnNpKPUkDGTavB+A3wYf7
        K+Hor1yqhDF0t
X-Received: by 2002:a05:6402:100b:: with SMTP id c11mr623830edu.193.1611568460050;
        Mon, 25 Jan 2021 01:54:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxcqcQjZJ1pJCHs48lf5IQcDnFo3BNnKaESA4fXV5jd/jEtPbExIpDIqbrHSMeIExDR9IX4ZQ==
X-Received: by 2002:a05:6402:100b:: with SMTP id c11mr623817edu.193.1611568459926;
        Mon, 25 Jan 2021 01:54:19 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id hr31sm7965914ejc.125.2021.01.25.01.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 01:54:19 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Stephen Zhang <stephenzhangzsd@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Zhang <stephenzhangzsd@gmail.com>, pbonzini@redhat.com,
        seanjc@google.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com
Subject: Re: [PATCH] KVM: x86/mmu: improve robustness of some functions
In-Reply-To: <1611314323-2770-1-git-send-email-stephenzhangzsd@gmail.com>
References: <1611314323-2770-1-git-send-email-stephenzhangzsd@gmail.com>
Date:   Mon, 25 Jan 2021 10:54:18 +0100
Message-ID: <87a6sx4a0l.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stephen Zhang <stephenzhangzsd@gmail.com> writes:

> If the name of this function changes, you can easily
> forget to modify the code in the corresponding place.
> In fact, such errors already exist in spte_write_protect
>  and spte_clear_dirty.
>

What if we do something like (completely untested):

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index bfc6389edc28..5ec15e4160b1 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -12,7 +12,7 @@
 extern bool dbg;
 
 #define pgprintk(x...) do { if (dbg) printk(x); } while (0)
-#define rmap_printk(x...) do { if (dbg) printk(x); } while (0)
+#define rmap_printk(fmt, args...) do { if (dbg) printk("%s: " fmt, __func__, ## args); } while (0)
 #define MMU_WARN_ON(x) WARN_ON(x)
 #else
 #define pgprintk(x...) do { } while (0)

and eliminate the need to pass '__func__,' explicitly? We can probably
do the same to pgprintk().

> Signed-off-by: Stephen Zhang <stephenzhangzsd@gmail.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6d16481..09462c3d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -844,17 +844,17 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
>  	int i, count = 0;
>  
>  	if (!rmap_head->val) {
> -		rmap_printk("pte_list_add: %p %llx 0->1\n", spte, *spte);
> +		rmap_printk("%s: %p %llx 0->1\n", __func__, spte, *spte);
>  		rmap_head->val = (unsigned long)spte;
>  	} else if (!(rmap_head->val & 1)) {
> -		rmap_printk("pte_list_add: %p %llx 1->many\n", spte, *spte);
> +		rmap_printk("%s: %p %llx 1->many\n", __func__, spte, *spte);
>  		desc = mmu_alloc_pte_list_desc(vcpu);
>  		desc->sptes[0] = (u64 *)rmap_head->val;
>  		desc->sptes[1] = spte;
>  		rmap_head->val = (unsigned long)desc | 1;
>  		++count;
>  	} else {
> -		rmap_printk("pte_list_add: %p %llx many->many\n", spte, *spte);
> +		rmap_printk("%s: %p %llx many->many\n",	__func__, spte, *spte);
>  		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
>  		while (desc->sptes[PTE_LIST_EXT-1]) {
>  			count += PTE_LIST_EXT;
> @@ -1115,7 +1115,7 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
>  	      !(pt_protect && spte_can_locklessly_be_made_writable(spte)))
>  		return false;
>  
> -	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
> +	rmap_printk("%s: spte %p %llx\n", __func__, sptep, *sptep);
>  
>  	if (pt_protect)
>  		spte &= ~SPTE_MMU_WRITEABLE;
> @@ -1142,7 +1142,7 @@ static bool spte_clear_dirty(u64 *sptep)
>  {
>  	u64 spte = *sptep;
>  
> -	rmap_printk("rmap_clear_dirty: spte %p %llx\n", sptep, *sptep);
> +	rmap_printk("%s: spte %p %llx\n", __func__, sptep, *sptep);
>  
>  	MMU_WARN_ON(!spte_ad_enabled(spte));
>  	spte &= ~shadow_dirty_mask;
> @@ -1184,7 +1184,7 @@ static bool spte_set_dirty(u64 *sptep)
>  {
>  	u64 spte = *sptep;
>  
> -	rmap_printk("rmap_set_dirty: spte %p %llx\n", sptep, *sptep);
> +	rmap_printk("%s: spte %p %llx\n", __func__, sptep, *sptep);
>  
>  	/*
>  	 * Similar to the !kvm_x86_ops.slot_disable_log_dirty case,
> @@ -1363,8 +1363,8 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>  
>  restart:
>  	for_each_rmap_spte(rmap_head, &iter, sptep) {
> -		rmap_printk("kvm_set_pte_rmapp: spte %p %llx gfn %llx (%d)\n",
> -			    sptep, *sptep, gfn, level);
> +		rmap_printk("%s: spte %p %llx gfn %llx (%d)\n",
> +			      __func__, sptep, *sptep, gfn, level);
>  
>  		need_flush = 1;

-- 
Vitaly

