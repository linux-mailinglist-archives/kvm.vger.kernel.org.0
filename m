Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986FE6FECE3
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 09:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237430AbjEKHdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 03:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237425AbjEKHcx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 03:32:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256A383F2
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 00:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683790330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OKw/7GKf5SeigZMQa50kp0kxHmz8EMcgJbcVffRmQ60=;
        b=I1lchl/bpu5DUAgmjaSx+lqh6BQ0uUY+CxipyRi+VXkkJDVddmvG4cccblriFN+Isrc44q
        rXbUviW4UkIiqumUvjBkAXOKSa5RBKzixvSjpYTgyJ7Q7t9HicOzWPOuk7p3U+kBxnv+Cf
        +WvFCFmLVmt3Vanv9XnmziJk6dffSA8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-iNelxsckNve6Xuj8hBwKXA-1; Thu, 11 May 2023 03:32:09 -0400
X-MC-Unique: iNelxsckNve6Xuj8hBwKXA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f33f8ffa05so50618635e9.1
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 00:32:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683790328; x=1686382328;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OKw/7GKf5SeigZMQa50kp0kxHmz8EMcgJbcVffRmQ60=;
        b=F9QkDzDDQxq3Cgm9knz+9ftn9+zPkkwavOscEhM1FXSZnJjvNW2UxWi2C+ChoQDgqy
         krT/eb2xcj5qDwh7SnahZwN3iYOk2Xta9D3UV31S4RXVfzd2TudCfFGEHS6MKnMFYwaX
         OdMfGKFC2eYk6s+rauDjEusFqQSOUal+xouiBf64hkOC11AnEETa174+8JcRTT8EqBsV
         XkkkYuaoZbcFnngVJS2cyZ4zpf+bKeHRXCC/PDqUq+nRJM0n1UrCDhylVDvsp1dqQFY5
         wOat+qzBMYxdRG47lWyRwEmKOiPYBnLQkiXxd1eMFd/yCvuMsVAkjF3RN9/xYx2jfcGI
         Nb7A==
X-Gm-Message-State: AC+VfDwXvaVh8/SJGFbzUkIY7zrDRwG8KwNA4tkF4TD7Q+xXvVt9bnYw
        gT0qiKJFbr+Z6qds2EZRkF/zeK9BaS5V6nrhKRKOVoUNpKOGjTTAMobd0qoEuGSDspJ3VDxjY6V
        j5+9FesD1NOkRj9/hc3NF
X-Received: by 2002:a1c:750a:0:b0:3f4:16bc:bd19 with SMTP id o10-20020a1c750a000000b003f416bcbd19mr12115369wmc.23.1683790327864;
        Thu, 11 May 2023 00:32:07 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4R0C+iELlFsb9wsuh5/Psxnk1XW//mRi8O1ejWAjjEBOVIXrCyQ/xOH07nc/3qC4QJ5riHVA==
X-Received: by 2002:a1c:750a:0:b0:3f4:16bc:bd19 with SMTP id o10-20020a1c750a000000b003f416bcbd19mr12115350wmc.23.1683790327473;
        Thu, 11 May 2023 00:32:07 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id p5-20020a7bcc85000000b003f4dde07956sm3144017wma.42.2023.05.11.00.32.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 May 2023 00:32:06 -0700 (PDT)
Message-ID: <e7849fb1-e333-6210-6c92-b00ecb52ccd4@redhat.com>
Date:   Thu, 11 May 2023 09:32:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] vfio/pci: take mmap write lock for io_remap_pfn_range
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.tian@intel.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com
References: <20230508125842.28193-1-yan.y.zhao@intel.com>
 <ZFkn3q45RUJXMS+P@nvidia.com>
 <20230508145715.630fe3ae.alex.williamson@redhat.com>
 <ZFwBYtjL1V0r5WW3@nvidia.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@redhat.com>
In-Reply-To: <ZFwBYtjL1V0r5WW3@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/10/23 22:41, Jason Gunthorpe wrote:
> On Mon, May 08, 2023 at 02:57:15PM -0600, Alex Williamson wrote:
> 
>> We already try to set the flags in advance, but there are some
>> architectural flags like VM_PAT that make that tricky.  Cedric has been
>> looking at inserting individual pages with vmf_insert_pfn(), but that
>> incurs a lot more faults and therefore latency vs remapping the entire
>> vma on fault.  I'm not convinced that we shouldn't just attempt to
>> remove the fault handler entirely, but I haven't tried it yet to know
>> what gotchas are down that path.  Thanks,

OTOH I didn't see any noticeable slowdowns in the tests I did with
NICs, IGD and NVIDIA GPU pass-through. I lack devices with large
BARs though. If anyone has some time for it, here are commits :

   https://github.com/legoater/linux/commits/vfio

First does a one page insert and fixes the lockdep issues we are
seeing with the recent series:

   https://lore.kernel.org/all/20230126193752.297968-1-surenb@google.com/

Second adds some statistics. For the NVIDIA GPU, faults reach 800k.

Thanks,

C.

> I thought we did it like this because there were races otherwise with
> PTE insertion and zapping? I don't remember well anymore.
> 
> I vaugely remember the address_space conversion might help remove the
> fault handler?
> 
> Jason
> 

