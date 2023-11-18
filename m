Return-Path: <kvm+bounces-1985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BADDB7EFE49
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 08:34:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73DC42811DE
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 07:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E2E61078C;
	Sat, 18 Nov 2023 07:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="jJJB/G7W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE33C1
	for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 23:33:51 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-6c34e87b571so2482921b3a.3
        for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 23:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1700292831; x=1700897631; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jvS+TEU7BLZ2Ws+wGWBvl7GPGDJLm60NOOheWwUlA+M=;
        b=jJJB/G7WdT+AD22gsKqZTpe5tUgS6LBCADl+epd3dgrPilNAT4xihEAWfqpFnFhXfx
         vXaEMNFqTp7W1bCrsTP5XQwAuV1ULrvBay87HMo3tZHRZq/y0m5ICtHh0r5NEfza8am8
         ejuQhLV38aXfzpdK4xLW6lChimjQ6OlpcM8oI/mmZsx/ilSTZa4b05UzlYSQ/phKrcXd
         bBYxZ+WJA7XHmiLlc7Xq/LthHccTUCw+5KqD7v7hDpFntUGMw8OoRGZSfR1CSIeNidNS
         6pZQZEQ+FZbvBPjoI1AVZav5A9Dk4JsRw+WYc5Ogxvep46y7kj20BUz0jLNoolYtNk+0
         HgOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700292831; x=1700897631;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jvS+TEU7BLZ2Ws+wGWBvl7GPGDJLm60NOOheWwUlA+M=;
        b=pxgiedIklITe2eZwVEonjeakngZ8xbnxJtIAiJ84Ls6IP5yia64E/MDEGWX8fIsAVQ
         tCHzYE0EYbCatLJrBf4X4Wo4tLuMG4+odsrk0EqSNqoh9uua98ano+Mpg+l5oKeOfL1o
         B6z88Z2ztIYC0a7SMLExs7ee3TgNQERjQ6CrC8XbDHzwnVYc8OrSWJ97c5lyYW9SwPEr
         KYMyBVZhbu6k5cio4tnXrU5dDZJwlUInt7ZznoxT5t74wTK1sjlekNj3HnRB4BJMNGj3
         HZUS10i5aDHBqeXMZyWNYYYPxboSJhDDxuXRyt95DbYl+6JfrChOdMLp9CtBw7oxuZ1J
         qkwg==
X-Gm-Message-State: AOJu0Yzy291tvh9hzCPOIXZzO4oa6BER/J2pvyFpZQ6hvQr90mZxddAw
	5hsoVRhC9wqrHLfrXkUZsCXc7g==
X-Google-Smtp-Source: AGHT+IEumhuQYfV3o4Z721tq/oFbXwiRdHj0B+h8h6mYYmWoONPXZo9l/FJ3wWOkQ2FFk/eykNZFZQ==
X-Received: by 2002:a05:6a20:e609:b0:186:5265:ed1c with SMTP id my9-20020a056a20e60900b001865265ed1cmr1471698pzb.6.1700292830919;
        Fri, 17 Nov 2023 23:33:50 -0800 (PST)
Received: from [10.254.46.51] ([139.177.225.228])
        by smtp.gmail.com with ESMTPSA id je6-20020a170903264600b001b8a3e2c241sm2482044plb.14.2023.11.17.23.33.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Nov 2023 23:33:50 -0800 (PST)
Message-ID: <93c0f8f2-f40e-4dea-8260-6f610e77aa7f@bytedance.com>
Date: Sat, 18 Nov 2023 15:33:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair: Add
 lag based placement)
Content-Language: en-US
To: Tobias Huschle <huschle@linux.ibm.com>,
 Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org
Cc: Peterz <peterz@infradead.org>, mst@redhat.com, jasowang@redhat.com
References: <c7b38bc27cc2c480f0c5383366416455@linux.ibm.com>
From: Abel Wu <wuyun.abel@bytedance.com>
In-Reply-To: <c7b38bc27cc2c480f0c5383366416455@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/17/23 2:58 AM, Tobias Huschle Wrote:
> #################### TRACE EXCERPT ####################
> The sched_place trace event was added to the end of the place_entity function and outputs:
> sev -> sched_entity vruntime
> sed -> sched_entity deadline
> sel -> sched_entity vlag
> avg -> cfs_rq avg_vruntime
> min -> cfs_rq min_vruntime
> cpu -> cpu of cfs_rq
> nr  -> cfs_rq nr_running
> ---
>      CPU 3/KVM-2950    [014] d....   576.161432: sched_migrate_task: comm=vhost-2920 pid=2941 prio=120 orig_cpu=15 dest_cpu=14
> --> migrates task from cpu 15 to 14
>      CPU 3/KVM-2950    [014] d....   576.161433: sched_place: comm=vhost-2920 pid=2941 sev=4242563284 sed=4245563284 sel=0 avg=4242563284 min=4242563284 cpu=14 nr=0
> --> places vhost 2920 on CPU 14 with vruntime 4242563284
>      CPU 3/KVM-2950    [014] d....   576.161433: sched_place: comm= pid=0 sev=16329848593 sed=16334604010 sel=0 avg=16329848593 min=16329848593 cpu=14 nr=0
>      CPU 3/KVM-2950    [014] d....   576.161433: sched_place: comm= pid=0 sev=42560661157 sed=42627443765 sel=0 avg=42560661157 min=42560661157 cpu=14 nr=0
>      CPU 3/KVM-2950    [014] d....   576.161434: sched_place: comm= pid=0 sev=53846627372 sed=54125900099 sel=0 avg=53846627372 min=53846627372 cpu=14 nr=0
>      CPU 3/KVM-2950    [014] d....   576.161434: sched_place: comm= pid=0 sev=86640641980 sed=87255041979 sel=0 avg=86640641980 min=86640641980 cpu=14 nr=0

As the following 2 lines indicates that vhost-2920 is on_rq so can be
picked as next, thus its cfs_rq must have at least one entity.

While the above 4 lines shows nr=0, so the "comm= pid=0" task(s) can't
be in the same cgroup with vhost-2920.

Say vhost is in cgroupA, and "comm= pid=0" task with sev=86640641980
is in cgroupB ...

>      CPU 3/KVM-2950    [014] dN...   576.161434: sched_stat_wait: comm=vhost-2920 pid=2941 delay=9958 [ns]
>      CPU 3/KVM-2950    [014] d....   576.161435: sched_switch: prev_comm=CPU 3/KVM prev_pid=2950 prev_prio=120 prev_state=S ==> next_comm=vhost-2920 next_pid=2941 next_prio=120
>     vhost-2920-2941    [014] D....   576.161439: sched_waking: comm=vhost-2286 pid=2309 prio=120 target_cpu=008
>     vhost-2920-2941    [014] d....   576.161446: sched_waking: comm=kworker/14:0 pid=6525 prio=120 target_cpu=014
>     vhost-2920-2941    [014] d....   576.161447: sched_place: comm=kworker/14:0 pid=6525 sev=86642125805 sed=86645125805 sel=0 avg=86642125805 min=86642125805 cpu=14 nr=1
> --> places kworker 6525 on cpu 14 with vruntime 86642125805
> -->  which is far larger than vhost vruntime of  4242563284

Here nr=1 means there is another entity in the same cfs_rq with the
newly woken kworker, but which? According to the vruntime, I would
assume kworker is in cgroupB.

