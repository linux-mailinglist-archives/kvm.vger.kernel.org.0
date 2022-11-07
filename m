Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D81C61F097
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 11:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbiKGK0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 05:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbiKGK0d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 05:26:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4689B19C02
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 02:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667816706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Iko1ii2ebczSgOsvA5noKLo6reij0uypJyH1/hTBVM=;
        b=g0LeHDjvNg/RknvytyHF6KAbMAtZhtgzbxbXt100ek9+JKJ5KZOYn5fw2a9FU21u38isVi
        pIm9UqjvM7PMSE8/rXADGlYPjbKk4n0zDl7xiW/v3WBwT1W4cIusUF41VyE5P7nNsu1aoL
        xT9xapctdNJZTMmfWipVWBzeYIibffw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-595-6Vl2gUskOiGuiIXznmdyFg-1; Mon, 07 Nov 2022 05:25:05 -0500
X-MC-Unique: 6Vl2gUskOiGuiIXznmdyFg-1
Received: by mail-qk1-f199.google.com with SMTP id ay43-20020a05620a17ab00b006fa30ed61fdso9727309qkb.5
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 02:25:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Iko1ii2ebczSgOsvA5noKLo6reij0uypJyH1/hTBVM=;
        b=gan8OS6rsXi6kTGUCT1IE0LoM8qxv8h3m80qvKdf6eugz6YhTaVXvF2V/FxxEhyz6P
         NjjLVVNsuqmTXsqsZEhPWbeNtiiYOjgis8hCKDH9NnN4HCKMAeHqk2fBCDISlt6kjhQb
         ItbFZtzbxcSb4MAcsq9sk8rUiUBmWga/tTJA343WJWYIwbfuy+cHJyYErIRiYsoUoRt6
         68APZ9vsfCRO/VbxjJACL8KaEdq4R6QQNkkj/7bs/WkJkrCHOgxLBeenr1rF5C+eCAE/
         RzYLtpTvQ/UTnbFV2yBxMGGEOggJ4Ce+zF1vZ2rvLGpH5JYF/ijyLfhJoe5qUpLK2u6h
         WI0w==
X-Gm-Message-State: ACrzQf0qw1NfKzhnL9aBPDgYI6ANJLqH73cphoLE6SLZinYqw+CNKUDG
        Fc1SsiGyFaC+tfSCYwdkIQbt17QQ8tSJXdKWPEh528sbIVWu2TmrV5/ZnYND0e1dzAzzXOdAIlb
        k7emMHaLAidHR
X-Received: by 2002:a05:620a:6c9:b0:6fa:9d10:1784 with SMTP id 9-20020a05620a06c900b006fa9d101784mr462127qky.627.1667816704664;
        Mon, 07 Nov 2022 02:25:04 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5AHzhcN/bP2uDy1t/E4fR3gNWYsyNh3upaZj8QrXavIj1o0uuLrLWWd4BaP8chDV20h7mTBA==
X-Received: by 2002:a05:620a:6c9:b0:6fa:9d10:1784 with SMTP id 9-20020a05620a06c900b006fa9d101784mr462111qky.627.1667816704408;
        Mon, 07 Nov 2022 02:25:04 -0800 (PST)
Received: from [10.33.192.232] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id bt12-20020ac8690c000000b003999d25e772sm5769536qtb.71.2022.11.07.02.25.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 02:25:03 -0800 (PST)
Message-ID: <5238980d-1b5f-43a7-57f4-2f98b23c4226@redhat.com>
Date:   Mon, 7 Nov 2022 11:25:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220902172737.170349-1-mjrosato@linux.ibm.com>
 <20220902172737.170349-9-mjrosato@linux.ibm.com>
 <1ffbe6ea-e42a-f84f-c499-0444ffca24ac@kaod.org>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v8 8/8] s390x/s390-virtio-ccw: add zpcii-disable machine
 property
In-Reply-To: <1ffbe6ea-e42a-f84f-c499-0444ffca24ac@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/11/2022 10.53, Cédric Le Goater wrote:
> Hello,
> 
> On 9/2/22 19:27, Matthew Rosato wrote:
>> The zpcii-disable machine property can be used to force-disable the use
>> of zPCI interpretation facilities for a VM.  By default, this setting
>> will be off for machine 7.2 and newer.
> 
> KVM will tell if the zPCI interpretation feature is available for
> the VM depending on the host capabilities and activation can be
> handled with the "interpret" property at the device level.
> 
> For migration compatibility, zPCI interpretation can be globally
> deactivated with a compat property. So, I don't understand how the
> "zpcii-disable" machine option is useful.
> 
> The patch could possibly be reverted for 7.2 and replaced with :
> 
>    @@ -921,9 +921,13 @@ static void ccw_machine_7_1_instance_opt
>     static void ccw_machine_7_1_class_options(MachineClass *mc)
>     {
>         S390CcwMachineClass *s390mc = S390_CCW_MACHINE_CLASS(mc);
>    +    static GlobalProperty compat[] = {
>    +        { TYPE_S390_PCI_DEVICE, "interpret", "off", },
>    +    };
>         ccw_machine_7_2_class_options(mc);
>         compat_props_add(mc->compat_props, hw_compat_7_1, hw_compat_7_1_len);
>    +    compat_props_add(mc->compat_props, compat, G_N_ELEMENTS(compat));
>         s390mc->max_threads = S390_MAX_CPUS;
>         s390mc->topology_capable = false;
> 
>     }

Thinking about this twice, I'm not sure whether we would need it at all 
since zpci cannot be migrated at all (see the "unmigratable = 1" in 
hw/s390x/s390-pci-bus.c) ... OTOH, doing it via the compat_props also does 
not really hurt.

Anyway, the zpcii-disable switch really does not seem to be necessary... 
Matthew, do you think it's ok if we revert "zpcii-disable" patch?

  Thomas

