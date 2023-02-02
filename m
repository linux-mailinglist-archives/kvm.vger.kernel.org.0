Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA05687A90
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 11:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbjBBKpa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 05:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbjBBKpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 05:45:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CBE9EE6
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 02:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675334657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zk689njywsUoTOAdolT0FFFPb72OxAcJiOLt6/D1p1Y=;
        b=UVwhCWClujGzVTuKSpn4VA2o3WIYhZ20KAxLl0/nVcUp0Ds6PdglTgnxn8LjEK6kFcysG2
        2pAvxY+ECApJSeKaduDDts+E5HKVqoAys4Zlfqf8mR6j5e27kSwhHUscqZ7zP+mfhV+RUB
        EFJ8Y0mfVsDD9hbEEo+M24nRDfNUxb8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-90-hahsCgAyNr6vyWB2Dl9eVg-1; Thu, 02 Feb 2023 05:44:13 -0500
X-MC-Unique: hahsCgAyNr6vyWB2Dl9eVg-1
Received: by mail-qk1-f198.google.com with SMTP id a198-20020ae9e8cf000000b007259083a3c8so1078078qkg.7
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 02:44:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zk689njywsUoTOAdolT0FFFPb72OxAcJiOLt6/D1p1Y=;
        b=Ce0wqZX7pwZuuzBcRJtBaPHWK7xai66gQRJc8YksvTQtPXrkryYRnap3IxdzzYclx6
         71ZYR12tUvr+eUP6VOfi81ixTvje/1T6Xq61l4+N5aHxAHjRXAeCjQBJA6IsJzaOugGo
         uz3KpIJf2gVU/7Kn7TTDE2aLbd3EFC2C88vNFWNfv9ElW9uaMhDMM0ol1V9Q/mO/9iyg
         bi+tQgYWQG/QLOHSclTQXY1GNLZiDzgurFxHR3E+5a+aC5HdHG5HliZVVjQfq1N7QSCd
         H4lo/X+5OGiac1RHTy+C3tXL3vCoaHuLF7UumUWcZUxuYIiqyU/KaP/Pd4kCDMZ7Z5E7
         zh8g==
X-Gm-Message-State: AO0yUKXSg9rAhIcVy5Mnmf3gHJ2WSrK7EasEmN/ncM7Gp3BgPPx4epRV
        7Lcci7RyqN9VpWJVFu04uzc8bBo40iS4UqWZqnXRANQ+JE7w4G+OQIu2UipuqprMeRIQ8ZJxlwd
        ceLgXBOoPApYw
X-Received: by 2002:ac8:5dce:0:b0:3b8:6043:daf8 with SMTP id e14-20020ac85dce000000b003b86043daf8mr10801135qtx.47.1675334653103;
        Thu, 02 Feb 2023 02:44:13 -0800 (PST)
X-Google-Smtp-Source: AK7set8xkxlLPup3tabY+V7Eq+5TTe5ay44NvoGI6jckJeZL6u8e/vKinxcibffe2Q4BFy26U/9Rrg==
X-Received: by 2002:ac8:5dce:0:b0:3b8:6043:daf8 with SMTP id e14-20020ac85dce000000b003b86043daf8mr10801121qtx.47.1675334652853;
        Thu, 02 Feb 2023 02:44:12 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-146.web.vodafone.de. [109.43.177.146])
        by smtp.gmail.com with ESMTPSA id 137-20020a37088f000000b0071aacb2c76asm10849689qki.132.2023.02.02.02.44.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 02:44:12 -0800 (PST)
Message-ID: <8f5980bd-bbc3-ba78-cf1e-60afb26fb887@redhat.com>
Date:   Thu, 2 Feb 2023 11:44:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-2-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v15 01/11] s390x/cpu topology: adding s390 specificities
 to CPU topology
In-Reply-To: <20230201132051.126868-2-pmorel@linux.ibm.com>
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

On 01/02/2023 14.20, Pierre Morel wrote:
> S390 adds two new SMP levels, drawers and books to the CPU
> topology.
> The S390 CPU have specific toplogy features like dedication

Nit: s/toplogy/topology/

> and polarity to give to the guest indications on the host
> vCPUs scheduling and help the guest take the best decisions
> on the scheduling of threads on the vCPUs.
> 
> Let us provide the SMP properties with books and drawers levels
> and S390 CPU with dedication and polarity,
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---

Apart from the nit:
Reviewed-by: Thomas Huth <thuth@redhat.com>

