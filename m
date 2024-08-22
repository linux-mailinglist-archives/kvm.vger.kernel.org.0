Return-Path: <kvm+bounces-24843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D0E295BE2B
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 20:22:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9468A285712
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 18:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A948F1D1734;
	Thu, 22 Aug 2024 18:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b="BjZgmJnz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313901D0DCE
	for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 18:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724350878; cv=none; b=hMO4+zqNarPEF7NCKCBMQtQztPIz2wdtuOzhtZx2gMJSmLmSukhvDibAmGG9e6A1JQFwKtFaZ80llL20FEm/fb67uvZdbqB27zWzP901N258kzecK3fHRbsgZt7nptsTQy89X5tKSdHQG02oiTICorLhls5Nu0Y8RSZuTvFUDow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724350878; c=relaxed/simple;
	bh=RLs+TgOeDB9U+OeJ5ILJJE/1qQupOxoL4NtsHLcUl2s=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=Cz3lpDS3EgRqWEUSBNxWxyT4BOab7kOAQwhYVfV1WerUV303e+fjxAImZxBR8w1sJDBTTU6swlvrlGq2rv/d5tBfsgJjoEevIz65X0cvx1PG9G0w1qdF2R1umeqHPLm5IgvQeFqt8WjktH9ZMaE6xiHhdt02by+OC0pvVjVVgiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=digitalocean.com; spf=pass smtp.mailfrom=digitalocean.com; dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b=BjZgmJnz; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=digitalocean.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digitalocean.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-6b2e6e7ad28so18455397b3.0
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 11:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google; t=1724350876; x=1724955676; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RLs+TgOeDB9U+OeJ5ILJJE/1qQupOxoL4NtsHLcUl2s=;
        b=BjZgmJnzgKmTy9uPpQxTpyyohGj/7FztpcBZoNI+XvVk1sYuQnCNZ/jtDlz8wGECdB
         9yeSLdZWvtkStppTav2cv1269PQ8dvT42o+OUC/zlQ4TruNwNMxgrSlYrFoN7lPeQYwC
         +s0SmlGzwisHwmaEDV62XgPl4hedgsKL5Xaz8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724350876; x=1724955676;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RLs+TgOeDB9U+OeJ5ILJJE/1qQupOxoL4NtsHLcUl2s=;
        b=bJ3kp36CeLGBnBmmKzOtOaV1WM1H1jTRtcs0GclPEb9ufEFu4PTRbBr+AgCaVjUnxJ
         T0Dmzz/jE6toppsgrWVsMhOdwr8KVJ74QYLlAxx3m66Dw8vCI456m2o0epWWYeemM3b8
         HGG6k8+MeVG+V/xh/Z7dK/dhM7s6yNsgFyfnLGpisTPe472jh/gaRxQGYgV79xd2/Ppr
         zbqwVrNDdVVRttzOGP4F13lG4XzY8IFklMG/03S4FWWZwFaXhNb+vORyFobI9TQBNlJ3
         nHAk5PTiNJR6NESxY6klGwo38+efkBykv5SpGyW3hXqohj+H2WakkP3wzS55XcKCCvuo
         HEMw==
X-Gm-Message-State: AOJu0Yzz2WjDhdPmTIOGDsX0UeoXtB3QV8NjJwssw6v+QmCCP9/r2WDY
	abohZE5Oaa+6WFjJ1lMlo2IM1tdrRbjgDWiNbvX7f0VElyFXDAMZnhG/+4pL1S0=
X-Google-Smtp-Source: AGHT+IHtXIMIiSwuBpmYLdcwUNBMd26Nuu8pfXN1VwE1UCqgTVayCXIzfx3aHHiMJ03T6ZoVnLerIw==
X-Received: by 2002:a05:690c:6d8c:b0:665:71a4:21ac with SMTP id 00721157ae682-6c303cf699fmr39887947b3.10.1724350876111;
        Thu, 22 Aug 2024 11:21:16 -0700 (PDT)
Received: from ?IPV6:2603:8080:7400:36da:45f:f211:3a7c:9377? ([2603:8080:7400:36da:45f:f211:3a7c:9377])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6c39a7525bdsm2992047b3.31.2024.08.22.11.21.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2024 11:21:15 -0700 (PDT)
Message-ID: <4f4572c8-1d8c-4ec6-96a1-fb74848475af@digitalocean.com>
Date: Thu, 22 Aug 2024 13:21:13 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: virtualization@lists.linux-foundation.org, mst@redhat.com,
 jasowang@redhat.com
From: Carlos Bilbao <cbilbao@digitalocean.com>
Subject: [RFC] vDPA: Trying to make sense of config data
Cc: kvm@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello folks,

I'm using the code below to retrieve configuration data for my vDPA file
via ioctl. I get as output:

Configuration data (24 bytes):
5a c3 5f 68 48 a9 01 00 08 00 dc 05 00 00 00 00
00 00 00 00 00 00 00 00
ASCII representation:
Z._hH...................

Could a good Samaritan point me in the right direction for the docs I need
to understand these values and convert them to a human-readable format?
hank you in advance!

Regards,
Carlos

---

void check_config(int fd) {

    uint32_t size;
    struct vhost_vdpa_config *config;
    uint8_t *buf;

    if (ioctl(fd, VHOST_VDPA_GET_CONFIG_SIZE, &size) < 0) {
        perror("ioctl failed");
        return;
    }

    config = malloc(sizeof(struct vhost_vdpa_config) + size);
    if (!config) {
        perror("malloc failed");
        return;
    }

    memset(config, 0, sizeof(struct vhost_vdpa_config) + size);
    config->len = size;
    config->off = 0;

    buf = config->buf;

    if (ioctl(fd, VHOST_VDPA_GET_CONFIG, config) < 0) {
        perror("ioctl failed");
    } else {
        printf("Configuration data (%u bytes):\n", size);

        /* Print the data in a human-readable format */
        for (unsigned int i = 0; i < size; i++) {
            if (i % 16 == 0 && i != 0) printf("\n");
            printf("%02x ", buf[i]);
        }
        printf("\n");

        printf("ASCII representation:\n");
        for (unsigned int i = 0; i < size; i++) {
            if (buf[i] >= 32 && buf[i] <= 126) {
                printf("%c", buf[i]);
            } else {
                printf(".");
            }
        }
        printf("\n");
    }

    free(config);
}

