Return-Path: <kvm+bounces-19673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9557E908CC4
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 15:56:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D8116B27D9C
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 13:56:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D6ED9441;
	Fri, 14 Jun 2024 13:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="ZefaSmTY"
X-Original-To: kvm@vger.kernel.org
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03olkn2057.outbound.protection.outlook.com [40.92.59.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56E64C96;
	Fri, 14 Jun 2024 13:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.59.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718373355; cv=fail; b=arbglxnGes6ZRNsnPK+SwMRrrtn7/DedZbkdmLItOavFSeA4nPLhSMZeEsBhnDC7Lb56WzOn+rhpnEZxgJsIF8ntdVgcYs5DjINQAxftrLum8zJgGanCrSK/KFObPncKdI7sirGQHgbbbSHIZvgCmeGCTzQkkKBNGsAlbWqwQcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718373355; c=relaxed/simple;
	bh=MQWeVsYjgaa1zoyqnGxlHb5PMU1BCZSB7VM3+zf3TgI=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=jo46LoGh5X7XkUW7wrS8dLVKcV2ZvNF9V8f16mok93nZaf76xEpDP++wW7iu9+1nHrJOhRkmt7d8tz+VSNyDnwBdZEPZz5ELP8ZcSA8n4T6R5o/Z+0Wq/hO1XT7GAzNJNNynt+rgxcj8GeZmGfQrUTmIS1N17vOU9ql+sGi1T4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=ZefaSmTY; arc=fail smtp.client-ip=40.92.59.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FIcdaGmD1Me9q5jfv2rL6Wq9f7qpeL46mqyTzGamauNqVgE0X8F14qCAdfBZKppA2Dh5QMCszUVTotLvxjQALH/0X/pxLudW1q4EM8K72/3mOcP6BmVstR2te90DcZ3Elss8rTJbaUdw9CT4/cb8V1EO+FmQdqgZbS5A+L/Oo3ksMDmj+1X5hZhTDiB7GU/oWl0TBrqXE9ot2gnvV63lvhUauRi5reogDQvJv2l84C2AK8UM7DFUuNcVjDI6n0HyXZFpQkCyDAmmn5dpcwvfyZS3BUD+uACNH1aUQf1583i3zhHvWufxM41DPHccclcHYvZoIxiWzVHLaE+AsPeTnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mtyiUHbCwTSg6DT9PUgPUQc+5RLjiP+cTtilbGkT7zE=;
 b=Pv6b+xtUI2ztkAI7l8t2MBfQHw1idCQSrqLKgNR+g9UE1ETkSl0OfUfbqAdB0WIE24XcKGT+maDnPX0en2FxD+c9Pgnpc477v6fbNtx6y0TivD8TwWUGhJV+U/riDeuaaDeEh/hcMq09jQ5YeqOk5p3bglidg7bUMBHE2pbKufsbGBPQZNafxYL7HEQpekeGDQabITKSMkbkd5yPklzafReBtOAxlP8z/oA70LJ2YEPiCUbIR87MareBUmJjCBNpv4OaS5mo4We8J3+gx0KjJi3/H9rGsuMxB2NH6zyRoIu9DyqxYco7zZRFJJPuYRBD8mqIaOnWBX2GymQTnoz2wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mtyiUHbCwTSg6DT9PUgPUQc+5RLjiP+cTtilbGkT7zE=;
 b=ZefaSmTYKHGIvwEkroAu7v0gdQYFpYGaGYCfxcFPjQ/RjOKv4g2a1SnZD6fxABBfjWcMBxAa/KtfKUuvzHWSfjGov0WoECtEC3PvNgXWWTUDt+VaZRMxKvzHrl8q9SQg5D6A99GB02Oht8Pqg43U4Ql0pLYdFQ94l/YdjkvRDNRqLEXMld0LK96K0NtqzSeFoyRINtXZLYMd5x0/mw83qrfMrUhwA729f7EwyR/Ma96xiV6oK8qTQxR7O+2bwKQHEPhLFrFL827l3TPiBJSpWoVDplN51yQn+R4yO/NwS3ti6QFHyZRVz/U/XTy/VKGUrAR8+U5r1PufG6N8zp+/5A==
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:642::8)
 by PAXP194MB1469.EURP194.PROD.OUTLOOK.COM (2603:10a6:102:1a8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.24; Fri, 14 Jun
 2024 13:55:50 +0000
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::3d63:e123:2c2f:c930]) by AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::3d63:e123:2c2f:c930%3]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 13:55:50 +0000
From: Luigi Leonardi <luigi.leonardi@outlook.com>
To: sgarzare@redhat.com,
	edumazet@google.com,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	kvm@vger.kernel.org,
	stefanha@redhat.com,
	pabeni@redhat.com,
	davem@davemloft.net
Cc: Luigi Leonardi <luigi.leonardi@outlook.com>
Subject: [PATCH net-next 0/2] vsock: avoid queuing on workqueue if possible
Date: Fri, 14 Jun 2024 15:55:41 +0200
Message-ID:
 <AS2P194MB2170EB1827729FB1666311FA9AC22@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TMN: [ugLNQMse1JjcisOqiZHWz6UJHgzwtyeZ]
X-ClientProxiedBy: MI0P293CA0015.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:44::8) To AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:642::8)
X-Microsoft-Original-Message-ID:
 <20240614135543.31515-1-luigi.leonardi@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2P194MB2170:EE_|PAXP194MB1469:EE_
X-MS-Office365-Filtering-Correlation-Id: 26c88e11-f4d1-4b90-7614-08dc8c79b2ea
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199025|3412199022|440099025|1710799023;
X-Microsoft-Antispam-Message-Info:
	uvRCtkKaME1lmfWV7AxCPXjvIMLZxyl1f5j4N1FRLaqCKIS2xRgeMJJr+tBEatQjzOVvAwcyhUvxqxzcQWV6eerpqZRh9FAGeJQfRbf1csmBDG6rndh5fuV9/hBi+Z8n+meSrWTzkd9iWgv5tTKkt7SesRdjvKa1SMArJ/qTWrTU+qiYovHB2Vx2CRJ7qWluhsZSjBvaRjCLavtm0NiPrgij7AcpSg4AUx9wOhvDUiFOrMzMIapSS/jo5fZ0yl7MOGJv2/1ueLBP/KB05mlhkWqjWw2A9iS9icNg65wnZbKHxza7eU5EFM4QHu6oqOqb5Nl5tYnfTPFZMjh4sbScD8FqXTR6Y7Wa5JoZsRxn3suv7jkHAgdps12SCZsVBC5Oie6ynggF4djti0MKaM4LT+Qgskgzq03530AA17aLRSP/rXebzGLxjLNqVNGikkslOISOVr9Uj0lEDAxfcPFe8afy/KjgbEkvTu6wu7oqaHAaNR5qPTVwPE54/1WbJnIdrTEPbPvIz0J42hLUTjCUzcl/QQEjXnzqxqVFe+ODkHu/yF1jG2zNrnyWlxJT0uv4fEbOrnb7x7//hTZKKoT2xiPBPj2zOxHEhDlz4nI2axI=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QmV5UzlrTFZ3S1RBV0U5RlJOYmg0WlI4cVl6SE1xYWNZNFpOTExPTVN1cExq?=
 =?utf-8?B?d2IzU1Rsc0UvVWJ2US90bUUwSE00NTNPUWgwQkluWmNDd3VoRVFSeVhtYkhU?=
 =?utf-8?B?MS9lS20ydFVpTTFUOWhuTGtVWDNIOXkvbnJOaTR6T3h1WllieXlsVjlQNFE5?=
 =?utf-8?B?Ri9CUVJ6MEJMcG1xZjRVVXBFakFETmRuWXZTUU1nbENEZ01Za2cwZ0xXQVI2?=
 =?utf-8?B?OFo4L0JhUlBwa2hDdVRsMlVFUDBnc0ZieldnOXpqU2xmWUt5YW1Qc3M4ZVdz?=
 =?utf-8?B?Si8rRmpVNnZUa051d08wN1ZNaFNaN013TVdJUmxTU3VJOFBHNFNXUTZmK2kx?=
 =?utf-8?B?U2JYMTN2ZXJjUmN1ck05ZDUyUzl5VTlVTnVzU09wV25tVGlhRDVuR3VUa1Qv?=
 =?utf-8?B?K25GWnBRMFJmTVhOSkc2dFdYZU9mYjE0QXUxVGR2S1lRdFgybnplaVhtbzRn?=
 =?utf-8?B?d2hac3RhaHhnMTJoVldpcEQrZEQ2MHlQRmY3QWh4MzdFclhYS201c2NMRHhu?=
 =?utf-8?B?T0hjbHlqcXJWVno1cnhROVd3RnVDZmRKdklzWWhhbUxucEc0WGJYckl4MVQw?=
 =?utf-8?B?ejBCMzFVZldmSzdkMk1UaytxbkR1eDdUZlNaSDJhelV6NWwxUnpJSGN1bGRL?=
 =?utf-8?B?V3pSR3k3UUs5R0kvdUFrVzB3dW02amlnaW9tL2grSkRUK1I0b1JwWmRNOWpH?=
 =?utf-8?B?UWZZSHBaTEFyZFRYdldGdlM4dERlYm1kOXU4ZVFzTkwyUExjZCtmMkZEcU0x?=
 =?utf-8?B?ekQxZkhBWGg0QnhJa1puRHlkRmtiSXI1VC9mZDhLL3NFb0pIMWpTWVBzQ09G?=
 =?utf-8?B?N1J6eGZRRlhXcmVZTmRqV1RWTFRNMHJxUENpb050R21CQWUzRHpQNFRhNnJT?=
 =?utf-8?B?UUVUTDlMOFR5V0lKWVlzeEJmVStCTWxVdVNSejhMbHBHYTM5Vm9WZ3ZjU1hr?=
 =?utf-8?B?VEwrMmFOY3ZjallXemJHY1RUVlI0aCtJZVI0a09zazZXTEdKVlBFRzZpMFJi?=
 =?utf-8?B?aHBQK0hGVlFZRys2ZC9iaVo0dm45c3NWQ1FKMjVzQ0dtUnZxTHZqZHpWSi9W?=
 =?utf-8?B?eWRnY1QyOXVBKzZDa245ZVNEQkp5VjBZY3lmbENUNWw4Qm1vT1JEa0lzK2VZ?=
 =?utf-8?B?dlNuc2ZHVkJ0aFdPNlVDWjVmRVlScVBtSlVteFg0VlNiWFJITzdILzQ5MG5N?=
 =?utf-8?B?VXYvbW1kRmdMcHl1T0dYREtxS05WRVBHcTV6cHpQZTlVd2o4Qk9HeGdDV213?=
 =?utf-8?B?SlpXYkNhR01BK2psNUw1NHJCNXM3TFJHc0wrU3o2dFZxMS8rcjV3ZTkrRWlh?=
 =?utf-8?B?UGE3YThCQU1pWWl1RHFURXNUOUlDVnZ5MzliR05JdkZyRHVoQjhRUi92Z1pa?=
 =?utf-8?B?Q3lJeE0xWlFHQnJmK3YydFNTMnd3cTZmQkQ3QUNxb3A3S1ZGcjVIQ3FoSjVo?=
 =?utf-8?B?UlVGL010amhWSkMyMU8rSzZJbUw1ODV3MWtNMGJSeTJBRW01MjAxaWhwQlhW?=
 =?utf-8?B?QUcvNi9Jekd5WS9ZY3lWZXpBWUE0a0dBZVhqclFNaFQ4a1FBdG9PR2V4M2pk?=
 =?utf-8?B?dllqblZaL2E1N2UrOFlvMjA1UUNzcFZOZ2Fza0o0cUtnS2FqR0drZVhJTnlo?=
 =?utf-8?B?dnJWRWxId05wcGZ1Z3NCMDh5YkFwVG12RmgzR1E1TUxxRWdzS2JCM2tObE4r?=
 =?utf-8?Q?JkP9Bdl8xe5CjRKz/v6T?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26c88e11-f4d1-4b90-7614-08dc8c79b2ea
X-MS-Exchange-CrossTenant-AuthSource: AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 13:55:50.2513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXP194MB1469

This patch series introduces an optimization for vsock/virtio to reduce latency:
When the guest sends a packet to the host, and the workqueue is empty,
if there is enough space, the packet is put directly in the virtqueue.

The first one contains some code refactoring.
More details and some performance tests in the second patch.

Marco Pinna (2):
  vsock/virtio: refactor virtio_transport_send_pkt_work
  vsock/virtio: avoid enqueue packets when work queue is empty

 net/vmw_vsock/virtio_transport.c | 166 +++++++++++++++++++------------
 1 file changed, 104 insertions(+), 62 deletions(-)

-- 
2.45.2


