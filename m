Return-Path: <kvm+bounces-70802-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wP0gEumpi2naYAAAu9opvQ
	(envelope-from <kvm+bounces-70802-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 22:58:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DED0411F911
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 22:58:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 66B35304EE9D
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 679E3337BA4;
	Tue, 10 Feb 2026 21:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lRqzYgig"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C382259C80
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 21:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770760673; cv=none; b=hPOx/+u+tw+J6RGgDpUO1fx8RV6mcJ0G6YFApnd874JTf84veWPOg6KRfCayeT4aLzVarMqerzLGCGPdh/mW4LdJG20zB4UMJBPZrZkcXVn0Rt5iv7JXA5IuotUqwmY1AHqwMdvpimKtDTMvwu0e+oEuzD3YBOFQm6RTw4WcZWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770760673; c=relaxed/simple;
	bh=reoYWKb/Vx9TvB3XNTOfqSmBfIbLiQgIURrDCzHdLmw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G/Sw3P21xMuQSy70ODX5Z+v7yKD8zlDChBA2eiqsdm/tH+UXGtL6MunY56DxnrNRV56v1cYxEJnhsvlLktCZKyckK12wQmoyt0gXFGnrhinMRZGbxGlREqEycVfY3AA+xtWNXJojkLEgyfRu54SGDn8z1FJZIdD1rPsPc+CWegE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lRqzYgig; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4359a316d89so1114782f8f.0
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 13:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770760670; x=1771365470; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wt4+TnDTB63oHepv/tSNeYmovpwWT8cqJplYnzyRS4A=;
        b=lRqzYgig1bUPzWt9wU7ep67hRVCQrTZ1a1Y1zdqYuIqSkpgs+8jxaid7mW4VEiyf9K
         wGabkgTJqjW8m9M2jh20iW8jzKnNBKQkSNgA/lGMeP1KgWs+TIUjJHgRXrFSDPWhK9HK
         pmSBfP/lbJsgdFkGahKIQmJ2iHploVjetKXxJVnBMJSJ4GRp7MxlRzLDdT3hdNYseV98
         oY2xNaUKrMa25o6EzVo1mlZ0YQ8JdWgOWEcHf1rc82yFLkoFmN7R4x7+zl10XRKxsV6u
         C4QFTDCXEoL8b6kz9y25FPNU45JazQdOk4CX1Q6VL/U8D3PtcsD8qkVMix2NlYMEwkZN
         L3GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770760670; x=1771365470;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wt4+TnDTB63oHepv/tSNeYmovpwWT8cqJplYnzyRS4A=;
        b=SayPfTbY4uImmplZLkJFjlB2nyHo1oIJpHO/KjCOswgVVMdAJkzIYoWQRABTR7FUq1
         +ZYXaHKqWztLhvh3LTm1Q6Mk4/Lv45ytJWw2rNwAb0/GY3syvVqQo3A3GdFQ5YRBENuu
         PsVmwY6eBag3Pd4+lnSdCX0fUFjJXapmi3PnuHm3OYmoDG8CC5ZkCRcKyIEfYoiZ0YoZ
         792Fs9iDGvtlyr7CcQc9//Zhd1kS7xLpOu/in4mZLng9nXYcSeRhmpBjZRlgvThUJVfj
         g7siLoI7RFeCiFYu56HYIg1jOLGqInQnOzSFSRIPiwQWfzSWJkBlwDTKbpTC3iZVWVBz
         fvvw==
X-Forwarded-Encrypted: i=1; AJvYcCWSfHTVdfA9FzdHOFTD9FeU+UwyNCaIqyL0TjA5GMmrrvYq49owIcgNzlcEVorowbXq5zI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLnHae+WEgq4h+kpVU5Tqh7TCTsc56+eeWouEI53zmFiPuNSDT
	GhtGOgAYU+Cf4VvBOuAeI5FD+pJSjDetd2mYfC4SlDyna1XIi2h3XQ9zlCpHDz+nKnU=
X-Gm-Gg: AZuq6aIjh/5HOGjcgo+0jBY8Zkzc4MkP6h24Yp24WOFcJCUR/plsKPh66KVUh2lEelr
	gtTj26WPfTF4R1gRBgSZo+5VcuhiFMtej6aMNuO3s58MYOlWuBBC1YOXzMy3wreR9w6iKSac9v9
	9GpsZngUFYs6zQ5ip6L3MSfKOcIhAb7eRbgFwFPO7KIgnPB1SupicPQXW4vY6KQqGxMP3pO8Kbr
	XRPgzPwX4Ls+XjgfAHHPpoH3dIfMuAjdxGneTk7bBVcEVrkQQ93nt0i+bdS7UxoPSDtBLpwYQ3y
	eIrwNrhVBRFuBc9DrskJqX8PVWYaH9UOzJ5096r6WYcmrS6FYgXXxoVE5X7HiyzWJ8igOYCiPYJ
	blm3Z7H4CArbpep3hgpTCS8WlzQu7C7sR/NlTnITZGzsBXZdFeY4yhB/EZCQ7YRmv+HGNKWEt7n
	1pkhQ/sIo5KsUoG6dTpM7qVJzD/8x17x8AG095R9pFQrkxNQNfZq+0EquuWfcyzn020Q==
X-Received: by 2002:a05:6000:2304:b0:436:b87:ce5c with SMTP id ffacd0b85a97d-43629237819mr24903389f8f.20.1770760670367;
        Tue, 10 Feb 2026 13:57:50 -0800 (PST)
Received: from [192.168.69.201] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43783d746a3sm3250f8f.17.2026.02.10.13.57.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Feb 2026 13:57:49 -0800 (PST)
Message-ID: <e76a6e53-6b8a-42fe-991f-93b9c19c8466@linaro.org>
Date: Tue, 10 Feb 2026 22:57:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/12] include/tcg/tcg-op.h: eradicate
 TARGET_INSN_START_EXTRA_WORDS
Content-Language: en-US
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: anjo@rev.ng, Jim MacArthur <jim.macarthur@linaro.org>,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 Richard Henderson <richard.henderson@linaro.org>
References: <20260210201540.1405424-1-pierrick.bouvier@linaro.org>
 <20260210201540.1405424-13-pierrick.bouvier@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20260210201540.1405424-13-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	TAGGED_FROM(0.00)[bounces-70802-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[philmd@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:mid,linaro.org:dkim,linaro.org:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DED0411F911
X-Rspamd-Action: no action

On 10/2/26 21:15, Pierrick Bouvier wrote:
> This commit removes TARGET_INSN_START_EXTRA_WORDS and force all arch to
> call the same version of tcg_gen_insn_start, with additional 0 arguments
> if needed. Since all arch have a single call site (in translate.c), this
> is as good documentation as having a single define.
> 
> The notable exception is target/arm, which has two different translate
> files for 32/64 bits. Since it's the only one, we accept to have two
> call sites for this.
> 
> As well, we update parameter type to use uint64_t instead of
> target_ulong, so it can be called from common code.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/tcg/tcg-op-common.h      |  8 ++++++++
>   include/tcg/tcg-op.h             | 29 -----------------------------
>   target/alpha/cpu-param.h         |  2 --
>   target/arm/cpu-param.h           |  7 -------
>   target/avr/cpu-param.h           |  2 --
>   target/hexagon/cpu-param.h       |  2 --
>   target/hppa/cpu-param.h          |  2 --
>   target/i386/cpu-param.h          |  2 --
>   target/loongarch/cpu-param.h     |  2 --
>   target/m68k/cpu-param.h          |  2 --
>   target/microblaze/cpu-param.h    |  2 --
>   target/mips/cpu-param.h          |  2 --
>   target/or1k/cpu-param.h          |  2 --
>   target/ppc/cpu-param.h           |  2 --
>   target/riscv/cpu-param.h         |  7 -------
>   target/rx/cpu-param.h            |  2 --
>   target/s390x/cpu-param.h         |  2 --
>   target/sh4/cpu-param.h           |  2 --
>   target/sparc/cpu-param.h         |  2 --
>   target/tricore/cpu-param.h       |  2 --
>   target/xtensa/cpu-param.h        |  2 --
>   target/alpha/translate.c         |  4 ++--
>   target/avr/translate.c           |  2 +-
>   target/hexagon/translate.c       |  2 +-
>   target/i386/tcg/translate.c      |  2 +-
>   target/loongarch/tcg/translate.c |  2 +-
>   target/m68k/translate.c          |  2 +-
>   target/microblaze/translate.c    |  2 +-
>   target/or1k/translate.c          |  2 +-
>   target/ppc/translate.c           |  2 +-
>   target/rx/translate.c            |  2 +-
>   target/sh4/translate.c           |  4 ++--
>   target/sparc/translate.c         |  2 +-
>   target/tricore/translate.c       |  2 +-
>   target/xtensa/translate.c        |  2 +-
>   35 files changed, 24 insertions(+), 93 deletions(-)


> diff --git a/target/xtensa/translate.c b/target/xtensa/translate.c
> index bb8d2ed86cf..5e3707d3fdf 100644
> --- a/target/xtensa/translate.c
> +++ b/target/xtensa/translate.c
> @@ -1159,7 +1159,7 @@ static void xtensa_tr_tb_start(DisasContextBase *dcbase, CPUState *cpu)
>   
>   static void xtensa_tr_insn_start(DisasContextBase *dcbase, CPUState *cpu)
>   {
> -    tcg_gen_insn_start(dcbase->pc_next);
> +    tcg_gen_insn_start(dcbase->pc_next, 0, 0);

If documentation is a concern, we could define INSN_START_DUMMY = 0 and 
use it here.

>   }

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


