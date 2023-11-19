Return-Path: <kvm+bounces-2013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AD357F066E
	for <lists+kvm@lfdr.de>; Sun, 19 Nov 2023 14:30:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5B501C20752
	for <lists+kvm@lfdr.de>; Sun, 19 Nov 2023 13:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8A89111AD;
	Sun, 19 Nov 2023 13:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W0wUVuAG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456D1C2;
	Sun, 19 Nov 2023 05:29:45 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-6cb66fbc63dso425978b3a.0;
        Sun, 19 Nov 2023 05:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700400585; x=1701005385; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kJv8gAH5q8bXkpAdk4M1bXRnPQIyDa6bo8fb8FFn0o4=;
        b=W0wUVuAGCj7OF9y8hyRgRUW2qTOdzOTPdjbFDfc/5jfH42MZCoDiY7VKd7UHGgiAt7
         boHRb9Xs5h4mFZ0xZVXbUykOYVCiSYhY+uDT4m1igDJKHV2oVp8EQUB4xo9GangT0GTh
         LdzU06fXpfAXZRUHTu6eGX5j5FqPSk0q9qQXb5C5nlh0b3O8G67mkewToEm0zFt4b0bq
         cUCJtScPde1eRupVPmbv2dEY/21UG0FOU+DV2Q3N8hmfbqsQyY6acjpmEQJk6xse9JXx
         kp13lfsOZ+X/2oM3o6EMITgodSWKKf8D4yR+FIWN5no2NlmYo+JcwRYmSiVoEThrxGxz
         7j9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700400585; x=1701005385;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kJv8gAH5q8bXkpAdk4M1bXRnPQIyDa6bo8fb8FFn0o4=;
        b=hJK2eLekoyH2Epp++psyAj5ERsbRitV4Bb0drjawpO5+zEP1U/YwBc3BHfjjJaDRS6
         nkPx40nk/tJKzZKpqY8W69xoppUT5wFAsHY9MOKwpwKUbcJdZXSjZRcUSia2VDw9krBq
         w0oYeymeckZSqjgpOvEuSKeSBAcV5hs9go72F2G45EK5DUNz+4HotdE6DGtHwUVBjOwC
         xKsd69iHqEfm3hOSB3AvrBdrPpUSGliWfSEu0RoaYre0fxLXaWUyoe5ObqKSAXkWJu4A
         1Ov7tYpvUMxgX4duPI4upuK5haCakd1TX18RP+UALamiE5oAMuEvD4I61iQ7p+RhQVXk
         tewQ==
X-Gm-Message-State: AOJu0YwjceDKokv+bYZN6S68Z0f+FEf1H9Y2V7QEEEi3B5LMu24o0rNL
	uf+AytZCGzms7MbPzQUpPNg=
X-Google-Smtp-Source: AGHT+IHQr6RPot5nQxRcjCCT/nrJWyqQqhh0R0i1gPi6uGHlXXfu4GQVp69AC9Bhscb4UwyJoH8/rw==
X-Received: by 2002:a05:6a21:32a9:b0:187:fefc:541d with SMTP id yt41-20020a056a2132a900b00187fefc541dmr6166706pzb.17.1700400584473;
        Sun, 19 Nov 2023 05:29:44 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id x4-20020aa784c4000000b006bf536bcd23sm4363921pfn.161.2023.11.19.05.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Nov 2023 05:29:44 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id EACB9101D92E3; Sun, 19 Nov 2023 20:29:39 +0700 (WIB)
Date: Sun, 19 Nov 2023 20:29:39 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Tobias Huschle <huschle@linux.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux KVM <kvm@vger.kernel.org>,
	Linux Virtualization <virtualization@lists.linux.dev>,
	Linux Networking <netdev@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
	Abel Wu <wuyun.abel@bytedance.com>,
	Honglei Wang <wanghonglei@didichuxing.com>, mst@redhat.com,
	jasowang@redhat.com
Subject: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair: Add
 lag based placement)
Message-ID: <ZVoNw4ta_1oWIrKX@archie.me>
References: <c7b38bc27cc2c480f0c5383366416455@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XWkoM4CGzIe0dY30"
Content-Disposition: inline
In-Reply-To: <c7b38bc27cc2c480f0c5383366416455@linux.ibm.com>


--XWkoM4CGzIe0dY30
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 16, 2023 at 07:58:18PM +0100, Tobias Huschle wrote:
> Hi,
>=20
> when testing the EEVDF scheduler we stumbled upon a performance regression
> in a uperf scenario and would like to
> kindly ask for feedback on whether we are going into the right direction
> with our analysis so far.
>=20
> The base scenario are two KVM guests running on an s390 LPAR. One guest
> hosts the uperf server, one the uperf client.
> With EEVDF we observe a regression of ~50% for a strburst test.
> For a more detailed description of the setup see the section TEST SUMMARY=
 at
> the bottom.
>=20
> Bisecting led us to the following commit which appears to introduce the
> regression:
> 86bfbb7ce4f6 sched/fair: Add lag based placement
>=20
> We then compared the last good commit we identified with a recent level of
> the devel branch.
> The issue still persists on 6.7 rc1 although there is some improvement (d=
own
> from 62% regression to 49%)
>=20
> All analysis described further are based on a 6.6 rc7 kernel.
>=20
> We sampled perf data to get an idea on what is going wrong and ended up
> seeing an dramatic increase in the maximum
> wait times from 3ms up to 366ms. See section WAIT DELAYS below for more
> details.
>=20
> We then collected tracing data to get a better insight into what is going
> on.
> The trace excerpt in section TRACE EXCERPT shows one example (of multiple
> per test run) of the problematic scenario where
> a kworker(pid=3D6525) has to wait for 39,718 ms.
>=20
> Short summary:
> The mentioned kworker has been scheduled to CPU 14 before the tracing was
> enabled.
> A vhost process is migrated onto CPU 14.
> The vruntimes of kworker and vhost differ significantly (86642125805 vs
> 4242563284 -> factor 20)
> The vhost process wants to wake up the kworker, therefore the kworker is
> placed onto the runqueue again and set to runnable.
> The vhost process continues to execute, waking up other vhost processes on
> other CPUs.
>=20
> So far this behavior is not different to what we see on pre-EEVDF kernels.
>=20
> On timestamp 576.162767, the vhost process triggers the last wake up of
> another vhost on another CPU.
> Until timestamp 576.171155, we see no other activity. Now, the vhost proc=
ess
> ends its time slice.
> Then, vhost gets re-assigned new time slices 4 times and gets then migrat=
ed
> off to CPU 15.
> This does not occur with older kernels.
> The kworker has to wait for the migration to happen in order to be able to
> execute again.
> This is due to the fact, that the vruntime of the kworker is significantly
> larger than the one of vhost.
>=20
>=20
> We observed the large difference in vruntime between kworker and vhost in
> the same magnitude on
> a kernel built based on the parent of the commit mentioned above.
> With EEVDF, the kworker is doomed to wait until the vhost either catches =
up
> on vruntime (which would take 86 seconds)
> or the vhost is migrated off of the CPU.
>=20
> We found some options which sound plausible but we are not sure if they a=
re
> valid or not:
>=20
> 1. The wake up path has a dependency on the vruntime metrics that now del=
ays
> the execution of the kworker.
> 2. The previous commit af4cf40470c2 (sched/fair: Add cfs_rq::avg_vruntime)
> which updates the way cfs_rq->min_vruntime and
>     cfs_rq->avg_runtime are set might have introduced an issue which is
> uncovered with the commit mentioned above.
> 3. An assumption in the vhost code which causes vhost to rely on being
> scheduled off in time to allow the kworker to proceed.
>=20
> We also stumbled upon the following mailing thread:
> https://lore.kernel.org/lkml/ZORaUsd+So+tnyMV@chenyu5-mobl2/
> That conversation, and the patches derived from it lead to the assumption
> that the wake up path might be adjustable in a way
> that this case in particular can be addressed.
> At the same time, the vast difference in vruntimes is concerning since, at
> least for some time frame, both processes are on the runqueue.
>=20
> We would be glad to hear some feedback on which paths to pursue and which
> might just be a dead end in the first place.
>=20
>=20
> #################### TRACE EXCERPT ####################
> The sched_place trace event was added to the end of the place_entity
> function and outputs:
> sev -> sched_entity vruntime
> sed -> sched_entity deadline
> sel -> sched_entity vlag
> avg -> cfs_rq avg_vruntime
> min -> cfs_rq min_vruntime
> cpu -> cpu of cfs_rq
> nr  -> cfs_rq nr_running
> ---
>     CPU 3/KVM-2950    [014] d....   576.161432: sched_migrate_task:
> comm=3Dvhost-2920 pid=3D2941 prio=3D120 orig_cpu=3D15 dest_cpu=3D14
> --> migrates task from cpu 15 to 14
>     CPU 3/KVM-2950    [014] d....   576.161433: sched_place: comm=3Dvhost=
-2920
> pid=3D2941 sev=3D4242563284 sed=3D4245563284 sel=3D0 avg=3D4242563284 min=
=3D4242563284
> cpu=3D14 nr=3D0
> --> places vhost 2920 on CPU 14 with vruntime 4242563284
>     CPU 3/KVM-2950    [014] d....   576.161433: sched_place: comm=3D pid=
=3D0
> sev=3D16329848593 sed=3D16334604010 sel=3D0 avg=3D16329848593 min=3D16329=
848593 cpu=3D14
> nr=3D0
>     CPU 3/KVM-2950    [014] d....   576.161433: sched_place: comm=3D pid=
=3D0
> sev=3D42560661157 sed=3D42627443765 sel=3D0 avg=3D42560661157 min=3D42560=
661157 cpu=3D14
> nr=3D0
>     CPU 3/KVM-2950    [014] d....   576.161434: sched_place: comm=3D pid=
=3D0
> sev=3D53846627372 sed=3D54125900099 sel=3D0 avg=3D53846627372 min=3D53846=
627372 cpu=3D14
> nr=3D0
>     CPU 3/KVM-2950    [014] d....   576.161434: sched_place: comm=3D pid=
=3D0
> sev=3D86640641980 sed=3D87255041979 sel=3D0 avg=3D86640641980 min=3D86640=
641980 cpu=3D14
> nr=3D0
>     CPU 3/KVM-2950    [014] dN...   576.161434: sched_stat_wait:
> comm=3Dvhost-2920 pid=3D2941 delay=3D9958 [ns]
>     CPU 3/KVM-2950    [014] d....   576.161435: sched_switch: prev_comm=
=3DCPU
> 3/KVM prev_pid=3D2950 prev_prio=3D120 prev_state=3DS =3D=3D> next_comm=3D=
vhost-2920
> next_pid=3D2941 next_prio=3D120
>    vhost-2920-2941    [014] D....   576.161439: sched_waking:
> comm=3Dvhost-2286 pid=3D2309 prio=3D120 target_cpu=3D008
>    vhost-2920-2941    [014] d....   576.161446: sched_waking:
> comm=3Dkworker/14:0 pid=3D6525 prio=3D120 target_cpu=3D014
>    vhost-2920-2941    [014] d....   576.161447: sched_place:
> comm=3Dkworker/14:0 pid=3D6525 sev=3D86642125805 sed=3D86645125805 sel=3D0
> avg=3D86642125805 min=3D86642125805 cpu=3D14 nr=3D1
> --> places kworker 6525 on cpu 14 with vruntime 86642125805
> -->  which is far larger than vhost vruntime of  4242563284
>    vhost-2920-2941    [014] d....   576.161447: sched_stat_blocked:
> comm=3Dkworker/14:0 pid=3D6525 delay=3D10143757 [ns]
>    vhost-2920-2941    [014] dN...   576.161447: sched_wakeup:
> comm=3Dkworker/14:0 pid=3D6525 prio=3D120 target_cpu=3D014
>    vhost-2920-2941    [014] dN...   576.161448: sched_stat_runtime:
> comm=3Dvhost-2920 pid=3D2941 runtime=3D13884 [ns] vruntime=3D4242577168 [=
ns]
> --> vhost 2920 finishes after 13884 ns of runtime
>    vhost-2920-2941    [014] dN...   576.161448: sched_stat_wait:
> comm=3Dkworker/14:0 pid=3D6525 delay=3D0 [ns]
>    vhost-2920-2941    [014] d....   576.161448: sched_switch:
> prev_comm=3Dvhost-2920 prev_pid=3D2941 prev_prio=3D120 prev_state=3DR+ =
=3D=3D>
> next_comm=3Dkworker/14:0 next_pid=3D6525 next_prio=3D120
> --> switch to kworker
>  kworker/14:0-6525    [014] d....   576.161449: sched_waking: comm=3DCPU =
2/KVM
> pid=3D2949 prio=3D120 target_cpu=3D007
>  kworker/14:0-6525    [014] d....   576.161450: sched_stat_runtime:
> comm=3Dkworker/14:0 pid=3D6525 runtime=3D3714 [ns] vruntime=3D86642129519=
 [ns]
> --> kworker finshes after 3714 ns of runtime
>  kworker/14:0-6525    [014] d....   576.161450: sched_stat_wait:
> comm=3Dvhost-2920 pid=3D2941 delay=3D3714 [ns]
>  kworker/14:0-6525    [014] d....   576.161451: sched_switch:
> prev_comm=3Dkworker/14:0 prev_pid=3D6525 prev_prio=3D120 prev_state=3DI =
=3D=3D>
> next_comm=3Dvhost-2920 next_pid=3D2941 next_prio=3D120
> --> switch back to vhost
>    vhost-2920-2941    [014] d....   576.161478: sched_waking:
> comm=3Dkworker/14:0 pid=3D6525 prio=3D120 target_cpu=3D014
>    vhost-2920-2941    [014] d....   576.161478: sched_place:
> comm=3Dkworker/14:0 pid=3D6525 sev=3D86642191859 sed=3D86645191859 sel=3D=
-1150
> avg=3D86642188144 min=3D86642188144 cpu=3D14 nr=3D1
> --> kworker placed again on cpu 14 with vruntime 86642191859, the problem
> occurs only if lag <=3D 0, having lag=3D0 does not always hit the problem=
 though
>    vhost-2920-2941    [014] d....   576.161478: sched_stat_blocked:
> comm=3Dkworker/14:0 pid=3D6525 delay=3D27943 [ns]
>    vhost-2920-2941    [014] d....   576.161479: sched_wakeup:
> comm=3Dkworker/14:0 pid=3D6525 prio=3D120 target_cpu=3D014
>    vhost-2920-2941    [014] D....   576.161511: sched_waking:
> comm=3Dvhost-2286 pid=3D2308 prio=3D120 target_cpu=3D006
>    vhost-2920-2941    [014] D....   576.161512: sched_waking:
> comm=3Dvhost-2286 pid=3D2309 prio=3D120 target_cpu=3D008
>    vhost-2920-2941    [014] D....   576.161516: sched_waking:
> comm=3Dvhost-2286 pid=3D2308 prio=3D120 target_cpu=3D006
>    vhost-2920-2941    [014] D....   576.161773: sched_waking:
> comm=3Dvhost-2286 pid=3D2308 prio=3D120 target_cpu=3D006
>    vhost-2920-2941    [014] D....   576.161775: sched_waking:
> comm=3Dvhost-2286 pid=3D2309 prio=3D120 target_cpu=3D008
>    vhost-2920-2941    [014] D....   576.162103: sched_waking:
> comm=3Dvhost-2286 pid=3D2308 prio=3D120 target_cpu=3D006
>    vhost-2920-2941    [014] D....   576.162105: sched_waking:
> comm=3Dvhost-2286 pid=3D2307 prio=3D120 target_cpu=3D021
>    vhost-2920-2941    [014] D....   576.162326: sched_waking:
> comm=3Dvhost-2286 pid=3D2305 prio=3D120 target_cpu=3D004
>    vhost-2920-2941    [014] D....   576.162437: sched_waking:
> comm=3Dvhost-2286 pid=3D2308 prio=3D120 target_cpu=3D006
>    vhost-2920-2941    [014] D....   576.162767: sched_waking:
> comm=3Dvhost-2286 pid=3D2305 prio=3D120 target_cpu=3D004
>    vhost-2920-2941    [014] d.h..   576.171155: sched_stat_runtime:
> comm=3Dvhost-2920 pid=3D2941 runtime=3D9704465 [ns] vruntime=3D4252281633=
 [ns]
>    vhost-2920-2941    [014] d.h..   576.181155: sched_stat_runtime:
> comm=3Dvhost-2920 pid=3D2941 runtime=3D10000377 [ns] vruntime=3D426228201=
0 [ns]
>    vhost-2920-2941    [014] d.h..   576.191154: sched_stat_runtime:
> comm=3Dvhost-2920 pid=3D2941 runtime=3D9999514 [ns] vruntime=3D4272281524=
 [ns]
>    vhost-2920-2941    [014] d.h..   576.201155: sched_stat_runtime:
> comm=3Dvhost-2920 pid=3D2941 runtime=3D10000246 [ns] vruntime=3D428228177=
0 [ns]
> --> vhost gets rescheduled multiple times because its vruntime is
> significantly smaller than the vruntime of the kworker
>    vhost-2920-2941    [014] dNh..   576.201176: sched_wakeup:
> comm=3Dmigration/14 pid=3D85 prio=3D0 target_cpu=3D014
>    vhost-2920-2941    [014] dN...   576.201191: sched_stat_runtime:
> comm=3Dvhost-2920 pid=3D2941 runtime=3D25190 [ns] vruntime=3D4282306960 [=
ns]
>    vhost-2920-2941    [014] d....   576.201192: sched_switch:
> prev_comm=3Dvhost-2920 prev_pid=3D2941 prev_prio=3D120 prev_state=3DR+ =
=3D=3D>
> next_comm=3Dmigration/14 next_pid=3D85 next_prio=3D0
>  migration/14-85      [014] d..1.   576.201194: sched_migrate_task:
> comm=3Dvhost-2920 pid=3D2941 prio=3D120 orig_cpu=3D14 dest_cpu=3D15
> --> vhost gets migrated off of cpu 14
>  migration/14-85      [014] d..1.   576.201194: sched_place: comm=3Dvhost=
-2920
> pid=3D2941 sev=3D3198666923 sed=3D3201666923 sel=3D0 avg=3D3198666923 min=
=3D3198666923
> cpu=3D15 nr=3D0
>  migration/14-85      [014] d..1.   576.201195: sched_place: comm=3D pid=
=3D0
> sev=3D12775683594 sed=3D12779398224 sel=3D0 avg=3D12775683594 min=3D12775=
683594 cpu=3D15
> nr=3D0
>  migration/14-85      [014] d..1.   576.201195: sched_place: comm=3D pid=
=3D0
> sev=3D33655559178 sed=3D33661025369 sel=3D0 avg=3D33655559178 min=3D33655=
559178 cpu=3D15
> nr=3D0
>  migration/14-85      [014] d..1.   576.201195: sched_place: comm=3D pid=
=3D0
> sev=3D42240572785 sed=3D42244083642 sel=3D0 avg=3D42240572785 min=3D42240=
572785 cpu=3D15
> nr=3D0
>  migration/14-85      [014] d..1.   576.201196: sched_place: comm=3D pid=
=3D0
> sev=3D70190876523 sed=3D70194789898 sel=3D-13068763 avg=3D70190876523
> min=3D70190876523 cpu=3D15 nr=3D0
>  migration/14-85      [014] d....   576.201198: sched_stat_wait:
> comm=3Dkworker/14:0 pid=3D6525 delay=3D39718472 [ns]
>  migration/14-85      [014] d....   576.201198: sched_switch:
> prev_comm=3Dmigration/14 prev_pid=3D85 prev_prio=3D0 prev_state=3DS =3D=
=3D>
> next_comm=3Dkworker/14:0 next_pid=3D6525 next_prio=3D120
>  --> only now, kworker is eligible to run again, after a delay of 39718472
> ns
>  kworker/14:0-6525    [014] d....   576.201200: sched_waking: comm=3DCPU =
0/KVM
> pid=3D2947 prio=3D120 target_cpu=3D012
>  kworker/14:0-6525    [014] d....   576.201290: sched_stat_runtime:
> comm=3Dkworker/14:0 pid=3D6525 runtime=3D92941 [ns] vruntime=3D8664228480=
0 [ns]
>=20
> #################### WAIT DELAYS - PERF LATENCY ####################
> last good commit --> perf sched latency -s max
> -------------------------------------------------------------------------=
------------------------------------------------------------------
>   Task                  |   Runtime ms  | Switches | Avg delay ms    | Max
> delay ms    | Max delay start           | Max delay end          |
> -------------------------------------------------------------------------=
------------------------------------------------------------------
>   CPU 2/KVM:(2)         |   5399.650 ms |   108698 | avg:   0.003 ms | ma=
x:
> 3.077 ms | max start:   544.090322 s | max end:   544.093399 s
>   CPU 7/KVM:(2)         |   5111.132 ms |    69632 | avg:   0.003 ms | ma=
x:
> 2.980 ms | max start:   544.690994 s | max end:   544.693974 s
>   kworker/22:3-ev:723   |    342.944 ms |    63417 | avg:   0.005 ms | ma=
x:
> 1.880 ms | max start:   545.235430 s | max end:   545.237310 s
>   CPU 0/KVM:(2)         |   8171.431 ms |   433099 | avg:   0.003 ms | ma=
x:
> 1.004 ms | max start:   547.970344 s | max end:   547.971348 s
>   CPU 1/KVM:(2)         |   5486.260 ms |   258702 | avg:   0.003 ms | ma=
x:
> 1.002 ms | max start:   548.782514 s | max end:   548.783516 s
>   CPU 5/KVM:(2)         |   4766.143 ms |    65727 | avg:   0.003 ms | ma=
x:
> 0.997 ms | max start:   545.313610 s | max end:   545.314607 s
>   vhost-2268:(6)        |  13206.503 ms |   315030 | avg:   0.003 ms | ma=
x:
> 0.989 ms | max start:   550.887761 s | max end:   550.888749 s
>   vhost-2892:(6)        |  14467.268 ms |   214005 | avg:   0.003 ms | ma=
x:
> 0.981 ms | max start:   545.213819 s | max end:   545.214800 s
>   CPU 3/KVM:(2)         |   5538.908 ms |    85105 | avg:   0.003 ms | ma=
x:
> 0.883 ms | max start:   547.138139 s | max end:   547.139023 s
>   CPU 6/KVM:(2)         |   5289.827 ms |    72301 | avg:   0.003 ms | ma=
x:
> 0.836 ms | max start:   551.094590 s | max end:   551.095425 s
>=20
> 6.6 rc7 --> perf sched latency -s max
> -------------------------------------------------------------------------=
------------------------------------------------------------------
>   Task                  |   Runtime ms  | Switches | Avg delay ms    | Max
> delay ms    | Max delay start           | Max delay end          |
> -------------------------------------------------------------------------=
------------------------------------------------------------------
>   kworker/19:2-ev:1071  |     69.482 ms |    12700 | avg:   0.050 ms | ma=
x:
> 366.314 ms | max start: 54705.674294 s | max end: 54706.040607 s
>   kworker/13:1-ev:184   |     78.048 ms |    14645 | avg:   0.067 ms | ma=
x:
> 287.738 ms | max start: 54710.312863 s | max end: 54710.600602 s
>   kworker/12:1-ev:46148 |    138.488 ms |    26660 | avg:   0.021 ms | ma=
x:
> 147.414 ms | max start: 54706.133161 s | max end: 54706.280576 s
>   kworker/16:2-ev:33076 |    149.175 ms |    29491 | avg:   0.026 ms | ma=
x:
> 139.752 ms | max start: 54708.410845 s | max end: 54708.550597 s
>   CPU 3/KVM:(2)         |   1934.714 ms |    41896 | avg:   0.007 ms | ma=
x:
> 92.126 ms | max start: 54713.158498 s | max end: 54713.250624 s
>   kworker/7:2-eve:17001 |     68.164 ms |    11820 | avg:   0.045 ms | ma=
x:
> 69.717 ms | max start: 54707.100903 s | max end: 54707.170619 s
>   kworker/17:1-ev:46510 |     68.804 ms |    13328 | avg:   0.037 ms | ma=
x:
> 67.894 ms | max start: 54711.022711 s | max end: 54711.090605 s
>   kworker/21:1-ev:45782 |     68.906 ms |    13215 | avg:   0.021 ms | ma=
x:
> 59.473 ms | max start: 54709.351135 s | max end: 54709.410608 s
>   ksoftirqd/17:101      |      0.041 ms |        2 | avg:  25.028 ms | ma=
x:
> 50.047 ms | max start: 54711.040578 s | max end: 54711.090625 s
>=20
> #################### TEST SUMMARY ####################
>  Setup description:
> - single KVM host with 2 identical guests
> - guests are connected virtually via Open vSwitch
> - guests run uperf streaming read workload with 50 parallel connections
> - one guests acts as uperf client, the other one as uperf server
>=20
> Regression:
> kernel-6.5.0-rc2: 78 Gb/s (before 86bfbb7ce4f6 sched/fair: Add lag based
> placement)
> kernel-6.5.0-rc2: 29 Gb/s (with 86bfbb7ce4f6 sched/fair: Add lag based
> placement)
> kernel-6.7.0-rc1: 41 Gb/s
>=20
> KVM host:
> - 12 dedicated IFLs, SMT-2 (24 Linux CPUs)
> - 64 GiB memory
> - FEDORA 38
> - kernel commandline: transparent_hugepage=3Dnever audit_enable=3D0 audit=
=3D0
> audit_debug=3D0 selinux=3D0
>=20
> KVM guests:
> - 8 vCPUs
> - 8 GiB memory
> - RHEL 9.2
> - kernel: 5.14.0-162.6.1.el9_1.s390x
> - kernel commandline: transparent_hugepage=3Dnever audit_enable=3D0 audit=
=3D0
> audit_debug=3D0 selinux=3D0
>=20
> Open vSwitch:
> - Open vSwitch with 2 ports, each with mtu=3D32768 and qlen=3D15000
> - Open vSwitch ports attached to guests via virtio-net
> - each guest has 4 vhost-queues
>=20
> Domain xml snippet for Open vSwitch port:
> <interface type=3D"bridge" dev=3D"OVS">
>   <source bridge=3D"vswitch0"/>
>   <mac address=3D"02:bb:97:28:02:02"/>
>   <virtualport type=3D"openvswitch"/>
>   <model type=3D"virtio"/>
>   <target dev=3D"vport1"/>
>   <driver name=3D"vhost" queues=3D"4"/>
>   <address type=3D"ccw" cssid=3D"0xfe" ssid=3D"0x0" devno=3D"0x0002"/>
> </interface>
>=20
> Benchmark: uperf
> - workload: str-readx30k, 50 active parallel connections
> - uperf server permanently sends data in 30720-byte chunks
> - uperf client receives and acknowledges this data
> - Server: uperf -s
> - Client: uperf -a -i 30 -m uperf.xml
>=20
> uperf.xml:
> <?xml version=3D"1.0"?>
> <profile name=3D"strburst">
>   <group nprocs=3D"50">
>     <transaction iterations=3D"1">
>       <flowop type=3D"connect" options=3D"remotehost=3D10.161.28.3 protoc=
ol=3Dtcp
> "/>
>     </transaction>
>     <transaction duration=3D"300">
>       <flowop type=3D"read" options=3D"count=3D640 size=3D30k"/>
>     </transaction>
>     <transaction iterations=3D"1">
>       <flowop type=3D"disconnect" />
>     </transaction>
>   </group>
> </profile>

Thanks for the regression report. I'm adding it to regzbot:

#regzbot ^introduced: 86bfbb7ce4f67a

--=20
An old man doll... just what I always wanted! - Clara

--XWkoM4CGzIe0dY30
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZVoNwwAKCRD2uYlJVVFO
o+cBAQDFArs4DMouZ9oO1BGlpXk4EJ/Pl0fstGGjl7k0pjOZmwD/Rx1VCZEOmNdQ
LDMkvDch9XMSRonRYEMu7zlO4fSGHQI=
=s1/r
-----END PGP SIGNATURE-----

--XWkoM4CGzIe0dY30--

