Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C53B01232E9
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 17:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbfLQQtD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 11:49:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57277 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727443AbfLQQtD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 11:49:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576601341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=inntMxAK2pexTlpzWJhiTSeRZ9YPjzrPzvHQ9NYkXSU=;
        b=F2VqTZI7mU4FgLTbpo9m8B6zY0usr3XzwKmAUHZriHZCmyd1oOu5epW+FIZ4w/u+yiiEly
        RYsibll5JPISkSulTkyGLBlz3sOqOvpoqlHX2GNmFrhdM5CHMkKD71zSjUjpMlZvKLMNzQ
        pYWMQbZtJSbEB7dcEGsBvTpQwy9aR2M=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-dbrlkABwN4WRKc1Rjf45sw-1; Tue, 17 Dec 2019 11:49:00 -0500
X-MC-Unique: dbrlkABwN4WRKc1Rjf45sw-1
Received: by mail-wm1-f72.google.com with SMTP id w205so1127244wmb.5
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2019 08:49:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=inntMxAK2pexTlpzWJhiTSeRZ9YPjzrPzvHQ9NYkXSU=;
        b=dnINjE5zs58HOBFojwKrEFCFJpREKbLIilXseX9saD+WP/8F2O+6kX84rQfMG+yEEz
         vNYJrDwGd2tKvhqsSJMwM9mlTJxX4j6K3Q1T7FNs6GWZ9RH/n0qzbqOClafsvMMOs8vv
         bCs0y/nhF4vonGAsbv+ydZc8KSJ/k6HzxvZCBBnqG5pPR85GrBO9T7WRlXpEOEs0eAEt
         lXW9ZR+GPE4T4qqXKuXL2EzUV8w9b88ByGr7++QuLYOMu3NU5cjUny2CDfLCK0TUuG3y
         ahYmyLjwdCiqdpR5Ad0gOQch/Q8s2QgO2csqRNNFqd3zThS7AZ5whI0h1ekxT6w6UxzP
         ixTg==
X-Gm-Message-State: APjAAAXR8THtP1ix0dB7GS3PryS4xnPGAsekfzYGbtyvPWPcc1UXmWnF
        9Rh9JnDzpL3dkFSqwf8/9UXg+iJ3Gc/HND7wZ6xp9UobcGM3pMXDhQ9VJNASUE0NhdIwcSxlZl8
        CtLU1kmnMdffv
X-Received: by 2002:a1c:1b15:: with SMTP id b21mr6106783wmb.17.1576601339222;
        Tue, 17 Dec 2019 08:48:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqx76pZ2UcGbn63XX4R4mlXgxOp67LblWwPXb/NG1+fS2tu+dMszUBFiT4MoSrPMR5Uz8a85tQ==
X-Received: by 2002:a1c:1b15:: with SMTP id b21mr6106762wmb.17.1576601338997;
        Tue, 17 Dec 2019 08:48:58 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:503f:4ffc:fc4a:f29a? ([2001:b07:6468:f312:503f:4ffc:fc4a:f29a])
        by smtp.gmail.com with ESMTPSA id f1sm26022621wro.85.2019.12.17.08.48.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 08:48:58 -0800 (PST)
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
To:     Peter Xu <peterx@redhat.com>
Cc:     Christophe de Dinechin <dinechin@redhat.com>,
        Christophe de Dinechin <christophe.de.dinechin@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com> <m1lfrihj2n.fsf@dinechin.org>
 <20191213202324.GI16429@xz-x1>
 <bc15650b-df59-f508-1090-21dafc6e8ad1@redhat.com>
 <E167A793-B42A-422D-8D46-B992CB6EBE69@redhat.com>
 <d59ac0eb-e65a-a46f-886e-6df80a2b142f@redhat.com>
 <20191217153837.GC7258@xz-x1>
 <ecb949d1-4539-305f-0a84-1704834e37ba@redhat.com>
 <20191217164244.GE7258@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c6d00ced-64ff-34af-99dd-abbcbac67836@redhat.com>
Date:   Tue, 17 Dec 2019 17:48:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191217164244.GE7258@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/12/19 17:42, Peter Xu wrote:
> 
> However I just noticed something... Note that we still didn't read
> into non-x86 archs, I think it's the same question as when I asked
> whether we can unify the kvm[_vcpu]_write() interfaces and you'd like
> me to read the non-x86 archs - I think it's time I read them, because
> it's still possible that non-x86 archs will still need the per-vm
> ring... then that could be another problem if we want to at last
> spread the dirty ring idea outside of x86.

We can take a look, but I think based on x86 experience it's okay if we
restrict dirty ring to arches that do no VM-wide accesses.

Paolo

