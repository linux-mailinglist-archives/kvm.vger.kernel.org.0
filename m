Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60503DC662
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 15:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393921AbfJRNnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Oct 2019 09:43:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51823 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388989AbfJRNnO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Oct 2019 09:43:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571406192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=avekW70KdpjMc4FyUCIX6gB40ry+NKr1jUqoVsBz8lA=;
        b=gz4SsWiejBc0717a4byoXCvZUuoz5lKdCVm7cTUblJlNO7HsBvduSIyMG24SjxdTFuUTWb
        e32c6jgVDP7aPCbb2Oaq6qy2VJ1i/86G7baAxKo5hvb+kym+vAunYMCAKcSO9kZe0V7cdi
        XQwTGzcmuY13ecupA7waRxjskJZ5lJY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-AZxbxpDLMg6sCTVOOVbaQg-1; Fri, 18 Oct 2019 09:42:59 -0400
Received: by mail-wr1-f71.google.com with SMTP id v7so763990wrf.4
        for <kvm@vger.kernel.org>; Fri, 18 Oct 2019 06:42:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PSGpxdY2p0addAHAYiert9spAPvfigx6YTt+FOH1FXs=;
        b=Nxyygk/o7ep9dLkxRXCpl9d3qwBot9zdxafzgMAYg60mcx//xnluNDbCXcmoOqy2VK
         b1L9R0iE3wTdmaeyTA96s0Sl0WwlJ81+aWRigxxPHTzxm2sayaGDmcCfOIQ8oHSL/bZj
         DCtQI5N6J6lQmknzhdTlamvD9VQ3pZ6Uwx+7UuCLzwStI1wT1RZVYyMmEk8a3XnPuFIO
         CHAMNxgAkECoNniYLeskoMQfijXBxEX0aig8uzYWOaKxjFDE/ofAvrzxPlIT08lV0Xq2
         Eew0M3WiucnCoKf5FxbUmzAnraug1rlgBi7RBjeqcDvw34UKuoGjO/7nUJOt7n6Up7hE
         qJew==
X-Gm-Message-State: APjAAAXxvY4FRlZ5Y8ldZ9n8ONnfBuOS5lb77M5Kd/bH3mYNauxSV6pq
        q4M/WDpO6ijFHTNhJgReHmUQSV8HEYYZv3Xz+Fngw6vZzjVIx6EDjhUh15PLHyXt7XWbfPrchzC
        po+JSE4Rih+zY
X-Received: by 2002:adf:f152:: with SMTP id y18mr8172896wro.285.1571406178383;
        Fri, 18 Oct 2019 06:42:58 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyaIWZ6txvBwpjhI2bDGBt808E/H69KU1rYAb5fnDTWOgKNDuk3yaDaWG2nfZo1hkeNcBz9Mw==
X-Received: by 2002:adf:f152:: with SMTP id y18mr8172875wro.285.1571406178083;
        Fri, 18 Oct 2019 06:42:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:fb:851b:6f64:49ab? ([2001:b07:6468:f312:fb:851b:6f64:49ab])
        by smtp.gmail.com with ESMTPSA id l6sm6444472wmg.2.2019.10.18.06.42.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Oct 2019 06:42:57 -0700 (PDT)
Subject: Re: [RFC PATCH 00/28] kvm: mmu: Rework the x86 TDP direct mapped case
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
References: <20190926231824.149014-1-bgardon@google.com>
 <20191017185002.GG20903@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <8613605a-3e6e-ce8e-f2af-25bef2703348@redhat.com>
Date:   Fri, 18 Oct 2019 15:42:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191017185002.GG20903@linux.intel.com>
Content-Language: en-US
X-MC-Unique: AZxbxpDLMg6sCTVOOVbaQg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/19 20:50, Sean Christopherson wrote:
> On Thu, Sep 26, 2019 at 04:17:56PM -0700, Ben Gardon wrote:
>> Over the years, the needs for KVM's x86 MMU have grown from running smal=
l
>> guests to live migrating multi-terabyte VMs with hundreds of vCPUs. Wher=
e
>> we previously depended upon shadow paging to run all guests, we now have
>> the use of two dimensional paging (TDP). This RFC proposes and
>> demonstrates two major changes to the MMU. First, an iterator abstractio=
n=20
>> that simplifies traversal of TDP paging structures when running an L1
>> guest. This abstraction takes advantage of the relative simplicity of TD=
P
>> to simplify the implementation of MMU functions. Second, this RFC change=
s
>> the synchronization model to enable more parallelism than the monolithic
>> MMU lock. This "direct mode" MMU is currently in use at Google and has
>> given us the performance necessary to live migrate our 416 vCPU, 12TiB
>> m2-ultramem-416 VMs.
>>
>> The primary motivation for this work was to handle page faults in
>> parallel. When VMs have hundreds of vCPUs and terabytes of memory, KVM's
>> MMU lock suffers from extreme contention, resulting in soft-lockups and
>> jitter in the guest. To demonstrate this I also written, and will submit
>> a demand paging test to KVM selftests. The test creates N vCPUs, which
>> each touch disjoint regions of memory. Page faults are picked up by N
>> user fault FD handlers, one for each vCPU. Over a 1 second profile of
>> the demand paging test, with 416 vCPUs and 4G per vCPU, 98% of the
>> execution time was spent waiting for the MMU lock! With this patch
>> series the total execution time for the test was reduced by 89% and the
>> execution was dominated by get_user_pages and the user fault FD ioctl.
>> As a secondary benefit, the iterator-based implementation does not use
>> the rmap or struct kvm_mmu_pages, saving ~0.2% of guest memory in KVM
>> overheads.
>>
>> The goal of this  RFC is to demonstrate and gather feedback on the
>> iterator pattern, the memory savings it enables for the "direct case"
>> and the changes to the synchronization model. Though they are interwoven
>> in this series, I will separate the iterator from the synchronization
>> changes in a future series. I recognize that some feature work will be
>> needed to make this patch set ready for merging. That work is detailed
>> at the end of this cover letter.
>=20
> Diving into this series is on my todo list, but realistically that's not
> going to happen until after KVM forum.  Sorry I can't provide timely
> feedback.

Same here.  I was very lazily waiting to get the big picture from Ben's
talk.

Paolo

