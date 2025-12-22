Return-Path: <kvm+bounces-66480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EE88FCD670F
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 15:56:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 07DDB306F17F
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 14:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C86DE2F549D;
	Mon, 22 Dec 2025 14:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FHwsdalD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WBR1wFIr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5C72F291A
	for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 14:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766415238; cv=none; b=rmrADmiMYjLwnAER1wm0rK0IX5Y4DE8btWbSNg+AhdSx9Bstmh+DMwqOrdjOpUPCrnLtpWnQKOWs+Vrt4hUYw8lFJkYZ0PsGmjes/gMtccb/BGt4sJBo89eumteXAho1zknW/m/iwsyEcA9WkCrrDjpG8yksR28ApxBl3tpLu34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766415238; c=relaxed/simple;
	bh=Cq5qIX1me6q0tgaKdJ+pewR/6NPqO/f6PKdojB8rVKM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jHI09QKFkLr+YG1BSxALovmZnkIAGeoFGUeJDgqMsJ7EOt7DAgeS+7IFQHVKpGgMpU2qE9lYpPqXmIpTTxbwyQsb/OLgBWwcwZiKKElQnrBuYaSB8riKwSiSO/Au8tXaZ1rVYrt87rOW/eEkXf8kNHADxTsDsyYUegZU1EK2l7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FHwsdalD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WBR1wFIr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766415236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SfXMHZCkCuQERL7oHyNOjV8n3cRAWLR01uYMmroCZvk=;
	b=FHwsdalDTeywvFCku2XA2cuYoS+xQvtfzp4FlvV87+5QalDtN8pZfxEj+YsIA+NVdcQtaK
	gRNsbd1KtzatIFcYuUhx1a+hCn2nL8RXcHsjF1a7LYjInCX8MHSQGKn8OAjEsMBfMUqy8P
	lCrsGPW+qnYpZmDc42eArvoSWW68KPY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-435-ODB_VPQMNW2Lcr3rJtmt3w-1; Mon, 22 Dec 2025 09:53:54 -0500
X-MC-Unique: ODB_VPQMNW2Lcr3rJtmt3w-1
X-Mimecast-MFC-AGG-ID: ODB_VPQMNW2Lcr3rJtmt3w_1766415233
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477563a0c75so22105115e9.1
        for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 06:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766415233; x=1767020033; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=SfXMHZCkCuQERL7oHyNOjV8n3cRAWLR01uYMmroCZvk=;
        b=WBR1wFIrpNkDxrEEEypXjSWsaEg14d/7eR1YC3AVeE0wcS9eawCP/OU8it2RWKL2XA
         8HhoHoD6IxEJAaLskAcQ2ICxPM4H38bthuE3WbGH9ovRqESNN86V0qA2/84iDHu77eaS
         zw8HM1HHeE9J658z9lRqxeZEypnK6AF436aFpjZrZstDFR5PLIUSGQC+TQeYVrjr3EDg
         IFER4JJhuCO0wnT6jQTysTe7EICB2xhthwdzUamq1wrtCll12xe/63Cbs9KON/qYN5xF
         P2JehY1DD5GKgNtsEbwLq3lPuSxVrPcZAHcndZmrtT4pUlVfx2qhQ1G+PVyrqycyNGZL
         8Q4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766415233; x=1767020033;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SfXMHZCkCuQERL7oHyNOjV8n3cRAWLR01uYMmroCZvk=;
        b=WdOM3r/VgEBSyv+8FlRNSPPk35GL/evdlMRcksXZnddeMe+Ipt7q+i7Jlzg3k/T9uy
         ZK1eMzhY9JuB+vvrNCmeqeafEhApydLMq1vk+0xbKzbqriSEAHhQKBwXziZM6BiXlB/t
         D25kwH2eoxzX+59meY8rlc46GF+rvDZgJG5ZoVKNoRPS2b9txMNhY3F48CliJ1vt21bi
         y3wqzhlkjXjdVbUOtvqWh+JYlZ21a/roTABYNJfePUdAwkVyoW//psEyD6iQf8SspWp2
         NddwN45COB+uk9OoS4BrMkJ433Erzv+bmZEJzp5rompNgpVExYH1YfeVhAoSSyCzW2m/
         TLRw==
X-Gm-Message-State: AOJu0YxDb7GQUarDR8RKXzXHR/oxgw+Cll63tbx2gCsmdvzYdi8JNxDj
	sR2sv404RckDa/DdJLF9vsKWnUhRHbkP6NtlGeslqGJm1qA2RAMii1cp6HNRrJOBAE2+2+vTxt1
	VFEhgIfh29rXtkyMwnss7hXSsrierUfAEphlhpE90fAYXq2qqqLOVrg==
X-Gm-Gg: AY/fxX7tfQdnfb75B7JlcZlPjJ+2uQmSxrBz/BUmvGdaBLXa0O+9J9liExysH06QHE1
	0DOPKXA4PgV1BD7w8CPMm11wtIHxjuODUQOX4G5h44o6Dv9cOIXVZwdivcMMP70/ZjTahndJ+pC
	GIRx+kY1dvKvT4s9daXhEfSmNQuVj8nJbXeOCRdYh9K5G1BCHrOAI4VLjhE3HnJ9SM4uybZD64X
	C1PXLo5Vycr9idpD1zeFt6m9Vx1u1DWGjFWZR4Nwi4PPAqV0U5I/glEyLgfN8Ap2bCF4NvN/b9S
	IU9+XT4sw9eODmq4oF2mcSqTS4qygV/99mRxFhp9agNd/jmWCSFO3J2UmUjkrAMroeKWxiwjbxX
	BIn2GW7H0FnZgeOW/vLa9zknHlVgnKzJFWx0IVDZbhisVMQzf1GDbB3KeUV2Y9XyzomaIUe58Oc
	mDh52ppFL4hkCbCR4=
X-Received: by 2002:a05:600c:3106:b0:47b:deb9:15fb with SMTP id 5b1f17b1804b1-47d195a0feamr121928085e9.33.1766415233142;
        Mon, 22 Dec 2025 06:53:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF6JSJ+qiA6LpY1JtcJlS8bwGICCk9Om1IPr0jE9rmfYiINoPMshUt3KTO2bklT9Xp4bqtB7A==
X-Received: by 2002:a05:600c:3106:b0:47b:deb9:15fb with SMTP id 5b1f17b1804b1-47d195a0feamr121927955e9.33.1766415232776;
        Mon, 22 Dec 2025 06:53:52 -0800 (PST)
Received: from [192.168.10.48] ([151.95.145.106])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47d193621c8sm191684855e9.7.2025.12.22.06.53.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 06:53:52 -0800 (PST)
Message-ID: <ef71284a-deeb-4661-8180-0f52259cae39@redhat.com>
Date: Mon, 22 Dec 2025 15:53:49 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/16] KVM: x86: Enable APX for guests
To: "Chang S. Bae" <chang.seok.bae@intel.com>, seanjc@google.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, chao.gao@intel.com
References: <20251221040742.29749-1-chang.seok.bae@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20251221040742.29749-1-chang.seok.bae@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/21/25 05:07, Chang S. Bae wrote:
> Hi all,
> 
> Since the last RFC posting [1], Paolo provided extensive feedback that
> helped clarify the overall direction, so this series is now without RFC.
> The patchset incorporates those feedbacks throughout, based on v6.19-rc1
> where the VEX support series [2] was merged.
> 
> Major changes were made on the emulator with rebasing and subsequent
> simplifications. Below is a brief summary of each part.

Looks good to me, with just a couple comments that I left on the 
individual patches.

Paolo


