Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311DE38E87D
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 16:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbhEXOOR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 10:14:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55072 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232662AbhEXOOQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 10:14:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621865567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YuolNKAChmee9Jf+0VWBlg4DUVbOcHignWbWcealYiA=;
        b=WkJaulk3XLuzVtNE9P0KFcZwwa1PlwmERjdneJgy05sou6c54dFYGdw6haOHI0EHgVF48D
        qIrzmnZ2X6Ti6+y0C39eblPgGZecpQMQZssj9803rnmpFz5DpClQwU44/SAEtsU3eDR0DC
        m27SxWioVe94EkgzX47wz1NadGFZRK4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-9DgqhiNtMIS996bNg7X-WQ-1; Mon, 24 May 2021 10:12:46 -0400
X-MC-Unique: 9DgqhiNtMIS996bNg7X-WQ-1
Received: by mail-wr1-f70.google.com with SMTP id n2-20020adfb7420000b029010e47b59f31so13045387wre.9
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 07:12:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YuolNKAChmee9Jf+0VWBlg4DUVbOcHignWbWcealYiA=;
        b=YXR+UAjDc4gIa3elNLFZ82pqpYCWU67a5/uQRQ1BqIVHzs5o7F/kkKYpJ/jBjH5S/q
         3RCURjSYf5mBB+PKlHVpZMjxQEV11XmfLsrKvqzfptuw0BbqmP21WHxhEjeU5HraMURC
         4fJ5uCDNsTih/VCVL1iIw6M73CnVLP7Nlk9nrzeETU/a9Qx8D8pttsyBRQbXQkXPPxtz
         OTPCGk+YJZXRVgYgzJSlzPHIRWzpTZ9RdSqj0NAhHuTZ/Za2adpp0Dr+kjLbGQ+DeKhR
         Ag3KvnOSWwMv4FmIOPqd/y5WCFW4dLMxllcURmwQ6U9q6ft0lfSOHCgknwoxRq6gfVKk
         zGOQ==
X-Gm-Message-State: AOAM533/jTy0lrOMMU62hlqC9R1wPGdF/ibBtERGQxrtypozACYisbFW
        XL+UZ87vHMAsgvMW4kNc5U7qf+zkuQlxm+vc80M51f5GXKuulmHK95zJ2ujBw35srrO0alq71D+
        YXgash5kkCyXj
X-Received: by 2002:a7b:cb1a:: with SMTP id u26mr3107069wmj.125.1621865565242;
        Mon, 24 May 2021 07:12:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxD/BIip0u5D6aGgEPMzrRFJXFZvyigKfUb5+MO/5Z1Q7Fui91N4UswBlkNcyzQrACC9tXQkg==
X-Received: by 2002:a7b:cb1a:: with SMTP id u26mr3107060wmj.125.1621865565105;
        Mon, 24 May 2021 07:12:45 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id c64sm8206839wma.15.2021.05.24.07.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 07:12:44 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/7] KVM: nVMX: Ignore 'hv_clean_fields' data when
 eVMCS data is copied in vmx_get_nested_state()
In-Reply-To: <b79562d2-c517-b86c-8871-e8f81537f247@redhat.com>
References: <20210517135054.1914802-1-vkuznets@redhat.com>
 <20210517135054.1914802-4-vkuznets@redhat.com>
 <b79562d2-c517-b86c-8871-e8f81537f247@redhat.com>
Date:   Mon, 24 May 2021 16:12:43 +0200
Message-ID: <87o8d08bl0.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 17/05/21 15:50, Vitaly Kuznetsov wrote:
>> 'Clean fields' data from enlightened VMCS is only valid upon vmentry: L1
>> hypervisor is not obliged to keep it up-to-date while it is mangling L2's
>> state, KVM_GET_NESTED_STATE request may come at a wrong moment when actual
>> eVMCS changes are unsynchronized with 'hv_clean_fields'. As upon migration
>> VMCS12 is used as a source of ultimate truth, we must make sure we pick all
>> the changes to eVMCS and thus 'clean fields' data must be ignored.
>
> While you're at it, would you mind making copy_vmcs12_to_enlightened and 
> copy_enlightened_to_vmcs12 void?
>

Sure, no problem.

-- 
Vitaly

