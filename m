Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2001E5E7F
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 13:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388425AbgE1Lja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 07:39:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54924 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388391AbgE1Lj1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 07:39:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590665966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tU/P76gUgCUjIYLmfhLoBs07Rafiz+cVEPVVpjAFAAk=;
        b=Cglb7SE0sTjcpsSBBGlNHAR5TN4Lc4W8bzWMS1OyFTXs0qEJwCXz1Cyy/DoXiPAC4I/RTc
        E+Uoke5q3hJrg5aUAcz1xmCm2jdzoRb9xIMKLhqZ1UTfBa3fM4i1LbM+lgXsYL+Mn2iJ30
        8ap2dJzkXwjzaAK/L7ArSbvzKOHQ0II=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91--eEOoEgSNAqRla3sep2Bcg-1; Thu, 28 May 2020 07:39:24 -0400
X-MC-Unique: -eEOoEgSNAqRla3sep2Bcg-1
Received: by mail-ed1-f72.google.com with SMTP id dh6so3609099edb.1
        for <kvm@vger.kernel.org>; Thu, 28 May 2020 04:39:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=tU/P76gUgCUjIYLmfhLoBs07Rafiz+cVEPVVpjAFAAk=;
        b=DJpoksvOHNn91NF5cLtIl1nMWbmJooZUm5ru5IBNmyQv+s5zCkyQDYswYCrYgN0nYH
         FBy8+mhlG2lCrgan8gsGQnXiwiGmue5QeDk3endn4mdk1q3iIt9LT+ktzvk05GAU7S3z
         Q1F+klCox5Bp0NhJaK7FoWo+rr8UXFornVodDJnO/nJ+0S/mZMbpAVmKvxY1+eyxUPpG
         K9vH0LIMuFqeQiPKd5BUJGoiOERJWKv6Ma8Sx7N2lKQUMaJgBc3ESK75FF2PNzqKHiLU
         7olzLKe5rDckBHEOkL2XS+SxYnWvWLOs3Ep13uikMBEhEBowS1q1epZooxP67008/6HR
         rTlA==
X-Gm-Message-State: AOAM530gS742Pxn+lKU/80WFCxeA1+w/Ib03Ekb1kcL04Zg6nomNdCjx
        TycJ2dU+MBR1ewPAPcP0womluEdOSNTyNY5HaBL5qZ0Wo5ijLbGcBf5SsQngQvIsVGxkZkSdaU6
        KjB1u1eigvVUB
X-Received: by 2002:aa7:c887:: with SMTP id p7mr2576190eds.269.1590665963638;
        Thu, 28 May 2020 04:39:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyAC0sFE6cKf2uAh541PEavwlw1Pez2X0cPDx1gikDvelrU7CmH5jbuidUWxsG3tn4K+fXDuQ==
X-Received: by 2002:aa7:c887:: with SMTP id p7mr2576164eds.269.1590665963456;
        Thu, 28 May 2020 04:39:23 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id i4sm4671308eja.92.2020.05.28.04.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 04:39:22 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Vivek Goyal <vgoyal@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/10] KVM: x86: acknowledgment mechanism for async pf page ready notifications
In-Reply-To: <f9d32c25-9167-f1a7-cda7-182a785b92aa@redhat.com>
References: <20200525144125.143875-1-vkuznets@redhat.com> <20200525144125.143875-7-vkuznets@redhat.com> <f9d32c25-9167-f1a7-cda7-182a785b92aa@redhat.com>
Date:   Thu, 28 May 2020 13:39:21 +0200
Message-ID: <87wo4w2sra.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 25/05/20 16:41, Vitaly Kuznetsov wrote:
>> +	case MSR_KVM_ASYNC_PF_ACK:
>> +		if (data & 0x1) {
>> +			vcpu->arch.apf.pageready_pending = false;
>> +			kvm_check_async_pf_completion(vcpu);
>> +		}
>> +		break;
>>  	case MSR_KVM_STEAL_TIME:
>>  
>>  		if (unlikely(!sched_info_on()))
>> @@ -3183,6 +3189,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>  	case MSR_KVM_ASYNC_PF_INT:
>>  		msr_info->data = vcpu->arch.apf.msr_int_val;
>>  		break;
>> +	case MSR_KVM_ASYNC_PF_ACK:
>> +		msr_info->data = 0;
>> +		break;
>
> How is the pageready_pending flag migrated?  Should we revert the
> direction of the MSR (i.e. read the flag, and write 0 to clear it)?

The flag is not migrated so it will be 'false'. This can just cause an
extra kick in kvm_arch_async_page_present_queued() but this shouldn't be
a big deal. Also, after migration we will just send 'wakeup all' event,
async pf queue will be empty. MSR_KVM_ASYNC_PF_ACK by itself is not
migrated, we don't even store it, not sure how invering it would change
things.

-- 
Vitaly

