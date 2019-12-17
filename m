Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4444E123916
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 23:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfLQWHZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 17:07:25 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41780 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726227AbfLQWHY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Dec 2019 17:07:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576620443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=slGVCNmnwx0F1K+nCa+cID8Tdy/RHxQkOhSUfY0VX6I=;
        b=CX0x0e6HVeTxGXIkedJwytxVeqMF8bXkTPMZfNXdt5IzzzUHj0e3SpRy0EF0yW8qlz5LZY
        lNDJk0Nkp4E5PoVlcdFdqgHHDQdN+LSbOV8K0lU+71sz1cfEOy2uvQI9C3f4qZ2foQBB31
        amuOGYhpkmqxwRjYrj5Vyx7A/ycpPbY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-vD-YC3zTNtKXjRYO3rdppg-1; Tue, 17 Dec 2019 17:07:21 -0500
X-MC-Unique: vD-YC3zTNtKXjRYO3rdppg-1
Received: by mail-qv1-f69.google.com with SMTP id c22so105411qvc.1
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2019 14:07:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=slGVCNmnwx0F1K+nCa+cID8Tdy/RHxQkOhSUfY0VX6I=;
        b=X/zt4NH1+QnS1iZLH4XiYwxoDk0i1GkAjkEDt6u9ygdoiSrIO8nlKXHOMhSU7QJfsE
         KOCoK+FtKacWw425fqPkgFXCBtF8DX1TcO8i1/2pdQywC6Kr/DaI8hIFGYJBSegXQun0
         qO6mfOaKmh6tdmQaCw9G8NoryHOsE8TaBkMM3l4c6PShmtmFvQYMW3QsNsrXHPhBe8ln
         roD81hsxRHNgV+vZTm7JCDESeApHJKhav5qbn11xxpJe6OTmBe/cqi7/K62T6dS6Zl+s
         ui8X51pLcRF1IwpP/KggxPsQ3QyzYjdP04k+TMaH1BxfiUfQNJZwqifDFu5PnTSzFHbT
         pZVw==
X-Gm-Message-State: APjAAAUMclefTXP16iD+HB51fDZ1R4eLZK3kSnNU5UNiojKTl2LEZIxF
        6IUI18apViGt8vj0UMR9HjtzmhDsrUkF0jefREJaKI8MUfjGa45KpEBpoTFZmMJhgHpq8SmPIU9
        PUam1f/yv8Frq
X-Received: by 2002:a0c:f68f:: with SMTP id p15mr6885107qvn.79.1576620441551;
        Tue, 17 Dec 2019 14:07:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqyYYchEVtwDwgk4Pr56pOeSJtWkuin1D2pVTuKZ433b4vaBfoHv6+mbPiSSnU54NveRu8NnwQ==
X-Received: by 2002:a0c:f68f:: with SMTP id p15mr6885088qvn.79.1576620441243;
        Tue, 17 Dec 2019 14:07:21 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id o9sm7592950qko.16.2019.12.17.14.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:07:20 -0800 (PST)
Date:   Tue, 17 Dec 2019 17:07:18 -0500
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
Subject: Re: [PATCH v4 05/19] KVM: x86: Allocate memslot resources during
 prepare_memory_region()
Message-ID: <20191217220718.GJ7258@xz-x1>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-6-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191217204041.10815-6-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 17, 2019 at 12:40:27PM -0800, Sean Christopherson wrote:
> Allocate the various metadata structures associated with a new memslot
> during kvm_arch_prepare_memory_region(), which paves the way for
> removing kvm_arch_create_memslot() altogether.  Moving x86's memory
> allocation only changes the order of kernel memory allocations between
> x86 and common KVM code.
> 
> No functional change intended.

(I still think it's a functional change, though...)

> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

