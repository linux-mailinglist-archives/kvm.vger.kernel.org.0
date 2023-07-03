Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F74D745787
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 10:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjGCInl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 04:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjGCInk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 04:43:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725BDE41
        for <kvm@vger.kernel.org>; Mon,  3 Jul 2023 01:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688373771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w9j01qwPpErBDT2GubuAl+sX/3Bkrf1KFu3e6uDsu3A=;
        b=KxIF7VW6TvchpAlGnjb+ipIfinWo2H/x3YnajHqCLaT3Is/y1z/QT1d7si/HLXHnOsEOFW
        TsllfmE+GY9gpPfCjQmGo3DNpNhNwGhDcPn5jhrezYkfDegYLmijfRoHFPpTaHap+kuPvZ
        DcRi94WuVibN015yG9bK8FjRutAOErg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-119-tvUBWtgwNSWXrBqZivbETA-1; Mon, 03 Jul 2023 04:42:48 -0400
X-MC-Unique: tvUBWtgwNSWXrBqZivbETA-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-635dd236b63so26628866d6.0
        for <kvm@vger.kernel.org>; Mon, 03 Jul 2023 01:42:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688373768; x=1690965768;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w9j01qwPpErBDT2GubuAl+sX/3Bkrf1KFu3e6uDsu3A=;
        b=Z7DXDChZOEctYNA7b4naJo55oxnenvncO9dt8XL7QPvcw4HcOWUhtUeAkV60zdoA7M
         eOyVW49+SWCDaQ7FC9zdOklqJzFzJbGv5o1wfHqxkOJGn/qHCciotL6J222UGLZcVkk8
         K424RnXwPQp+hH2jwKi2Xol7D8A+aiHawMI6OOHe2IzwEVn3cYdc83hpE52KSSnGRiCx
         9Gx4d3V8l/OuCY4jak8PFEdOSOAdkglOhQM7BEPEyBhANw22VI9q0Q+chaqcaUOJxJLE
         bMJ6lBchSc9IJd/LOVmxmOBEtdf1Z1cZnnHMCTnbxG1CfG+hpNYx/mMaPi+OhEbCETj7
         hk1w==
X-Gm-Message-State: ABy/qLbiipHhFgDKX8gcjT1LoHcQkY//n0wZ9mYl/0JXKDswwj3TgT04
        n3JUqqQ8ETUCiUN/Ys957NMSpucAvSRK3ufNPY8RqqwrYu0rF1wkJG+WKLPCnNDMzKTubJ3tjox
        WLsZciUtCNGaH
X-Received: by 2002:a05:6214:2a4a:b0:635:f562:fa1e with SMTP id jf10-20020a0562142a4a00b00635f562fa1emr12570339qvb.30.1688373767940;
        Mon, 03 Jul 2023 01:42:47 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEg+PvXt3zRvvQF/8LbgMFfXOr/yVak/1Iy7Zlv9ZOHPU6mms7XYBSch3qq3Gqbn+BlsVFLWA==
X-Received: by 2002:a05:6214:2a4a:b0:635:f562:fa1e with SMTP id jf10-20020a0562142a4a00b00635f562fa1emr12570332qvb.30.1688373767735;
        Mon, 03 Jul 2023 01:42:47 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-178-242.web.vodafone.de. [109.43.178.242])
        by smtp.gmail.com with ESMTPSA id q5-20020ad45ca5000000b00623950fbe48sm11249923qvh.41.2023.07.03.01.42.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jul 2023 01:42:47 -0700 (PDT)
Message-ID: <a162644d-f548-7c34-e501-d8080d1d0bef@redhat.com>
Date:   Mon, 3 Jul 2023 10:42:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [kvm-unit-tests PATCH v10 1/2] s390x: topology: Check the Perform
 Topology Function
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, kvm@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nsg@linux.ibm.com
References: <20230627082155.6375-1-pmorel@linux.ibm.com>
 <20230627082155.6375-2-pmorel@linux.ibm.com>
 <168802854091.40048.12063023827984391132@t14-nrb>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <168802854091.40048.12063023827984391132@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/06/2023 10.49, Nico Boehr wrote:
> Quoting Pierre Morel (2023-06-27 10:21:54)
> [...]
>> diff --git a/s390x/topology.c b/s390x/topology.c
>> new file mode 100644
>> index 0000000..7e1bbf9
>> --- /dev/null
>> +++ b/s390x/topology.c
>> @@ -0,0 +1,190 @@
> [...]
>> +static void check_privilege(int fc)
>> +{
>> +       unsigned long rc;
>> +       char buf[20];
>> +
>> +       snprintf(buf, sizeof(buf), "Privileged fc %d", fc);
>> +       report_prefix_push(buf);
> 
> We have report_prefix_pushf (note the f at the end!) for this.
> 
> I can fix that up when picking in case there's no new version, though.

With that fixed:

Reviewed-by: Thomas Huth <thuth@redhat.com>

