Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A78F61F84A
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 17:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbiKGQGN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 11:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbiKGQFu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 11:05:50 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CEEC205FA
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 08:05:41 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso10735063pjc.2
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 08:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CwCXHOiuiyfKv69+MEzKNVwp3Ov8oZ78eR0WR4d2A90=;
        b=NLcMdAU2vS38J28r0bBcsw9sZG6YcZkl/8nBVDjJmKmae84CrIcfXGeRXyu5K/r2XC
         UXrnEq0BsJneLcHe1CNJYHR75xYsoXID5BQbTEcuwORpbQ+QfxAjFkkD8vDJsL2oodUp
         DIuWBiHaNivTC8uyPcgEfz1vmoWtscFYydQi+R3bmF6HEgWJmUiWrYPuVIaUChxcqxTi
         di9evWogJbj1Hbyk9lUBgezlAa96Ur8/3SxAxP0+2IU0yS7UH7HSbHYQwC9QdQrQmZGN
         JyXtK6CAsYEae29AWcTHURqTPdtdj6RMhazriqop30Mk5iNQ232Ex5JAIGbk+jM6+DBc
         He+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CwCXHOiuiyfKv69+MEzKNVwp3Ov8oZ78eR0WR4d2A90=;
        b=2a4KOSJYs+1PW8iQsBEgsT4vGX4sJnk2cQaS/bj2zQqFjZJ3ORx8PvTgGVQHIXq3KQ
         Yy/eABbvwbHdAXAsqf38AteJ7gZohlVf2+TDojOFJhGpwmjhtSL6+W4jQooL7IZB5hOH
         M5WSAqkmIccIUXRIU1WgK2m6O2Txlwh3OEhlcYedNdX69q8yacLNTImPMMI2GMsPsqge
         Hevqs3koEXss/tbO2azH98eUOJAtO6TQ/gDbZEyqUnJfCnwxyf4ymairvuTdZJ9iqxcX
         oQ9Mv5JBZR876tDHZoBD1o1f/dzYeM7jRC/tm5lzT2lOs9TXbFI1eMCN1OW0SOctBuDh
         kRcQ==
X-Gm-Message-State: ANoB5pngi+6763FMVBCDnJwuxUaWA3Ei36rzrc4+TixKGBatR4drgY4o
        XJt0vgxq+fiVhDxNY33wQr/lQg==
X-Google-Smtp-Source: AA0mqf7NmHUwnj4p1J7j0E54Y9RXMXBZQMv0Sw4ZZdbS0IXjebmkq5OLQBCE6zzlWdvLIEkqEMOzqA==
X-Received: by 2002:a17:903:4052:b0:188:6bad:3ff0 with SMTP id n18-20020a170903405200b001886bad3ff0mr16812130pla.6.1667837140430;
        Mon, 07 Nov 2022 08:05:40 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n5-20020a170902e54500b00186c54188b4sm5188752plf.240.2022.11.07.08.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 08:05:39 -0800 (PST)
Date:   Mon, 7 Nov 2022 16:05:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, shuah@kernel.org, catalin.marinas@arm.com,
        andrew.jones@linux.dev, ajones@ventanamicro.com,
        bgardon@google.com, dmatlack@google.com, will@kernel.org,
        suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, maz@kernel.org, peterx@redhat.com,
        oliver.upton@linux.dev, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v8 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2ks0NWEEfN8bWV1@google.com>
References: <20221104234049.25103-1-gshan@redhat.com>
 <20221104234049.25103-4-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104234049.25103-4-gshan@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 05, 2022, Gavin Shan wrote:
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index fecbb7d75ad2..758679724447 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -21,6 +21,16 @@ u32 kvm_dirty_ring_get_rsvd_entries(void)
>  	return KVM_DIRTY_RING_RSVD_ENTRIES + kvm_cpu_dirty_log_size();
>  }
>  
> +bool kvm_use_dirty_bitmap(struct kvm *kvm)
> +{

	lockdep_assert_held(&kvm->slots_lock);

To guard against accessing kvm->dirty_ring_with_bitmap without holding slots_lock.

> +	return !kvm->dirty_ring_size || kvm->dirty_ring_with_bitmap;
> +}
> +
> @@ -4588,6 +4594,31 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>  			return -EINVAL;
>  
>  		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
> +	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP: {
> +		struct kvm_memslots *slots;
> +		int r = -EINVAL;
> +
> +		if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
> +		    !kvm->dirty_ring_size)
> +			return r;
> +
> +		mutex_lock(&kvm->slots_lock);
> +
> +		slots = kvm_memslots(kvm);

Sadly, this needs to iterate over all possible memslots thanks to x86's SMM
address space.  Might be worth adding a separate helper (that's local to kvm_main.c
to discourage use), e.g. 

static bool kvm_are_all_memslots_empty(struct kvm *kvm)
{
	int i;

	lockdep_assert_held(&kvm->slots_lock);

	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
		if (!kvm_memslots_empty(__kvm_memslots(kvm, i)))
			return false;
	}

	return true;
}

> +
> +		/*
> +		 * Avoid a race between memslot creation and enabling the ring +
> +		 * bitmap capability to guarantee that no memslots have been
> +		 * created without a bitmap.

Nit, it's not just enabling, the below also allows disabling the bitmap.  The
enabling case is definitely the most interesting, but the above wording makes it
sound like the enabling case is the only thing that being given protection.  That's
kinda true since KVM frees bitmaps without checking kvm_use_dirty_bitmap(), but
that's not a strict requirement.

And there's no race required, e.g. without this check userspace could simply create
a memslot and then toggle on the capability.  Acquiring slots_lock above is what
guards against races.

Might also be worth alluding to the alternative solution of allocating the bitmap
for all memslots here, e.g. something like

		/*
		 * For simplicity, allow toggling ring+bitmap if and only if
		 * there are no memslots, e.g. to ensure all memslots allocate a
		 * bitmap after the capability is enabled.
		 */

> +		 */
> +		if (kvm_memslots_empty(slots)) {
> +			kvm->dirty_ring_with_bitmap = cap->args[0];
> +			r = 0;
> +		}
> +
> +		mutex_unlock(&kvm->slots_lock);
> +		return r;
> +	}
>  	default:
>  		return kvm_vm_ioctl_enable_cap(kvm, cap);
>  	}
> -- 
