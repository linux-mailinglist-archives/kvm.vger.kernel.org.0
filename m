Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 377E2153B2D
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 23:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbgBEWmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 17:42:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55516 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727518AbgBEWmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 17:42:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580942522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rH9hapDVBD03GESwcZDF6GjM5sGJp1/0m6Dm+I8b0N0=;
        b=JtDSey0FUdcytnDwLk7i5BQ57t9q7h12bqL0z5nUWblWZns4rdUrt8XGs9I3UhwoQ7NiX0
        D3QnHe3wdCy17Urjhv/LosxOsxbLjDLkq+nK7BWa/BgbQCXHkFTP8vV06PRRJetJ+k1yFu
        pa4uCYB0PHdEXHv4iIr3ow+Yxl48rWM=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-NXY0bi8qN3KU-gcZgK6W7Q-1; Wed, 05 Feb 2020 17:41:59 -0500
X-MC-Unique: NXY0bi8qN3KU-gcZgK6W7Q-1
Received: by mail-qt1-f197.google.com with SMTP id m8so2442140qta.20
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 14:41:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rH9hapDVBD03GESwcZDF6GjM5sGJp1/0m6Dm+I8b0N0=;
        b=g2Bf84iXV04V1aDP61vim9OrsZu+jKIWjP4Dx6NVboQyH1W9hrOmW/M/+S2zpxMRWc
         WELhIlmXWZV1rhu6aDsCl3M+OKEqZv+5w4YZxwlz+35qeKEU/AJZ/wuTia4/+XfTSjtL
         TOo8y1llF/uoa0X5MKiCDhxBiWyJwuzi1Og6HSj83GFBCwdGCfrsvhRdeH2f+tFbweik
         /HSlw9zMkUpavAD81cX5b3cogC/XEceWcBM0fvEaczXrPdBY4/1wWeZ66mwuJCAe86T5
         FOujz/t/Soy2GwipJhkVjDUJCYH4LFKY5xPRjPLrWGKa0RsdVtegPj7HYWzCkfjb91lY
         Lzog==
X-Gm-Message-State: APjAAAWJLX43lgdQRmbFAUIG/01wER1k8yYiU8VF+OZByrGyR25ESItr
        2L6ptp2tnMJFiryR8mGMngvsUhMDC2C2Ni9vlhkR2y6a49iGDyMsmANTlYbU4lX3RNauLNjiJpf
        ToSwBU1Xz98Le
X-Received: by 2002:a37:4fc3:: with SMTP id d186mr59902qkb.100.1580942518823;
        Wed, 05 Feb 2020 14:41:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqz7uhA3CGENCAtqy4g5GvmYMoxE6Qbx+Ub2ume93+vIa38OEJ1jq8Hx/Hw9ZpC1eb3usykd7Q==
X-Received: by 2002:a37:4fc3:: with SMTP id d186mr59892qkb.100.1580942518606;
        Wed, 05 Feb 2020 14:41:58 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id a201sm512222qkc.134.2020.02.05.14.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 14:41:57 -0800 (PST)
Date:   Wed, 5 Feb 2020 17:41:54 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: Re: [PATCH v5 04/19] KVM: PPC: Move memslot memory allocation into
 prepare_memory_region()
Message-ID: <20200205224154.GG387680@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-5-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200121223157.15263-5-sean.j.christopherson@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 21, 2020 at 02:31:42PM -0800, Sean Christopherson wrote:
>  static int kvmppc_core_prepare_memory_region_hv(struct kvm *kvm,
> -					struct kvm_memory_slot *memslot,
> -					const struct kvm_userspace_memory_region *mem)
> +					struct kvm_memory_slot *slot,
> +					const struct kvm_userspace_memory_region *mem,
> +					enum kvm_mr_change change)
>  {
> +	unsigned long npages = mem->memory_size >> PAGE_SHIFT;

Only in case if this patch still needs a respin: IIUC we can directly
use slot->npages below.  No matter what:

Reviewed-by: Peter Xu <peterx@redhat.com>

> +
> +	if (change == KVM_MR_CREATE) {
> +		slot->arch.rmap = vzalloc(array_size(npages,
> +					  sizeof(*slot->arch.rmap)));
> +		if (!slot->arch.rmap)
> +			return -ENOMEM;
> +	}
> +
>  	return 0;
>  }

-- 
Peter Xu

