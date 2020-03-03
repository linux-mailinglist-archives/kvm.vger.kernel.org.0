Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCF9177DD9
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 18:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbgCCRoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 12:44:19 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49042 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728022AbgCCRoT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Mar 2020 12:44:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583257458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+kDNjT2v7RCGN2/RZBTOd7SE7Zwpp1JBRccPdNRTagU=;
        b=BerRdVguQkn/wVKsGfiu9xhV0/5S169JlwxlIW1vpqWB/3Pokvs0aN8YMnj74IHwdotpvC
        jcilsBKotwU9dnY46bNOymrNQngmKDoB/I00LfPUDnX4t+COmp0naeZBkSagvDf957brSH
        YuFmBp8y/zTbbED4mPgv0nk7iZMXi+8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-Xg25iwFUPWe3rjs8EoMAnQ-1; Tue, 03 Mar 2020 12:44:16 -0500
X-MC-Unique: Xg25iwFUPWe3rjs8EoMAnQ-1
Received: by mail-wr1-f72.google.com with SMTP id z16so1547573wrm.15
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 09:44:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+kDNjT2v7RCGN2/RZBTOd7SE7Zwpp1JBRccPdNRTagU=;
        b=U8N3MLk+h/mq9erN4TBhBe6CbulqVjuhwdhbdX0lanKbObiteRPqwW9tTYeW0a7AnW
         NdX/qrNd1vQCAgEdVCOliE3wCNoS2O4jH/wODAsBkxE2wjOJljOkaim4fIgsEwuemC6D
         jJlhIkxeUn/Q78p68mkAAXH0gEmnp9mYw03jjt8q0ofejoA7h4/dGb805Pi05SMn0doC
         jQ4p1YFDkadwflbE+/wKrmtx2wumKmiLYFZN01mm7Z/olc7DuLLKiNJDjWjyZHjg+eHj
         5AkbT59aBzJ4j/tpZSvN7jpC4OOWfTY9F97y0ZPUiTBptq6H0eXiAYtC3cJ6eu8/poA4
         qfaw==
X-Gm-Message-State: ANhLgQ3PnWFUHzx6s3YzSzT8xZb4n3/t0RfqbULxf39XRLjTSQrVn3+j
        SGJ8Y99/W6uA8HDip64u4MScjCXh26Lpg1/UZ+KnZo/hGWhxErw31vdpEd547Y6rSFFK0zWaUTV
        L096by6s/wIDc
X-Received: by 2002:a1c:1bd6:: with SMTP id b205mr5290790wmb.186.1583257455561;
        Tue, 03 Mar 2020 09:44:15 -0800 (PST)
X-Google-Smtp-Source: ADFU+vs8FxJrSSORXThGbCXQ++IvZ7jOiUFQ+O7eaLn60+Ha62LSmPleWl6D5qSQA/eOUulgtPkXRQ==
X-Received: by 2002:a1c:1bd6:: with SMTP id b205mr5290768wmb.186.1583257455198;
        Tue, 03 Mar 2020 09:44:15 -0800 (PST)
Received: from [192.168.178.40] ([151.20.254.94])
        by smtp.gmail.com with ESMTPSA id b16sm30986279wrq.14.2020.03.03.09.44.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 09:44:14 -0800 (PST)
Subject: Re: [PATCH v2 06/13] KVM: x86: Refactor emulate tracepoint to
 explicitly take context
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200218232953.5724-1-sean.j.christopherson@intel.com>
 <20200218232953.5724-7-sean.j.christopherson@intel.com>
 <8736axjmte.fsf@vitty.brq.redhat.com> <20200303164813.GL1439@linux.intel.com>
 <2f3f7aff-2bd0-fa62-4b66-9f90f125e44e@redhat.com>
 <20200303174242.GN1439@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c1ffb941-6232-7a35-a70c-4831f9632395@redhat.com>
Date:   Tue, 3 Mar 2020 18:44:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200303174242.GN1439@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/20 18:42, Sean Christopherson wrote:
>> As long as we have one use of vcpu, I'd rather skip this patch and
>> adjust patch 8 to use "->".  Even the other "explicitly take context"
>> parts are kinda debatable since you still have to do emul_to_vcpu.
>> Throwing a handful of
>>
>> - 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
>> + 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>>
>> into patch 8 is not bad at all and limits the churn.
> Hmm, I'd prefer to explicitly pass @ctxt, even for the tracepoint.  I get
> that it's technically unnecessary churn, but explicitly passing @ctxt means
> that every funcition that grabs arch.emulate_ctxt (all three of 'em) checks
> for a NULL ctxt.  That makes it trivial to visually audit that there's no
> risk of a bad pointer dereference, and IMO having @ctxt in the prototype
> is helpful to see "oh, this helper is called from within the emulator".
> 

That's a good rationale, but I believe this refactoring belongs more in
the "disable emulator" part than this one.

Paolo

