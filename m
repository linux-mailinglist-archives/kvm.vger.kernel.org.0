Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A8A74D923
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 16:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbjGJOjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 10:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbjGJOjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 10:39:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D23D7
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 07:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688999908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9bBk+gcdaziKAiVUIICdUphtJ9k+wR7npopsvAwOuyk=;
        b=UXsnH/RiF8KtBt2pN1VTSw8iE2fOPSwsIY+5Np4x1APIbnB4eLgvojFVshxSCnZ/UePi21
        2YCrIr9Sx8hZq/upVUo3qYBBo1mky/4v+KwmddYBve/YbYU6eh3x9zwwwEKNu9+lNEomA5
        jiB+V6kJeOfEmcWOL/7F94pGzIjwHL4=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-495-kXzVm-OcOuulHatsyn7x7g-1; Mon, 10 Jul 2023 10:38:27 -0400
X-MC-Unique: kXzVm-OcOuulHatsyn7x7g-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-63719bd2155so53248646d6.1
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 07:38:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688999906; x=1691591906;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9bBk+gcdaziKAiVUIICdUphtJ9k+wR7npopsvAwOuyk=;
        b=KrvQ2LPz8GiOE1BMKayjb9/zKAz1kCvce4GhcRkRNcX+UZX9W2O3TjLhwswLm78fv8
         45bxJzaGrVVOsT3IIutb9bX4Kdb+ykgQBU63gikqLth2vvOeDcHDxTajyopX+hIGiopX
         xf4SnRZeJJg0g3TZSEoTUy6WG2yby1utJzRS/aDoLjWbvCqsCqH6OLxgO3FtKT/MsyzM
         1melv9zd7fC4G44EKQAsOp1+MtJpa7VU9G4Mn7PTmosLwGALYRpMsdWgmWSh+SnzBGr+
         PaYaaJNcLl/kAV5vpq2RhdPJnXysiBlggKobwwZo2aSzTQGTTVMTGJE31e1WUeMRCJc8
         2mSQ==
X-Gm-Message-State: ABy/qLYfpPfLjEW1VTqKkcAOfUY77NNMNwtX60eNhQUauzYEPTVSfGMT
        kh6uLEM/a9T9edm+XolIboEu3xcObmgyJel9Xb4aZOP8MUzgglzywObU7BwKGzQQ2Oy92eXOIws
        dpbFaQ+iruxtn
X-Received: by 2002:a0c:f187:0:b0:636:60c6:2034 with SMTP id m7-20020a0cf187000000b0063660c62034mr12393802qvl.38.1688999906381;
        Mon, 10 Jul 2023 07:38:26 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGp08zk0EBF3bjMsUvEIIQOE7Zv3c9eNAbISu+Ycb8aFzKovzbasgw7kDa8dsG/n7IxSzbtAA==
X-Received: by 2002:a0c:f187:0:b0:636:60c6:2034 with SMTP id m7-20020a0cf187000000b0063660c62034mr12393791qvl.38.1688999906202;
        Mon, 10 Jul 2023 07:38:26 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-179-116.web.vodafone.de. [109.43.179.116])
        by smtp.gmail.com with ESMTPSA id b12-20020a0ccd0c000000b006362aac00a2sm5603683qvm.29.2023.07.10.07.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jul 2023 07:38:25 -0700 (PDT)
Message-ID: <d52e4c34-55f0-56a5-1543-52fefb39e2a6@redhat.com>
Date:   Mon, 10 Jul 2023 16:38:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, kvm@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nsg@linux.ibm.com
References: <20230627082155.6375-1-pmorel@linux.ibm.com>
 <20230627082155.6375-3-pmorel@linux.ibm.com>
 <ffc48a06-52b2-fc65-e12d-58603d13b3e6@redhat.com>
 <168897816265.42553.541677592228445286@t14-nrb>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v10 2/2] s390x: topology: Checking
 Configuration Topology Information
In-Reply-To: <168897816265.42553.541677592228445286@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/07/2023 10.36, Nico Boehr wrote:
> Quoting Thomas Huth (2023-07-06 12:48:50)
> [...]
>> Does this patch series depend on some other patches that are not upstream
>> yet? I just tried to run the test, but I'm only getting:
>>
>>    lib/s390x/sclp.c:122: assert failed: read_info
>>
>> Any ideas what could be wrong?
> 
> Yep, as you guessed this depends on:
> Fixing infinite loop on SCLP READ SCP INFO error
> https://lore.kernel.org/all/20230601164537.31769-1-pmorel@linux.ibm.com/

Ok, that fixes the assertion, but now I get a test failure:

ABORT: READ_SCP_INFO failed

What else could I be missing?

  Thomas

