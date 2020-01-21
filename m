Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB3FC1441D0
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 17:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbgAUQOM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 11:14:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24859 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728904AbgAUQOL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 11:14:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579623249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IqGKWE4vljjAcPx0vpPhn72zDnBvqdvK17Xs6yePlDY=;
        b=T+J8gUvRUR79f0ylxzBAq9c+kHpfP3Jd6Ccy/dp+WgeqFQBiFg1bAC9RMtUotQoRlxf8DM
        o81Y9b/zAyuQlyXuOgC8whzoD67NVzUhQWvRujGOb/tr7KtmQSmKszD12ttrB7josByHGk
        98cFg3E28nw/l/taiXlLFRze2XNlMYo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-ExTeveONMFOjb2BzYvVY1Q-1; Tue, 21 Jan 2020 11:14:05 -0500
X-MC-Unique: ExTeveONMFOjb2BzYvVY1Q-1
Received: by mail-wr1-f69.google.com with SMTP id f10so1526778wro.14
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 08:14:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IqGKWE4vljjAcPx0vpPhn72zDnBvqdvK17Xs6yePlDY=;
        b=qU2/TPWZV62tN5tJRjiRsaGcLhsk4b7RDrWge0lLBgVyKIElrxSu3PElw+Ov7ypuQb
         IZci/rncDFkgXwGNUy8RdEi31mHfwe0FTudkS54tObbq8Wf+FQABDi5apqzehWXWVwb2
         yDMD32l9dNycOa2ed05LpvhqKGv8t4u8OWxpsvwlCgegU3zF1VOFyCKy7np9B3/Q37LS
         tXokAcG5peZzz6dwoH6gBlY3xAVfkkxQkS0udJIBOTk28/4qNQBoEgIwH5Cwyj2uKogc
         9Lp/I9at6tNCpeEZLmgrx7PmF0g1kIkAM/+edjADbSpqrYt+aE0j611IMU/LCq7DO4gO
         rLCw==
X-Gm-Message-State: APjAAAU6hKibc/ZXqTGuWoH91/LmMnyqLqOLDYnpujtz5AaYYRlJeC5x
        2dlCc23anhQZJrWqPakjyLxYXVqbOQ3bETmOsdM01SWpcRx5Y7vZGUWG5TFzMh2V/l5XnrtK4He
        wyl0Mw4A9Dnbz
X-Received: by 2002:a05:600c:cd:: with SMTP id u13mr4971794wmm.24.1579623244196;
        Tue, 21 Jan 2020 08:14:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqyLcl/lYmcft/LqZTO4NiEq6Lyk5s/oCPqY3EBAJJlr/q/iZw7reeRokvq1TEUD+WfWoLmTWA==
X-Received: by 2002:a05:600c:cd:: with SMTP id u13mr4971768wmm.24.1579623243901;
        Tue, 21 Jan 2020 08:14:03 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id t8sm53079354wrp.69.2020.01.21.08.14.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 08:14:03 -0800 (PST)
Subject: Re: [PATCH v3 09/21] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-10-peterx@redhat.com>
 <20200121155657.GA7923@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c2f556fa-8562-f2d3-37a0-220af33732cd@redhat.com>
Date:   Tue, 21 Jan 2020 17:14:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200121155657.GA7923@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/20 16:56, Sean Christopherson wrote:
> This code also needs to be tested by doing unrestricted_guest=0 when
> loading kvm_intel, because it's obviously broken.

... as I had just found out after starting tests on kvm/queue.  Unqueued
this patch.

Paolo

> __x86_set_memory_region()
> takes an "unsigned long *", interpreted as a "pointer to a usersepace
> address", i.e. a "void __user **".  But the callers are treating the param
> as a "unsigned long in userpace", e.g. init_rmode_identity_map() declares
> uaddr as an "unsigned long *", when really it should be declaring a
> straight "unsigned long" and passing "&uaddr".  The only thing that saves
> KVM from dereferencing a bad pointer in __x86_set_memory_region() is that
> uaddr is initialized to NULL 

