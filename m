Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B64953EB4A
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 19:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241702AbiFFQUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 12:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241669AbiFFQUr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 12:20:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7073A296300
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 09:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654532442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SiJ9xom7N9pKMOdzxnCK3+PJOWSLJd7EA3DjmLBi34c=;
        b=b0drvRjlRNgZBMVsZAyhXBQLudyiok2rzZJLTNDYO3cyDQCmZfParihErmhIn7r2+JY0uD
        zja/nSHoYKozpj7laJPcKYlu3K7yGW92NQMalK3u8GWRAKsDS2H8cxQduRiVQ9xHdTV8hW
        yHi1H/hBmSWe+tDpecNWvviGWa+uvMA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-RQjddTfzMgqdqKwP7ZdarA-1; Mon, 06 Jun 2022 12:20:40 -0400
X-MC-Unique: RQjddTfzMgqdqKwP7ZdarA-1
Received: by mail-wr1-f70.google.com with SMTP id c11-20020adffb4b000000b0020ff998391dso2965831wrs.8
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 09:20:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SiJ9xom7N9pKMOdzxnCK3+PJOWSLJd7EA3DjmLBi34c=;
        b=hhZ6d07npz3gbrqhXAjDgBDTv3ODMw0dt1YuutI5u01J4hhW9OY+jp8z+VU6RsWDdU
         aVZLQcGGPBB30OcuRvIRf3qY4IZyO2I8IER6Pa8Gpu1Hw6uy5CVeB7qyd104HzmapdVN
         FBalPR+quMz0NCt48jSeIh81O+eUGxR+Q2CyT53na90ptKWXiyzxSmXoUJjsaDvlEGgK
         Bd7FvJ1XBFDh/7mwA/PcAsP9QW7GplycXBONXDWMGrCCgWQ9ZXTOC/FdewyrkVV+PNIt
         8U6WtUV6xZe8Ilo13CHasV3hNW4Z3uH7mGaR2Q2WTkzBkFp+qPkQiNp0FwzXSKH1xtZH
         vNgA==
X-Gm-Message-State: AOAM5331MID9QU2jg2oRZIub0/1T3PAV94GfkJsu9gDV0NUi4C7eKAm+
        fSitncR4t9RMEAjZx8bzEyGkKvn/+2HbdYQusw6GE6G4m4p4UC9U6WhLJ6WgUGX/c1NkwHU1Gfo
        +lFGW8Df1lgQe
X-Received: by 2002:a05:6000:1c0d:b0:216:c9f4:2b83 with SMTP id ba13-20020a0560001c0d00b00216c9f42b83mr11271678wrb.405.1654532439233;
        Mon, 06 Jun 2022 09:20:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRaTzbA0QBQEva/7Bqtk+6R9scH/Yt15vQFFNyrQgBRo85G9w3nue1vJbR7yVabCwRBl1RyQ==
X-Received: by 2002:a05:6000:1c0d:b0:216:c9f4:2b83 with SMTP id ba13-20020a0560001c0d00b00216c9f42b83mr11271648wrb.405.1654532438966;
        Mon, 06 Jun 2022 09:20:38 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id k5-20020adff285000000b002101ed6e70fsm11539684wro.37.2022.06.06.09.20.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jun 2022 09:20:38 -0700 (PDT)
Message-ID: <bf1d4cd1-d902-6efc-a954-58a11d85d9ac@redhat.com>
Date:   Mon, 6 Jun 2022 18:20:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] entry/kvm: Exit to user mode when TIF_NOTIFY_SIGNAL is
 set
Content-Language: en-US
To:     Seth Forshee <sforshee@digitalocean.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Sean Christopherson <seanjc@google.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, kvm@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
References: <20220504180840.2907296-1-sforshee@digitalocean.com>
 <Yp4LpgBHjvBEbyeS@do-x1extreme>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yp4LpgBHjvBEbyeS@do-x1extreme>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/6/22 16:13, Seth Forshee wrote:
> On Wed, May 04, 2022 at 01:08:40PM -0500, Seth Forshee wrote:
>> A livepatch transition may stall indefinitely when a kvm vCPU is heavily
>> loaded. To the host, the vCPU task is a user thread which is spending a
>> very long time in the ioctl(KVM_RUN) syscall. During livepatch
>> transition, set_notify_signal() will be called on such tasks to
>> interrupt the syscall so that the task can be transitioned. This
>> interrupts guest execution, but when xfer_to_guest_mode_work() sees that
>> TIF_NOTIFY_SIGNAL is set but not TIF_SIGPENDING it concludes that an
>> exit to user mode is unnecessary, and guest execution is resumed without
>> transitioning the task for the livepatch.
>>
>> This handling of TIF_NOTIFY_SIGNAL is incorrect, as set_notify_signal()
>> is expected to break tasks out of interruptible kernel loops and cause
>> them to return to userspace. Change xfer_to_guest_mode_work() to handle
>> TIF_NOTIFY_SIGNAL the same as TIF_SIGPENDING, signaling to the vCPU run
>> loop that an exit to userpsace is needed. Any pending task_work will be
>> run when get_signal() is called from exit_to_user_mode_loop(), so there
>> is no longer any need to run task work from xfer_to_guest_mode_work().
>>
>> Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> Cc: Petr Mladek <pmladek@suse.com>
>> Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
> 
> Friendly reminder as it seems like this patch may have been forgotten.

Probably AB-BA maintainer deadlock.  I have queued it now.

Paolo

> Thanks,
> Seth
> 
>> ---
>>   kernel/entry/kvm.c | 6 ------
>>   1 file changed, 6 deletions(-)
>>
>> diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
>> index 9d09f489b60e..2e0f75bcb7fd 100644
>> --- a/kernel/entry/kvm.c
>> +++ b/kernel/entry/kvm.c
>> @@ -9,12 +9,6 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
>>   		int ret;
>>   
>>   		if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL)) {
>> -			clear_notify_signal();
>> -			if (task_work_pending(current))
>> -				task_work_run();
>> -		}
>> -
>> -		if (ti_work & _TIF_SIGPENDING) {
>>   			kvm_handle_signal_exit(vcpu);
>>   			return -EINTR;
>>   		}
>> -- 
>> 2.32.0
>>
> 

