Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349FE66D6DD
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 08:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235699AbjAQH0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 02:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235525AbjAQH0F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 02:26:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666FC22A38
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 23:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673940323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O4zBoqJqPzwMibjvR7F5l/g+QNwG5fVvLTJIc31O8EI=;
        b=VNz6yDjLMEwIhpEK+Y927xTAbusrAviFxcZPnPWCgMdtWHvwS8XauphKoSnSGPSHdfp3KQ
        WEwDmdXgcmTKntJ7f363DHn4yfi9lNfomdgEcS0TRnHnUV0ftCm9HCXngwdu40LWTiMgIG
        6/dzHxqii0WD+JxxHLvn538u68GKsUQ=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-137-65glM6RNNXWwTxnWCHyErg-1; Tue, 17 Jan 2023 02:25:22 -0500
X-MC-Unique: 65glM6RNNXWwTxnWCHyErg-1
Received: by mail-qv1-f70.google.com with SMTP id jh2-20020a0562141fc200b004c74bbb0affso15762722qvb.21
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 23:25:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O4zBoqJqPzwMibjvR7F5l/g+QNwG5fVvLTJIc31O8EI=;
        b=I3x7qFMII8c3d5hQUp4u9ncURpowNtutgm/6IRVsna7ylGI0WRWqaUpJODmr/D+qp1
         N7uFRufZjfQcYRhUEeNJYZmfV1lIQ9xtUunrMOEoKcPFHhe4UrxnBZdBM1qBIBGbjfA5
         T0EkQPDd27CvT79udbIwG4ILam3BRaSeB4GN+UdCEBPKAsQ6rW6BS4G6f6a4lw2zfzB6
         Xd5S7U+wWRYPqcQFpQfqWSkDOjCNtWlPYZ7JoeRRF9hjnsn5E5n/da4UP3TxjR6Ey8X3
         /2KPHq9GF97WZfz/0VQENqjmtP533E1jZK5ZTUhu3CtpsdQsTuWdovIRF1WnWVuSIPwk
         yScQ==
X-Gm-Message-State: AFqh2kqO68TtbVHrxw1SCqSrBwr3P3wuMHj/BjlbW3a5uWtANQdxGGGB
        YPkHmhJH137S7R6ttqzATKmHMA9xRZ7QOhthDzAoxV+gLJWmk32YA1fv36vCbGrv5egE1fANAUn
        tsgZVj3VcnOGJ
X-Received: by 2002:ac8:5157:0:b0:3ab:28ea:d849 with SMTP id h23-20020ac85157000000b003ab28ead849mr2569594qtn.10.1673940321768;
        Mon, 16 Jan 2023 23:25:21 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtaUo0fA+8zIftJnzJVB3TphzXIUKPSfzpt6Qm4mryPHeKyHHoyFrRHliHqQs+ezrX7a2pUPg==
X-Received: by 2002:ac8:5157:0:b0:3ab:28ea:d849 with SMTP id h23-20020ac85157000000b003ab28ead849mr2569579qtn.10.1673940321537;
        Mon, 16 Jan 2023 23:25:21 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-26.web.vodafone.de. [109.43.177.26])
        by smtp.gmail.com with ESMTPSA id h18-20020a05620a401200b007064fa2c616sm5241268qko.66.2023.01.16.23.25.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 23:25:21 -0800 (PST)
Message-ID: <d997124c-5ef5-6a1a-51a8-3000bb8526e3@redhat.com>
Date:   Tue, 17 Jan 2023 08:25:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v14 01/11] s390x/cpu topology: adding s390 specificities
 to CPU topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org,
        borntraeger@de.ibm.com
Cc:     qemu-devel@nongnu.org, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-2-pmorel@linux.ibm.com>
 <49d343fb-f41d-455a-8630-3db2650cfcd5@redhat.com>
 <619b3ebd-094a-cd8b-697c-de08ba788978@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <619b3ebd-094a-cd8b-697c-de08ba788978@linux.ibm.com>
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

On 16/01/2023 17.32, Pierre Morel wrote:
> 
> On 1/10/23 12:37, Thomas Huth wrote:
...
>> Other question: Do we have "node-id"s on s390x? If not, is that similar to 
>> books or drawers, i.e. just another word? If so, we should maybe rather 
>> re-use "nodes" instead of introducing a new name for the same thing?
> 
> We have theoretically nodes-id on s390x, it is the level 5 of the topology, 
> above drawers.
> Currently it is not used in s390x topology, the maximum level returned to a 
> LPAR host is 4.
> I suppose that it adds a possibility to link several s390x with a fast network.

Ok, thanks. So if nodes are indeed a concept on top of the other layers, and 
we do not really support these on s390x yet, should we maybe forbid them on 
s390x like we recently did with the "threads" in the recent machine types? 
... to avoid that users try to use them with the wrong expectations?

  Thomas


