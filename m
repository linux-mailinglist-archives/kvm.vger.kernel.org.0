Return-Path: <kvm+bounces-73345-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EAsyMFcJr2lzMQIAu9opvQ
	(envelope-from <kvm+bounces-73345-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 18:54:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 419EA23E01C
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 18:54:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2E90C300E605
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 17:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78F113B531B;
	Mon,  9 Mar 2026 17:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vRp0Plbk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779033CA4BE
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 17:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773078862; cv=none; b=rnYfRjktOqKuCf7NBHy34dkMSFxg64TAlW7dJenGlPjHj4RHK7pDIXB012yz2rjTaPBTWqZNp4vavlwHea2eXmsJiiMkD7+Evbn9/ySG4G2LgHZRG4wwcQsb8ns4t56+lIMeQ/aC1ABQq7mWAoC0rXWLaHzcYAcBT2YD5V2FZCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773078862; c=relaxed/simple;
	bh=BuwqdQR/+JoA/BZVUlisB+/mVbteEFRlh//+sjJRQCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KkJV13voF4ujuq3WmRFFP/i0pRZ6CXccR6QSBXSASckPBR83i47e+VG4/uayrn22dE6iu/3O5oZMwNCF9GuC7qQEeFLZ76RLSZZ2u3TpUSTEm7medxRWm7Y+1bnopMk9UDPtCxJzT4ZeSsyj2sizAoEyqXFQJkwyZxRMgPLapJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vRp0Plbk; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4806ce0f97bso108276965e9.0
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 10:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1773078856; x=1773683656; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DQpCcbWib06GwrSrjKEgPauEB4pMQNN0BW8pnBJ7+wc=;
        b=vRp0Plbka85TW7vX8+qolBfZoE5kGf/fDTfRkrCJH9Te3GPDEJmluH73MWpT6xF8q7
         rQZAKgbBosWF9r5uawUGVDWLPCUc6gu342mXZ5+ztmkK7q5uXDTYCwwKA6sGNBV7sCR8
         Ul10+elIcNqCTgFI19ge26dJsgNMvS+pxe/6cTWURpFTT7EtQtFKHwiX3MEF17wJE+NX
         2yJfV1fmNG6qxitz0eMskdxL7eLULobP6ReK8ZHfKW8RXCYASYGZOv7QN7+TVM5rLs+V
         T5dbhBdKyBGWTCNWPoCZDLG5yzaHh7YguyEY+keZpwNcVW9/7II5WtA7Y8F03Y95NJHD
         yMtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773078856; x=1773683656;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DQpCcbWib06GwrSrjKEgPauEB4pMQNN0BW8pnBJ7+wc=;
        b=V+8K+UXwdYrGAh9ydfbouiUvDHcoDLZyyf+WIEIN8rf4gcJvEbSPNq4chEByUZXQTo
         MNi95o95tgDr8hUonvj54MiQZzSGGICfVX30NXob9LfeQubMCL2HZSM81SrA7o6ifJ37
         qzb4NzMmA+Yngvn+QatssmBwLPb220QREAraJJhHAFzuQaF1+23D6J7vN3XmoGy5Q1IR
         yDHJ+L+zbxSQnc7IAn/e8NIwrZgv/GU3MVjJP/5PuY2WVGEIOJ0lihif0zBuRtbk4/U+
         RFqDTsdAANzUnr7sUuB4nB5OFxGKglsbrFWbC/I7PryGgh8K4960nhxhRa7pPPO7qbWx
         PEpA==
X-Gm-Message-State: AOJu0YxbV835IKIpsQJ/aUV4ktEHp9Aq6dze210KkzJJwAIjVpOVpSZI
	V3q3FM0tU1Y9HOHPx30mC9aXPvUV0U6ps+w4RuxVFoN22BtiXyMO9+0ZGNi3KGpzduo9+vlsILT
	KxsngBNo=
X-Gm-Gg: ATEYQzxmKPbi1DlYJmTnI8wmPKihTp9VsbA3wlN9Fck8ZRx9h6yicGEwRCFGy6nLuAr
	0aKp0gXCRyQK0HlPgl0ag0hYfB7cojkJD1Gsbwm3FG+I2sch/O+wjh9x3BuFPCrnUoOputVJ5UW
	B3qzGthQuFFmxjMfOC7vRc0Ic7UeFghDm7viyQtKwYOyNcPHRrsWQ/RYebjx6jRQYiXZiC1xIdN
	SyYvRrs0n1HExGGnqtUTj573+c8k2o/EEHf2wlxCL6OByDPMsm9O+BfRdv9zwn6g6r/bdmoUUpo
	uaoJze93CfvzZxqgm/u8JLT5AuM3RdSUaGV6s/7c9r/PahJH3IRQBd6YVUqCQsulsFJHEdHdoS1
	Xcdbe2l9VW4AN1zszMtij76RJbUZg2wkcp3Tb46WyzcrpXBM/GC9Smwh0FREODGTVihvJzDfaxQ
	X9XkwHdI3slJ7QWHj7aSlyo8YKTWlsDy3b9hFoRBZxo+4KdCjibe5fAwqRAL966M0Kmw==
X-Received: by 2002:a05:600c:4445:b0:483:6a8d:b2f9 with SMTP id 5b1f17b1804b1-4852690febamr219281285e9.5.1773078856525;
        Mon, 09 Mar 2026 10:54:16 -0700 (PDT)
Received: from [192.168.69.201] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48541a8f610sm12732545e9.7.2026.03.09.10.54.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 10:54:15 -0700 (PDT)
Message-ID: <80f7ebc0-2ca9-489e-a017-29965a3fa50b@linaro.org>
Date: Mon, 9 Mar 2026 18:54:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] accel: Try to build without target-specific knowledge
Content-Language: en-US
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, xen-devel@lists.xenproject.org
References: <20260225051303.91614-1-philmd@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20260225051303.91614-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 419EA23E01C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-73345-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[philmd@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,linaro.org:dkim,linaro.org:mid]
X-Rspamd-Action: no action

On 25/2/26 06:12, Philippe Mathieu-Daudé wrote:

> Philippe Mathieu-Daudé (5):
>    accel/kvm: Include missing 'exec/cpu-common.h' header
>    accel/mshv: Forward-declare mshv_root_hvcall structure
>    accel/mshv: Build without target-specific knowledge
>    accel/hvf: Build without target-specific knowledge
>    accel/xen: Build without target-specific knowledge

Series queued, thanks.

