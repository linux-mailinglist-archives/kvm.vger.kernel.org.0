Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E317253299B
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 13:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbiEXLnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 07:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236945AbiEXLnu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 07:43:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B2073939AB
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 04:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653392523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8UkRKYgvR5N7mLPjjPEcjbxrGaS1UyWcr5Nl7D8zmwQ=;
        b=brAivGbhceK7/vWjhdAEpdVOxpAsAWlx0qMvmJFpEn2J9kjFd13uh0AilP5KcN2UGFaWtt
        TG9evj2MJcpA0d9VFi8qhtVjqC39+P6wyEj5Rx5jz4mXouCxEFGa7nYTnAlJlVMc6mnBrP
        NYet5VHAjtv3t8Oa3JMDXcJkBlszgks=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-Xt5T8FZvNH2dsoB6q8fanQ-1; Tue, 24 May 2022 07:32:25 -0400
X-MC-Unique: Xt5T8FZvNH2dsoB6q8fanQ-1
Received: by mail-wm1-f71.google.com with SMTP id n18-20020a05600c3b9200b0039746f3d9faso2919576wms.4
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 04:32:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8UkRKYgvR5N7mLPjjPEcjbxrGaS1UyWcr5Nl7D8zmwQ=;
        b=Ldek3Xcw5wmgBaIkgx8DYnf2C/i4altrQ2fatAhKwO66Weume/kiGgL0/jmKMqcxqk
         7CdsbR50Myhe6sN17lIkMljOLDnWemZ3snsopyKMXaMtxL/pkEm4FTRhOhOQKOz0ubtO
         dIxgunuGbERBzJYIsWR9MIYbyFx+MAyxF5HvTi8SXN8wNCUZjJT4DqbTP3taPLa/nD4J
         chJdMj8bissz7Ls0sL3Z2xNXt6jGccTkQF1Cps+t1nytX48Q+aegPdOdkmIJ5xUUEoxl
         WAM7djV013Hq8qYEJUPhH70yZLhUJg2e5ncMjiiVrVwdd4HkeGS5tyvJDfV5Hy5j7ksw
         IOGg==
X-Gm-Message-State: AOAM531kPFCiHzW3PfzV4xkRy4T/3K2WrO4Xhdq0oyco3CWda9vFnegZ
        qyxzveLxKbPhnR6eUt3NOOrR3v4MPAPJe1aSoOJcdxFTTwaiKLqwU2lXzCHoMsXPg2hDEv85SHQ
        kZJeMVYcHgZXE
X-Received: by 2002:adf:fd0e:0:b0:20d:110b:5c52 with SMTP id e14-20020adffd0e000000b0020d110b5c52mr24089138wrr.82.1653391944656;
        Tue, 24 May 2022 04:32:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5LF5PkCk5l/pqnDPSExPww/J7WMai8gIUo4yCKyd1IGl+Zob3/ctwrcZohtPUt0Gbwub3Bw==
X-Received: by 2002:adf:fd0e:0:b0:20d:110b:5c52 with SMTP id e14-20020adffd0e000000b0020d110b5c52mr24089124wrr.82.1653391944481;
        Tue, 24 May 2022 04:32:24 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id l4-20020adfbd84000000b0020e5d2a9d0bsm15030262wrh.54.2022.05.24.04.32.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 04:32:23 -0700 (PDT)
Message-ID: <3d9badda-6939-9ea0-5554-ba15c0c0cb02@redhat.com>
Date:   Tue, 24 May 2022 13:32:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v7 12/13] s390x: CPU topology: CPU topology migration
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com
References: <20220420115745.13696-1-pmorel@linux.ibm.com>
 <20220420115745.13696-13-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220420115745.13696-13-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/2022 13.57, Pierre Morel wrote:
> To migrate the Multiple Topology Change report, MTCR, we
> get it from KVM and save its state in the topology VM State
> Description during the presave and restore it to KVM on the
> destination during the postload.
> 
> The migration state is needed whenever the CPU topology
> feature is activated.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
...
> @@ -2592,22 +2594,57 @@ static void kvm_s390_set_mtr(uint64_t attr)
>           .group = KVM_S390_VM_CPU_TOPOLOGY,
>           .attr  = attr,
>       };
> +    int ret;
>   
> -    int ret = kvm_vm_ioctl(kvm_state, KVM_SET_DEVICE_ATTR, &attribute);
> -
> +    ret = kvm_vm_ioctl(kvm_state, KVM_SET_DEVICE_ATTR, &attribute);

Nit: Unnecessary code churn.

  Thomas

