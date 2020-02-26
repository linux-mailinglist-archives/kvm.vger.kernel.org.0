Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30535170698
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 18:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgBZRvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 12:51:09 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20540 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726151AbgBZRvI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Feb 2020 12:51:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582739467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X/GO32zOeZAgd5MebprE0rtmSJluPtmU741UPYfurz8=;
        b=atLv9YiN6hDp5fEbqXNSTVTDh6vhkPOKVm9+d3VjcNl2bWkrPs+WKi1PSvWnCKkRpiQXWt
        wQ/pB/+FtmznhQEAK0lItKTq8D/YPdOA0GewBsv7iNhbl5pDdpFVvrVgiWrr7AuU+wGcQ0
        vPn0wKwV22ncK+/wrbCeLp1DJYbXRBA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-8Vs85sbcOpe4uYvhht5f6w-1; Wed, 26 Feb 2020 12:51:05 -0500
X-MC-Unique: 8Vs85sbcOpe4uYvhht5f6w-1
Received: by mail-wr1-f71.google.com with SMTP id u8so83649wrp.10
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 09:51:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=X/GO32zOeZAgd5MebprE0rtmSJluPtmU741UPYfurz8=;
        b=j0XC3DeSSlYQ+R5HycGoq6uOtwJ7TnS9YQase9Om3VOOh0+K1vWIDlHiD3NhgMAmj6
         IK0L2QUQduf3D6Jp6PlEjoNdjdfqcZGKHnmbb1lRa3i9ZeyBh4oa1LN4+WoKWZo7GgR5
         rhmVsWzzviA0lbsbqgapeg7FT3eT1iHTL7GQuy8gMBcWfKYvF3INrNwPxuh8p+Qc2XIa
         SRXmjDcatnuVdr6IPsBjLi2E9dpDVXq8/eqnAUmzJKJnZUWUxZCgaCQ3TYSUzZDc0QcN
         jc44O6ZG/4YgJyZhsBtzir50LnSwB+db7Z5Nb9ijYCk/xYCzgZiAlLjhyy91Ekh5ylY8
         RlYg==
X-Gm-Message-State: APjAAAXViOtasy5Y27jCK3Iw/LRNVhnz0F3l46+kwTKctMsuwY9mpd7m
        viF1ohteqZnFD+uXqG2BCOXmqKPjZomiFoCAuLHA4MaiFI0Ov8z55zEHdQaR4G8msWFoNfezbHT
        RPQfvslviiXfU
X-Received: by 2002:a1c:4b0f:: with SMTP id y15mr21658wma.87.1582739463997;
        Wed, 26 Feb 2020 09:51:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqxC2qNmKsu4aQ5LkbFoKjMbr17wp+oJXxszJiSQSybBfpoQvWQmOwm0eaMUvvYJjuSRaJvQ6g==
X-Received: by 2002:a1c:4b0f:: with SMTP id y15mr21648wma.87.1582739463797;
        Wed, 26 Feb 2020 09:51:03 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id o9sm4307838wrw.20.2020.02.26.09.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 09:51:03 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 10/13] KVM: x86: Shrink the usercopy region of the emulation context
In-Reply-To: <20200218232953.5724-11-sean.j.christopherson@intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com> <20200218232953.5724-11-sean.j.christopherson@intel.com>
Date:   Wed, 26 Feb 2020 18:51:02 +0100
Message-ID: <87r1yhi6ex.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Shuffle a few operand structs to the end of struct x86_emulate_ctxt and
> update the cache creation to whitelist only the region of the emulation
> context that is expected to be copied to/from user memory, e.g. the
> instruction operands, registers, and fetch/io/mem caches.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/kvm_emulate.h |  8 +++++---
>  arch/x86/kvm/x86.c         | 12 ++++++------
>  2 files changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index 2f0a600efdff..82f712d5c692 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -322,9 +322,6 @@ struct x86_emulate_ctxt {
>  	u8 intercept;
>  	u8 op_bytes;
>  	u8 ad_bytes;
> -	struct operand src;
> -	struct operand src2;
> -	struct operand dst;
>  	int (*execute)(struct x86_emulate_ctxt *ctxt);
>  	int (*check_perm)(struct x86_emulate_ctxt *ctxt);
>  	/*
> @@ -349,6 +346,11 @@ struct x86_emulate_ctxt {
>  	u8 seg_override;
>  	u64 d;
>  	unsigned long _eip;
> +
> +	/* Here begins the usercopy section. */
> +	struct operand src;
> +	struct operand src2;
> +	struct operand dst;

Out of pure curiosity, how certain are we that this is going to be
enough for userspaces?

>  	struct operand memop;
>  	/* Fields above regs are cleared together. */
>  	unsigned long _regs[NR_VCPU_REGS];
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 370af9fe0f5b..e1eaca65756b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -235,13 +235,13 @@ static struct kmem_cache *x86_emulator_cache;
>  
>  static struct kmem_cache *kvm_alloc_emulator_cache(void)
>  {
> -	return kmem_cache_create_usercopy("x86_emulator",
> -					  sizeof(struct x86_emulate_ctxt),
> +	unsigned int useroffset = offsetof(struct x86_emulate_ctxt, src);
> +	unsigned int size = sizeof(struct x86_emulate_ctxt);
> +
> +	return kmem_cache_create_usercopy("x86_emulator", size,
>  					  __alignof__(struct x86_emulate_ctxt),
> -					  SLAB_ACCOUNT,
> -					  0,
> -					  sizeof(struct x86_emulate_ctxt),
> -					  NULL);
> +					  SLAB_ACCOUNT, useroffset,
> +					  size - useroffset, NULL);
>  }
>  
>  static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt);

-- 
Vitaly

