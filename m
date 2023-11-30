Return-Path: <kvm+bounces-2917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E99247FF083
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:44:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17A441C20E58
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 13:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39D8C482D5;
	Thu, 30 Nov 2023 13:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="taaya3lx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6991735
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 05:44:16 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-332c46d5988so557783f8f.1
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 05:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701351854; x=1701956654; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0mf7eH2hS0c3P4+d2fQms4pu9zEXfWtMcluTCO73qZ4=;
        b=taaya3lx6JIFhTkFj63pD9Fr1r9503i2pH94uwF9mukuoPVCrSWnVQ//gVKL3JLBGH
         TqcyJAyKCDQ4KHyAEx2xLvtQQxI6ZtMvD3bWcuSQEwUnsgv2rfuFXTnAZhHx7cHQ8n1U
         g0PLZuBBJ/+RJv5QxX1w/q0Ocv5H6FZckRPho7CL/lYBraTYV/gMv3DwBjaIwglMDVRd
         zzKxl5J8Y1czsvTZRjQLyVELtxinapepTQfLb3nacnL/M2alBuVr6rHThwkPsoYWITuS
         k1mxMp7ICEYZ/VRvLZo3S+kMwjTY0CFkWsg4fEyDH+XR+smY6t5mqXw1kIzf6falmBH9
         vUJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701351854; x=1701956654;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0mf7eH2hS0c3P4+d2fQms4pu9zEXfWtMcluTCO73qZ4=;
        b=v0W06TJoaTB1J1Vx5xpjEWdmomJZGX8y1/uS8mrIwtypK17N1Ny7LDR7lSnZlw6HzD
         OHizxlnh7lNwM+uTRTxz5AOEAxrND5MyVplFKN2AooljWst5dirXM4SIpU/lekbOo3+I
         CYMwX/UHK+301rrVMShuaRPredR4KbYiEMd5fvLH43dLGD7gd/S0iSzXxJlK8nW/IVCz
         B34CXvI1QRxZ6Eu+5tYz41CqtYiCw3iUaV7Alr+8OO2yJ0Ms/IwccydBIePTjGzviomz
         4l6VE7vVLYj6FRzLf4t8MBojKGxyuqvzX9aotcQTHG4fvDNyKvSXUDmgb7GIDT49SSuK
         dBhA==
X-Gm-Message-State: AOJu0Yz/u/paJ7YdOH7HWkCNxi2ZVMD0HLrKFXfcWHsWP7lTN3SUNVam
	VJlF/zIXGlMAyKzRXcQMeZdAnQ==
X-Google-Smtp-Source: AGHT+IFUGjlT2U8pG1QuxMF95YCA0GrMa8IF7sX8GSSN6+0zFOCS7e4DUVfFAG6PfrkSgylNqNXNlw==
X-Received: by 2002:adf:ff88:0:b0:333:a2f:e674 with SMTP id j8-20020adfff88000000b003330a2fe674mr6201850wrr.25.1701351854659;
        Thu, 30 Nov 2023 05:44:14 -0800 (PST)
Received: from [192.168.69.100] (sev93-h02-176-184-17-116.dsl.sta.abo.bbox.fr. [176.184.17.116])
        by smtp.gmail.com with ESMTPSA id cw18-20020a056000091200b00332fa6cc8acsm1576506wrb.87.2023.11.30.05.44.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Nov 2023 05:44:14 -0800 (PST)
Message-ID: <01ebd72d-affc-4b03-b491-f40964520f1c@linaro.org>
Date: Thu, 30 Nov 2023 14:44:07 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] system/cpus: rename qemu_global_mutex to qemu_bql
Content-Language: en-US
To: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org
Cc: Jean-Christophe Dubois <jcd@tribudubois.net>,
 Fabiano Rosas <farosas@suse.de>, qemu-s390x@nongnu.org,
 Song Gao <gaosong@loongson.cn>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, Thomas Huth <thuth@redhat.com>,
 Hyman Huang <yong.huang@smartx.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Andrey Smirnov <andrew.smirnov@gmail.com>,
 Peter Maydell <peter.maydell@linaro.org>, Kevin Wolf <kwolf@redhat.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Artyom Tarasenko
 <atar4qemu@gmail.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
 Max Filippov <jcmvbkbc@gmail.com>,
 Alistair Francis <alistair.francis@wdc.com>, Paul Durrant <paul@xen.org>,
 Jagannathan Raman <jag.raman@oracle.com>, Juan Quintela
 <quintela@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, qemu-arm@nongnu.org, Jason Wang
 <jasowang@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>,
 Hanna Reitz <hreitz@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 BALATON Zoltan <balaton@eik.bme.hu>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Elena Ufimtseva <elena.ufimtseva@oracle.com>,
 Aurelien Jarno <aurelien@aurel32.net>,
 Hailiang Zhang <zhanghailiang@xfusion.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, Huacai Chen <chenhuacai@kernel.org>,
 Fam Zheng <fam@euphon.net>, Eric Blake <eblake@redhat.com>,
 Jiri Slaby <jslaby@suse.cz>, Alexander Graf <agraf@csgraf.de>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Weiwei Li <liwei1518@gmail.com>,
 Eric Farman <farman@linux.ibm.com>, Stafford Horne <shorne@gmail.com>,
 David Hildenbrand <david@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Reinoud Zandijk <reinoud@netbsd.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Cameron Esfahani <dirty@apple.com>, xen-devel@lists.xenproject.org,
 Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, qemu-riscv@nongnu.org,
 Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
 John Snow <jsnow@redhat.com>, Sunil Muthuswamy <sunilmut@microsoft.com>,
 Michael Roth <michael.roth@amd.com>,
 David Gibson <david@gibson.dropbear.id.au>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Bin Meng <bin.meng@windriver.com>,
 Stefano Stabellini <sstabellini@kernel.org>, kvm@vger.kernel.org,
 qemu-block@nongnu.org, Halil Pasic <pasic@linux.ibm.com>,
 Peter Xu <peterx@redhat.com>, Anthony Perard <anthony.perard@citrix.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, Paolo Bonzini <pbonzini@redhat.com>,
 Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, qemu-ppc@nongnu.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>, Leonardo Bras
 <leobras@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <20231129212625.1051502-1-stefanha@redhat.com>
 <20231129212625.1051502-5-stefanha@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20231129212625.1051502-5-stefanha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Stefan,

On 29/11/23 22:26, Stefan Hajnoczi wrote:
> The APIs using qemu_global_mutex now follow the Big QEMU Lock (BQL)
> nomenclature. It's a little strange that the actual QemuMutex variable
> that embodies the BQL is called qemu_global_mutex instead of qemu_bql.
> Rename it for consistency.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>   system/cpus.c | 20 ++++++++++----------
>   1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/system/cpus.c b/system/cpus.c
> index eb24a4db8e..138720a540 100644
> --- a/system/cpus.c
> +++ b/system/cpus.c
> @@ -65,7 +65,7 @@
>   
>   #endif /* CONFIG_LINUX */
>   
> -static QemuMutex qemu_global_mutex;
> +static QemuMutex qemu_bql;

I thought we were using _cond/_sem/_mutex suffixes, but
this is not enforced:

$ git grep -hE 'Qemu(Cond|Mutex|Semaphore) [a-zA-Z]' \
   | sed -e 's/static //' -e 's/extern //' -e 's/^ *//' \
   | sort -u
QemuCond comp_done_cond;
QemuCond cond;
QemuCond decomp_done_cond;
QemuCond event_complete_cond;
QemuCond exclusive_cond;
QemuCond exclusive_resume;
QemuCond fwnmi_machine_check_interlock_cond;
QemuCond handle_apdu_cond;
QemuCond init_done_cond;    /* is thread initialization done? */
QemuCond key_cond;
QemuCond mutex_cond;
QemuCond page_cond;
QemuCond page_request_cond;
QemuCond qemu_cpu_cond;
QemuCond qemu_pause_cond;
QemuCond qemu_work_cond;
QemuCond request_cond;
QemuCond reset_cond;
QemuCond thr_cond;
QemuCond thread_cond;
QemuCond worker_stopped;
QemuMutex active_timers_lock;
QemuMutex aio_context_list_lock;
QemuMutex bitmap_mutex;
QemuMutex blkio_lock;
QemuMutex chr_write_lock;
QemuMutex cmdq_mutex;
QemuMutex colo_compare_mutex;
QemuMutex comp_done_lock;
QemuMutex counts_mutex;
QemuMutex decomp_done_lock;
QemuMutex dirty_bitmap_mutex;
QemuMutex dirtylimit_mutex;
QemuMutex error_mutex;
QemuMutex event_list_mutex;
QemuMutex event_mtx;
QemuMutex evlock;
QemuMutex free_page_lock;
QemuMutex global_mutex;
QemuMutex gnt_lock;
QemuMutex handle_apdu_mutex;
QemuMutex handlers_mutex;
QemuMutex init_done_lock;
QemuMutex intp_mutex; /* protect the intp_list IRQ state */
QemuMutex io_mutex;
QemuMutex iommu_lock;
QemuMutex irq_level_lock[REMOTE_IOHUB_NB_PIRQS];
QemuMutex job_mutex;
QemuMutex key_mutex;
QemuMutex kml_slots_lock;
QemuMutex lock;
QemuMutex m;
QemuMutex map_client_list_lock;
QemuMutex migration_threads_lock;
QemuMutex mon_fdsets_lock;
QemuMutex mon_lock;
QemuMutex monitor_lock;
QemuMutex mutex;
QemuMutex output_mutex;
QemuMutex page_mutex;
QemuMutex page_request_mutex;
QemuMutex pending_out_mutex;
QemuMutex port_lock;
QemuMutex postcopy_prio_thread_mutex;
QemuMutex qemu_cpu_list_lock;
QemuMutex qemu_file_lock;
QemuMutex qemu_global_mutex;
QemuMutex qemu_sigp_mutex;
QemuMutex qjack_shutdown_lock;
QemuMutex qmp_queue_lock;
QemuMutex queue_mutex;
QemuMutex queued_requests_lock; /* protects queued_requests */
QemuMutex ram_block_discard_disable_mutex;
QemuMutex rcu_registry_lock;
QemuMutex rcu_sync_lock;
QemuMutex readdir_mutex_L;
QemuMutex reqs_lock;
QemuMutex requests_lock;
QemuMutex rp_mutex;    /* We send replies from multiple threads */
QemuMutex rsp_mutex;
QemuMutex rx_queue_lock;
QemuMutex sigbus_mutex;
QemuMutex sint_routes_mutex;
QemuMutex src_page_req_mutex;
QemuMutex start_lock;
QemuMutex target_fd_trans_lock;
QemuMutex thr_mutex;
QemuMutex thread_lock;
QemuMutex vdev_mutex;
QemuMutex vmstop_lock;
QemuMutex vreader_mutex; /* and guest_apdu_list mutex */
QemuMutex work_mutex;
QemuMutex xen_timers_lock;
QemuMutex yank_lock;
QemuSemaphore channels_ready;
QemuSemaphore colo_exit_sem;
QemuSemaphore colo_incoming_sem;
QemuSemaphore init_done_sem; /* is thread init done? */
QemuSemaphore pause_sem;
QemuSemaphore postcopy_pause_sem;
QemuSemaphore postcopy_pause_sem_dst;
QemuSemaphore postcopy_pause_sem_fast_load;
QemuSemaphore postcopy_pause_sem_fault;
QemuSemaphore postcopy_qemufile_dst_done;
QemuSemaphore postcopy_qemufile_src_sem;
QemuSemaphore rate_limit_sem;
QemuSemaphore rp_pong_acks;
QemuSemaphore rp_sem;
QemuSemaphore sem;
QemuSemaphore sem_sync;
QemuSemaphore sem_thread;
QemuSemaphore wait_unplug_sem;

So:
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


