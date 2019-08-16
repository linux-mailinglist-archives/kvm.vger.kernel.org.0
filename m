Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C75AD8FBED
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2019 09:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfHPHQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Aug 2019 03:16:47 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39016 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfHPHQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Aug 2019 03:16:47 -0400
Received: by mail-wr1-f67.google.com with SMTP id t16so576066wra.6
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2019 00:16:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EJIVlcVrChaIchPRvi0VZFSGzF07MglN/xDgbO0U5g8=;
        b=tcGIdyBdTF3uKqXglRA57PPGJj5ULA4Yk87E0W307Zj+EjKY/6su/nw0HpZG5tYx8c
         xHGX6maQj38fTtE7qi0kMLLNtsQoUOicyNdxn1H85R9vl0muO+0M/75At6iMWGsVEwoC
         SOLL9iE86L1NVqJQX8SitOoyDP5BNB2WeJPO33YD8RYBDst6V05OU6h0TohouRvSPKcD
         pTzCMcBHF6TWQuUEGnri7w0yzcro7hd5ktNSWCU/gwAAMAQv5iVT7bKzTqdhesLshcwe
         G9ZSLp2L5ZMxVfGYq8OMaWz8F3Tl8Q8cHijwEZ5PnIdWowhfyH31JOrkZmnhwMSqsMAk
         6Rew==
X-Gm-Message-State: APjAAAWKfY/phRWHfhF7KcApyrXlNST7VrlOyvKhJ/XfLHG1gLBjhdKz
        J4GZgw7p7uTXpwXMl41yZd/t7Q==
X-Google-Smtp-Source: APXvYqzTfq2WpNnyBkTVV943/NPrjFUPf4oiM2s4KVceIdYqfb9LPPM0nQxqCppVTo2b/jit8oFZxQ==
X-Received: by 2002:adf:9050:: with SMTP id h74mr8738567wrh.191.1565939805105;
        Fri, 16 Aug 2019 00:16:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:399c:411e:1ccb:f240? ([2001:b07:6468:f312:399c:411e:1ccb:f240])
        by smtp.gmail.com with ESMTPSA id g26sm3184169wmh.32.2019.08.16.00.16.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2019 00:16:44 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/MMU: Zap all when removing memslot if VM has
 assigned device
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Willamson <alex.williamson@redhat.com>
References: <1565855169-29491-1-git-send-email-pbonzini@redhat.com>
 <20190815151228.32242-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <6c040867-2978-5c57-bbd1-3000593ed538@redhat.com>
Date:   Fri, 16 Aug 2019 09:16:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190815151228.32242-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/08/19 17:12, Sean Christopherson wrote:
> Alex Williamson reported regressions with device assignment when KVM
> changed its memslot removal logic to zap only the SPTEs for the memslot
> being removed.  The source of the bug is unknown at this time, and root
> causing the issue will likely be a slow process.  In the short term, fix
> the regression by zapping all SPTEs when removing a memslot from a VM
> with assigned device(s).
> 
> Fixes: 4e103134b862 ("KVM: x86/mmu: Zap only the relevant pages when removing a memslot", 2019-02-05)
> Reported-by: Alex Willamson <alex.williamson@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> 
> An alternative idea to a full revert.  I assume this would be easy to
> backport, and also easy to revert or quirk depending on where the bug
> is hiding.

We're not sure that it only happens with assigned devices; it's just
that assigned BARs are the memslots that are more likely to be
reprogrammed at boot.  So this patch feels unsafe.

Paolo

> 
>  arch/x86/kvm/mmu.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 8f72526e2f68..358b93882ac6 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -5659,6 +5659,17 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
>  	bool flush;
>  	gfn_t gfn;
>  
> +	/*
> +	 * Zapping only the removed memslot introduced regressions for VMs with
> +	 * assigned devices.  It is unknown what piece of code is buggy.  Until
> +	 * the source of the bug is identified, zap everything if the VM has an
> +	 * assigned device.
> +	 */
> +	if (kvm_arch_has_assigned_device(kvm)) {
> +		kvm_mmu_zap_all(kvm);
> +		return;
> +	}
> +
>  	spin_lock(&kvm->mmu_lock);
>  
>  	if (list_empty(&kvm->arch.active_mmu_pages))
> 

