Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E118162A7B
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 17:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgBRQ3v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 11:29:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28004 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726444AbgBRQ3v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 11:29:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582043389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/xeFn2xogkvVTbJnDqLCWor5PNlBtKum0AFBL80A1+Q=;
        b=cO47Is+hcCu1c5DYa7K1krdGrOf7LOS1FBQO5Pr4XDINCZ3kcT/6gxr5tufh+k4Rm3HEEN
        HGjIcDiqo5ySDpQlNOwQNmbWOcjy12IB0o7e+AIxp9uSGn3EUvVLAa3RRMsT44e2rl6wgP
        EwYS8SbjS7m3LitfgGxon5qfxT03MIw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-PkqxX02zOXuAB0zV1DXflQ-1; Tue, 18 Feb 2020 11:29:48 -0500
X-MC-Unique: PkqxX02zOXuAB0zV1DXflQ-1
Received: by mail-wr1-f72.google.com with SMTP id d7so694789wrx.9
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 08:29:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=/xeFn2xogkvVTbJnDqLCWor5PNlBtKum0AFBL80A1+Q=;
        b=QaKHJSEdzUUCLYt6mHgtAeE4KmSKXKW54G3ter96GoLBqGCfKOYtt17FZWh57qxsDr
         BTYaa4E0i/4rcDKJC5Xanl+DzkJ0BYgPcabIWU41OwGPsYyZT23uVtfcpikMtLh7+etc
         s0BBMktNTJUSU3MkSqLRXlfRd297YSX9SwX4wuA+MtPTc2A3i2fXlwGkDuHeDtHBKW/9
         eP9JfnX7O4I/fmTku2w8EKFEfRokV2LtGiMI4Od5lZMkOVlXzijuFKdmRR7rK5kdzx+3
         5n6MqvBTeBpYc3Oe8psD6coRs2JRU110f56y1OLRzJNlopgDUFlekUeKXCJgeUzWCsju
         Yv6w==
X-Gm-Message-State: APjAAAUU7Hkzr4W+jbfZvVPfmyY3naNon93QlCasK/7Bf3KtKPpkPJaE
        LL3gVSdY5zRmCYgSiehJMwb2eTnJmymtm6odi9Y1nAl1+oxdLN0ObVI0+xqTxWA1+GYvqE0+CkQ
        ZW8CW95OaHZiP
X-Received: by 2002:a05:600c:21c5:: with SMTP id x5mr4126818wmj.72.1582043386465;
        Tue, 18 Feb 2020 08:29:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqyu+z4ptlYhKpFiduZBLAPpESjhfWuQywip8nwgL2XtTPQu1tJhUCSKUdBT0QweLYw1Oz5CRg==
X-Received: by 2002:a05:600c:21c5:: with SMTP id x5mr4126799wmj.72.1582043386211;
        Tue, 18 Feb 2020 08:29:46 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id x6sm4088344wmi.44.2020.02.18.08.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 08:29:45 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 1/2] KVM: X86: Less kvmclock sync induced vmexits after VM boots
In-Reply-To: <e6caee13-f8f7-596c-fb37-6120e7c25f99@redhat.com>
References: <1581988630-19182-1-git-send-email-wanpengli@tencent.com> <87r1ys7xpk.fsf@vitty.brq.redhat.com> <e6caee13-f8f7-596c-fb37-6120e7c25f99@redhat.com>
Date:   Tue, 18 Feb 2020 17:29:44 +0100
Message-ID: <87mu9f97uv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 18/02/20 15:54, Vitaly Kuznetsov wrote:
>>> -	schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
>>> -					KVMCLOCK_SYNC_PERIOD);
>>> +	if (vcpu->vcpu_idx == 0)
>>> +		schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
>>> +						KVMCLOCK_SYNC_PERIOD);
>>>  }
>>>  
>>>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>> Forgive me my ignorance, I was under the impression
>> schedule_delayed_work() doesn't do anything if the work is already
>> queued (see queue_delayed_work_on()) and we seem to be scheduling the
>> same work (&kvm->arch.kvmclock_sync_work) which is per-kvm (not
>> per-vcpu).
>
> No, it executes after 5 minutes.  I agree that the patch shouldn't be
> really necessary, though you do save on cacheline bouncing due to
> test_and_set_bit.
>

True, but the changelog should probably be updated then.

-- 
Vitaly

