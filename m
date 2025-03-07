Return-Path: <kvm+bounces-40417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 218AEA571D9
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:32:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0664C3B3B36
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66221250BFB;
	Fri,  7 Mar 2025 19:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WxH4HCjy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120FD1AA1D5
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741375960; cv=none; b=C/aW00mZz+iGRcgUGkz13/mMCiHI9JevxT1DbTa4uNcLSYycIHp0koIcsylDfPTu3yeT1gLo+esHiMcqAr8DrOZEeiP5ozYhQg/i5Ey3Gu/1tp8Jg1rFrBxhH/myhEr/jq4XoAOyn3xr76qmdc7WN6ynvu9sHMlgw7VtfIS3hEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741375960; c=relaxed/simple;
	bh=HtK6fZimQujKype0r19lWlFwCfanGbqGbMwfFlc25jE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cchG0SFzcmTWq0jlqKq/HlDhvN5QS7BQ3Tup8WL7pG8mCVDv/cQxCVTr/bG9ki15jLFm0tWJV/feV6bH3vCF+HuCTdi7aW+qG5OKquZyA/nPVC65aByvOE1qs7iXwN0hln8vfaZvamA0HTBDIvLZw2ICHAkl3GhN2fF8sh81ePs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WxH4HCjy; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2fa8ac56891so3597840a91.2
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741375958; x=1741980758; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MeKWtiInp5V+cmwwK3Y1NC5YRaGg6vaRs97hD7A0NQA=;
        b=WxH4HCjygpDbu5jjxNaL/4XPfbDh5exv+qV2LVj4Yapejx9gqwEAPnTqrbjPvtdzmb
         0N99ujDM9Uu17l/R7nhMS8jCAJ9l80G5PxHMPh0mHTSJXDCPFuZBvo6AP5A7cq0huTEW
         cMcFSHjaEOkdij5iBK8/5DLVnXRCRep9YGZV4Qj2Lpkul0nbe6+j+iT8IBGodecF5N+A
         3PqH0Y2SuiLhPOcRG56Fb8CZvbtlQEvWgjiSPKOX3iFX+TQ65iNCgpHP4qVNo2UCWYy+
         ZoCS9Zi7VRcfGI5Oc2ISQGTLXZn583SMV+l9PhT3+u1yYdZQ+xsEohmcNtgMNMqTD5Bb
         AJxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741375958; x=1741980758;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MeKWtiInp5V+cmwwK3Y1NC5YRaGg6vaRs97hD7A0NQA=;
        b=hbOAZVUNKdHrBQh4le3JP4oMBRSYsaP+EeGZr21tKxApZPi2JTtr0HZjyqbq9CX5hv
         FxzRmUh4Of9HiCb8Mvu7hK2zKk8CmoUhATASeVFLs5OimU/azQrvXR1eRhKGHf7gInJa
         /8etIy0g4jpV9fJa59NXwKRnslsK+WKH1Gi8VnTlKpfRRT0NrAhoAg29eGbuIwA1acGF
         gt20BVwi2f9gGaY18U4KIOIqBYY3fSaRyyGYiPA01TDXUo92jbJp2orzQpZ0xof4REvf
         PdlI6Rbl0M7hdprwa4u9ar2+C5sbETlc7dBjT/ChPASH38/xhGBgbsNQzKRPbFu5uEOb
         SvTA==
X-Forwarded-Encrypted: i=1; AJvYcCVIS3cGjDcj74v0VQ30fljdCANEO8KVot5u19biL8Tt8+Z13HpVdYt0nYEmvhRcsDAjyQs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHUYCYPIf3QNVwX2Co1tuf4X2XlySa6YO8BL5Le/yISWXPnQy7
	JSQkpsq0mb2lJVbQ12srxlbPqndqHamDQnx8y8wbs+IiR5BORKoHBBoKU5JyNL4=
X-Gm-Gg: ASbGnctumPlc8BdQzytVjmQR3sLWEA44wuAxNuWBOXGKu/yUtHvo14cL4BM1gnILluk
	o0MqLb7xfn4DybrPHSor4z52UcInI4wTqIL41XKn4QdbXT13lut+v8IcYCDFtmSzbSEGjj33w4e
	lIlERNrbA9n7JGf7HqRKbDigSMFMBjq8QJV+M/wOIZwe243hzTY8gtTILKsnlqF+IogHJZJHrrr
	Bi8r9ulBAplHb5GDTa8pnRWkKEm/QpGpsOYLIqN/eV2dqtUMb5UwuBCFj13ENub/UlinaEkCQ9V
	oXi3wPe/FpOIYrdWT0w8YQZ8GwD2ackNY2w8xP5bK1anFj8qBOOf+4t+fg==
X-Google-Smtp-Source: AGHT+IFyYXzUnplKfHzTRwjXR6Pptw2Ed9CumeXy1pPAFDk/GxVx6wFsvOZ3tk3Y0JCtpo/anM2miw==
X-Received: by 2002:a17:90b:4c44:b0:2ee:f80c:6889 with SMTP id 98e67ed59e1d1-2ff7cf22f41mr8270598a91.33.1741375958305;
        Fri, 07 Mar 2025 11:32:38 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109ddffesm34103155ad.40.2025.03.07.11.32.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 11:32:37 -0800 (PST)
Message-ID: <8739f1cd-e2d0-4720-9f72-c7ca60c85d8a@linaro.org>
Date: Fri, 7 Mar 2025 11:32:37 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/7] hw/hyperv/syndbg: common compilation unit
Content-Language: en-US
To: qemu-devel@nongnu.org
Cc: philmd@linaro.org, "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 richard.henderson@linaro.org, manos.pitsidianakis@linaro.org
References: <20250307191003.248950-1-pierrick.bouvier@linaro.org>
 <20250307191003.248950-6-pierrick.bouvier@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250307191003.248950-6-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/7/25 11:10, Pierrick Bouvier wrote:
> Replace TARGET_PAGE.* by runtime calls
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   hw/hyperv/syndbg.c    | 10 +++++++---
>   hw/hyperv/meson.build |  2 +-
>   2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/hw/hyperv/syndbg.c b/hw/hyperv/syndbg.c
> index d3e39170772..ee91266c070 100644
> --- a/hw/hyperv/syndbg.c
> +++ b/hw/hyperv/syndbg.c
> @@ -14,7 +14,7 @@
>   #include "migration/vmstate.h"
>   #include "hw/qdev-properties.h"
>   #include "hw/loader.h"
> -#include "cpu.h"
> +#include "exec/target_page.h"
>   #include "hw/hyperv/hyperv.h"
>   #include "hw/hyperv/vmbus-bridge.h"
>   #include "hw/hyperv/hyperv-proto.h"
> @@ -183,12 +183,14 @@ static bool create_udp_pkt(HvSynDbg *syndbg, void *pkt, uint32_t pkt_len,
>       return true;
>   }
>   
> +#define MSG_BUFSZ 4096
> +
>   static uint16_t handle_recv_msg(HvSynDbg *syndbg, uint64_t outgpa,
>                                   uint32_t count, bool is_raw, uint32_t options,
>                                   uint64_t timeout, uint32_t *retrieved_count)
>   {
>       uint16_t ret;
> -    uint8_t data_buf[TARGET_PAGE_SIZE - UDP_PKT_HEADER_SIZE];
> +    uint8_t data_buf[MSG_BUFSZ];
>       hwaddr out_len;
>       void *out_data;
>       ssize_t recv_byte_count;
> @@ -201,7 +203,7 @@ static uint16_t handle_recv_msg(HvSynDbg *syndbg, uint64_t outgpa,
>           recv_byte_count = 0;
>       } else {
>           recv_byte_count = recv(syndbg->socket, data_buf,
> -                               MIN(sizeof(data_buf), count), MSG_WAITALL);
> +                               MIN(MSG_BUFSZ, count), MSG_WAITALL);
>           if (recv_byte_count == -1) {
>               return HV_STATUS_INVALID_PARAMETER;
>           }
> @@ -374,6 +376,8 @@ static const Property hv_syndbg_properties[] = {
>   
>   static void hv_syndbg_class_init(ObjectClass *klass, void *data)
>   {
> +    g_assert(MSG_BUFSZ > qemu_target_page_size());
> +

Should be >= here.

>       DeviceClass *dc = DEVICE_CLASS(klass);
>   
>       device_class_set_props(dc, hv_syndbg_properties);
> diff --git a/hw/hyperv/meson.build b/hw/hyperv/meson.build
> index c855fdcf04c..a9f2045a9af 100644
> --- a/hw/hyperv/meson.build
> +++ b/hw/hyperv/meson.build
> @@ -1,6 +1,6 @@
>   specific_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'))
>   specific_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
>   system_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
> -specific_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
> +system_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
>   specific_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'))
>   system_ss.add(when: 'CONFIG_HV_BALLOON', if_false: files('hv-balloon-stub.c'))


