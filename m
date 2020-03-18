Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9BA618A15D
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 18:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgCRRRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 13:17:44 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:59988 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726638AbgCRRRl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 13:17:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584551860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ElhWjdRMCoGK2Lc8uZXX8uK2whTvzsICGIGF/xooqpM=;
        b=i2tzr4YGZHmecaPbGaSSa3zpFUS87DD/pBQe3d40Cg2fgFGnxiD7FzxiaodDdyDLDTQKMx
        xe+hcNqzgBMVINJccE8nqcp3BSx2baiY2Qfx9op+f484rPNev1U8w+Nwobj5KLd0R5qj/E
        ErVaG5ZUfH5cW95A4ChmFv99EbmTwTY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-8QdJ3G-5Pv6V22wlwBWbeQ-1; Wed, 18 Mar 2020 13:17:38 -0400
X-MC-Unique: 8QdJ3G-5Pv6V22wlwBWbeQ-1
Received: by mail-wm1-f72.google.com with SMTP id z16so1337678wmi.2
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 10:17:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ElhWjdRMCoGK2Lc8uZXX8uK2whTvzsICGIGF/xooqpM=;
        b=B7cVR+OjLHGJhR+BsKsSxjiS6AFFT/RugT1zzs9uRh9Mm0N17D6QeLZqqcKbs/kytQ
         d/czBiflc4m0GOCmLs7tjrugv8uXWxM9ZOlWuAW5wWTZXzXXarPfI0AfcJx0YnhJaryD
         ZGMpMA5npqMG6rl7EfOzusLbTbZGRd/Wbr2g3+DClDkmC7VSUPMXMH8rWecdcomPr3Qn
         SgCMjQeIOcgjY/sNTIvw4jIoyUdEQ41XffG4VPT/yjwDcZs8CyBZ0WhXLPkKETdkWq73
         H48ldYZwOkow2c5ar4jlr1t8JL4/Lg2vpOQp6OX26tFfGkng9hwSo9UGx3+m7s78/cD4
         w0gA==
X-Gm-Message-State: ANhLgQ2wlevyP3OEyqmkT4/o3cIr67D/6QJxrnlpM17G6BTBR6iOFPEX
        nXGnMpAQyRFWA4XGzoi7pXsfM26T6pU13hXfffraWvyNp5+yckILip/zI/5tM1U544v/pYeOS0H
        HiuhFTVuwW0H9
X-Received: by 2002:adf:f9cd:: with SMTP id w13mr6556011wrr.406.1584551857189;
        Wed, 18 Mar 2020 10:17:37 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuLNTKjD3r3M43CNF3bs8kW9P2xtl0cL/v67E32HQFeJpZLIMHlaNw6rmfihVJhQipQ+Kn6vw==
X-Received: by 2002:adf:f9cd:: with SMTP id w13mr6555987wrr.406.1584551856929;
        Wed, 18 Mar 2020 10:17:36 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u144sm3129625wmu.39.2020.03.18.10.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 10:17:36 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v3 2/2] KVM: VMX: untangle VMXON revision_id setting when using eVMCS
In-Reply-To: <87mu8pdgci.fsf@vitty.brq.redhat.com>
References: <20200306130215.150686-1-vkuznets@redhat.com> <20200306130215.150686-3-vkuznets@redhat.com> <908345f1-9bfd-004f-3ba6-0d6dce67d11e@oracle.com> <20200306230747.GA27868@linux.intel.com> <ceb19682-4374-313a-cf05-8af6cd8d6c3b@oracle.com> <20200307002852.GA28225@linux.intel.com> <87mu8pdgci.fsf@vitty.brq.redhat.com>
Date:   Wed, 18 Mar 2020 18:17:34 +0100
Message-ID: <87r1xp1t1t.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>
>>   enum vmcs_type {
>> 	VMXON_VMCS,
>> 	VMCS,
>> 	SHADOW_VMCS,
>>   };
>>
>
> No objections from my side. v4 or would it be possible to tweak it upon
> commit?

It seems this slipped through the cracks, rebased v4 is comming to
rescue!

-- 
Vitaly

