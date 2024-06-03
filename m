Return-Path: <kvm+bounces-18676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD80D8D8754
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 18:32:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19333B217AB
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 16:32:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 310BD136E1C;
	Mon,  3 Jun 2024 16:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Hyj+tBWS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8102B1369A3
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 16:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717432330; cv=fail; b=G6szErHmg+ikYe6tmkmQ5t0waD9HXtRpwHHhamZbXz3RIgjxQk2af0CrYw++H829UpZvpBA7fsBvfFnkl/xMWBfAeJ0cu8HkafI4jp4JK5AjTCAxkM37+lH6G0Yyr/0eWGIl1UYEV+WNwC1reI/9OYrZVDdH2OGI2Rm4R5NBUNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717432330; c=relaxed/simple;
	bh=zoeeSQW2xNGvaA2Z+UYsjXeb/nFpTHbFkK9GTN9D6sU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=klOuyceXEbptNHxmZddSxnoHBuxL2P1VJH1YZKlkM2qLhTo+lELTrAihxnJ1FqGM7vcpL7o+8jGfmH13EqZESVCBCKMqkeHtnEQM7cR/i8IUxN40mGRWrHpfHFWGH2AGz/swcSorkEaMlw0Ee+Wj+m/8xaedLTbsRN7wqxlfG10=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Hyj+tBWS; arc=fail smtp.client-ip=40.107.237.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NKfaptuOLJvlp0T1oNDcuxa35fqyAerglRXbawG1HIcipo76O5HJQjLpK06L0lry+5FZ4Utf01QxJqWDWXJoyerx9U6NToXZFliA6a5h4bEC7nWpH6cVWavbF+w6h3X5Ea31J9qr6jlBJ7d96dPS9tUCaJQ6RgAS8s0NzqsXjbmc6OkE8+71tSX6kTE3QE7hVoX4yjcfRiwFhVWbH2/uw+vCs7iJ/WEhMCek49HZrqeYoHw1MTBgvkGHV6VE0iKNtbDdoiE9L5V8n2hhiBTgbIj8WppOd9kXOzi6rypC41gAWUth0YEDtngt2v/sZnKsn53BU4DGIffO/Fx+BHGBPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HGabzVk/Q4H8sodOzisnP7UO4HZ5JkqN/axVNjWoUoI=;
 b=mpegGccgparZi6uk7DmspOVvOTxqNAeQXQyHsHr299yIbx/AjzMYqwuex9OI/VHAG+HzDs7vdv4QEgUILFmEtfaDgvVS9TsgBL0ByxTi4T4ltSpfVN2F0/bVIzXwirQSC8zBaa78h6BJ5ErSsWTvTP95j7Qu+9lOqxPXVVXBh8FEIfNxMCP0tb2imIbaM1Cvp4mC4Vs3TflkMZZI5s1yskQgBoMYjn84Ff/Xeec8i/s78Z3jAUQt1JQ/VRUyhs9/roRyw2NBXijJNBZa928yEhhsGGKoNwmpI2TF1NvlDmm4mSQ4lMMr6fNVnx4AAhjpBrweHS+iWBGBnIhjXbVYXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HGabzVk/Q4H8sodOzisnP7UO4HZ5JkqN/axVNjWoUoI=;
 b=Hyj+tBWS+13bJSlw3ja5WxsGmXJ5bqP25IgyAvC+7a/IP5DC/808mRZu2eAHVCySpt/dMpRnMKRpC5BxUGFjnz1X/XV3Mz8zjvgo/NfxaAOA2nSki9nSYXe8BrGpJoSr32bsFvUP7FN0zRljf06kZd32OUJreqpZhtUFdF50DPI=
Received: from BN0PR04CA0109.namprd04.prod.outlook.com (2603:10b6:408:ec::24)
 by CYYPR12MB8939.namprd12.prod.outlook.com (2603:10b6:930:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.19; Mon, 3 Jun
 2024 16:32:05 +0000
Received: from BN3PEPF0000B074.namprd04.prod.outlook.com
 (2603:10b6:408:ec:cafe::ce) by BN0PR04CA0109.outlook.office365.com
 (2603:10b6:408:ec::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.28 via Frontend
 Transport; Mon, 3 Jun 2024 16:32:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B074.mail.protection.outlook.com (10.167.243.119) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Mon, 3 Jun 2024 16:32:05 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 3 Jun
 2024 11:32:03 -0500
Date: Mon, 3 Jun 2024 11:31:48 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, <qemu-devel@nongnu.org>, <brijesh.singh@amd.com>,
	<dovmurik@linux.ibm.com>, <armbru@redhat.com>, <xiaoyao.li@intel.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<anisinha@redhat.com>
Subject: Re: [PATCH v4 29/31] hw/i386/sev: Allow use of pflash in conjunction
 with -bios
Message-ID: <7njm47hsc56gau45qq73qkqmqms7eixdk2yt6kh7mh7ujjcnvt@isr6imh63s6f>
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <20240530111643.1091816-30-pankaj.gupta@amd.com>
 <Zl2vP9hohrgaPMTs@redhat.com>
 <wfu7az7ofb5lxciw2ewxoyf5xggex5npr7j2qookddfuaioikk@3lf2nzapab5c>
 <CABgObfa1ha1MXYWLRTfBtMCTh0n=wNO=9jbRgbO10ksuzMO9hQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfa1ha1MXYWLRTfBtMCTh0n=wNO=9jbRgbO10ksuzMO9hQ@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B074:EE_|CYYPR12MB8939:EE_
X-MS-Office365-Filtering-Correlation-Id: 98f245cb-315f-4e57-c60e-08dc83eab48f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|376005|36860700004|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SjJWc0Q1dVdDSzd5dHhVQWJMSDNsQXE3YWpXZTlFVlNwWFdjNEFWQU5VZUEx?=
 =?utf-8?B?QVliWmpSaXhjSVAyVzdmbVNHY2lKZVh3MmthSzZ4Tm13cWxDc0E1L2t5S2Iv?=
 =?utf-8?B?cUNWTkpRNldYNHE5b1NCeHl3b0NEeFJGc3owbndCUkdBaXlVSXpiV3l4cTc0?=
 =?utf-8?B?OVZrUFRzU090ZnBTd0E3UXh5R25OdTh5NlV0OVVaaGg5Q1BaNitwL3QyQmdv?=
 =?utf-8?B?aWVRa0tYMHlEZFMzdkE4WDl4bDVGUk9uRkd0dXVnMi9lYWhQRkk4Mi8zdDFY?=
 =?utf-8?B?aTVpYmtVV2lsU1RIZTVicTJBbkdTYmNQaUk0ejJtQ2ljTUdycU1zQ3N5Q1Rz?=
 =?utf-8?B?RlVIb3hLVmcwdFFLcFNwMDh1cU9zWlB2YThuZEM1YUFXdWZmWEZ1a0lwSUhz?=
 =?utf-8?B?ck1FS0pWSUpvTnRSVnhaZ3ErOWhrQVphOXdTM1E2YXhPSHBYUThzaGRCbWx4?=
 =?utf-8?B?YllXSXN2anEzT05PMHptRGJ3QkZEZUVqQlV3M09IdlAySTk3dGxabHlhK3A3?=
 =?utf-8?B?aHFGdm4vMkVlSitPcmtkRlgxdnJyUG5jRXlrUHNUTWNSTkJ3TjVXRzRvdFIz?=
 =?utf-8?B?QXhlL2JwMmViSkNRbUJCN2xTTWJDcDBFZHNIQmU1c25LWFptVndNcDN4L0tK?=
 =?utf-8?B?L091UExqQWxWbk5LUjRsSzU0RG5rdGJJbVVGVm1kU0VNK1A2YlVTLzlaaUE2?=
 =?utf-8?B?QUMrY1g0TWFFN1RVNGtwSGRxZFdpQWY2eTB0V09Hd3dJOTNVRlJ0aWdna0Rz?=
 =?utf-8?B?SG1ETndjT212TC9hK3lBeVBzUzQ3RUdWWTRKZUNyTnVGbENpanlOdnR2cnJU?=
 =?utf-8?B?bjBOTFQ0Y2FwTlhiaDdYOS9samxoeWZLNFZNTzhmZTAzVXpkeXF1VmtCVXJu?=
 =?utf-8?B?T2ExSi9WR2owK1NBeXZGWURlY2hKUEtGUkJ6bE1KbHRiVFFtSlZMT01INHFQ?=
 =?utf-8?B?cThNV0NwSmZGMXlQdXg2RXVESHV6WTZ1THRuM1AwWVVPNWlmcWt5YmwvbHB3?=
 =?utf-8?B?dzh3OFB1b2dGM1hEQjNSaGRjbkZoTmJQNFRObWVKb05JdVFiVXAxV1ByNEF4?=
 =?utf-8?B?dGpVNEJxLzRVVm9sN0I4Q0UzV2FLV3FGaDdNSG1WMVFHcERpWUR2RnBDVklK?=
 =?utf-8?B?V1VHWnhqQmJxUHZFb2kxRHZnQW43VUM2VGJDSXpQNXFEbTdBZUI2aC9mVUpQ?=
 =?utf-8?B?MjBhOFJFdVJmT2FvZm9jbytxS05qQ3JneWhrMFJkdnpXam43dHVRdXlhNWpZ?=
 =?utf-8?B?bXBxV2EzN0ZrM29PdzdVeUlWc2NNU3ZxcmlYNWlzZ0xhc3BBZitUSU1yc2RS?=
 =?utf-8?B?WGo5OVRTTzhJYzhkMmpDV3hMVE5JYXVITUFHb284UTBDeXdNR1ZONkNzZ1Zx?=
 =?utf-8?B?UCtrcWJiZHY3cmptSWkzVTdZOFcvL01CVnVtT0tIamJJaWtCbkg3VWhHV2VJ?=
 =?utf-8?B?MERjSTVWdHVTbndHTHRrQ1F3c0xYbGhncU83cHNzRXFKTk9wbjRTSnhPeGJX?=
 =?utf-8?B?MnMxSGRpbTdwT01SckpNV055UndmQ3piTmxkNEZIZU1ZYmRMeitPdmIyTkJB?=
 =?utf-8?B?U1VEMlpFbnN5ZXR3M0tOMTlYejh1WWpWcUE3MVBGZEEwelBiYmNJcW5kN3pK?=
 =?utf-8?B?MHhtWGNzNnZmNjJGNGFoMFhWRCtGWXp4OGxGOElJK1g4OVZpYUljSzdCYkkz?=
 =?utf-8?B?VndTemozdXhVUnJtSndPaDBCT1EwMnljWGViamxIQmpaYkhKODlQYWd2TExo?=
 =?utf-8?B?S3ZzV3R4S1VGOXIycFBvQTc0Y08yVTJhVFdUMmhOeFllMVM4alg0YWVGdk9k?=
 =?utf-8?B?eHRwSVFyVU9Id2JsTFFwQlJNOW1UUnNGRm5NVXp4Q25HK3R1TmFjWnJiNDVo?=
 =?utf-8?Q?ztDzDK6//x6qs?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(376005)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 16:32:05.4206
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98f245cb-315f-4e57-c60e-08dc83eab48f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B074.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8939

On Mon, Jun 03, 2024 at 04:31:45PM +0200, Paolo Bonzini wrote:
> On Mon, Jun 3, 2024 at 4:28 PM Michael Roth <michael.roth@amd.com> wrote:
> > So for now maybe we should plan to drop it from qemu-coco-queue and
> > focus on the stateless builds for the initial code merge.
> 
> Yes, I included it in qemu-coco-queue to ensure that other things
> didn't break split firmware (or they were properly identified), but
> basically everything else in qemu-coco-queue is ready for merge.
> 
> Please double check "i386/sev: Allow measured direct kernel boot on
> SNP" as well, as I did some reorganization of the code into a new
> class method for sev-guest and sev-snp-guest objects.

The patch changes look sensible to me, and I re-tested the following
permutations of split/unsplit OVMF with/without kernel hashing and
everything looks good (this is with PATCH 29/31 reverted):

         |split     |split      |unsplit   |unsplit    |
         |hashing=on|hashing=off|hashing=on|hashing=off|
         |----------|-----------|----------|-----------|
  svm    |      n/a |      PASS |      n/a |      PASS |
  sev    |      n/a |      PASS |     PASS |      PASS |
  sev-es |      n/a |      PASS |     PASS |      PASS |
  snp    |      n/a |      n/a  |     PASS |      PASS | 

  (split + hashing=on is not possible because hashing requires AmdSevX64
  OVMF package which is built unsplit-only by design. split tests done
  using OvmfPkgX64)

-Mike

> 
> Paolo
> 

