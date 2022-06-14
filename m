Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB33054B04F
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 14:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356932AbiFNMNN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 08:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356940AbiFNMM7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 08:12:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A288D4A3DD
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 05:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655208767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9NJS7vTeV+3f52O3a1sXabKwOSd+YPOK4Fgue9n4dN8=;
        b=ZNdkPki2fQuEujwbm5KgJteuvOCzjI8lD+67wrVk3RmsaIrkRjtCyhgsx+RvX8Xx3pxrxc
        +Ml11wVkiz3pdmIDj9TXX+iKdWdd2/8oeLykxMd7LZCKC2XiyjgLlssDgbJuRrg/BxJRt1
        CxK+E/qsOklCYlGWcanNR33lZcsJxN0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-e6PcFOPHPK6X5rlNnbbgAw-1; Tue, 14 Jun 2022 08:12:46 -0400
X-MC-Unique: e6PcFOPHPK6X5rlNnbbgAw-1
Received: by mail-wr1-f72.google.com with SMTP id e15-20020adfa44f000000b00219ebf65301so1244735wra.4
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 05:12:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9NJS7vTeV+3f52O3a1sXabKwOSd+YPOK4Fgue9n4dN8=;
        b=EYzGX86a1S4qUH6RWG9V/w5fkvnIHZ3fPNztfm1B8c5jJmvBcTdBo8LkGynTNax+8O
         +yGnCVAR5V5YPMZ7JX4fntOGbb/hXzLxDvrkS8BnnAM77QrvlEkatkuQeq73Q6EEv8Os
         2z9B+NEJK8QSh6xAk8zRJdRkv+BHCqYWEM+NOQs4B1iR3v7rcXko/7XG8uyPenrJRmzN
         3CwggPEXd1gTyEwSoUKH7r9mu3n3zRzraqMbQ3+QkO2ujs/winwZGMeYqsn69YrE1Iby
         /DFrdOCY1ViX/MKSJksc7wG33p0CKmNK2WiNSI3tnyorz9Jbe6P5S+GUhVdQMdDg80T5
         ymsg==
X-Gm-Message-State: AOAM531UrloVUIzgPC/wcInhBsQAKYpJLmdMDqQO0EPglgYbzUGBdU0d
        I5kYAbL6Ap2NUPcneGVLPsrZCtNt2WHdV5dG7i2aPtBgUMrCsggOnLYljsCHYnfgYGL6hEaBN1v
        kca6hs2H1c4eC
X-Received: by 2002:a05:600c:3551:b0:39c:8a93:869 with SMTP id i17-20020a05600c355100b0039c8a930869mr3733108wmq.107.1655208765109;
        Tue, 14 Jun 2022 05:12:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEXTquH8/sxyWSRyBCfv+emQNXo3WD5eknmqSPFC9vd0yNZB55lljxFkUFtPUVzYuR4l3yEw==
X-Received: by 2002:a05:600c:3551:b0:39c:8a93:869 with SMTP id i17-20020a05600c355100b0039c8a930869mr3733075wmq.107.1655208764777;
        Tue, 14 Jun 2022 05:12:44 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id 63-20020a1c1942000000b0039c84c05d88sm12472762wmz.23.2022.06.14.05.12.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 05:12:43 -0700 (PDT)
Message-ID: <7a5d48d0-d1b5-91aa-8966-54d9ac986126@redhat.com>
Date:   Tue, 14 Jun 2022 14:12:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm:queue 5/184] arch/x86/kvm/svm/avic.c:913:6: warning: shift
 count >= width of type
Content-Language: en-US
To:     kernel test robot <lkp@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>
References: <202206132237.17DFkdFl-lkp@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <202206132237.17DFkdFl-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        UPPERCASE_50_75 autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/13/22 16:49, kernel test robot wrote:
>     902	
>     903	bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
>     904	{
>     905		ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
>     906				  BIT(APICV_INHIBIT_REASON_ABSENT) |
>     907				  BIT(APICV_INHIBIT_REASON_HYPERV) |
>     908				  BIT(APICV_INHIBIT_REASON_NESTED) |
>     909				  BIT(APICV_INHIBIT_REASON_IRQWIN) |
>     910				  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
>     911				  BIT(APICV_INHIBIT_REASON_X2APIC) |
>     912				  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
>   > 913				  BIT(APICV_INHIBIT_REASON_SEV      |
>     914				  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
>     915				  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED));

Ouch, saw this right after sending a pull request. :(

I'll do the fixup.

Paolo

