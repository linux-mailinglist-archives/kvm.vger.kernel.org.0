Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8ED66D9080
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 09:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235633AbjDFHfL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 03:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235254AbjDFHfK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 03:35:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262AC128
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 00:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680766468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6S+MqW+j81U9Z/7F/WEgBtZH58QNAcAHFCnG7N2wysw=;
        b=Lzkn7PkPwX51LKSPcQ922I//fMB4aCbIQAgJhpAnwrzwixpI8lIDXrrZhZqlITmkLVpV4g
        YUQ6X2vJUzV1C1r5BKMNhoFmvi2BjNYzTUK4W//ZL+aU8+Q331p3V9FHHQS+UC5vpxq/VO
        ydyPSTT7ShY8Lm0q03AvmjFRACAFquc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-mYXgo4DdP-WIN3k42Aou6g-1; Thu, 06 Apr 2023 03:34:24 -0400
X-MC-Unique: mYXgo4DdP-WIN3k42Aou6g-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-930722de7ceso81344166b.3
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 00:34:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680766463; x=1683358463;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6S+MqW+j81U9Z/7F/WEgBtZH58QNAcAHFCnG7N2wysw=;
        b=ZtFk6qLJIUaKQoQtDPkiYRGzhT4sw3o4auzEOm8kubak8gIEFEacYra46Z4/z4/OKQ
         LUMqYX3yTif9NOTyBHn4vvsQA3onm6XXCaxRI7/YSiC0elKkXN3RBuIRqgjb+OjuBUb5
         FuV99SO0NGqmyd004X9gZoAzlFdu0YVm56nmzcG8PccxtKrg+wvUfAwaz7ahkOmu7BQ9
         +TXjmD9mLD6Nvq6vD/q4XpYnCXJa0OgnBvivdtwnj2IuD2UFHW8sRpaxsdARCaC55jUB
         ieka+JGOqwhoL4ZWVObOzbSDxB6Z2D3bGWg28jtyz5m/zgEuRdEwmqzo2m5M11MfdVTn
         wv+g==
X-Gm-Message-State: AAQBX9ds1AbNWj5CcqBVnI/A5zf/gB00pJRQu18S7ZDI0xOrzSOUKmAK
        nQAVwCSzjRe4mWx2Dr6PODeNSHHQN4cTBfiKwiyk1R+2hDK9ZX18Ctafmn4w/YOeywtAYs59xPo
        kJreeFcxrLbEo
X-Received: by 2002:aa7:c587:0:b0:4fa:b302:84d4 with SMTP id g7-20020aa7c587000000b004fab30284d4mr3831911edq.13.1680766463646;
        Thu, 06 Apr 2023 00:34:23 -0700 (PDT)
X-Google-Smtp-Source: AKy350axc4A6ANxIqMlT15hmeCvsMMAyHXq/91RNZX5x2tAWqpcl1qap5JVH6YLQcTr9JEuRNw0Jbg==
X-Received: by 2002:aa7:c587:0:b0:4fa:b302:84d4 with SMTP id g7-20020aa7c587000000b004fab30284d4mr3831894edq.13.1680766463324;
        Thu, 06 Apr 2023 00:34:23 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id a29-20020a509b5d000000b004fd204d180dsm346928edj.64.2023.04.06.00.34.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 00:34:22 -0700 (PDT)
Message-ID: <34e9da5c-f79a-db5e-bce6-95101e919097@redhat.com>
Date:   Thu, 6 Apr 2023 09:34:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: The necessity of injecting a hardware exception reported in VMX
 IDT vectoring information
Content-Language: en-US
To:     "Li, Xin3" <xin3.li@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "Yao, Yuan" <yuan.yao@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "H.Peter Anvin" <hpa@zytor.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
References: <SA1PR11MB673463616F7B1318874D11A3A8909@SA1PR11MB6734.namprd11.prod.outlook.com>
 <CABgObfaJwgBKkSfp=GP437jEKTP=_eCktdiKcujeSOgwv9dbiQ@mail.gmail.com>
 <SA1PR11MB673431B687B392B142129E72A8909@SA1PR11MB6734.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <SA1PR11MB673431B687B392B142129E72A8909@SA1PR11MB6734.namprd11.prod.outlook.com>
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

On 4/5/23 20:03, Li, Xin3 wrote:
>> If the second exception does not cause a vmexit, it is handled as usual by the
>> processor (by checking if the two exceptions are benign, contributory or page
>> faults). The behavior is the same even if the first exception comes from VMX
>> event injection.
>
> The case I was thinking is, both the first and the second exception don't cause
> any VM exit, however the first exception triggered an EPT violation. Later
> KVM injects the first exception and delivering of the first exception by the
> CPU triggers the second exception, then the information about the first
> KVM-injected exception is lost, and it can be re-generated once the second
> exception is correctly handled.

That's not a problem, the behavior is the same as on bare metal 
(depending on whether the two exceptions are benign/contributory/page 
faults).

Paolo

