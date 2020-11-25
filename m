Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898D32C462D
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 18:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732368AbgKYRAj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 12:00:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43089 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730630AbgKYRAi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 12:00:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606323637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DFj8aivB8s6n2nT/4lNtxO8j77s7jurBcNb7VD/gLbQ=;
        b=DaDyYpdN1z74vtOCf/Yhxk2xKby6nd+L5clOac7psgop3ueNY/MpIIrFks+o8w/SX7WjTm
        nA7gOMx0cDidCHrDaIfrTx84d+qhCyzin8Oe7vxaZq5pcW/uyU2SD45Y/6uZn4+QU3MjLN
        RybxcpnlrS2SlHSy0QF2S7EJ3euNyFI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-ugVaCajwNPG5eJXWXy3bTw-1; Wed, 25 Nov 2020 12:00:34 -0500
X-MC-Unique: ugVaCajwNPG5eJXWXy3bTw-1
Received: by mail-ej1-f72.google.com with SMTP id f21so973345ejf.11
        for <kvm@vger.kernel.org>; Wed, 25 Nov 2020 09:00:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DFj8aivB8s6n2nT/4lNtxO8j77s7jurBcNb7VD/gLbQ=;
        b=Il9VfsfbROBCjK+TZpD8D7X2kTgKQP1Gjz+nE196LZ8mUi0dajt3F1XY6d7+7+ik1l
         UthhOh6eHfk/qnWcbPVEWmfO825t9uhmfLBrqTQcGc6FlDCTybxA9Ju3jQvCKWrBQHpX
         5e0UZc00FqO970z5o4h2c3Ameq6JVmTK+7wSgXf2FhVpr6FVfPaaT0mQu2T1Q/fgxhBw
         ivjFTjRUlbCT/+gC2EjUu4YK3ROUpTPbngdNag5AVSIy7Bq80RTBIGiEcAxgPDrFsQwZ
         ZIN/r1ZQEmyrXYJdlMr/fTrU3vNl20H+wFMWLzOq86AtPp0lcI5sKWRLXYghpqZNAsOs
         l+bA==
X-Gm-Message-State: AOAM533+lDnwtLOjCkQHgfV74qSUn82MKiJUrupaI3m18qr4qF4tDm/h
        JnlcXWhDNgP3j5QzcWej+YTw/sQJB7BdQrDZafrpjmtLqsH7N2+tHrSdsnA51hVbup8m887pD19
        S5FmgKIQ+u9ZD
X-Received: by 2002:a17:906:c04d:: with SMTP id bm13mr3813477ejb.519.1606323633631;
        Wed, 25 Nov 2020 09:00:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwxsv1CzemqWGnTiUDExZTt5wg5RDim4wTwXfH1lVYI2DMg8319hlWHBYwfFdtD8Gz1xIvUfg==
X-Received: by 2002:a17:906:c04d:: with SMTP id bm13mr3813456ejb.519.1606323633369;
        Wed, 25 Nov 2020 09:00:33 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id jr13sm1589706ejb.50.2020.11.25.09.00.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2020 09:00:32 -0800 (PST)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oupton@google.com>, idan.brown@oracle.com,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>, liam.merwick@oracle.com,
        wanpeng.li@hotmail.com
References: <95b9b017-ccde-97a0-f407-fd5f35f1157d@redhat.com>
 <20201123192223.3177490-1-oupton@google.com>
 <4788d64f-1831-9eb9-2c78-c5d9934fb47b@redhat.com>
 <CAOQ_QsiUAVob+3hnAURJF-1+GdRF9HMtuxpKWCB-3m-abRGqxw@mail.gmail.com>
 <CAOQ_QshMoc9W9g6XRuGM4hCtMdvUxSDpGAhp3vNxhxhWTK-5CQ@mail.gmail.com>
 <20201124015515.GA75780@google.com>
 <e140ed23-df91-5da2-965a-e92b4a54e54e@redhat.com>
 <20201124212215.GA246319@google.com>
 <d5f4153b-975d-e61d-79e8-ed86df346953@redhat.com>
 <20201125011416.GA282994@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 11/11] KVM: nVMX: Wake L2 from HLT when nested
 posted-interrupt pending
Message-ID: <13e802d5-858c-df0a-d93f-ffebb444eca1@redhat.com>
Date:   Wed, 25 Nov 2020 18:00:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201125011416.GA282994@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/11/20 02:14, Sean Christopherson wrote:
>> The flag
>> would not have to live past vmx_vcpu_run even, the vIRR[PINV] bit would be
>> the primary marker that a nested posted interrupt is pending.
>
> 	while (READ_ONCE(vmx->nested.pi_pending) && PID.ON) {
> 		vmx->nested.pi_pending = false;
> 		vIRR.PINV = 1;
> 	}
> 
> would incorrectly set vIRR.PINV in the case where hardware handled the PI, and
> that could result in L1 seeing the interrupt if a nested exit occured before KVM
> processed vIRR.PINV for L2.  Note, without PID.ON, the behavior would be really
> bad as KVM would set vIRR.PINV *every* time hardware handled the PINV.

It doesn't have to be a while loop, since by the time we get here 
vcpu->mode is not IN_GUEST_MODE anymore.  To avoid the double PINV 
delivery, we could process the PID as in 
vmx_complete_nested_posted_interrupt in this particular case---but 
vmx_complete_nested_posted_interrupt would be moved from vmentry to 
vmexit, and the common case would use vIRR.PINV instead.  There would 
still be double processing, but it would solve the migration problem in 
a relatively elegant manner.

>> The weird promise is
>> that the PINV interrupt is the _only_ trigger for posted interrupts.
> 
> Ah, I misunderstood the original "only".  I suspect the primary reason is that
> it would cost uops to do the snoop thing and would be inefficient in practice.

Yes, I agree.  But again, the spec seems to be unnecessarily restrictive.

>>> This is the part that is likely impossible to
>>> solve without shadowing the PID (which, for the record, I have zero desire to do).
>> Neither do I.:)   But technically the SDM doesn't promise reading the whole
>> 256 bits at the same time.
>
> Hrm, the wording is poor, but my interpretation of this blurb is that the CPU
> somehow has a death grip on the PID cache line while it's reading and clearing
> the PIR.
> 
>    5. The logical processor performs a logical-OR of PIR into VIRR and clears PIR.
>       No other agent can read or write a PIR bit (or group of bits) between the
>       time it is read (to determine what to OR into VIRR) and when it is cleared.

Yeah, that's the part I interpreted as other processors possibly being 
able to see a partially updated version.  Of course in practice the 
processor will be doing everything atomically, but the more restrictive 
reading of the spec all but precludes a software implementation.

Paolo

