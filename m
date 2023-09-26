Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD497AF123
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 18:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235352AbjIZQvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 12:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234905AbjIZQvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 12:51:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B6EDE
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 09:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695747020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cMSoSEixyIVudOMIe40c4w7ZTQb2ifmzLk6WEIsdc9M=;
        b=ca3cpgsBwn9cavS2p3rn+YfOGiYSCWkD2OtiJxLl1MHydmbZDti9r+zfQACXO9/WwUsjhS
        /Y1dcKB49T8k2SkSunGEMEuHUTIv2DV+NwBiab9f8kbznFMYy/q0dAUT7WF87FNNoO5sIB
        YkC87jrqSDDUGG6sA+kT92dTZ1O3Zdw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-TDITxgy6PKeFApPK9TnrfA-1; Tue, 26 Sep 2023 12:50:17 -0400
X-MC-Unique: TDITxgy6PKeFApPK9TnrfA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-404f81fe7cfso55553315e9.1
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 09:50:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695747016; x=1696351816;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cMSoSEixyIVudOMIe40c4w7ZTQb2ifmzLk6WEIsdc9M=;
        b=IGm54+enP57po1qjCCWFMvxEhRWcmZkfm0S0O55ODc3c2jyHhsJ2O8ylxhjSlWyPm7
         OiNlqL45DA8FzuRsmE5c/n+qxRYp6HUAwRzsQNdGGaLL4JUgZ7aZjKnqkomxdNkyV9O+
         OwLqIG62ZO9mMgL2cOY+P6vwtqNIJ6lZOmAuBhwBhaHIlnTD1iMNxsY9prY3TQErXB23
         TdOJSLEmPAQtgJyDjF8tj83husHZ3e4MJO1+SRlW9U2W5bPshfDpFztfUi7aWK8a+81n
         8b92B1gIyXUFMOVWHdpjzVL08QlRhl9yRD5T5yr3wvYvS65TuqgsY7jg4dIfjj12JimF
         A2Vw==
X-Gm-Message-State: AOJu0YwQdBflokfRDqla2araSkKX6Mng9q903JDoqKcsRLQhlJAYNsQY
        IIQQpgCeCTIOn8Cw4QJ7uiH/DSip2sFSY7hhCSp5nOYX+tnXAseKA8tzLMWgdlD9EjVsDZnj/Vm
        3+nAzLun34cncsljAJDVQ
X-Received: by 2002:a05:600c:1d07:b0:405:3be0:c78d with SMTP id l7-20020a05600c1d0700b004053be0c78dmr2461941wms.3.1695747016252;
        Tue, 26 Sep 2023 09:50:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHAQkTtUETwceEQ4G2o01LtoTRv0QuDzh0I6ymLH/AgSZeWmW0OyjOaPSmROM3kZLIgnn701g==
X-Received: by 2002:a05:600c:1d07:b0:405:3be0:c78d with SMTP id l7-20020a05600c1d0700b004053be0c78dmr2461918wms.3.1695747015913;
        Tue, 26 Sep 2023 09:50:15 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id m28-20020a05600c3b1c00b004053a2138bfsm14051900wms.12.2023.09.26.09.50.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Sep 2023 09:50:15 -0700 (PDT)
Message-ID: <0db86d5f-50d0-db25-e9ee-d92f2f463faf@redhat.com>
Date:   Tue, 26 Sep 2023 18:50:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 4/4] KVM: x86: add new nested vmexit tracepoints
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
References: <20230924124410.897646-1-mlevitsk@redhat.com>
 <20230924124410.897646-5-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230924124410.897646-5-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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

On 9/24/23 14:44, Maxim Levitsky wrote:
> +		trace_kvm_nested_page_fault(fault->address,
> +				vcpu->arch.ept_fault_error_code,

Any reason to include vcpu->arch.ept_fault_error_code rather than the 
injected exit qualification?

Paolo

> +				fault->error_code);

