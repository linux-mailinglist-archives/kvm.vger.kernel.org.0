Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B808566D6D1
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 08:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235588AbjAQHXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 02:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234165AbjAQHXb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 02:23:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C715322A38
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 23:22:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673940165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pzn7dTDGTrlOkRWCaQu/SbyexaizuE+jqg3HyX8FiWc=;
        b=MkJ6N/GrsKeP2aexao1maMerd91XGf79WLoUHwi0jckGfZmTPVRNJzcK//wxMC3Y/RfBYg
        FDY9+f8KFMCcLdmSqYctZqDjEV/blasI9DJpfuHUvXyCJKWjg7m1+qBjEQWGP7rM7ONf1O
        6zVw+GFdY01ADmmMnk+RnjyXy3s2jb8=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-586-Tvzs4BW-O4SFmmTrVw-LXg-1; Tue, 17 Jan 2023 02:22:43 -0500
X-MC-Unique: Tvzs4BW-O4SFmmTrVw-LXg-1
Received: by mail-qv1-f72.google.com with SMTP id k15-20020a0cd68f000000b00535261af1b1so960246qvi.13
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 23:22:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pzn7dTDGTrlOkRWCaQu/SbyexaizuE+jqg3HyX8FiWc=;
        b=Ycsi8QJFLM3GWds37z59NmoeVYywS08h4x5da2y5vXjwk0a2MYONMfpDo3LngNE6x5
         MGVVJ2VECXWUJK0aiWqae8YGlmrVLNBdeWRUS9PAmovhapUo2OiX/FkzqfGAlN1Rfhjy
         xs+tTiPgCKQp16rqSThLqLqluiQx25kShe6KPhE6+FUnUPEPGVqq2HiJjHpQKk065Xxu
         YDcYD4PUiICzwXaPTmZWFBpmwyoEBfHpOSsFkC2/CQW+0TgKPe9fOrm9ZK0OGx2LNZXp
         /Di8FwzYwaj56a5uvsPD4w23vtAJt9IuvCf6N7tqbvA/O1tAWrKjZNXEWn+s6ZXCSRYn
         gJ2w==
X-Gm-Message-State: AFqh2koTxfVGG/YZVgLyIOp5wsQOTQ8MESvcuaXMxkUyaTMRGSA8QBDq
        I6g8Hl/x8ja78EXywqss5lcBY2/vRPSUjaNWfNTz7ZQLY3GtqrxK6ctr6f8XlCG8SlPDaRC5K7M
        AjKYXoT22hDqp
X-Received: by 2002:a05:6214:3019:b0:532:33e4:2d70 with SMTP id ke25-20020a056214301900b0053233e42d70mr4922914qvb.12.1673940163475;
        Mon, 16 Jan 2023 23:22:43 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtnf8FrLDzX0dpt0O9w5aA9IBszjZhcPKD6+z07UWfqY2tgs2Lbj6uGeEQY508aZ5l1FOMZAA==
X-Received: by 2002:a05:6214:3019:b0:532:33e4:2d70 with SMTP id ke25-20020a056214301900b0053233e42d70mr4922890qvb.12.1673940163244;
        Mon, 16 Jan 2023 23:22:43 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-26.web.vodafone.de. [109.43.177.26])
        by smtp.gmail.com with ESMTPSA id v1-20020a05620a0f0100b006faf76e7c9asm19976616qkl.115.2023.01.16.23.22.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 23:22:42 -0800 (PST)
Message-ID: <870effa2-4e98-2b1a-fd24-35247b04394b@redhat.com>
Date:   Tue, 17 Jan 2023 08:22:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v14 01/11] s390x/cpu topology: adding s390 specificities
 to CPU topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-2-pmorel@linux.ibm.com>
 <87039aeec020afbd28be77ad5f8d022126aba7bf.camel@linux.ibm.com>
 <31bc88bc-d0c2-f172-939a-c7a42adb466d@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <31bc88bc-d0c2-f172-939a-c7a42adb466d@linux.ibm.com>
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

On 16/01/2023 18.28, Pierre Morel wrote:
> 
> 
> On 1/13/23 17:58, Nina Schoetterl-Glausch wrote:
>> On Thu, 2023-01-05 at 15:53 +0100, Pierre Morel wrote:
>>> S390 adds two new SMP levels, drawers and books to the CPU
>>> topology.
>>> The S390 CPU have specific toplogy features like dedication
>>> and polarity to give to the guest indications on the host
>>> vCPUs scheduling and help the guest take the best decisions
>>> on the scheduling of threads on the vCPUs.
>>>
>>> Let us provide the SMP properties with books and drawers levels
>>> and S390 CPU with dedication and polarity,
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
...
> PTF([01]) are no performance bottle neck and the number of CPU is likely to 
> be small, even a maximum of 248 is possible KVM warns above 16 CPU so the 
> loop for setting all CPU inside PTF interception is not very problematic I 
> think.

KVM warns if you try to use more than the number of physical CPUs that you 
have, not at hard-coded 16 CPUs. So if you've got an LPAR with 248 CPUs, 
it's perfectly fine to use also 248 CPUs for your guest.

  Thomas

