Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B87B492165
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 09:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235312AbiARIk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 03:40:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50576 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235134AbiARIk6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 03:40:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642495257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P6JED6ZXK16zXcKezrzoJEKz/qwjTeZGQeCzB0BgpnU=;
        b=RiEWDAV3OcuiE45sjY523IQKEiL50lKdzcdimznNdEiAZwwtX40m3DNOrvuIZuD73NltPx
        cjqsdZyJsz3BSwFpxZvx37j7+BNn9FKPJI84KvexMbIh3Q8Vdfndrn8DZgF6qsrZL1tjbU
        tJd5mKkoIF5i/4ctf9mIR7dmsevljkQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-4S6kkVyJN8WZvAxDI4B5oQ-1; Tue, 18 Jan 2022 03:40:56 -0500
X-MC-Unique: 4S6kkVyJN8WZvAxDI4B5oQ-1
Received: by mail-ed1-f72.google.com with SMTP id z6-20020a50eb46000000b00403a7687b5bso510389edp.3
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 00:40:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=P6JED6ZXK16zXcKezrzoJEKz/qwjTeZGQeCzB0BgpnU=;
        b=5NBBWqiZ1f4sEm2pbVJYoPnAuoffOu4oBKppagiH77Xlp6JFZiVgzNbUL6FxoyqWTm
         BOnBkQKBgkoVFwSgsj7slnSKwkfX7O/5bTq2Ub7rEgZCgDxHoWgr23I7LdF4mbWRgbm2
         wjDccKEddOQGXfxZgMfuZjIK6VAt5lW6XhrnS/CXED5U3f+BA1QhFuClnN4IaVroiQ+T
         Rq7ixk+GTvzSYfqoMbAAC8gXW+L2HGdlUFe8m8/sgB1tt68IRlCOjeJ23niw7n0G0lPr
         5Ex+CERHAd81EHPRvviSHN3sk+ivBTLRk/TA7Gk00ldMvGgSTE8aQuKx9GDj4y/CZmy4
         rC+g==
X-Gm-Message-State: AOAM53239CzYbXFvObsVopBgj9RkKuScPnOuqM7s3n7uvxwRnal7WqLY
        0vR0hy8Y6wMgMr+bKTvznyNiz1ljZWD3EX5gegSLRQnFiD1/nog0BRp0UIEvM1q2QYA9YRNs/as
        6CUiauDxuPbRW
X-Received: by 2002:a17:906:6a1d:: with SMTP id qw29mr6640040ejc.750.1642495255457;
        Tue, 18 Jan 2022 00:40:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxy/67Tkiwq/Hb0lr+RVqCK8TWjyci7RUPTkTmpxhBNTEK2o14/AlNKQFp4PQJusHdo+BDSrA==
X-Received: by 2002:a17:906:6a1d:: with SMTP id qw29mr6640026ejc.750.1642495255261;
        Tue, 18 Jan 2022 00:40:55 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o22sm2994507eju.193.2022.01.18.00.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 00:40:54 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] KVM: x86: Partially allow KVM_SET_CPUID{,2}
 after KVM_RUN
In-Reply-To: <c427371c-474e-1233-4e57-66210bfc5687@redhat.com>
References: <20220117150542.2176196-1-vkuznets@redhat.com>
 <20220117150542.2176196-3-vkuznets@redhat.com>
 <c427371c-474e-1233-4e57-66210bfc5687@redhat.com>
Date:   Tue, 18 Jan 2022 09:40:53 +0100
Message-ID: <87pmopl9m2.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 1/17/22 16:05, Vitaly Kuznetsov wrote:
>>   
>> +/* Check whether the supplied CPUID data is equal to what is already set for the vCPU. */
>> +static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
>> +				 int nent)
>> +{
>> +	struct kvm_cpuid_entry2 *best;
>> +	int i;
>> +
>> +	for (i = 0; i < nent; i++) {
>> +		best = kvm_find_cpuid_entry(vcpu, e2[i].function, e2[i].index);
>> +		if (!best)
>> +			return -EINVAL;
>> +
>> +		if (e2[i].eax != best->eax || e2[i].ebx != best->ebx ||
>> +		    e2[i].ecx != best->ecx || e2[i].edx != best->edx)
>> +			return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>
> What about this alternative implementation:
>
> /* Check whether the supplied CPUID data is equal to what is already set for the vCPU. */
> static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
>                                   int nent)
> {
>          struct kvm_cpuid_entry2 *orig;
>          int i;
>
>          if (nent != vcpu->arch.cpuid_nent)
>                  return -EINVAL;
>
>          for (i = 0; i < nent; i++) {
>                  orig = &vcpu->arch.cpuid_entries[i];
>                  if (e2[i].function != orig->function ||
>                      e2[i].index != orig->index ||
>                      e2[i].eax != orig->eax || e2[i].ebx != orig->ebx ||
>                      e2[i].ecx != orig->ecx || e2[i].edx != orig->edx)
>                          return -EINVAL;
>          }
>
>          return 0;
> }
>
> avoiding the repeated calls to kvm_find_cpuid_entry?
>

My version is a bit more permissive as it allows supplying CPUID entries
in any order, not necessarily matching the original. I *guess* this
doesn't matter much for the QEMU problem we're trying to workaround,
I'll have to check.

-- 
Vitaly

