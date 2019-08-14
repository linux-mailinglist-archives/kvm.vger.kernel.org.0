Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7934A8D361
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 14:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfHNMn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 08:43:27 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40428 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbfHNMn0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 08:43:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id c3so2698523wrd.7
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2019 05:43:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M5hsYK/rzm8ReV5S4YkxsSgW2EXo1cijbAwHAUlpP8k=;
        b=OL90ZOc/hJVLxj3tOqXRgtK4iFp+wUyGIkoX3WKLvO6hmFbDL95E8h5yrETxO2hf7O
         3VlfP2Q4RCs/A5/u+ADKH/IPkakAJKBywF4oBBmWulZRNeBDCp7WR7cvjd6MquUQi6Qa
         a0kEO9MGSBTvEL7vtP+HqtjYDwVplmIiCwdf2KBten7dwBRo6S1eXa6PS9uMs8otkwC6
         U8lrR+Qu+oHucYJm7sUo9qHApoKqCKdrHTQkBeFRcyvjv9s32l1M1MnWzyF/XGmLg3Ac
         dN4R/PpnOlirEAWy8rV68zZrCgI8bzKQrb8TTynRYFt8Y5bQg/p7z0CwJrC+aR+wLRAJ
         lrzQ==
X-Gm-Message-State: APjAAAVNx0g3lcVDpOx6B5JQOvhcmC9D37wEw6D1xjNDlQjoHcBqhrUG
        8InSuL7CHVmGDF8fIerjQzNWjQ==
X-Google-Smtp-Source: APXvYqyfLWqL8rHcLOstM/hvMlhYrfpItQbxvR1GSfn9A5q80g1cvbmp7iAW23OHiije7dIDH2+FHQ==
X-Received: by 2002:adf:e2cb:: with SMTP id d11mr46732872wrj.66.1565786604592;
        Wed, 14 Aug 2019 05:43:24 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id e11sm28754114wrc.4.2019.08.14.05.43.23
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 05:43:24 -0700 (PDT)
Subject: Re: [PATCH] KVM/nSVM: properly map nested VMCB
To:     Jiri Palecek <jpalecek@web.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Ahmed <karahmed@amazon.de>
References: <20190604160939.17031-1-vkuznets@redhat.com>
 <b46872ce-5305-aa25-9593-d882da3c0872@redhat.com>
 <6282e1bf-1eaa-450d-7f6a-b868ebab09d0@web.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9bade306-5229-5744-48f6-bab022cdf27b@redhat.com>
Date:   Wed, 14 Aug 2019 14:43:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6282e1bf-1eaa-450d-7f6a-b868ebab09d0@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/08/19 20:35, Jiri Palecek wrote:
> Hello,
> 
> On 04. 06. 19 19:27, Paolo Bonzini wrote:
>> On 04/06/19 18:09, Vitaly Kuznetsov wrote:
>>> Commit 8c5fbf1a7231 ("KVM/nSVM: Use the new mapping API for mapping
>>> guest
>>> memory") broke nested SVM completely: kvm_vcpu_map()'s second
>>> parameter is
>>> GFN so vmcb_gpa needs to be converted with gpa_to_gfn(), not the
>>> other way
>>> around.
>>>
>>> Fixes: 8c5fbf1a7231 ("KVM/nSVM: Use the new mapping API for mapping
>>> guest memory")
>>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>> ---
>>>   arch/x86/kvm/svm.c | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>>> index 735b8c01895e..5beca1030c9a 100644
>>> --- a/arch/x86/kvm/svm.c
>>> +++ b/arch/x86/kvm/svm.c
>>> @@ -3293,7 +3293,7 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
>>>                          vmcb->control.exit_int_info_err,
>>>                          KVM_ISA_SVM);
>>>
>>> -    rc = kvm_vcpu_map(&svm->vcpu, gfn_to_gpa(svm->nested.vmcb), &map);
>>> +    rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->nested.vmcb), &map);
>>>       if (rc) {
>>>           if (rc == -EINVAL)
>>>               kvm_inject_gp(&svm->vcpu, 0);
>>> @@ -3583,7 +3583,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
>>>
>>>       vmcb_gpa = svm->vmcb->save.rax;
>>>
>>> -    rc = kvm_vcpu_map(&svm->vcpu, gfn_to_gpa(vmcb_gpa), &map);
>>> +    rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map);
>>>       if (rc) {
>>>           if (rc == -EINVAL)
>>>               kvm_inject_gp(&svm->vcpu, 0);
>>>
>> Oops.  Queued, thanks.
> 
> Given that this fix didn't make it to 5.2, and its straightforwardness,
> could you send it to stable for inclusion?

Done, thanks for the reminder!

Paolo

