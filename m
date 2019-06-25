Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D13A54D51
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 13:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbfFYLPL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 07:15:11 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39347 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727516AbfFYLPL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 07:15:11 -0400
Received: by mail-wm1-f68.google.com with SMTP id z23so2538281wma.4
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2019 04:15:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=pXjNCSKO+A8itxoJob/5aeE7uqcr9aKUUDE+2xRnOkY=;
        b=hJR+sr/B9lzIw+dnufecsmHnCl8wbBwXLaSkHIY6CpMmJIirTTIvqlB7FwIaG2dEHR
         UbDEEuN+m4qyoQ3M8eih8XOX+Z46+KjtIO1zeSFxfBWaKfVayfu4f/Aibppld1RjZ2jd
         7zLiC73GXSxNEzIu69DYvjHRJmXbfBm+7XDgevywJwdFZ0lHjF9U6fz+bGqHOlZUgP6d
         Y0fL8tqPcaPafCrt9KKu+v8EVKVl8n6rCifoRg0kUFe+g9CfTc/9XeWZrXcYSFqW1eoh
         2cA9LSnkhUucBq+y5TTZQs1wuawEQuuIEehwrfz1ETihoFeEDHn77cKmEEBrlnpDXJLg
         IVFw==
X-Gm-Message-State: APjAAAWx6l2od4x8WAzb4unXHDeexIDpMpq3ArWiVELuqlSWJYAoor/g
        /jn/bN0ZkNn7U2yK7+40O0CxRg==
X-Google-Smtp-Source: APXvYqydRIoQjTJUQqXrm4rNvHj1Xk6V6w1I7qRMQSYy0w5DpXzkX2h8z8C/Hdm2U23nX7pt5y4hCQ==
X-Received: by 2002:a05:600c:291:: with SMTP id 17mr18954242wmk.32.1561461309066;
        Tue, 25 Jun 2019 04:15:09 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id d1sm12697836wru.41.2019.06.25.04.15.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 04:15:08 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH] x86/kvm/nVMCS: fix VMCLEAR when Enlightened VMCS is in use
In-Reply-To: <E7C72E0C-B44F-4CE6-8325-EA32521D75B7@oracle.com>
References: <20190624133028.3710-1-vkuznets@redhat.com> <CEFF2A14-611A-417C-BC0A-8814862F26C6@oracle.com> <87lfxqdp3n.fsf@vitty.brq.redhat.com> <E7C72E0C-B44F-4CE6-8325-EA32521D75B7@oracle.com>
Date:   Tue, 25 Jun 2019 13:15:07 +0200
Message-ID: <87ftnxex1g.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Liran Alon <liran.alon@oracle.com> writes:

>> On 25 Jun 2019, at 11:51, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>> 
>> Liran Alon <liran.alon@oracle.com> writes:
>> 
>>>> On 24 Jun 2019, at 16:30, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>>> 
>>>> 
>>>> +bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmptr)
>>> 
>>> I prefer to rename evmptr to evmcs_ptr. I think it’s more readable and sufficiently short.
>>> In addition, I think you should return either -1ull or assist_page.current_nested_vmcs.
>>> i.e. Don’t return evmcs_ptr by pointer but instead as a return-value
>>> and get rid of the bool.
>> 
>> Actually no, sorry, I'm having second thoughts here: in handle_vmclear()
>> we don't care about the value of evmcs_ptr, we only want to check that
>> enlightened vmentry bit is enabled in assist page. If we switch to
>> checking evmcs_ptr against '-1', for example, we will make '-1' a magic
>> value which is not in the TLFS. Windows may decide to use it for
>> something else - and we will get a hard-to-debug bug again.
>
> I’m not sure I understand.
> You are worried that when guest have setup a valid assist-page and set
> enlighten_vmentry to true,
> that assist_page.current_nested_vmcs can be -1ull and still be considered a valid eVMCS?
> I don't think that's reasonable.

No, -1ull is not a valid eVMCS - but this shouldn't change VMCLEAR
semantics as VMCLEAR has it's own argument. It's perfectly valid to try
to put a eVMCS which was previously used on a different vCPU (and thus
which is 'active') to non-active state. The fact that we don't have an
active eVMCS on the vCPU doing VMCLEAR shouldn't matter at all.

-- 
Vitaly
