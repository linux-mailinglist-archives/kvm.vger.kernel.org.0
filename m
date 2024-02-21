Return-Path: <kvm+bounces-9255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA2C785CF9D
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 06:29:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCC5D1C22006
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 05:29:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9CE539AF3;
	Wed, 21 Feb 2024 05:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="CE1sx6G2"
X-Original-To: kvm@vger.kernel.org
Received: from AUS01-ME3-obe.outbound.protection.outlook.com (mail-me3aus01olkn2186.outbound.protection.outlook.com [40.92.63.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319113A8C7
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 05:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.63.186
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708493360; cv=fail; b=slNbukrZZR/pDe2W22DfOh9M1B9VZTyu9b01rWfqaM8Esc9Y5AJWCtYkbmBIM9WsmGY2FNqzJhWJca4N+yzeqV8cLsprE+/mnWwGoTKStgSiS+7rd1oumkNn/3qcoBNMQA97BLPCEkwcQWWRerPu5DK7cDgnHmZDC3Uc63acatw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708493360; c=relaxed/simple;
	bh=glVruQFAOzqnbPxV/mzeIsmQzEl1ySq9bsfm34G7C1A=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=bmMSuy+3Z21I4AuoUIjdmPr6NJCtRBL0KcniCa/cPbnjNgpuSmqDhSQU3bkxb+cN1MQPaKRlqDkw5stCee+hK6NJUZeVsoNqJzy7C/1B5kKrOLW/yyhCLdv/D9PV8r6XSRDXmnaU35pNc1mI71pORHXiV1+AYPyOkB4VbcRpvlA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=CE1sx6G2; arc=fail smtp.client-ip=40.92.63.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TC+Xc7rJ1QL3k8lWADETH8Pg/wJeeMXvctb4YRlVm7+vsj58dOXu5dbfw+StIbFZ+r3l0hJ6g5QbTnnH+uRT/i2kROJeBhFS4WU3+jnda0/d51oS9PrKH/DzI7hy+o0Z4SaPORYuysE8kuWXBThns9PLpib4f+FHq6sFoExLwCP892Ydc2yDNh9AXiovk7Mo5uS6GChf3Gby8FOVxYjeM+5Y26VZYQTpv9C/mSsdOq/N/7237mV/waGd7hosYj0Jkx4DJO6c+g6qj/d84VGNeeC68Z1HRVzEBBRTeGHqcz6aUSgMf0YX+CaXGeAdDCNMTbrp/Xio2Emq7NSYZjWCLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LU9i2kQatEIT8Dh9wxhRKQCrh/rCnt+dYiY5UDZ0lOU=;
 b=nTTdeQ1fwxQJFRbx1A/Ka6M098zUu3wBkpl512CKVMeTqp/r/93I+IE8YGJjMmzR594X06Y5lN5ikQPMhexlvbvomhfawu3E0sW9CCLlCZekdUl+nyUJ6df2kw0PjuL8I3D0ofsotP6Nlmvt8y8Cy+kDg7aqS65xE6j8ubhsK1xcal4+E/zNpMKe9v1ySk3IPcuXyrhRnWbarRDaXpeM7Rx3ujAYO8URTIBnp4wuRXwgjz2SRH16D7WcO42FLJkEFrbtShuasxLzU2WAXUpp7MVxceMvKPUQ/zLodAZK7sSZpscduU6wxabh2LlvZ/r7RDNHzTz6F0WRiiLMdA/VNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LU9i2kQatEIT8Dh9wxhRKQCrh/rCnt+dYiY5UDZ0lOU=;
 b=CE1sx6G2Nzrjxz8/HR2ZG8NZ0hcnJU0cJ/+E984cdNC72htPcRcAC44MxR0pSO+Rs/rXaaQbm+qRqgMAQqOP8lbLeXlgrDUgRpoBhQAE4aooAjK62acbodp7Dh7wJt9WO4DVSnVogsPQRonQHRnIjA0SMfxUAdLGbfRbxK5OtQUqFl4hNjueCK/tPQh9EcxnHvIKvIgtCnDSoev+lRkIVrfmqcEE9h3gK4ld4g+is1Lc3e5azodwTTYD2PPyZG0mFZV+X7FrgQ2UaISyGM1RIKWZUJqgV9ZlpdCR/QS7In7rBUIUB9UvQSZmauPpYUGtRGUi7ZGZ+cqHJjsMFMI7TA==
Received: from SY6P282MB3733.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:1bc::5) by
 ME3P282MB4050.AUSP282.PROD.OUTLOOK.COM (2603:10c6:220:187::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.39; Wed, 21 Feb 2024 05:29:03 +0000
Received: from SY6P282MB3733.AUSP282.PROD.OUTLOOK.COM
 ([fe80::9a05:aec9:26c0:28d7]) by SY6P282MB3733.AUSP282.PROD.OUTLOOK.COM
 ([fe80::9a05:aec9:26c0:28d7%5]) with mapi id 15.20.7292.036; Wed, 21 Feb 2024
 05:29:03 +0000
From: Sicheng Liu <lsc2001@outlook.com>
To: kvm@vger.kernel.org
Cc: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	Sicheng Liu <lsc2001@outlook.com>
Subject: [PATCH kvmtool] x86: Fix bios memory size in e820_setup
Date: Wed, 21 Feb 2024 05:28:43 +0000
Message-ID:
 <SY6P282MB3733A7DAEFD362632DAF4897A3572@SY6P282MB3733.AUSP282.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [C8cmazsJinewI2fNritQkrUMGfkMmjfL]
X-ClientProxiedBy: PS2PR02CA0067.apcprd02.prod.outlook.com
 (2603:1096:300:5a::31) To SY6P282MB3733.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:1bc::5)
X-Microsoft-Original-Message-ID:
 <20240221052843.2278063-1-lsc2001@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SY6P282MB3733:EE_|ME3P282MB4050:EE_
X-MS-Office365-Filtering-Correlation-Id: db34e687-2f33-4e8b-1311-08dc329e0389
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+KwXsa2Q457KZyWDSy/vFmLlacZzjkjbpjbSI0h30zpnV6RSrkY4FjVNRM9CDBcbnUEO6wsu4FA72Qxiub6eJbd6e1+tVgg03/laP1fqBSOZr3AJ/ILpjQCBER2glusJoDFpLnzDa55Yk/9KHZibod0iQa5aePNgJ7rtHc4+AphldW6ZNrir7/VSjPBO/dtwDOLTvb2qcWWQ+JHsFuuijR12dzNSJPnT7knTR4jQQ9SCM9ne0tx0ixxqh4ElycRQ9bEyd0RzFN6T0PC2fTNxRM3lVIdUD/FV+GTgEWu3EIiw9f+jHG064psyT0Y4ZSA4wc5TC0fuVndyj2DjD8FRoBWdSJK0yhrhRZzMOgOpq3Q7y5NQVwX+t/+azF0n7Lnm6Otku1d8abrKRW9TPQ8f9xKDCrTNlHy9sxoaA134MdAkKLISCcsyVA2xLWEtVhy2LG/3iZcf0UPFBzgTxDTwxNeBRkH9Uz6o8w5m+UpUL9xiG2zxazpR+L/lf3xR8aT9RzFuG5mmPGEfPIWuNBLjCTBV+hXm3Wo5avojKTF7cR0Xl5wjUwXLGOTVYydfowvNCESzHw4DYZYpLuMVSy2rIp8ngrXOSYmmVyly78I18nHe34lv92oOJeuwp2Xidrf1
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Y9vJ/v2+8QhZ3eFwgXSuA3yfaaq6E/WBqGMkRLDgJ1Ri+gX4yqzG7pwhD2Co?=
 =?us-ascii?Q?d6QS87KGIQmYbEeAjxowXiJa7hTMggu5Qc3MVT257m/5TaA7dbkkZydfXh1g?=
 =?us-ascii?Q?/FaJGUbilQEJ/qRAmWg2NNUN86f9gP8oeQdOEL8WA2sHuvsMo/enMTLFPoKJ?=
 =?us-ascii?Q?NFRlufNhGowb0f0ve5Zthdn9mi6lQB2pXB0y5vmjGdsT38hpv5gwj+U8WZ4z?=
 =?us-ascii?Q?2k2W2GHTPNRe45vWyWX2QJP5J7CPq9+jw2wfY5i0dmPLe+JlAKi8zZgRar/U?=
 =?us-ascii?Q?f/vDNZY2l3ClK3qYrJiBKMYq7oXJgh3BfukTDyOhb9mMHGYQDRNY/v93OoLZ?=
 =?us-ascii?Q?rTgA6yJe0p2CN8z5rPHiTdlM1RS6L+sv1NGjLddZAe93RVMs1PhAaaQCjCV4?=
 =?us-ascii?Q?kM9YAzmwgrTbEaNVPaS6LWN7I1XaEWfMS+ODqWf4P1PRG9wHE8XSA3BcYrwa?=
 =?us-ascii?Q?gHZbVj3EIOR7KkfBzCJ1NRAKCdggLk8iMklQdiIEDfPcgMZf5uwJL5j7513f?=
 =?us-ascii?Q?s2Xs37HShU5ACcoVO9ILzkLBL5pweGo4gXm3k/Im9/CaqXua/mrCEKk6lGHU?=
 =?us-ascii?Q?MCt4RqWg5QPem2zyZQgwhgs4TryyzDPheNoFKDVFWqzSdP/NFN3wnXgZG+OS?=
 =?us-ascii?Q?5Eb/W0rHYUgxOPlkyB3m3zS/obY6Skljgrm9ARzVF9XkOjha1a5H5X9pq/qA?=
 =?us-ascii?Q?3gPoB8PmM4JA/T7cKm+yvxwWYp5JihiCvvrOAQ4y8sS8EMw0xO/8DIreyj+R?=
 =?us-ascii?Q?CPQNS1/Hdq1mK5BjhOPIhVzKVkS8sLtKKbzA0+Qu+72N8AV98EXs9GlnzMRA?=
 =?us-ascii?Q?+4XsEgbp8xYrjBKx3rzahY8xLokTZodFRktDDRNWM+6dKvAQKWY6eRt0tsJJ?=
 =?us-ascii?Q?ZSB4f0MwFcxehkr4j3IWOYrkisBah7Vv2pG3cOzA0nUeDQKjtLkF3fp0Lkui?=
 =?us-ascii?Q?2ErQ0eUrzztsRS7N+c52xy4DElpE+YqHmeBIHaDL89mRhKHEux+ZKemmms/Q?=
 =?us-ascii?Q?w/Eu1AFw1ITwn6QpkXZdFGDqoLcMRyftPPKzAGMRBJ5U7B6RwEhh59q1k8Hr?=
 =?us-ascii?Q?O4FDvAkzYosFqfji99MMlxqXCnCT9IXxYEN3QNbmoFsJfgEw8C2VdX3JhnRE?=
 =?us-ascii?Q?fO6Ijpsv687tQ81D2bpWY6rPhx3qCSKAPM1tyjmND57+QdnQcQNtUPO69V3c?=
 =?us-ascii?Q?WCYWDJpjZBMwyXLS0h1Pu6zvVk6eo5bEp8/5BUnGiFcTf7Y4Xjc89BUlHcs?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db34e687-2f33-4e8b-1311-08dc329e0389
X-MS-Exchange-CrossTenant-AuthSource: SY6P282MB3733.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2024 05:29:02.9526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ME3P282MB4050

The memory region of MB_BIOS is [MB_BIOS_BEGIN, MB_BIOS_END],
so its memory size should be MB_BIOS_END - MB_BIOS_BEGIN + 1.

Signed-off-by: Sicheng Liu <lsc2001@outlook.com>
---
 x86/bios.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/bios.c b/x86/bios.c
index 5ac9e24ae0a8..380e0aba7129 100644
--- a/x86/bios.c
+++ b/x86/bios.c
@@ -75,7 +75,7 @@ static void e820_setup(struct kvm *kvm)
 	};
 	mem_map[i++]	= (struct e820entry) {
 		.addr		= MB_BIOS_BEGIN,
-		.size		= MB_BIOS_END - MB_BIOS_BEGIN,
+		.size		= MB_BIOS_END - MB_BIOS_BEGIN + 1,
 		.type		= E820_RESERVED,
 	};
 	if (kvm->ram_size < KVM_32BIT_GAP_START) {
-- 
2.25.1


