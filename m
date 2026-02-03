Return-Path: <kvm+bounces-70112-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aDfrKap/gmnAVQMAu9opvQ
	(envelope-from <kvm+bounces-70112-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 00:07:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 18005DF8BB
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 00:07:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DE6B03047525
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 23:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0873E3112D0;
	Tue,  3 Feb 2026 23:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Heyp9T15"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB962DB783
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 23:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770160032; cv=none; b=WmyKj/josZHap82emdyTwpCX/Zifx/KWb2Pd36bb+5CxXHn9nMXvajlx6Dy8aYDbtkojAVDbAKxXShWxyc6e4/f75YzE6IycuK4mVrxAqX9tgVNPq/U4UcaFUc4c2rqDLUHWdUeR+6BmlL7wcavwOLMLNs2sj+DKZHdrkig2VP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770160032; c=relaxed/simple;
	bh=9kzaR+zsQ/4FH8wJTBHGYH+emu09b02p7PBz/ED4wuI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pxGT8Kpq2h9y9Fd62W/TEn+XqRQksGDXGkiF1rQgGTmZKqoZQebPF7/c2lvP37YzoVvvBixQDaGd+Wmz/QAZRmag0+sOZR8VdEuYFKOA4RpPQ1VBIqoefhxOEfyFbt0ygC+eA/dDIqHfOrcP6HvuqruLHWM3n//ZR81lhbpg8KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Heyp9T15; arc=none smtp.client-ip=209.85.210.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-81e8b1bdf0cso3887047b3a.3
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 15:07:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770160030; x=1770764830; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dah94LlcgxIBc11yFC7eq8mtegbkFcb+3zm6NfNIbTA=;
        b=Heyp9T15O4ZeWxYveBKV/e+bm4JISWkcyNZ87hQWSBhxRRYWOBd3tP4BhgkXLnt1Ii
         TUEo82vdcjXLK3EnKcM+oGBrxim4EdidCKNrTL5hwGrkhG8Z/0lf9s4mS3rtvTXJjmwe
         5vj7S18ZKefDXmlU/s4byDe0s6bMpjJvCK+9KMuvZSXjeYIfES0011c7QfeZHeP0lDyF
         qbi5X6AgOikbTvmCX8nHvxxROMKgSW6K8Umz80veROH97LPyhl0FgTLviG8hqjQNQjyB
         Wd9i2PbIbvzUu9a2SVbLy7/gBGHnlYF7JMUYFk8IG2Y48VYtYaIsbbEuhAjNIdvAj1pd
         AXwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770160030; x=1770764830;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dah94LlcgxIBc11yFC7eq8mtegbkFcb+3zm6NfNIbTA=;
        b=I2AuJ8mYn4Nb18Pe0zTvvyD5yH2wwnR+oiFdHJ+JH+4gDLnF6Nhu8X9KEVpJtgERys
         mCJDKIUK3VHblTzuES6NKsG0moB1fllL8iz/ZjSnBKAYBWK9x69Rc5MHWpnY6eqXvKMY
         wWLPA8WhUmXBlFvKRKU3hyyfuniYftTAKuLe+wqD0aM5/CClZscHBH1LEsvcM1IyQJyq
         jIuzwxdTy7rOSCHSoKQ+Lw7qeHpeqYnJmVvby6D8EkXUb/ibJD74IIZKfYq00qMpfly0
         OYu+YGey5By+Y1aYp148EnrGA9GAKa6d8eVvEd2pGHOGrTe/0eypdNwY+54iPwigJkmb
         eLBA==
X-Forwarded-Encrypted: i=1; AJvYcCW9GLs7BvP9ilfcc/2NwkiYzLluVygHs0izwuT3ChXRngn8+6c67QA85wZKBDw8Vgsb1e4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyj783zQMJViAi7swquw/zFSP793I6Zgop0W7N0XTK6FlvGuKKg
	+6pBohkVUTcxS8I9C4TuLPgbHxrSn/hOGaQyE8OVxTJy4U5/ExJt+Z0fpLeJ1CmRYTU=
X-Gm-Gg: AZuq6aJ7HXDI3bnEf8iyXr4BeO67P91USe0P0hgb4lq+0wDFBl+awC4b1+wdJzX1HOq
	MyNT2VQlT38pJSHIDgIneSMNp+zAelJU9Oc/F/efl6gL8t++4NWJIGAAdZ54RySiFHfQN1SYo2I
	kJ+kxZVGHTKmr0DKSlb3bnxVxjq37+YXDrYU2a8kc0AtgJq+hcQPINQbOe471D1eIgf60LsQTPn
	WCC44hnY5COHH8TW7NZpsigf+R9iiPrhvQY3gIS97Q4qOMIjSySolr/zQrgoiPlfrA4VsRr7PFt
	G3CtpnPAuu0xStSF14iXY/I006X1Cpecm+rHJNdCxgT60iaZ5jnS4vjSLgmBjM0s8UGQgYzoyE2
	RgY5XYHwqcw/jWRSiZs/NPCKYqwCWq35szv5eO9T+MKuZ6SV7GLKEiZNimZAYApJHtfgwGX6gK+
	rYLj1tHzgp5+dLBeUR63tZmhKe1ip7MbuYaQhNPjRfzyqucdmXU/fEsc1DNhmFk5hmjJA=
X-Received: by 2002:a05:6a00:cc7:b0:822:6830:5900 with SMTP id d2e1a72fcca58-8241c1f5796mr904211b3a.6.1770160030429;
        Tue, 03 Feb 2026 15:07:10 -0800 (PST)
Received: from ?IPV6:2401:d002:dc0f:2100:1bc:fe1e:491:928e? ([2401:d002:dc0f:2100:1bc:fe1e:491:928e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8241d4abb49sm362926b3a.64.2026.02.03.15.07.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Feb 2026 15:07:10 -0800 (PST)
Message-ID: <acfd1479-3b6c-49a1-9bb8-cf1bc5611f87@linaro.org>
Date: Wed, 4 Feb 2026 09:06:52 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PULL 00/17] Firmware 20260203 patches
To: Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org
Cc: Igor Mammedov <imammedo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Ani Sinha <anisinha@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, Zhao Liu <zhao1.liu@intel.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, kvm@vger.kernel.org
References: <20260203120343.656961-1-kraxel@redhat.com>
From: Richard Henderson <richard.henderson@linaro.org>
Content-Language: en-US
In-Reply-To: <20260203120343.656961-1-kraxel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,linaro.org,habkost.net,intel.com,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-70112-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[richard.henderson@linaro.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linaro.org:mid,linaro.org:dkim,gitlab.com:url]
X-Rspamd-Queue-Id: 18005DF8BB
X-Rspamd-Action: no action

On 2/3/26 22:03, Gerd Hoffmann wrote:
> The following changes since commit b377abc220fc53e9cab2aac3c73fc20be6d85eea:
> 
>    Merge tag 'hw-misc-20260202' ofhttps://github.com/philmd/qemu into staging (2026-02-03 07:52:04 +1000)
> 
> are available in the Git repository at:
> 
>    https://gitlab.com/kraxel/qemu.git tags/firmware-20260203-pull-request
> 
> for you to fetch changes up to dea1f68a5cd338b338e34f2df5ecb2e35a9d8681:
> 
>    igvm: Fill MADT IGVM parameter field on x86_64 (2026-02-03 08:32:33 +0100)
> 
> ----------------------------------------------------------------
> firmware updates for 11.0
> - igvm: rework reset handling.
> - igvm: add MADT parameter support.
> - uefi: variable store fixes.

Applied, thanks.  Please update https://wiki.qemu.org/ChangeLog/11.0 as appropriate.

r~

