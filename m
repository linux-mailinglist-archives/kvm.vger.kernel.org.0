Return-Path: <kvm+bounces-19875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1506A90DA54
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 19:07:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B02BE28234B
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 17:07:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D729D13DB8D;
	Tue, 18 Jun 2024 17:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="hQgI7JIu"
X-Original-To: kvm@vger.kernel.org
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03olkn2073.outbound.protection.outlook.com [40.92.57.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACF513AD12;
	Tue, 18 Jun 2024 17:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.57.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718730412; cv=fail; b=dfPFGxCOMXXOtbAo3RA5SUEjsC/QlSrESLXe6GcD7oErkfKMJxIRBR58E6LCnYeU/2gKoxHpvBl6xHFWNjudWNP9LqJy8/vtk5BXRWApVaZOb3uyMlRbv/CY/i62P6JiFd5qdDeeNQbQmKQhvrYuGJIVup+nOwVXHDB+E25Wpaw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718730412; c=relaxed/simple;
	bh=Iu0KXbmaSbcHGv+qwxX7KvdlFvAuc6tP2WDDM+laUrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iuDuN+FEqEitXCsfiMsiwrnmmzas+BYe03jRI0GpDuFAls+EvvgnEsQqtNAEfaSjLWqabBY6qeQn4ik87qAepHF6L0UnDrrjPQMeYahJAwioLabxJwM92js+DgXnI48KbGC8NGgkpk31gscEgDQNHdADSJsFuV+2M1CqZ4lnZN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=hQgI7JIu; arc=fail smtp.client-ip=40.92.57.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VdrhjlRXS16MtRUS90zrssAPnAofUbvBeQyTFFTgE39nQRDCBHuOvZeuLCeODxPn9H250zXhrJsB2UkJvlEhIt1EFzXO/u3KuASqj/QLjIo97FUgKFnoFtuChYD/VJhh3B2YIvISQAiHe3MgLcQjomeeSIOXQcLC9PbX+bHkoMzN1btXJoWk903Vo/teh6gHcieLn8V2t0eFYYZlC/+ElwmkVpHaPGWsybxEmu2OxAsWuQgcW5D/L8ik+ngXU6eHxhiF6riY8YERifcwfSi9E2RTruwQZX5mUUd5DEcilD6myJR3WljqQHFiA1SNDUxHCejx/VgI2MpSna8FjZ+NUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iu0KXbmaSbcHGv+qwxX7KvdlFvAuc6tP2WDDM+laUrY=;
 b=LujtaQL4cAg712+CXud41OudpSD2uPBa/jmCHP/uf3s+dlSMNWHAaUB7a9YmgbmL9HembIbBlm7AjLDv27vQLNUeGwmRSwjOv3TAEuDLN/xcfEJR7dYzkyvj2lOzoLZ6Va6+wDJjMoeat0YUWw8EOdwbXKt08UVBbVFOWOV3i/NHsuSmyTE+s2LeKLyI1Ad1eCUM/igA29kDrrRUbqxcx1rI2ixJc9GIvyjm56xNfbrMc9UtPD0Ecv6xBlEfkSmsczE/rxKQoGg3PYG20+2GYO4ltU/KBqCMDjJYNKhxTrHLurMb+17SDAw9fBOo6oOo4OSh107so4XlEtIzqVjz1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iu0KXbmaSbcHGv+qwxX7KvdlFvAuc6tP2WDDM+laUrY=;
 b=hQgI7JIux7IBRlgqVA5XLR9YBMB/c3cJ58ilNQNvaG10xoEmKHRqdxgmXikrQLahwWZ2bLLWSuc0OgmSUwackkPli1PEMwJ7Ex/NfODbxzqwIt5QXie84QN1XK7uhNO7wdMZcuL+hgNEbDCh9OkRCJkiVNRt0HNjYdA3nJUWMnUqpEqSfp9HTkC7bE73O0HQZr9yN77sR5zGwURHz3yWkZ+m7ggUzyGJcD2yFsvBYMbXOWImjC/JzOi0fyV0P9AlxrIg9B0277Nt9s7xYWQ2eLSQOYUpqs05ZEJrjDzGEulSkNgm+86NZq/UOZUaFAazgZw9QGnx8x30ThNZq0dNdQ==
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:642::8)
 by PAXP194MB1469.EURP194.PROD.OUTLOOK.COM (2603:10a6:102:1a8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Tue, 18 Jun
 2024 17:06:48 +0000
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::3d63:e123:2c2f:c930]) by AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::3d63:e123:2c2f:c930%4]) with mapi id 15.20.7677.030; Tue, 18 Jun 2024
 17:06:47 +0000
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
Date: Tue, 18 Jun 2024 19:05:54 +0200
Message-ID:
 <AS2P194MB2170E2A932679C37B87562539ACE2@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <jjewa7jiltjnoauat3nnaeezhtcwi6k4xf5mkllykcqw4gyfgi@glwzqxp5r76q>
References: <jjewa7jiltjnoauat3nnaeezhtcwi6k4xf5mkllykcqw4gyfgi@glwzqxp5r76q>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [AgMXQ0+TrTSac1IRUDK8vMcI5sKrDLqn]
X-ClientProxiedBy: MI1P293CA0013.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:2::15) To AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:642::8)
X-Microsoft-Original-Message-ID:
 <20240618170553.48483-2-luigi.leonardi@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2P194MB2170:EE_|PAXP194MB1469:EE_
X-MS-Office365-Filtering-Correlation-Id: e10ddb0e-e87c-4bb8-b6a9-08dc8fb9097e
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199025|3412199022|440099025|1710799023;
X-Microsoft-Antispam-Message-Info:
	GXLH3XrMs99QVvm2DSUDQPUrv9wsWA2RqpYolBzgjeeTD57nczT3wNvcqQV1DpkH4rO40ixDWL37BK5TciCPZ2BiQPW+r0/En1Da3sGyoT+1ZnMLZZQPzYcN67xZP0r3Nu/nxvbPOHGFSz0OrHB5pzZ/qRrGo0wk1E1WexTcXvyLEuNqcAK2PbO8yoHsD53IDnb6VNhs8ooyGiDgN0vge2mkeXs/tfsKrYm5gTP9gFX8iEYf9ydTu9KIrVH99VoSkZKN0uBwDHuFV7CSRL/yt/ROfvGw37eClxNA3rEWPuDliRWFjBpFljAjtq6qady45SP5nQAA6QutwHUgntEXb55/kx6u1zLva+JswA7pP2604mA1VZ6o69LAwAYg0gcjQsFZDsBJ8K9WPDJYwKvJWTIfgUPr72IH2KzHssg6lTpRICEyTIs5acHPCAqc6pRkTtE+CWBGfIMxfGHKmDIw5xcyJXXlA6P91rWbEw62iGrS4xU7USNeHqfp6BcfLMxV4AVuzzOy1bsjebbgRhZvo+DF7d3acQyiGv42Tj0aJb3Zfsa0IwEKA2MF+RTYuXQtlsvLBSBuSvfMwv66Dg+U2VIMxjzDY+ONVMHjonYPFVewgH+gqJKl/bGDc2e7ByEo
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?THM3jP8BrBcgpi/9SXSbdazmP9E83RetHPss/bn9InqdiB+usQ2VxGdGgivh?=
 =?us-ascii?Q?woazaDPnTgZWyYvOq8OlcOfMMfz5Vjkj34l6QCzTirF85MYU4nWdLPjkW6U+?=
 =?us-ascii?Q?WjKWDe8YeBaBouVIAu6phBLUv1V99cyit08z00VFKn+VkOTJ3tS1iJt+r4Ry?=
 =?us-ascii?Q?UfkJ13Tr9sgxyuAp0W9hwGblPBYOJmlJLXyI97wVF36fdvGZwiewEPc19P1V?=
 =?us-ascii?Q?lF3mEfMbkMnKACUTWy8VNKQXUzcQ7w6u5HYlaNkm8WF6dsnCn6VK7p2MTbFK?=
 =?us-ascii?Q?LyxFPcFGeV7iv7dqJcBv370bFq0QlzZCFwCTarwft4AvBE+uEJWvDjRMPsFX?=
 =?us-ascii?Q?eB4kdfwdeXVVUidKWgpACMc5GhLNDiWcrgqiG/RAfKNCl6fjdALI3Xjt3/Q0?=
 =?us-ascii?Q?Ly6g14QCTto4vge6IzdcPy+Rl5CMSeFqIKHNafaR7RR1W4ESzlixU2pFFi7o?=
 =?us-ascii?Q?2svnaeJlYY9f3POgPPLQWwbGW41CNvd0XKyl+EH2XZB3sl0YZl/go+VdDazx?=
 =?us-ascii?Q?grQW6RKB8yRuF2bJTM/f8JgjaI/wj6NH2SVKbj7lhGhOZe4L/ntktzQTRwGX?=
 =?us-ascii?Q?cdhDV4b+CHqlJRwSE7/gf4d7xKI/EIXp3FEyHmX5nE2hGGzWw/qGM7AGdt+H?=
 =?us-ascii?Q?k83oS6yZWKvyfKq3pLoBXnsRtBImdOZREorztGBIEzVOu3OQ2PNfVqUPugqD?=
 =?us-ascii?Q?k89BElELL2jXfq+e9guOVYogBF/gkGDMwUP7+0fudGHbOQFFnge6RguPw4l/?=
 =?us-ascii?Q?9lcOravW7zTwynag62/7o9CheY0NNTfPBEdEejSw16IXVTH4wvEBG+XFWVM4?=
 =?us-ascii?Q?kc1eP+Kp58fUFFFP0lHg6lfpU9rXHDfP/hxJm/Ep3uc79WyTzvoNNqcyObSZ?=
 =?us-ascii?Q?PA/xnyXgPK8ZZcTRJUTNyKzp6gSBTx6nJyFlZi3AyADW9d6mh9t0rBY9bVHe?=
 =?us-ascii?Q?dNQ467goQk9VkiqvuyRRwo5lJsy8QCxgCT7ACe6YInY6ZQ1y6JtFjR4oeza2?=
 =?us-ascii?Q?sge8EVuS7fP7FNyC5hoV+cloCQrLg+gvMpSGtsYOnsg7IjHSuEODeqsHWma8?=
 =?us-ascii?Q?Zb8IOGR+5Iv7qKbuc367J6tb0GmnSCD+/aDnYJkiiFpa+X28gxucLzkSF7WY?=
 =?us-ascii?Q?6nlewSLsVbfGByywqu6Sn4yJhgvhitQrmpOVUWEri09+eAtRs8TWigGW+BLn?=
 =?us-ascii?Q?gzA/VI95UuAhVHCJrBIkbc3UDDS8VcUyXSkL1ciHsPWGbHJJIx72Xlmhqb7R?=
 =?us-ascii?Q?B0k4EulATAXdETj6MWfi?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e10ddb0e-e87c-4bb8-b6a9-08dc8fb9097e
X-MS-Exchange-CrossTenant-AuthSource: AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2024 17:06:47.4068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXP194MB1469

Hi Stefano and Matias,

@Stefano Thanks for your review(s)! I'll send a V2 by the end of the week.

@Matias

Thanks for your feedback!

> I think It would be interesting to know what exactly the test does

It's relatively easy: I used fio's pingpong mode. This mode is specifically
for measuring the latency, the way it works is by sending packets,
in my case, from the host to the guest. and waiting for the other side
to send them back. The latency I wrote in the commit is the "completion
latency". The total throughput on my system is around 16 Gb/sec.

> if the test is triggering the improvement

Yes! I did some additional testing and I can confirm you that during this
test, the worker queue is never used!

> If I understand correctly, this patch focuses on the
> case in which the worker queue is empty

Correct!

> I think the test can always send packets at a frequency so the worker queue
> is always empty. but maybe, this is a corner case and most of the time the
> worker queue is not empty in a non-testing environment.

I'm not sure about this, but IMHO this optimization is free, there is no
penalty for using it, in the worst case the system will work as usual.
In any case, I'm more than happy to do some additional testing, do you have
anything in mind?

Luigi

