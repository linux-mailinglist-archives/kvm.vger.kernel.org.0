Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51596402EA
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 10:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbiLBJGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 04:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbiLBJG2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 04:06:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630F3F2
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 01:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669971929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PfJ93dLRCeG2GBsUtx3//WXn16R7gr7n62jhn2ToEZQ=;
        b=e/diA4bscdT5iChz84V5E9m2bdrHFPIBhYwedjTcEZOYmPvr3MieW7337pA1ZU0v9l1igA
        nyU7ds5y0IF1K8aY12nmpuazxygFKiztVT1ILfrazjAXayLPHT9kc7dFXRbx5/rJftqCJ5
        wETl1sNMdeSzpATb07BuZT4nskVzsiE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-533-8duqE_txO8eAAgnhjNT1pw-1; Fri, 02 Dec 2022 04:05:27 -0500
X-MC-Unique: 8duqE_txO8eAAgnhjNT1pw-1
Received: by mail-wm1-f71.google.com with SMTP id bi19-20020a05600c3d9300b003cf9d6c4016so3829997wmb.8
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 01:05:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PfJ93dLRCeG2GBsUtx3//WXn16R7gr7n62jhn2ToEZQ=;
        b=U0aCSlrvYioESWUU+zsvfCfzbaSbK6SSpOQ7vQqDD3yeK03RoPelOJuDEQ1eqIIX8L
         4Vt75qnx3vUMWEZw55lrogw+kur5peAvIQCTpIWK2bfO65ecdg8awGskVYtPQtRICAmt
         tQv3+3hzdLbCdt1iYSc5dnCRCLjJI4+zhB6z/hLq/WV9Thrp3/wLoqwSe0Ikil+0ZW0p
         TuYYejnRjRVE9JlM8U/zKwYtGABNeaSs9knAEWaeHKPpbnX64xb14/DpOhooFN556mFU
         V7Kdg5OC2t2P8d3MoZD6zq2VxnENy8YDPS36ySIDoo9Paewlf69ve7pbeKWYDCcnjfqO
         Txrg==
X-Gm-Message-State: ANoB5plw80bVmwKg1FsBlBiDB1aXR2Uyk4W18v//je5XLUS2/XGpwQfy
        D+JaXEViOkZP/CK2zdDgurxYgs+w6LK7BaVwtFHqvHbRBqE8yei5U933fTYdHo6n0C7KdJe6t2U
        0ayQW6rMEhf6d
X-Received: by 2002:a5d:6045:0:b0:242:16ad:9a91 with SMTP id j5-20020a5d6045000000b0024216ad9a91mr15335411wrt.197.1669971926847;
        Fri, 02 Dec 2022 01:05:26 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6WJceT8QBVUD0zpPQkSfWy5DScDnZDc3La9y+xbLksGd4EzJm0mv7STAApMu247vDJZ0sbSQ==
X-Received: by 2002:a5d:6045:0:b0:242:16ad:9a91 with SMTP id j5-20020a5d6045000000b0024216ad9a91mr15335397wrt.197.1669971926631;
        Fri, 02 Dec 2022 01:05:26 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-178-86.web.vodafone.de. [109.43.178.86])
        by smtp.gmail.com with ESMTPSA id r2-20020a056000014200b002422bc69111sm8080008wrx.9.2022.12.02.01.05.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 01:05:26 -0800 (PST)
Message-ID: <37a20bee-a3fb-c421-b89d-c1760e77cb11@redhat.com>
Date:   Fri, 2 Dec 2022 10:05:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org,
        david@redhat.com
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, cohuck@redhat.com, mst@redhat.com,
        pbonzini@redhat.com, kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20221129174206.84882-1-pmorel@linux.ibm.com>
 <20221129174206.84882-7-pmorel@linux.ibm.com>
 <fcedb98d-4333-9100-5366-8848727528f3@redhat.com>
 <ea965d1c-ab6a-5aa3-8ce3-65b8177f6320@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v12 6/7] s390x/cpu_topology: activating CPU topology
In-Reply-To: <ea965d1c-ab6a-5aa3-8ce3-65b8177f6320@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/12/2022 12.52, Pierre Morel wrote:
> 
> 
> On 12/1/22 11:15, Thomas Huth wrote:
>> On 29/11/2022 18.42, Pierre Morel wrote:
>>> The KVM capability, KVM_CAP_S390_CPU_TOPOLOGY is used to
>>> activate the S390_FEAT_CONFIGURATION_TOPOLOGY feature and
>>> the topology facility for the guest in the case the topology
>>> is available in QEMU and in KVM.
>>>
>>> The feature is fenced for SE (secure execution).
>>
>> Out of curiosity: Why does it not work yet?
>>
>>> To allow smooth migration with old QEMU the feature is disabled by
>>> default using the CPU flag -disable-topology.
>>
>> I stared at this code for a while now, but I have to admit that I don't 
>> quite get it. Why do we need a new "disable" feature flag here? I think it 
>> is pretty much impossible to set "ctop=on" with an older version of QEMU, 
>> since it would require the QEMU to enable KVM_CAP_S390_CPU_TOPOLOGY in the 
>> kernel for this feature bit - and older versions of QEMU don't set this 
>> capability yet.
>>
>> Which scenario would fail without this disable-topology feature bit? What 
>> do I miss?
> 
> The only scenario it provides is that ctop is then disabled by default on 
> newer QEMU allowing migration between old and new QEMU for older machine 
> without changing the CPU flags.
> 
> Otherwise, we would need -ctop=off on newer QEMU to disable the topology.

Ah, it's because you added S390_FEAT_CONFIGURATION_TOPOLOGY to the default 
feature set here:

  static uint16_t default_GEN10_GA1[] = {
      S390_FEAT_EDAT,
      S390_FEAT_GROUP_MSA_EXT_2,
+    S390_FEAT_DISABLE_CPU_TOPOLOGY,
+    S390_FEAT_CONFIGURATION_TOPOLOGY,
  };

?

But what sense does it make to enable it by default, just to disable it by 
default again with the S390_FEAT_DISABLE_CPU_TOPOLOGY feature? ... sorry, I 
still don't quite get it, but maybe it's because my sinuses are quite 
clogged due to a bad cold ... so if you could elaborate again, that would be 
very appreciated!

However, looking at this from a distance, I would not rather not add this to 
any default older CPU model at all (since it also depends on the kernel to 
have this feature enabled)? Enabling it in the host model is still ok, since 
the host model is not migration safe anyway.

  Thomas

