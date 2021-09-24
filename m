Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA634178FD
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245680AbhIXQoK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:44:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233969AbhIXQoJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:44:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SgDhT9oIEBb9h38x2W632anLjZkMC/1v2YrYWwdqtjo=;
        b=GWv/DfYStenUHkZsgAE/FRW7PTM/NH6J9CFzh7hHSD7F72OwG5/O/rs0fXBChxsSOydYdV
        jAN/lzp5/GRQJGSj9qSbow+ShpzR+/tshU+hsH7pMKFdWwppty2mDPPchgf5v8zI8MssQE
        ZQ6NXwYz6Bl0NhJnPtItvJOJALbFZXk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-Um1RtEvbN8OnwyNZnLkPng-1; Fri, 24 Sep 2021 12:42:34 -0400
X-MC-Unique: Um1RtEvbN8OnwyNZnLkPng-1
Received: by mail-ed1-f69.google.com with SMTP id e7-20020aa7d7c7000000b003d3e6df477cso10792162eds.20
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 09:42:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SgDhT9oIEBb9h38x2W632anLjZkMC/1v2YrYWwdqtjo=;
        b=YsftF4yKCXSgVTZGZyJS89dZ1RiwDuZgPgtlL88Pvjwave0hzYLdM6LNRYs5vnNcUS
         y9U4c+6cNIcBptV5GO55AYYgIdi1GyS+ezg3t5CvXVCEL22pcntNMSoULwXVHsONul8x
         qEjIED/UkH7gdDc3KwTnk+cPOXcWSvguaqrYTV13R7rYLEl1TwY3Ci06qOgtYlot8cBz
         xSZsFM+JYm9BgGcNete/gjoL0PqqupJ+ikKoUWdJAva/BnTcPNz3WRUS0SVOmNhVfKmc
         MReL353fTMru35ZcdaeP1F95Kpql5q4Ho3V7CTnzmctz2B2XTv02VUXpICTBPfDkSyZl
         LDuQ==
X-Gm-Message-State: AOAM532b9L6FegbAuwTW4jPfhTKxiW+UzPadwGTw3MdCSXaX6gzICpO7
        8PJdhekg1wWZi4Y3Bm7uu4eQ/AMFkHuA6n574PgCL5FrafqSEQBuuZyb1dDXOjtnpqb2TbeJIUX
        0/eAS55tqcgce
X-Received: by 2002:a17:906:e299:: with SMTP id gg25mr12401356ejb.339.1632501752939;
        Fri, 24 Sep 2021 09:42:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7DGgQT1CNE4utgIdHx4UNlydMmiz9dbyvTw96aDiDa+sfFGPWN4xEYMtSN4Nf+fdJ7yHHsQ==
X-Received: by 2002:a17:906:e299:: with SMTP id gg25mr12401338ejb.339.1632501752743;
        Fri, 24 Sep 2021 09:42:32 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id cf16sm420363edb.51.2021.09.24.09.42.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 09:42:31 -0700 (PDT)
Message-ID: <e6af1bc9-6018-6fd7-fcc1-098b8af0ecdc@redhat.com>
Date:   Fri, 24 Sep 2021 18:42:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v8 5/7] kvm: x86: protect masterclock with a seqcount
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-6-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210916181538.968978-6-oupton@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/09/21 20:15, Oliver Upton wrote:
> From: Paolo Bonzini<pbonzini@redhat.com>
> 
> Protect the reference point for kvmclock with a seqcount, so that
> kvmclock updates for all vCPUs can proceed in parallel.  Xen runstate
> updates will also run in parallel and not bounce the kvmclock cacheline.
> 
> nr_vcpus_matched_tsc is updated outside pvclock_update_vm_gtod_copy
> though, so a spinlock must be kept for that one.
> 
> Signed-off-by: Paolo Bonzini<pbonzini@redhat.com>
> [Oliver - drop unused locals, don't double acquire tsc_write_lock]
> Signed-off-by: Oliver Upton<oupton@google.com>
> ---

This needs a small adjustment:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 07d00e711043..b0c21d42f453 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11289,6 +11289,7 @@ void kvm_arch_free_vm(struct kvm *kvm)
  int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
  {
  	int ret;
+	unsigned long flags;
  
  	if (type)
  		return -EINVAL;
@@ -11314,7 +11315,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
  	mutex_init(&kvm->arch.apic_map_lock);
  	seqcount_raw_spinlock_init(&kvm->arch.pvclock_sc, &kvm->arch.tsc_write_lock);
  	kvm->arch.kvmclock_offset = -get_kvmclock_base_ns();
+
+	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
  	pvclock_update_vm_gtod_copy(kvm);
+	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
  
  	kvm->arch.guest_can_read_msr_platform_info = true;
  

