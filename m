Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E2944D881
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 15:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhKKOra (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 09:47:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55579 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233729AbhKKOr3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 09:47:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636641880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9h35ss/MZV4b7BsVK6YSJJk8fuPoOjbqo9hy449dhgU=;
        b=Uz6yzdfzswbrabN4FXGSttdkKJ/Jy8KXg7AwP+h6lfT5yPl1g3H4tqJ84rB5SprioqVc/0
        kQ8uYbdDex78tftbjFPUic9ayr6zdwT+ptFaQvbcpjEXVPycxuOxPtmTCWmBh2IRzqK8x7
        lg8/H+2+NroiHHHXDBaeL/pK9vfvy/U=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-upeo5dgtNyCWNhTDtV-BkA-1; Thu, 11 Nov 2021 09:44:39 -0500
X-MC-Unique: upeo5dgtNyCWNhTDtV-BkA-1
Received: by mail-ed1-f70.google.com with SMTP id w13-20020a05640234cd00b003e2fde5ff8aso5556305edc.14
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 06:44:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9h35ss/MZV4b7BsVK6YSJJk8fuPoOjbqo9hy449dhgU=;
        b=mNJPyHOW1H8q0pRDmCcd++mHqjF7ygUO63ngs2cwDJAe7wm+RwMkl8BeH2usBjULO1
         HhYW7FXZ2lHsT7Cg9LRhL1TRfCAcHfzUsG217MrUPX/wAZqBQNSkiBKDnWRx4+t3NSac
         /Nq8edv8wyUWhOFZbzqdwKCQM/7Q5NVfblSISI8wpDGwVbF5n52K/zXlaYWZ5SA9WDOE
         ETvz03FDqOAL4Pmxlvx1gFMmMC7tXxcQpx2HJg5Ea9wopX6Zf6Il5IZwHxCiT3pFgV+c
         wfAJkjYiqJF/0rK9JltrMHegRWD9TNLiRcFCg0W/cBzfEGFDOw8NRo+ofOvsuyrHCUzU
         e/7Q==
X-Gm-Message-State: AOAM532qHn6zqW3nI8Bhi8sad6MzKAWgDtfKvEWD7v9QN54gLfRSx9Hb
        EeCe4dDtKxSEMIHNkS3qih3TQ8I5+xXll8G84U+4H4eYTpOGIy0kXHH+SnK3OAVRZC84U6ipaF/
        1d2QEzOrIQT2Z
X-Received: by 2002:a05:6402:524b:: with SMTP id t11mr10875865edd.98.1636641877899;
        Thu, 11 Nov 2021 06:44:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJymshSnBa02uZ+mhC68CkdDPxQgbf+jB00yvDwjrbLe9OLRw94VZDtbrVjyAffqcbZU9xGRQA==
X-Received: by 2002:a05:6402:524b:: with SMTP id t11mr10875844edd.98.1636641877764;
        Thu, 11 Nov 2021 06:44:37 -0800 (PST)
Received: from fedora (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m9sm1420991eje.102.2021.11.11.06.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 06:44:37 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] KVM: x86: Drop arbitraty KVM_SOFT_MAX_VCPUS
In-Reply-To: <YY0qgUqM3CuDHWgB@google.com>
References: <20211111134733.86601-1-vkuznets@redhat.com>
 <5cdb6982-d4ec-118e-2534-9498196d11b8@redhat.com>
 <YY0qgUqM3CuDHWgB@google.com>
Date:   Thu, 11 Nov 2021 15:44:36 +0100
Message-ID: <87bl2qg3aj.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Nov 11, 2021, Paolo Bonzini wrote:
>> On 11/11/21 14:47, Vitaly Kuznetsov wrote:
>> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> > index ac83d873d65b..91ef1b872b90 100644
>> > --- a/arch/x86/kvm/x86.c
>> > +++ b/arch/x86/kvm/x86.c
>> > @@ -4137,7 +4137,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>> >   		r = !static_call(kvm_x86_cpu_has_accelerated_tpr)();
>> >   		break;
>> >   	case KVM_CAP_NR_VCPUS:
>> > -		r = KVM_SOFT_MAX_VCPUS;
>> > +		r = num_online_cpus();
>
> I doubt it matters much in practice, but this really should be
>
> 		r = min(num_online_cpus(), KVM_MAX_VCPUS);
>

Nice catch, actually! It makes no sense to recommend > KVM_MAX_VCPUS. We
should fix this across all arches though, I'll take that as an action
item.

-- 
Vitaly

