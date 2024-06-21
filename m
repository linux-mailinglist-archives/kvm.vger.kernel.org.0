Return-Path: <kvm+bounces-20229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2561F912131
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 11:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8EAF2B21FEA
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 09:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D32C16FF39;
	Fri, 21 Jun 2024 09:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="PgCkBM9U"
X-Original-To: kvm@vger.kernel.org
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04olkn2020.outbound.protection.outlook.com [40.92.74.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E3916F854;
	Fri, 21 Jun 2024 09:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.74.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718963383; cv=fail; b=La0IGtDqz2AmMfiyCbmuoVnRhyeUiHU9O2efpxXI7HC8WLFmWfpnRKLq+YrxYORqkCVaXlv7q1p+RpBUq+iCt1WgBJkXLGmp+GmKYaog21xL2I/3gzc2IzDMm/DuxClWwWpyc+IufMPTm/M2KCMKbXBXTGdfmRBCzNbOBWxD/9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718963383; c=relaxed/simple;
	bh=kRsyUuGg7dYrLwd+WSfLJf36EQDHVciiQyBkW8vqBLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eMW2wQhlVUk6+cxmkKeQPBhNansT70ap6BpKDW7EZEeErT32AnkfQ3eyWjUsfuwLdDRLPAcvcgE3yMTXGbfkj3Wl6JYzTefOsnox0unP9M1ygRz8a0lkuvMRooAIN7SulWxOTggiyme/ZDgyzwrh2fH+HMSyIak63sdi8/npRP4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=PgCkBM9U; arc=fail smtp.client-ip=40.92.74.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DOHqIbgggRVrDne2/6ttSZD0pp/sbAMv4rLUvncXMaTdI57RMJGlaHsaZLQ0JzSA8NJG2VSBr2MX8c/yfIx9mYibVwHyDHxuWr/iKbChhIaQ6LQGC0v2eZyDa4TnGlu4Osmf36vHhZ8LlCtS8xX4458eOyJYmXUTq6IpuEjGtbb2fnVZlw9AIZ8dPtuX6pqFyEtqZHVq0+FwkVp/kk5JUz/5YuDmooBq0ujYcc2EwgVGHbC9nFEq6EvnqdPT8jVXpXEWDVl/1ZhaP5XKax6R8YipIdOpIRF9CNTEfFf5pSNWQpHu/4V2APqoBOsm8kh210oh13L9Bk+GHzEOs09VRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kRsyUuGg7dYrLwd+WSfLJf36EQDHVciiQyBkW8vqBLk=;
 b=PoktW7FgDA1G99iVzxRhGV+Xdj7j84v1YP9Xe7BOFsPWM9zGx9jCyGCMaB5TOb3BKq9yMUQo42TG59jVyC3Lx3VAf23JaW1W7QHHd15Yrmn1/hiRfRv1Z93Wmq7zFCrtnuagiO3o4V1JfUyWbAbjtjnv5leBAkeqe6xWjdBQmPw2lEEz/2+U0jfU1VqlO4ohIMGR/D+CDl4KCVgnlOatFAjNp2jL6gzgJpS+6a6E1S2pMrzhYQFw/RYs0j3izM5cFeVPmolJwmCFBxVwVOQHwLqAKo5rWEz93lLvLS3PKXDQcTIikIuS92nC20H1FCH+yybmz6nL73kT4GAZWW0Uvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRsyUuGg7dYrLwd+WSfLJf36EQDHVciiQyBkW8vqBLk=;
 b=PgCkBM9U5miTBMmegnHCUExW35Oksg72LPiRuk7Vm9OcgLwtWWFOIZo+q8WXkdmwwk7JdaclTQoaqNexn8EQpXY7yn8azL4vOlpWtWXcO5iMV3ty8xnG2pmHPiGKukes4Bw5abvlj1iXuH69Q6EZIsvmRyNAFpk9B+yEtM+6n2e+e8atSFW7imAb8upUPpdFyeOhCMIDitguigVOhg+RlU+uIuQzmwbduKozwF+bFAToiIvZ+hcsuzw4HN6rjFqhtK3qYD0jk9CA0GEA/WxDb3JtRz4Zy+j+w7uJkR479DFUwf7BxlPAoTlKQ4vhyFxu3dhL95WuVqwK4zNMB8UVhw==
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:642::8)
 by AS8P194MB2113.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:635::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Fri, 21 Jun
 2024 09:49:39 +0000
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::3d63:e123:2c2f:c930]) by AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::3d63:e123:2c2f:c930%4]) with mapi id 15.20.7698.017; Fri, 21 Jun 2024
 09:49:39 +0000
From: Luigi Leonardi <luigi.leonardi@outlook.com>
To: mvaralar@redhat.com
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	kvm@vger.kernel.org,
	luigi.leonardi@outlook.com,
	marco.pinn95@gmail.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	sgarzare@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev
Subject: Re: [PATCH net-next 2/2] vsock/virtio: avoid enqueue packets when work queue is empty
Date: Fri, 21 Jun 2024 11:47:51 +0200
Message-ID:
 <AS2P194MB2170634139F2B2E0216047BA9AC92@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <ZnVAsjkK11cE2fTI@fedora>
References: <ZnVAsjkK11cE2fTI@fedora>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [/+p1cY0JgD6CZYcwk444UpeY/VwPLTPl]
X-ClientProxiedBy: MI1P293CA0017.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:3::13) To AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:642::8)
X-Microsoft-Original-Message-ID:
 <20240621094751.7092-1-luigi.leonardi@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2P194MB2170:EE_|AS8P194MB2113:EE_
X-MS-Office365-Filtering-Correlation-Id: ec6c5cfe-835c-4bfe-e7e0-08dc91d77779
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199025|440099025|3412199022|1710799023;
X-Microsoft-Antispam-Message-Info:
	YhFnrG1Dy1j1y4sm3BfhH4Duo10n1J/t8vFk6uhdt64iNbxedirnWQgONHwEJqt6JdWVS29TrmlIhgbv68GGziN4CJwTD+7SYovo5W8cbW2Q89rBUSqPbILZgOSdezR2ApTke2rUH+hbpdnO8ettiQ21RZBFyZRWgKoTWnKZgakrC+XeREJt9rK4jwafrMRMqmSKo/mvknpNbTHC+ufpJeG/TG8vnDupMGvfMMqoQTJwsRl65Y5xZoVHIWTUUuADuDOmCkYyRXnFkG1dY13uCbgT4RBa6PQdU7EEai9gpcv+AK09iwkPg//dnMoQ4QlG95wJScXoFmHEZr1qtHUag1kMLjjekJ1U3cfginY8h8oX2B+BCJprfgphQ7uJtT+NkmY7vQD/h5b/VlXWCulGZvZ7QoxYKJrTHx5hLNNI7s0HXQcjTZM5usk9Fi4R+FL/rbA+Tlo3b06iiH5+wWPT8fn36xioB+Tuox6wqALJYpyuPOvJerrYqWNV4AY9gISC2tmB6BYw3YdINYhQaaocAIqQKcmP++UIPf+zxslKh0mP2rRPBtWSK3indmQHi9jTCXsRLZWZp2o1kKNPGRI13f+7AevVNVGOb72VB4YGI66hh9FITXCWwb9Ycrfne3f6
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1b0a74GsfdygrRvDZyeTpR25u6mAn2zxFkuklkIxmrSkCk9H6upyYvyW1ZlR?=
 =?us-ascii?Q?bQjXdq6Om+XITui2qcC5Qd01Mv6f9qYC+Fg9gkKHel0OtzGGF9OVSmzyvqdH?=
 =?us-ascii?Q?H4+jdMIAotdrN0HtfsdE3GgQPNHNRP4xp10/JMX/8Xs+jPc7378weF/15P9S?=
 =?us-ascii?Q?hkyyIEPQGv6GiSKDLwf3VL/83RCPXvkSYIf/R0/qs+20me9Z47GzZ/bK0m79?=
 =?us-ascii?Q?RZkbYzYLpRmI3m993VS+s/YE3sPfPRtPnZQCz4bubuzOMX6RhZ2AVlF4fHNX?=
 =?us-ascii?Q?zMm5GEwpvk/DECZcJVmBBzDXKyn9eSW9xEKxGkzQ12D09J+vh4GOuIU34/hc?=
 =?us-ascii?Q?KZJHsObWKHLjCp2HqkQC4NgH6EkxEID0laIijGNYsxrghpeV7+46GvEFXerB?=
 =?us-ascii?Q?6ny+rMcclkAGnsqzrKvoq2IMtlHo6e7YTCQYd6mHq8vw141cfG6d/fFVxV3U?=
 =?us-ascii?Q?amg9zs/1UqU74o9n1lKrBLlXaSyJK42qrgX51cbCh8Wxch89xDMk9LOi69v0?=
 =?us-ascii?Q?1v2/HltgF2ncgZoHBcT2m8815SK6TQsAh9quudXUIG2wKGe26pWkVtTYU2+x?=
 =?us-ascii?Q?J7ZbUnPqrwktJNgOuBRCj6t+UknTHRNdqbqM4hjhucP+HWHyDwndzqkHVkX5?=
 =?us-ascii?Q?TFbzP/+Zw++GuY0t8JYlAhe0U6gMPPJuuwXdrFq4DxLSLUML40nLgIBcmDq9?=
 =?us-ascii?Q?RF0cXY2gts0iQToqnxz/kr9RJQIon3kL/ZWLa1oEZcWD09D9G58eEW7CegDe?=
 =?us-ascii?Q?0MjnMyVqpi2CckjoRKH7WDSpDNpbGz/1T6Nli6/7pVYup6sX+y2fXfvAYypz?=
 =?us-ascii?Q?clez69OhSuPHZL7DW4u8XktUJNpfc0GpVGyMTvZmdCs3HuFDrTRjbWy1JRGh?=
 =?us-ascii?Q?CorjKS2KVWCuc6x3uOV8yoIQWdY0tu8aQ6pSrF7Gs2HxyQ4r1VJcZH1XNHQS?=
 =?us-ascii?Q?5njqn7lXc6ltoLkQ9S3BfGR9RC21tNqsgEvyeddnDYBEj9nTcayTZ2nAX4mY?=
 =?us-ascii?Q?/FkryaZkHHXaWhJzmqXqIdLICEvXDVXh01qSO/c0k65HxZkzmm5XmWDyzRaQ?=
 =?us-ascii?Q?U1z64ZAf2XAO1R3m/gdNlim6WfBL8AKPW2gD/4k4LAopkGbsUhv6ko8JQFpr?=
 =?us-ascii?Q?M5g1fmdVRu548nZi4zYD0XqDiBLNJSanE4gjdWb65iu7FnfeZuUdEPFmEnnO?=
 =?us-ascii?Q?irVtBgDQY8zF8PQzx0gZWXNtbb/iYKihTU5RlHChSDl9D/u8sFEmfxigF+vd?=
 =?us-ascii?Q?4EOlpbb07jcPnJ0W8ipt?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec6c5cfe-835c-4bfe-e7e0-08dc91d77779
X-MS-Exchange-CrossTenant-AuthSource: AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 09:49:39.1605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P194MB2113

Hi Matias,

> > > I think the test can always send packets at a frequency so the worker queue
> > > is always empty. but maybe, this is a corner case and most of the time the
> > > worker queue is not empty in a non-testing environment.
> >
> > I'm not sure about this, but IMHO this optimization is free, there is no
> > penalty for using it, in the worst case the system will work as usual.
> > In any case, I'm more than happy to do some additional testing, do you have
> > anything in mind?
> >
> Sure!, this is very a interesting improvement and I am in favor for
> that! I was only thinking out loud ;)

No worries :)

> I asked previous questions
> because, in my mind, I was thinking that this improvement would trigger
> only for the first bunch of packets, i.e., when the worker queue is
> empty so its effect would be seen "only at the beginning of the
> transmission" until the worker-queue begins to fill. If I understand
> correctly, the worker-queue starts to fill just after the virtqueue is
> full, am I right?

Correct! Packets are enqueued in the worker-queue only if the virtqueue
is full.

Luigi

