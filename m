Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6CB4A68F
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 18:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729964AbfFRQQq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 12:16:46 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37833 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730011AbfFRQQm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 12:16:42 -0400
Received: by mail-wm1-f66.google.com with SMTP id f17so3895237wme.2
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 09:16:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5e9uLp89Gt+m5g88zVJ9D5G0JHLLMLu3Kl8Zr8OgjC8=;
        b=kZiuU+kfG0oLuC+8qFoIUAG/O222KLPd+rsRN9Drjfe3sfygGvkSJKnmC3PhjyFXIn
         yExIOZ2+/WbOsRAtOR19E97Pl7JMGJIjGKsYHdHHcW2OnrRkVQ5taDtkinLUkr3PdUgE
         +QPUdhUGRnQkXT7tBvTss5NZ7iWjn3BoONn7B9zUNd7FqF4Wwbr+4+X/K22ci0JWyRyN
         33iMf76HTxC70D6vg0uqWebTNJC6tTP+2Opbm0KkwzrMFriwNqDTk6BRX9OAWhh+9B+a
         880NkwCAKUB0wiKH2EVJfYqs9mnxMsBZwWkqhe6qTZeJ9+/DNJ+vNOAcktJPQ3mwMeuI
         bi5Q==
X-Gm-Message-State: APjAAAVBQ1QJkbGgMNEt3Am5yDuG/ah9ewon7KjooWGva4DOLdP24bvv
        L7QTP3E/sbczuMjYtt4FaBl1gA==
X-Google-Smtp-Source: APXvYqw1J9CwL+z6Y1GnoG219YYSsmAGstLgCwPixXpJKUR7s+TMMAsy7qhDiA6bWSLkIly4qjc0Ww==
X-Received: by 2002:a7b:c057:: with SMTP id u23mr4411268wmc.29.1560874600084;
        Tue, 18 Jun 2019 09:16:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:51c0:d03f:68e:1f6d? ([2001:b07:6468:f312:51c0:d03f:68e:1f6d])
        by smtp.gmail.com with ESMTPSA id v27sm30359654wrv.45.2019.06.18.09.16.38
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 09:16:39 -0700 (PDT)
Subject: Re: [QEMU PATCH v3 7/9] KVM: i386: Add support for save and restore
 nested state
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Cc:     qemu-devel@nongnu.org, mtosatti@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com, kvm@vger.kernel.org, jmattson@google.com,
        maran.wilson@oracle.com,
        Nikita Leshenko <nikita.leshchenko@oracle.com>
References: <20190617175658.135869-1-liran.alon@oracle.com>
 <20190617175658.135869-8-liran.alon@oracle.com>
 <20190618090316.GC2850@work-vm>
 <32C4B530-A135-475B-B6AF-9288D372920D@oracle.com>
 <20190618154817.GI2850@work-vm>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <476e9ff5-133a-4ee0-6eec-6c55c5e98dfc@redhat.com>
Date:   Tue, 18 Jun 2019 18:16:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190618154817.GI2850@work-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/06/19 17:48, Dr. David Alan Gilbert wrote:
>> Currently, KVM folks (including myself), haven’t decided yet to expose vmcs12 struct layout to userspace but instead to still leave it opaque.
>> The formal size of this size is VMCS12_SIZE (defined in kernel as 0x1000). I was wondering if we wish to expose VMCS12_SIZE constant to userspace or not.
>> So currently I defined these __u8 arrays as 0x1000. But in case Paolo agrees to expose VMCS12_SIZE, we can use that instead.
> Well if it's not defined it's bound to change at some state!
> Also, do we need to clear it before we get it from the kernel - e.g.
> is the kernel guaranteed to give us 0x1000 ?

It is defined, it is the size of data.vmx[0].vmx12.  We can define it.

Paolo
