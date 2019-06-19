Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E6E4B669
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 12:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731550AbfFSKpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 06:45:47 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34652 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbfFSKpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 06:45:46 -0400
Received: by mail-wm1-f67.google.com with SMTP id w9so4329706wmd.1
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2019 03:45:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iC2zZcx+YjliS5onXVeJ8w5DNsHAqEZjYqGkgbTolzM=;
        b=bhTsGvi3vzXUU4+1I8zNHSeBmVeUyyTjcu6WYOGO0D7MwcJkKce4unptSgNfLx9bda
         DNEHIwcepJepGEpeuxp6v3rDf30mUyOSYw/vQE57gCNFKQrKTDB5YyeM33xMtIwSsPeo
         hW/7Vso9Q98fj7roNB55An64Q0pjvM2TeLYsaMcVXfrKP/tGj28icJMFssogqsE7QyHH
         IvtN0ETK7vDWwlDpdmIn/lZIcciimS/NuC0JsNMVEpryuiF4cxxZMdC+JCApEClS/lJe
         RWdv74YE+USqIBnDKNkXOxOZxa8VbnP2X0RwOxdWcOft9KCKsz8x5fv/UFzGOXZrmzFJ
         IiJg==
X-Gm-Message-State: APjAAAXQYs8LR6ny5fsbkyXs3+OAHX9nE5dSoefyK2Rmbuq1HKeW8UGf
        Nvk56Cji04pdL6cyY6b6bTWvic/rhNE=
X-Google-Smtp-Source: APXvYqy0ty2rakAspQ5FiQyJAMVNZJNT5Wjkp5XpihllmSHHVZKmoECz1obLsbhu8h/7ygcYbVwUNQ==
X-Received: by 2002:a1c:e183:: with SMTP id y125mr7809546wmg.152.1560941143997;
        Wed, 19 Jun 2019 03:45:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:51c0:d03f:68e:1f6d? ([2001:b07:6468:f312:51c0:d03f:68e:1f6d])
        by smtp.gmail.com with ESMTPSA id r4sm38495207wra.96.2019.06.19.03.45.39
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 03:45:43 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: x86: Modify struct kvm_nested_state to have
 explicit fields for data
To:     Liran Alon <liran.alon@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1560875046-26279-1-git-send-email-pbonzini@redhat.com>
 <D2867F96-6B8D-4A1D-9F6F-CF0F171614BC@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e2800277-4d44-5caa-1122-c36487f6e6bb@redhat.com>
Date:   Wed, 19 Jun 2019 12:45:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <D2867F96-6B8D-4A1D-9F6F-CF0F171614BC@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/06/19 00:36, Liran Alon wrote:
> 
> 
>> On 18 Jun 2019, at 19:24, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> From: Liran Alon <liran.alon@oracle.com>
>>
>> Improve the KVM_{GET,SET}_NESTED_STATE structs by detailing the format
>> of VMX nested state data in a struct.
>>
>> In order to avoid changing the ioctl values of
>> KVM_{GET,SET}_NESTED_STATE, there is a need to preserve
>> sizeof(struct kvm_nested_state). This is done by defining the data
>> struct as "data.vmx[0]". It was the most elegant way I found to
>> preserve struct size while still keeping struct readable and easy to
>> maintain. It does have a misfortunate side-effect that now it has to be
>> accessed as "data.vmx[0]" rather than just "data.vmx".
>>
>> Because we are already modifying these structs, I also modified the
>> following:
>> * Define the "format" field values as macros.
>> * Rename vmcs_pa to vmcs12_pa for better readability.
>>
>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
>> [Remove SVM stubs, add KVM_STATE_NESTED_VMX_VMCS12_SIZE. - Paolo]
> 
> 1) Why should we remove SVM stubs? I think it makes the interface intention more clear.
> Do you see any disadvantage of having them?

In its current state I think it would not require any state apart from
the global flags, because MSRs can be extracted independent of
KVM_GET_NESTED_STATE; this may change as things are cleaned up, but if
that remains the case there would be no need for SVM structs at all.

> 2) What is the advantage of defining a separate KVM_STATE_NESTED_VMX_VMCS12_SIZE
> rather than just moving VMCS12_SIZE to userspace header?

It's just for namespace cleanliness.  I'm keeping VMCS12_SIZE for the
arch/x86/kvm/vmx/ code because it's shorter and we're used to it, but
userspace headers should use a more specific name.

Paolo
