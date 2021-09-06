Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FEE401DCF
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 17:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242939AbhIFPx3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 11:53:29 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:49036 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhIFPx2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Sep 2021 11:53:28 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 186FqLZ1103762;
        Mon, 6 Sep 2021 10:52:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1630943541;
        bh=AmCdNApGszIldNsIIkEGWv5ioCQhcJfxkbQ+XX/90J8=;
        h=To:CC:From:Subject:Date;
        b=gEHZA09u1yS7gjKMRjfKR4gxmjxHn3NzsT3Kv8rTM7EH60w8rYtOlpeFxXwHAdKW/
         qGH5tGHEqecYJIGiADdE58zSsJG/8jYmWlerPBIiMCFffV6W0sCMkwHHQ7mV5ADbZr
         6xID1HvP01opju7vBdBMAiFyQTNoJQh7HR3ggVXU=
Received: from DLEE107.ent.ti.com (dlee107.ent.ti.com [157.170.170.37])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 186FqLsK061765
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 6 Sep 2021 10:52:21 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 6
 Sep 2021 10:52:21 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 6 Sep 2021 10:52:21 -0500
Received: from [10.250.235.239] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 186FqGiv119307;
        Mon, 6 Sep 2021 10:52:17 -0500
To:     Cornelia Huck <cohuck@redhat.com>, <alex.williamson@redhat.com>
CC:     <kvm@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        linux-remoteproc <linux-remoteproc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Vutla, Lokesh" <lokeshvutla@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>
From:   Kishon Vijay Abraham I <kishon@ti.com>
Subject: [QUERY] Flushing cache from userspace using VFIO
Message-ID: <d338414f-ed88-20d4-7da0-6742dedb8579@ti.com>
Date:   Mon, 6 Sep 2021 21:22:15 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex, Cornelia,

I'm trying to see if I can use VFIO (Versatile Framework for userspace I/O
[1]) for communication between two cores within the same SoC. I've tried to put
down a picture like below which tries to communicate between ARM64 (running
Linux) and CORTEX R5 (running firmware). It uses rpmsg/remoteproc for the
control messages and the actual data buffers are directly accessed from the
userspace. The location of the data buffers can be informed to the userspace via
rpmsg_vfio (which has to be built as a rpmsg endpoint).

My question is after the userspace application in ARM64 writes to a buffer in
the SYSTEM MEMORY, can it flush it (through a VFIO IOCTL) before handing the
buffer to the CORTEX R5.

If it's implemented within kernel either we use dma_alloc_coherent() for
allocating coherent memory or streaming DMA APIs like
dma_map_single()/dma_unmap_single() for flushing/invalidate the cache.

Trying to see if that is already supported in VFIO or if not, would it be
acceptable to implement it.

Please let me know your thoughts.

┌───────────────────────────────────────────────────────────────────────────┐
│                                                                           │
│ ┌────────────────────┐                                                    │
│ │                    │                                                    │
│ │ ┌──────────────┐   │                                                    │
│ │ │ userspace    │   │  Data Buffers                                      │
│ │ │ Application  ├───┼──────────────┐                                     │
│ │ │              │   │              │                                     │
│ │ └──────▲──┬────┘   │              │                                     │
│ │        │  │        │              │                                     │
│ │        │  │ user   │              │                 ┌─────────────────┐ │
│ │  ──────┼──┼─────── │              │                 │                 │ │
│ │        │  │ kernel │              │                 │                 │ │
│ │  ┌─────┴──▼────┐   │    ┌─────────┼────────────┐    │                 │ │
│ │  │             │   │    │         │            │    │  Data           │ │
│ │  │  rpmsg_vfio │   │    │  ┌──────▼─────────┐  │    │  Buffers        │ │
│ │  │             │   │    │  │ Reserved Region◄──┼────┼────────┐        │ │
│ │  └─────▲──┬────┘   │    │  │                │  │    │        │        │ │
│ │        │  │        │    │  └────────────────┘  │    │        │        │ │
│ │  ┌─────┴──▼────┐   │    │                      │    │        │        │ │
│ │  │             │   │    │                      │    │ ┌──────┴──────┐ │ │
│ │  │  rpmsg      │   │    │     SYSTEM MEMORY    │    │ │ Application │ │ │
│ │  │             │   │    │       (DDR)          │    │ │   Logic     │ │ │
│ │  └─────▲──┬────┘   │    └──────────────────────┘    │ └───▲────┬────┘ │ │
│ │        │  │        │                                │     │    │      │ │
│ │  ┌─────┴──▼────┐   │Notify Firmware/Control Message │ ┌───┴────▼────┐ │ │
│ │  │             ├───┼────────────────────────────────┼─►             │ │ │
│ │  │  remoteproc │   │Interrupt ARM/Control Message   │ │   Firmware  │ │ │
│ │  │             ◄───┼────────────────────────────────┼─┤             │ │ │
│ │  └─────────────┘   │                                │ └─────────────┘ │ │
│ │      ARM64(Linux)  │                                │   ARM CORTEX R5 │ │
│ └────────────────────┘                                └─────────────────┘ │
│                                                                           │
│                                                                       SoC │
└───────────────────────────────────────────────────────────────────────────┘

Thank You,
Kishon

[1] -> https://youtu.be/WFkdTFTOTpA
