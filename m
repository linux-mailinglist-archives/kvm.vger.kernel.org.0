Return-Path: <kvm+bounces-13887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3471989C3AA
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 15:43:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58B781C2223F
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 13:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2770712D745;
	Mon,  8 Apr 2024 13:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="LTlNtjEd"
X-Original-To: kvm@vger.kernel.org
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04olkn2084.outbound.protection.outlook.com [40.92.74.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC04812C7E8;
	Mon,  8 Apr 2024 13:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.74.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583481; cv=fail; b=L+x652MRXTQOkitsUflR5W+k2aU83h2jsZoCFMxYOBSfm0O6g33cMMBTgsL0u+M6QFXTMM3ZkHzMYUD501FOz9wyFp0p4FFDpQfKLr2Hcj3C3F+ABXBbOts7M/QX6kUXCMKm9b0LK6Dy4g3gpOb3PcwMhzyMR0jVCTtROy261yU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583481; c=relaxed/simple;
	bh=v2kkyX6TxtLab5v9MRYP/8mP3IdNn7VGnPN+B8NhR0o=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=PYlU0W4vLXY9z2QI7qIOLxW4Gimi+MkgwkPp4/TAUs9DIPzW7TSd6nVVbNpjrG9f0I6Dmw/PSUbwXgovHRSa0yQFtVlVrUuzC+m+bFe5nf9efi8varBri4SbD22XgXxBMu8ti/OIbQYSoNEnbWivG4iVEJauJXS546ptCGh/S/s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=LTlNtjEd; arc=fail smtp.client-ip=40.92.74.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ejfVFezfvSZqu/ZdKOd3mutIkXBCLX3zv0e7KrskyKpamT99PZ4mGs8CC+4RgAKi+aUkrC1Cd5YC56JyYsBXfvcggScZCDWkTze6dsgWC+dA32Pl2IqefShivSjt203Ar+B4ezIIVkvkfPk/bGoD0ThX2e1n3gv/Np7xuSJtoxkbdGEV/A27J4a7NQR0UyExWeBtd9LiaL/YkwA+MfdflG0iO5M5p/9paT90+Nd7/TYk4iAD8nkqq3PQDHDjtZ+Qj/Kl991U+F2zv+bMqOvYPeD+EGh4GUHEIdUT1FXpbZNLPg2zW2DsAE9ec4dZO1QtPyF6fWcv02zoGjvJs/drig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/jZWmpaWdwJn1GG3i9Qe9HWpGH0DCjrM9CeCdLCm5Jo=;
 b=gzGYL31m7XAUTYaYxHIuentnlKZxdbytxNykNgHpBErFxnHZxLfgFagQXIuHjs+zZaaTkjvE3rDiTIpJqmsEQ/0BPG7RXHIPerRZcSCiE/zrbt4nmC8DtcvybebTVm0O5FUoqaklBwkgXFKSxXRt/zRKauMAL6/QpGjS0yXqc0i87VxIl4qN7sL4QQLko7wlV4Zp4j+OktYiRh1ipDtuNAfJyMp49WTLnUwqyYfK/ujKg6MmbCrQaznKepKpM0/3klD/4N6nW0MvxWCwRXq08OXylIVcYOJvvm2rh8ofKcC+g1LQiSKmkP0Z5zzKQMWTo52jtPO3YedYN/wXd2YDQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/jZWmpaWdwJn1GG3i9Qe9HWpGH0DCjrM9CeCdLCm5Jo=;
 b=LTlNtjEdz1tgHwtXinxenmMHRLpp1pGmUnlDrpxOFk3lCUzeXbcp6m8OKKV9om7nj6IP9jQCku+71SN5W0O9jICcDuT76JI6VchTUyMkXyObXlJmtfrm1Z7pPq4EwhNwVeMVZ638snTH/ZHAWs8Aywndn336WkVWznzpBqyRUHPPwRQ2scYjpRDqglfFEFpIeZb23syo/0021PyrBvCS1KEr8IysSm7FHPrJCMx/+IcetOMSh6LFwGN/gicNw7VsuQVNL9mGHKzmLPp1nKj+zNVben0Jt3cJj+Ajh6cHN6upWyCrx8XINU4Upc2BvWtlXJEwykKtwsbT67ov+yKVVw==
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:642::8)
 by AM8P194MB1662.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:321::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.47; Mon, 8 Apr
 2024 13:37:56 +0000
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::56f0:1717:f1a8:ea4e]) by AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::56f0:1717:f1a8:ea4e%2]) with mapi id 15.20.7409.042; Mon, 8 Apr 2024
 13:37:56 +0000
From: Luigi Leonardi <luigi.leonardi@outlook.com>
To: mst@redhat.com,
	xuanzhuo@linux.alibaba.com,
	virtualization@lists.linux.dev,
	sgarzare@redhat.com,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	stefanha@redhat.com,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	kvm@vger.kernel.org,
	jasowang@redhat.com
Cc: Luigi Leonardi <luigi.leonardi@outlook.com>
Subject: [PATCH net-next v2 0/3] This patch series introduce the support for ioctl(s) in AF_VSOCK.
Date: Mon,  8 Apr 2024 15:37:46 +0200
Message-ID:
 <AS2P194MB2170E1933C4257264D53AB069A002@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TMN: [ny+j1VmChUN0F9G40nHNFY4xTfyDBCB0]
X-ClientProxiedBy: MI0P293CA0013.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:44::18) To AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:642::8)
X-Microsoft-Original-Message-ID:
 <20240408133749.510520-1-luigi.leonardi@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2P194MB2170:EE_|AM8P194MB1662:EE_
X-MS-Office365-Filtering-Correlation-Id: 96385924-3355-4006-b3c9-08dc57d1192a
X-MS-Exchange-SLBlob-MailProps:
	/UmSaZDmfYCe9ICa+qD7o10Vv1KVb8VQ99OJLclpbL92WqSgnQ4ICxG+FRLwF8QlCD6ILazI1uzwoWVKNNN82rLWo5LMJHziqAivNGAzVQzibBc8NeBOy9nVkKgz/lvrJPTt8sxrSxAumOEML2Lc2fVBmRnx+pFHDX7ZTPdSc0y6iG5MBSgTHnGuuJXeX7rLb5GYUWBZd6Esnz/gLVujIzKwchSBurD7C1XV+RKtXpc0HQX8Fzi9o9evXLzQDi7ZfcNIh7xV+IwY7o5YujwriQvXULD1wE128Mspn5nBxVrnnuvTV+lfqpVmr6vePWiFrV6NJPLyPyg4zt0c19bp+Yjia/azwVarkpu4p7n+OwBsWTHoP9En0UuN7SN9jQhxg2Ee9Rqp5VrMQdL+EbBK3J7zyD4QW7pa1nKofo/c1InWDZxjn2RrB3RBgW1+OZ02WOxeST4QQsJb0y4fDcbCObsece7W1rX5Co9FEtxVGmIAElJMPPoNXF5gdplHTKFhaQd+wEjWANqX9QK9lZpSj/m4rosTKT8/jZ7KJDUovASGOra9N37NWECOHYJXO7tQkTE80go+oGZXE6E62cLzg3MheCmOVteo9ZSCa26QfVUAnP5uJvumH+CgHd9sQK283X28DjuYjw7rnwnXTWgtrOy9nHE6uSQ9AMrRLzo3kvq3kXLeBvKrvjLAnYCcsF3phlRxXuGIW9PQ3hCLsEPGnQinCJDRbk2y2+i/BydmnCfIVt22idmE7+5+HhVePbxpF6C0x6ie6ClFAGIq4OEBjYkYy3ZshLOM8RHASo28JEfyH+fqxM3Fnk+sxSbl0yZnHEmeHPVZ7l0OJZs8QELJsA==
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DdCz+dCsdpGgN2+vomiOo9T+eYm29VlLRjrqmOsVnjm1rScuUJT1d3f5gMsWIKcZw8yxoLgAfkJc2G5oSfX4gDc0c+u9KKk3ApwDE/n1HEvdyeCYyd3s2VihYNSQS1YHpk+zRKy4RjuHHzdPsbeH3J/ni9sBBfs3qiuIjuvj7k/LzD8JyZzB293u4w57br7KZOUbTQsMUoHTTkxXqpmqhovb3o+eB4YUDzj3s9zbybMVQ1ocJFAyknxb43sAEVfQ6GXPMAgD1633JeMUWXO2L4iKX+ohHLeyiEjWpUwnsY2KqsSSguBB2eGB7O70zXNt+9vEWnPr1SWrET3ENS5jIw1+fpX7+7OA4gjY4AA6FWos5RIbXCVzgfys7K14BQLVaEcXG6I35LhwxEkNO06JHdu5NLFJponX5JCkbWoDbesMUGsG/yUNN396a6vdecGjdNg4R6pV745oaxpHJv3UpX8SpfJyreVTfGMYCDgilUac2YxVetAWIhMU/7oWyBPeVDo2HTSa8cEox+pM9OSHZtIuiRg3WIVo9nbHe8KUVyXpto+aO3Qcc2VuoerRAei035DNlykPjQk8rXM44A283Ejsh65YBkco93I9rldVhKCZkRVkidvjaddzpsMmoyvwgRgs6EAd9OF+i2+SaDIfP+OBss8rw54Mr37Al3d91Rc=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RUJ3azNqSEFKYjJCT094VU9RUnVEWEdqT0p1WlUrMEhPVTU2eG1EaThUU0NQ?=
 =?utf-8?B?Ly8wWEJaVDNOR1kwS1ZvaXI4elFEcjEvdEttbGRjY1hrZlJQR0RwTFJHWHlE?=
 =?utf-8?B?blFhSUptZEVUUkVHaVRKb3VidmJqQWRTdXFGZ29VYkZMRDRyaHg1WGlBalF0?=
 =?utf-8?B?L0I2STNKYk9uczdGdnAzS3hRNW44MSszWlBtclVlNHJmaXNSYTBoMHp4ZlVi?=
 =?utf-8?B?TlNaSWdjMmNGby9HS2g1TFUzOFFUQjArcEJNRnNJVzk0Y2JJM3p6dXJpcVdC?=
 =?utf-8?B?bmZxSk5uSHhPQktITUxLMGRqeFo3WVVVQUhuK2xhcHN6TFhaOUZKQXRGY1RJ?=
 =?utf-8?B?MldXTllVTFI4TEgxTHBqb2wyak5jbnNEeUIzRXdIeG04MjRpYk5Tem1LNDcr?=
 =?utf-8?B?WGZSYm1RTzM5MXZ6QkFqZ0lSeXZ2c2dVMit3dlp6OUNjZnc0MVlhYWEvSDM4?=
 =?utf-8?B?Wlo2d0l5czUxaHBTdlEwNnJoQ2RDVWxVbytNUVBSbEFBVnF2TllXQTVPblg3?=
 =?utf-8?B?eFp1ZXMvL3NFOUdnRGJaOWVSWnUva2ZlcVdvNVJhekQ1dW9hWGE0eHkra25r?=
 =?utf-8?B?aU9KTGxGWGMza2VQUVZKaDRqaTR2V1VBUjlOK3I3dTVxUFBtOEtmWjdBYTRE?=
 =?utf-8?B?ZVZvS0tkMkd6WjUrR1dlRFNPcy9SbzJMRlNxRzM5MW5oNDFUMjA1MUxVWVpi?=
 =?utf-8?B?TVU2TVhLOE1yczFaYi9yUWQ5clhHL3I0SEwrS1oyZTUweno1azJFdXBBbVdZ?=
 =?utf-8?B?dmNQN1B4MkwwQmFxSHN6TEl1TjFCYmxja2J3bU1IU2x5Y2VveFlSOTRxSjcy?=
 =?utf-8?B?Rnd5cURaOE4zWnllTy9IMmo0UVoxcjBVNWFkNm9RMTM2S29qS3dnaTZKVC9a?=
 =?utf-8?B?amt0WUZlY2N0QzVCYWJkSm85OFUvOWxWd29vZlIxNzMxTnlxWCtPeGhmR3hV?=
 =?utf-8?B?M0JxREcwUWsra2I5bWpHR0VaVy9xelA3eno2WFQrY1VyenpGTWhMQkFPeGwz?=
 =?utf-8?B?YUhBZ2lESy9PMlhVK016Sm1wYXZiYjhyYzY2ZFJjeEZrRS9IdHVXengxOTcv?=
 =?utf-8?B?UllCZ1BUL3UxVVowQUZ5aHBWbVErZEViNXgxdVZIMDcwdTQ0YTl6Z3Fza3Ro?=
 =?utf-8?B?OHVyY2JFUG5zNXg0emYva2tpMG1vbGZXWk9KbGFHOHBTYjRqSUVDUGxkUWE1?=
 =?utf-8?B?NEtFdmNON2piRFZpNEc1UTlJV1o3TlRuWVU1Sm5qczhrVVBZMUppSEdGUHdB?=
 =?utf-8?B?OHkweDdrZ3ExU3dIOVpUWlBlUkVzYTd0b3ZlVlpNeXkyR3RjNEN4ZXNWYzBy?=
 =?utf-8?B?WVhWR2w5elFFM0M2cGhqdXFvTU4wM2YrRWdtUkVGTmR0ZTdtZFBuenI4N0J2?=
 =?utf-8?B?d0ZmMDI0VmhYRG5UZndhMXB1dTVyNFZsZ3Aza0pLaDVMSmVRbFdSNW8ySDdm?=
 =?utf-8?B?M0syZ0lrM0NNd2swVysvRndHMWdGNzNTV1dVU1cyMnBCYTEzN2FsU2NpMTBP?=
 =?utf-8?B?N25nSlBodFpxZ3FkNkxZSHpxRDFRTi90ZS9NZENsNmtHcWl2M2NnWm16c3Nl?=
 =?utf-8?B?MlVnTG1zT3hlcGUyVHZQMWdTekpZTEQ1Z2ozQkVqVTVlTnN4aXpFR2I4aUJk?=
 =?utf-8?B?VjdzL200ODhHRENQMmxHU3dISXUvbXNVWDFEa3FxN3hReHFpTHIydVZBekt2?=
 =?utf-8?Q?7XaaTwirAKPr9RyeS7qr?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96385924-3355-4006-b3c9-08dc57d1192a
X-MS-Exchange-CrossTenant-AuthSource: AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2024 13:37:56.4305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8P194MB1662

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

v1->v2
Applied all Stefano's suggestions:
    - vsock_do_ioctl has been rewritten
    - ioctl(SIOCOUTQ) test is skipped when it is not supported
    - Minor variable/function name changes
    - rebased to latest net-next

Link: https://lore.kernel.org/netdev/AS2P194MB2170C0FC43DDA2CB637CE6B29A3E2@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM

Luigi Leonardi (3):
  vsock: add support for SIOCOUTQ ioctl for all vsock socket types.
  vsock/virtio: add SIOCOUTQ support for all virtio based transports
  test/vsock: add ioctl unsent bytes test

 drivers/vhost/vsock.c                   |  4 +-
 include/linux/virtio_vsock.h            |  7 ++
 include/net/af_vsock.h                  |  3 +
 net/vmw_vsock/af_vsock.c                | 51 ++++++++++++++-
 net/vmw_vsock/virtio_transport.c        |  4 +-
 net/vmw_vsock/virtio_transport_common.c | 33 ++++++++++
 net/vmw_vsock/vsock_loopback.c          |  7 ++
 tools/testing/vsock/util.c              |  6 +-
 tools/testing/vsock/util.h              |  3 +
 tools/testing/vsock/vsock_test.c        | 85 +++++++++++++++++++++++++
 10 files changed, 195 insertions(+), 8 deletions(-)

-- 
2.34.1


