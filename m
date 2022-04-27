Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69293511DC4
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 20:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241759AbiD0QKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 12:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242788AbiD0QJy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 12:09:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D57A8492000
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 09:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651075470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KnIiu4aHbqX/cEMaulV4w/SJ9uqmiCPjBFKvPiEFRe0=;
        b=WprXT2TPiweaF750Wry+tjUJuEmboKF8/vqSkZBxZFMnBSbGyciuA/ZQUKNSL9NpYln79H
        4IdH+DG4ZpNC7oF9FBLVwX0O+yIEq9RFoPduvo1fTQkApqxqTj+39jKSj/44MLf0Rft+nE
        gzex4BGU2jS5h6/ZrA9OtvWmPbhfEsE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-4WtCj3CZPvmUblIL8wUL8w-1; Wed, 27 Apr 2022 12:04:28 -0400
X-MC-Unique: 4WtCj3CZPvmUblIL8wUL8w-1
Received: by mail-ej1-f69.google.com with SMTP id i14-20020a17090639ce00b006dabe6a112fso1404603eje.13
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 09:04:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=KnIiu4aHbqX/cEMaulV4w/SJ9uqmiCPjBFKvPiEFRe0=;
        b=y0HJZJcvbgwW3PtJyf+Yxo0KIJ8+XnJyeXBq5wrclL2+GF1gKV0Lz7+JiszQQ1WzaI
         RgOq2jYuXtPZ6InnqD41NQ3FC3Q2HvnBEjO7FEKr4x8E7jup5bpn7yu+dMjQkS6DE1wk
         Y7A6lGETgPUaUiqGppUVvTJGpRM06NNrfaGEjiDrIKZYfh6eF3hduhrTbkGXXzMvR36R
         3eXomOpgzhi0AunBMrT939hnF/H1ntYm/lqarrH0vaz3qrIZw3Ruig9dL7kROgqVSN7C
         t9ZRgfCwGJNKPVXbqz54jyCu17W0AfvruEBTkPpQIUqDCKq7boeYVt/1HgJQaGUI2P8J
         fQ/w==
X-Gm-Message-State: AOAM531HpriR7vRJJ6Vw6gHcPlhv02EC6XIb6F4RFxtQ40sOdhnN5kvP
        GMENHRkZBNIcc8JrP09LmknKThyRJV1LDdSQ106MGZRtlQfWwCAuOoTPEtZufLIN0CWGVU4hhLq
        Eztpl8NwYogMI
X-Received: by 2002:a17:907:7ea3:b0:6e8:92eb:3dcc with SMTP id qb35-20020a1709077ea300b006e892eb3dccmr27624640ejc.75.1651075466142;
        Wed, 27 Apr 2022 09:04:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqNSR4hVvkXBeP+K+imWXt9ZGbaPI48pJcmDVu7PsJz8M+Q4F+vXJ4MZ3xBab8Khy6a1oUhg==
X-Received: by 2002:a17:907:7ea3:b0:6e8:92eb:3dcc with SMTP id qb35-20020a1709077ea300b006e892eb3dccmr27624614ejc.75.1651075465846;
        Wed, 27 Apr 2022 09:04:25 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id z12-20020a50f14c000000b00425d61cbb0esm6345687edl.22.2022.04.27.09.04.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 09:04:24 -0700 (PDT)
Message-ID: <4c0edc90-36a1-4f4c-1923-4b20e7bdbb4c@redhat.com>
Date:   Wed, 27 Apr 2022 18:04:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
Cc:     John Sperbeck <jsperbeck@google.com>,
        kvm list <kvm@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220407195908.633003-1-pgonda@google.com>
 <CAFNjLiXC0AdOw5f8Ovu47D==ex7F0=WN_Ocirymz4xL=mWvC5A@mail.gmail.com>
 <CAMkAt6r-Mc_YN-gVHuCpTj4E1EmcvyYpP9jhtHo5HRHnoNJAdA@mail.gmail.com>
 <CAMkAt6r+OMPWCbV_svUyGWa0qMzjj2UEG29G6P7jb6uH6yko2w@mail.gmail.com>
 <62e9ece1-5d71-f803-3f65-2755160cf1d1@redhat.com>
 <CAMkAt6q6YLBfo2RceduSXTafckEehawhD4K4hUEuB4ZNqe2kKg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3] KVM: SEV: Mark nested locking of vcpu->lock
In-Reply-To: <CAMkAt6q6YLBfo2RceduSXTafckEehawhD4K4hUEuB4ZNqe2kKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/26/22 21:06, Peter Gonda wrote:
> On Thu, Apr 21, 2022 at 9:56 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 4/20/22 22:14, Peter Gonda wrote:
>>>>>> svm_vm_migrate_from() uses sev_lock_vcpus_for_migration() to lock all
>>>>>> source and target vcpu->locks. Mark the nested subclasses to avoid false
>>>>>> positives from lockdep.
>>>> Nope. Good catch, I didn't realize there was a limit 8 subclasses:
>>> Does anyone have thoughts on how we can resolve this vCPU locking with
>>> the 8 subclass max?
>>
>> The documentation does not have anything.  Maybe you can call
>> mutex_release manually (and mutex_acquire before unlocking).
>>
>> Paolo
> 
> Hmm this seems to be working thanks Paolo. To lock I have been using:
> 
> ...
>                    if (mutex_lock_killable_nested(
>                                &vcpu->mutex, i * SEV_NR_MIGRATION_ROLES + role))
>                            goto out_unlock;
>                    mutex_release(&vcpu->mutex.dep_map, _THIS_IP_);
> ...
> 
> To unlock:
> ...
>                    mutex_acquire(&vcpu->mutex.dep_map, 0, 0, _THIS_IP_);
>                    mutex_unlock(&vcpu->mutex);
> ...
> 
> If I understand correctly we are fully disabling lockdep by doing
> this. If this is the case should I just remove all the '_nested' usage
> so switch to mutex_lock_killable() and remove the per vCPU subclass?

Yes, though you could also do:

	bool acquired = false;
	kvm_for_each_vcpu(...) {
		if (acquired)
			mutex_release(&vcpu->mutex.dep_map, _THIS_IP_);
		if (mutex_lock_killable_nested(&vcpu->mutex, role)
			goto out_unlock;
		acquired = true;
		...

and to unlock:

	bool acquired = true;
	kvm_for_each_vcpu(...) {
		if (!acquired)
			mutex_acquire(&vcpu->mutex.dep_map, 0, role, _THIS_IP_);
		mutex_unlock(&vcpu->mutex);
		acquired = false;
	}

where role is either 0 or SINGLE_DEPTH_NESTING and is passed to 
sev_{,un}lock_vcpus_for_migration.

That coalesces all the mutexes for a vm in a single subclass, essentially.

Paolo

