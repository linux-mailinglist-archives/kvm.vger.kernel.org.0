Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D9E4937E3
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 11:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353414AbiASKCw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 05:02:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40338 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353090AbiASKCr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 05:02:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642586567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=abfS2icOuWpdTxqSWF3BYTWApiC68lAeGLn8EnVYmNE=;
        b=YlbbI8pLK7jYe3sucLTEXUx1nNHLFnyKOJHBTmNP3wcRTukaXTTs4+4xKIFUksginOJdl+
        pYB8+b/KMfhf35Q80aYVYixlFqZLx7OfV/kkDls4ldfMYmLVOTJ9/UhCuYHJ46SdibSORT
        IFDELC7YFYllxLt3a6jEp9eBF1YO4ls=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-sN784ZbxNESF1Xj64s17Zg-1; Wed, 19 Jan 2022 05:02:46 -0500
X-MC-Unique: sN784ZbxNESF1Xj64s17Zg-1
Received: by mail-ed1-f71.google.com with SMTP id h11-20020a05640250cb00b003fa024f87c2so1828689edb.4
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 02:02:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=abfS2icOuWpdTxqSWF3BYTWApiC68lAeGLn8EnVYmNE=;
        b=cxLuozma2uFCAZLUFuHejNRq5w/zPeR9toEhL8doDwXst/l7BTuWbSrCNr/cMUkKzR
         md2PbqXIJlbs4qnW1sVuqb0osI31PVaxZPsT8fpmppik4PZsLnqWbOZ7Ce5/h4JhB87E
         tmVL3WuYD3WMD3KN/uq/9Mb1fav87WOZj2PtBMa+jFoIdfTKR0Tf4bGEboKBmnKUc+q4
         lbWO2N3pAoLv/QUCSZJ/RqwBwpfZhj5mhznH7gTexiQaebllLrbVUocljXhWTo34oXN4
         Y5w4FNuvSJeEyLwrXVDd/ZlR8p5UWMUZUhKe2QrpdkJxfT6oPbp24WpzQBeZb7UtZ3xM
         W7TQ==
X-Gm-Message-State: AOAM5308XXNcDsx+cQXEOBXz+zfE7+jA6GndLDplvC7uGlsk3BtykK45
        yExqhqWiKVKgAvoVJO1boGcflq4MeogzPwVdDqzFRF9yk8xjhCT0YVZjMiePZo8fYVLxh2wU1vJ
        O4IRE2nypalHd
X-Received: by 2002:a17:906:9743:: with SMTP id o3mr23422696ejy.162.1642586564792;
        Wed, 19 Jan 2022 02:02:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzKs3tvi7eu0pEo37qMQnxQYuOPsJEa/XhNVcVFXAYh96CC1F8BGlQlduqYlTUKe8iKLBUVkA==
X-Received: by 2002:a17:906:9743:: with SMTP id o3mr23422671ejy.162.1642586564494;
        Wed, 19 Jan 2022 02:02:44 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id i26sm981649edq.28.2022.01.19.02.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 02:02:44 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] KVM: x86: Partially allow KVM_SET_CPUID{,2}
 after KVM_RUN
In-Reply-To: <Yebs21Vnt4WBQBw5@google.com>
References: <20220118141801.2219924-1-vkuznets@redhat.com>
 <20220118141801.2219924-3-vkuznets@redhat.com>
 <Yebs21Vnt4WBQBw5@google.com>
Date:   Wed, 19 Jan 2022 11:02:43 +0100
Message-ID: <878rvckpq4.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Jan 18, 2022, Vitaly Kuznetsov wrote:
>> +/* Check whether the supplied CPUID data is equal to what is already set for the vCPU. */
>> +static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
>> +				 int nent)
>> +{
>> +	struct kvm_cpuid_entry2 *orig;
>> +	int i;
>> +
>> +	if (nent != vcpu->arch.cpuid_nent)
>> +		return -EINVAL;
>> +
>> +	for (i = 0; i < nent; i++) {
>> +		orig = &vcpu->arch.cpuid_entries[i];
>> +		if (e2[i].function != orig->function ||
>> +		    e2[i].index != orig->index ||
>> +		    e2[i].eax != orig->eax || e2[i].ebx != orig->ebx ||
>> +		    e2[i].ecx != orig->ecx || e2[i].edx != orig->edx)
>> +			return -EINVAL;
>
> This needs to check .flags for the above check on .index to be meaningful, and at
> that point, can't we be even more agressive and just do?
>
> 	if (memcmp(e2, vcpu->arch.cpuid_entries, nent * sizeof(e2)))
> 		return -EINVAL;
>
> 	return 0;
>

Sure, looks good to me.

>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  static void kvm_update_kvm_cpuid_base(struct kvm_vcpu *vcpu)
>>  {
>>  	u32 function;
>> @@ -313,6 +335,20 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
>>  
>>  	__kvm_update_cpuid_runtime(vcpu, e2, nent);
>> +	/*
>> +	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
>> +	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
>> +	 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
>> +	 * faults due to reusing SPs/SPTEs. In practice no sane VMM mucks with
>> +	 * the core vCPU model on the fly. It would've been better to forbid any
>> +	 * KVM_SET_CPUID{,2} calls after KVM_RUN altogether but unfortunately
>> +	 * some VMMs (e.g. QEMU) reuse vCPU fds for CPU hotplug/unplug and do
>> +	 * KVM_SET_CPUID{,2} again. To support this legacy behavior, check
>> +	 * whether the supplied CPUID data is equal to what's already set.
>
> This is misleading/wrong. KVM_RUN isn't the only problematic ioctl(),

Well, it wasn't me who wrote the comment about KVM_RUN :-) My addition
can be improved of course.

> it's just the one that we decided to use to detect that userspace is
> being stupid.  And forbidding KVM_SET_CPUID after KVM_RUN (or even all
> problematic ioctls()) wouldn't solve problem as providing different
> CPUID configurations for vCPUs in a VM will also cause the MMU to fall
> on its face.

True, but how do we move forward? We can either let userspace do stupid
things and (potentially) create hard-to-debug problems or we try to
cover at least some use-cases with checks (like the one we introduce
here).

Different CPUID configurations for different vCPUs is actually an
interesting case. It makes me (again) think about the
allowlist/blocklist approaches: we can easily enhance the
'vcpu->arch.last_vmentry_cpu != -1' check below and start requiring
CPUIDs to [almost] match. The question then is how to change CPUID for a
multi-vCPU guest as it will become effectively forbidden. BTW, is there
a good use-case for changing CPUIDs besides testing purposes?

>
>> +	if (vcpu->arch.last_vmentry_cpu != -1)
>> +		return kvm_cpuid_check_equal(vcpu, e2, nent);
>
> And technically, checking last_vmentry_cpu doesn't forbid changing CPUID after
> KVM_RUN, it forbids changing CPUID after successfully entering the guest (or
> emulating instructions on VMX).
>
> I realize I'm being very pedantic, as a well-intended userspace is obviously not
> going to change CPUID after -EINTR or whatever.  But I do want to highlight that
> this approach is by no means bulletproof, and that what is/isn't allowed with
> respect to guest CPUID isn't necessarily associated with what is/isn't "safe".
> In other words, this check doesn't guarantee that userspace can't misuse KVM_SET_CPUID,
> and on the flip side it disallows using KVM_SET_CPUID in ways that are perfectly ok
> (if userspace is careful and deliberate).

All true but I don't see a 'bulletproof' approach here unless we start
designing new KVM API for userspace and I don't think the problem here
is a good enough justification for that. Another approach would be to
name the "don't change CPUIDs after KVM_RUN at will" comment in the code
a good enough sentinel and hope that no real world userspace actually
does such things.

-- 
Vitaly

