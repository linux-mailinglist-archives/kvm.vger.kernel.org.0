Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F0E667CAC
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 18:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbjALRhj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 12:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232587AbjALRgw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 12:36:52 -0500
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD045869FC
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 08:58:02 -0800 (PST)
Received: by mail-ej1-f46.google.com with SMTP id tz12so46269650ejc.9
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 08:58:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BEKnEKGtz2uafTpUVkqBU7l+QHds/17H+VOh+qMvSZY=;
        b=WuM4MkIuuToGRK6n52vWBRvkJWlywxkoUmt8uexZAlDoJBeXDrjP/aC1OyJ2lF8lqQ
         2GnJW83b370PDeaO7LqhU6ZYRy4j98Uby2kKxAn7ow/g0/hjK5kONqt8AqH4yAtoZXUb
         wu1SXfRXKi2c/nA7YTFAab1WfhKcD6KTd7fzxp7QZrP7A36IDSoKzyv7ZNrmJOBtK4a+
         3WlTbaPdOG0E4HJjWx58kGSgd0AP9KrhbIUDQiCOwBbpVNaj3WMeGFlOavWEpnmfjUUr
         pOoT40eKaoJAY4sfFBntQ7iB+G3a3vQX/LtHzn4d/aE/RSQj5hkzjp7Yj2Lz9dEMnYXj
         h+bw==
X-Gm-Message-State: AFqh2kq80QIUTzemCmxcMtnaW7qUeEd+BK3Q+95vlwLP6UEdjE/iMDpG
        KmrMVef+48Bo7QGg9jyAbjY=
X-Google-Smtp-Source: AMrXdXuchfQeDbVJTXokliFejWu01Q0oDUe890/clwlC5eQRFJDx8JiVl7Pr1ejZx59bQGkgbLv4qg==
X-Received: by 2002:a17:907:8196:b0:7c1:6fd3:1efa with SMTP id iy22-20020a170907819600b007c16fd31efamr95729ejc.28.1673542665386;
        Thu, 12 Jan 2023 08:57:45 -0800 (PST)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id 10-20020a170906210a00b007c0f2d051f4sm7589943ejt.203.2023.01.12.08.57.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 08:57:44 -0800 (PST)
Message-ID: <3da07f36-52ce-58ef-845b-67c98f78410d@kernel.org>
Date:   Thu, 12 Jan 2023 17:57:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Stalls in qemu with host running 6.1 (everything stuck at
 mmap_read_lock())
From:   Jiri Slaby <jirislaby@kernel.org>
To:     Pedro Falcato <pedro.falcato@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        mm <linux-mm@kvack.org>, yuzhao@google.com,
        Michal Hocko <MHocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>, shy828301@gmail.com
References: <b8017e09-f336-3035-8344-c549086c2340@kernel.org>
 <CAKbZUD0Tqct_G9OcO8ocdH1J_YvLSEod-ofr97hsyoHgcvBwuw@mail.gmail.com>
 <7aa90802-d25c-baa3-9c03-2502ad3c708a@kernel.org>
 <17b584f1-9d3b-35bb-7035-9b225936fd23@kernel.org>
Content-Language: en-US
In-Reply-To: <17b584f1-9d3b-35bb-7035-9b225936fd23@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12. 01. 23, 16:43, Jiri Slaby wrote:
>> and dump a kcore (kdump is set up).
> 
> Going to trigger a dump now.

Hmm, crash doesn't seems to work for 6.1, apparently. Once it did 
nothing, second time, it dumped an empty dir...

So for now, only the lock dump is available. Next time, I will dump at 
least process states (sysrq-t).

thanks,
-- 
js
suse labs

