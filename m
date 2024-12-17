Return-Path: <kvm+bounces-33906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFE979F44BE
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 08:06:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80EF0162136
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 07:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A69E716EB7C;
	Tue, 17 Dec 2024 07:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="C37oaf0O"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2060.outbound.protection.outlook.com [40.107.101.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E82C143C63;
	Tue, 17 Dec 2024 07:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734419147; cv=fail; b=pdd5rJKLWIvrVlngo3sfHzUKyA6EwfhZZ1aVEI9QdR7Q1lK3Ha34co5MCpLR+GwwJiMxxA3UCVfrkXlil8RQ2eRa52FBXjTbQs/XOC2AJCtI1Ky+DxTRIeulkT4YfHU44IkgYmrdZ4mCoJYh76Yl3cOYR0/l9vc6472V4Us/Ie8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734419147; c=relaxed/simple;
	bh=LdH7pYuBOSc+ICZrs/lBjmrLHpFJ84bvmKX277PRJMo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=V2TBAgRT6gvzS0DrWkCvDaJXV3TZmJ6itJinlvRa5xy1q1sBVeLs+WY8BRZqmYyulbu8O2oCbhnuLybcrl2HbUwo45UjRIJYiUi4prAMdtaUic39QrMcGgWl01whWPUtJsDBTujCqZiJGbie0LW4Q2s3L8QlSv9LyqsUv1XERNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=C37oaf0O; arc=fail smtp.client-ip=40.107.101.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n6jG6T1hlKTGwroI5GYztOzcCcajdrd5gVPcLG+C7s9AomSRz5gfDgSM2XD4Ncn9q8FgUpeFK+DH193cMWQjTRi6jWejvEOjw5zzjKsMYCN0IfDvuC7fsRL5FflnXkjht/atQgZeFGbjprggu2xFGV5frJ9YdkTPC6VuQTwY8DcmHN3iX74uOzm5nQCoCjgqOcCK+AWewz9ISS89XfAdpIqnUrMq7PKY2eUIwWRT/Mt0Z6xKSKnX9vqsZLZVaP3+azFAOQcf4m3EDbfFBX1pWXuGEP4pnrD0bryHs+X57zeseqfYYpZNWorTVNciXdEgdVcltfg+cFCpKLIn1fW2lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=90+fjc65WxBVpLfOZ8xUHlEfVvu3Ct5jvwB+vxGyDE4=;
 b=qlGAQrs87fv+nZ9DS+TzLRSszKL6vUTh1Wr6FNxmlCPAFlovBmqValTr4E8iom1Y9jQf8F+6CKu5WZBCmHCtrqPm45/OKMOt+NEutxzw1WgtsRjnrE2FVGxeG6gvNOA3FI+szv1IPiZcDdegKxjHfDuWtlYSuJnovJeG6ulSMOgJA0/QVt2dOAhNl96Te739rPY5FahY3zgr/8tur6Ezx8Jom4F7LqStkzmIIm2Ofoy6CTsOAw59JIJwm1VHEtWOlZHLu218ipCJe0EsBR1IfRvRlS6LjWvcbgXOlBlV7amzhvag8vVgwvAuDT+2fvyDOu6s4bdyKqicebAaxYLpLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90+fjc65WxBVpLfOZ8xUHlEfVvu3Ct5jvwB+vxGyDE4=;
 b=C37oaf0OdLnLnu45wumg/aErK5mWQoXbS5vcGH+cyUEwmgHueEqMuKEYNua19yn3L/hB7f753w3fqzBgNnimWvaJ/nNSb2rOUFOKIkH1DMd2w1DlWuXBL06U4OPbBTSQrpg8/20yBxS9vobTy+IXXQALyxRafmOOZNzLxYaDJRg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA1PR12MB7640.namprd12.prod.outlook.com (2603:10b6:208:424::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.20; Tue, 17 Dec
 2024 07:05:44 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8251.015; Tue, 17 Dec 2024
 07:05:44 +0000
Message-ID: <1c7734a4-e6f2-378b-cef2-af087a51526b@amd.com>
Date: Tue, 17 Dec 2024 01:05:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v15 09/13] tsc: Use the GUEST_TSC_FREQ MSR for discovering
 TSC frequency
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-10-nikunj@amd.com>
 <4dc0f6d9-764d-69de-6a4f-ae0f9a4ca7a8@amd.com>
 <04ce52ca-4123-42e5-924c-1c0c47a7f268@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <04ce52ca-4123-42e5-924c-1c0c47a7f268@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0123.namprd11.prod.outlook.com
 (2603:10b6:806:131::8) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA1PR12MB7640:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f71ac8b-3efb-4a49-8627-08dd1e69394d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c3BoWWhrcDBJV0FkKzU3TWgwTkFVODl3NEoxbVUzVUJoNE9vcUhMdGFqZGZs?=
 =?utf-8?B?dm5FVklrcmFEeGIzVzg2aXd0Q2d5bUdHSE1GOC9vUUtpTVRiVE4yYjY1U080?=
 =?utf-8?B?SjczbmEzdXZub2ZPSldaV0hiMnRJRVlRT2Z3dXBhV1lRK1JXQ0NUa2kyb3F3?=
 =?utf-8?B?a2N1WEU0RmtUaVpEaDZnYmw4cHl0TTF2R0lYWjBaaEduWW1qV3dlVXlHOGMw?=
 =?utf-8?B?MDRJck9NZVhzK1I2N3VuckNtSEo2Z3FIQWFLc3czNTB6RUwrazVGejg5QUhP?=
 =?utf-8?B?amk0My9LNjlOWVVzY0MycDRncThQVkV1WWVwb0lWYVpFWU52ZndneFFLZDZT?=
 =?utf-8?B?eWpuQzhhdFUwNEhyWU90cFFZMk1ENndqSmUwWU9jNC9QYVA4TmVQK09XdXJQ?=
 =?utf-8?B?d1NhUERlaWs2TjlBRzdPcnBsQTkzYlMxQmd6R3dTdDRnKzRTOUhzbjZVWjJs?=
 =?utf-8?B?ZTJaKzZYTCt6TXlhOTNFYWFIRkpjbmN3Nmc5a0lWS3grVldycE1ndW5WTXY4?=
 =?utf-8?B?Q0M2VlNXcFVlNXF1azY2TkJHVzU4LzBiTTM3VlM1OE5SMkZIRTdUSm9QT3RU?=
 =?utf-8?B?WGZ5S3ZlbXNrNmd1bmsrV2syY2VpMnRlNzdIc01CUEtFZng3RkhTbmpLL2Rm?=
 =?utf-8?B?U2tzaC9PbGlDdDNhbW9MNHhMWXpMU0VkWE1hWktCUXhKb21jTmhtYVVDb2pO?=
 =?utf-8?B?L016eFB5MUxKVlNsM2kzQUY4MEVXaVR4U2lxVGhZV1ZROTRNS3ZiWU10SWp5?=
 =?utf-8?B?clZmWHZUS3hDQjZxem9BWjBzKzFwd3RRQk9EUzN0aHlyV1VabUFKMjNteGJ1?=
 =?utf-8?B?TFh4L3BhQXdXVkJpMDJKYUExZkZRQ05teEZFRjE4K1JHbVR5VWFQa2F5UzNy?=
 =?utf-8?B?ZWpCQ1BOZFROVm9qdmRDUUxZMTJoWk1rL2ZuY0JCOC9Id1NrbW4yMFJtNVFk?=
 =?utf-8?B?RnJFSlFXZWhEV3d4TVBuM3d2S2MzQTROODFlMEpkYVZ1dmFOYkJCUmtBYWNM?=
 =?utf-8?B?VDRsem9iN1Q4OUl6WVViVkdvWHQyT0NtblhKbGFQWFRSVm8zaHpnbW81R3Ar?=
 =?utf-8?B?Qk1vR01ieFNZN0IxcFJLaTAwV2s2bEtVNWJGU1I4ejdtRzRLR1pkVGhlRlFP?=
 =?utf-8?B?ODgyZWlOMTRZa1habVF6ZmQ3YXVNVEs0d3hBVHNVUDJraXNVejZ0aFdFQ2Q4?=
 =?utf-8?B?alFDM2pxQnhiejBCaHN0Q3QwRm4xN2UvZEQ3L1JIaFdiZzRFVFVHV2tYSTVB?=
 =?utf-8?B?aWp4YlRoTkRoYlZxME5UdWpmVHhKdVJsTVI0eit3aUZkWWFPNVorZ1JLK3hy?=
 =?utf-8?B?aStUZEhFcHFUcTVGYS9FWTAzNmFSdmY3V0RjTmcvbG5lanFyOUpQWFZCcHRD?=
 =?utf-8?B?QlBjMnFIUkgvR3k2ZS92Nm9UVUpNVnczT2wwUGJPSU5HSEFFcDl2UEFiVG1V?=
 =?utf-8?B?aUM5bjJOenNGaFh4N0xwVDBuOFVpbUV0dE85VXozcWU0d1laZmdVYUx3Zm9V?=
 =?utf-8?B?d3dHWldhSnZoZTlEWk4xMElRZThaR3JrVld3cWNyaWo2bjA5VGdPd0pHdmc4?=
 =?utf-8?B?bmlRUXczSHBlNk5GWkkrMFBUMkVBa0Nqci9CTjc2WXBkdTdhYVFGMm00VGlC?=
 =?utf-8?B?NDkrV1lwYkVTV2IyRVF3Mkkvc1hyTEQwbjZEMis1WnVtKzlpRHl0aUVyVGlq?=
 =?utf-8?B?eWpEVlJzU050eTBHOW1sYktJczZZMUpadmw4eHNkdVZWRmFvUVlxV2cvQ2Z1?=
 =?utf-8?B?QXcxcFp0Sk03SUpFczhDZHQzc1EyRVN4NlU0dGR2NG1LWkZkdU1jOTVUN2ta?=
 =?utf-8?B?NXRGeEdYKzdKZHNoTU5zWjFpM2p3WmZFOHdsN0VaZGtvVzM3MCtIdkl4NWpZ?=
 =?utf-8?Q?XD2PPoHJd312f?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d013ajN2bWtMcHoreDcvSnduMFhzamUwMW9IZEdBRHZTcFdCUGxrcjVveXhJ?=
 =?utf-8?B?dkJJT1M4QS9tTHAyNkVrTVVpaWlJbXpFTldyWU9uMU9OdU5lVXNpNkpXSlNV?=
 =?utf-8?B?K0Q5eTlEZnFNSGhwZ3dsQ3FKRjZzNHZjaXllSHFQZE9PMDRWZmVqTTJMbm9k?=
 =?utf-8?B?U1loMWJoTFo0SVVWb3N4VnpoMU9ERUF1ZXBOYmJLRm1CM2lJay9tdk9hTVdn?=
 =?utf-8?B?dGgxWDRCdDdqNVYyNHQ3dURJTDJGeVl2NzhvM0NBa2k2MzRvZHd1L1paMjlv?=
 =?utf-8?B?V2h2dDVkRFJ0VSs2dFJXZHJIV0l4MUVhdnd0c1ZFM2tUbzk2S1N2QVpHL0tl?=
 =?utf-8?B?Lys4QlVXZWU2cUNjUEhvSUtmSHBDTmZuSW1XcUs2aHhaUWZaL1pRcTNiTUV3?=
 =?utf-8?B?TXl3VDBkMGlVWmtJZkZ0UnRtMVFTVndqaUtxQThVQndtUkFpSXJzdUozREZE?=
 =?utf-8?B?RHhFMjB0c0JFM2Njcmo1R0czZFpBd0hYdjFXUmlNMVpnbHVKeG8zc09hSWZy?=
 =?utf-8?B?Si9hZG14QUxlNzhQTjZLVG01eVhrVk1jYnY3dkV5Wmpld09IbTRHVGFXT0Ri?=
 =?utf-8?B?YWtPSno2WUNpc3RDUFJHTjhjQXBlNDlWS1lhWFZGU3V0NFV0VGo2VnJUbTRh?=
 =?utf-8?B?SHJLMEJPSW1TSHBxcHZqRjBManNaOWZuQ3pzWnhBaUN4YkVLYzY2MTlTRjli?=
 =?utf-8?B?WmZta0hpSmMyaFZ4RExqR0hYaVI2QVBJS3JiMUwyTkJxY2lJUHMzMXB3WTJJ?=
 =?utf-8?B?dzQ0S0kvQ3F3dWdiVVhzVFhKQUJlNUZFMWRhbWw2aXhjNFQ4WEN1b2R0MGd2?=
 =?utf-8?B?cmJWclZkb3VmUzlJQTFDNkdkSzIxVG9zcWpoWXp1MUJ1OEtZQkNFRVIxejdv?=
 =?utf-8?B?SjN5MnZzNTg3ZktGMTZ3QzVmbTRWNHZZdno2Qjd1d2lmWWVreXQ0czdkWnRZ?=
 =?utf-8?B?OGQrdE4zajRwNERJbThRR2pzRGh5QUw1aTU1UVhRZUxJRzVXUGFxMFpGZVN1?=
 =?utf-8?B?TFFSTzlobjJ2Nm9Sc29NWllEaVUvc0JqaVJjZUdOalZ4eDVWV00rai84aklv?=
 =?utf-8?B?Y253THQ5YmlDdjdCSVl5V1p2US9EampURTc2T1RWT3VScTBHMmwxbUc5WlpO?=
 =?utf-8?B?c04zc2l2WDRjV3dyT1hTOGdBVC9pQWlRK05XVFBKdHRNU212dXQvVFNTalFF?=
 =?utf-8?B?dWhOMFRYSlJUSEFjRzhPVmhoMlNHZ0h0SktlYlFHNTdlVnRRV2pDRmUxMlRJ?=
 =?utf-8?B?WExBazFhZWROUVBTdHI3S1FUWVRvaXU4RVU3dWxTZGU2cHN1RklMRXJKMEdj?=
 =?utf-8?B?ZGo1RUZEYlcrQUxzcUtDRG5hbnhnR0E2MzJWVnkrYjBKTFhQTEExaGV2cm9a?=
 =?utf-8?B?T29aTkJqTTV4bWV5cVV3RHI4dU1VaFBMb2RJSVhveWVSaEJNenByV1JDSGFs?=
 =?utf-8?B?WVhMRSs3bjNqRkJhOG50aVBxNy9OS1hsVjhTNG1WZ0x1b2JpT0RDRE54cVVh?=
 =?utf-8?B?V2hZTE1ScWRNNkI4Z0FMSy9JMVJ3a0VXK0I5SGx3MXFHTm4zRGpuSXNxVjVT?=
 =?utf-8?B?c2ZNYzhxS0s4NHVxY3lSNThJdVRvdEErQVl3ams4Mm8yejFKZHpVN3g0UmhU?=
 =?utf-8?B?aEd6SDhSRUVuSjFHSnMzWFVsczNuK2VkS3BBeWluUVVrT0JJV0dwMFJqOXhK?=
 =?utf-8?B?Z1BqVDY4T05qTVhlTEYxS1lYL2ZEWDlVN2xHMGlMOGpHeGo5R1dldlVDRUEv?=
 =?utf-8?B?TmpBV0h6UDVCb3ZRUGFOVUpOMmdQSFFoQ0lzbVFQR21PTVFWUDNCNjY1WFZa?=
 =?utf-8?B?dEFqK2d5eGI0WFB6SDRZUWpWVWRXUjBRaS9CeDRPMjB4YllGa2FDUm1rNmw4?=
 =?utf-8?B?YWtML3ZiSzRsZlpNcW1HVU1uK3JnTTJBN3d2OHNqMFoxemhONFhvVnhMNkZL?=
 =?utf-8?B?b0tNOWdBOEhyQ05TSk9FcjQxeGhWUnBxQmhxaGZVTStGNUtlaWQ5RzJPeERO?=
 =?utf-8?B?aUJodkNNNktuWGx3elBmakNlUEhMbXlKR3lhTXZmWVhqcFpwVTNuZ1oyVXZt?=
 =?utf-8?B?a1h0SGEwUmZzNGYxMFE4bmppc2dKWkJuOFZDalFGU0JuaVN6QW41cER0ejVS?=
 =?utf-8?Q?cBWtAZ4tgCx0h7VGBYG8aQmSS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f71ac8b-3efb-4a49-8627-08dd1e69394d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2024 07:05:44.0098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O0auV+HIjsU/ENonuV4rZQ5Uexk/Jx+U2Il+e8TWlf2lB0j8LJ1UTYZzzZhYMFq5lfixbOXZ8pwazaFwXQIIuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7640

On 12/17/24 00:27, Nikunj A Dadhania wrote:
> On 12/16/2024 10:01 PM, Tom Lendacky wrote:
>> On 12/3/24 03:00, Nikunj A Dadhania wrote:
>>> Calibrating the TSC frequency using the kvmclock is not correct for
>>> SecureTSC enabled guests. Use the platform provided TSC frequency via the
>>> GUEST_TSC_FREQ MSR (C001_0134h).
>>>
>>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>> ---
>>>  arch/x86/include/asm/sev.h |  2 ++
>>>  arch/x86/coco/sev/core.c   | 16 ++++++++++++++++
>>>  arch/x86/kernel/tsc.c      |  5 +++++
>>>  3 files changed, 23 insertions(+)
>>>

> @@ -3282,16 +3283,18 @@ void __init snp_secure_tsc_prepare(void)
>  
>  static unsigned long securetsc_get_tsc_khz(void)
>  {
> -	unsigned long long tsc_freq_mhz;
> -
>  	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);

I was thinking even this can be moved.

Thanks,
Tom

> -	rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
>  
> -	return (unsigned long)(tsc_freq_mhz * 1000);
> +	return snp_tsc_freq_khz;
>  }
>  
>  void __init snp_secure_tsc_init(void)
>  {
> +	unsigned long long tsc_freq_mhz;
> +
> +	rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
> +	snp_tsc_freq_khz = (unsigned long)(tsc_freq_mhz * 1000);
> +
>  	x86_platform.calibrate_cpu = securetsc_get_tsc_khz;
>  	x86_platform.calibrate_tsc = securetsc_get_tsc_khz;
>  }
> 
> 
> ---
> 
> Regards
> Nikunj

