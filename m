Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32A9A5FAD8
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 17:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbfGDP3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 11:29:06 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38854 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727289AbfGDP3F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 11:29:05 -0400
Received: by mail-wr1-f66.google.com with SMTP id p11so1557973wro.5
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2019 08:29:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uTber9tnQqfaXZRYxYBLuoOHIoCFmIICAtxbv0BddWo=;
        b=UzUNSUjlpS5vWjf32KnnrpmRbMCfnHC5t8dv69tMW/6ygzjalvFbLbmj+dKyyhqbVP
         HsAD+n5ZL1HNNofpL7ChO9ji4n13pYZHGwEh5IR6UC7CK2aAra3l+ScsDT+7DgkH0kyI
         78UwmcFjrILQNKe5UTdsYCK39kARWGB+t737SY9Fvi+j+9OFNo1hZzaRJxbACRvpa5lJ
         teMGzZhiqHcSGc2LnlduRj7N3tlvP2nfvsqDdtrdb7ybrxuM6DM2I8FaVzlVc9svk2Tk
         1+KeboLAkfbDAGCKt4nFYVVRjOxUSCr7i6mxn+MOas63Qn9aEVkH22Go227vIU1/nm7Z
         wzAg==
X-Gm-Message-State: APjAAAXNTUo5aAX4p8UmCjds+egW27/nKjHLTlAx23TywLf2oB/ciHgO
        X+r3kthLvogh02YJ0P3vEGXLSg==
X-Google-Smtp-Source: APXvYqw7wS0O7kIcDJO3t+HWyknb2q6xvP7eHD0RP4+CDaSX6mc7pSid9kytNhWqXR1Upc348yXh2A==
X-Received: by 2002:a5d:5448:: with SMTP id w8mr34173359wrv.180.1562254143384;
        Thu, 04 Jul 2019 08:29:03 -0700 (PDT)
Received: from [10.201.49.68] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id e20sm10190235wrc.9.2019.07.04.08.29.02
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 08:29:02 -0700 (PDT)
Subject: Re: [PATCH] target/i386: kvm: Fix when nested state is needed for
 migration
To:     Liran Alon <liran.alon@oracle.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Karl Heubaum <karl.heubaum@oracle.com>
References: <20190624230514.53326-1-liran.alon@oracle.com>
 <6499083f-c159-1c3e-0339-87aa5b13c2c0@redhat.com>
 <432511A2-C6B4-4B03-87A5-176D886C0BF2@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c5e7fd4d-3554-4df9-1e92-49e4ec02d653@redhat.com>
Date:   Thu, 4 Jul 2019 17:29:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <432511A2-C6B4-4B03-87A5-176D886C0BF2@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/07/19 16:31, Liran Alon wrote:
> 
> 
>> On 2 Jul 2019, at 19:39, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 25/06/19 01:05, Liran Alon wrote:
>>> When vCPU is in VMX operation and enters SMM mode,
>>> it temporarily exits VMX operation but KVM maintained nested-state
>>> still stores the VMXON region physical address, i.e. even when the
>>> vCPU is in SMM mode then (nested_state->hdr.vmx.vmxon_pa != -1ull).
>>>
>>> Therefore, there is no need to explicitly check for
>>> KVM_STATE_NESTED_SMM_VMXON to determine if it is necessary
>>> to save nested-state as part of migration stream.
>>>
>>> In addition, destination must enable eVMCS if it is enabled on
>>> source as specified by the KVM_STATE_NESTED_EVMCS flag, even if
>>> the VMXON region is not set. Thus, change the code to require saving
>>> nested-state as part of migration stream in case it is set.
>>>
>>> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
>>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
>>> ---
>>> target/i386/machine.c | 2 +-
>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/target/i386/machine.c b/target/i386/machine.c
>>> index 851b249d1a39..e7d72faf9e24 100644
>>> --- a/target/i386/machine.c
>>> +++ b/target/i386/machine.c
>>> @@ -999,7 +999,7 @@ static bool vmx_nested_state_needed(void *opaque)
>>>
>>>     return ((nested_state->format == KVM_STATE_NESTED_FORMAT_VMX) &&
>>>             ((nested_state->hdr.vmx.vmxon_pa != -1ull) ||
>>> -             (nested_state->hdr.vmx.smm.flags & KVM_STATE_NESTED_SMM_VMXON)));
>>> +             (nested_state->flags & KVM_STATE_NESTED_EVMCS)));
>>> }
>>>
>>> static const VMStateDescription vmstate_vmx_nested_state = {
>>>
>>
>> Queued, thanks.
>>
>> Paolo
> 
> Actually Paolo after I have created KVM patch
> ("KVM: nVMX: Change KVM_STATE_NESTED_EVMCS to signal vmcs12 is copied from eVMCS”)
> I think I realised that KVM_STATE_NESTED_EVMCS is actually not a requirement for nested-state to be sent.
> I suggest to replace this commit with another one that just change vmx_nested_state_needed() to return true
> In case format is FORMAT_VMX and vmxon_pa != -1ull and that’s it.
> 
> As anyway, QEMU provisioned on destination side is going to enable the relevant eVMCS capability.
> I’m going to send another series that refines QEMU nested-migration a bit more so I will do it along the way.
> But I think this patch should be un-queued. Sorry for realizing this later but at least it’s before it was merged to master :)

Replaced with

diff --git a/target/i386/machine.c b/target/i386/machine.c
index 851b249d1a..704ba6de46 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -997,9 +997,8 @@ static bool vmx_nested_state_needed(void *opaque)
 {
     struct kvm_nested_state *nested_state = opaque;
 
-    return ((nested_state->format == KVM_STATE_NESTED_FORMAT_VMX) &&
-            ((nested_state->hdr.vmx.vmxon_pa != -1ull) ||
-             (nested_state->hdr.vmx.smm.flags & KVM_STATE_NESTED_SMM_VMXON)));
+    return (nested_state->format == KVM_STATE_NESTED_FORMAT_VMX &&
+            nested_state->hdr.vmx.vmxon_pa != -1ull);
 }
 
 static const VMStateDescription vmstate_vmx_nested_state = {

and dropped the last paragraph of the commit message.

Paolo

