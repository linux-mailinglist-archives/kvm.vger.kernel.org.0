Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933C9617EF2
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 15:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbiKCOJV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 10:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbiKCOJS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 10:09:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366ADFAFE
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 07:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667484505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tMZz/r0Y/xMO+n/fhUi//lk8Yf2Cm8C30yAiPyY4Bw4=;
        b=BvLHurLMwVDgrC5uhK44L/byVG+P6ZGto4yEoY+EUaGq99Wtcv85Zsei/h/1XNI/kMnA0G
        XUZZkE7fBZ6fc0zr/jB43JlmqvJxl1TT9Qc891GgF2z7pXM4reGLJz29OYlixI950akVBl
        +wyDHma+7+3qDJfAtHN5ymQXbUFrB88=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-210-G9s8QAWzOmegFljOMhZgQQ-1; Thu, 03 Nov 2022 10:08:23 -0400
X-MC-Unique: G9s8QAWzOmegFljOMhZgQQ-1
Received: by mail-ej1-f69.google.com with SMTP id hd11-20020a170907968b00b0078df60485fdso1321033ejc.17
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 07:08:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tMZz/r0Y/xMO+n/fhUi//lk8Yf2Cm8C30yAiPyY4Bw4=;
        b=qrWWvrw/ctACflrajM4c80dLHY4V2sRlyTlitVNjvwg8bc8W2ArgWfbMkxzDKyRoWs
         vqMw+hZ8BHnMegrzS3Yv8UAGJQC4ILfZKMcU0PdxAo2maZY2HasYMtjlb+/Yb1K5mzmL
         M1SBwPrm/4e58eEuj1oAF9GW5krKQ0iinVjdxC09mlPA35rGgjtVctQmwtJwCci03qXR
         NUZQLq0H8vfPRVWhOc06+rRArJkRPt59n/LaxFxLYI6TW8B/ueJBSG5xN6DYT5nOYU9d
         rsWXQqml1lw2fC6fk6sTVlfhLx1oWMF/sfh+yUixTvR4qlAxaB0+O+skRi2pdQq1MAtj
         IaXw==
X-Gm-Message-State: ACrzQf1hAMCtXCpxo9htGsoyiv3CEaLmK15qQD/FDriXKNHD6h7Ksm7W
        iUeWnEvqA7CDE+ZCbr6PcV/dxpv9ygWZ+MQ5LSsBo1pM7tp/roxt1Js864+1MZKEPmRFEuF3q97
        JqMLUXB14itvC
X-Received: by 2002:a05:6402:528a:b0:454:8613:6560 with SMTP id en10-20020a056402528a00b0045486136560mr31172978edb.252.1667484502424;
        Thu, 03 Nov 2022 07:08:22 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4Dre/hkgRdSdcGbydsy/bQuSRL4FR7uIznudXowctaxKseqrZdRoK/gAiQci2+2pTFqeljBQ==
X-Received: by 2002:a05:6402:528a:b0:454:8613:6560 with SMTP id en10-20020a056402528a00b0045486136560mr31172953edb.252.1667484502137;
        Thu, 03 Nov 2022 07:08:22 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id hw20-20020a170907a0d400b007ade5cc6e7asm558763ejc.39.2022.11.03.07.08.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 07:08:21 -0700 (PDT)
Message-ID: <48530886-ed28-d50a-205b-81f6bf359ca7@redhat.com>
Date:   Thu, 3 Nov 2022 15:08:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] tools/kvm_stat: fix attack vector with user controlled
 FUSE mounts
Content-Language: en-US
To:     Matthias Gerstner <matthias.gerstner@suse.de>, kvm@vger.kernel.org
References: <20221103135927.13656-1-matthias.gerstner@suse.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221103135927.13656-1-matthias.gerstner@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/3/22 14:59, Matthias Gerstner wrote:
> The first field in /proc/mounts can be influenced by unprivileged users
> through the widespread `fusermount` setuid-root program. Example:
> 
> ```
> user$ mkdir ~/mydebugfs
> user$ export _FUSE_COMMFD=0
> user$ fusermount ~/mydebugfs -ononempty,fsname=debugfs
> user$ grep debugfs /proc/mounts
> debugfs /home/user/mydebugfs fuse rw,nosuid,nodev,relatime,user_id=1000,group_id=100 0 0
> ```
> 
> If there is no debugfs already mounted in the system then this can be
> used by unprivileged users to trick kvm_stat into using a user
> controlled file system location for obtaining KVM statistics.
> 
> To exploit this also a race condition has to be won, since the code
> checks for the existence of the 'kvm' subdirectory of the resulting
> path. This doesn't work on a FUSE mount, because the root user is not
> allowed to access non-root FUSE mounts for security reasons. If an
> attacker manages to unmount the FUSE mount in time again then kvm_stat
> would be using the resulting path, though.
> 
> The impact if winning the race condition is mostly a denial-of-service
> or damaged information integrity. The files in debugfs are only opened
> for reading. So the attacker can cause very large data to be read in by
> kvm_stat or fake data to be processed by kvm_stat. I don't see any
> viable way to turn this into a privilege escalation.

Ok, thanks for confirming.  I will tweak the commit message.

Paolo

> The fix is simply to use the file system type field instead. Whitespace
> in the mount path is escaped in /proc/mounts thus no further safety
> measures in the parsing should be necessary to make this correct.
> ---
>   tools/kvm/kvm_stat/kvm_stat | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
> index 9c366b3a676d..88a73999aa58 100755
> --- a/tools/kvm/kvm_stat/kvm_stat
> +++ b/tools/kvm/kvm_stat/kvm_stat
> @@ -1756,7 +1756,7 @@ def assign_globals():
>   
>       debugfs = ''
>       for line in open('/proc/mounts'):
> -        if line.split(' ')[0] == 'debugfs':
> +        if line.split(' ')[2] == 'debugfs':
>               debugfs = line.split(' ')[1]
>               break
>       if debugfs == '':

