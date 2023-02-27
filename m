Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD2626A42C4
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 14:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjB0NeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 08:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjB0Ndu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 08:33:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABA7AD1A
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 05:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677504775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hPF6OqkldqKMAfXygeIPr6QHZzjaTi2wskjIdYzJSBk=;
        b=bSXorY18q3une212ebBYQTuZvT9uJldgYQgNaObLMtacF0Tl4rfjvUfW+kvd0CgI7yQPZ0
        zvY7cFmtivLsKvcNnfoU7kV3GCC7trGj7iZengEnwmVT9ImWRqba2lIHyx/KRjgXO45mM4
        CEAM2XQKbPdcG+nB8y2VfyRQ+sZT4zI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-189-skj44yuuOxmcOd7Xv8KsLw-1; Mon, 27 Feb 2023 08:32:53 -0500
X-MC-Unique: skj44yuuOxmcOd7Xv8KsLw-1
Received: by mail-wm1-f70.google.com with SMTP id l20-20020a05600c1d1400b003e10d3e1c23so5353005wms.1
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 05:32:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hPF6OqkldqKMAfXygeIPr6QHZzjaTi2wskjIdYzJSBk=;
        b=f7E2iSeQuhvB2ZqU+MZ+SgJNVjpmVt6fYmttMJHpeaFTUOmAwQ+PP51+8JUzn+eWZD
         A3ixuheQt7r808pDwiNWIgZYf3VSaHl59GKU5nk5RHmIhTBlZsl8kKbmZ/A2sMuuw2H7
         aI6Ty8vCwQ0BThLAstrjcWS6N1D9EUnIB6muVbSoVif761DQuI2e4BssF8wD+w0ttYZF
         psj85hY2jHsigWiD8dzEhT6URHclcDhBEkGlNMGXvqLOY+Cjcfmsczuv3mMSVldS3jza
         BUoY8mCPq36MZ4SLj6+ii/U8TolHBWmKdR2O8w+JEc+e5+vYJ7YgAFQ2XSCHfY5P81ps
         P7AQ==
X-Gm-Message-State: AO0yUKUNvleMz0RJVFbJ8VGdhvZ2UAD5bw2hiQPJn5YfXlN1fTls88bh
        UHtRf2YiDgXeAp7FPWrE6c1abBgbwZNZ0s54WLw0yHG2sEEPV/ADOvOSVcqMVK4QSLlN3NFcWJ7
        LsjSp5zMYRZBh
X-Received: by 2002:a05:600c:1c86:b0:3ea:ed4d:38f6 with SMTP id k6-20020a05600c1c8600b003eaed4d38f6mr12435580wms.4.1677504772806;
        Mon, 27 Feb 2023 05:32:52 -0800 (PST)
X-Google-Smtp-Source: AK7set/HHsOVoCqCSi4LLgNkgXWJ8tbRO76NvBzHEZr9RzACY5CRnnRRggW5lBz8VKGsyv0o7aCVfQ==
X-Received: by 2002:a05:600c:1c86:b0:3ea:ed4d:38f6 with SMTP id k6-20020a05600c1c8600b003eaed4d38f6mr12435555wms.4.1677504772515;
        Mon, 27 Feb 2023 05:32:52 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-150.web.vodafone.de. [109.43.176.150])
        by smtp.gmail.com with ESMTPSA id c2-20020a5d4cc2000000b002bfd524255esm6983507wrt.43.2023.02.27.05.32.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 05:32:51 -0800 (PST)
Message-ID: <9a029d4e-4794-9a6a-7516-bed8feb39d97@redhat.com>
Date:   Mon, 27 Feb 2023 14:32:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v16 10/11] qapi/s390x/cpu topology:
 CPU_POLARIZATION_CHANGE qapi event
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
 <20230222142105.84700-11-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230222142105.84700-11-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/02/2023 15.21, Pierre Morel wrote:
> When the guest asks to change the polarization this change
> is forwarded to the admin using QAPI.
> The admin is supposed to take according decisions concerning
> CPU provisioning.

I still find it weird talking about "the admin" here. I don't think any 
human will monitor this event to take action on it. Maybe rather talk about 
the "upper layer" (libvirt) or whatever you have in mind to monitor this event?

> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> index baa9d273cf..e7a9049c1f 100644
> --- a/qapi/machine-target.json
> +++ b/qapi/machine-target.json
> @@ -389,3 +389,37 @@
>     'features': [ 'unstable' ],
>     'if': { 'all': [ 'TARGET_S390X' ] }
>   }
> +
> +##
> +# @CPU_POLARIZATION_CHANGE:
> +#
> +# Emitted when the guest asks to change the polarization.
> +#
> +# @polarization: polarization specified by the guest
> +#
> +# Features:
> +# @unstable: This command may still be modified.
> +#
> +# The guest can tell the host (via the PTF instruction) whether the
> +# CPUs should be provisioned using horizontal or vertical polarization.
> +#
> +# On horizontal polarization the host is expected to provision all vCPUs
> +# equally.
> +# On vertical polarization the host can provision each vCPU differently.
> +# The guest will get information on the details of the provisioning
> +# the next time it uses the STSI(15) instruction.
> +#
> +# Since: 8.0
> +#
> +# Example:
> +#
> +# <- { "event": "CPU_POLARIZATION_CHANGE",
> +#      "data": { "polarization": 0 },
> +#      "timestamp": { "seconds": 1401385907, "microseconds": 422329 } }
> +#

I'd remove the final empty line.

> +##
> +{ 'event': 'CPU_POLARIZATION_CHANGE',
> +  'data': { 'polarization': 'CpuS390Polarization' },
> +  'features': [ 'unstable' ],
> +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
> +}

  Thomas

