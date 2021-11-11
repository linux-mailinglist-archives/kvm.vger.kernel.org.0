Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C072744D870
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 15:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbhKKOlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 09:41:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45161 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232182AbhKKOlL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 09:41:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636641501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J1q4Uvf4U6qAoXiM7At73lEgP58+SNlJPRqNJ0ihFIs=;
        b=DXyhZ+C3UC2UbFBfMuEDLGwauWkwNtLFPqY44GttUNavdAAlQvf1sqa2rVCE4JFtckudYh
        q5NCpyBeEfIj60TmCibnwJ1tNkd30OYZCunGv2J+8uX3fIO/9yXJZRpRGrHfnuSt/w0F2n
        MxBkKNqQA7zd2qdSC5ScR34LAtKdj7U=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-THWkGUQuMoW4lPEWqTnXHg-1; Thu, 11 Nov 2021 09:38:20 -0500
X-MC-Unique: THWkGUQuMoW4lPEWqTnXHg-1
Received: by mail-ed1-f69.google.com with SMTP id s6-20020a056402520600b003e2dea4f9b4so5558481edd.12
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 06:38:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=J1q4Uvf4U6qAoXiM7At73lEgP58+SNlJPRqNJ0ihFIs=;
        b=MqFNUmqZvWAkFB3ffvGW7xyjFWWlPsGzMmGIhiS28VdW6PIyRf+RJp4JcPzKJO68JG
         T4lzNc3UMKfo/cqZ1BjivTmxTTPX8fttlTVX37sz+V5MnNTLvxhSdb8KusfuYXkbOfg/
         LAgGS3XxUXiX49yXDA/Xp8+0uO6F0BKOpzadK/F9wYxcH66Gb1pLq5FlagD6y6Zp1Xk5
         y9obytUhpgAWumTMmGtoZvkO3bVbi8MJWn/3Vv/jaKV6G4SHsqubPe/PlsCL/lNiz+iG
         x98f/tf/r4pn4Ixu5L/EK2FC24QaOhmB7XCpwqmaS9acv5TreSUuUH+bJH7+6HkOTblg
         DsaQ==
X-Gm-Message-State: AOAM533t71RBVEpGRcK1A/aB1l5ISb9LvCnUC6j8CV/CtOgAL5H7hbMy
        zCA1VVfFGpD2uBUnphOV31opTzna6k2K7JIKOjbDZ6B0Fe6Sz9bTVZJ8+Rsp7Zy+25gF6g7CzjS
        4GRPFwweHItMI
X-Received: by 2002:a50:be87:: with SMTP id b7mr3969868edk.199.1636641499399;
        Thu, 11 Nov 2021 06:38:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyJv3i/EgL9DS1CKpFJqNtxGP0RSFq7qq5b8Rf2sK2TxZZ9PIqRJflwtjT7Y4nKNVhYjVJh3w==
X-Received: by 2002:a50:be87:: with SMTP id b7mr3969835edk.199.1636641499173;
        Thu, 11 Nov 2021 06:38:19 -0800 (PST)
Received: from fedora (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b17sm1691838edd.96.2021.11.11.06.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 06:38:18 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] KVM: x86: Drop arbitraty KVM_SOFT_MAX_VCPUS
In-Reply-To: <5cdb6982-d4ec-118e-2534-9498196d11b8@redhat.com>
References: <20211111134733.86601-1-vkuznets@redhat.com>
 <5cdb6982-d4ec-118e-2534-9498196d11b8@redhat.com>
Date:   Thu, 11 Nov 2021 15:38:17 +0100
Message-ID: <87ee7mg3l2.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 11/11/21 14:47, Vitaly Kuznetsov wrote:
>> KVM_CAP_NR_VCPUS is used to get the "recommended" maximum number of
>> VCPUs and arm64/mips/riscv report num_online_cpus(). Powerpc reports
>> either num_online_cpus() or num_present_cpus(), s390 has multiple
>> constants depending on hardware features. On x86, KVM reports an
>> arbitrary value of '710' which is supposed to be the maximum tested
>> value but it's possible to test all KVM_MAX_VCPUS even when there are
>> less physical CPUs available.
>> 
>> Drop the arbitrary '710' value and return num_online_cpus() on x86 as
>> well. The recommendation will match other architectures and will mean
>> 'no CPU overcommit'.
>> 
>> For reference, QEMU only queries KVM_CAP_NR_VCPUS to print a warning
>> when the requested vCPU number exceeds it. The static limit of '710'
>> is quite weird as smaller systems with just a few physical CPUs should
>> certainly "recommend" less.
>> 
>> Suggested-by: Eduardo Habkost <ehabkost@redhat.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> Yes, this is a good idea.  We cannot move it entirely to common code due 
> to POWER's handling of secondary threads in hypervisors; still, this is 
> as close as we can get to a common idea of what KVM_CAP_NR_VCPUS means.
>

S390's idea is also different and while I don't understand at all
all these hardware features, KVM_CAP_NR_VCPUS == KVM_CAP_MAX_VCPUS
(afaict). This was the first reason to keep KVM_CAP_NR_VCPUS handling in
arch specific code.

-- 
Vitaly

