Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C15596B8D
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 10:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235318AbiHQIpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 04:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238282AbiHQIpX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 04:45:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2FE74B8F
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 01:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660725921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p/gDo76UwTmViEx13ZIEnXWDsVcvV6S3aUwfWuW0178=;
        b=ZDrsgY75BHyYvhC8kIYHQiEXAM/pqDF4mTxiqUqRLkqrdzp8+oIUU+XV6Y4CykYCNggnaS
        wcIS4+I2a3uNA/E+m2+Yz9oKnF5VUx4vv362J0G2g5zIPokdJIdB37lON5fjvCMPs/rZUE
        Xg5QLCOytwIjgkkN0Ou4u4DbUwDqySE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-615-5aYLSDLhOGqXwbKGApzGGg-1; Wed, 17 Aug 2022 04:45:19 -0400
X-MC-Unique: 5aYLSDLhOGqXwbKGApzGGg-1
Received: by mail-ej1-f70.google.com with SMTP id qf23-20020a1709077f1700b007308a195618so2654540ejc.7
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 01:45:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=p/gDo76UwTmViEx13ZIEnXWDsVcvV6S3aUwfWuW0178=;
        b=cJpDAB1OVZOl2sT69PlUAuB0U+0WOPYUgunQ5Xx4GkpYJwddKEyLXyGh3+RH4hNLWP
         qAkW9zSOlRNEyFHR3iONPUkg19EPuwqAdgtgVxQK+zvDqJJpDB7Z/AvY86krCJFATrZy
         vnHuxWw3tlXZyLLF77oieRCDWZ+Hb9O5YVuXATITkco0n211tNkclTKZhABVg+f6DjOt
         CNKzVcDB4betYXd/07elCaboIijzju+87Rtr8ikQlFoyqAGMyXinCMoOqsOszgVbMJEU
         mop+WRahO6v+PHLyexdM+yoz1tqf3sC3ZK7wKTld9n3nhDmSA3b7bwKha1XWYIDawhSf
         rv2g==
X-Gm-Message-State: ACgBeo35rkUni1d5LZT4ZxfeI2kkTJZNVKofuPcEiYNNP7rktVxsjhjE
        qy6fLlZNjqF2B507Q1gQlltjrlkZzRRCXDCrR4OsXp2se5oZknF+BoAtB6oRuE8tA5lhldQxeYm
        53E0pu5ZdRTf6
X-Received: by 2002:a05:6402:35c:b0:43c:8f51:130 with SMTP id r28-20020a056402035c00b0043c8f510130mr22069661edw.393.1660725918838;
        Wed, 17 Aug 2022 01:45:18 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5AMm80dBw8wUUUR+UqHcBujLtUvJk4USLHFXwkNf0tAYNyaMXZlXOZmkAx/1CzOJRTLVTo1A==
X-Received: by 2002:a05:6402:35c:b0:43c:8f51:130 with SMTP id r28-20020a056402035c00b0043c8f510130mr22069645edw.393.1660725918646;
        Wed, 17 Aug 2022 01:45:18 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id o2-20020a170906358200b00730979f568fsm6393950ejb.150.2022.08.17.01.45.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 01:45:18 -0700 (PDT)
Message-ID: <a76066e2-af2c-1be2-5e3e-1f42557523e6@redhat.com>
Date:   Wed, 17 Aug 2022 10:45:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     =?UTF-8?Q?Leonardo_Br=c3=a1s?= <leobras@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc:     kvm@vger.kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org
References: <20220816175936.23238-1-dgilbert@redhat.com>
 <YvwODUu/rdzjzDjk@google.com>
 <e9b456cee5032c62cab6b9a3ab1411196d4d1c3c.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86: Always enable legacy fp/sse
In-Reply-To: <e9b456cee5032c62cab6b9a3ab1411196d4d1c3c.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/17/22 05:29, Leonardo Brás wrote:
>>> QEMU always calls kvm_put_xsave, even on this combination because
>>> KVM_CAP_CHECK_EXTENSION_VM always returns true for KVM_CAP_XSAVE.
> Any particular reason why it always returns true for KVM_CAP_XSAVE, even when
> the CPU does not support it?
> 
> IIUC, if it returns false to this capability, kvm_put_xsave() should never be
> called, and thus it can avoid bug reproduction.

Because it allows userspace to have a single path for saving/restoring 
FPU state.  See for example the "migration" code in 
tools/testing/selftests/kvm/lib/x86_64/processor.c (the vcpu_save_state 
and vcpu_load_state functions).

In fact, the QEMU code that uses KVM_GET_FPU/KVM_SET_FPU in x86 is 
obsolete, because it's not been used since Linux 2.6.36.

Paolo

