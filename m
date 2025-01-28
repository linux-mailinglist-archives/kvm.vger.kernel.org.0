Return-Path: <kvm+bounces-36800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABF9BA2133E
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 21:52:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D95543A7696
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 20:52:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E1721E008E;
	Tue, 28 Jan 2025 20:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aJoEShfv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01C1199EAF
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 20:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738097564; cv=none; b=lT4kZ2G4+noFdVQs8VOrkpvW9kK7dg+81R+ymlefFBk0gHyNaddI1wEQuR7ss0Pp7BYzLoq0HJUuwPmjUYQ3TIVfU4ex5jmcd4moj5Ik0JoIJHymS8Qx7gmJs9+VbAz/vDOQ/XbbK5bEMDsq4WXVJdf8//5/o12DofpNn4We1Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738097564; c=relaxed/simple;
	bh=ru2gAsxMeOMjM0rOu77co7cs9CuXJqKqvt+ygZsdbvQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PSxsL1dmutxISYysX5kgihkjUAv1cSRNSykoiIEEdVmYUEIozPiccTacTFldDVKp4nJ7pN3gCh53E0A0ycZDhgd3l9JcXcgqJTT3YXFbt983yxnEKX979/6bRu47UdlPqjxhiQdPXeUtadM1qTsvCaFfkWOEblVzkAQLZa/Vdfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aJoEShfv; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-216281bc30fso36723545ad.0
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 12:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738097562; x=1738702362; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+AY5k8k+TxGfxhluS8BQjjUBCxahKfmtXeetBu/eOuo=;
        b=aJoEShfv926FxOvU5BFLbFE4VzNV3jfwDm3tn0R5rAkzquIDkR3Zbg3FHZDYNE0XdM
         97gHF+lctvA1Di/Q0ZCeX5Vz0kRyyoyJ++Hwws/GqscUgam7BJsBlOnjvQzHNtelx28B
         KXl25jxjTUQqtxgaEQSGIRBCoDcBNqbXSaSCQdMWrmVusnMDXsGxgbRril0KSg5DFXaG
         +uFAIhzAhpVLZ0XcXge/OHtnFHfAhYbkNkPR+J3nrni/sgZKY9dVhfYycyH4Ipumj9oD
         UbJIh6m2rNh2NfE7SrSQbC4zfVQSOYL4o9XOKXfoL3ae18nq0+KF2H8WpgpNXf/Sdi1Y
         kewQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738097562; x=1738702362;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+AY5k8k+TxGfxhluS8BQjjUBCxahKfmtXeetBu/eOuo=;
        b=KNsMqVqv6UJf5BjPVWMPYTSSwxB89+ktXYv0LQuj19l+LhTk11C1biPqWEwy6IpIEk
         QoFgUD5Ii4DpmaNiI31bflEPMqeOfBZ1lGjLHA78oqmfzvpv9/+6e43R6DpRVRj0DWMI
         oeYS6T7O7waSj5x99q8xp/88eEz9WBG1WKEGUpAYqrs8gSFrM0yU4mJwpuVXjlMM1jvD
         rF5s+PWFdcHptgMq7zbammK0G4OOpLI25AHO284S+w3I7W1ufUBfZJlpwBuspww+qUhv
         VVBY529ULTmpLB7hSOLr0e31NGQk+HtHjqn9iwozSXyidTBwMYEvhLQCYho2eZK9XABQ
         DsjA==
X-Forwarded-Encrypted: i=1; AJvYcCWiG4F/x0R2IGgoc8iQ8FukVTmEQdRSOU7siZcK0qNL/n+HWjt9CKIQ6GUAYPQc1PMEwHo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsHGatbSCJHCrEtyE9prtODiFwjfSmL1hOmTM7PBaSJVyO5KI9
	Bkt1goFtP4kqZI6JorFi4GERB+gId3168vltdsXi/QRHV13RjpdiP2iCW6XanJ8=
X-Gm-Gg: ASbGncuFlH0/gduf30Zhc8PZh3yVpMxFADQCH0b6cjB0MmY0FO/Qk6MVCxlPZ/6oriv
	JWamOH9lXpYDyIutuPm1QELIdwUdefy4ZwwSvVI90WY0Qo85QCDlVbnWZPnF6uzWTyG2TI1QgKl
	UvgEvyV5rSSbsNk431qjV1mro1pvJLKnvXlT7Z8XjjqJCSUxKYeX6r9PFrKkYSewHAZIVj6dEB9
	mpfsDcz9ZMti57U9QCaYQyRvDJsN55HKv+TQCllGQbb/9Z2YyymwxEH6dnLel5ABLJUcGtrysi9
	QLGL7hvLtNTcJv4leOD/Uhhi6K+C7g7mKTuoQ6V/ObtdXDW9PsZpQOpiCWvNy2qVj2xO
X-Google-Smtp-Source: AGHT+IHX2b3c+1wIXKNlrq6ihzfzwVqiA1uBVnrtcveXRo1EFuqKfUsw89gpnINxgCOGI5vhU71s/g==
X-Received: by 2002:a05:6a21:1807:b0:1e1:932e:b348 with SMTP id adf61e73a8af0-1ed7a6236eamr1093398637.41.1738097561894;
        Tue, 28 Jan 2025 12:52:41 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a78dfa2sm9626014b3a.157.2025.01.28.12.52.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2025 12:52:41 -0800 (PST)
Message-ID: <b7646baf-a07d-4ded-804c-6809173c1f6b@linaro.org>
Date: Tue, 28 Jan 2025 12:52:39 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/9] hw/qdev: Introduce DeviceClass::[un]wire()
 handlers
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Eduardo Habkost <eduardo@habkost.net>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, kvm@vger.kernel.org,
 Zhao Liu <zhao1.liu@intel.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Peter Xu <peterx@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20250128142152.9889-1-philmd@linaro.org>
 <20250128142152.9889-5-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250128142152.9889-5-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/28/25 06:21, Philippe Mathieu-Daudé wrote:
> We are trying to understand what means "a qdev is realized".
> One explanation was "the device is guest visible"; however
> many devices are realized before being mapped, thus are not
> "guest visible". Some devices map / wire their IRQs before
> being realized (such ISA devices). There is a need for devices
> to be "automatically" mapped/wired (see [2]) such CLI-created
> devices, but this apply generically to dynamic machines.
> 
> Currently the device creation steps are expected to roughly be:
> 
>    (external use)                (QDev core)                   (Device Impl)
>     ~~~~~~~~~~~~                  ~~~~~~~~~                     ~~~~~~~~~~~
> 
>                                 INIT enter
>                     ----->
>                           +----------------------+
>                           |    Allocate state    |
>                           +----------------------+
>                                                   ----->
>                                                          +---------------------+
>                                                          | INIT children       |
>                                                          |                     |
>                                                          | Alias children properties
>                                                          |                     |
>                                                          | Expose properties   |
>                                  INIT exit               +---------------------+
>                     <-----------------------------------
>   +----------------+
>   | set properties |
>   |                |
>   | set ClkIn      |
>   +----------------+          REALIZE enter
>                     ---------------------------------->
>                                                         +----------------------+
>                                                         | Use config properties|
>                                                         |                      |
>                                                         | Realize children     |
>                                                         |                      |
>                                                         | Init GPIOs/IRQs      |
>                                                         |                      |
>                                                         | Init MemoryRegions   |
>                                                         +----------------------+
>                                 REALIZE exit
>                     <-----------------------------------                        ----  "realized" / "guest visible"
> +-----------------+
> | Explicit wiring:|
> |   IRQs          |
> |   I/O / Mem     |
> |   ClkOut        |
> +-----------------+             RESET enter
>                      --------------------------------->
>                                                         +----------------------+
>                                                         | Reset default values |
>                                                         +----------------------+
> 
> But as mentioned, various devices "wire" parts before they exit
> the "realize" step.
> In order to clarify, I'm trying to enforce what can be done
> *before* and *after* realization.
> 
> *after* a device is expected to be stable (no more configurable)
> and fully usable.
> 
> To be able to use internal/auto wiring (such ISA devices) and
> keep the current external/explicit wiring, I propose to add an
> extra "internal wiring" step, happening after the REALIZE step
> as:
> 
>    (external use)                (QDev core)                   (Device Impl)
>     ~~~~~~~~~~~~                  ~~~~~~~~~                     ~~~~~~~~~~~
> 
>                                 INIT enter
>                     ----->
>                           +----------------------+
>                           |    Allocate state    |
>                           +----------------------+
>                                                   ----->
>                                                          +---------------------+
>                                                          | INIT children       |
>                                                          |                     |
>                                                          | Alias children properties
>                                                          |                     |
>                                                          | Expose properties   |
>                                  INIT exit               +---------------------+
>                     <-----------------------------------
>   +----------------+
>   | set properties |
>   |                |
>   | set ClkIn      |
>   +----------------+          REALIZE enter
>                     ---------------------------------->
>                                                         +----------------------+
>                                                         | Use config properties|
>                                                         |                      |
>                                                         | Realize children     |
>                                                         |                      |
>                                                         | Init GPIOs/IRQs      |
>                                                         |                      |
>                                                         | Init MemoryRegions   |
>                                                         +----------------------+
>                                 REALIZE exit       <---
>                           +----------------------+
>                           | Internal auto wiring |
>                           |   IRQs               |  (i.e. ISA bus)
>                           |   I/O / Mem          |
>                           |   ClkOut             |
>                           +----------------------+
>                      <---                                                       ----  "realized"
> +-----------------+
> | External wiring:|
> |   IRQs          |
> |   I/O / Mem     |
> |   ClkOut        |
> +-----------------+             RESET enter                                    ----  "guest visible"
>                      --------------------------------->
>                                                         +----------------------+
>                                                         | Reset default values |
>                                                         +----------------------+
> 
> The "realized" point is not changed. "guest visible" concept only
> occurs *after* wiring, just before the reset phase.
> 
> This change introduces the DeviceClass::wire handler within qdev
> core realization code.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/hw/qdev-core.h |  7 +++++++
>   hw/core/qdev.c         | 20 +++++++++++++++++++-
>   2 files changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/include/hw/qdev-core.h b/include/hw/qdev-core.h
> index 530f3da7021..021bb7afdc0 100644
> --- a/include/hw/qdev-core.h
> +++ b/include/hw/qdev-core.h
> @@ -102,7 +102,12 @@ typedef int (*DeviceSyncConfig)(DeviceState *dev, Error **errp);
>    * @props: Properties accessing state fields.
>    * @realize: Callback function invoked when the #DeviceState:realized
>    * property is changed to %true.
> + * @wire: Callback function called after @realize to connect IRQs,
> + * clocks and map memories. Can not fail.
> + * @unwire: Callback function to undo @wire. Called before @unrealize.
> + * Can not fail.
>    * @unrealize: Callback function invoked when the #DeviceState:realized
> + * property is changed to %false. Can not fail.
>    * property is changed to %false.
>    * @sync_config: Callback function invoked when QMP command device-sync-config
>    * is called. Should synchronize device configuration from host to guest part
> @@ -171,6 +176,8 @@ struct DeviceClass {
>        */
>       DeviceReset legacy_reset;
>       DeviceRealize realize;
> +    void (*wire)(DeviceState *dev);
> +    void (*unwire)(DeviceState *dev);
>       DeviceUnrealize unrealize;
>       DeviceSyncConfig sync_config;
>   
> diff --git a/hw/core/qdev.c b/hw/core/qdev.c
> index 82bbdcb654e..38449255365 100644
> --- a/hw/core/qdev.c
> +++ b/hw/core/qdev.c
> @@ -554,6 +554,15 @@ static void device_set_realized(Object *obj, bool value, Error **errp)
>               }
>          }
>   
> +        if (dc->wire) {
> +            if (!dc->unwire) {
> +                warn_report_once("wire() without unwire() for type '%s'",
> +                                 object_get_typename(OBJECT(dev)));
> +            }
> +            dc->wire(dev);
> +        }
> +
> +        /* At this point the device is "guest visible". */
>          qatomic_store_release(&dev->realized, value);
>   
>       } else if (!value && dev->realized) {
> @@ -573,6 +582,15 @@ static void device_set_realized(Object *obj, bool value, Error **errp)
>            */
>           smp_wmb();
>   
> +        if (dc->unwire) {
> +            if (!dc->wire) {
> +                error_report("disconnect() without connect() for type '%s'",
> +                             object_get_typename(OBJECT(dev)));
> +                abort();
> +            }
> +            dc->unwire(dev);
> +        }

Mismatched error messages (wire vs connect).
But, really, just check both directions properly at startup.
There's probably lots of places where devices are never unrealized.

Otherwise, this seems sane, having a kind of post_init on the realize path, running after 
all superclass realization is done.


r~

