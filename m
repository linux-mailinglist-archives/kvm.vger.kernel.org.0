Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C72663ED6C
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 11:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiLAKQ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 05:16:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiLAKQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 05:16:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642FF4E42F
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 02:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669889761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e9qA4VHIN82/Ab8wC5piRWKy3zE/49XyOR+31yHpXyI=;
        b=W/lewllybxZIY4uzuvAf3dZHhhiPFYPTF82EsrlvL86nRSzmleb/GSgnf02vCcKhB9QEOS
        YffBff2I0tQgPu8aMzCMos1uyi87I0LDBsyYa7/KptwXw8xIDv6LzqcaFNXvk03x60HLQC
        K/PlisXlDHR4eV9R49IbF3d9x8aU8cc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-315-tlQ9Sk_7NtWZMJrqqSjQVQ-1; Thu, 01 Dec 2022 05:15:58 -0500
X-MC-Unique: tlQ9Sk_7NtWZMJrqqSjQVQ-1
Received: by mail-wr1-f72.google.com with SMTP id h10-20020adfaa8a000000b0024208cf285eso268283wrc.22
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 02:15:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e9qA4VHIN82/Ab8wC5piRWKy3zE/49XyOR+31yHpXyI=;
        b=5NF/t/PIXmIsuwKLYwO3J0Rcb7K8359uK9mHpSnIeLITtmjriI/J7tkbUYH7KEu8xG
         3rU32xYqAkDjV4OQJzhZ0pQb3YXpOmYWGcRbOJqbj7KIjDIAktQcUnw/8QldXbEYH2Cy
         oIdH6SAxGS+YH3EANDTqaolxVmABltHnRKY7wRcaekcXr5ZS3TfWaSFYL55kyjq1kq/6
         quwfsVUTCfk/H49MMAE0Yay1Nk64V30zZV9qJEzLYynDa9p7PSuXFjGJNhsP2XdRff1C
         8EzCeyVhV/rgsMxPF8xQrWqFlf4/dr/iQ2tG0Xyo4SkSmBbMSZDWSilePF2rnoRMcjGl
         BDmw==
X-Gm-Message-State: ANoB5pkxKW0it8oS7wgDPq7CaMOrwL1WlD4oWtglMVBUcY0uiJmaIh9l
        xkVO/fpdn1n+mscvifx9nbwRsDUHHsea0G34qc0cFo1ZAOTODTGQGEK4P6IMFgcjsMBB1qnVw7/
        UW1PaXXKUTfwQ
X-Received: by 2002:a05:600c:34d3:b0:3cf:a7a8:b712 with SMTP id d19-20020a05600c34d300b003cfa7a8b712mr34056447wmq.124.1669889756953;
        Thu, 01 Dec 2022 02:15:56 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5SlmLRPzdxlyszVN8pGU01bp/jRPMDL3XBjakBkWtVRvdrvZ6Zw9bnrQwCp62f8f56RICv0g==
X-Received: by 2002:a05:600c:34d3:b0:3cf:a7a8:b712 with SMTP id d19-20020a05600c34d300b003cfa7a8b712mr34056432wmq.124.1669889756774;
        Thu, 01 Dec 2022 02:15:56 -0800 (PST)
Received: from [192.168.8.102] (tmo-073-221.customers.d1-online.com. [80.187.73.221])
        by smtp.gmail.com with ESMTPSA id e4-20020adff344000000b00236488f62d6sm4183014wrp.79.2022.12.01.02.15.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 02:15:56 -0800 (PST)
Message-ID: <fcedb98d-4333-9100-5366-8848727528f3@redhat.com>
Date:   Thu, 1 Dec 2022 11:15:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20221129174206.84882-1-pmorel@linux.ibm.com>
 <20221129174206.84882-7-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v12 6/7] s390x/cpu_topology: activating CPU topology
In-Reply-To: <20221129174206.84882-7-pmorel@linux.ibm.com>
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

On 29/11/2022 18.42, Pierre Morel wrote:
> The KVM capability, KVM_CAP_S390_CPU_TOPOLOGY is used to
> activate the S390_FEAT_CONFIGURATION_TOPOLOGY feature and
> the topology facility for the guest in the case the topology
> is available in QEMU and in KVM.
> 
> The feature is fenced for SE (secure execution).

Out of curiosity: Why does it not work yet?

> To allow smooth migration with old QEMU the feature is disabled by
> default using the CPU flag -disable-topology.

I stared at this code for a while now, but I have to admit that I don't 
quite get it. Why do we need a new "disable" feature flag here? I think it 
is pretty much impossible to set "ctop=on" with an older version of QEMU, 
since it would require the QEMU to enable KVM_CAP_S390_CPU_TOPOLOGY in the 
kernel for this feature bit - and older versions of QEMU don't set this 
capability yet.

Which scenario would fail without this disable-topology feature bit? What do 
I miss?

> Making the S390_FEAT_CONFIGURATION_TOPOLOGY belonging to the
> default features makes the -ctop CPU flag is no more necessary,

too many verbs in this sentence ;-)

> turning the topology feature on is done with -disable-topology
> only.
...

  Thomas


