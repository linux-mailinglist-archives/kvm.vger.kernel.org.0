Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA23154DDF
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 22:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbgBFVYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 16:24:39 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51629 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727519AbgBFVYj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 16:24:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581024277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mpppjCJmC0FyN5SMr7bSEAaCj98EBVmwQP8+IcdCU94=;
        b=P8d02Ph+LnLRpaB0yMM3aJBxMYy1FsnmZyD8D0aigINYNL/pAqcQJdX0Ce1aCKbJf4yIC9
        Uo5dyz1B55y6hsL3gSfecgRBuWanIDfOA1EvjXdlFJ318vMnLGk952pebgV1NVTmYRDCB8
        0KhVbVTUDNlrbBOa+JfSQ9Tf2iUoHyI=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-YTFDyCGbMoyILQ1vLJR8hA-1; Thu, 06 Feb 2020 16:24:35 -0500
X-MC-Unique: YTFDyCGbMoyILQ1vLJR8hA-1
Received: by mail-qt1-f197.google.com with SMTP id k27so138100qtu.12
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 13:24:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mpppjCJmC0FyN5SMr7bSEAaCj98EBVmwQP8+IcdCU94=;
        b=XXifLJIrMPVjiMq4MDGbKaimQIJWuxgI3wIxcfmWWdgw4HffF4IU4iMvqT8HxgKXuL
         d+f9ZnbLgiWYLyjniYZmCS87+zZOu+q2EnZlaqfUoCNbkjYi60xsvWDH+maR1aqASKb2
         G8KDsOHXNlm8ZqiqTe1jnPeQbL3Nu0vbEPPeUgjHxdIoY2v1oMrZEJMzK1813U0FzLhV
         nl9f/Zu6htECzTNR3hm7USlcKnTaleDuudWpNWduX3IuWSVQ3OENBLr0P/i1kHv4+4Kf
         x+7j/gVbnEY3iXrM2eeI9aRyHCC3CrBc3EN1oM/jLCIh6W5T1ojNKIGWgndk2Oyzb8dq
         dTXA==
X-Gm-Message-State: APjAAAUTU70RGMtI3qtQMr3AEITSYrAHsIvEPUPL78kJewGXvuDqmb2m
        Esr5rjRIeXa+aCCGCgD+9mMJESuf8pbXG+7R/bE1RJj9K71XLVB/xwWW3pJxdaT2HRNoVRmuDEm
        1fXkVNUreUr1d
X-Received: by 2002:ae9:ebd8:: with SMTP id b207mr4579991qkg.353.1581024275409;
        Thu, 06 Feb 2020 13:24:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqz5VOLMiLzF1LhwmvuD3bg8z0IeFMhpmxCeKGC9RcbBKEXcR3SRyFUKynAlxMw185+NrKLCqw==
X-Received: by 2002:ae9:ebd8:: with SMTP id b207mr4579963qkg.353.1581024275206;
        Thu, 06 Feb 2020 13:24:35 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id v78sm278695qkb.48.2020.02.06.13.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 13:24:34 -0800 (PST)
Date:   Thu, 6 Feb 2020 16:24:31 -0500
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
Subject: Re: [PATCH v5 15/19] KVM: Provide common implementation for generic
 dirty log functions
Message-ID: <20200206212431.GF700495@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-16-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200121223157.15263-16-sean.j.christopherson@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 21, 2020 at 02:31:53PM -0800, Sean Christopherson wrote:

[...]

> @@ -1333,6 +1369,7 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
>  	unsigned long i, n;
>  	unsigned long *dirty_bitmap;
>  	unsigned long *dirty_bitmap_buffer;
> +	bool flush;
>  
>  	as_id = log->slot >> 16;
>  	id = (u16)log->slot;
> @@ -1356,7 +1393,9 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
>  	    (log->num_pages < memslot->npages - log->first_page && (log->num_pages & 63)))
>  	    return -EINVAL;
>  
> -	*flush = false;
> +	kvm_arch_sync_dirty_log(kvm, memslot);

Do we need this even for clear dirty log?

> +
> +	flush = false;
>  	dirty_bitmap_buffer = kvm_second_dirty_bitmap(memslot);
>  	if (copy_from_user(dirty_bitmap_buffer, log->dirty_bitmap, n))
>  		return -EFAULT;

-- 
Peter Xu

