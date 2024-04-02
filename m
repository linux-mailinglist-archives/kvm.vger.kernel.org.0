Return-Path: <kvm+bounces-13375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A08E58957BC
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 17:06:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BAA41F24BCB
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 15:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CB7512C533;
	Tue,  2 Apr 2024 15:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="JGbvYBzf"
X-Original-To: kvm@vger.kernel.org
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05olkn2072.outbound.protection.outlook.com [40.92.89.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C6D86128;
	Tue,  2 Apr 2024 15:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.89.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712070352; cv=fail; b=rPo3MsjJPCaUfF3AAoWv9uaRQyJIDH7U0l4nY/sVQYB7HSqLIQ6wJzspIIUIfYdvRNyCKMPaOgp0LWLzT1+TADDIHOd2j7Ytx72CbZSUruZts8bo94SeprFhwcRRkDBkLmK/s88o6AUDDYFX0atGjWc3wgWxRpfrPTBD7VpnlmU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712070352; c=relaxed/simple;
	bh=L0LoCHzT3QB8vBXGF54LP9kt8+BHuqLRRuvJe8mI7/U=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=bThOixWLMTpcg3MQhcyEYqzrDaHH+jM4gijd4saIB7FsaSl4baxz2TC81hiQAkN+Jy2W91W53JJfmM7zgOqVWwcrFfI1FcbnNuzc44aeN1fpOzB83zv7WeuHUiFei8VwkK3jyJGgJQdRwh/T7FYcaXFeLJops4MBEZDAH0s/de4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=JGbvYBzf; arc=fail smtp.client-ip=40.92.89.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XNTn/YcZtlI1l3KRfcq62UiWzCQRsdsAL3Fkw2/gofZF6OoioAImats6LyR6WNlAhLPMTgAGZS51O0M+ggnQTO3XBxp5LY03Bd+dsqbEnUi/pXGxOMHzevNOsQsti5v3LLwcZWKnAmXZ2fGbcnWjZ5yiRemqdE1b7jMEcvwwNBx7GQ+WgNghheySUsK9VT54tvTJlRlRhIVl3s6fOPhS82ucmoOlVq0Ef6P74VfkMkie0gPMHRG3YKsKzSWNZSINc31PL/w399VFgKX/m5vdyJq3HUHINzkmA5cy4pgTNmxyfL1aIp2YU2zwh5LasNBNSw+eOABAX2pTOVTaShtsFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=29YO+qJ9ddHmzvs+1fRHfsbpENep51HowdbSPGnTJhA=;
 b=JglkVAF5v8hEDubdUMukvRjDz3Cprdluws+WqjrsQRjpvQkW00BvtGBRZN+cJc6pzZ+t932sLv+IT9ofx3C0tu2qYaYt3hqyqXYKvlGzmejxX0/U5Vq+dgIKiy04FRcOI1G4QrpKe/hfdpSsdp/cwjhU3KN22fmEykox9IW7nay+FEUq0ywN6VzlkID202fivSGMJDkhOvn82jWUZy5l3hqxHOwh/XEnsMg+u7avVHGTUY5YbrvhbzAfEvEdXXvmSm302APsHCcUdItaJsX18O53BqQwhb+FVG/2gCbI+9IFB3IlJwmTs443JZfikdqr1RSLmsOXuJye1YKDbICuMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29YO+qJ9ddHmzvs+1fRHfsbpENep51HowdbSPGnTJhA=;
 b=JGbvYBzfW2cdzdkCBuOzSGIv8AwY6CO/aWR+3E8nPOf6YWAMnp4w0PQ+YJT9m1gD1TTE8Ma7g9ojTYM6qWe16wtRmJBrr/gA0sLIYndO2Vdx/fVnBYptJvK4deqb76HdUaZHPjZsOXEftWGPYUtoTjkT1FRZzTUCk6z8BnxcpDksvvWt9h7x8S0Xml/86GGkemMn5HFnK4iTX2MI3inFeXjynpR5SdiJYnNC1r8gdq3W8FiFEl921v56jsoZe9BnBjQst1F2Fx6XvHyvYTTuECb+gtCEJu9+vVKdsjSVQfd1IOeXoH6uaavhawrD6ogfpBuz5uz3aFZ/5xMlKItQLg==
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:642::8)
 by AS8P194MB1141.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:2a1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Tue, 2 Apr
 2024 15:05:47 +0000
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::56f0:1717:f1a8:ea4e]) by AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::56f0:1717:f1a8:ea4e%2]) with mapi id 15.20.7409.042; Tue, 2 Apr 2024
 15:05:47 +0000
From: Luigi Leonardi <luigi.leonardi@outlook.com>
To: sgarzare@redhat.com,
	kvm@vger.kernel.org,
	jasowang@redhat.com,
	virtualization@lists.linux.dev,
	mst@redhat.com,
	kuba@kernel.org,
	xuanzhuo@linux.alibaba.com,
	netdev@vger.kernel.org,
	stefanha@redhat.com,
	pabeni@redhat.com,
	davem@davemloft.net,
	edumazet@google.com
Cc: Luigi Leonardi <luigi.leonardi@outlook.com>
Subject: [PATCH net-next 0/3] ioctl support for AF_VSOCK and virtio-based transports
Date: Tue,  2 Apr 2024 17:05:36 +0200
Message-ID:
 <AS2P194MB217046DE16A509B3FEC6623A9A3E2@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TMN: [aR2t77mvVXJ9r42eukDkK97vLdzdjr6J]
X-ClientProxiedBy: MI2P293CA0011.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:45::11) To AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:642::8)
X-Microsoft-Original-Message-ID:
 <20240402150539.390269-1-luigi.leonardi@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2P194MB2170:EE_|AS8P194MB1141:EE_
X-MS-Office365-Filtering-Correlation-Id: a76fabb5-24f0-4323-f759-08dc53266007
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7c7BJiLyDbsAZDm4yhHdiyFIt6xgDFs1WC2pd9cmNO/o63X24U19Yaj3An1rhuD2nIKgjPlWtcNiL++B+XnLXL0ZW3L4DvZVxFHFO+76mPckzYFZ7xl0/pdeIwJju9ZorKKaFIlHD+V4P2NMz2q3L9DbY4OvNYkF23/KqYZgr23FYCspD0E/j/69/eaHznND9acW7xvx2R1sWenjAYfSbrGc++qEUZt0ArZvXFU3bOJdvOSN06oJnxrEHuSXr+43GnVZ6A/bX0ss4hsSkTuBBklytZ3W8qC3DX4Ey8GQH8esIB58qKqZE2shGdW1dRwLPTNwT4LPR0Gks6f9/j2E/EBgL1DKf/cZX4lV9nQ329CMI7Z7ZneHrrv9u/hMKviSKqAiiluBBGZAyYQ1BDJAFR7Pm3ur0SITLCrwp5PMDvdYV7iOuD2cMS7JsX57rzHvLydlOiFZa6zCjxpL42XphttCAMhveYJUPNQKLg6Rh7/zzjYSA0Q+yuON35TCmrKuE/NYy5ZDTNeQuXo4O0FWcEnkwyflz3G5k0mCY4RfFRRLf/z2yNl7k7rSGN+IbJLaqHV2+FF2qbH9qjg+aJGWfmU4uFlxG3vsNKF+McGdLFQ=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YnJXaHRiaVZ2aWNSY3ppRUZwWVJadjY1NkJzem9Rb3FESkRNdnJsZEhPcnZH?=
 =?utf-8?B?WHlzd0o1UG04WWVCblNIR0RXTGtwRTBMV0NXbjJ2MEhjbWdGNmIwOFpiL1hZ?=
 =?utf-8?B?cXpQdjJDc2xhR3pmL1UybWJLSm5pMFpNanM2WlNsU2cydVJvVmQ4a21XYXFT?=
 =?utf-8?B?RmpmYUVTOUJHNWlpQzFjQkhDOEdyWTU3ZWkxUTZUVjFTZ2lLT1ZwM01tb2ZO?=
 =?utf-8?B?d2RKOWpCRW4wQldIZGppWnFCL0pjRnJlUVVwVlF3VW5SQ2dUTEljaTZrYW9x?=
 =?utf-8?B?VGxGZWQxMGlsUW11L0VPb0ZINXdkTVNnZ0ZRTytrWjhrWHplU2c0QTA4Wk5i?=
 =?utf-8?B?bkd0d2ZpWEE4dzg4Zi9VMlY2UFV5aE1TbExDYTdNYW41K3hNSjM2Zm41bHBt?=
 =?utf-8?B?WUoyeWNJSnZvbW9GSnppZ0haYWd3d2RWS1BqbGRXMjJlUTFxYkd0YThXU3Zj?=
 =?utf-8?B?bFk5ek9GZUlicnJFZDdseFFKYmV3TWY2NE5zSzdPd29pSngvQU1oMDVUM2Rp?=
 =?utf-8?B?d2pTeTR2UStBdWhlZmxFYTJ5UE5YM2NNQ1g2aGc5bTQwK1dDTFI3bXJXeXVI?=
 =?utf-8?B?MmdQMGREVUJNdkF6WDhOVVNGUnJPeitTcisyeXlXU1NRV3d0SnpkbkVxU0Q1?=
 =?utf-8?B?QTk4NEhZYmY3VGxOV3hiVDdDbTdxSWxmVlNpZTl1M2hBM0NzTnJmakE2eE43?=
 =?utf-8?B?dmhReHFZQ0ZXU2FiOCtEVEU4MHh4dXZVZndOUEtRMkpqZ0VCRWI4YWx5VWRQ?=
 =?utf-8?B?TEJOZ0s3UzZwS0RHMk1XNW56a1BBRGRteGtoS2hvaHVtSTVGRDFjSjlhdmVs?=
 =?utf-8?B?MDBEWGxjZElsZ3ZoUytrZzhId2UrbHhEcXorWUhocEpQSkpPWlVjWC9GWldD?=
 =?utf-8?B?MHE3UlVMZmVNS0daSjdsY1J6eFNkZ21kLzkyWER5aTNSdVFUYUNGZ1M5VlAw?=
 =?utf-8?B?RVBlbXk5d0xiR0RJZElFdmZ4Y3JEeVJENEROaHhEQ0VHbHVReUtENjBkYjNI?=
 =?utf-8?B?L3U1QXlaZjF6QWVIQ3ZqZFhtdHhBZmVWU0ZqcDczSFdDVmRPR3VNaGp6MFhI?=
 =?utf-8?B?TTNIc0FYUVJhUHBENUdRRG1XYkZCR2tpc25JdHpnRGJCTlFGYkRLR1pRWnRz?=
 =?utf-8?B?aU5DUStZenh2NFBTTUZuc0VUbU44VWZQNGkzeWUzanE5TDlCVVg1OHRXc2s4?=
 =?utf-8?B?R3I4b1dscXJCU0JycXJ5QjZpR1JYRXpSRFZacUV4dWxnSUpUSmpwQzBSZUlu?=
 =?utf-8?B?WkRHaHlDMjZYQzd6Njl5eGFxUERPSUtEVDM2YVptYUkrZmQ5WHJvZjRCMVV2?=
 =?utf-8?B?aUVMQm96SU9kNjh0TDlZbHkzOTFkVVR2Wk5abGxRdXNNUjVoMExiM2pLRmIr?=
 =?utf-8?B?RXlhTEdwSjFWNnhvbXJVeGNGYzB1L3E2K2dsWHhSSkJIeERhSDZwVzlkclFX?=
 =?utf-8?B?Y0RFaTVJeEFOUm1mb2IxYnB1aUpjcnpLZUk1T1p5MVpZMVJna0QwaDhlemNJ?=
 =?utf-8?B?cHA0MnpwZEhRS0Z3clplM0VKTnFEK3pQb0EyMGRhYjNWb1FXazNERGpEUzNI?=
 =?utf-8?B?SjVIVmJkekRuSVlCNGl6MUp2d004UE9LS3l3UkRQakhiUlhORFdJQi80VEZR?=
 =?utf-8?B?VXR0dUNZK3dmUWRKbTJuV01sLzhQMUg1K2tURGMyMCs3eGFiYWlXUkdrdy9v?=
 =?utf-8?Q?bNAXuSSr/228pIPCu6Ac?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a76fabb5-24f0-4323-f759-08dc53266007
X-MS-Exchange-CrossTenant-AuthSource: AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2024 15:05:46.8838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P194MB1141

This patch series introduce the support for ioctl(s) in AF_VSOCK.
The only ioctl currently available is SIOCOUTQ, which returns
the number of unsent or unacked packets. It is available for
SOCK_STREAM, SOCK_SEQPACKET and SOCK_DGRAM.

As this information is transport-dependent, a new optional callback
is introduced: stream_bytes_unsent.

The first patch add ioctl support in AF_VSOCK, while the second
patch introduce support for SOCK_STREAM and SOCK_SEQPACKET
in all virtio-based transports: virtio_transport (G2H),
vhost-vsock (H2G) and vsock-loopback.

The latest patch introduce two tests for this new feature.
More details can be found in each patch changelog.

Luigi Leonardi (3):
  vsock: add support for SIOCOUTQ ioctl for all vsock socket types.
  vsock/virtio: add SIOCOUTQ support for all virtio based transports
  test/vsock: add ioctl unsent bytes test

 drivers/vhost/vsock.c                   |  3 +-
 include/linux/virtio_vsock.h            |  7 +++
 include/net/af_vsock.h                  |  1 +
 net/vmw_vsock/af_vsock.c                | 42 ++++++++++++-
 net/vmw_vsock/virtio_transport.c        |  3 +-
 net/vmw_vsock/virtio_transport_common.c | 30 +++++++++
 net/vmw_vsock/vsock_loopback.c          |  6 ++
 tools/testing/vsock/util.c              |  6 +-
 tools/testing/vsock/util.h              |  3 +
 tools/testing/vsock/vsock_test.c        | 83 +++++++++++++++++++++++++
 10 files changed, 176 insertions(+), 8 deletions(-)

-- 
2.34.1


