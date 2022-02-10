Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8994B09FF
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 10:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239187AbiBJJxZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 04:53:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239174AbiBJJxZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 04:53:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A3CAC318
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 01:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644486805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ALXd4CkpYhz0PzrpWR8ccebfEXt2RH4smcsnpQnLsk=;
        b=UZDzIv9ZoI9s0CIq9GiXHT82B2QJo9BPqANMT9PhnXYCot0gCln8BhMSlR5Ra776aZ9u7h
        Hn/W7ggMhyEVS1TyEW8L6cwOngDgphaQoTDr6F8asqeKn5tz6Kso0LGvB5Q2iVM8Bfiwgw
        Bg+/s5Ejlcn3AP2Qu9dEE/SC7iCAbY4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-I6IMQv9GNvit7i2RXZMcQA-1; Thu, 10 Feb 2022 04:53:24 -0500
X-MC-Unique: I6IMQv9GNvit7i2RXZMcQA-1
Received: by mail-ed1-f70.google.com with SMTP id w3-20020a50c443000000b0040696821132so3013002edf.22
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 01:53:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2ALXd4CkpYhz0PzrpWR8ccebfEXt2RH4smcsnpQnLsk=;
        b=ywQTW3xbGi8oF2Wg5ddrW0Qsv+H0MJmtAI0FF8DzZD88njoywbx+IVl+1AiXckIBWv
         Q8I59jLrfnoaA+Q1yElIuole8jkaVmq2NVJ2oWeclwuoTRhUw4NlguukRdZFdTayCZUl
         BwFpvaxdiuqw/z8mX8ELxQTqix8RXSKaEYDKZLMJ2EWEIt6QA3YOP1kAZUTfDVkvuevI
         dGZ4l0EI2DalUtCrrAMHS43H3LOh/Hc7m0CBR7ciy6NWJ18yn8Ly1r0eqC29NM+tCWaU
         4jYOutCQs8tE93bPNoXBRsaZdZJWKxr9X2cAqPJZ7OIw9CtZT5EDAcl2FfRyBZfQ5nRa
         2Fiw==
X-Gm-Message-State: AOAM531bQdrZrNxdjTY/0I4pL4eoxugMMZXlFOeEoBarHp4nvYxpO9Uz
        P8oNFVMwRDtgxOTWMyLLle9TmMxnr1QncD/iMN6TnjJaZS4e0WlNcTY7tlBKlNYBRS5AlBvXjGA
        DcT4sPnnD5UtQ
X-Received: by 2002:a05:6402:4c2:: with SMTP id n2mr7224991edw.247.1644486803371;
        Thu, 10 Feb 2022 01:53:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxYsGzFAIAxGewz0MvOdM1WduQkHptGANoYIsynhjpXJkagAgM4JHO0ZXxslFEDVseEyx+sdg==
X-Received: by 2002:a05:6402:4c2:: with SMTP id n2mr7224973edw.247.1644486803214;
        Thu, 10 Feb 2022 01:53:23 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id i5sm3866374ejh.13.2022.02.10.01.53.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 01:53:22 -0800 (PST)
Message-ID: <7e2767c2-d772-a485-ce8c-ed5d4da06b3f@redhat.com>
Date:   Thu, 10 Feb 2022 10:53:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 03/23] KVM: MMU: remove valid from extended role
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com, vkuznets@redhat.com
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-4-pbonzini@redhat.com> <YgRGQ1HiB2jSTr5M@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YgRGQ1HiB2jSTr5M@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/22 23:54, Sean Christopherson wrote:
> Nope, it's not guaranteed to be non-zero:
> 
> static int role_regs_to_root_level(struct kvm_mmu_role_regs *regs)
> {
> 	if (!____is_cr0_pg(regs))
> 		return 0; <=============================================
> 	else if (____is_efer_lma(regs))
> 		return ____is_cr4_la57(regs) ? PT64_ROOT_5LEVEL :
> 					       PT64_ROOT_4LEVEL;
> 	else if (____is_cr4_pae(regs))
> 		return PT32E_ROOT_LEVEL;
> 	else
> 		return PT32_ROOT_LEVEL;
> }
> 

Yes, see my reply to David.  At the end of the series the assumption is 
correct:

- level is always nonzero in mmu_role

- one of level or direct (which is !CR0.PG) is always nonzero in cpu_role

So the patch can be kept but it has to be moved much later.

Paolo

