Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BC62B25A6
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 21:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgKMUip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 15:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgKMUip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Nov 2020 15:38:45 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B258C0613D1;
        Fri, 13 Nov 2020 12:38:43 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id o15so11539865wru.6;
        Fri, 13 Nov 2020 12:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aXbvyvTJfOeaKCw6ThSniHNYXp/ID2w+JUNwyA1yDVI=;
        b=cqJi9j7M8UuiJXPW39hVAcgU8cXXGBpY5tdQX4/iKdPeP4uRbRwhA1roIDL/GFAG2P
         f9hN+oWH5lo4/xJAv8/+PKELSFmL21CaEBuFD1DYf/r/o09N0vvLs8A6Ar+RWlbloudJ
         zPJsvfuAcXYil4enM6HunDX+lCyZDeBZQz8RstoNXrpjx/THPpUmuGMbLSmuZRHlT4qO
         NYRBq2QucwFo41D22ZL2hLoz5tAuipsleHPji9t+dltjuw0+mbKg9FibehT0fVy7jArS
         UVZXYn6Uqs4nDEDyd7M0LChCOaT73oCNBXEiCs0qau9Jo/hFY2VhbxBwg5wF4apV9sAN
         owuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:from:to:cc:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aXbvyvTJfOeaKCw6ThSniHNYXp/ID2w+JUNwyA1yDVI=;
        b=A+X9FgJiIYTUejBjNeajh/4oU2DC61q38BvpiMJgtDlq+2dVn9etiakU2FMvrbtt8v
         jw7IrIAqeIBMsiCHuu0pDDTkK7mCrdX5/FsgZhjSdeWKF2cCVF1s4PgkL1GPFi4lgJ2v
         ocQMStCYuxlRWk162iN7T/bIaB8sV7+41j4cgWgCIvmJXytSfe7+NOoUQh2ycSV8NZ0M
         2ooZ9QaMSr4aiOCZSCUxZ7fWmK1lTikA7eO6h3KaU7oR+x5VKnKsWx93czimwQV2fJta
         RDRy6yeSjpQrhhwJMy7gQgEa5RUGs5bBoYru6j0rXimWTTE+/MJ61dC4gmqRL4Ooua9x
         B56w==
X-Gm-Message-State: AOAM530nbv9C1znqgwcoxJNNJXF/E5EGcLYQCRQlYKZ/ECwi6WInva9M
        wfLrI3evJE8SUXNYUfDVJBA=
X-Google-Smtp-Source: ABdhPJxbKf4UCu3T15Haey9kD5vr4Uz9w+EdKtEHQEpUq/5DVwHN+Dcv9ogGbR2BQwaiJxB43X0z1A==
X-Received: by 2002:a05:6000:1183:: with SMTP id g3mr5613666wrx.7.1605299922237;
        Fri, 13 Nov 2020 12:38:42 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id 6sm4811550wrn.72.2020.11.13.12.38.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 12:38:41 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: SVM: Use a separate vmcb for the nested L2
 guest
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Cathy Avery <cavery@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, wei.huang2@amd.com, mlevitsk@redhat.com
References: <20201011184818.3609-1-cavery@redhat.com>
 <20201011184818.3609-3-cavery@redhat.com>
 <80b02c13-dc69-783a-9431-41b4a5188c0b@redhat.com>
Message-ID: <8f9bb12a-fa10-8c2c-aee2-240c59c92758@redhat.com>
Date:   Fri, 13 Nov 2020 21:38:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <80b02c13-dc69-783a-9431-41b4a5188c0b@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/11/20 18:58, Paolo Bonzini wrote:
> 
>> +    svm->nested.vmcb02->save.cr4 = svm->vmcb01->save.cr4;
> 
> I cannot understand this statement.

I wonder if it has something to do with

         unsigned long old_cr4 = to_svm(vcpu)->vmcb->save.cr4;

whereas vmx.c has

         unsigned long old_cr4 = vcpu->arch.cr4;

without this assignment, the old_cr4 would be taken from the last value 
stored in the vmcb02, instead of the current value for the vCPU.

In general uses of svm->vmcb01 (in svm.c especially) needs to be audited 
carefully.

Paolo
