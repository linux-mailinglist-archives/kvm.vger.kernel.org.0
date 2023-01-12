Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D293666B16
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 07:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238603AbjALGHc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 01:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236007AbjALGHb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 01:07:31 -0500
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F353AB06
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 22:07:30 -0800 (PST)
Received: by mail-ed1-f41.google.com with SMTP id i15so25446825edf.2
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 22:07:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xxs907cg45HJfbSdyVtEwlDTCuCMeZ4+KqX2Ba3eYak=;
        b=WU1o/HYLWDQjfZ41hVNsMR7k274UHpBgSpktFyjkcS2mj+RBihrbvd2CrppfdkAOl+
         z9Uat1ShoxPqewIYU+oGsQNrnDLomI9G/KqF1kZeD2rF/VzH4C4O6wQuajgBVY4MRX2/
         7kP+VRiDRkvfiM2QOUX38J8qYFDCwZJduBrIsW0PDyENCOaXVLGsLbFeTMTcnDfff0bP
         qBy3WfO9/GKZK+bGZQrj/j9eIP6J02uZgiR2BqDgN7TxzENojlUxVY76AW4I6o/FNXVj
         Ov8NTWYVyV4ZZpjFYFnsvJc8+RqDNysfhmvl87k+OZ6kxfr1Ri49wAigwlCBY82Gtyjm
         roiA==
X-Gm-Message-State: AFqh2kql5IoKT40R/j92djz/R+Fbms9c7F6HMYS2CiPh5sBdXMdpIjNj
        XCzKt+SXZyYsyjgt7Sjr/Zg=
X-Google-Smtp-Source: AMrXdXsKXJv3OYoZfWb8ZotNtyjw7yMtRZm1Z7IeSGCwm5kkx19eyinzkjp+kn6SJHwEb8PP6vtIzg==
X-Received: by 2002:a05:6402:1149:b0:482:d62c:cde with SMTP id g9-20020a056402114900b00482d62c0cdemr59638228edw.13.1673503648114;
        Wed, 11 Jan 2023 22:07:28 -0800 (PST)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id g11-20020a056402428b00b004722d7e8c7csm6768666edc.14.2023.01.11.22.07.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 22:07:27 -0800 (PST)
Message-ID: <7aa90802-d25c-baa3-9c03-2502ad3c708a@kernel.org>
Date:   Thu, 12 Jan 2023 07:07:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US
To:     Pedro Falcato <pedro.falcato@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        mm <linux-mm@kvack.org>, yuzhao@google.com,
        Michal Hocko <MHocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>, shy828301@gmail.com
References: <b8017e09-f336-3035-8344-c549086c2340@kernel.org>
 <CAKbZUD0Tqct_G9OcO8ocdH1J_YvLSEod-ofr97hsyoHgcvBwuw@mail.gmail.com>
From:   Jiri Slaby <jirislaby@kernel.org>
Subject: Re: Stalls in qemu with host running 6.1 (everything stuck at
 mmap_read_lock())
In-Reply-To: <CAKbZUD0Tqct_G9OcO8ocdH1J_YvLSEod-ofr97hsyoHgcvBwuw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 12. 01. 23, 1:37, Pedro Falcato wrote:
> I just want to chime in and say that I've also hit this regression
> right as I (Arch) updated to 6.1 a few weeks ago.
> This completely ruined my qemu workflow such that I had to fallback to
> using an LTS kernel.
> 
> Some data I've gathered:
> 1) It seems to not happen right after booting - I'm unsure if this is
> due to memory pressure or less CPU load or any other factor

+1 as I wrote.

> 2) It seems to intensify after swapping a fair amount? At least this
> has been my experience.

I have no swap.

> 3) The largest slowdown seems to be when qemu is booting the guest,
> possibly during heavy memory allocation - problems range from "takes
> tens of seconds to boot" to "qemu is completely blocked and needs a
> SIGKILL spam".

+1

> 4) While traditional process monitoring tools break (likely due to
> mmap_lock getting hogged), I can (empirically, using /bin/free) tell
> that the system seems to be swapping in/out quite a fair bit

Yes, htop/top/ps and such are stuck at the read of /proc/<pid>/cmdline 
as I wrote (waiting for the mmap lock).

> My 4) is particularly confusing to me as I had originally blamed the
> problem on the MGLRU changes, while you don't seem to be swapping at
> all.
> Could this be related to the maple tree patches? Should we CC both the
> MGLRU folks and the maple folks?
> 
> I have little insight into what the kernel's state actually is apart
> from this - perf seems to break, and I have no kernel debugger as this
> is my live personal machine :/
> I would love it if someone hinted to possible things I/we could try in
> order to track this down. Is this not git-bisectable at all?

I have rebooted to a fresh kernel which 1) have lockdep enabled, and 2) 
I have debuginfo for. So next time this happens, I can print held locks 
and dump a kcore (kdump is set up).

regards,
-- 
js
suse labs

