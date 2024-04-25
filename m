Return-Path: <kvm+bounces-15894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5A8C8B1C6E
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 10:06:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E84B61C21392
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 08:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5C556EB5B;
	Thu, 25 Apr 2024 08:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sjvE5gwy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9851EB48
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 08:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714032379; cv=none; b=kFoVLBQ2WMXK3Q1V3VSVH8hU1PHsq6zlnvDNCrxINgNgNMBbd+mP5evef9RcBYcaWMwaDcf9kA9J8PPQUc/YHzeJtBil7zpbunRN6ljOBfcncOqVYNoNXt8bthDAWiSvI7SlikZmMVqdVN2q/vkxjGWe8zZbaAn9IWcm2EPtlno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714032379; c=relaxed/simple;
	bh=XnVkaeXi6jkA3Q8JMwm3VIBeCahgb1HJbV0MMahy1fA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r1x8TKgkl6fMBS77lH5VDG0ug7uBJfxl2MIGx+5lSM9wziaRAHHtGtvmCaMjkd56GQsLEqmh60sl61sLQnFC3Jm9yiJ4YZsWd+RtMx17hQsU9sah2evvGEwam9L5JNakn0jLUk4lJ6l1/25B+uANV1Tq2S6ZxHVl5jrB29AGefo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sjvE5gwy; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2db101c11beso7156781fa.0
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 01:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714032375; x=1714637175; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iCdKGBl8MCWSdClEAgreA+ZkX6CtItXZ5VVpZBsUrJY=;
        b=sjvE5gwyh5tMJgvGNkrbfYZoAAiqEgzV+Nm41Yylkiu2Oy/pJaTJs77vcrdJylr7z0
         B5dSi2Z9wF4DyG55VawMsNy359Ng2XaaD1VpN+W/8bp2/Q/76dMMCPEJX3bOFfYCYRKb
         kRN705KI6x2aqtNTJWRM3gSHrKSJyLM4npHDr7edeJlyUz9Q6OOd9pGXwItHLX0Y2quB
         Vko+LUoJaE9cYzZYZT24Ohy5brvQEN+bUDYapmVIy1fHR6VDIhlfOdXSzcEnaCsfAjF3
         URxozzkjGFY/YxNEPy6wr5rVzxuMhCk2XRzR4+cWrvDk4eeP9n57vVVlHNnP2THCMrWv
         cHZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714032375; x=1714637175;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iCdKGBl8MCWSdClEAgreA+ZkX6CtItXZ5VVpZBsUrJY=;
        b=SpbeyfANEetulgY0kmd4BY7FaHdgZ9dNbcXJMsQPkkqzaU6FI1ARvDUDqyCipvUMlW
         32hLlzar+kuz3kUoMaIygg2xnPLOOG1ZaE0hBepOdY6CqNLGeVqKUK5XFE3FCo5V06Tt
         9aXtUPrg4aa1JWU+a9o+a4sJaUggrPYKXbLXvZVRlGvU9kLWAOs1EFCHOEq8FBpeHmdW
         KELjdIiDSZkTr7xNcLvXle5d5774yD15ZHWY++FkYLn9VPpDUzugC4eObzWvAcwVbnqQ
         edemRTIHJIymk1p4OZXDFcFgVAycyiDXRoJMAqYM2lhY81/a+L8V4GXBtI3Ce9TrShAb
         tL/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXCQv2kjcdHUCuiqcRCHvu0uxTthsYeyjuZLtZqHvAc8dvubK/Zm+q3310kBPfWo0Pi/b6NQ6mdKS3PsWb3TCilnmhK
X-Gm-Message-State: AOJu0YwGz4hjKsoPruOTudXu8B624Xy4a9v/Ahm6C1z0jGfIET5hW1jc
	4IqGEb7DP8eNKOUe3nlbnK+5pJvF/BdfnWKXAZcyuw1bGV80TLqe12kemC2XmLc=
X-Google-Smtp-Source: AGHT+IEb4+fND5ZU/0fnVUcIFg/IIv1B6MFauRzoNd2D1aWZh7NEqWTW+bH4oFShfqLEyzeM1ITtrQ==
X-Received: by 2002:a2e:9c45:0:b0:2d8:7363:ff36 with SMTP id t5-20020a2e9c45000000b002d87363ff36mr2950018ljj.37.1714032375510;
        Thu, 25 Apr 2024 01:06:15 -0700 (PDT)
Received: from [192.168.69.100] ([176.187.197.201])
        by smtp.gmail.com with ESMTPSA id w20-20020adfe054000000b0034a366f26b0sm17489992wrh.87.2024.04.25.01.06.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Apr 2024 01:06:15 -0700 (PDT)
Message-ID: <a76a987f-3ea2-4c48-bc02-74ab42fd3c01@linaro.org>
Date: Thu, 25 Apr 2024 10:06:11 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/21] i386: Introduce smp.modules and clean up cache
 topology
To: Zhao Liu <zhao1.liu@intel.com>, Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?=
 <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Zhuocheng Ding <zhuocheng.ding@intel.com>, Babu Moger <babu.moger@amd.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>,
 Yongwei Ma <yongwei.ma@intel.com>
References: <20240424154929.1487382-1-zhao1.liu@intel.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240424154929.1487382-1-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Zhao,

On 24/4/24 17:49, Zhao Liu wrote:

> ---
> Zhao Liu (20):
>    hw/core/machine: Introduce the module as a CPU topology level
>    hw/core/machine: Support modules in -smp
>    hw/core: Introduce module-id as the topology subindex
>    hw/core: Support module-id in numa configuration

To reduce this series size, I'm taking these 4 patches to via
my hw-misc tree.

Regards,

Phil.

