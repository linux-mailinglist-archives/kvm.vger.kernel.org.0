Return-Path: <kvm+bounces-2919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7560F7FF0AE
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:50:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EB9D282229
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 13:50:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A836482F3;
	Thu, 30 Nov 2023 13:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YuoFnwL6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D44610F9
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 05:49:57 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-32f8441dfb5so659390f8f.0
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 05:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701352196; x=1701956996; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MzXC86kI/230MRmOExolGBgQpce+zyW7qougvXLVSk8=;
        b=YuoFnwL6x3mNtlIfSODzX6kXM5QCR/zU9MR8YahdYPyIJ7vNSVyH5YswfH4rJqbN9r
         B3bVK5H5k/2qLmM84Nrs6xnB4EzyjDx2Odi9prcMJ1RNPtRzYxhUmVqEyanbgxHvDM7G
         dWaZ89eVc1wgWmjCYMESz3trCnCn0D5Tc7KaY03GZCJHkjcbMYllZhMhc8G0MA3LEwia
         /oH0uqoMpVpWTHngpVD19mbU/u7hIwlrEVxjRQAI1L0k/k6WJl1gzlYrKJoYLfDx7sHL
         HyqXUViK6Gih+f2lIZ2MOUoaTem7qx3hI76V1y5rx6L8p+ZmWxPx6N9JzyGJEjlGHMLF
         JBfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701352196; x=1701956996;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MzXC86kI/230MRmOExolGBgQpce+zyW7qougvXLVSk8=;
        b=ausHd32QhjkgVnUf2agEwvPY2qdRdsK9VSlegzBPIdqMW7FtsKMm+fZ7LqEdL+NEs+
         VbfBaje3Qr4AlZhxwP+430eYafMBqySHggDN+x0ENmE+M9Qsf2KCVqQPyA1jzQFi+fT9
         Sq9qwunh1z82d7Jat/E01ASnHQnAJdl14OpNnYZIqeYi0xAFOquz6j1NiB5n/FKLQdYm
         OZvItJEUuJXgN44pm5CnRx+S1KuZVvvHFX7hhuTAC4qeGRQpo0lF6bRxd5lFVY6Y16oa
         iUixWgNiNrHVz/xT4Fz0d3n800ads7XCvBvO+mgedMzao8AFmu/H9kbtb4HwDeURtCl7
         hhyg==
X-Gm-Message-State: AOJu0YxryVin3b75mrfU9cPTCLlX29aDCTB9r7ulV3PkZP9y9ftbmgko
	D4dTV7ZNWm4H/ZHWXCwmKND1HQ==
X-Google-Smtp-Source: AGHT+IGEZM/F60lbKf+pyOaxLGJZDqngSEf0GXts+oJS0AF+AGOPuKqrMqfmt5a2LHBk+wqKglvvAA==
X-Received: by 2002:adf:f588:0:b0:332:eb19:9530 with SMTP id f8-20020adff588000000b00332eb199530mr14573473wro.32.1701352195915;
        Thu, 30 Nov 2023 05:49:55 -0800 (PST)
Received: from [192.168.69.100] (sev93-h02-176-184-17-116.dsl.sta.abo.bbox.fr. [176.184.17.116])
        by smtp.gmail.com with ESMTPSA id h1-20020adfe981000000b00332f6202b82sm1595392wrm.9.2023.11.30.05.49.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Nov 2023 05:49:55 -0800 (PST)
Message-ID: <fcaff24d-0ced-4547-898f-a9b8bf49be45@linaro.org>
Date: Thu, 30 Nov 2023 14:49:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] Rename "QEMU global mutex" to "BQL" in comments and
 docs
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
 <20231129212625.1051502-7-stefanha@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20231129212625.1051502-7-stefanha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 29/11/23 22:26, Stefan Hajnoczi wrote:
> The term "QEMU global mutex" is identical to the more widely used Big
> QEMU Lock ("BQL"). Update the code comments and documentation to use
> "BQL" instead of "QEMU global mutex".
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>   docs/devel/multi-thread-tcg.rst   |  7 +++----
>   docs/devel/qapi-code-gen.rst      |  2 +-
>   docs/devel/replay.rst             |  2 +-
>   docs/devel/multiple-iothreads.txt | 16 ++++++++--------
>   include/block/blockjob.h          |  6 +++---
>   include/io/task.h                 |  2 +-
>   include/qemu/coroutine-core.h     |  2 +-
>   include/qemu/coroutine.h          |  2 +-
>   hw/block/dataplane/virtio-blk.c   |  8 ++++----
>   hw/block/virtio-blk.c             |  2 +-
>   hw/scsi/virtio-scsi-dataplane.c   |  6 +++---
>   net/tap.c                         |  2 +-
>   12 files changed, 28 insertions(+), 29 deletions(-)


> diff --git a/include/block/blockjob.h b/include/block/blockjob.h
> index e594c10d23..b2bc7c04d6 100644
> --- a/include/block/blockjob.h
> +++ b/include/block/blockjob.h
> @@ -54,7 +54,7 @@ typedef struct BlockJob {
>   
>       /**
>        * Speed that was set with @block_job_set_speed.
> -     * Always modified and read under QEMU global mutex (GLOBAL_STATE_CODE).
> +     * Always modified and read under BQL (GLOBAL_STATE_CODE).

"under the BQL"

>        */
>       int64_t speed;
>   
> @@ -66,7 +66,7 @@ typedef struct BlockJob {
>   
>       /**
>        * Block other operations when block job is running.
> -     * Always modified and read under QEMU global mutex (GLOBAL_STATE_CODE).
> +     * Always modified and read under BQL (GLOBAL_STATE_CODE).

Ditto,

>        */
>       Error *blocker;
>   
> @@ -89,7 +89,7 @@ typedef struct BlockJob {
>   
>       /**
>        * BlockDriverStates that are involved in this block job.
> -     * Always modified and read under QEMU global mutex (GLOBAL_STATE_CODE).
> +     * Always modified and read under BQL (GLOBAL_STATE_CODE).

Ditto.

>        */
>       GSList *nodes;
>   } BlockJob;

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


