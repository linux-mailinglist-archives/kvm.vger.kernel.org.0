Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572957A962A
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjIUQ7v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 12:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjIUQ7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 12:59:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE0A199D
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 09:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695315441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jkSn+PxPk9HUDFePBeJ+qJj/mQ3EC7rJPAPt5aKMVQM=;
        b=F/DriBNlnakBpwiZkokr3z+a5AgR3B9wCCeWop/EVSzLMj7wS5E6zW5rJdGUvhRzSNG/+w
        yCu2oTiHR78RFy5XWGRKTiGFLETjlkF3d2nrYF4hBvpyIVMVvJzbd9OThFQaTbCaLfxi7T
        doxlcyShmKX3finXVctwZIOxHUYLWOg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-groYQRNhOSSindLPmFryEw-1; Thu, 21 Sep 2023 08:38:53 -0400
X-MC-Unique: groYQRNhOSSindLPmFryEw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-405334b0873so4539095e9.0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 05:38:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695299931; x=1695904731;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jkSn+PxPk9HUDFePBeJ+qJj/mQ3EC7rJPAPt5aKMVQM=;
        b=E/hPp9Miq/ycFc0uXOqiZKDVyPpczffgdOB9TjXmbUdOe79gHIRXIBIig2fZqiUovn
         WQh7lrv1LRPThdCTDALcACSIDWsdkKHi8lsMcdVFZ+uoQbsyNMbV0/LB7cZkOCbSeJ0q
         LbeDupl9Oq43H0ou9I/fjGTRiAsiL1Q1YFvP+GYCiIPdoEGWbJJVzquk4dcOa8Wn6wHg
         8ToVCSnnLz6lZGwuN6sZvCyiKj6bHuVuZ5Kx4FtQX2C+3HJcworQd0EhssYkTfnuePqx
         DwFGq8FWVSU3mxDZn6QQK/oQwH/Fbng6zjR8ir4HCSsD9erkadpjobPNLKJSjeWmqBf8
         k2jA==
X-Gm-Message-State: AOJu0YzEqzTVboozlGSFQokQxbaO043OPNRcTExwnA//Srf+BIEuGswG
        cWX7W5wE3qCkVuTsGiPLGPIikvSll2D1eJzA6ln1BsJ2rjyZV/9ML0S7yNkcIt4lUlNqQ15VNOp
        UF+8ATV20xzFEDL1396Fw
X-Received: by 2002:a05:600c:2218:b0:3fe:d7c8:e0d with SMTP id z24-20020a05600c221800b003fed7c80e0dmr5342838wml.34.1695299931240;
        Thu, 21 Sep 2023 05:38:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFiI3gcW3I+u5Eo8SPNcaANg2683MWXN2khdedOCHDWhlltohFDz1lgyBkB4z+3k5LCX1UlHw==
X-Received: by 2002:a05:600c:2218:b0:3fe:d7c8:e0d with SMTP id z24-20020a05600c221800b003fed7c80e0dmr5342805wml.34.1695299930876;
        Thu, 21 Sep 2023 05:38:50 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id c12-20020adfed8c000000b0032179c4a46dsm1650846wro.100.2023.09.21.05.38.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 05:38:50 -0700 (PDT)
Message-ID: <9d2cccad-16ee-abcf-5a34-7e513a050229@redhat.com>
Date:   Thu, 21 Sep 2023 14:38:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 33/38] x86/entry: Add fred_entry_from_kvm() for VMX to
 handle IRQ/NMI
Content-Language: en-US
To:     Nikolay Borisov <nik.borisov@suse.com>, Xin Li <xin3.li@intel.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, seanjc@google.com, peterz@infradead.org,
        jgross@suse.com, ravi.v.shankar@intel.com, mhiramat@kernel.org,
        andrew.cooper3@citrix.com, jiangshanlai@gmail.com
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-34-xin3.li@intel.com>
 <8163cf98-8968-72a4-4193-1ca9f019d9ff@suse.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <8163cf98-8968-72a4-4193-1ca9f019d9ff@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/21/23 14:11, Nikolay Borisov wrote:
>>
>> +SYM_FUNC_START(asm_fred_entry_from_kvm)
>> +    push %rbp
>> +    mov %rsp, %rbp
> 
> use FRAME_BEGIN/FRAME_END macros to ommit this code if 
> CONFIG_FRAME_POINTER is disabled.

No, the previous stack pointer is used below, so the code might as well 
use %rbp for that; but it must do so unconditionally.

Paolo

>> +
>> +    UNWIND_HINT_SAVE
>> +
>> +    /*
>> +     * Don't check the FRED stack level, the call stack leading to this
>> +     * helper is effectively constant and shallow (relatively speaking).
>> +     *
>> +     * Emulate the FRED-defined redzone and stack alignment.
>> +     */
>> +    sub $(FRED_CONFIG_REDZONE_AMOUNT << 6), %rsp
>> +    and $FRED_STACK_FRAME_RSP_MASK, %rsp
>> +
>> +    /*
>> +     * Start to push a FRED stack frame, which is always 64 bytes:
>> +     *
>> +     * +--------+-----------------+
>> +     * | Bytes  | Usage           |
>> +     * +--------+-----------------+
>> +     * | 63:56  | Reserved        |
>> +     * | 55:48  | Event Data      |
>> +     * | 47:40  | SS + Event Info |
>> +     * | 39:32  | RSP             |
>> +     * | 31:24  | RFLAGS          |
>> +     * | 23:16  | CS + Aux Info   |
>> +     * |  15:8  | RIP             |
>> +     * |   7:0  | Error Code      |
>> +     * +--------+-----------------+
>> +     */
>> +    push $0                /* Reserved, must be 0 */
>> +    push $0                /* Event data, 0 for IRQ/NMI */
>> +    push %rdi            /* fred_ss handed in by the caller */
>> +    push %rbp

^^ here

Paolo

>> +    pushf
>> +    mov $__KERNEL_CS, %rax
>> +    push %rax 

