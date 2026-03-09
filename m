Return-Path: <kvm+bounces-73328-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CG2TBpbwrmkWKQIAu9opvQ
	(envelope-from <kvm+bounces-73328-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 17:08:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7786D23C77B
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 17:08:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8922C30B9805
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 16:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD0593B8BB2;
	Mon,  9 Mar 2026 16:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gBTlwZch"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40AB392C2C
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 16:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773072137; cv=none; b=J7nHmUmZsNodFp0fqrX3yTSDhhVN+eORUya9rMQEAKHdMHzMwyR7MDnulL+wNsaRR9KQz5fPeHwltVBOApdAVbOrFpAV+FUbPu+hPPZeqdvkJc440UYCXJCpwvAPWNF6+T4J1OS+PlSrotiRIATj1tav4sPZbthSeo9lAGPwAf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773072137; c=relaxed/simple;
	bh=g4xnvV/ZslA3nhJ7BC+rZ0cWzXT4jo4xIZglkvyS4C4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sP68kySDBzSN5vu8Y1Jb0CrhyrQ8xqQyrbG9UM8d2MFZO/ojJzC853tPT1awfA+NvJh9UmUcYoYXdwpR6jfgF9JrXPdLhbXzQK58xq36+8WzwU2WVOHBRa6wjBDJC+6Ebsl8mvof77M92gRnY+8vtGwJCzGDRqG1bPkeufsNVio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gBTlwZch; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3597fea200dso6371154a91.3
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 09:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773072132; x=1773676932; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0JcBmMc7RHH64iN3rytmVT6qlyOdSxQ+djReiuE8ktE=;
        b=gBTlwZchheD3rMBCEweOGahUiJwWtnNEMuDINTOwsijU7cSKBF/QrQzUcg+P6MHsjt
         h2f+S5lqLIHPAha58vBDaxN9v5Q+yLUeQUnmaPn2VPN9qTXagINqQHLefQ8lOW9fCiwz
         cVwsBhOSh1ADPhIpEBrm4rHRQ3Tw6jJn9hbZHuInMhqOdEvHJqjCYQ/ETjFVNvMCOkrU
         9xycPBVCQrYpTR1yP+JWfqdZJrVF0v1zWVOPsBfWZO1N1hUzgezjZqN5edktylB/ocuX
         hNWyq94S/F7EjKOvcZF+nSYri4cz2EybHzo6EtpdVls0xUMDTEUePuqaZbdK8EskUtgi
         10Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773072132; x=1773676932;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0JcBmMc7RHH64iN3rytmVT6qlyOdSxQ+djReiuE8ktE=;
        b=Yw/OICGni9lYjRo3S7aNG+0lVTcObsEzjOGHbPPxzQVpcY4SXwaP87eNIXC/VHnCq9
         51OV2NPwmXGZSoNi3KeNKK/gA4ZhFZYegPHK3ZwtDlP/eOt53XlYySxmBHP1px8LpjET
         bVpWt41Hoj90chZvrRToyIiN/Rhz7CJoFhfkoFP/z3eKKJeq5f5FGJtBbYdCGRHcJLWi
         c8ZXmhvBXCUTLJHKO659gRzMpgYXHqCfIrTLFt8SKoz9BeGQZLOye2cEynvxJ2LKm9bV
         Z55hn6qavr7jamO80y44kJy0VQKyjps1eKMkYXgR2n1fqovs8vRD/UGZMAshhyFxLS5j
         qNwA==
X-Forwarded-Encrypted: i=1; AJvYcCUxCs0dQ4PhkDlGk/RG/lDLj1Uqp7HsPWfYrb0Nn0Di5x7d5bNcP/mendlYP67Ag4UPgCI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxuQria2iEarn/9uzdCFn2n9yVwTp5+enHDHH8HVgWUDXbakqD
	HF7YlN5Ngg84SBwctHXCZnET/z44CMCqlQ2L5abWOzIClnsn7VnqxQ1X4geX+D+qqDg=
X-Gm-Gg: ATEYQzyZDTHK7xFsDTtKMjq4v5J5qlY93z6UURVm5/NeLxgMctOthz8XEqbncEaz7B3
	AqYRDAYIgGE6RpKtEQb4kcdor1N4y5Ijyj00CC8lhxboYNmon61gCaxPm9J77AiuPqVywRXpoYB
	xAYMAJ4G/+eqc3oY08Hw5RKz8LplzqzQ2/+I4Htt6VfK+B4xEi7WfUH5GCpWVxaeJyw8f9kRLXv
	1T83bxYB971jGKLX6glRy/Krgh9DwTOQaXQLoRYP+T+IBS3O3PP+tShfcBdvE16IPdddF9sto20
	HzxNB7MT2tN26rDJC29mdxkN3FliLo3ib3xiMVmx8G+aDABDUAT3y7DOksxPk6fKV+DvlZbSeXR
	zX5ig+idcRxq7lDd6dQPM7irP4yQR5ujRjydQ8DoDuKUF+vCNXMxl7YTm+osNrWugWDcIJBZCC9
	l2Q9WXtVDIOsZtGkC59vCkhRDjQA62/Hy/750VKALIz+UFOtg2Wm6cqCwhSALuuJba7y/JI7Pnq
	d+i7MeMlifSS97a
X-Received: by 2002:a17:90b:350b:b0:34c:a29d:992f with SMTP id 98e67ed59e1d1-359be32b9ccmr10866952a91.31.1773072131119;
        Mon, 09 Mar 2026 09:02:11 -0700 (PDT)
Received: from ?IPV6:2406:3003:2007:2131:15e3:dec5:94ba:4da7? ([2406:3003:2007:2131:15e3:dec5:94ba:4da7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359f05ee4a7sm50316a91.4.2026.03.09.09.02.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 09:02:10 -0700 (PDT)
Message-ID: <d550c85e-a149-4cc2-8519-d157226097e2@gmail.com>
Date: Tue, 10 Mar 2026 00:02:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: pfncache: Fix uhva validity check in
 kvm_gpc_is_valid_len()
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 syzbot+cde12433b6c56f55d9ed@syzkaller.appspotmail.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260309075629.24569-2-phind.uet@gmail.com>
 <aa7bjEJ_ICGjuiy5@google.com>
Content-Language: en-US
From: Phi Nguyen <phind.uet@gmail.com>
In-Reply-To: <aa7bjEJ_ICGjuiy5@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7786D23C77B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73328-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[phinduet@gmail.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.950];
	TAGGED_RCPT(0.00)[kvm,cde12433b6c56f55d9ed];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 3/9/2026 10:39 PM, Sean Christopherson wrote:
> On Mon, Mar 09, 2026, phind.uet@gmail.com wrote:
>> From: Nguyen Dinh Phi <phind.uet@gmail.com>
>>
>> In kvm_gpc_is_valid_len(), if the GPA is an error GPA, the function uses
>> uhva to calculate the page offset. However, if uhva is invalid, its value
>> can still be page-aligned (for example, PAGE_OFFSET) and this function will
>> still return true.
> 
> The HVA really shouldn't be invalid in the first place.  Ideally, Xen code wouldn't
> call kvm_gpc_refresh() on an inactive cache, but I suspect we'd end up with TOCTOU
> flaws even if we tried to add checks.
> 
> The next best thing would be to explicitly check if the gpc is active.  That should
> preserve the WARN if KVM tries to pass in a garbage address to __kvm_gpc_activate().
> 
> diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
> index 728d2c1b488a..8372d1712471 100644
> --- a/virt/kvm/pfncache.c
> +++ b/virt/kvm/pfncache.c
> @@ -369,6 +369,9 @@ int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, unsigned long len)
>   
>          guard(mutex)(&gpc->refresh_lock);
>   
> +       if (!gpc->active)
> +               return -EINVAL;
> +
>          if (!kvm_gpc_is_valid_len(gpc->gpa, gpc->uhva, len))
>                  return -EINVAL;
In this reproducer, userspace invokes KVM_XEN_HVM_EVTCHN_SEND without 
first configuring the cache. As a result, kvm_xen_set_evtchn_fast() 
returns -EWOULDBLOCK when kvm_gpc_check() fails. The -EWOULDBLOCK error 
then causes kvm_xen_set_evtchn() to fall back to calling kvm_gpc_refresh().

IMO, if the cache is not active, kvm_xen_set_evtchn_fast() should return 
-EINVAL instead. It may be better to check the active state of the GPC 
in kvm_xen_set_evtchn_fast() rather than kvm_gpc_refresh()?
Br,
Phi

