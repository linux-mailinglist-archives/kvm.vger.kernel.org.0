Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37117D7C2E
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388040AbfJOQnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:43:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33324 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728083AbfJOQnG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:43:06 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B68852A09AA
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 16:36:15 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id z205so8901351wmb.7
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 09:36:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6SU2iYxBpciwSkgWiOL6iZkMAxSRBo4v5NF0FEchK38=;
        b=LotWqmjZCHdDPgwt+srfI/noVElN/OmtqZE4PUnrFRmRttTQBOB0bgVrhuIZuxnMBe
         tNmWydRQH1WXMuNkF8WZYDNnsT05+j3ZTXhLQcVo/qSXTZCLPut+C3vWGPzVlt9sDOTU
         NyK4O6rGhxZ0/7CwhuiCWCEeukIsYkotQ7ar2dO+MmDt6mqdW2w4T3sZ/XGPtTZq51rY
         Up1QLdsdxVtCJ6ACQR+hnxcz72c82SYjY/dPKg5LZ4qVcrhH8jqGdisVgXAbOiM0gvVf
         dcirab764m45d1Mt7lrKc/DSsHzwAZccuAs1e47IenOwUEc5KODFVBq8SnW0Rr/efV/i
         n+gg==
X-Gm-Message-State: APjAAAU7CP2AMvujRjFqZA5aFiFKsY3+djWx5UQEdNjRQOb7GcJ1mlyU
        +kNaJMYNaWyL4AlJhbQ/0MlfX2XZoTr22mghOmL51CWoOdLBl3LZ4o9KT2EV9SCA569DNX0Sve3
        txFhkK+2Z+9qD
X-Received: by 2002:a1c:e086:: with SMTP id x128mr19487203wmg.139.1571157374398;
        Tue, 15 Oct 2019 09:36:14 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzIfVMIbG+6mpdFJ1PD9Fm1XVFu7mH9sLaGR+C1rC7u9raqVC9mEMICjHeKjSaYaX9uuQ3HNA==
X-Received: by 2002:a1c:e086:: with SMTP id x128mr19487181wmg.139.1571157374101;
        Tue, 15 Oct 2019 09:36:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d001:591b:c73b:6c41? ([2001:b07:6468:f312:d001:591b:c73b:6c41])
        by smtp.gmail.com with ESMTPSA id a4sm19159768wmm.10.2019.10.15.09.36.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2019 09:36:13 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Make fpu allocation a common function
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
References: <20191014162247.61461-1-xiaoyao.li@intel.com>
 <87y2xn462e.fsf@vitty.brq.redhat.com>
 <20191014183723.GE22962@linux.intel.com>
 <87v9sq46vz.fsf@vitty.brq.redhat.com>
 <97255084-7b10-73a5-bfb4-fdc1d5cc0f6e@redhat.com>
 <87lftm3wja.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f00edd02-7d25-54f4-0972-c702e8254016@redhat.com>
Date:   Tue, 15 Oct 2019 18:36:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87lftm3wja.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/19 16:36, Vitaly Kuznetsov wrote:
>> On 15/10/19 12:53, Vitaly Kuznetsov wrote:
>>> A very theoretical question: why do we have 'struct vcpu' embedded in
>>> vcpu_vmx/vcpu_svm and not the other way around (e.g. in a union)? That
>>> would've allowed us to allocate memory in common code and then fill in
>>> vendor-specific details in .create_vcpu().
>> Probably "because it's always been like that" is the most accurate answer.
>>
> OK, so let me make my question a bit less theoretical: would you be in
> favor of changing the status quo? :-)

Not really, it would be a lot of churn for debatable benefit.

Paolo
