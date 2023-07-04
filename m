Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E4274714E
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 14:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbjGDM2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 08:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbjGDM15 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 08:27:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D475B10F9
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 05:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688473630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f1DVV9YwOzEbvqEsOsygUElF9BNPHfcGIhILStRd8EE=;
        b=gKYJffEW/30zgR0IdzIC65z1qO5Nlw/bHudklzBFCzIC9mhmqgliK8gLaU6XntuF9ADOu7
        VVGFSATsRafBDp6qaXGraV8KwmNxrYSgwiDDYUc0MJLoVm6Y13cfEDrGxkrEjP9lml7bgW
        x4eSG6DB8Kwi0VVdQ+apwq6VYgnNAS0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-MvHdh9bEONSzBvpO5NauQg-1; Tue, 04 Jul 2023 08:27:09 -0400
X-MC-Unique: MvHdh9bEONSzBvpO5NauQg-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-765ab532883so670193385a.0
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 05:27:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688473629; x=1691065629;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f1DVV9YwOzEbvqEsOsygUElF9BNPHfcGIhILStRd8EE=;
        b=Vak98GLQImQ0D7heGkGpnoVgjEKj8xewazW/lfXMXvVkTgXe4alT9ZbNz3oiLnRxxR
         4k9/hoFiOMcxmyuajEsH7vgsw+AnRg2DCaDfJ2shGKu8QpX912b7S5ICyS7Q6fq/rOhO
         al+v5lcb/0AjM5JFq+vKmhLrmr/+MEmqzvNijMcyfh/K/ljknIKaTV+vfDv5m4PxlQGM
         m2vyOT3JCoCJnckCj/xdO4uQimZPvXUMwioFBLvVjM/biqcUVjPDUpRpJUSOlCFtYxWR
         tnDPeMAWDfvq06H0qpQSBA33OYCcjhns1jANytl7KenlDAOEWGXEIOx3HCwh+p9flWV6
         9qCg==
X-Gm-Message-State: AC+VfDy/401EzMT33y8BJR6gqeOyrahvXOCrJ/nIXSdVvqxUX+u0Jjke
        ARjk9+gDNAkZx4DlDfpc3eVlI6oIEzqLVpqBLrdsOv+YkhmL5BEqsHQzpqJmJa8XfSi7Pi/AMB7
        skIRJnNYohfwK
X-Received: by 2002:a05:620a:4589:b0:765:67fe:5325 with SMTP id bp9-20020a05620a458900b0076567fe5325mr11399700qkb.44.1688473629333;
        Tue, 04 Jul 2023 05:27:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7zjflw9gGwLPQ+6p7/iOq2otzVQcU0pI8fD11P7JCfoU8kTxxOyduW3xPfK9rVb7NpMdhNEQ==
X-Received: by 2002:a05:620a:4589:b0:765:67fe:5325 with SMTP id bp9-20020a05620a458900b0076567fe5325mr11399686qkb.44.1688473629093;
        Tue, 04 Jul 2023 05:27:09 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-179-126.web.vodafone.de. [109.43.179.126])
        by smtp.gmail.com with ESMTPSA id dy1-20020a05620a60c100b007676ee76195sm1924994qkb.20.2023.07.04.05.27.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 05:27:07 -0700 (PDT)
Message-ID: <dd5c5445-e563-8461-a81b-1c637e69362d@redhat.com>
Date:   Tue, 4 Jul 2023 14:27:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v21 03/20] target/s390x/cpu topology: handle STSI(15) and
 build the SYSIB
Content-Language: en-US
From:   Thomas Huth <thuth@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org,
        frankja@linux.ibm.com, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-4-pmorel@linux.ibm.com>
 <aef8accb-3576-2b10-a946-191a6be3e3e0@redhat.com>
In-Reply-To: <aef8accb-3576-2b10-a946-191a6be3e3e0@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/07/2023 13.40, Thomas Huth wrote:
...
> Also, what about protected virtualization? Do you have to use 
> s390_cpu_pv_mem_write() in case PV is enabled?

Never mind, I keep forgetting that CPU topology can't be used together with 
PV (I just noticed after reading patch 07/20).
Not sure ... but maybe a comment here in the code would help?

  Thomas

