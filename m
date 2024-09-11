Return-Path: <kvm+bounces-26460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D01E974A29
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 08:12:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C16121C21532
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 06:12:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C2DE762EF;
	Wed, 11 Sep 2024 06:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LroXdTWI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902DA4D9FB
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 06:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726035171; cv=none; b=D1DqMFM7SGG/aae+1Rp6uxDDaDUu3NKWxqPO0mQmq7K6OtYbC45LjY4H1e+enevAHjVXeknXv2Si6hO5seFNeULHiCEw0VaiA4DSzce5Nrjr8eD4/Kq5aQBSDmXuiCyTvZPwoiTIxNBYz4DoyXknhO8QJ6rxTuoFy0VmbkLbcZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726035171; c=relaxed/simple;
	bh=+nCIQgLqe54ZoFoRYt9D+ZzVJ82cdezdkEaOtqt2nJE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PZEdfJYxXddmlzm3puMDW3lr+DtSvMmjcLihOK7KzHKKKDCSmvRFJzPYHZsIFS74L68q4yR9qU40q82u053b9KPMcAGIjH0R+phiG+/IeOg5Iv9byObGAty8+z3+i0QS46diIMjzm7vBUUIbiiNJNprDIgMCenK4th1KWSHMJ0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LroXdTWI; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-42cb6f3a5bcso38287745e9.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726035168; x=1726639968; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TL/lFv17AlRRni3BjvbBzcjoUvGtXN+SvzpuJVUHQg8=;
        b=LroXdTWI0RxDeb9YKaLcziZgSYcbHA4si8NVdMxsY7PvtkfwSB4kh4DKSjYmmJSx4T
         fnIQ2mK+HvaouHkdVruE/WPyT4bpv9BJEqKGReuAoT/rYqsqzl+7oeKBWCdCb42eEOD2
         JqygIGcFxyXTrPA9mb3sDvIHQlWloBS3ZjH3k+h6IH/y7dDvucdVMdxGGj+E+eOGeqrX
         EjNvNCNQQ0S93TZrf7otez4dzU9afGAti1fubUSIAQNO3lbXPtqDIrf6SWQ/8EnkBm37
         VuZHOW1CBtxNTeo3fXosaNr8MGvU34P1MYM+JHrELlJSJ5c82MuK+/ouJB7W5FJfZkXo
         xNxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726035168; x=1726639968;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TL/lFv17AlRRni3BjvbBzcjoUvGtXN+SvzpuJVUHQg8=;
        b=BnJs85+hqNCqRk1NC8/KaliuKYIMNLOqHoJ6fIq749B3i/vAQRWrhWQaqBKl+shJMS
         lyWZd9jCLUiWrhhYAjOBpIK/AoainYU5LcyGXx3jaiZCZPfV8p9sqy47Rzm/1k5OPF46
         4qhmpeMZt4o6ZHk7NrIH7wvzijm/rSoUSk2UPM+BWIX3NPtmSUv+coCz9Dec/wc0ewUL
         7cxqKKWuTaV3MR6L2mfrmkfu764vavBXtZmOGn2O4YxJFDOGqA5+UOHZ3xg9ey1ABqD9
         ijxl5HZ90T+COEtuiduDx4Snvde4gdjCTi9cQ/XMzwvGFZw7CHMVt4wez1LkDPMSXXVo
         X2lg==
X-Forwarded-Encrypted: i=1; AJvYcCX+slvS8c8c8UCloGure5arIhiDnqbl3f76bvb0HgNkB2OEB+yErd98XcUMIk1MG7WtmeE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdJXsdTNS/QB5mcZ+HS4nMht6eox1oB/9kEt/09IALawwMZq27
	DegXO2MHaoiQnjje0wnG7elmlZMRfhuVu8/fKVCA14oAdiJkTGWziaGH9WJE6aE=
X-Google-Smtp-Source: AGHT+IEc72IfoqLgZowTqWigpNIlUglrPLMS84A16dLv8yLW+1D3kLeBnbG++tZCCJ+vQoNT+RC+RQ==
X-Received: by 2002:a5d:6a0b:0:b0:374:c616:54b2 with SMTP id ffacd0b85a97d-378922a6a85mr12171475f8f.19.1726035167475;
        Tue, 10 Sep 2024 23:12:47 -0700 (PDT)
Received: from [192.168.69.100] ([176.187.196.107])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25cefa24sm581411166b.178.2024.09.10.23.12.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 23:12:46 -0700 (PDT)
Message-ID: <f6db8937-35f5-4ac2-ae78-d5043cf5d440@linaro.org>
Date: Wed, 11 Sep 2024 08:12:38 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/39] system: replace assert(0) with
 g_assert_not_reached()
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>, "Richard W.M. Jones" <rjones@redhat.com>,
 Joel Stanley <joel@jms.id.au>, Kevin Wolf <kwolf@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Corey Minyard <minyard@acm.org>, Eric Farman <farman@linux.ibm.com>,
 Thomas Huth <thuth@redhat.com>, Keith Busch <kbusch@kernel.org>,
 WANG Xuerui <git@xen0n.name>, Hyman Huang <yong.huang@smartx.com>,
 Stefan Berger <stefanb@linux.vnet.ibm.com>,
 Michael Rolnik <mrolnik@gmail.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Markus Armbruster <armbru@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, qemu-riscv@nongnu.org,
 Ani Sinha <anisinha@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Jesper Devantier <foss@defmacro.it>, Laurent Vivier <laurent@vivier.eu>,
 Peter Maydell <peter.maydell@linaro.org>, Igor Mammedov
 <imammedo@redhat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>, Fam Zheng
 <fam@euphon.net>, qemu-s390x@nongnu.org, Hanna Reitz <hreitz@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>, Eduardo Habkost <eduardo@habkost.net>,
 Laurent Vivier <lvivier@redhat.com>, Rob Herring <robh@kernel.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, qemu-block@nongnu.org,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Fabiano Rosas <farosas@suse.de>,
 Helge Deller <deller@gmx.de>, Dmitry Fleytman <dmitry.fleytman@gmail.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 David Gibson <david@gibson.dropbear.id.au>,
 Aurelien Jarno <aurelien@aurel32.net>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Yanan Wang <wangyanan55@huawei.com>, Peter Xu <peterx@redhat.com>,
 Bin Meng <bmeng.cn@gmail.com>, Weiwei Li <liwei1518@gmail.com>,
 Klaus Jensen <its@irrelevant.dk>,
 Jean-Christophe Dubois <jcd@tribudubois.net>,
 Jason Wang <jasowang@redhat.com>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
 <20240910221606.1817478-11-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240910221606.1817478-11-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/9/24 00:15, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   system/rtc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


