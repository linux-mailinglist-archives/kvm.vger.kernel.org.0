Return-Path: <kvm+bounces-21905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 85295937127
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 01:38:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBABD1F21E1A
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09ED3146A61;
	Thu, 18 Jul 2024 23:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="IOP7tBAV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E9B1465BE
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 23:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721345927; cv=none; b=KaEuUhr3uLIRN4qPpKkLvW517HyGQ2J/Bcu1qDk4XseuFCu9OI6SHM2E8HiHGyIPaW29zJVjffgJVD2HskXOOk61UdtxlxbWBBzA1OrCx0aoWQaM0j+CdoOQP+sfrVpBmexy3kKZIh7wm88pYx97+IIozkX2evGWwZ2U633PUtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721345927; c=relaxed/simple;
	bh=mdmnaCDZYFykkp8P60f5Qr3sXWLsG8Use+1CQ/rGOoQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u+kPcXJMoat/FkMaAIOm+Zsjona0Rc+AYZQ/ycQ3KB64frba/JgG7xIRWbSCxYnfh1bESqncmjUZtQPoJKyB5Y7bzTQx/3vEdtBTBWWVD4WAIG0Tlt2Nd6AQeYqWGBS9FuOGGb8x3izbirHIuEIRO2JaOlpk2i5iOmepfHbskZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=IOP7tBAV; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7eee7728b00so54082939f.3
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 16:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1721345925; x=1721950725; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nvIns0vPchcCSpiwT/Cr//HZT6luVmkYPX5bZikjiSM=;
        b=IOP7tBAVjmmCqM0yaqd6WfKf+8TaOMn7Atn/jNRHw6uRu4xx8y51lqDiw7oUYjbzGN
         tuxFudCtAWiWSzLQz/7rHJN+QslwE5Y2jGcSdZo8RuaqiX3OZKUabiapY3ZS+IcuoPav
         dfgopp4MLYKKswU3+icsygWxBkVpmIPgOg/KfvXtrvtmTE+1n5IYhQkQAmg7dBMA3Aop
         Q7UBXeghNZwkjj1wvX6zCKastw147syZuTiM7xIAOXzCNX1+UrRVtpMcJvif/SMuag0A
         H/aQnLhZDBvgwSU8cs9NEC0BI1lVC+vLOnOGc54Nyemd74VWaOnGtk4trkv3A7m+9kK0
         3C7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721345925; x=1721950725;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nvIns0vPchcCSpiwT/Cr//HZT6luVmkYPX5bZikjiSM=;
        b=IxDcTInHwIUWOxbdzWDyIZ2KWNJRKs4PqaeGQxiACmmYxj5cIia30kEZbpzG8Z225a
         5sTcdEK582pm7rcGhjjb3b3eEU4zg2BiXUvGUHd3oo8+jylBbN7sDpWNXNV70z8QbX3M
         RLEI7mbbSmXN5gnbQEVwb6AeeMKarUUsn/RFkE5l4+eXFBIKZQ9LZX5O7JGmv8OJh4lh
         vRDRMx7tEPIUX6z3/weD5aiBp1OqWixbFn6PQoSDCesJMEAkg4Ayn8ESwxSepb35bc29
         ZIwfbpwS5LFqTSja0r3iWBnzXavaslCLX03rcqXmDixtmS1/l5LwwYgbl157j3aNusGp
         Ho9w==
X-Forwarded-Encrypted: i=1; AJvYcCVyvoBFfbq9J/YDPWhAyvmV/qcCJIHX49Ud9b2P1eLJB00m7sR6Dj8QkiMl1tRyQHq/Ag3e+wxNpXCzyTHyl3BcC/EL
X-Gm-Message-State: AOJu0Yzmg9nsE3qknZ8zT9Wf5PZ0rZDh5dmPvdVnRle43NgFSayFjwAe
	eTLocqxgpNIbIKgy+rA6NgaQ6y+8SeF269+IXajcyBzOhQn5GNoztyWWDmZCh2o=
X-Google-Smtp-Source: AGHT+IEIoaaRXy0Um8nUPOglEs3ZnOloxeKDVGZgw8a7UQi1E33LPlNqKhP4N06l+qm+Tlu0m2n/3Q==
X-Received: by 2002:a05:6602:1347:b0:807:28a5:aa47 with SMTP id ca18e2360f4ac-817125e17eamr804148139f.18.1721345924786;
        Thu, 18 Jul 2024 16:38:44 -0700 (PDT)
Received: from [100.64.0.1] ([147.124.94.167])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c2342f15ccsm80150173.67.2024.07.18.16.38.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jul 2024 16:38:44 -0700 (PDT)
Message-ID: <727b966a-a8c4-4021-acf6-3c031ccd843a@sifive.com>
Date: Thu, 18 Jul 2024 18:38:42 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/4] dt-bindings: riscv: Add Svade and Svadu Entries
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>, Conor Dooley <conor@kernel.org>
Cc: greentime.hu@sifive.com, vincent.chen@sifive.com,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org
References: <20240712083850.4242-1-yongxuan.wang@sifive.com>
 <20240712083850.4242-3-yongxuan.wang@sifive.com>
Content-Language: en-US
From: Samuel Holland <samuel.holland@sifive.com>
In-Reply-To: <20240712083850.4242-3-yongxuan.wang@sifive.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-07-12 3:38 AM, Yong-Xuan Wang wrote:
> Add entries for the Svade and Svadu extensions to the riscv,isa-extensions
> property.
> 
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> ---
>  .../devicetree/bindings/riscv/extensions.yaml | 28 +++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
> index 468c646247aa..e91a6f4ede38 100644
> --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> @@ -153,6 +153,34 @@ properties:
>              ratified at commit 3f9ed34 ("Add ability to manually trigger
>              workflow. (#2)") of riscv-time-compare.
>  
> +        - const: svade
> +          description: |
> +            The standard Svade supervisor-level extension for SW-managed PTE A/D
> +            bit updates as ratified in the 20240213 version of the privileged
> +            ISA specification.
> +
> +            Both Svade and Svadu extensions control the hardware behavior when
> +            the PTE A/D bits need to be set. The default behavior for the four
> +            possible combinations of these extensions in the device tree are:
> +            1) Neither Svade nor Svadu present in DT => It is technically
> +               unknown whether the platform uses Svade or Svadu. Supervisor
> +               software should be prepared to handle either hardware updating
> +               of the PTE A/D bits or page faults when they need updated.
> +            2) Only Svade present in DT => Supervisor must assume Svade to be
> +               always enabled.
> +            3) Only Svadu present in DT => Supervisor must assume Svadu to be
> +               always enabled.
> +            4) Both Svade and Svadu present in DT => Supervisor must assume
> +               Svadu turned-off at boot time. To use Svadu, supervisor must
> +               explicitly enable it using the SBI FWFT extension.
> +
> +        - const: svadu
> +          description: |
> +            The standard Svadu supervisor-level extension for hardware updating
> +            of PTE A/D bits as ratified at commit c1abccf ("Merge pull request
> +            #25 from ved-rivos/ratified") of riscv-svadu. Please refer to Svade

Should we be referencing the archived riscv-svadu repository now that Svadu has
been merged to the main privileged ISA manual? Either way:

Reviewed-by: Samuel Holland <samuel.holland@sifive.com>

> +            dt-binding description for more details.
> +
>          - const: svinval
>            description:
>              The standard Svinval supervisor-level extension for fine-grained


