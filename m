Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5C3177BFD
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 17:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730336AbgCCQgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 11:36:10 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57345 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727989AbgCCQgK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Mar 2020 11:36:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583253369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RJWF1eWFLN+jPR+BNc53F9U0SopZ95T6MW9CaJ7Lt0E=;
        b=LlYHB1fJ9tVoXtYjeE7xQrswDmsa38PHqX8+2kR+JNYy3eEC1FfFoK6NmijO21/yDHuYIV
        f5a5MPT1IbeJQfFTtizT4W259hrNXXwoguRd5Uxb4YSpzYi06ItO9F2JOLHPEZfKkKVOuO
        HWKhi2bPFoubYUG2mQGYHbA7WAFtCUM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-0h-SO2CSPdmyctZLL83g1Q-1; Tue, 03 Mar 2020 11:35:56 -0500
X-MC-Unique: 0h-SO2CSPdmyctZLL83g1Q-1
Received: by mail-wr1-f69.google.com with SMTP id d9so1449855wrv.21
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 08:35:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=RJWF1eWFLN+jPR+BNc53F9U0SopZ95T6MW9CaJ7Lt0E=;
        b=N48ezW7UnMiIDS49+fn+LY8y4/8H7sCKJfTrsWXoGCANhJhReK032BjnTERavt47kf
         OLUqQG5mJnW0z4/d9kouHM1OkW8cZm54CLbl6kT0rG0WUkfsQ7bkruaYt2/IS3uB5I2y
         f/Bcx4gAtFjkQl591sFCFp+KPJ0j3m56TjWNhhTKTZ4+mfT9HebRZlce8aFk6ABVQXvX
         Vfcp4H28HTxd2mKlLkoHVc7YNROq05HV09S6WZXne/f1DyULfm/yE6Koncp3lD6oLKWR
         DMG2ZH8HG1zq9gWIogMHLXupxqNxAe7RRvBgwIp1uasy+sqgMIZTj422Erka1dZXdtNM
         OR6w==
X-Gm-Message-State: ANhLgQ0cPW2R6Ksrs39QR94UrygSHvRzmUp947TyYq5dOl6S1Yt2iK/0
        HVT9Y6gkws12GFNOSmsS0cEk2GJ0rDMEumKbn/AtP4i6A7jKdBRll7SdXtd61xAj/LwPh63Ur3h
        uu6ugJyMWz16N
X-Received: by 2002:a5d:568f:: with SMTP id f15mr6309085wrv.202.1583253355029;
        Tue, 03 Mar 2020 08:35:55 -0800 (PST)
X-Google-Smtp-Source: ADFU+vukv9qnKRFBfr4HwvHP2NBCSoxyOtoOb2QQaTYSs0loSmJRYXOG1lAS0tc+8mfrnfWjuyssLA==
X-Received: by 2002:a5d:568f:: with SMTP id f15mr6309068wrv.202.1583253354840;
        Tue, 03 Mar 2020 08:35:54 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f17sm24125202wrj.28.2020.03.03.08.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 08:35:54 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Bandan Das <bsd@redhat.com>, Oliver Upton <oupton@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86: clear stale x86_emulate_ctxt->intercept value
In-Reply-To: <4f933f77-6924-249a-77c5-3c904e7c052b@redhat.com>
References: <20200303143316.834912-1-vkuznets@redhat.com> <20200303143316.834912-2-vkuznets@redhat.com> <4f933f77-6924-249a-77c5-3c904e7c052b@redhat.com>
Date:   Tue, 03 Mar 2020 17:35:53 +0100
Message-ID: <87zhcxe6qe.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 03/03/20 15:33, Vitaly Kuznetsov wrote:
>> Commit c44b4c6ab80e ("KVM: emulate: clean up initializations in
>> init_decode_cache") reduced the number of fields cleared by
>> init_decode_cache() claiming that they are being cleared elsewhere,
>> 'intercept', however, seems to be left uncleared in some cases.
>> 
>> The issue I'm observing manifests itself as following:
>> after commit 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest
>> mode") Hyper-V guests on KVM stopped booting with:
>> 
>>  kvm_nested_vmexit:    rip fffff802987d6169 reason EPT_VIOLATION info1 181
>>     info2 0 int_info 0 int_info_err 0
>>  kvm_page_fault:       address febd0000 error_code 181
>>  kvm_emulate_insn:     0:fffff802987d6169: f3 a5
>>  kvm_emulate_insn:     0:fffff802987d6169: f3 a5 FAIL
>>  kvm_inj_exception:    #UD (0x0)
>
> Slightly rephrased:
>
> After commit 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest
> mode") Hyper-V guests on KVM stopped booting with:
>
>  kvm_nested_vmexit:    rip fffff802987d6169 reason EPT_VIOLATION info1 181
>     info2 0 int_info 0 int_info_err 0
>  kvm_page_fault:       address febd0000 error_code 181
>  kvm_emulate_insn:     0:fffff802987d6169: f3 a5
>  kvm_emulate_insn:     0:fffff802987d6169: f3 a5 FAIL
>  kvm_inj_exception:    #UD (0x0)
>
> "f3 a5" is a "rep movsw" instruction, which should not be intercepted
> at all.  Commit c44b4c6ab80e ("KVM: emulate: clean up initializations in
> init_decode_cache") reduced the number of fields cleared by
> init_decode_cache() claiming that they are being cleared elsewhere,
> 'intercept', however, is left uncleared if the instruction does not have
> any of the "slow path" flags (NotImpl, Stack, Op3264, Sse, Mmx, CheckPerm,
> NearBranch, No16 and of course Intercept itself).

Much better, thanks) Please let me know if you want me to resubmit.

-- 
Vitaly

