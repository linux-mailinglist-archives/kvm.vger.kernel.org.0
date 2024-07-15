Return-Path: <kvm+bounces-21674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7E89931E05
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 02:15:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B659B22C31
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 00:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1F8C17F8;
	Tue, 16 Jul 2024 00:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="H8d8xWVh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93691AD24;
	Tue, 16 Jul 2024 00:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721088900; cv=fail; b=XnxtuW4zFsIt+a91uMcAWOYA8VsmqXKRzgks/QsMhkSP5wDU+Dzd/1Uyu520YVGWPzWTItMcKNm/A4Mr4c5Gkas7/CIBKQL5UwkZdY6GuFWn8fCs8dJQB2X3oc/EDQrtqWz3ccY/Acu8mZ2S0MxtTTNCkQKxrAwoI3t410MSLgU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721088900; c=relaxed/simple;
	bh=4fmzsPBUbS0rpMf5rUhC9th8KH+CQ2x8jq4qP7kyYFc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VLono6f3vlJxdkyzhnxz8rJtoI0gYbyByQTbRF6vXmrnW1+CdsJfpgA4ZhOdcp3okAnBCwNpq4WJ0nPq+BBvvjFzthvN8x88Qts7ocdc4r3+w0oG8FGnm6BxbzuDNW3HP0ajHUBfQ7xjbfV8e6wPe++3yz3jn58pOFNea/HdY78=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=H8d8xWVh; arc=fail smtp.client-ip=40.107.94.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FSIt2XoVgnVGkPl7wRZEg0O/CaDfiMeTUfBYTdNjAF1gx9W0OoN9OZiafCk06NNA72K6ImM3IndywNpo1ZIlxfugh04u1SRiogXjJwc/qj4CxdrMJszMrl+BhTDAFv+HtSVX2XnQxy5vDGT1/soy4QPNqLWbl5+rI8h9z317Zc9MKhZZ/O21BEmfGpyKoUYChK/3AOwN57VDg0bkxKBhWBVMeu7sNDomzZ1u4t2oUNBo4PCoP+FwDR9ROHGwEqUanu+L/n8u0W+QFhiDQ1DIXvqADlSD8VxWRhV+E3OoOao0cTluDEiYq3zx6ucomjiDIjUm2cTRIQ+JFo/upQmqWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HxEqXpRLHkFAvaRyZ8ZO3CqAPlqbef8fKxdHCle95EI=;
 b=G/l9AKZiokZ64ryoFWY7jpaefWLhgxwo9PkQXxqiPF2FKlrM42ihbmar1y18IOpMH3TMQNXGH48WTKVmHSnUEhceuXDLunyxZvhOqS6VVzJKgk/wOsDS/UH6c4xcma+HJCvuIbrF7ZOqyrDQhTuWz74ofdz2UkOeOUpD0RBFdobi/Fxlfs/D0XlKqK7iZQ8OWA8OROP9Ry/lehAu2Y4KZ4F6U7ba4ZVd5ZwzZRoGdkmF9/l7Yl1NFvc8SRrP6iOt5vlPnlQwTFHErXh6hYzy79Cp1VVeGxw3CB5uPw7LP9kM8vBIZFWNqy//P9jG25AcxQ8CaIGJx+jfadp2vV38Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HxEqXpRLHkFAvaRyZ8ZO3CqAPlqbef8fKxdHCle95EI=;
 b=H8d8xWVhJnrgi+TeZt0QkC7HeTDJuqPq5AhoYoHh12rVQwRr25nAeg3kVBy1Fca/gjCVfpjCorobyHqOw1a3BoUqn8Wa3QWUTd1w5S8J7EF6v1+wyron8pjd/vUuYoD2a1pxbDx6Eam1f+V2Cgx9Wj6976dSsAfzgV2AA/PpByc=
Received: from BN9PR03CA0271.namprd03.prod.outlook.com (2603:10b6:408:f5::6)
 by DS7PR12MB6047.namprd12.prod.outlook.com (2603:10b6:8:84::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Tue, 16 Jul
 2024 00:14:56 +0000
Received: from BN3PEPF0000B071.namprd04.prod.outlook.com
 (2603:10b6:408:f5:cafe::61) by BN9PR03CA0271.outlook.office365.com
 (2603:10b6:408:f5::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29 via Frontend
 Transport; Tue, 16 Jul 2024 00:14:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B071.mail.protection.outlook.com (10.167.243.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.11 via Frontend Transport; Tue, 16 Jul 2024 00:14:56 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 15 Jul
 2024 19:14:55 -0500
Date: Mon, 15 Jul 2024 18:55:11 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>
Subject: Re: [PATCH 05/12] KVM: guest_memfd: return locked folio from
 __kvm_gmem_get_pfn
Message-ID: <3irohxlhnbxg6xvgzex5jxtun556gytrnbborlzhgky4i7mbgy@c5mxntjx33v7>
References: <20240711222755.57476-1-pbonzini@redhat.com>
 <20240711222755.57476-6-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240711222755.57476-6-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B071:EE_|DS7PR12MB6047:EE_
X-MS-Office365-Filtering-Correlation-Id: 85dfc1b8-a356-4c96-9d6f-08dca52c5299
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZdEl3qZpACeF8y0AkTPE46jJJ8B5QaF5NV48ju/Z4dKW80El3PgD1I5igaZe?=
 =?us-ascii?Q?LZG5G1YJG9kOYBKJ95d32p95b5KxepmAscAwZVhPDPOfpfzZj6Fh4TuArx8L?=
 =?us-ascii?Q?aOX6oV05FRZMsSHZAovgN22uTploegNVrOhNf6xCfq7LIZCi1ynk+6dHFejn?=
 =?us-ascii?Q?pIBSq38skApMOY2UnhMybTtrp2qCAxRduO/53rDmeYZWnnU1Jtq2gFy0jYIu?=
 =?us-ascii?Q?ar211BlGy9UnDjCAPTiLlCaEz9rPvAYx23eTmg9y3k+/v/gZZxY1l7+vR/Ew?=
 =?us-ascii?Q?+WcMr45F1KBtOJKGHTSe/CUCCAtEgK6jw77wKz59IKUoBE9dFRrUGIbz9Jo5?=
 =?us-ascii?Q?4+Mw/b8RzS/+0LcVxRaqgKy3tiD60z3AyxjAVuL5DX4+X1Mzw8mrrbzo+ylx?=
 =?us-ascii?Q?XhwbNqYHjLXVfOloGydynFexEsyJxDnJz/7b6HqHG2v6yUkGR43makE5iQbQ?=
 =?us-ascii?Q?fqWW9df3RuFsrWD9P3Z8l27qvop0BT/xVLlnqQ90xtkRNTUkYcrQqgvk/RUy?=
 =?us-ascii?Q?WhCTtkEtq1fnBsByigvcESailXLGfai5/X/sq3GrJKmjDruBymMwljeBOApa?=
 =?us-ascii?Q?K2HQ/5jYsa/iSnFE1Li9FM70XAxM6lByK/FhVj/gBz/pPvfJSBjDmfaShWWn?=
 =?us-ascii?Q?sRC0pjD+oD9yJJHFI4izpZBfuWpPG8P/RMi0mYMSLXwaN3RgRcUN2eBY5Tlf?=
 =?us-ascii?Q?N/Q1NYlWaxnjnU2yZM403oPrB/y8eBUA5brlrDEmlTf4yPSUqDbBxFifJDqS?=
 =?us-ascii?Q?UQVFFlyDwUcrRAgWBpynLwD6Gu+p9LfPkhUJNyDov6NvkF1NXN5AURRZPkR2?=
 =?us-ascii?Q?KLFQoRSjn2MbvvzsyBTDMcMKjsJW6MYweQb7Ec+jfsG7tiYHMVAzDvIVtTLf?=
 =?us-ascii?Q?sqOi5YqJTb7MYMS9fJujmZzg8j9Ur2Ua6ePAcffpMTId/4ogpY2xzPHeNqp6?=
 =?us-ascii?Q?Ot0yL6SW75XeYD1kEX2QvQSw49ChhiKj70/eKEj9MNwVj9xlbFZSRxIVf4HG?=
 =?us-ascii?Q?X7qi+cXp3Oc3mmLDsuPr5tWbb/AUTdTF+PYESO7Gy7lYsDTyfi88jfjtdze7?=
 =?us-ascii?Q?xnRYGQoev14SLvgQP9mGEL5GNl2zKq/COGBAe/N3egnzO2J6larcVTS48ZMN?=
 =?us-ascii?Q?Oj4nKgqhO7fXx0gx+/G0yEDo9Tihwnzx+Ybs50d/A4TRJBzDfvQxUmYa4ArO?=
 =?us-ascii?Q?PuBTcGvU/FoGByuFAw0CzdyWZ/QQ98bdI2PC7oa+J/Vk7Q1v9lSyD9m2mHmb?=
 =?us-ascii?Q?FbHVpb3tuo/RL5pAAPD3xSxhBxjZ+WjNz6s55f0ND+p77oHsrylUCvjFIJqX?=
 =?us-ascii?Q?eB+ii0AqEnx+7OYlLWxSEbUTHotJttVenbZv4m77e5Lk4GVFxqXDAgsJZ30o?=
 =?us-ascii?Q?AOEBho46X7Ma3cxRO3L1NNmNZfCrRDVCdXGxIs9bypfcwMwKV6kIhLp39oUC?=
 =?us-ascii?Q?N6FwWKKrRGjZJekgsqcP9aFgSZj1blKb?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2024 00:14:56.1304
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85dfc1b8-a356-4c96-9d6f-08dca52c5299
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B071.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6047

On Thu, Jul 11, 2024 at 06:27:48PM -0400, Paolo Bonzini wrote:
> Allow testing the up-to-date flag in the caller without taking the
> lock again.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Michael Roth <michael.roth@amd.com>

