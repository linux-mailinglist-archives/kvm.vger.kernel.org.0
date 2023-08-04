Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8A2770B2E
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 23:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbjHDVoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 17:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjHDVoG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 17:44:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75530F0
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 14:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691185400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WRmxLYIrCgq02IXbbQhHjflMDPccTOFGrJky+eGE/k8=;
        b=Kz2HubX5PRxVoxh5u5QQfLfAbWez7Rlioe70pGpvUypui8JPSEfO+KAIw3DOIUwYj9A9NO
        uJ6Z3500X26RVWEuM7BAUc9J/YpD3M5VmKtgMlB1LuP/8wxc11GCAKeGugKTvAsCRRYLTk
        yK/fPRqC7Ne39dkwVl0SIVVSf8C0yvY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-281-FRQGTZpCNk2RrmG0dULqmQ-1; Fri, 04 Aug 2023 17:43:19 -0400
X-MC-Unique: FRQGTZpCNk2RrmG0dULqmQ-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-99bdee94b84so389882766b.0
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 14:43:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691185398; x=1691790198;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WRmxLYIrCgq02IXbbQhHjflMDPccTOFGrJky+eGE/k8=;
        b=gA3IS2lBpGEIlPmnjqYsBxXZRARhWCejVWc5mqLwrKn1TqnBfwy6ma1eEoOUpJ87jo
         Mlv4/Pi9h7B5H//GIn/kQ+oVCv4yi2EU22N5uG16uCctn/V4tVlZ7biT+twF2DpSiVP2
         mBz46Q1NjSbm7xcE+pobMgKEMoHL8n1T7FE1/X1QlgAcfYa+aqUD76PMy1nfZwejZLDx
         qIwUWV8tEQR/NHQ4uChq0Cs8CxTo2KwoGjwFlqgfpJRQcbcfsC7Ol2n/PknM2m8r9Kwm
         zp1mU1OJ3CyrNBK6pdQByTC9xIUTfxho55j57ZGC0Tk6V5A/iXTRS2xxqSw5pTlR1lxo
         cmmw==
X-Gm-Message-State: AOJu0YxNg6un1FyiYdO6uCnzM8ax33NNlreNkBMTkmdYTC08nP/nocEX
        2CpkyzlUlMpo16BqBS9X8a3lxvM/ku4fyNeUL27dj6nEBhFRXdKJViHRT3jUqbbdxAjgp2Kuypc
        muj1IUljhNnz6
X-Received: by 2002:a17:906:8a44:b0:99b:cdfd:fb44 with SMTP id gx4-20020a1709068a4400b0099bcdfdfb44mr913700ejc.9.1691185398326;
        Fri, 04 Aug 2023 14:43:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEklM3VILACDcACrvQk+qwlMw4FzbNi8o+s75zI78aYnVIs33rmzbnT6NaghC2ulWxNTYj5zA==
X-Received: by 2002:a17:906:8a44:b0:99b:cdfd:fb44 with SMTP id gx4-20020a1709068a4400b0099bcdfdfb44mr913686ejc.9.1691185397983;
        Fri, 04 Aug 2023 14:43:17 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id x14-20020a1709064bce00b0098f33157e7dsm1826649ejv.82.2023.08.04.14.43.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Aug 2023 14:43:17 -0700 (PDT)
Message-ID: <8066f19d-68e9-711b-acdb-7554475602e6@redhat.com>
Date:   Fri, 4 Aug 2023 23:43:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v5 04/19] KVM:x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Cc:     peterz@infradead.org, john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com,
        chao.gao@intel.com, binbin.wu@linux.intel.com,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-5-weijiang.yang@intel.com>
 <ZM0hG7Pn/fkGruWu@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ZM0hG7Pn/fkGruWu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/23 18:02, Sean Christopherson wrote:
>> Update CPUID(EAX=0DH,ECX=1) when the guest's XSS is modified.
>> CPUID(EAX=0DH,ECX=1).EBX reports required storage size of
>> all enabled xstate features in XCR0 | XSS. Guest can allocate
>> sufficient xsave buffer based on the info.
>
> Please wrap changelogs closer to ~75 chars.  I'm pretty sure this isn't the first
> time I've made this request...

I suspect this is because of the long "word" CPUID(EAX=0DH,ECX=1).EBX. 
It would make the lengths less homogeneous if lines 1 stayed the same 
but lines 2-4 became longer.

Paolo

