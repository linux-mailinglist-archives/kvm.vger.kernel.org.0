Return-Path: <kvm+bounces-71341-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oOqcFGTblmlJpgIAu9opvQ
	(envelope-from <kvm+bounces-71341-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 10:44:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AB5EA15D78B
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 10:44:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C37043069AEE
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 09:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEB7832BF42;
	Thu, 19 Feb 2026 09:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lxl9CD+r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE494328B7C
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 09:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771493988; cv=none; b=M6suAUs3YaLun4b5EH6WcLsnDHa9Fa0RB5fDxGrgLDBnSWmU1ePo4xboI6tpiLttLOza1MgYicYhZADBMmJ40O11iLSQrif7fsKXeR+FCs33NSxYfDzpfqQN8u6gLcieO9l3vL0lZIwyArDX0Je62aJiiU+HbBrq8insfZl4urA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771493988; c=relaxed/simple;
	bh=IE1T+RHVCqmPFncrXfUxNPRTfaJLMSqDtdIAZNSPjmA=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=MV8jI70vexa7JjvkGe1Q946z9d5uotT/vg0/QP0Dmv/0uwRt54tB3wJLW7c9AMYObgkwI3yvTvqVTJfeGEXWvDfzI8ZwfY1VLX8ceP0qRqtcLJ8Il83OOJe0C1SaAsuQBz0/UNGd3G2A3jC4kmvOx6nknaZcTw/SNRQTZ1rPROc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lxl9CD+r; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4833115090dso7121025e9.3
        for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 01:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771493985; x=1772098785; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0Qwt8Tz8tB4Obh3dtJ6HDehOvnoNxAwIhhD+tN8oggA=;
        b=Lxl9CD+rhrD0zYj8N0WiI39dKi3SvHDegYx72GZH26w+Mq4uVBCasOPhoGKzWDHguw
         3FkKqGeDeQX/NpuKrtwNsn34PnwK7n6vNmLXMrlo+V5A3jv9HtVn8NsNP4ZGNtmbc9uN
         ApzsvfxjE1MNPe5KEjgFd7LPLaTaWu8jsLXoKc8uUW0x7qWW9X8tnsnPEvRPFA/DxllT
         E2TJZiKDujebhUPigZeMqtLhlUd5SIPyPJUv92A7Xg4luwSj7nt+p+083d6Fbvh9cNeQ
         tGiUCoKRVNFpPcmbhbLsyLR5r5qjnforovXuQ0yUTklk/IWkPC5t5PFmnolJw3MafH0q
         6CLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771493985; x=1772098785;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Qwt8Tz8tB4Obh3dtJ6HDehOvnoNxAwIhhD+tN8oggA=;
        b=OK5UBQg8OB7ddVT7sNbYO53Q/OP7gx/FJCnzDE1bbZn8NMNilsu8cJ/7fzJFtZkB4r
         MPtVaL0qWvh8M7LulhS7EQ14t0Rp3s1Aj0x23H5ryp33Uz2e8bS/ioy5gIEnva7c/82v
         z+MTC+o+9JtIi/X4TubYV6kHYF3ha5Vilf2Te54ALOwzolSqVYsetY8mnTqlHysiPJ37
         6zQufFsPpTNQKkPW7oJyKdRb/UXr7YZfRAvzdtYshJT77VHwB4NHlaI514saVyMGqlee
         L9wFWnhZ0QL5svtXnLW1e6N71fs2bzG3u8ZSAOUQrphtcbJMkjjyZ0kFBgWOfUKpBpxT
         TEbA==
X-Forwarded-Encrypted: i=1; AJvYcCUmZsS8vBGwSJjv7QNyuJNvCEXSHH4LVTDrkr2WrZ8A8VFS0MBOCJch5VBkSQOZH0xoglU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvSpSMQFO86FoeZpmig0XKgrmNKe3EQZWZZW3FeBelEsemIVZf
	d1uLnm0kIUa/ijZ9UXrdCgi6PAWOIeCO4615nQk7hulRxuPW502OeFHE
X-Gm-Gg: AZuq6aKvoHw6Q6EptBNI5vdvLHbiNBr6Zybu4HCyZ+eCIIMWvYw5Owa++p1+Jqqd0Fk
	pULAdSO6v3eo3vmWFboZSp3vKDR4x4e0so4pbMr1+yLqbp3swUKVxPBzOglSqOpWR/RVzo/Iayj
	H+dhBe4ZADtxXidOYTEbZd7txYJNPUpOgeXwnvK96Sw/nJTecwtVQ2siDXdDN5G7YoNfsaRaBCF
	srCBgBvvOtC+jjQcUfGKEVvOygUoQbWq89GCv/7bHYZTUlyS9lpNuvuRd+xnQuZDCFrWbvz/nyg
	tR8tRklK2qDCrEidPj91S5CEbYRKhfHVS29g3Jgsy090KwVy36UUp15QEGICwhRMsuIFBTv8+vc
	1ky1XPBKzUqCcHqklROwxgxmeMTXfaCTUCT04EhiJxSpEhGndekaW68fFRQxCpcBKc+TrScHWgH
	b3LWM9ZWqEG1Mgr/4UU/XNpKEcSLTFqg==
X-Received: by 2002:a05:600c:3e14:b0:47a:935f:61a0 with SMTP id 5b1f17b1804b1-483989ca52emr75382465e9.0.1771493984819;
        Thu, 19 Feb 2026 01:39:44 -0800 (PST)
Received: from [10.24.66.212] ([15.248.2.236])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4837a5d562esm336851535e9.15.2026.02.19.01.39.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Feb 2026 01:39:44 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <3b4b7b7b-7fcd-46ce-bdcb-cd1a30cf5276@xen.org>
Date: Thu, 19 Feb 2026 09:39:43 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 27/34] kvm/xen-emu: re-initialize capabilities during
 confidential guest reset
To: Ani Sinha <anisinha@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kraxel@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20260218114233.266178-1-anisinha@redhat.com>
 <20260218114233.266178-28-anisinha@redhat.com>
Content-Language: en-US
In-Reply-To: <20260218114233.266178-28-anisinha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71341-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xadimgnik@gmail.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[xen.org:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AB5EA15D78B
X-Rspamd-Action: no action

On 18/02/2026 11:42, Ani Sinha wrote:
> On confidential guests KVM virtual machine file descriptor changes as a
> part of the guest reset process. Xen capabilities needs to be re-initialized in
> KVM against the new file descriptor.
> 
> Signed-off-by: Ani Sinha <anisinha@redhat.com>
> ---
>   target/i386/kvm/xen-emu.c | 50 +++++++++++++++++++++++++++++++++++++--
>   1 file changed, 48 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
> index 52de019834..69527145eb 100644
> --- a/target/i386/kvm/xen-emu.c
> +++ b/target/i386/kvm/xen-emu.c
> @@ -44,9 +44,12 @@
>   
>   #include "xen-compat.h"
>   
> +NotifierWithReturn xen_vmfd_change_notifier;
> +static bool hyperv_enabled;
>   static void xen_vcpu_singleshot_timer_event(void *opaque);
>   static void xen_vcpu_periodic_timer_event(void *opaque);
>   static int vcpuop_stop_singleshot_timer(CPUState *cs);
> +static int do_initialize_xen_caps(KVMState *s, uint32_t hypercall_msr);
>   
>   #ifdef TARGET_X86_64
>   #define hypercall_compat32(longmode) (!(longmode))
> @@ -54,6 +57,30 @@ static int vcpuop_stop_singleshot_timer(CPUState *cs);
>   #define hypercall_compat32(longmode) (false)
>   #endif
>   
> +static int xen_handle_vmfd_change(NotifierWithReturn *n,
> +                                  void *data, Error** errp)
> +{
> +    int ret;
> +
> +    /* we are not interested in pre vmfd change notification */
> +    if (((VmfdChangeNotifier *)data)->pre) {
> +        return 0;
> +    }
> +
> +    ret = do_initialize_xen_caps(kvm_state, XEN_HYPERCALL_MSR);
> +    if (ret < 0) {
> +        return ret;
> +    }
> +
> +    if (hyperv_enabled) {
> +        ret = do_initialize_xen_caps(kvm_state, XEN_HYPERCALL_MSR_HYPERV);
> +        if (ret < 0) {
> +            return ret;
> +        }
> +    }
> +    return 0;

This seems odd. Why use the hyperv_enabled boolean, rather than simply 
the msr value, since when hyperv_enabled is set you will be calling 
do_initialize_xen_caps() twice.

> +}
> +
>   static bool kvm_gva_to_gpa(CPUState *cs, uint64_t gva, uint64_t *gpa,
>                              size_t *len, bool is_write)
>   {
> @@ -111,15 +138,16 @@ static inline int kvm_copy_to_gva(CPUState *cs, uint64_t gva, void *buf,
>       return kvm_gva_rw(cs, gva, buf, sz, true);
>   }
>   
> -int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
> +static int do_initialize_xen_caps(KVMState *s, uint32_t hypercall_msr)
>   {
> +    int xen_caps, ret;
>       const int required_caps = KVM_XEN_HVM_CONFIG_HYPERCALL_MSR |
>           KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL | KVM_XEN_HVM_CONFIG_SHARED_INFO;
> +

Gratuitous whitespace change.

>       struct kvm_xen_hvm_config cfg = {
>           .msr = hypercall_msr,
>           .flags = KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL,
>       };
> -    int xen_caps, ret;
>   
>       xen_caps = kvm_check_extension(s, KVM_CAP_XEN_HVM);
>       if (required_caps & ~xen_caps) {
> @@ -143,6 +171,21 @@ int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
>                        strerror(-ret));
>           return ret;
>       }
> +    return xen_caps;
> +}
> +
> +int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
> +{
> +    int xen_caps;
> +
> +    xen_caps = do_initialize_xen_caps(s, hypercall_msr);
> +    if (xen_caps < 0) {
> +        return xen_caps;
> +    }
> +

Clearly here the code would be simpler here if you just saved the value 
of hypercall_msr which you have used in the call above.

> +    if (!hyperv_enabled && (hypercall_msr == XEN_HYPERCALL_MSR_HYPERV)) {
> +        hyperv_enabled = true;
> +    }
>   
>       /* If called a second time, don't repeat the rest of the setup. */
>       if (s->xen_caps) {
> @@ -185,6 +228,9 @@ int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
>       xen_primary_console_reset();
>       xen_xenstore_reset();
>   
> +    xen_vmfd_change_notifier.notify = xen_handle_vmfd_change;
> +    kvm_vmfd_add_change_notifier(&xen_vmfd_change_notifier);
> +
>       return 0;
>   }
>   


