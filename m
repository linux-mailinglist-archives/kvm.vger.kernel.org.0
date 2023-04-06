Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69C16D9037
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 09:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235540AbjDFHLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 03:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235403AbjDFHLv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 03:11:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE6FA279
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 00:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680765022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=adHnVuk2ILAzc5S+mXIHmJar+QuMmzx4aY5NT07+1Cc=;
        b=R5POzgkBFwxI7GzsoxGoLh+71au5jVmoZWlEzQFD7sSUQ2SOI3u9xq2sjadL54JZpDKM1M
        kccy5zcdQIMg6OO9CPkKY3M8NIpXlAb9t+oUHj887BS7Nr0CeGAj7WyWdKaH7n2M/x+As5
        jbCN5Wm7j9I7Dd07XOZTYhqq/FwDAV0=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-D3xUQcEEO_at8HQ3HLKdmA-1; Thu, 06 Apr 2023 03:10:20 -0400
X-MC-Unique: D3xUQcEEO_at8HQ3HLKdmA-1
Received: by mail-qv1-f71.google.com with SMTP id o14-20020a0cc38e000000b005e62747d93aso466396qvi.11
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 00:10:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680765020;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=adHnVuk2ILAzc5S+mXIHmJar+QuMmzx4aY5NT07+1Cc=;
        b=4GUY4T/gBWa3pfaxu4lYxqdFxD9kG+8hoRtg4XQDDQkKJluli5rYdwUPY/bmfp6K2X
         TLXHw4N4TRIXBQv/ktWFtVOqWaFM8LGeRi41rIapoAQ39jVxfWQxE2Gjm3LQS9gphr5A
         UcKR/vD9aEsyC/T8cYXKp8c5CAEKA5W2Ru+Ne2I4f8NTQz3KhSWyqmEGvkfzZi+zjNga
         MzWruBGjvGqQ9T569FKhnISxCgWLvjB3MyDCW1OtlkFYA1BRI1D/seXIGdEykDxKirrY
         HkaFCv5Z8y41OXKRnKaoh9EYq2uxKKYDMqBPBV4gvyBRSahGXVF1jVgFwsejbIiYeIXy
         PKEA==
X-Gm-Message-State: AAQBX9fDwU5TdO0T7LjTOE+Q3ne53Y4UW43O1sAzaIQUa8cBHYfAnFPk
        2fo+M1BJMzWWQWUArs5Ej4kY73QDPplfzcAVps4WbR73JNz5+PMjOJPxz6ZwxwaoTss1TEE3NuC
        RHxbXYZPAjJN9a7i5/4GsLU4=
X-Received: by 2002:a05:6214:2341:b0:5a5:7acf:c29f with SMTP id hu1-20020a056214234100b005a57acfc29fmr2382502qvb.52.1680765020373;
        Thu, 06 Apr 2023 00:10:20 -0700 (PDT)
X-Google-Smtp-Source: AKy350bkSdeKSkPNYlZkt8ttttbk2VC5v2YHZLnyQtUmdiHNEJUa62NwpJHcSOmNHof4DjwTzUe4xw==
X-Received: by 2002:a05:6214:2341:b0:5a5:7acf:c29f with SMTP id hu1-20020a056214234100b005a57acfc29fmr2382491qvb.52.1680765020129;
        Thu, 06 Apr 2023 00:10:20 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-178-193.web.vodafone.de. [109.43.178.193])
        by smtp.gmail.com with ESMTPSA id om8-20020a0562143d8800b005dd8b934587sm322027qvb.31.2023.04.06.00.10.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 00:10:19 -0700 (PDT)
Message-ID: <8b2fe89b-718c-074a-e566-41106dff016c@redhat.com>
Date:   Thu, 6 Apr 2023 09:10:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH] x86/flat.lds: Silence warnings about empty
 loadable segments
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230329123814.76051-1-thuth@redhat.com>
 <168073550254.619716.10085104611122942655.b4-ty@google.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <168073550254.619716.10085104611122942655.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/04/2023 01.01, Sean Christopherson wrote:
> On Wed, 29 Mar 2023 14:38:14 +0200, Thomas Huth wrote:
>> Recent versions of objcopy (e.g. from Fedora 37) complain:
>>
>>   objcopy: x86/vmx.elf: warning: empty loadable segment detected at
>>    vaddr=0x400000, is this intentional?
>>
>> Seems like we can silence these warnings by properly specifying
>> program headers in the linker script.
>>
>> [...]
> 
> Applied to kvm-x86 next, thanks!

Thanks for picking it up!

> On the topic of annoying warnings, this one is also quite annoying:
> 
>    ld: warning: setjmp64.o: missing .note.GNU-stack section implies executable stack
>    ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
> 
> I thought "-z noexecstack" would make it go away, but either I'm wrong or I'm not
> getting the flag set in the right place.

I never saw that warning here before, but I'm currently also still using an 
older version of GCC and binutils here since my development machine is still 
using RHEL 8 ...

Anyway, does this happen for the normal builds, or for the efi builds? I can 
see a .note.GNU-stack entry in x86/efi/elf_x86_64_efi.lds ... maybe we need 
something similar in x86/flat.lds ?

  Thomas

