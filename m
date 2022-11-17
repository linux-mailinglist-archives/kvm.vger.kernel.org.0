Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D308362DD98
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 15:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239832AbiKQOKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 09:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234880AbiKQOKb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 09:10:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E49657D9
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 06:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668694176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NzIt6ugZo53on12tsmd+ec2teYp08BuufbWKe+Wlkpo=;
        b=STIn2YsfNGyyhWkOrPmehQrLJ0ku/l3jkKIECLQG8n7XOl6YEmVEI8w+N5OSEyDDc7+5Jk
        6WwkbBDeGHwvSrRgVOyjyhgLMnK7tIQ8wzZWLvhuMVkHzB9cwGCDczYwd7vzsuj3U59WfB
        3fxl3cSJMFi5dCJTwl6wQ3YWLS27EQo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-8-V3KFzXC5PW2hZ0eC1lwdng-1; Thu, 17 Nov 2022 09:09:35 -0500
X-MC-Unique: V3KFzXC5PW2hZ0eC1lwdng-1
Received: by mail-ej1-f70.google.com with SMTP id hs34-20020a1709073ea200b007ad86f91d39so1180655ejc.10
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 06:09:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NzIt6ugZo53on12tsmd+ec2teYp08BuufbWKe+Wlkpo=;
        b=T5hFF/lZ2VLqgXTtkEl0VNNL6p3Hk/BQQCWJzDjlV1vV4IyZdN2b5w/W2PzJvuv/Sm
         2giSbHJiQvQ+eH12P4aAEY+h+r3olgQdbpMPF+IOrn6kWv6TEjZrxj8DBqpMAt8G5Eyr
         OhVJId/o3SR1XBrcKJGit9Q3/LBIa/ddrgxmADqj3ywJMDsf17QXBvLE/vhTLpA0rDKf
         bVSxLIoIGPQQwiPC/cDAHKFMI/6infZfPnCdxcgZlwu8XiOjzwGXvfT8l3Pwh4yU5FCg
         kjtyhprXy5g7S3NE7q4bvDOKnjbUWCpuyzMrqT09FAJoxRz63g53QPL1gHtilQ4hcoRi
         E47g==
X-Gm-Message-State: ANoB5plaMoWkJcUDf1XNsy8HntCDU4PbBGf2qn6N9F9YZlA2+V/JZY1P
        U2I7kYIh+W7uHOvq1kL5e8cA50Cis82aJKZ671/s8VJWyTTxP3qHEBYD85ThQPrnPjJl7nGw5Xm
        TvZsixGb2ijQj
X-Received: by 2002:a17:906:a1a:b0:79e:9aea:7b60 with SMTP id w26-20020a1709060a1a00b0079e9aea7b60mr2305578ejf.444.1668694173672;
        Thu, 17 Nov 2022 06:09:33 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6z+0IwQxUUH6TFZQEvdGuAmsL9NjdMjHKAMRpyUPKyvEmTyLpypgM7zXqc+fnrBfKAKPjrgg==
X-Received: by 2002:a17:906:a1a:b0:79e:9aea:7b60 with SMTP id w26-20020a1709060a1a00b0079e9aea7b60mr2305559ejf.444.1668694173455;
        Thu, 17 Nov 2022 06:09:33 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id u22-20020aa7d896000000b00459f4974128sm589257edq.50.2022.11.17.06.09.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 06:09:32 -0800 (PST)
Message-ID: <87d698f2-b4b8-6263-43fb-d96a6108292b@redhat.com>
Date:   Thu, 17 Nov 2022 15:09:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [GIT PULL] KVM: selftests: Early pile of updates for 6.2
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Reiji Watanabe <reijiw@google.com>, kvm@vger.kernel.org,
        Colin Ian King <colin.i.king@gmail.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Gautam Menghani <gautammenghani201@gmail.com>,
        Peter Gonda <pgonda@google.com>,
        Vishal Annapurve <vannapurve@google.com>
References: <Y3WKCRJbbvhnyDg1@google.com> <861qq1ptew.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <861qq1ptew.wl-maz@kernel.org>
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

On 11/17/22 15:06, Marc Zyngier wrote:
>> monitor is cleared by eret.  gdb is allegedly smart enough to skip over
>> atomic sequences, but our selftest... not so much.
> I'm not sure how GDB performs this feat without completely messing
> things up in some cases...

As far as I know what happens is simply that "step" sets a breakpoint to 
the next line of *source* code.  "stepi" instead works on an instruction 
bases and will not make any progress over LL/SC sequences.

Paolo

