Return-Path: <kvm+bounces-64466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 69C5EC83744
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 07:22:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id DE04334958C
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 06:22:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C68A283FDD;
	Tue, 25 Nov 2025 06:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F5H5p29u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3811F8BD6
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 06:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764051747; cv=none; b=oJrPkVdYaJei7vfNoiGOuUnsgu/Z74brAu6ujN3vVVDsfIb5vzY5h7WiKLIeuy6YjSdtVS86yFN1XHZDKEopuFqZpdpffXAWH9c7yM0LU6xQ9HbIj4QJ6kcGyJK819H3Tq6ahDwS62RxcB/Mn4PfH8bnpVuw4EBkyqTsNTqszk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764051747; c=relaxed/simple;
	bh=M13F+rhVlXBntSfrJ5IrHs4mLOLffoO4KnGlWgu4+TA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l14r+zApyI/VT/dAk7ZN2a3UNPxXC7lwZGdTaAQqQd2cYmhs8F0SqkdAhyWm0v8PgDGIQQxeQPQzoVKHSN3R/Qf27ihX2DWeMDMNnPrevCELKHZGXtIiy+wgGLbma2FZtaDFkOr3ezyMx6SwHi5/6uxSKSy9OYlzyJ1bTuQ6nWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=F5H5p29u; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47755de027eso26947645e9.0
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 22:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764051744; x=1764656544; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f9PMY82i/jaFQBwB85/CZ8mIcoZUJob2eOmqwSq7Cyo=;
        b=F5H5p29u8sMdphyAP8SBkZl6jaIYNBkezTpntNawnukXeg4KBHU4gNwyfXFliqbmGI
         cxegfoTabk6saUYUP4T4JzeR9uSCPBkrcybdUFTxS2bSwQGMwIa97Tg5sRUXbOK/xfWn
         2p3P0ai5QE30TkUf7RbbQxGsvnPNoKjE9GSefFI3imPd4ce46jypp55wNRC82JSFNwt6
         7VlirPN9UFAiFATJ5SP8fYzQNMy1XHhcLQZ+LiTgNBYQNardS3Ap1fw7phmjiq7y/Yc2
         rTZeEAkuNsa6ZYLSegjUZ9yoE0HHs56e64dy2yXbh+5wcldNwAH2PvUP3Ozm+oNeH+Vs
         yZ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764051744; x=1764656544;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f9PMY82i/jaFQBwB85/CZ8mIcoZUJob2eOmqwSq7Cyo=;
        b=HH1exKOMMp+A6LdgCOmUqynh0BtuGq/ZPyWUokJ02z8TJgHtWLGw5o0Vwz39vVsEDJ
         H/DmZWVXbCyUtonVsUNlNESX7zZ7tEEFI4V3wvhkm2TzDbQxf6CIhs3os1rUt4lgdhUr
         FLVcXCPfYkQtcTFViug0tQDHiSCNhY3RSmuLvrjor/1UtJ0JzRHKzX8XakFwZ9nIYR3Y
         ygNSuhVrgDSKY/Xjse19uLXF9jXVz0ggpqDBdG51T9byGhaMLhB5OdTN9xLEd8+wQ5ZG
         DYuagiM8uXyXEgmY0lXo/aO29UI3Hjwu8VmQ2K5XgQ4nLBekPoNP+RiIUuwUXWKlUXK9
         2b/g==
X-Forwarded-Encrypted: i=1; AJvYcCX0HgiVeoMPpasDOFizx7bfbulgokwWnn1LWb3R22hYbOJMVuIQffXxfUMAQTLWnsiYpi4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9FiF3xZ1QpycMz3GbedH1T23/TcTDLvdPP821A58p0DgGjT4E
	xpw02O2E6StuvpsgbFyh/ZPm8yoUxtn4xCbcbE46z0HsiuTeX3xYgl8CUF2QtatyUR0=
X-Gm-Gg: ASbGncuVGWdHSUQWnb61ir1FUrd2mx0jNosZK31fSr14BfDXPFOUISUpwUfmNZnLFpx
	QmPVIgFHUZ66Wuu7tkqboSjPri1D46oQRXDgteniVuSrMiHJNiyL5biYzkftCX+q9SakhwIO3sg
	+E+ev8iGCgkZYWyfhg9kl8zigN4Id+NRqwZWH/CSEa3jXeX2LRclhgsQ9SHJj2Kdg+HbiPj/WVv
	N3+aMda8WFa8YUivWmrLTDqZC7ia46/MvdnPqystjWIjg31gbFaBzK/fDyMrEl6Y6M7pyUbDUZ3
	9oELBy/cNSV6hrvw2rzWTPVbkth8/dXddRkaeTSfGUJAaw4hoAGnK0ZwZSRogM6h41DmyBYYy3J
	qK5HLRCf9h1ZQ64vAfa06BH+xJw7uMpvpcPuLZxZUnJi2klGa3a8+VOzrZ6jQ0qCmUAelill4TJ
	wTuKNeLfMnIy2eI3IgYHUbZuNhAx/ASSaaCguxfuW++Wmixhx3gVIF8g==
X-Google-Smtp-Source: AGHT+IFDchfo8wmvxExDOTScFL75Y50QSTKmA05qmrURNbKfXMlTq1TI/FEAoocUx4gEjb2eI/uz8Q==
X-Received: by 2002:a05:600c:1c87:b0:477:98f7:2aec with SMTP id 5b1f17b1804b1-47904acef12mr14222015e9.3.1764051743857;
        Mon, 24 Nov 2025 22:22:23 -0800 (PST)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477c0d85360sm227844905e9.15.2025.11.24.22.22.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Nov 2025 22:22:23 -0800 (PST)
Message-ID: <f992f60b-515f-4834-88fd-d033255bed83@linaro.org>
Date: Tue, 25 Nov 2025 07:22:20 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/15] error: Use error_setg_errno() to improve error
 messages
Content-Language: en-US
To: Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org
Cc: arei.gonglei@huawei.com, zhenwei.pi@linux.dev, alistair.francis@wdc.com,
 stefanb@linux.vnet.ibm.com, kwolf@redhat.com, hreitz@redhat.com,
 sw@weilnetz.de, qemu_oss@crudebyte.com, groug@kaod.org, mst@redhat.com,
 imammedo@redhat.com, anisinha@redhat.com, kraxel@redhat.com,
 shentey@gmail.com, npiggin@gmail.com, harshpb@linux.ibm.com,
 sstabellini@kernel.org, anthony@xenproject.org, paul@xen.org,
 edgar.iglesias@gmail.com, elena.ufimtseva@oracle.com, jag.raman@oracle.com,
 sgarzare@redhat.com, pbonzini@redhat.com, fam@euphon.net, alex@shazbot.org,
 clg@redhat.com, peterx@redhat.com, farosas@suse.de, lizhijian@fujitsu.com,
 dave@treblig.org, jasowang@redhat.com, samuel.thibault@ens-lyon.org,
 michael.roth@amd.com, kkostiuk@redhat.com, zhao1.liu@intel.com,
 mtosatti@redhat.com, rathc@linux.ibm.com, palmer@dabbelt.com,
 liwei1518@gmail.com, dbarboza@ventanamicro.com,
 zhiwei_liu@linux.alibaba.com, marcandre.lureau@redhat.com,
 qemu-block@nongnu.org, qemu-ppc@nongnu.org, xen-devel@lists.xenproject.org,
 kvm@vger.kernel.org, qemu-riscv@nongnu.org
References: <20251121121438.1249498-1-armbru@redhat.com>
 <20251121121438.1249498-13-armbru@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251121121438.1249498-13-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/11/25 13:14, Markus Armbruster wrote:
> A few error messages show numeric errno codes.  Use error_setg_errno()
> to show human-readable text instead.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>   backends/cryptodev-lkcf.c   |  2 +-
>   hw/ppc/spapr.c              |  6 +++---
>   hw/vfio/migration-multifd.c |  5 +++--
>   migration/rdma.c            |  3 +--
>   net/l2tpv3.c                |  6 ++----
>   target/riscv/kvm/kvm-cpu.c  | 11 ++++++-----
>   6 files changed, 16 insertions(+), 17 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


