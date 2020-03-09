Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0B417DC81
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 10:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgCIJbr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 05:31:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31488 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726702AbgCIJbq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 05:31:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583746305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bAxovC+YmLxqKmhTg+wnldWy/2Z+UUqMLgm0E3zQGuQ=;
        b=DFHk3IxUINZwdC2JpdGtGAVJp42jIMbIAhgu+s8O/DwLVGNDdgpFa8JKszs30lFWl5udY/
        yPpJxbhD6j1q8Aqrqj4PAeyi8eDd7uyOOyXKlwvs3XcJ9/SNUW/uIM0x0yJKMODk3WcXR/
        qXNowZ+wWedVGuFdSzjrM8Z5SLjZ/iM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-pUjni2_1OfCYnXksBz3CpQ-1; Mon, 09 Mar 2020 05:31:43 -0400
X-MC-Unique: pUjni2_1OfCYnXksBz3CpQ-1
Received: by mail-wm1-f72.google.com with SMTP id i16so2289942wmd.9
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 02:31:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=bAxovC+YmLxqKmhTg+wnldWy/2Z+UUqMLgm0E3zQGuQ=;
        b=lvGE4+Qpx0TTAVrnCdME+JNwvCgRgz55qKHD/7+C2fJMJEL9iKHCo1hQtg3pqQv+0O
         JBIJ/EkvMDaD96YZ+7Yb+EmiatK7F3+exE0zd2SC4uPVt3Gqh1dkKQGAlIvppS8nW6YI
         qOWXsSILUBmK1g4/yopGCAa+fyPu+ox6yDn3mHK5QclzyPBMploWEMTKeN9Na21RFZ+f
         Rxsrkg/eZWis9HJfvB6lr/LHBlEyJjTd1+GPqM6ePO+KIZZW8eC6B3yuDPIxHbH6RbYU
         K7VCs5TGPmRjqPgVjd3Brttyt6L8XPyDZezXwrAUjyourM6Cb4MwcjiDrVxGVNI0nrf7
         jGCA==
X-Gm-Message-State: ANhLgQ3IqeSL6GexDFEGP1KnjIVtOYLwr4qdFN0eppadOHz4oBtwW2Yy
        otHt9TFwsEKqf1/mCDl2JRkIJDoHjLKEvT35ShbXk3u7APa698un+a6fEK9iDIEc8J6YfARSS5F
        8kz3/6nq7znip
X-Received: by 2002:a05:600c:215:: with SMTP id 21mr19153914wmi.119.1583746302712;
        Mon, 09 Mar 2020 02:31:42 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vukk69NSM339Baa9gmzJoWipsNi+hBKkDBAew96ERxS+NgbmmfnSmY3RZMXrY0CvF3CeTM9/w==
X-Received: by 2002:a05:600c:215:: with SMTP id 21mr19153896wmi.119.1583746302471;
        Mon, 09 Mar 2020 02:31:42 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id d15sm59386303wrp.37.2020.03.09.02.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 02:31:41 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] KVM: VMX: untangle VMXON revision_id setting when using eVMCS
In-Reply-To: <20200307002852.GA28225@linux.intel.com>
References: <20200306130215.150686-1-vkuznets@redhat.com> <20200306130215.150686-3-vkuznets@redhat.com> <908345f1-9bfd-004f-3ba6-0d6dce67d11e@oracle.com> <20200306230747.GA27868@linux.intel.com> <ceb19682-4374-313a-cf05-8af6cd8d6c3b@oracle.com> <20200307002852.GA28225@linux.intel.com>
Date:   Mon, 09 Mar 2020 10:31:41 +0100
Message-ID: <87mu8pdgci.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

>   enum vmcs_type {
> 	VMXON_VMCS,
> 	VMCS,
> 	SHADOW_VMCS,
>   };
>

No objections from my side. v4 or would it be possible to tweak it upon
commit?

-- 
Vitaly

