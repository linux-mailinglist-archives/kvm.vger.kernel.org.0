Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4833A41AB
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 14:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhFKMGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 08:06:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58371 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231553AbhFKMGD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Jun 2021 08:06:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623413045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SJDmCGSzSoN+SjlCljTi/drpSsUmCLU82T+0nPdBIYI=;
        b=e1pg4RtDKVJIWrZIsPDAdiIzKDQiTPlQ9kD3wa/bsALNmGpdZE3wA9Lcyf1wS250tQQMX2
        umMi+zEbn+jb4EcswPc41ssfq461rWnWkRKJYWpnMu2NADmWyxNtW1lIiOFC45a1XWruVc
        446ycv4RKtAanjoSYa+NnIxmgqaS4Vc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-5Q0wEw-UOg2tBgX8V-sknA-1; Fri, 11 Jun 2021 08:04:03 -0400
X-MC-Unique: 5Q0wEw-UOg2tBgX8V-sknA-1
Received: by mail-wm1-f70.google.com with SMTP id n8-20020a05600c3b88b02901b6e5bcd841so1631748wms.9
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 05:04:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SJDmCGSzSoN+SjlCljTi/drpSsUmCLU82T+0nPdBIYI=;
        b=I0u+dhetDtQDZWoyUb6DckXQGcxVs6FLHtBlW8HlLAn/n9tFHUaC20J277FM2//TC7
         s3heKc0H6+PzN9QAAAhxh6cCsm+tTHVQp4QJbaDJMJow1IKXavYckSV7NpmIIW8Ss63k
         f2iBVnHLNBUHs23ZEhsMYxsO2YP1c0/EN9qpTlFWBqtKxq1I4vvfKSEg3jYhDVie0o7M
         iqCLCBb03sbmqHRhJy4mB/uxjbucU1ZIIq+E6vCLAAZlDRjZGAEfzKkUH5K7/+arxlaH
         /URhwSIjH0TrTf6uU6QAYzG9UEPQ7/KOvv5d/uG6bWpsCAc3G9HEbgluipk2XNWgyYZ7
         vawg==
X-Gm-Message-State: AOAM532yWy9V/valTixBDVXQtR6xGPdzJyArTU1k9Ns6TIl2zvuU0row
        MFCvs6zSLjanpTO1Xg/yzeghw1nTT4aYDFtRKTvq2FZ+5cS192hLrMsaHOHVn8CQKOTYHi/5spL
        V9RUZY8q8P+Nf
X-Received: by 2002:a7b:c0cb:: with SMTP id s11mr3607780wmh.21.1623413042166;
        Fri, 11 Jun 2021 05:04:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzG2XIC2YxHXVTDi+gO8yJwV9JxmgIYE7VFZU1/ddoPOqjwHeITDdMBlqBjpf4Ks7p+wpwf+g==
X-Received: by 2002:a7b:c0cb:: with SMTP id s11mr3607733wmh.21.1623413041887;
        Fri, 11 Jun 2021 05:04:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o20sm11859481wms.3.2021.06.11.05.04.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 05:04:01 -0700 (PDT)
Subject: Re: [PATCH v7 1/4] KVM: stats: Separate generic stats from
 architecture specific ones
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20210603211426.790093-1-jingzhangos@google.com>
 <20210603211426.790093-2-jingzhangos@google.com>
 <03f3fa03-6f61-7864-4867-3dc332a9d6f3@de.ibm.com>
 <bdd315f7-0615-af69-90c3-1e5646f3e259@redhat.com>
 <c0173386-0c37-73c0-736a-e904636b6c94@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c5199e63-762d-a731-7ef2-c2af3a8cb0c3@redhat.com>
Date:   Fri, 11 Jun 2021 14:03:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <c0173386-0c37-73c0-736a-e904636b6c94@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/06/21 14:00, Christian Borntraeger wrote:
> What is the semantics of remote_tlb_flush?

I always interpreted it as "number of times the KVM page table 
management code needed other CPUs to learn about new page tables". 
Whether the broadcast is done in software or hardware shouldn't matter; 
either way I suppose there is still some traffic on the bus involved.

ARM is also not updating the stat, I'll send a patch for that.

Paolo

> For the host:
> We usually do not do remote TLB flushes in the "IPI with a flush 
> executed on the remote CPU" sense.
> We do have instructions that invalidates table entries and it will take 
> care of remote TLBs as well (IPTE and IDTE and CRDTE).
> This is nice, but on the other side an operating system MUST use these 
> instruction if the page table might be in use by any CPU. If not, you 
> can get a delayed access exception machine check if the hardware detect 
> a TLB/page table incosistency.
> Only if you can guarantee that nobody has this page table attached you 
> can also use a normal store + tlb flush instruction.
> 
> For the guest (and I guess thats what we care about here?) TLB flushes 
> are almost completely handled by hardware. There is only the set prefix 
> instruction that is handled by KVM and this flushes the cpu local cache.

