Return-Path: <kvm+bounces-23141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E036946485
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:41:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4C362828E9
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:41:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DD1E61FD4;
	Fri,  2 Aug 2024 20:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JDZ+ZE0T"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F85653389;
	Fri,  2 Aug 2024 20:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722631299; cv=fail; b=c0B5D+tILCb+DslboppHP4X/IEcNS3HZn+XJuEDoK2Av7QIxEK3zBl63ZbmolZPBaA8fyFbcA+HYGUYjcw7JD0lPtVBReKjOxvuwdNL0l4Z4IeCiKD8ZV9t0sbo6dGRDg1f5/d5OkSCly2ls38DMvAide2wQWM9UhpIWbEpafD0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722631299; c=relaxed/simple;
	bh=s9p9jW9Kujip1pVae11CJdytEK/Yj1Q0Jb1qyCPGOfU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=loiBvCUBVyr4xz6l6zmgZ2Lf/i0muUogsrWqi9zfL8vE1QZGx/g3sygvRLKFEemJ2tn1EaywhUpoKEYBlLiTkOVjg3ecfFGwQh/w1o/x8gANMscI6hAEP9RD7Dwua46u2O4eszBLkZ+9fHkHr9tSywEC/mMARjkHssZYAEWhqp0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JDZ+ZE0T; arc=fail smtp.client-ip=40.107.94.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LZaOZjnH6AmGmbTatt+1JA38tjUk2qhrs42xq/MwmC6Mn8VvVQUOMVf4sUaT81vzoBLkNgIBoOcaU8n+VvqwhkBkE3AjlSAfPIOosY6T1XE9/v7p/L2y0OJiILpapqaIBmPdnoPXxbCsgDSiuy6N8RRxorQBi8sENrtAsBs6OAsR/e+5/9q/RgjPPIl8Y05fjzZEiCPYdkiHs+3ZQ/z6oy/rkaI6Rdk3qWWz5uWUUUovVHys0hDiNlyDWoWrpocdLKhh2zPnFvU15bqaalrcyn/L5mM+IDwJizyd3N9bdarHYEnD2BesKw9eyMEf31I56+aoGvEQEdqR0PMK5LOOHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UtOex/1g6N/d4vUHiwogvYdbmt6ve6ulnFjGjA/9H7E=;
 b=yYEi/6nBPCi3xqXEh/4YY3IYVRMNwNvoOHFTniINXXVZ5q9pfSLa0IjiVtD8ktgm0n9OPkBphSE3WFZq9RKtRwKGKazZ3gD000CfrmBow6HoCtBiuLai3MdoXeP3hQVePkhbDStJb0VMfe+PXEKuHrdIrcfEIXzEAw2QmN+lvRDyWmI8FlnCoocC6f+PZj3n7TYjes1KBYfACsPwzLC7PgRJCDDZ6ts2pTz/rZ97Nry8uBdvZlcD1NUg0L0PC5icj1NCeArirXYDY/KRmFpc7yDHNQbmSqSgJM9EooKB0aZz0Dd2sQZXUZ9f1NGBJdzlSKgNhU2ZFRqqvdQNYPWX8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UtOex/1g6N/d4vUHiwogvYdbmt6ve6ulnFjGjA/9H7E=;
 b=JDZ+ZE0TPsxY5RKEsNOkZOF2JP7TbfrsGNAPGcTyEeY933qCeSd98w/qU+bqYIrf+4FyZTjkjjUNGes8k4Y7+0o1Sa/8wZtHl9ItKi1Xa+CC/PUe2aSKAhvQc6k74KAAGekjmJIip5LPUKS8Hs1q31r61TE+HyDvkm2p1nq94rY=
Received: from PH0PR07CA0028.namprd07.prod.outlook.com (2603:10b6:510:5::33)
 by PH8PR12MB6724.namprd12.prod.outlook.com (2603:10b6:510:1cf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.19; Fri, 2 Aug
 2024 20:41:35 +0000
Received: from CY4PEPF0000EE35.namprd05.prod.outlook.com
 (2603:10b6:510:5:cafe::75) by PH0PR07CA0028.outlook.office365.com
 (2603:10b6:510:5::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23 via Frontend
 Transport; Fri, 2 Aug 2024 20:41:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE35.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Fri, 2 Aug 2024 20:41:34 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 2 Aug
 2024 15:41:33 -0500
Date: Fri, 2 Aug 2024 15:36:08 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: SEV: allow KVM_SEV_GET_ATTESTATION_REPORT for SNP
 guests
Message-ID: <20240802203608.3sds2wauu37cgebw@amd.com>
References: <20240801235333.357075-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240801235333.357075-1-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE35:EE_|PH8PR12MB6724:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ffebfba-b1df-4d80-f6fb-08dcb3337f77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HX//XjaGWg/o6lhGr/w6qw1Ws/3vRJJOdfRScoxtfOpSJ0n84P1mWUpJoqgM?=
 =?us-ascii?Q?uqLRbgvkVIT0Jrzew0iW7QQSmjbc14m2hI6wuoYnQDUWzpPF4LtKnpqIjmSg?=
 =?us-ascii?Q?pw2b77bt6eGuRNo9T52XEm3FqqJKMWMVImqCSKwDsBQC5ELOgPnVVNVgvvA2?=
 =?us-ascii?Q?rz4auSt2GuXtnC3NCeKe16vzmoX9HYR7rRsn34woHRDlVH2X8YR3Uium1kps?=
 =?us-ascii?Q?T9TNfKya8LD4KemZNHS6zupGmlSbJt9a7mqQDbmWoZfbdjFxtqA8DHsFmoAA?=
 =?us-ascii?Q?RR1Hd3HTDvwUdnHjYJ2qpfO7xanv0apTt2jJZTlJ/sp0AUQUFt2WmPopbwj8?=
 =?us-ascii?Q?pXqeNEHQuDV8m29xFB2OPcianARkt4cjdCe9czL2IU6i2PCnRDBs/7xkonA5?=
 =?us-ascii?Q?b/4VrUw+94lH4CYzQS0pQTvFAxEJcPaOZF7qUdosktT7iIeZEg74Yg2Fe+Et?=
 =?us-ascii?Q?PG2ri98E4JAFm9PUfs4N4sznlUqCHN/RvKA+KNoSAslIQbGiR5NERfc8jnKQ?=
 =?us-ascii?Q?qB1XJOcOmA37PsyXkC+7ohVM4dvmnaCsmAEzMJdVWJz2hCPVCUGK7DdcR+m1?=
 =?us-ascii?Q?jEHfkag9kepKP59o9f7IueYglSkgQKB0Y3MU9L7x2VslJXyzvuxFkT9j6FUZ?=
 =?us-ascii?Q?rU40U8xMV1TEGcLdhugk7bwckLHS2YiUIJKWZNAI2opSizsCfdAwzwCTJY+d?=
 =?us-ascii?Q?D2kX4n4+6/6R9x8JPzfieq9/IxxQ6w95J+0ar51S0AQ8QgBRFfM+NnVvVqoL?=
 =?us-ascii?Q?eyWwOhmUZNs2a8ZAqXgCq1orfHdDydDs9BaAcFWpaBv1yRLD6x+CqgBdrzFB?=
 =?us-ascii?Q?RAWgCesTB6lm/fts/Cc34WgD19e4S4M5obxs/9ZQ9RT3VTgV+imSwizewGaV?=
 =?us-ascii?Q?hhdjWXmPJ00E29ZcOcjBo4BFQ5RO8y14vjNDlas2W9V0kQRhwqbmN1Dcgpvg?=
 =?us-ascii?Q?0UtziGbRcD/hq+iYSkgwGoWKY+Oc88C7/Jmf9pqyxEtCTUOSo9aBOlxSyGA+?=
 =?us-ascii?Q?JlwIEXRzadqNbtlXKsZAmLaoH4rNIO9CyKEFF8d1WG0DkIe/tyJTpmkeMMpp?=
 =?us-ascii?Q?hf+wTKiAg3f4EupaAb/CgxXVTMMslYVDeRXKpLHOn+4IsBtRx4dB/W4xe50D?=
 =?us-ascii?Q?ww4SmjN5AAwihBpXw9diQQ/1KBQ2NymF3QQmB6qxrktLAmmkuYJKmrTx/6mt?=
 =?us-ascii?Q?nAPV2aHxlPUnSiOHw0vdLgRp2F1+O1tfNWn9a0Q1QSCoYOlaZrw4GWz2bF5u?=
 =?us-ascii?Q?uUs8GScKFRNxh3O3JN9+uUuzNNPYav+PuCksL+xJunCHn3QVmcYMJXbf8hvW?=
 =?us-ascii?Q?r2oxfYwQj2VlTzbRKUFg+MqCkxhWsdXY7R+/OzT8x8nyTzleKiZp0pNS2qWX?=
 =?us-ascii?Q?N9xUmhzcEVn3y4xyw9XltOuimirKppwW0i0fXt1jWJg6YCg5W4gUvR49/VHs?=
 =?us-ascii?Q?Z8Nc5hrdK6K2NrwKTkEX/tWvLHNTDtMh?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2024 20:41:34.1790
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ffebfba-b1df-4d80-f6fb-08dcb3337f77
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE35.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6724

On Fri, Aug 02, 2024 at 01:53:33AM +0200, Paolo Bonzini wrote:
> Even though KVM_SEV_GET_ATTESTATION_REPORT is not one of the commands
> that were added for SEV-SNP guests, it can be applied to them.  Filtering

Is the command actually succeeding for an SNP-enabled guest? When I
test this, I get a fw_err code of 1 (INVALID_PLATFORM_STATE), and
after speaking with some firmware folks that seems to be the expected
behavior.

There's also some other things that aren't going to work as expected,
e.g. KVM uses sev->handle as the handle for the guest it wants to fetch
the attestation report for, but in the case of SNP, sev->handle will be
uninitialized since that only happens via KVM_SEV_LAUNCH_UPDATE_DATA,
which isn't usable for SNP guests.

As I understand it, the only firmware commands allowed for SNP guests are
those listed in the SNP firmware ABI, section "Command Reference", and
in any instance where a legacy command from the legacy SEV/SEV-ES firmware
ABI is also applicable for SNP, the legacy command will be defined again
in the "Command Reference" section of the SNP spec.  E.g., GET_ID is
specifically documented in both the SEV/SEV-ES firmware ABI, as well as
the SNP firmware ABI spec. But ATTESTATION (and the similar LAUNCH_MEASURE)
are only mentioned in the SEV/SEV-ES Firmware ABI, so I think it makes
sense that KVM also only allows them for SEV/SEV-ES.

-Mike

> it out, for example, makes the QEMU command query-sev-attestation-report
> fail.
> 
> Cc: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/sev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 5c125e4c1096..17307257d632 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2587,7 +2587,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  	 * Once KVM_SEV_INIT2 initializes a KVM instance as an SNP guest, only
>  	 * allow the use of SNP-specific commands.
>  	 */
> -	if (sev_snp_guest(kvm) && sev_cmd.id < KVM_SEV_SNP_LAUNCH_START) {
> +	if (sev_snp_guest(kvm) &&
> +	    sev_cmd.id < KVM_SEV_SNP_LAUNCH_START &&
> +	    sev_cmd.id != KVM_SEV_GET_ATTESTATION_REPORT) {
>  		r = -EPERM;
>  		goto out;
>  	}
> -- 
> 2.45.2
> 

