Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54AC97DE26
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 16:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbfHAOnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 10:43:10 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53618 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbfHAOnK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 10:43:10 -0400
Received: by mail-wm1-f65.google.com with SMTP id x15so64944150wmj.3
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2019 07:43:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=AQVZzxviCSRzfupMACZrSRSzcwDwgjm3ki6dTQwgdSY=;
        b=VvwhW0ofxz84GpoV/P217P7W5TwYbbMd+N7MgF7MnGte4qDguta0KeKtrXeUvKPQVg
         0RhNt5hPQ0jLWOr2CBssqAYRYcMpgaMPTd5QeIFocIb3urEso/4jGlyLyZDOCXDhndhb
         9eXyT4ygAS4SCr3lDsfpTW0eYgrmseFw2YxgYkD2EB2WSY/ZjQUI11xc1sciZMXg6mum
         VCRtHvRB+S5pH8CbJmfGyC+o4dPGQlPTGaJJwBlUaefoGpAze6wrbhaQbhfN2Xy84Xwp
         K6+SQRAYN6Lqxs8Ksk9MZVJVJDnz1o0zQZb/5/uFOGuHOP1uFhtlM1SrTlUqVr+w+cj3
         oMDA==
X-Gm-Message-State: APjAAAVAA09LU+41jeMHNEwF9EKj0FKvmiNfneiwAkI4pjkUmAaJJQiB
        P3LPSQTrnZytwOhdoftJCXcxpCV+bPw=
X-Google-Smtp-Source: APXvYqyvHJ4XFkD6+G+k8opm3OHCmgXq7DQbrlYYAWG0VPhgFif8OCAYnGiM6GkBJFvf5mNzeQpPPQ==
X-Received: by 2002:a1c:5602:: with SMTP id k2mr109441102wmb.173.1564670587902;
        Thu, 01 Aug 2019 07:43:07 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f204sm111394043wme.18.2019.08.01.07.43.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 07:43:06 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 3/5] x86: KVM: svm: clear interrupt shadow on all paths in skip_emulated_instruction()
In-Reply-To: <20190801141802.GA6783@linux.intel.com>
References: <20190801051418.15905-1-vkuznets@redhat.com> <20190801051418.15905-4-vkuznets@redhat.com> <20190801141802.GA6783@linux.intel.com>
Date:   Thu, 01 Aug 2019 16:43:05 +0200
Message-ID: <87ftml54li.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Thu, Aug 01, 2019 at 07:14:16AM +0200, Vitaly Kuznetsov wrote:
>> Regardless of the way how we skip instruction, interrupt shadow needs to be
>> cleared.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Reviewed-by: Jim Mattson <jmattson@google.com>
>> ---
>>  arch/x86/kvm/svm.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index 80f576e05112..7c7dff3f461f 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -784,13 +784,15 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
>>  				EMULATE_DONE)
>>  			pr_err_once("KVM: %s: unable to skip instruction\n",
>>  				    __func__);
>> -		return;
>> +		goto clear_int_shadow;
>
> A better fix would be to clear the interrupt shadow in x86_emulate_instruction()
> after updating RIP for EMULTYPE_SKIP.  VMX has this same flaw when running
> nested as handle_ept_misconfig() also expects the interrupt shadow to be
> handled by kvm_emulate_instruction().  Clearing the shadow if and only if
> the skipping is successful also means KVM isn't incorrectly zapping the
> shadow when emulation fails.

Oh, nice catch actually! Will do in v2.

-- 
Vitaly
