Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9998123286
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 17:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbfLQQb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 11:31:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54611 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728238AbfLQQby (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 11:31:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576600312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p4Hn2/T4wztJ+c4sVZ6jA7HB4xZQZPe/kIKj1uFgRVk=;
        b=hNeTp5GkdBEOR7hIwvl+ypDHOC1HcZ99wV69r7OSBGcpKnLoy79v+NfGAdvv8uk6bTs+sI
        rMlD0eSaUKrC31oLqUyAp+iBAsSirS0XlPSNgX4bzsxqh0U6uCoyWoWc2PNJbBHX+eWZvH
        pxrRYBk2toAk4RHLPCTFvY2U+fiuBfI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-csAG9FpXOcObWrQQjjDuDA-1; Tue, 17 Dec 2019 11:31:51 -0500
X-MC-Unique: csAG9FpXOcObWrQQjjDuDA-1
Received: by mail-wm1-f72.google.com with SMTP id f25so1115756wmb.1
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2019 08:31:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p4Hn2/T4wztJ+c4sVZ6jA7HB4xZQZPe/kIKj1uFgRVk=;
        b=omRZZeSzBSeQN3mKeRaEame7CnnMRbfDXEGt8sIMVgE8OiJmOk0JJblfKi/raEMA79
         3E2I2QG+yBjs3zmJNdCaqi18eKhHvXbj6nkBcbTqYWYtwDrA1RzyMBXBUbW0YFE60z2B
         1B6JDcGOPIJuPKsPSvyTkLwC1mVe7NdRecBXv12+XicO4gVnAHHFJ/V4qgg30nlexzTi
         UUpZpNXvA783AxH2hvXIxRgbyCSJ8GD0HemJu6TLh1Vf0R6CG1nwgd80Cgq3xtj8JFUm
         DeMF7EDAA7ACoKSOide8vEHNlrdR+6/wuP+IErT16wWE7t0P/YyKi5U3jkLkPnUhVBu2
         twLQ==
X-Gm-Message-State: APjAAAXwCC3fpGFSOpcVI7r1C2a6AQu6O8uLtH5bKMRXnlH2nAeEyJXL
        6NCHUWcedA+VmcSQIhO1GbyLgxwgLx+NMRqUCkrSHYRut1/V45nf7eREpKa1rJikxlxEmIBUKaX
        dlVOFTSiWQGlP
X-Received: by 2002:a7b:cd84:: with SMTP id y4mr6245442wmj.57.1576600309958;
        Tue, 17 Dec 2019 08:31:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqyC2rukHVDQgKq/ZtQIpGm8enAFSLAsGkp7zQE3V9/knw3xd0UFSkx6c2y3sZBvaw/ULjXKEw==
X-Received: by 2002:a7b:cd84:: with SMTP id y4mr6245415wmj.57.1576600309736;
        Tue, 17 Dec 2019 08:31:49 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:503f:4ffc:fc4a:f29a? ([2001:b07:6468:f312:503f:4ffc:fc4a:f29a])
        by smtp.gmail.com with ESMTPSA id h2sm27209915wrt.45.2019.12.17.08.31.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 08:31:49 -0800 (PST)
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ecb949d1-4539-305f-0a84-1704834e37ba@redhat.com>
Date:   Tue, 17 Dec 2019 17:31:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191217153837.GC7258@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/12/19 16:38, Peter Xu wrote:
> There's still time to persuade me to going back to it. :)
> 
> (Though, yes I still like current solution... if we can get rid of the
>  only kvmgt ugliness, we can even throw away the per-vm ring with its
>  "extra" 4k page.  Then I suppose it'll be even harder to persuade me :)

Actually that's what convinced me in the first place, so let's
absolutely get rid of both the per-VM ring and the union.  Kevin and
Alex have answered and everybody seems to agree.

Paolo

