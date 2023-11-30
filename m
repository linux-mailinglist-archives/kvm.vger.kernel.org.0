Return-Path: <kvm+bounces-2900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 734487FEF7D
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 13:48:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71AF61C20A67
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 12:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7682C30D13;
	Thu, 30 Nov 2023 12:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="C/sVKUTS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="e/lvIcPc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B160ED7F
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 04:48:21 -0800 (PST)
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 10C811FCE6;
	Thu, 30 Nov 2023 12:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1701348500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RTuA0vwRJM61+hvnoP8MdxxsojJVxdHRURHd6eKRNXI=;
	b=C/sVKUTSkov48n4XmsDwYxa5K9R2+3uy4IskBU8i++S79PqU/4AbI4gLWA7qvXW8YuWKFQ
	XVAEqmUIsd2sHw6Xj8L1S9fP1iFVe4JDMW6EIi8ZTJFdcnxkhH2VI6ZjFGVUwpMErVs2c1
	m5gLmiRh2v7cnI/gg9kGFajQq1czCXk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1701348500;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RTuA0vwRJM61+hvnoP8MdxxsojJVxdHRURHd6eKRNXI=;
	b=e/lvIcPcjWHPbX/O4yoyyVvQtXxhaYi6ps20QsMhuBJbQ8LwDFOm+7MW7PbAOIZl5xMzoY
	cJIQ86PSkMkNj/Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A850B1342E;
	Thu, 30 Nov 2023 12:48:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hyj7JZOEaGWzNQAAD6G6ig
	(envelope-from <cfontana@suse.de>); Thu, 30 Nov 2023 12:48:19 +0000
Message-ID: <3d8bbcc9-89fb-5631-b109-24a9d08da1f5@suse.de>
Date: Thu, 30 Nov 2023 13:48:19 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] accel: Do not set CPUState::can_do_io in non-TCG accels
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Cameron Esfahani <dirty@apple.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, kvm@vger.kernel.org
References: <20231129205037.16849-1-philmd@linaro.org>
From: Claudio Fontana <cfontana@suse.de>
In-Reply-To: <20231129205037.16849-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -4.10
X-Spamd-Result: default: False [-4.10 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 RCPT_COUNT_FIVE(0.00)[6];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]

Hi Philippe,

took a quick look with 

grep -R can_do_io

and this seems to be in include/hw/core/cpu.h as well as cpu-common.c,

maybe there is more meat to address to fully solve this?

Before we had stuff for reset in cpu-common.c under a
if (tcg_enabled()) {
}

but now we have cpu_exec_reset_hold(),
should the implementation for tcg of cpu_exec_reset_hold() do that (and potentially other tcg-specific non-arch-specific cpu variables we might need)?

If can_do_io is TCG-specific, maybe the whole field existence / visibility can be conditioned on TCG actually being at least compiled-in?
This might help find problems of the field being used in the wrong context, by virtue of getting an error when compiling with --disable-tcg for example.

Ciao,

Claudio


On 11/29/23 21:50, Philippe Mathieu-Daudé wrote:
> 'can_do_io' is specific to TCG. Having it set in non-TCG
> code is confusing, so remove it from QTest / HVF / KVM.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  accel/dummy-cpus.c        | 1 -
>  accel/hvf/hvf-accel-ops.c | 1 -
>  accel/kvm/kvm-accel-ops.c | 1 -
>  3 files changed, 3 deletions(-)
> 
> diff --git a/accel/dummy-cpus.c b/accel/dummy-cpus.c
> index b75c919ac3..1005ec6f56 100644
> --- a/accel/dummy-cpus.c
> +++ b/accel/dummy-cpus.c
> @@ -27,7 +27,6 @@ static void *dummy_cpu_thread_fn(void *arg)
>      qemu_mutex_lock_iothread();
>      qemu_thread_get_self(cpu->thread);
>      cpu->thread_id = qemu_get_thread_id();
> -    cpu->neg.can_do_io = true;
>      current_cpu = cpu;
>  
>  #ifndef _WIN32
> diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
> index abe7adf7ee..2bba54cf70 100644
> --- a/accel/hvf/hvf-accel-ops.c
> +++ b/accel/hvf/hvf-accel-ops.c
> @@ -428,7 +428,6 @@ static void *hvf_cpu_thread_fn(void *arg)
>      qemu_thread_get_self(cpu->thread);
>  
>      cpu->thread_id = qemu_get_thread_id();
> -    cpu->neg.can_do_io = true;
>      current_cpu = cpu;
>  
>      hvf_init_vcpu(cpu);
> diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
> index 6195150a0b..f273f415db 100644
> --- a/accel/kvm/kvm-accel-ops.c
> +++ b/accel/kvm/kvm-accel-ops.c
> @@ -36,7 +36,6 @@ static void *kvm_vcpu_thread_fn(void *arg)
>      qemu_mutex_lock_iothread();
>      qemu_thread_get_self(cpu->thread);
>      cpu->thread_id = qemu_get_thread_id();
> -    cpu->neg.can_do_io = true;
>      current_cpu = cpu;
>  
>      r = kvm_init_vcpu(cpu, &error_fatal);


