Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005F5313518
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 15:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhBHOYh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 09:24:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37134 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233050AbhBHOVf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 09:21:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612794009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hATSdQe07kB7fmsA14JIQoTiPmshFpMhXZBEBGZDljQ=;
        b=arswWm91riZYy2eStYC3wXmWPmU97/nMIdY7e1hLSAjwyHOzLygdfA3h7avWVORjED94aM
        rbFJ40SOH6QxBy2FJWHjEWwH6OR0JDMe4utXTsswLJyXTSyPeTAJDicPn3aXRFGOxTedom
        BebtmCUq/1yi3fhaqdGz7CMpNu3VTzI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-Up0mEWckNUatwb66bxFEpg-1; Mon, 08 Feb 2021 09:20:07 -0500
X-MC-Unique: Up0mEWckNUatwb66bxFEpg-1
Received: by mail-ej1-f70.google.com with SMTP id jl9so7314379ejc.18
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 06:20:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=hATSdQe07kB7fmsA14JIQoTiPmshFpMhXZBEBGZDljQ=;
        b=dxNO9XEIEXN/NFz+Al+GtuRchijAhhHV7k1QxRZMVLyzrNB94HkVL+h5ltZFlSsygZ
         mYFD/V4PbF5o9rN75nms/W2rFmw7dPT6Vu47dO6f0mNJX9ELKeMY/sGQ7VmkRLH+Rg48
         8BgG+fmYJk1Is3NPBILdv+8k1D1xBVy5VnfPWjvasrl0rEiYzOySNibVlKuEc1shEc6N
         mHUxUtUFQdTK8l2izBWqedNm7qhGsfUdH3vmYzXx/mC8Szn3OIDxbQABH9FQHGny9PfC
         8kR7NUw9aw/IwGuBtAXKzsQJP5a64LLHLz3i6oRr1B3jnqboU+jnGWDqv4ljcY0gg5KK
         cvTA==
X-Gm-Message-State: AOAM531R23Xi490nKhHqOinXz25DDaKVQ3fejhYhSpBz5BDYSBg//9j/
        mnWddfYCl7Ge3lh2OryTy3YfZM99XuQdOy8yF/yAlxT2b+NdxwuQnKbLhWmgY5AMhvui65QWeGF
        XlPQ9zZh9MzB1
X-Received: by 2002:a17:906:a44:: with SMTP id x4mr11405848ejf.101.1612794005263;
        Mon, 08 Feb 2021 06:20:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzQAw3LhJWe3c9U7N/2uCnKHEvTx5NAWhthrgkEWsKEr+A1anLopr4CRFGH+3fHG2vcRJ/ElA==
X-Received: by 2002:a17:906:a44:: with SMTP id x4mr11405830ejf.101.1612794005077;
        Mon, 08 Feb 2021 06:20:05 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id a15sm9543494edy.86.2021.02.08.06.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 06:20:04 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 1/5] KVM: Make the maximum number of user memslots a
 per-VM thing
In-Reply-To: <538aec50-b448-fbd8-7c65-2f5a50d3874d@redhat.com>
References: <20210127175731.2020089-1-vkuznets@redhat.com>
 <20210127175731.2020089-2-vkuznets@redhat.com>
 <09f96415-b32d-1073-0b4f-9c6e30d23b3a@oracle.com>
 <877dnx30vv.fsf@vitty.brq.redhat.com>
 <5b6ac6b4-3cc8-2dc3-cd8c-a4e322379409@oracle.com>
 <34f76035-8749-e06b-2fb0-f30e295f6425@redhat.com>
 <YBL05tbdt9qupGDZ@google.com>
 <538aec50-b448-fbd8-7c65-2f5a50d3874d@redhat.com>
Date:   Mon, 08 Feb 2021 15:20:03 +0100
Message-ID: <87a6seod4c.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 28/01/21 18:31, Sean Christopherson wrote:
>> 
>>> For now I applied patches 1-2-5.
>> Why keep patch 1?  Simply raising the limit in patch 2 shouldn't require per-VM
>> tracking.
>
> Well, right you are.
>

... so are we going to raise it after all? I don't see anything in
kvm/queue so just wanted to double-check.

Thanks!

-- 
Vitaly

