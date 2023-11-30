Return-Path: <kvm+bounces-2915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 03C807FF04F
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:38:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 89A6CB20F5F
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 13:38:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8386A482C6;
	Thu, 30 Nov 2023 13:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2a07:de40:b251:101:10:150:64:1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFFCC4
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 05:38:01 -0800 (PST)
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E4E1521AF3;
	Thu, 30 Nov 2023 13:37:59 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 95AC413AB1;
	Thu, 30 Nov 2023 13:37:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id omWqITeQaGXJQgAAD6G6ig
	(envelope-from <cfontana@suse.de>); Thu, 30 Nov 2023 13:37:59 +0000
Message-ID: <96479d73-b5b0-68da-4ce9-65bbadb0bc56@suse.de>
Date: Thu, 30 Nov 2023 14:37:55 +0100
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
 <3d8bbcc9-89fb-5631-b109-24a9d08da1f5@suse.de>
 <73ca9d6c-62d4-412a-b847-f2c421887e96@linaro.org>
From: Claudio Fontana <cfontana@suse.de>
In-Reply-To: <73ca9d6c-62d4-412a-b847-f2c421887e96@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
Authentication-Results: smtp-out1.suse.de;
	dkim=none;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=suse.de (policy=none);
	spf=softfail (smtp-out1.suse.de: 2a07:de40:b281:104:10:150:64:97 is neither permitted nor denied by domain of cfontana@suse.de) smtp.mailfrom=cfontana@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [6.98 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 MIME_GOOD(-0.10)[text/plain];
	 R_SPF_SOFTFAIL(4.60)[~all:c];
	 RCPT_COUNT_FIVE(0.00)[6];
	 RCVD_COUNT_THREE(0.00)[3];
	 DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 MX_GOOD(-0.01)[];
	 NEURAL_SPAM_LONG(3.19)[0.911];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 R_DKIM_NA(2.20)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[];
	 DMARC_POLICY_SOFTFAIL(0.10)[suse.de : No valid SPF, No valid DKIM,none]
X-Spam-Score: 6.98
X-Rspamd-Queue-Id: E4E1521AF3

On 11/30/23 14:31, Philippe Mathieu-Daudé wrote:
> Hi Claudio,
> 
> On 30/11/23 13:48, Claudio Fontana wrote:
>> Hi Philippe,
>>
>> took a quick look with
>>
>> grep -R can_do_io
>>
>> and this seems to be in include/hw/core/cpu.h as well as cpu-common.c,
>>
>> maybe there is more meat to address to fully solve this?
>>
>> Before we had stuff for reset in cpu-common.c under a
>> if (tcg_enabled()) {
>> }
>>
>> but now we have cpu_exec_reset_hold(),
>> should the implementation for tcg of cpu_exec_reset_hold() do that (and potentially other tcg-specific non-arch-specific cpu variables we might need)?
> 
> Later we eventually get there:
> 
> diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
> index 9b038b1af5..e2c5cf97dc 100644
> --- a/accel/tcg/tcg-accel-ops.c
> +++ b/accel/tcg/tcg-accel-ops.c
> @@ -89,6 +89,9 @@ static void tcg_cpu_reset_hold(CPUState *cpu)
> 
>       cpu->accel->icount_extra = 0;
>       cpu->accel->mem_io_pc = 0;
> +
> +    qatomic_set(&cpu->neg.icount_decr.u32, 0);
> +    cpu->neg.can_do_io = true;
>   }
> 
> My branch is huge, I'm trying to split it, maybe I shouldn't have
> sent this single non-TCG patch out of it. I'll Cc you.

Thanks and congrats for the rework effort there!

Ciao,

Claudio

> 
>> If can_do_io is TCG-specific, maybe the whole field existence / visibility can be conditioned on TCG actually being at least compiled-in?
>> This might help find problems of the field being used in the wrong context, by virtue of getting an error when compiling with --disable-tcg for example.
>>
>> Ciao,
>>
>> Claudio
> 


