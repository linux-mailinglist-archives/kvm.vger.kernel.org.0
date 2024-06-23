Return-Path: <kvm+bounces-20339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED76B913BED
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2024 17:04:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72FF42834E5
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2024 15:04:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB38181D09;
	Sun, 23 Jun 2024 15:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="WRqAdfMZ"
X-Original-To: kvm@vger.kernel.org
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04olkn2039.outbound.protection.outlook.com [40.92.75.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB4220E6;
	Sun, 23 Jun 2024 15:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.75.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719155078; cv=fail; b=UR5Jfmml48/pH70s47J7g9Uemrac6Lln93+Zl2LwaIpR2J4iMYHLLLg2IapwFFwLdpwVIdGwHSItUqn/wRavzIXeHHAAD3TeQIb/9QCRyPpY5qZ1YRQbr6lx3BbZ7y0Bwz84l7TLfNi9i2lc57wpO6vowYlbnde383zdZPqEoyQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719155078; c=relaxed/simple;
	bh=gCaEd+gaqqh80Co47KTty0GlzLQchxsvTTgCuIAV3Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WtUQWag/UycZPnDAAWN2WPF9Y0ZMuzQexJTVwgNw1u5WED1DhSY6M0jdjUHAJd6YZup7SCyAf4/dps/Uw5uuAwHTi/PLghHOAc3EMGLQbGEifBtqEAAyh8e9q60nuGiB/0EbRQ+BDR+6awvQHPmDuJVLPyQKOEtndLJxqqsqe00=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=WRqAdfMZ; arc=fail smtp.client-ip=40.92.75.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ByKG2+hSucB660Gn+3shEnG5eXTysMj1c3oyWEtjCPVTDt8d4S2lfvouHLeGhWo98HagGU45N6fvsNh+bYXhiF37+4iwN060qVJHRpb4JkG46jj1qxdB5HBbnDvg/jBjWq6MK9XXtQVcw/HgaxU03ZzTtUmEjse2r3EM9AJSz1JZlABJ1yABWFR9Ib89bFSngyNmj65GwaOcrRhdrr7CfUvsr5mWH2QecLMa9d3TbeaAH24sHxiKjJ7IoYH/5qMxEkjE73NM1HqZDFcUcLBP9640w2aTFGC6ag8ys24g4d3h4kwSV6jcitMZLrcEHaX1PMuTqRbcUjAyH5kAh9CLmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gCaEd+gaqqh80Co47KTty0GlzLQchxsvTTgCuIAV3Pc=;
 b=U8RO6aP+wfhYxztVReD89F7gpyRoh9fH2V3f+qC1uH29sepoLBI7zyRbI066r/LfGQDna0yX7Da27Qp4F4RB6fOGodT5eI86iGbKeKT5XHpAgSnBchxyknIoyd4p2ptdPAC6IANPBAIito4l//RwN4Mt2k8XhkPxI1anI00o5S0uerKDHTQU/ThcfEaX6Tbx8BpsRR9Btff06NFVskEC8Hf2iO/wTYWKQFYx9wPk/hi5CsPmlk2z0b4V7qUEESyawmDgv8mVCXlLDWahSIR0vCUrIPksM+u/6iwVtbtsvq5ilnqFdqqZsQYB6gKUZMzknO00fKLFMNZMFqQvc0h83A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCaEd+gaqqh80Co47KTty0GlzLQchxsvTTgCuIAV3Pc=;
 b=WRqAdfMZDLxdv0unXdTfKQdreF4ICzTJjz4uGjJjeUEx1vTbNXqkrNi63ZpFWg5A7uAXxjJwdw4hrqfu1k455H+L3K8snaU5xdc8UcxP8pWdmrCp8osxDAtOrm58Xj0y77P0bp1nm1UlXj2XIRaunNyxwNEmhadU01cn89iabuEI4/6xX/VMt/UMb+sWgTQ1Qmt6QFN37gtrN7M1fYCENfbGyGR0B5kXX7+94mLMax22jsywN5NhgyR9uwswVb9YYkd1JAa3SoK/bV+vK+81ziqRCbWj99nbT7Fq0rV1lgN/jdDv8jIIlyKog+37lebivCKcGbTHzCNlp87guh6mRw==
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:642::8)
 by PR3P194MB0553.EURP194.PROD.OUTLOOK.COM (2603:10a6:102:3e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Sun, 23 Jun
 2024 15:04:34 +0000
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::3d63:e123:2c2f:c930]) by AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::3d63:e123:2c2f:c930%4]) with mapi id 15.20.7698.024; Sun, 23 Jun 2024
 15:04:34 +0000
From: Luigi Leonardi <luigi.leonardi@outlook.com>
To: sgarzare@redhat.com
Cc: davem@davemloft.net,
	edumazet@google.com,
	jasowang@redhat.com,
	kuba@kernel.org,
	kvm@vger.kernel.org,
	luigi.leonardi@outlook.com,
	mst@redhat.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net-next v2 2/3] vsock/virtio: add SIOCOUTQ support for all virtio based transports
Date: Sun, 23 Jun 2024 17:04:17 +0200
Message-ID:
 <AS2P194MB2170A39251AC72302E8F6F459ACB2@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <dlqbbypoowki556ag74zgnsiscsctjf2xfcw5e5lf4b4pg6f6g@af4lxbljrw7x>
References: <dlqbbypoowki556ag74zgnsiscsctjf2xfcw5e5lf4b4pg6f6g@af4lxbljrw7x>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [AEhnebDCHYuCLeqIQH6Wb++oMX18JyG9]
X-ClientProxiedBy: MI1P293CA0022.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:3::19) To AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:642::8)
X-Microsoft-Original-Message-ID:
 <20240623150417.8018-1-luigi.leonardi@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2P194MB2170:EE_|PR3P194MB0553:EE_
X-MS-Office365-Filtering-Correlation-Id: 29a4e9ed-6065-43f9-d722-08dc9395ca7d
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199025|440099025|3412199022|1710799023;
X-Microsoft-Antispam-Message-Info:
	mWZMER+e2+qeTn2KT0UPpKVuFVZ7Ef91fEbNswm6Wvuo0WKPrChidKM2cOAGrhQGjb/PcJzrkLZR+qAQLRpG2JertHWJ3GXqOTOFG4yFKZRpR1qJolXgGy5nP5VqfywThSBmEfOT+QMhW8eqBeuTh785EW3RPCxGqRHtDiMQrVj07aFEyp0DebHke3oRTXc0CaHI1UuIKQpiVQ0gzC3xbS4XycjsU7ge3ZgfQBT6e6b5rG85UtnhP7V4BqzXBYTB+tpyoUiQhCH+12GPPfiJZgn0A1K/dmDN5Vrwqp9nV2xKpi7p412Fpk2w4TvBCX4hDrss92F197chDZxZ18kygSSJxVq6UisWVd5mN1JULvVnlhFHFZ1Lw9GBnTZ820eFYY65AYkmytDU0nL8k7YjfLPDPOjMo2pubBTWzEUT8tjrIMv8j7kA5PmnTCWpnU/mpq2VcThNjIL/hHfwsJssErwVkSNrQtS1mdvaqju3sTwx8cIUhxTm9QSTHpJIREj1zzdwEYfjeqHl+tQzayN9SwFNSYzAXh2ngSuzjoCeDkkaMYHHjsUESJGxKTQqkNMw2X7YA2CmanMldF55nvkB8Zc9a1HWhZDMa2BsAK3pJxD36SMHJOl77eRg1LrX75RZ
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cERhLZaofF9Ye/WB7X7Rh21spmuBPJBHnWte5I9a95zxEEo51vxgmejJfegM?=
 =?us-ascii?Q?GPz4qbgVi4ji9hhkCg/NYdVQdOoS8NqYvbq7O1nef8aACE4sTnNdH8ZUTYWL?=
 =?us-ascii?Q?XGtH7YSk3tVxki2ScW+xtd1qNngA5HeS+gLQFpZwWtyi+RVCAGCOany1SmJ5?=
 =?us-ascii?Q?VUhnTNsRwEo4sC2hprwMXlYPsqeBdjsgNrQPGVwKN8kDpw72W7QffqAs0jtd?=
 =?us-ascii?Q?bFcdeFNCAOyRp0Dj4yKXhHG93OeYhMEBGzVyZQ9ccuLC3cbKELkrHixe1zb6?=
 =?us-ascii?Q?VCOyT3NeEq0MMRJdVlPXVC1Anz72PF1fFO3IEI64p4bByj8TfDHQSaH4MlnM?=
 =?us-ascii?Q?vHDCPsvQ6GncYttC31aZ/XeGsVS+hf9qZokYQ2mQkzi6tOi9NlhkC5+CwEtp?=
 =?us-ascii?Q?jVfv9TDJumpvS5sfqS6mRe4GmItgPeBmZdkDM9N7RL6qwg/I5RZrd5df1h7N?=
 =?us-ascii?Q?7pz+rC+knPJQY+sGr8C/YbMNn0SVl9U47T0jtPSLjNcIDDsqdlzfaTN0OqTi?=
 =?us-ascii?Q?J/SZT6qBEWNoG2SHDZmLTfDtSv7ViP56PW4Tlo8hzQ3MAf7MZSNgUpLpEliO?=
 =?us-ascii?Q?LeyuQMCxjjX0Ak6P1YgEi119gd9UmAZf8PweosoTsZwflOQr6BUrTdz9F0NE?=
 =?us-ascii?Q?Z8d98FL8ZXyRHkfxCB5OlAD81TA/v8GBJrRQtB+xxwfN3xTJqGVbnr2zumKI?=
 =?us-ascii?Q?dtWBn0Nj9dPvQPA3m5rss4DKsfLGdhRU5ZuOW4+lQbzvSjdO/mw9N8i5/Wo1?=
 =?us-ascii?Q?tybWfQeOwiMJmQEFTS8dE0U4k36HCt4uKCKwahmIWZjy61yDUNUazHZEEHSm?=
 =?us-ascii?Q?5c/zu2nJYgI03+kabH1J9wLB4fgsHirFOZGM8PGDCUFiX/XlOetS2DR1/mmq?=
 =?us-ascii?Q?8/QiiemGolKiwdGBMRcVmPAJhLRFe2USg+XSA0G5FnK6pNBme6yOYOxahqf7?=
 =?us-ascii?Q?fhsiP0/LhAwgj5ygCRqh+X9HfgGUbKaPOQS7ljMex2uLRy2kLrkqy1SuvzHC?=
 =?us-ascii?Q?ASo7odZaNyLZodCqnf4TN/pLBOCmJloBPo2ZTZKvn81x+6ovdfBh68t5yjZU?=
 =?us-ascii?Q?JKLy79Zy/b7FJb8fvqvfUlBdgn/mcFvqZOqtwIsfein2hD8R0vZwMWI48t9L?=
 =?us-ascii?Q?Wdpv9gC/T0oWG7oOr1uBfEsU78rqkr2oZXxZrbiIijaC6FLVLVfjSoww5pwc?=
 =?us-ascii?Q?ms72Ia3/C8YQs36jYg/TvytFWp5NwdaYR00IecnmXKa+RPSd5VtfWoJ70jbW?=
 =?us-ascii?Q?vhH5VLSjWJ/nUQ8LFlu6?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29a4e9ed-6065-43f9-d722-08dc9395ca7d
X-MS-Exchange-CrossTenant-AuthSource: AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2024 15:04:33.9495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P194MB0553

Hi Paolo and Stefano,

Sorry for the (super) late reply! I haven't had much time to work on
it, I hope to send a v3 by the end of this month! Thanks both of you
for your comments and reviews! :)

> > This will add 2 atomic operations per packet, possibly on contended
> > cachelines. Have you considered leveraging the existing transport-level
> > lock to protect the counter updates?

> Good point!

> Maybe we can handle it together with `tx_cnt` in
> virtio_transport_get_credit()/virtio_transport_put_credit().

> WDYT?

I'll take a look at it! That's a very good idea.

> Should virtio_transport_bytes_unsent() returns size_t?

Yes! int was because of atomic_int, size_t is more appropriate.

Thanks,
Luigi

