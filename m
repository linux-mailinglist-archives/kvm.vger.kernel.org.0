Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8803143AEE
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 11:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbgAUKZg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 05:25:36 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26518 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728797AbgAUKZf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 05:25:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579602334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oTqyG9FV9F3Gftaw3MKdGBixjFpBO7jrDVlvtMm1XMI=;
        b=RAjnN9UduCzMQCEddF2s8Z4OGL61aQqpkHR41oHLCvI6cQzVtTvwD3P4/KguSwXL6dmfBe
        NeEysZtgsXo3Q93/CPhkvon8WdVvSmuW4Mcfi70Pp1OUkQnI001jTgt/CSDYCr2JJb82/F
        pb/jZKW2CRIHpNOdvV9aMJoT1l6LNek=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248--iceqz3dNGqK9sdAtl0xSQ-1; Tue, 21 Jan 2020 05:25:32 -0500
X-MC-Unique: -iceqz3dNGqK9sdAtl0xSQ-1
Received: by mail-wr1-f70.google.com with SMTP id i9so1121433wru.1
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 02:25:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oTqyG9FV9F3Gftaw3MKdGBixjFpBO7jrDVlvtMm1XMI=;
        b=DnsnDf9YrK5jN+Iey2CrWxaYYzYzf/47ljlT+ZH3kpshWm5ZQlQ6aVRp16cqDK+QCS
         nkqZ+dSC0GPJCa9rQKmGegWx9RrvpD5qNewF83OolaBvnBBDKJu136NFS6cenrEqJHvM
         yFkooZvs9yMBJSDeG4qqI5RTf+MzxVfah8HFTBHJmp4bqqF3RqfKRW+dDkVGZ8v3bKW5
         5hnu6Uz9On4GbLZVLJNIA6iM8tc9aA6IJKnG/k15wRS6tCsPJi72RNffh+LGX6UOoaod
         g6LzMhxO9BzjZg5R5wshCnQwLAu9bhp0iZ3LJFf+qqhV2FKLzfs1RRssNBiBhiguiBeP
         4wVA==
X-Gm-Message-State: APjAAAXRxWjqBRHfRF2X2Dp+h8lw9n8zKChAjKhxKBrG+9eHfdYvMvGU
        9Z1SVIWzeOBTYb2Zlz3DlB490EHzFT+oQZ+7qIL1H7i3DhkwrVgMN3AyJaP8cGCclmAMucZw8EV
        pUBXl7kFGPNpN
X-Received: by 2002:a1c:4b09:: with SMTP id y9mr3638744wma.103.1579602331149;
        Tue, 21 Jan 2020 02:25:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqx5TapOgQyy7Hd7YKdK3/8GL73X+vODGmGxX65zJSEY6VdLBvTxmNhberwnJtChT/tzehYexg==
X-Received: by 2002:a1c:4b09:: with SMTP id y9mr3638716wma.103.1579602330847;
        Tue, 21 Jan 2020 02:25:30 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id a14sm55297165wrx.81.2020.01.21.02.25.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 02:25:30 -0800 (PST)
Subject: Re: [PATCH v3 12/21] KVM: X86: Implement ring-based dirty memory
 tracking
To:     Peter Xu <peterx@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-13-peterx@redhat.com>
 <20200109110110-mutt-send-email-mst@kernel.org>
 <20200109191514.GD36997@xz-x1>
 <22bcd5fc-338c-6b72-2bda-47ba38d7e8ef@redhat.com>
 <20200119051145-mutt-send-email-mst@kernel.org>
 <20200120072915.GD380565@xz-x1>
 <20200120024717-mutt-send-email-mst@kernel.org>
 <20200121082925.GB440822@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bb6cb50e-738a-b1e6-a407-42c1228a6d22@redhat.com>
Date:   Tue, 21 Jan 2020 11:25:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200121082925.GB440822@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/20 09:29, Peter Xu wrote:
>>>> If we are short on bits we can just use 1 bit. E.g. set if
>>>> userspace has collected the GFN.
>>> I'm still unsure whether we can use only one bit for this.  Say,
>>> otherwise how does the userspace knows the entry is valid?  For
>>> example, the entry with all zeros ({.slot = 0, gfn = 0}) could be
>>> recognized as a valid dirty page on slot 0 gfn 0, even if it's
>>> actually an unused entry.
>> So I guess the reverse: valid entry has bit set, userspace sets it to
>> 0 when it collects it?
> Right, this seems to work.

Yes, that's okay too.

Paolo

