Return-Path: <kvm+bounces-2004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C30B7F011C
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 17:24:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AAF591F22EFB
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 16:24:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D6C01A72F;
	Sat, 18 Nov 2023 16:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F46C5;
	Sat, 18 Nov 2023 08:23:32 -0800 (PST)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1cf52e5e07eso2356725ad.0;
        Sat, 18 Nov 2023 08:23:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700324612; x=1700929412;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2erzZFOyxOrSdjM/KpGdx3oacnKwVcss5FA960Pxu5w=;
        b=fYqqCdMKOD5hcFS+Pcb3HrknnLjiaxbOO5e4YVeP4FvvFzmD68K0T/fVY5rqvkB/z1
         8K0Ez2Sap8pkqkVUaJhQkP4xz1r4DGnwtXtmM5hVyUI02rapghbUrXG3HdWrVXk3VQNg
         vN9dcZycZJACeTuGiw9LY/RN74GwRadhRZGRX+feZunbiVY06owKpBy0NDpqh1cvH3sX
         +dybOGVGL++XVvQ4LS3GPJMBHWbN/Bqi0GjqSZ22idjdggvGVqIsFQPt5k93I2HbTqJR
         u7lLYaTbIohcO9sSRcALX6J7CTIYxnWZ/QI5zVmJU99Kji/Q4/EHzh3yijGQVY9oiQev
         WYPQ==
X-Gm-Message-State: AOJu0YxqrpdyoiEsZK64HSkNuYVjWMly5Z6GlC6YjejWvfM9OnqKsy+l
	Ca/aK/JyHgxk/FKsDuHdxBY=
X-Google-Smtp-Source: AGHT+IFxNCOe1hV/UN7ql6AF5ylF4cLl3KjxD1pwBtnSiRvXE7Ae8L1R6+CdLXdA7EoHYLiLeUL3Gw==
X-Received: by 2002:a17:902:6844:b0:1cf:5197:25ac with SMTP id f4-20020a170902684400b001cf519725acmr2006009pln.12.1700324611982;
        Sat, 18 Nov 2023 08:23:31 -0800 (PST)
Received: from ?IPV6:2601:647:4d7e:54f3:667:4981:ffa1:7be1? ([2601:647:4d7e:54f3:667:4981:ffa1:7be1])
        by smtp.gmail.com with ESMTPSA id u18-20020a170902e81200b001ce64bdfa19sm2051042plg.45.2023.11.18.08.23.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Nov 2023 08:23:31 -0800 (PST)
Message-ID: <91a32cd2-903a-43df-8067-510c6c431ec7@acm.org>
Date: Sat, 18 Nov 2023 08:23:20 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/34] lib/find: add atomic find_bit() primitives
Content-Language: en-US
To: Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Akinobu Mita <akinobu.mita@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Andersson <andersson@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Chaitanya Kulkarni <kch@nvidia.com>, Christian Brauner <brauner@kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, David Disseldorp <ddiss@suse.de>,
 Edward Cree <ecree.xilinx@gmail.com>, Eric Dumazet <edumazet@google.com>,
 Fenghua Yu <fenghua.yu@intel.com>, Geert Uytterhoeven
 <geert@linux-m68k.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Gregory Greenman <gregory.greenman@intel.com>,
 Hans Verkuil <hverkuil@xs4all.nl>, Hans de Goede <hdegoede@redhat.com>,
 Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>,
 Jakub Kicinski <kuba@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
 Jiri Pirko <jiri@resnulli.us>, Jiri Slaby <jirislaby@kernel.org>,
 Kalle Valo <kvalo@kernel.org>, Karsten Graul <kgraul@linux.ibm.com>,
 Karsten Keil <isdn@linux-pingi.de>, Kees Cook <keescook@chromium.org>,
 Leon Romanovsky <leon@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Martin Habets <habetsm.xilinx@gmail.com>,
 Mauro Carvalho Chehab <mchehab@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Simek <monstr@monstr.eu>,
 Nicholas Piggin <npiggin@gmail.com>, Oliver Neukum <oneukum@suse.com>,
 Paolo Abeni <pabeni@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ping-Ke Shih <pkshih@realtek.com>,
 Rich Felker <dalias@libc.org>, Rob Herring <robh@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Sean Christopherson <seanjc@google.com>,
 Shuai Xue <xueshuai@linux.alibaba.com>, Stanislaw Gruszka <stf_xl@wp.pl>,
 Steven Rostedt <rostedt@goodmis.org>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Thomas Gleixner <tglx@linutronix.de>,
 Valentin Schneider <vschneid@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Wenjia Zhang <wenjia@linux.ibm.com>,
 Will Deacon <will@kernel.org>, Yoshinori Sato <ysato@users.sourceforge.jp>,
 GR-QLogic-Storage-Upstream@marvell.com, alsa-devel@alsa-project.org,
 ath10k@lists.infradead.org, dmaengine@vger.kernel.org,
 iommu@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-media@vger.kernel.org, linux-mips@vger.kernel.org,
 linux-net-drivers@amd.com, linux-pci@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
 linux-sh@vger.kernel.org, linux-sound@vger.kernel.org,
 linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, mpi3mr-linuxdrv.pdl@broadcom.com,
 netdev@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org
Cc: Jan Kara <jack@suse.cz>, Mirsad Todorovac
 <mirsad.todorovac@alu.unizg.hr>, Matthew Wilcox <willy@infradead.org>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Maxim Kuvyrkov <maxim.kuvyrkov@linaro.org>,
 Alexey Klimov <klimov.linux@gmail.com>
References: <20231118155105.25678-1-yury.norov@gmail.com>
 <20231118155105.25678-2-yury.norov@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231118155105.25678-2-yury.norov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/23 07:50, Yury Norov wrote:
> Add helpers around test_and_{set,clear}_bit() that allow to search for
> clear or set bits and flip them atomically.

Has it been considered to add kunit tests for the new functions?

Thanks,

Bart.


