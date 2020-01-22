Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C587414586A
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 16:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgAVPJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 10:09:02 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32933 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgAVPJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 10:09:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579705740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gs0hLkIZ3duxwFToMJ4ktrx5qsitsIbBNuQxZL9XjEY=;
        b=Mr9+gK5hSg9yTm41pnynNNIdaSwz6xJ5yYaVRJFLe4q+qjovgkqZaq/VO0UQ6iGhDouP1s
        nlP937HXra9yi8mj/ZrfkcEyshbFq1X4qLMdLDjrkUkpLoDOizqUBvdnhzU5I7eqNweqBx
        IKBbsbk97WER33G9QE9yzndi9LFdVnk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-E-lSPt_6NXSuTEzYxOXFBA-1; Wed, 22 Jan 2020 10:08:58 -0500
X-MC-Unique: E-lSPt_6NXSuTEzYxOXFBA-1
Received: by mail-wr1-f70.google.com with SMTP id v17so3160357wrm.17
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 07:08:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Gs0hLkIZ3duxwFToMJ4ktrx5qsitsIbBNuQxZL9XjEY=;
        b=tmAdUAsQqiHqx5Q2Qczd2dZeQLrJLDeJo9K9JYgyGKm5a7msb4UjH8aS6iOcVQrqyG
         tlSGwGUCJ9udwZANvsORR1h0zXF1XEOfGUmB9k/x7klRwuUdXWjHgk4FKfpWwDEUbz7s
         AkxCOfPgE/98a0+nvB2/4SgMW3JNupwhKmf3JPuY+9DMTHtcVU7KqlwRBx2+bHArFd7L
         F3cn2w4pSqWtuXdtVUVtgy2KkmL8lqerEL9wEGQo2KzKXXHnehUcxode0bXiMb6TiCzW
         EOAckginNCLvbzhypRW0p5+39qK4gH0QkrrYiFN7Pj1/Jtb4UWKuGNyM+TWx9SVRhfoP
         71EQ==
X-Gm-Message-State: APjAAAUPIsoBMogCwF566fwU07uNExz6XafqBmewDHtWP9/b1l9Rt5TX
        Ozmhy2tN6VmFyYd+0QrUw+PyOgeQcQUk2yRm/O+hZDhIIvWcBjdiifgJ8EmUF2byULEmwJ4nPpM
        22RWLO/mM2rom
X-Received: by 2002:a1c:61c1:: with SMTP id v184mr3600988wmb.160.1579705737469;
        Wed, 22 Jan 2020 07:08:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqxxHQQ7M+5VlXhyTxrA6AqZnQ80yqWJgIp5dIPVzFm5/1K8pZKKmyUgPXC6mh2/XwH9oKiihw==
X-Received: by 2002:a1c:61c1:: with SMTP id v184mr3600962wmb.160.1579705737142;
        Wed, 22 Jan 2020 07:08:57 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id b128sm4353614wmb.25.2020.01.22.07.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 07:08:56 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization out of nested_enable_evmcs()
In-Reply-To: <9c126d75-225b-3b1b-d97a-bcec1f189e02@redhat.com>
References: <20200115171014.56405-1-vkuznets@redhat.com> <20200115171014.56405-3-vkuznets@redhat.com> <6c4bdb57-08fb-2c2d-9234-b7efffeb72ed@redhat.com> <20200122054724.GD18513@linux.intel.com> <9c126d75-225b-3b1b-d97a-bcec1f189e02@redhat.com>
Date:   Wed, 22 Jan 2020 16:08:55 +0100
Message-ID: <87eevrsf3s.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 22/01/20 06:47, Sean Christopherson wrote:
>>> Yes, it most likely is and it would be nice if Microsoft fixed it, but I
>>> guess we're stuck with it for existing Windows versions.  Well, for one
>>> we found a bug in Hyper-V and not the converse. :)
>>>
>>> There is a problem with this approach, in that we're stuck with it
>>> forever due to live migration.  But I guess if in the future eVMCS v2
>>> adds an apic_address field we can limit the hack to eVMCS v1.  Another
>>> possibility is to use the quirks mechanism but it's overkill for now.
>>>
>>> Unless there are objections, I plan to apply these patches.
>> Doesn't applying this patch contradict your earlier opinion?  This patch
>> would still hide the affected controls from the guest because the host
>> controls enlightened_vmcs_enabled.
>
> It does.  Unfortunately the key sentence is "we're stuck with it for
> existing Windows versions". :(
>
>> Rather than update vmx->nested.msrs or filter vmx_get_msr(), what about
>> manually adding eVMCS consistency checks on the disallowed bits and handle
>> SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES as a one-off case by simply
>> clearing it from the eVMCS?  Or alternatively, squashing all the disallowed
>> bits.
>
> Hmm, that is also a possibility.  It's a very hacky one, but I guess
> adding APIC virtualization to eVMCS would require bumping the version to
> 2.  Vitaly, what do you think?

As I already replied to Sean I like the idea to filter out unsupported
controls from eVMCS but unfortunately it doesn't work: Hyper-V actually
expects APIC virtualization to work when it enables
SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES (I have no idea how without
apic_access_addr field but). I checked and at least Hyper-V 2016 doesn't
boot (when >1 vCPU).

-- 
Vitaly

