Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9247162A27
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 17:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgBRQNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 11:13:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35400 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726360AbgBRQNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 11:13:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582042411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aUcg10FdEyJIOkhd/+uHQ8iOxzxoVvPYFFS92dJuc98=;
        b=HO3lfn7GgM7rSNvTusN08tLiIakm1aCMCMBmr2UpoEfUUwBNkSFl92xO6OAfJs/ovCAPQc
        XVT9syU3vXsAlJqjU8o0Tt5PpeEblA+njxebSS4SwCFC1ykcYqpKH9yMGnkBEmz+jWPItz
        +TsTOz2zLqs8iVk7PgK5LqZEzlnRmRk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-5kYdmzOjPUuy3jYIotm9jQ-1; Tue, 18 Feb 2020 11:13:30 -0500
X-MC-Unique: 5kYdmzOjPUuy3jYIotm9jQ-1
Received: by mail-wm1-f69.google.com with SMTP id n17so271438wmk.1
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 08:13:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aUcg10FdEyJIOkhd/+uHQ8iOxzxoVvPYFFS92dJuc98=;
        b=ftIHsHZADdRWq0wv1+CGUN1WB7upm52+9EQEGEFAEUA466dLm01hAYeSjy/x5JdZ6N
         tx5HNBNKzqwdxXsdihCsMvLb/XY47MicQSiY1WGDYjRWcw3MeubOqKUvDOoiOISNnQEf
         x+QA/YzAduPfIVEOQdLeX4XUdwSyoljpoP+1kcMnI8l2bfp7EcAcJeX1+u6Ww0G4W7Tz
         92UOeOYKip8AP/O61oybtagz2tkaEMQzyr3NwkR/EuN22DJWwrRAsFp/tksjNWwQppZe
         DlF4Q2eOFjnpRJIfRdra/eg/x0IU8lIAZTsVi/F1jNsBIJmz46XZ+BeOZjDxRPH2IWcz
         2teA==
X-Gm-Message-State: APjAAAVj0VTd8QlTm2fELnwHek6quDBXE/OhjcpTibiBh5znlgdFZLT3
        3+hC1V449tv1Fb1gEEHKW9/H/g5KycaaFsPuwOMtMO/wqEXTvsHGIqHUaKBrvs8vH8HQcPPGuX9
        1XjJl8ZNN6uP2
X-Received: by 2002:a5d:54c1:: with SMTP id x1mr28817002wrv.240.1582042409155;
        Tue, 18 Feb 2020 08:13:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqyXedi7AlcavweAMf9+HWzGYgsGQvODoyFLpJ3gqcUvGuepwCqYrQV3b+k+aJVwDB3HEPYLpA==
X-Received: by 2002:a5d:54c1:: with SMTP id x1mr28816980wrv.240.1582042408937;
        Tue, 18 Feb 2020 08:13:28 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id x6sm6698593wrr.6.2020.02.18.08.13.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 08:13:28 -0800 (PST)
Subject: Re: [PATCH RFC] target/i386: filter out VMX_PIN_BASED_POSTED_INTR
 when enabling SynIC
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>, kvm@vger.kernel.org
References: <20200218144415.94722-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9b4b46c2-e2cf-a3d5-70e4-c8772bf6734f@redhat.com>
Date:   Tue, 18 Feb 2020 17:13:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200218144415.94722-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/02/20 15:44, Vitaly Kuznetsov wrote:
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> RFC: This is somewhat similar to eVMCS breakage and it is likely possible
> to fix this in KVM. I decided to try QEMU first as this is a single
> control and unlike eVMCS we don't need to keep a list of things to disable.

I think you should disable "virtual-interrupt delivery" instead (which
in turn requires "process posted interrupts" to be zero).  That is the
one that is incompatible with AutoEOI interrupts.

The ugly part about fixing this in QEMU is that in theory it would be
still possible to emulate virtual interrupt delivery and posted
interrupts, because they operate on a completely disjoint APIC
configuration than the host's.  I'm not sure we want to go there though,
so I'm thinking that again a KVM implementation is better.  It
acknowledges that this is just a limitation (workaround for a bug) in KVM.

Paolo

