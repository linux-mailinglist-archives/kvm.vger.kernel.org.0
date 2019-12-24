Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D428A12A3DD
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 19:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfLXSTg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 13:19:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48160 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726183AbfLXSTg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 13:19:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577211575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=10oE3mcJxbSPeGAikLZZiyP7ObdJq49Q5FPmOfsO/dc=;
        b=PTTNo6f0N0oM84oibL1JmCjoMZ6oL4qF3OEtIlgPRrYCS9thofqO/iEuBUmBAfZkWor+Ts
        o6TnjTHppELGnwPItpT3RRxAkE75PUPZo3iO7PdGxWMRzlaPnnCcI0cLi8N+HuE9ML2jer
        08U8Q+TGpdcW2X/57A6qT556g/jISk8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-YluSQYx_P2eZ0gN1JezQhg-1; Tue, 24 Dec 2019 13:19:33 -0500
X-MC-Unique: YluSQYx_P2eZ0gN1JezQhg-1
Received: by mail-qk1-f198.google.com with SMTP id a6so10791110qkl.7
        for <kvm@vger.kernel.org>; Tue, 24 Dec 2019 10:19:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=10oE3mcJxbSPeGAikLZZiyP7ObdJq49Q5FPmOfsO/dc=;
        b=bIRAjNgM4TAVSIEHLi8eStmwYn09Y8pdGsfMjtd7kJ3w0GYJcqQJtHQ8VOodkG3YjY
         E0fsEELSjwQf2Db1HQoYB6EoDU2nCFkDMf9YAWici1ccYgeuXcNqT4NfeoyHVDS64F8g
         +RqwCoj9LpEleyT9G8iy91bYYweIZspjmsYar1R8F7iBRKe178qGqCtcYIp2JtCKngMJ
         mHc6pKAAAOR9v0be+aD3KYk2OixxbnBc67/XxU2DsZw8A752ZkJVfSXna80Fw0XOnUBA
         1uTY/kVJNEXVhxekbpSEmo6rsJtvBCl0qoxE6pHdaTyPy3jMotU5jaqF8rPY5bnXvVh6
         V4YQ==
X-Gm-Message-State: APjAAAVKguZptVNhVvyxbhWRvB9ClvsDtMe0gctfviX4x5tBSu01PkEj
        t+pEPRkk3HeKTXh0kPE/y0xq2hM2kuVRLnPuho12/XWEccdEJ1Itg5JLO89j0zKirJig2Wp/eMs
        1Y6lIR4frdj9u
X-Received: by 2002:a37:de16:: with SMTP id h22mr32000493qkj.400.1577211573533;
        Tue, 24 Dec 2019 10:19:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqyPlDOvamAwfkQQCQ/yrbEZ/IdA8BxSZxEa3M38XxUFXj9DeSRjaR1EpPHTj42i4TNzDYXwVw==
X-Received: by 2002:a37:de16:: with SMTP id h22mr32000473qkj.400.1577211573294;
        Tue, 24 Dec 2019 10:19:33 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c0:3f::2])
        by smtp.gmail.com with ESMTPSA id 63sm7087025qki.57.2019.12.24.10.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2019 10:19:32 -0800 (PST)
Date:   Tue, 24 Dec 2019 13:19:30 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v4 16/19] KVM: Ensure validity of memslot with respect to
 kvm_get_dirty_log()
Message-ID: <20191224181930.GC17176@xz-x1>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-17-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191217204041.10815-17-sean.j.christopherson@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 17, 2019 at 12:40:38PM -0800, Sean Christopherson wrote:
> +int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
> +		      int *is_dirty, struct kvm_memory_slot **memslot)
>  {
>  	struct kvm_memslots *slots;
> -	struct kvm_memory_slot *memslot;
>  	int i, as_id, id;
>  	unsigned long n;
>  	unsigned long any = 0;
>  
> +	*memslot = NULL;
> +	*is_dirty = 0;
> +
>  	as_id = log->slot >> 16;
>  	id = (u16)log->slot;
>  	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
>  		return -EINVAL;
>  
>  	slots = __kvm_memslots(kvm, as_id);
> -	memslot = id_to_memslot(slots, id);
> -	if (!memslot->dirty_bitmap)
> +	*memslot = id_to_memslot(slots, id);
> +	if (!(*memslot)->dirty_bitmap)
>  		return -ENOENT;
>  
> -	n = kvm_dirty_bitmap_bytes(memslot);
> +	kvm_arch_sync_dirty_log(kvm, *memslot);

Should this line belong to previous patch?

> +
> +	n = kvm_dirty_bitmap_bytes(*memslot);
>  
>  	for (i = 0; !any && i < n/sizeof(long); ++i)
> -		any = memslot->dirty_bitmap[i];
> +		any = (*memslot)->dirty_bitmap[i];
>  
> -	if (copy_to_user(log->dirty_bitmap, memslot->dirty_bitmap, n))
> +	if (copy_to_user(log->dirty_bitmap, (*memslot)->dirty_bitmap, n))
>  		return -EFAULT;
>  
>  	if (any)
> -- 
> 2.24.1

-- 
Peter Xu

