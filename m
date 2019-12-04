Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E78112917
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 11:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfLDKO1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 05:14:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30088 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726899AbfLDKO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 05:14:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575454465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jaZNglZBHWh1PXOWzB13kdHQKSWZGLUFvmmlN21CdK0=;
        b=RSqp01Goo6FZSOX79wURMhjgMBdWWO/7ILKsy24sINbPe4EM3MilAtB4Aa5oa4JjXM2aZn
        7NTdCR5v4UTiMvhVWrW/aOxBVOWNI9f3IpyPwxIBuUhBHlwvRdDAjySaperCHXX83+spGq
        okNDZeYf1lWiczyJsA6KEdM272NEXo4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-UJE554_hOheA8Os7JG1QUw-1; Wed, 04 Dec 2019 05:14:22 -0500
Received: by mail-wm1-f69.google.com with SMTP id v8so2046225wml.4
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 02:14:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jaZNglZBHWh1PXOWzB13kdHQKSWZGLUFvmmlN21CdK0=;
        b=GzVUKlxUgQqQ5bT+9I9RRnIvcZYAZS3q1hK74vaYpu5xLnFG4u88thXHL+GP8E03r8
         c8+e/kjkmNEWsJzHq4ALiPUUgOn5/gvgy5EFckDwyM7pud81CVKnzcQoJkgMwLDMMx+I
         klOMi63D2lMlX7+XWflX1FEZVSBX/Pb6yi8y6brK5xNBVrCTMy7nDEQV2fLOM+2Zysme
         CkM1QEqNJlKcnpYv2tDjYBEN6KmkhM8vwuiduPyixGPjv7syprOOivq22Cr6pD7/qLTX
         3pPtVltiFJFc0V5J5IuMsiGy3dST2FQKOKUICau/4RlGEC2Beiv6jLtwpHLjRtCsVeJk
         YNTA==
X-Gm-Message-State: APjAAAWch/9JxnHjPW+4hP7oyzZvWmXBnziW8m2a0NU7T2zf9p2397tp
        Iy8RBwxsQMS4R0L8n6zpMvh3gqsxtY+ZyJNkW/WImyxnxtkrMcAhTXZf7spvf3bbE3qf1VWmHph
        2pTabWXVdr6cr
X-Received: by 2002:adf:ef92:: with SMTP id d18mr3009774wro.234.1575454461049;
        Wed, 04 Dec 2019 02:14:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqz1mQooSgrWGZALy9jHjc1l54Ros7SOKeVLepAlo+Jylrte2L011cYMVOzZALXmbTSQo50Kmg==
X-Received: by 2002:adf:ef92:: with SMTP id d18mr3009739wro.234.1575454460809;
        Wed, 04 Dec 2019 02:14:20 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a? ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id n188sm7149011wme.14.2019.12.04.02.14.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 02:14:20 -0800 (PST)
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <20191203191328.GD19877@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <24cf519e-5efa-85a7-9bc0-9be15957eb0a@redhat.com>
Date:   Wed, 4 Dec 2019 11:14:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191203191328.GD19877@linux.intel.com>
Content-Language: en-US
X-MC-Unique: UJE554_hOheA8Os7JG1QUw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/12/19 20:13, Sean Christopherson wrote:
> The setting of as_id is wrong, both with and without a vCPU.  as_id should
> come from slot->as_id.

Which doesn't exist, but is an excellent suggestion nevertheless.

>> +		/*
>> +		 * Put onto per vm ring because no vcpu context.  Kick
>> +		 * vcpu0 if ring is full.
>> +		 */
>> +		vcpu = kvm->vcpus[0];
> 
> Is this a rare event?

Yes, every time a vCPU exit happens, the vCPU is supposed to reap the VM
ring as well.  (Most of the time it will be empty, and while the reaping
of VM ring entries needs locking, the emptiness check doesn't).

Paolo

>> +		ring = &kvm->vm_dirty_ring;
>> +		indexes = &kvm->vm_run->vm_ring_indexes;
>> +		is_vm_ring = true;
>> +	}
>> +
>> +	ret = kvm_dirty_ring_push(ring, indexes,
>> +				  (as_id << 16)|slot->id, offset,
>> +				  is_vm_ring);
>> +	if (ret < 0) {
>> +		if (is_vm_ring)
>> +			pr_warn_once("vcpu %d dirty log overflow\n",
>> +				     vcpu->vcpu_id);
>> +		else
>> +			pr_warn_once("per-vm dirty log overflow\n");
>> +		return;
>> +	}
>> +
>> +	if (ret)
>> +		kvm_make_request(KVM_REQ_DIRTY_RING_FULL, vcpu);
>> +}
> 

