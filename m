Return-Path: <kvm+bounces-23641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C93C94C2D6
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 18:37:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D37F1C221D3
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 16:37:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72C6618FC9C;
	Thu,  8 Aug 2024 16:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jbbSxESm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="EhqEGc1n";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jbbSxESm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="EhqEGc1n"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2ADF12FB0A
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 16:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723135070; cv=none; b=mLyWh/1i5Fc2sSv2sQMMphmL8IUhXfYHhMck3QtF9Gd719qImMW/yat+XMT3IfSxu/ITeHd9DjRXvroWg26qD31orWmq2P2o+XYRGQwUuqZILL97NUSP1AEWfShGMdUCQVyQE+hhHLdON0YdXnzqOCZKh7+b2haf0fSi1da6tSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723135070; c=relaxed/simple;
	bh=NUrB6sJ73kiOk5iF0dfbIq5VtRKVr5MwvPrr0T4uMM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O0Rgob+tZexjzDHDkHXjr2Y+VWLQp2/uo3p5N+Oyumfnf/A1dEVbpJ0ds/7XGgtka7EDAHTK8AZJC2geLVYKyL4mZp7OoHGRbk9kzKyHdeJdDMHjWbdIj02FNLya3UfGSqty4ERQTIYgZA8HM+J7B99StKnH8LCmWZCLbjjqwQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jbbSxESm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=EhqEGc1n; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jbbSxESm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=EhqEGc1n; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 20B7B21D34;
	Thu,  8 Aug 2024 16:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723135067; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FT6POBvoe+yceWz2dTOKo85Viu9VOo9r/g2Kos0kDdI=;
	b=jbbSxESmx7Dph6AXufN+jgTTbBSkt5d0dMyKbXVAcx04p+vh7JX1/g5ayz2QJhtI/DsHla
	L2nBJ9FnTWTEPhhifZrednIBYgLLi9/oxIgw05kv06HrTxuXa0IxAZT6zwdJb6Uo/Om+3E
	+V0BkClbhvAgdowjI6rE/6jw8NDWTSs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723135067;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FT6POBvoe+yceWz2dTOKo85Viu9VOo9r/g2Kos0kDdI=;
	b=EhqEGc1n9UhPT747OUq3VGiibPinN/b9RWZiJzSMj3CaK+WezjB2u52Z/rjUY+p3lta+7H
	DwGiOvHLVqoUn4AQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723135067; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FT6POBvoe+yceWz2dTOKo85Viu9VOo9r/g2Kos0kDdI=;
	b=jbbSxESmx7Dph6AXufN+jgTTbBSkt5d0dMyKbXVAcx04p+vh7JX1/g5ayz2QJhtI/DsHla
	L2nBJ9FnTWTEPhhifZrednIBYgLLi9/oxIgw05kv06HrTxuXa0IxAZT6zwdJb6Uo/Om+3E
	+V0BkClbhvAgdowjI6rE/6jw8NDWTSs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723135067;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FT6POBvoe+yceWz2dTOKo85Viu9VOo9r/g2Kos0kDdI=;
	b=EhqEGc1n9UhPT747OUq3VGiibPinN/b9RWZiJzSMj3CaK+WezjB2u52Z/rjUY+p3lta+7H
	DwGiOvHLVqoUn4AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E3CA313BAF;
	Thu,  8 Aug 2024 12:58:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id B6yrMwXBtGZsZwAAD6G6ig
	(envelope-from <cfontana@suse.de>); Thu, 08 Aug 2024 12:58:45 +0000
Message-ID: <34b23dba-52ef-400b-a876-47bafc8989ce@suse.de>
Date: Thu, 8 Aug 2024 14:58:41 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] kvm: refactor core virtual machine creation into its
 own function
To: Ani Sinha <anisinha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: zhao1.liu@intel.com, kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20240808113838.1697366-1-anisinha@redhat.com>
Content-Language: en-US
From: Claudio Fontana <cfontana@suse.de>
In-Reply-To: <20240808113838.1697366-1-anisinha@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-1.29 / 50.00];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,intel.com:email];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -1.29

Hello,

as a suggestion you could adjust the names of the functions to match the existing pattern in this module.

It is modulename_method ie kvm_* , so:

On 8/8/24 13:38, Ani Sinha wrote:
> Refactoring the core logic around KVM_CREATE_VM into its own separate function
> so that it can be called from other functions in subsequent patches. There is
> no functional change in this patch.
> 
> CC: pbonzini@redhat.com
> CC: zhao1.liu@intel.com
> Signed-off-by: Ani Sinha <anisinha@redhat.com>
> ---
>  accel/kvm/kvm-all.c | 93 +++++++++++++++++++++++++++------------------
>  1 file changed, 56 insertions(+), 37 deletions(-)
> 
> changelog:
> v2: s/fprintf/warn_report as suggested by zhao
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 75d11a07b2..c2e177c39f 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2385,6 +2385,60 @@ uint32_t kvm_dirty_ring_size(void)
>      return kvm_state->kvm_dirty_ring_size;
>  }
>  
> +static int do_kvm_create_vm(MachineState *ms, int type)

kvm_do_create_vm()

btw does the "_do_" part add anything of value? Otherwise I would do:

kvm_create_vm()



> +{
> +    KVMState *s;
> +    int ret;
> +
> +    s = KVM_STATE(ms->accelerator);
> +
> +    do {
> +        ret = kvm_ioctl(s, KVM_CREATE_VM, type);
> +    } while (ret == -EINTR);
> +
> +    if (ret < 0) {
> +        warn_report("ioctl(KVM_CREATE_VM) failed: %d %s", -ret,
> +                    strerror(-ret));
> +
> +#ifdef TARGET_S390X
> +        if (ret == -EINVAL) {
> +            warn_report("Host kernel setup problem detected. Please verify:");
> +            warn_report("- for kernels supporting the switch_amode or"
> +                        " user_mode parameters, whether");
> +            warn_report("  user space is running in primary address space");
> +            warn_report("- for kernels supporting the vm.allocate_pgste "
> +                        "sysctl, whether it is enabled");
> +        }
> +#elif defined(TARGET_PPC)
> +        if (ret == -EINVAL) {
> +            warn_report("PPC KVM module is not loaded. Try modprobe kvm_%s.",
> +                        (type == 2) ? "pr" : "hv");
> +        }
> +#endif
> +    }
> +
> +    return ret;
> +}
> +
> +static int find_kvm_machine_type(MachineState *ms)

kvm_find_machine_type

Thanks,

C

> +{
> +    MachineClass *mc = MACHINE_GET_CLASS(ms);
> +    int type;
> +
> +    if (object_property_find(OBJECT(current_machine), "kvm-type")) {
> +        g_autofree char *kvm_type;
> +        kvm_type = object_property_get_str(OBJECT(current_machine),
> +                                           "kvm-type",
> +                                           &error_abort);
> +        type = mc->kvm_type(ms, kvm_type);
> +    } else if (mc->kvm_type) {
> +        type = mc->kvm_type(ms, NULL);
> +    } else {
> +        type = kvm_arch_get_default_type(ms);
> +    }
> +    return type;
> +}
> +
>  static int kvm_init(MachineState *ms)
>  {
>      MachineClass *mc = MACHINE_GET_CLASS(ms);
> @@ -2467,49 +2521,14 @@ static int kvm_init(MachineState *ms)
>      }
>      s->as = g_new0(struct KVMAs, s->nr_as);
>  
> -    if (object_property_find(OBJECT(current_machine), "kvm-type")) {
> -        g_autofree char *kvm_type = object_property_get_str(OBJECT(current_machine),
> -                                                            "kvm-type",
> -                                                            &error_abort);
> -        type = mc->kvm_type(ms, kvm_type);
> -    } else if (mc->kvm_type) {
> -        type = mc->kvm_type(ms, NULL);
> -    } else {
> -        type = kvm_arch_get_default_type(ms);
> -    }
> -
> +    type = find_kvm_machine_type(ms);
>      if (type < 0) {
>          ret = -EINVAL;
>          goto err;
>      }
>  
> -    do {
> -        ret = kvm_ioctl(s, KVM_CREATE_VM, type);
> -    } while (ret == -EINTR);
> -
> +    ret = do_kvm_create_vm(ms, type);
>      if (ret < 0) {
> -        fprintf(stderr, "ioctl(KVM_CREATE_VM) failed: %d %s\n", -ret,
> -                strerror(-ret));
> -
> -#ifdef TARGET_S390X
> -        if (ret == -EINVAL) {
> -            fprintf(stderr,
> -                    "Host kernel setup problem detected. Please verify:\n");
> -            fprintf(stderr, "- for kernels supporting the switch_amode or"
> -                    " user_mode parameters, whether\n");
> -            fprintf(stderr,
> -                    "  user space is running in primary address space\n");
> -            fprintf(stderr,
> -                    "- for kernels supporting the vm.allocate_pgste sysctl, "
> -                    "whether it is enabled\n");
> -        }
> -#elif defined(TARGET_PPC)
> -        if (ret == -EINVAL) {
> -            fprintf(stderr,
> -                    "PPC KVM module is not loaded. Try modprobe kvm_%s.\n",
> -                    (type == 2) ? "pr" : "hv");
> -        }
> -#endif
>          goto err;
>      }
>  


