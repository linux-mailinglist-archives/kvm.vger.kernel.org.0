Return-Path: <kvm+bounces-70827-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4Dt9EWkijGl0hwAAu9opvQ
	(envelope-from <kvm+bounces-70827-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 07:32:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D1FC1121A15
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 07:32:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 114943054C88
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 06:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C28729C338;
	Wed, 11 Feb 2026 06:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jMu+l0Lu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BA7221DAD
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 06:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770791506; cv=none; b=S1JMukGZYkdF7Fmv9EmDfJVWOK2H/rO790jIc3KkKQJNM2igsDrNlc2h6M1T/JGTQvnMz9X5wj5WCxneHKJ4Zb7kDHMknN0JTp2QDaK80iR3wNGqxu0FJFxfZcWEKwtzZwnPDBhZcQoeL/n8S78LCpIkFTXsSnc+sGyPwd32GEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770791506; c=relaxed/simple;
	bh=BXfC6VUNL5jv93nE5tj2X8yF0MrC6yguaH8ozZVLrSc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=elMgB/mhEGl2ch5m82JKji8DPjNoI6swRmIs8/sQ7/usK5Ryu75CZ7FEdLInVwrNBgSb9zYFvVFdWdImF+NBK0MiZsjeQ58AVW0WQscll2GzyxVuZ1iBlhHTJ0RKVUSoiVnysgW5QaJ0lYBl6b/Rf0NajS8iUwBJYrwAf+VRy6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jMu+l0Lu; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8230c839409so1472938b3a.3
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 22:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770791505; x=1771396305; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5VI3P8I4QXrt/D58wc4S2XlvSfUm8+jvHYdThYnzY4E=;
        b=jMu+l0Lu5QEB/CjAybiq7WLNLice5oKL0xUnaJvr2XJXKE5yM2ibVJpsyGLM00h8/5
         PvQn7MpGmc2weqKpC7o0xEIBHPh4P1GPAagKtqHM44an+xLAYW2eWrQGHDSVKDG+PKbu
         EiO07rIzaPkestOK4PhyBOMAJ9TtTqAsnJHi3CHOLyFVNw+hdrH3hQijlo9SqdCe3WMf
         Z6MajjQDZftDYKgeNzCfkunvSv4OWYsF5rfPKBKNUFtd7Tdu6JkprSOGpj64lbe7+K1M
         QEz7nD3T+BxK1YBe6AXXlZNCh2niH9CCAoQAZJ/Muogw5hdYL4PHQ3CDCaaKdntWe6XD
         skzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770791505; x=1771396305;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5VI3P8I4QXrt/D58wc4S2XlvSfUm8+jvHYdThYnzY4E=;
        b=jzZ8kL4rc+zRLxMul8eZoFpO/Xf/5JnDuJV42KMitI5/gmIKTtxw3B1+kkZiZcUPzp
         vIhxyi4l+t3Saf4/bywBNWHDMcDyVU6kXFD9AVnXhk/+rj23f6fHvm7DoQOWkvW7qRBF
         bqeaHd/qbwNQRh1u7swgMrJpmGAH30Xbjqwb9yFgpo0SFklV5vhCzZQKtbpAfaUn613t
         lqlYrmV+qbyrE7isAkrS/dBSYdC2NS0855bUjgH7otsjuXOiM5o8AQ5H7ODG7aptASv5
         UXzylI+oFuCiQ+Uo+vdtTDeVwmuUI2rgmRbd/5nnZgq4Hb6TZ7khJntBxG9eFkuldYbl
         4oWg==
X-Forwarded-Encrypted: i=1; AJvYcCXbhafhaDapUaFdmdXuF7nVv+PKGwve2F7err9BHorBbX4g5LdsOMVZSErqTI3Oy3Qqd2k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzhlppdHHLh0zdA6guaZd2l6bWBzibFmmuqq8yDUTBeOs8zMsP
	+j26wyoc4jTXMusX0iRSv94aY7g6teoZXRBXgydIuLC1AxPIFvrIUMGgjQb0Ppz75c8=
X-Gm-Gg: AZuq6aI6bUssMh8ZdI7ITE1AVczPFq37aHxAdLkoWDsFYVcJMe3vqMEy9eTisDj5dYd
	ULF/tIpYZ5ODn1n8Dohiyd8SSVfgq/em/Ox0issUkxjJO9ggisUJYZVCKW/5RE1TjrqSV4xcrUU
	wHe4tFHTqLKgeA8nwBPdLjXW0AsUjgOhKAf7w0KCu6gkZIqEVmLpEde0DabaeVgKm5k78kJibQ2
	cKQHfUWMidzPFjJHscSvDAVMKoTOkWU882wKaFceErXojtNtOy3swx4qdIFggxK5QUZq/BCfDF/
	6MuxzA+4CYab7OdkajkxDJuRKhDBI8PSZ9TP8H6R/JZetCX6LiJ93Wy3UGWs29epbRgCEFEaTnr
	t5TQ0MDLOm107W2ldCam7dgl1KWRD1iF7Hran8KAKMlC+EyYHWD8HFCOgRuDT5yaf9AUfWmobCr
	7IWP0vYyrOEl0Duj5aNPUJO7snACuJj9OXE7mRSB6Py0VjaOezOfQi8iefNhzXoXkRgWG/0C1Ok
	jxW3YHJlcX5Up984N91N3Dn
X-Received: by 2002:a05:6a00:22cc:b0:81f:43fe:988c with SMTP id d2e1a72fcca58-824416107b2mr15625182b3a.6.1770791504764;
        Tue, 10 Feb 2026 22:31:44 -0800 (PST)
Received: from ?IPV6:2001:8003:e109:dd00:f8f8:2c3b:9605:55a0? ([2001:8003:e109:dd00:f8f8:2c3b:9605:55a0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e366a76sm984264b3a.10.2026.02.10.22.31.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Feb 2026 22:31:44 -0800 (PST)
Message-ID: <8addf5df-614c-4309-8ae4-c3bb59f7e0ef@linaro.org>
Date: Wed, 11 Feb 2026 16:31:37 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/12] include/tcg/tcg-op.h: eradicate
 TARGET_INSN_START_EXTRA_WORDS
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: anjo@rev.ng, Jim MacArthur <jim.macarthur@linaro.org>,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org
References: <20260210201540.1405424-1-pierrick.bouvier@linaro.org>
 <20260210201540.1405424-13-pierrick.bouvier@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
Content-Language: en-US
In-Reply-To: <20260210201540.1405424-13-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	TAGGED_FROM(0.00)[bounces-70827-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[richard.henderson@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linaro.org:mid,linaro.org:dkim,linaro.org:email]
X-Rspamd-Queue-Id: D1FC1121A15
X-Rspamd-Action: no action

On 2/11/26 06:15, Pierrick Bouvier wrote:
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
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

