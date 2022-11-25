Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8005F638BF7
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 15:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiKYOTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 09:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiKYOTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 09:19:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70143222AD
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 06:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669385889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YE++MfzgW7MB3DaTTHqG0OkXNg+K/BWgK4ZZvaPVOdk=;
        b=ifgIUpIOqUB4VTxFUGzKt1olaHpIt+72IY9uWh1Fe14JQCbSrD/cC5XYtij/Z56dwg/3zJ
        GlHf+yMc0ove0qCARaumBk9RkvLAmCmOXaVf2VEzY/XfOl5mlOXOU9bRCPr+1iq4dKFS8o
        /iUDxS4A+nsy/HEpOPpPIlOGofjMGpM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-275-82lwOJEEOiOafzGOHGuewQ-1; Fri, 25 Nov 2022 09:18:08 -0500
X-MC-Unique: 82lwOJEEOiOafzGOHGuewQ-1
Received: by mail-wm1-f69.google.com with SMTP id ay40-20020a05600c1e2800b003cf8aa16377so2486328wmb.7
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 06:18:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YE++MfzgW7MB3DaTTHqG0OkXNg+K/BWgK4ZZvaPVOdk=;
        b=Jemzk4q/x00R8FoRf/TZmPOptYiWthJ0rveertc/yMh4q/PFud8mku1L51DwYE+OAL
         WbN8u+l6qpapKyVmZJLsee4GtJ5M3qoD6WIxNQDhMgE+04aFTToXYaJHyjfNjp5wDC2Y
         DczY+K11UUaAqC2hqGbUIT+ZbULJkbe1YrPmEQz6hLqc3Ndi66TM5FsG20Tc9xmczx+n
         sKAmjBcAjigKen8foKZGj6SyKH39nFMwpLlHe0tJNFhWGqAhQPmQnZX6Qg1SnawD79fq
         SS3XKvdlxADXePr/HFoAAgkpk/oHFNUvFcHluO8QG9hwBppmA/d34Gw8W1tOCTKGAkZN
         PP1w==
X-Gm-Message-State: ANoB5pnBoWMJuVHEMDrXAkW02SBu48SFGjo3WUwCPI1E6vkJAYQc3Zqc
        mf9KWy1MYjS1719FwD6ckbbbtStxh4cmqSfb34WD9g3Rs0jH2GLuHD3lOEkxqe/sh0OK+nRwX0u
        GAYLntFre+VND
X-Received: by 2002:a7b:cb4d:0:b0:3cf:b2a6:267d with SMTP id v13-20020a7bcb4d000000b003cfb2a6267dmr28123630wmj.67.1669385887132;
        Fri, 25 Nov 2022 06:18:07 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6VnkqAofRDKB9+K4Pt3+IGb9+SVYMO+SOvkNylasE9pyJIgTOfCNCf+mdMJlSC+ALdckd7dA==
X-Received: by 2002:a7b:cb4d:0:b0:3cf:b2a6:267d with SMTP id v13-20020a7bcb4d000000b003cfb2a6267dmr28123612wmj.67.1669385886958;
        Fri, 25 Nov 2022 06:18:06 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-176-41.web.vodafone.de. [109.43.176.41])
        by smtp.gmail.com with ESMTPSA id cc18-20020a5d5c12000000b002238ea5750csm4746881wrb.72.2022.11.25.06.18.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Nov 2022 06:18:06 -0800 (PST)
Message-ID: <0d629df6-c48d-318b-34d5-c36627aa96ea@redhat.com>
Date:   Fri, 25 Nov 2022 15:18:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: add CMM test during
 migration
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com
References: <20221124134429.612467-1-nrb@linux.ibm.com>
 <20221124134429.612467-3-nrb@linux.ibm.com>
 <8829c1f2-46cd-12b7-5939-48a1866ed001@redhat.com>
 <20221125150539.6b59a63b@p-imbrenda>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20221125150539.6b59a63b@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/11/2022 15.05, Claudio Imbrenda wrote:
> On Fri, 25 Nov 2022 14:58:35 +0100
> Thomas Huth <thuth@redhat.com> wrote:
> 
> [...]
> 
>>> +	/*
>>> +	 * If we just exit and don't ask migrate_cmd to migrate us, it
>>> +	 * will just hang forever. Hence, also ask for migration when we
>>> +	 * skip this test alltogether.
>>
>> s/alltogether/all together/
> 
> nope, it's "altogether"

Drat, it must be close to the weekend already ;-)

  Thomas

