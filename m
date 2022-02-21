Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693254BDF11
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379037AbiBUPXy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 10:23:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379055AbiBUPXq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 10:23:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C799B220FA
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 07:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645457002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L7D+Gz5qc5+200bg5kld6rn86i5+1h5B3y6lWwEfErY=;
        b=dyutw1o6GVU8MlHjFMoykYFu9QflFzd3jxs/6YU7SU7Mnu63ahF0bD0P7CApYByVUpPp3/
        KsOjyGLiyPo4Uf6m9MOBUZ8y4DdocRbQTFjqOIvzbOTwmWhSXoKA7prQ+RcPRg/4BfUryw
        mCENnS6IMKFh2MnmfYnRno7YtkGyJo4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-4aS8IaltMXWFN-7V3rfdrg-1; Mon, 21 Feb 2022 10:23:20 -0500
X-MC-Unique: 4aS8IaltMXWFN-7V3rfdrg-1
Received: by mail-ed1-f72.google.com with SMTP id f9-20020a0564021e8900b00412d0a6ef0dso5327837edf.11
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 07:23:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=L7D+Gz5qc5+200bg5kld6rn86i5+1h5B3y6lWwEfErY=;
        b=b2DFgn+XTh9/W5NcFTqUIaUl+e5ZJ8KvM+aBurhZl9lkQcNdeuK7aU+ju8Cg/LHqcM
         Xc9BPRvPBvs/vtcR6hFvcJwsZ1ubx0Hi6c/nT/+g45CTvjw23qWovIo5SLMsxBBiwLb4
         xCHR29NCPOk8iErTXhK4jXBeX/CzyEfWg+JUkWSz3e6R6HEFWA4M2taSlKVOZRGBVGzS
         NJWPaPbX6PJ7MKgYqTFpX2aujCirdPEp1yL2gGimIoMrdJH+Chu+yXmcHlSIFpYkfys3
         q9JfXBPAelMlDmnR0m8xmpk+wnHvwHbcT+0nuUb8t+4Al+w0eSj29js9Guh2P2kZAHWm
         XJGg==
X-Gm-Message-State: AOAM533WDyuHzieSzvTFmxMKiiqXXVMefV8HkOrJc3Pgu87CclKox2gy
        G9VKU0uUGfiQwzUCmwW9YZJIOSx5e8Cl+cEaxjKfucZtH4dCGXRPcusB9+8dGUrOw54/4DzwMuk
        JOgeRe0Sh5tfN
X-Received: by 2002:a50:f144:0:b0:40f:29ce:c68e with SMTP id z4-20020a50f144000000b0040f29cec68emr21882154edl.307.1645456999561;
        Mon, 21 Feb 2022 07:23:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyoTFuwv0JsZHH8RoTxcAfeLNi2DR2BVP//7ZNa4gKcLutUIrwPppkNV4bX+28chRF/hoFl9w==
X-Received: by 2002:a50:f144:0:b0:40f:29ce:c68e with SMTP id z4-20020a50f144000000b0040f29cec68emr21882131edl.307.1645456999388;
        Mon, 21 Feb 2022 07:23:19 -0800 (PST)
Received: from [10.43.2.56] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id j8sm9256909edw.40.2022.02.21.07.23.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 07:23:18 -0800 (PST)
Message-ID: <03b5523b-ba5a-a729-40d7-61bd469f8e0f@redhat.com>
Date:   Mon, 21 Feb 2022 16:23:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@gmail.com>
Cc:     "libvir-list@redhat.com" <libvir-list@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <f7dc638d-0de1-baa8-d883-fd8435ae13f2@redhat.com>
 <bf97384a-2244-c997-ba75-e3680d576401@redhat.com>
 <ad4e6ea2-df38-005a-5d60-375ec9be8c0e@redhat.com>
 <CAJSP0QVNjdr+9GNr+EG75tv4SaenV0TSk3RiuLG01iqHxhY7gQ@mail.gmail.com>
 <d2af5caf-5201-70aa-92cc-16790a8159d1@redhat.com>
 <1b38c5ea-d908-fe36-05e1-022d402cedbc@redhat.com>
From:   =?UTF-8?B?TWljaGFsIFByw612b3puw61r?= <mprivozn@redhat.com>
In-Reply-To: <1b38c5ea-d908-fe36-05e1-022d402cedbc@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/21/22 12:27, Paolo Bonzini wrote:
> On 2/21/22 10:36, Michal Prívozník wrote:
>> Indeed. Libvirt's participating on its own since 2016, IIRC. Since we're
>> still in org acceptance phase we have some time to decide this,
>> actually. We can do the final decision after participating orgs are
>> announced. My gut feeling says that it's going to be more work on QEMU
>> side which would warrant it to be on the QEMU ideas page.
> 
> There are multiple projects that can be done on this topic, some
> QEMU-only, some Libvirt-only.  For now I would announce the project on
> the Libvirt side (and focus on those projects) since you are comentoring.
> 

Alright then. I've listed the project idea here:

https://gitlab.com/libvirt/libvirt/-/issues/276

Please let me know what do you think.

Michal

