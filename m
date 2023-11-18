Return-Path: <kvm+bounces-1998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D5887F004C
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 16:33:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E226EB209C9
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 15:33:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 830CE182A3;
	Sat, 18 Nov 2023 15:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
X-Greylist: delayed 182 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 18 Nov 2023 07:33:10 PST
Received: from mx10.didiglobal.com (mx10.didiglobal.com [111.202.70.125])
	by lindbergh.monkeyblade.net (Postfix) with SMTP id 46BC112B;
	Sat, 18 Nov 2023 07:33:10 -0800 (PST)
Received: from mail.didiglobal.com (unknown [10.79.64.13])
	by mx10.didiglobal.com (MailData Gateway V2.8.8) with ESMTPS id 21E9C18F00FBBD;
	Sat, 18 Nov 2023 23:30:03 +0800 (CST)
Received: from [172.28.168.151] (10.79.71.102) by
 ZJY01-ACTMBX-03.didichuxing.com (10.79.64.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sat, 18 Nov 2023 23:30:02 +0800
Message-ID: <44b3098e-f98c-4e68-8d13-9d668f92fe36@didichuxing.com>
Date: Sat, 18 Nov 2023 23:29:52 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair: Add
 lag based placement)
To: Abel Wu <wuyun.abel@bytedance.com>, Tobias Huschle
	<huschle@linux.ibm.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<netdev@vger.kernel.org>
CC: Peterz <peterz@infradead.org>, <mst@redhat.com>, <jasowang@redhat.com>
Content-Language: en-US
X-MD-Sfrom: wanghonglei@didiglobal.com
X-MD-SrcIP: 10.79.64.13
From: Honglei Wang <wanghonglei@didichuxing.com>
In-Reply-To: <93c0f8f2-f40e-4dea-8260-6f610e77aa7f@bytedance.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.79.71.102]
X-ClientProxiedBy: ZJY02-PUBMBX-01.didichuxing.com (10.79.65.31) To
 ZJY01-ACTMBX-03.didichuxing.com (10.79.64.13)



On 2023/11/18 15:33, Abel Wu wrote:
> On 11/17/23 2:58 AM, Tobias Huschle Wrote:
>> #################### TRACE EXCERPT ####################
>> The sched_place trace event was added to the end of the place_entity 
>> function and outputs:
>> sev -> sched_entity vruntime
>> sed -> sched_entity deadline
>> sel -> sched_entity vlag
>> avg -> cfs_rq avg_vruntime
>> min -> cfs_rq min_vruntime
>> cpu -> cpu of cfs_rq
>> nr  -> cfs_rq nr_running
>> ---
>>      CPU 3/KVM-2950    [014] d....   576.161432: sched_migrate_task: 
>> comm=vhost-2920 pid=2941 prio=120 orig_cpu=15 dest_cpu=14
>> --> migrates task from cpu 15 to 14
>>      CPU 3/KVM-2950    [014] d....   576.161433: sched_place: 
>> comm=vhost-2920 pid=2941 sev=4242563284 sed=4245563284 sel=0 
>> avg=4242563284 min=4242563284 cpu=14 nr=0
>> --> places vhost 2920 on CPU 14 with vruntime 4242563284
>>      CPU 3/KVM-2950    [014] d....   576.161433: sched_place: comm= 
>> pid=0 sev=16329848593 sed=16334604010 sel=0 avg=16329848593 
>> min=16329848593 cpu=14 nr=0
>>      CPU 3/KVM-2950    [014] d....   576.161433: sched_place: comm= 
>> pid=0 sev=42560661157 sed=42627443765 sel=0 avg=42560661157 
>> min=42560661157 cpu=14 nr=0
>>      CPU 3/KVM-2950    [014] d....   576.161434: sched_place: comm= 
>> pid=0 sev=53846627372 sed=54125900099 sel=0 avg=53846627372 
>> min=53846627372 cpu=14 nr=0
>>      CPU 3/KVM-2950    [014] d....   576.161434: sched_place: comm= 
>> pid=0 sev=86640641980 sed=87255041979 sel=0 avg=86640641980 
>> min=86640641980 cpu=14 nr=0
> 
> As the following 2 lines indicates that vhost-2920 is on_rq so can be
> picked as next, thus its cfs_rq must have at least one entity.
> 
> While the above 4 lines shows nr=0, so the "comm= pid=0" task(s) can't
> be in the same cgroup with vhost-2920.
> 
> Say vhost is in cgroupA, and "comm= pid=0" task with sev=86640641980
> is in cgroupB ...
> 
This looks like an hierarchy enqueue staff. The temporary trace can get 
comm and pid of vhost-2920, but failed for the other 4. I think the 
reason is they were just se but not tasks. Seems this came from the 
for_each_sched_entity(se) when doing enqueue vhost-2920. And the last 
one with cfs_rq vruntime=86640641980 might be the root cgroup which was 
on same level with kworkers.

So just from this tiny part of the trace log, there won't be thousands 
ms level difference. Actually, it might be only 86642125805-86640641980 
= 1.5 ms.

correct me if there is anything wrong..

Thanks,
Honglei
>>      CPU 3/KVM-2950    [014] dN...   576.161434: sched_stat_wait: 
>> comm=vhost-2920 pid=2941 delay=9958 [ns]
>>      CPU 3/KVM-2950    [014] d....   576.161435: sched_switch: 
>> prev_comm=CPU 3/KVM prev_pid=2950 prev_prio=120 prev_state=S ==> 
>> next_comm=vhost-2920 next_pid=2941 next_prio=120
>>     vhost-2920-2941    [014] D....   576.161439: sched_waking: 
>> comm=vhost-2286 pid=2309 prio=120 target_cpu=008
>>     vhost-2920-2941    [014] d....   576.161446: sched_waking: 
>> comm=kworker/14:0 pid=6525 prio=120 target_cpu=014
>>     vhost-2920-2941    [014] d....   576.161447: sched_place: 
>> comm=kworker/14:0 pid=6525 sev=86642125805 sed=86645125805 sel=0 
>> avg=86642125805 min=86642125805 cpu=14 nr=1
>> --> places kworker 6525 on cpu 14 with vruntime 86642125805
>> -->  which is far larger than vhost vruntime of  4242563284
> 
> Here nr=1 means there is another entity in the same cfs_rq with the
> newly woken kworker, but which? According to the vruntime, I would
> assume kworker is in cgroupB.

