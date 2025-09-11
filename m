Return-Path: <kvm+bounces-57274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC092B5284C
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 07:49:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 786A6A0294E
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 05:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74BDD253B58;
	Thu, 11 Sep 2025 05:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SCaHCpL5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7601547EE
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 05:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757569763; cv=none; b=Q7SmIb9ENCABW9MR+e6c1o6XspR+8LS9eTci8G6T9qLUdU587yVPy6nFoHml42aCyt4WPPcQWQwisAAox0uI7U4+72+Cy5nOPV4zqfJNA4sg+3+a7DHP65w7FjgTsEcfcCGdKAAQU39jPl0gtRCkdrGfRTBsMJuqzYwghLl+oJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757569763; c=relaxed/simple;
	bh=JIYVIQlB7J9T03D+eAy6Vs64tXPxmHEhF7bGRnRDbzo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Za6Otfnt241agofuBwQ+UzZ2iejNg5gXswSp6D6b2OboaStHx1rw/W5Rvm4zYnQgrSty601ggqITPcQteQbPfdfRUYDsEEv1FsUPKIGQoF+Bb6KTzJ7k8bIPbo/trkEGxYbg9RyDYGZvPLos6Or60xsNoIsBkYiT26I2ueJdQis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SCaHCpL5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757569760;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lA/nIyygxp23zR9n/0zHUPCz01RuhWaoaOgXYYqwEFU=;
	b=SCaHCpL5HkwjGtG1gt0c7z6ysbjo81fFoDo1c2V49rmOTXx7ntcG5qccgtgOpkKOa7Y8n+
	UZHXJbZRYezWAbVqrVD8DJmUunSauRs9IBR5DPHdRnZk5EBDCgQLnir4xFRj6VhlPhCaPr
	gtcZx83TFQEUXGoPLdTOPl6tV/eNGKM=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-150-oLQwTZ9mOAG6KuzjVr7AwA-1; Thu, 11 Sep 2025 01:49:18 -0400
X-MC-Unique: oLQwTZ9mOAG6KuzjVr7AwA-1
X-Mimecast-MFC-AGG-ID: oLQwTZ9mOAG6KuzjVr7AwA_1757569758
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-24c9304b7bcso4362385ad.3
        for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 22:49:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757569757; x=1758174557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lA/nIyygxp23zR9n/0zHUPCz01RuhWaoaOgXYYqwEFU=;
        b=oM6o6rvwD4o6YNswFl9bBlkVsMDzPJHeRS9KsTwWDwwFiEdhQJcdJhdyvuFiai+J/f
         PPzSFqPNoDNMFhX9QRvbPLQO2gl4bla2KgRZ/CBoKq/Ffryr4+/yGSJAJn801D5qYiGM
         lDfINcds9/VENnWxmsR3uVLAy06fgYMlEHHuqTRA0yiWrnkctdUEuIgSWcuKN9OpaVvU
         70JrNolciYIsbnF+U8we9nIZU/P/mmX3mnTTJ4eqRfJPBR82PXf17uTPWvf5VUPqN4A3
         kVq2vJchv4ijfJ4/qZ17QA6QLDDJ6R/FBNcGrPr03Y5v47AYSLZWqUtVHRpF/jpagUSp
         m7Tw==
X-Forwarded-Encrypted: i=1; AJvYcCXnSagsrQRxEJFSFa4IvVh17EXTMHr3zRliNklohSDO8iJ/rZRh2bVfC6Jyw0yY3UutdN4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6Pht7kYS4RkJonSpT/cchVJTEyDui/YbJp0Jq4O0RTynPd0K4
	jekGxTpRn++Wwc/p/giFv9qEYVqp5SYxAi6Jn9hdn6IxTq1xtIlzygBYUmZA6zeof2ZfQx1tnc+
	9UEtRwHXlENMnd04Zmzo+ddheIJonwQeypmpu4l7P/lYQkMogPhJzElBzhh41Si2MSVDWxA+6OI
	XqLogCE3ErzRXAlyvlQSf2y4rWXswh
X-Gm-Gg: ASbGnctRiOIvCGA2PAyB6ftglQkrGXdFLuzV9VhNLCLcNUkFQcNtRVn5S36HrJescog
	z3E/tHg59tmfOE8gsxgTWa/aHwHQ24DkrgJ4/QdqjdPBGxTcysJWrL0wdZ5Ts9iPbulXrfFbgkl
	stp6czQIHXaI4KkShFUdM=
X-Received: by 2002:a17:90b:2f48:b0:32d:dadf:b6ac with SMTP id 98e67ed59e1d1-32ddadfbc40mr584405a91.33.1757569757638;
        Wed, 10 Sep 2025 22:49:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHwWFrSzVREtFpLHQeMGB7oIiUl7lSi6qj8cNkKYaS39zzL0tJAYGt0Ag8spgomwA5uNHDMMOTpsNPlW3ePagM=
X-Received: by 2002:a17:90b:2f48:b0:32d:dadf:b6ac with SMTP id
 98e67ed59e1d1-32ddadfbc40mr584389a91.33.1757569757109; Wed, 10 Sep 2025
 22:49:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250501020428.1889162-1-jon@nutanix.com> <174649563599.1007977.10317536057166889809.git-patchwork-notify@kernel.org>
 <154EA998-3FBB-41E9-B07E-4841B027B1B5@nutanix.com> <20250910155110-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250910155110-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 11 Sep 2025 13:49:05 +0800
X-Gm-Features: Ac12FXz2GiW7KSQdNYNxPu26Ksj8x667AJ6XM8sYkMeO98LgOStRktKKhO4igRI
Message-ID: <CACGkMEvggRncZegemhR9fnkRDGJh1G3jgjycDG0ZX8RKg2-X-Q@mail.gmail.com>
Subject: Re: vhost_iotlb_miss tight loop lockup - RE vhost/net: Defer TX queue
 re-enable until after sendmsg
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jon Kohler <jon@nutanix.com>, 
	"patchwork-bot+netdevbpf@kernel.org" <patchwork-bot+netdevbpf@kernel.org>, 
	"eperezma@redhat.com" <eperezma@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 4:11=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Wed, Sep 10, 2025 at 06:58:18PM +0000, Jon Kohler wrote:
> >
> >
> > > On May 5, 2025, at 9:40=E2=80=AFPM, patchwork-bot+netdevbpf@kernel.or=
g wrote:
> > >
> > > Hello:
> > >
> > > This patch was applied to netdev/net-next.git (main)
> > > by Jakub Kicinski <kuba@kernel.org>:
> >
> > Hey all,
> > Writing to fire up a flare and point out a problem that we=E2=80=99re s=
eeing
> > with this patch internally, specifically when we enable iommu on the
> > virtio-net device.
> >
> > With this patch applied on 6.12.y-based bare metal instance and then
> > starting a 6.12.y based guest with iommu enabled, we see lockups
> > within the guest in short order, as well as vmm (qemu) stuck in a tight
> > loop responding to iommu misses from vhost net loop.
> >
> > We've bisected this in our internal tree, and for sure it is this
> > patch that is alledgedly causing the problem, so I wanted to point out
> > there is some sort of issue here.
> >
> > Working on trying to figure this out, but if jumps off the page to
> > anyone, happy to take advice!
> >
> > Flamegraph:
> > https://gist.github.com/JonKohler/0e83c014230ab59ddc950f10441335f1#file=
-iotlb-lockup-svg
> >
> > Guest dmesg errors like so:
> > [   66.081694] virtio_net virtio0 eth0: NETDEV WATCHDOG: CPU: 1: transm=
it queue 0 timed out 5500 ms
> > [   68.145155] virtio_net virtio0 eth0: TX timeout on queue: 0, sq: out=
put.0, vq: 0x1, name: output.0, 7560000 usecs ago
> > [  112.907012] virtio_net virtio0 eth0: NETDEV WATCHDOG: CPU: 1: transm=
it queue 0 timed out 5568 ms
> > [  124.117540] virtio_net virtio0 eth0: TX timeout on queue: 0, sq: out=
put.0, vq: 0x1, name: output.0, 16776000 usecs ago
> > [  124.118050] virtio_net virtio0 eth0: NETDEV WATCHDOG: CPU: 1: transm=
it queue 0 timed out 16776 ms
> > [  124.118447] virtio_net virtio0 eth0: TX timeout on queue: 0, sq: out=
put.0, vq: 0x1, name: output.0, 16776000 usecs ago
> >
> > Host level top output
> > 3992758 qemu      20   0   16.6g  52168  26704 R  99.9   0.0  21:23.72 =
qemu-kvm       <<< this is the qemu main thread
> > 3992769 qemu      20   0   16.6g  52168  26704 R  58.8   0.0  13:33.44 =
vhost-3992758 <<< this is the vhost-net kthread
> >
> > For qemu-kvm main thread:
> > Samples: 13K of event 'cycles:P', 4000 Hz, Event count (approx.): 51319=
22583 lost: 0/0 drop: 0/0
> >   Children      Self  Shared Object     Symbol
> > -   87.41%     0.30%  [kernel]          [k] entry_SYSCALL_64_after_hwfr=
ame
> >    - 87.11% entry_SYSCALL_64_after_hwframe
> >       - do_syscall_64
> >          - 44.79% ksys_write
> >             - 43.74% vfs_write
> >                - 40.96% vhost_chr_write_iter
> >                   - 38.22% vhost_process_iotlb_msg
> >                      - 13.72% vhost_iotlb_add_range_ctx
> >                         - 7.43% vhost_iotlb_map_free
> >                            - 4.37% vhost_iotlb_itree_remove
> >                                 rb_next
> >                              1.78% __rb_erase_color
> >                              0.73% kfree
> >                           1.15% __rb_insert_augmented
> >                           0.68% __kmalloc_cache_noprof
> >                      - 10.73% vhost_vq_work_queue
> >                         - 7.65% try_to_wake_up
> >                            - 2.55% ttwu_queue_wakelist
> >                               - 1.72% __smp_call_single_queue
> >                                    1.36% call_function_single_prep_ipi
> >                            - 1.32% __task_rq_lock
> >                               - _raw_spin_lock
> >                                    native_queued_spin_lock_slowpath
> >                            - 1.30% select_task_rq
> >                               - select_task_rq_fair
> >                                  - 0.88% wake_affine
> >                                       available_idle_cpu
> >                           2.06% llist_add_batch
> >                      - 4.05% __mutex_lock.constprop.0
> >                           2.14% mutex_spin_on_owner
> >                           0.72% osq_lock
> >                        3.00% mutex_lock
> >                      - 1.72% kfree
> >                         - 1.16% __slab_free
> >                              slab_update_freelist.constprop.0.isra.0
> >                        1.37% _raw_spin_lock
> >                        1.08% mutex_unlock
> >                     1.98% _copy_from_iter
> >                - 1.86% rw_verify_area
> >                   - security_file_permission
> >                      - 1.13% file_has_perm
> >                           0.69% avc_has_perm
> >               0.63% fdget_pos
> >          - 27.86% syscall_exit_to_user_mode
> >             - syscall_exit_to_user_mode_prepare
> >                - 25.96% __audit_syscall_exit
> >                   - 25.03% __audit_filter_op
> >                        6.66% audit_filter_rules.constprop.0
> >                  1.27% audit_reset_context.part.0.constprop.0
> >          - 10.86% ksys_read
> >             - 9.37% vfs_read
> >                - 6.67% vhost_chr_read_iter
> >                     1.48% _copy_to_iter
> >                     1.36% _raw_spin_lock
> >                   - 1.30% __wake_up
> >                        0.81% _raw_spin_lock_irqsave
> >                   - 1.25% vhost_enqueue_msg
> >                        _raw_spin_lock
> >                - 1.83% rw_verify_area
> >                   - security_file_permission
> >                      - 1.03% file_has_perm
> >                           0.64% avc_has_perm
> >               0.65% fdget_pos
> >               0.57% fput
> >          - 2.56% syscall_trace_enter
> >             - 1.25% __seccomp_filter
> >                  seccomp_run_filters
> >               0.54% __audit_syscall_entry
> >
> > vhost-net thread
> > Samples: 20K of event 'cycles:P', 4000 Hz, Event count (approx.): 77964=
56297 lost: 0/0 drop: 0/0
> >   Children      Self  Shared Object     Symbol
> > -  100.00%     3.38%  [kernel]          [k] vhost_task_fn
> >      38.26% 0xffffffff930bb8c0
> >    - 3.36% 0
> >         ret_from_fork_asm
> >         ret_from_fork
> >    - 1.16% vhost_task_fn
> >       - 2.35% vhost_run_work_list
> >          - 1.67% handle_tx
> >             - 7.09% __mutex_lock.constprop.0
> >                  6.64% mutex_spin_on_owner
> >             - 0.84% vq_meta_prefetch
> >                - 3.22% iotlb_access_ok
> >                     2.50% vhost_iotlb_itree_first
> >               0.80% mutex_lock
> >             - 0.75% handle_tx_copy
> >            0.86% llist_reverse_order
> >
> > >
> > > On Wed, 30 Apr 2025 19:04:28 -0700 you wrote:
> > >> In handle_tx_copy, TX batching processes packets below ~PAGE_SIZE an=
d
> > >> batches up to 64 messages before calling sock->sendmsg.
> > >>
> > >> Currently, when there are no more messages on the ring to dequeue,
> > >> handle_tx_copy re-enables kicks on the ring *before* firing off the
> > >> batch sendmsg. However, sock->sendmsg incurs a non-zero delay,
> > >> especially if it needs to wake up a thread (e.g., another vhost work=
er).
> > >>
> > >> [...]
> > >
> > > Here is the summary with links:
> > >  - [net-next,v3] vhost/net: Defer TX queue re-enable until after send=
msg
> > >    https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__git.kernel.=
org_netdev_net-2Dnext_c_8c2e6b26ffe2&d=3DDwIDaQ&c=3Ds883GpUCOChKOHiocYtGcg&=
r=3DNGPRGGo37mQiSXgHKm5rCQ&m=3D0XoR6N9VbkaJ_wBENy8Z28uDdqjCe4HRNCyV-8o4etqX=
eEJOqoFFGjeGGP5sQcmt&s=3D-X8si_rU8pXKNyWNNzBqx5Fmv-ut9w2gS5E6coMDApM&e=3D
> > >
> > > You are awesome, thank you!
> > > --
> > > Deet-doot-dot, I am a bot.
> > > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__korg.docs.kern=
el.org_patchwork_pwbot.html&d=3DDwIDaQ&c=3Ds883GpUCOChKOHiocYtGcg&r=3DNGPRG=
Go37mQiSXgHKm5rCQ&m=3D0XoR6N9VbkaJ_wBENy8Z28uDdqjCe4HRNCyV-8o4etqXeEJOqoFFG=
jeGGP5sQcmt&s=3DsydedZsBCMSJM9_Ldw6Al-BplvM7FokLwV_80bJpGnM&e=3D
> > >
> > >
> >
>
>
> Well it seems that if  get_tx_bufs failed with -EAGAIN then we
> previously bailed out, but now we will redo poll and so on, forever.

Something like this, the vhost_vq_avail_empty() will cause the
vhost_poll_queue() to be queued in this case.

Let me post a patch to fix that.

Thanks

>
>
> No?
>
>
> --
> MST
>


