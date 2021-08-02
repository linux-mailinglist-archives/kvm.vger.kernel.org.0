Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751483DDBAF
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 16:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234223AbhHBO6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 10:58:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46151 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233981AbhHBO6c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 10:58:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627916302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ok5kbJTrTR3AnuP5Nxutzf0dfR4tIT9TcuJEsfYZW8Y=;
        b=GGCCBZpe2uMWN+Evp5yDosk0PlSNlgun6cMOhA8UKSnSpvPY81ffJHkEwGptIXY9eKozTI
        YsYwCoGiTrAdC7L35bA9nCKCd9hcvfjV9f9S6DeJ/dhgu791sHiAKqbZ5gGrisFpt9ffWd
        ocrEdRmuyFcULtx3HG8aQXh2gR2pOeg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-OECrdn-HOPCycIGGqShiKA-1; Mon, 02 Aug 2021 10:58:21 -0400
X-MC-Unique: OECrdn-HOPCycIGGqShiKA-1
Received: by mail-wm1-f72.google.com with SMTP id c2-20020a7bc8420000b0290238db573ab7so5164570wml.5
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 07:58:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ok5kbJTrTR3AnuP5Nxutzf0dfR4tIT9TcuJEsfYZW8Y=;
        b=ZHDmc5S0SYYaKUOlhM9XTktxBZ0sQwWCc0ZMIL3S78UqQNyCpxVhgiNAnK1dBSXaB6
         uG50f9L6m3uJxgVLepOs9COrbQgahtTQeRcCtqr+ajd4ETp82YfWl12+VH5QH2dncSFn
         t56y0Wt1+tKUW7c54ROlVKXX6yUF+rWAKcRBXtFYsiwKoLtGlU7eKLKu0YsA23jd4ENx
         cWvvg6/hZYcfjpdzM2rb3aIX5MQ9qOcUktPpRgWRGy88fn1VFPqSs1Pxq6EqcUCuS5x/
         GogW8HyMZYDzYzXscoCE4ELeBTu5+SGD2LxMSWrxvG5QQNFE4cEIfbZkhR3E9zJkI1p+
         yF0w==
X-Gm-Message-State: AOAM531HIimBOtIsZlJEjtm4mpQoSLkYR/ChQGmNWaE/VJMRY0lAxVtr
        qdt+h0SYFBeGNLXAZ7zscAF/aVbCZTNBE+y324ctVKcLEMrJvIkGKQgtEdXvH7xZYMFeUCnmwrf
        6VdqZPKo87pk+
X-Received: by 2002:adf:fe44:: with SMTP id m4mr10350591wrs.133.1627916299878;
        Mon, 02 Aug 2021 07:58:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8t1/u91T6M6NDOoz/0fFto5pSUi0Klz29RUOpCv+koYT8oRGtTWPAuglrU6cvcIkXAg4ctQ==
X-Received: by 2002:adf:fe44:: with SMTP id m4mr10350571wrs.133.1627916299655;
        Mon, 02 Aug 2021 07:58:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w10sm9761466wrr.23.2021.08.02.07.58.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 07:58:19 -0700 (PDT)
To:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
References: <20210730223707.4083785-1-dmatlack@google.com>
 <20210730223707.4083785-4-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/6] KVM: x86/mmu: Speed up dirty logging in
 tdp_mmu_map_handle_target_level
Message-ID: <279056b0-38c0-6ee4-c581-e2328c120b2e@redhat.com>
Date:   Mon, 2 Aug 2021 16:58:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210730223707.4083785-4-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/21 00:37, David Matlack wrote:
> -	if (new_spte == iter->old_spte)
> +	if (new_spte == iter->old_spte) {
>   		ret = RET_PF_SPURIOUS;
> -	else if (!tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
> -		return RET_PF_RETRY;
> +	} else {
> +		if (!tdp_mmu_set_spte_atomic_no_dirty_log(vcpu->kvm, iter, new_spte))
> +			return RET_PF_RETRY;
> +
> +		/*
> +		 * Mark the gfn dirty here rather that through the vcpu-agnostic
> +		 * handle_changed_spte_dirty_log to leverage vcpu->lru_slot_index.
> +		 */
> +		if (is_writable_pte(new_spte))
> +			kvm_vcpu_mark_page_dirty(vcpu, iter->gfn);
> +	}

Looking at the remaining callers of tdp_mmu_set_spte_atomic we have:

* tdp_mmu_zap_spte_atomic calls it with REMOVED_SPTE as the new_spte, 
which is never writable

* kvm_tdp_mmu_map calls it for nonleaf SPTEs, which are always writable 
but should not be dirty.


So I think you should:

* change those two to tdp_mmu_set_spte_atomic_no_dirty_log

* add a WARN_ON_ONCE(iter->level > PG_LEVEL_4K) to tdp_mmu_set_spte_atomic

* put the kvm_vcpu_mark_page_dirty code directly in 
tdp_mmu_set_spte_atomic, instead of the call to 
handle_changed_spte_dirty_log

(I can't exclude I'm missing something though).

Paolo

