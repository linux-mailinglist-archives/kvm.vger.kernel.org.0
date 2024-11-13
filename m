Return-Path: <kvm+bounces-31764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B4BF9C74D4
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 15:53:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1DF8B3AB16
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 14:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 932B97E575;
	Wed, 13 Nov 2024 14:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p8S+zRJf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4241B70805;
	Wed, 13 Nov 2024 14:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731508456; cv=fail; b=aQVPJa7DaESmbonQloQLxsAy3f1XtqZ04vPHoII7rC+h50R9Nw2WQZ2fkLopbF/6dIX5O95RD2uLHBBdWAf8QuJsvTaPUf7gDrqLpoCnaPjS7cpaj1nYaEf99FmyHD+dlarXLqLRHAUwko6LELEBKY8hWIBLShFwMoLhEwoPkGg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731508456; c=relaxed/simple;
	bh=aAnCI+VlPN2GHKZ+x7fXFiJ3JOKpHY9lEJMzoOrSVsg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nyrOoPz0fP/G0u2an6B4nlcHMMVI7+0Z80dVtLGaJTMQIYMVHumOeLrze3Ev8tIe8widS+p8FuOGn4+7FsQFqvJ+IHLszjvuShnxuocchDtT85oGLk/GZW33Aouyo1XVAFmkm6+PNyCFX7y2VJaTU8gmd49BSDnnXHo9imfmIIE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p8S+zRJf; arc=fail smtp.client-ip=40.107.243.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l3TqGQFX9XZxe9x07H+Wb6dfC7DuUNEJW/X2TsFBKbRXH0GUrtHNM9fJ0dRhCYgYKvT2niodeeTdGT9HJbqaVG6iX6d/SN7mxUogX52Sxuta19yHThKtjqKSq8S3UoeME0unn+lD9eeRL5FgncxXVY+o3Hgg9UK8tLo4U/1be7cj5ywRt+yO3TcgV67qEBsWwTOQxcZHflDomNmXGPUSUGNQfIjlqr23tpCRHbshFFmXTo2mOdf07d5yCSzHi9onmWeyOYqgp4LVhyLSUTV6U8nCtyfbsw8l/vAW4KzDfYcyYpFA6ij1+ZCoEfFH4aG8VnUiFehugBxmCKd3/S8sDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GsinAHFUM3CmmXE8qQYBchXD3XkKmzkYdOmpF/NPjrU=;
 b=noq26le7/jke12JnXwM2zmoVPdmags6MXZEA0Tco+DSIqKAhVfhi5+ip3StYBdcS219ZyhJVr8xznUnvs5Vvm45SVdX04fJt0VYtP3vdU3dbsTuANVZzEFPYh/eMNWSC6Eu/vYo1mnAXoQ/ckd1qW4zh+nCgCbLhOazMs3jcUjiYBoeUDiL8joaNCb5nhPhWmH/9YKkuVh1Q3mOlkbho9PG6uiOSTLMXNnyu0+u4aA/fJbiD/VUNzPdD5WFje2OeQ53YzLkolKzVlsglfxcvWFDXUn3ThfS2KPgqmNoSSX+yGXy3opKjrxAWpekOelBuxon6SikKtAIhaZGoEKEuxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GsinAHFUM3CmmXE8qQYBchXD3XkKmzkYdOmpF/NPjrU=;
 b=p8S+zRJf1+54JEjSj5N5yxKk8+uebbVRLF9yZcRRr9vtO3OlkfnT8ZL290vYhzjlNpfUAiOqItp5FF390w9S2gRXYKdMQUStL9VCOJqcfH5zAeVUOXcoKT92Zou8/2iyH6AN6xLzSDfIPXAhourfixk0t2vz91SG1Qa5PFMib/h+NJwJK5L2xfVCqmY6uUXETx1bUUu+nSVaSD5RB0OmYQUS4cuNDORyrs7wYK6AOpy+DXlaFonL2DxbDB9F76eof1LqBongwrorDmc25iIl0qRio4n26gZRQpzRKLRsPTS/8VaeHhj4hTP/xD77pkdmuDVFekzYlb1JgpnRS8BR5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB9031.namprd12.prod.outlook.com (2603:10b6:208:3f9::19)
 by LV3PR12MB9187.namprd12.prod.outlook.com (2603:10b6:408:194::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Wed, 13 Nov
 2024 14:34:11 +0000
Received: from IA1PR12MB9031.namprd12.prod.outlook.com
 ([fe80::1fb7:5076:77b5:559c]) by IA1PR12MB9031.namprd12.prod.outlook.com
 ([fe80::1fb7:5076:77b5:559c%6]) with mapi id 15.20.8158.017; Wed, 13 Nov 2024
 14:34:11 +0000
Message-ID: <195f8d81-36d8-4730-9911-5797f41c58ad@nvidia.com>
Date: Wed, 13 Nov 2024 15:33:35 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vhost 2/2] vdpa/mlx5: Fix suboptimal range on iotlb
 iteration
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux.dev, Si-Wei Liu <si-wei.liu@oracle.com>,
 Jason Wang <jasowang@redhat.com>, Eugenio Perez Martin
 <eperezma@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Gal Pressman <gal@nvidia.com>, Parav Pandit <parav@nvidia.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20241021134040.975221-1-dtatulea@nvidia.com>
 <20241021134040.975221-3-dtatulea@nvidia.com>
 <20241113013149-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20241113013149-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0341.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ea::16) To DS0PR12MB9038.namprd12.prod.outlook.com
 (2603:10b6:8:f2::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB9031:EE_|LV3PR12MB9187:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ef6f81c-a584-4133-2f47-08dd03f02a9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cDFwQTU3bmxNSDQ0NFlQRVg3ckQ1TmNsN01GcEZWbWpYekFpbXpNN05ONVQ4?=
 =?utf-8?B?Vm9nZmRSMHFLZ01pbWo4R2wvLzB4dlJvYmtXYVlpYlluZDBTQjEyRXJMaEg0?=
 =?utf-8?B?VTdoN2M5SzV4R281WWhXRmI2dTZjMUlpTjR5ZTB6Ymt0dVZBWWpEZ2lIaHRu?=
 =?utf-8?B?UTd6bG53ZHNjUHlMMVgyN1BUQWJVNTQrNmRlK3BPb1IwRDdzV1F1c2VZT21L?=
 =?utf-8?B?d1BQUVBzZTVFRjcxNHJXL3c2TEFpdWR1OUx2eDg0YXk1Q2VWUHNhaW9tdncv?=
 =?utf-8?B?RHZ5UmduOGpyWmlsT0ZzUE5jZkZkYUJzcVdPOCtQQjgwSm8wb0F3OGhCcGdQ?=
 =?utf-8?B?Wm1mNUlGaGpNWjhsVTR5WGs5YUovdGtRMEdrVnJxMFQ3Qzd6SU1oWDhlUzZS?=
 =?utf-8?B?MHlBYndsYjBkaXRtdnlHTVUwVVJiYzVKSi93ckpBN252SDJmd29mSCtrRzJw?=
 =?utf-8?B?R1dNYmNhM3JYZzRMbUZaUGZYOGdhWE14YS9FbndFSVNtZUFjWE1NRVIzbVNl?=
 =?utf-8?B?V0JkQ053MUhXRmpuNlc1THZOd3VZOUV5eERBS3MrUjdHcEwwaldVZm5BWVdO?=
 =?utf-8?B?RklldHNwZWFySlB3OXlBSUN0SE9NYzc1bHBMVXFROUpNcUQ0MWxmMWc4YWZY?=
 =?utf-8?B?bmdhaktOYUdQcHErYmgvdmR5WDQ1VlF0cHZtSHZIbWdiMWdYSXJnclN0RjAy?=
 =?utf-8?B?a3JvOGNuTUNVNmJOZVAyYzFEUlI4U2JVWXpjaFljdjliV0xsMXo2b3pzQSti?=
 =?utf-8?B?a1VOTi9VeUdKa3BkSnVCUHMrZUkyK2VtK0p4RXI2bS9WK1lZS1d2cHVySWJ0?=
 =?utf-8?B?WGM3eWt6MzNNaXhhY3hCeGJMblNqWUoyL25zMXE2Z29HS29OaHFxS0pYazdJ?=
 =?utf-8?B?Yy80blhUY0RvTndRak1TR3Z6OG1LOFZRRzZSYmJJTWRSVzd3TndiMzIyeW4z?=
 =?utf-8?B?VXp1c1dHckFDNnBhOURCUEFaZzRtVkNIbzM5VEZLY01ENE1sOHBDNkJha0lv?=
 =?utf-8?B?MHZRZmJ5N3FKRUpBeU94VXhtSUJDRzB3WVJscGo4ei8vemJPMHliSytCQjNq?=
 =?utf-8?B?cGsyWFNHTTZaQlFnR2NyaE0wdGZnbkZTbldFR1R5ZXcwUTBrMmkzL2pXbzdq?=
 =?utf-8?B?N3NnYjZZdnlmbVc0RGhvdDEvd3RDV3M5c01TM25ScEhUcmxOd0ROZ1krUXQx?=
 =?utf-8?B?YjIxVURSRjRUZUppcFZObzNQN3h0UU5iTlF4Y3ovaE5rYXo5Y0FEOS9xMmVG?=
 =?utf-8?B?WGZjbmJFWngwV2xNZFY4RTNCR240dFBsNHF4clB1WEkvOFJ4VHhnZHJkb3Y0?=
 =?utf-8?B?aW5WeDNxclVsQTlTcENEWjJicDlqcWNCT25ML0xrSzltM3hyWFBYTWs5UXNk?=
 =?utf-8?B?SmVsbVhBNklXREtaQXVDK0V4VUd1WDAxeEVHQmlLZ2ZrQlhCc2hXU2VlNnpD?=
 =?utf-8?B?NFFWSkxKaURQNzRKWXpONkpTUGVjYlZBbHdnWHkvWXp1VEhPVFM5YWhjdWRv?=
 =?utf-8?B?YlVjL3hxdFV1R2dHekdWVnNVb2ZqQ2lUMVVyVkp2eEFxNXBTdzV6dG5Pc3Ba?=
 =?utf-8?B?aDVPUngvYkxlNE9HNG1jVjZvb0p5OHRxblU2eExxNGs1ZnEvWHdOM2R5OEZy?=
 =?utf-8?B?bFZGc0VrN3h5YzhvUW5lL3ovN2gwcjE1SklnRGJWeFk4cURMNDdnblVuM0Fv?=
 =?utf-8?B?WFpaaVRiUXhqTXB4WnpScEVzcTlMS1VNdjNBOCtoU0JXK2Jyb3MrZHp1alk3?=
 =?utf-8?Q?lIpd3zQGZMQ+YznbGQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB9031.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWJaQm5hYy9xa0lEMVFzTWZEYjdJR3N6dGU2T3YxMU9yTzZoQ24xZkRtb1VM?=
 =?utf-8?B?RmFXTU50c2hmYkplWldnRnR4b3pKMXJoRzFLL1AzcEJTT01nWmFJdkpNVy9h?=
 =?utf-8?B?QzJLcVRVbGx0RzZZaEJqNG55UEV0dVl2c2lReEtETkdsVkRpb0JWRUMrc1pq?=
 =?utf-8?B?d0RYazVBNHBmQlVMVlhDUnVEYTdWK3FWZ3p6eTdhQkFVWGh6R1JDZmhvMzNQ?=
 =?utf-8?B?MFY0U0tVeEs0aUF0L0xOSVFiYXN5am5uZlNKNHpMNUtidmswWmlxd1hiSmZy?=
 =?utf-8?B?d2l3M0Y4SnZFMjdSTzdzaXd4ZGdZZ2EydU9QUFE3bDRJSjF6YlpvSTRjanRi?=
 =?utf-8?B?Y0FkT3FwNUl3bHJPSk95Y3hTR3BNWTJod0VzV0ZOTmVEYWdlYk5Ja3ovbjYz?=
 =?utf-8?B?aVpwcGF4eFhrRWUrQUpocHJtLzNMeXY3L1FKUGdTQVBpanRNWTdVS2REdTZV?=
 =?utf-8?B?bjRKa1RZNWxleFBPd2N5NEthaEdpV2thUlFwdmorQVEvYk9UTFZQdzc2Z3Vj?=
 =?utf-8?B?Z0wvZUhXVmY3dWFYZUxYcEtsRCswZCtHTDRHTDhlVVE1UFN6Uk5ESDIwajAv?=
 =?utf-8?B?bmJuOHAvYmRSY1dTUVloT3p0ZjJTaXcrTDlwaWFyMmcwc3M5VEhQcmQrMEMy?=
 =?utf-8?B?TGFNS2JPelJkdzYvbmF1RlI3bytKVlk0NnVSKytYQUZyY21YK2dmY1A3RWNY?=
 =?utf-8?B?Qy82Z1QxSjlSc2lJVnNDMG1BdXZaZXBzSWFkOHBNWGNmb0liRnRTTm83WHhP?=
 =?utf-8?B?MGJaM1NaMlF2QTNyY3dYRmxGeGx2aFo3dHhZZ0haYlNDVHJWU0xDUEw0RWk2?=
 =?utf-8?B?ZCsvY3FWTWxxZmdVYXNkbkFFazdYSW5yaFpKOUdGYng4QjVtUlY5V2xwYUlh?=
 =?utf-8?B?bE5WT1hYKy8zSnVoRDB5bXE2Mk5CNkxIa3hiMDhyRVhRRiszVDZWb0tSZkgy?=
 =?utf-8?B?dlRsVjRaK2JBUlFraVBGN3FRSjNZNFNrUURKM2hoS3lpZGFweGtUMXVsN1h5?=
 =?utf-8?B?Nkg2bmNnb2tlVS9HODFWZ3pOS3BGc2pDZTR1N1l5T21rcnF2WG5LTzV6alNU?=
 =?utf-8?B?REpPZGw5SGI0UG0wSldLaHBBNGEwM2ZENkJCMGhXeXpENEcxZDJZSmJOemtN?=
 =?utf-8?B?QW5ycll6dTVPRFZCUSt6RmlpZllTeElzaUJaaUZRY0gvNUhLdHozNFg5UlZl?=
 =?utf-8?B?WlhiOXJySklvZGF5aHdJdXpzbDNyWXMwYnJ2aXQxZ0VYWlVTMEkrTGp5d0Er?=
 =?utf-8?B?WlROQTZoZDhEZFFxTDdFNnVQcC9pZTVJcjlvSVJUMmNXZitxcVBtcENETTk3?=
 =?utf-8?B?anVDSkpKTjF6bXVEU3BaVWRVUjNDZVRTdzgzWHJFK2RQZk9ua1lUUzBrd3pC?=
 =?utf-8?B?SHM5YUJTbTZzNkxlOUZHWkxuT3IzQmdMamNEYUcxdEJiNWtMSjJXRW9wNjdI?=
 =?utf-8?B?UE9vem9ZQWpXUGl1NkJqSzRMckdzVFdMMlZ2ZFZaTXgyMWltMHpwa0laNk5R?=
 =?utf-8?B?OS9uT3Nndjk4NHJtZkVuU3hoYUhiQitpckFnbjNiWENRSDNtVWpVL1VWUnF5?=
 =?utf-8?B?dXdEMnoralJGUDZkQ3N6WGVGRElXejNoVlZDay9wYVFtRW85TG1lWDFDc3lU?=
 =?utf-8?B?YjBZVkRtYUdkOUw4U3Blb1R2TDRKdTRydVU1Rk9WOEF5RDNpckJQTmVLOWdD?=
 =?utf-8?B?T1NPTzA3OTg4ZnpqS0l5OFJrMUZIczhOTHB5RUVzZTlFV0RGQjdpam1Jck9Z?=
 =?utf-8?B?a3VvTTVzN1hvVXVBMWpwRld3c2xFanZiWS9lQnVBUEZhQyt6RzNYTlFicEZE?=
 =?utf-8?B?MzE1UjlCM3U3YTFKU1NEdmJyTWFETmZKMVE0RnVwT2c2N3A4SGd4U0NtY0JT?=
 =?utf-8?B?dUN4MkhpVDhaUm92OGtlUFNoU1ZiNE52RW1OYklpYlBsV1RSZ1AxdEFpOFox?=
 =?utf-8?B?ODh6L0pMa3RJVGFrRmx2S2tIZDB0SHZmU2dyL1BuWjNBaS8wbk9oVDRPdUZ4?=
 =?utf-8?B?VTdFY1Q1Ky9mbUcvbGc0VHJSKzJwdThSMFRIMzVGaXpTeU4vc2pqSHMrN1lV?=
 =?utf-8?B?aWM5R2hLWHVocTJCZVJ5YU55djZ5d0RiMHhJblRCQ1hDSkRXaE9GQys0TWds?=
 =?utf-8?Q?N4m3wNai5lx/dUEgJSahuaRxm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ef6f81c-a584-4133-2f47-08dd03f02a9d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB9038.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 14:33:41.1765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tkT5PrLmjh7DBBWg86Raf8etR8JOuqZcT8unM24gRorLbmEmdjIsa2VU9+4jPyn92JJ7mDLZrb5SRA2ogA3kBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9187



On 13.11.24 07:32, Michael S. Tsirkin wrote:
> On Mon, Oct 21, 2024 at 04:40:40PM +0300, Dragos Tatulea wrote:
>> From: Si-Wei Liu <si-wei.liu@oracle.com>
>>
>> The starting iova address to iterate iotlb map entry within a range
>> was set to an irrelevant value when passing to the itree_next()
>> iterator, although luckily it doesn't affect the outcome of finding
>> out the granule of the smallest iotlb map size. Fix the code to make
>> it consistent with the following for-loop.
>>
>> Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
> 
> 
> But the cover letter says "that's why it does not have a fixes tag".
> Confused.
Sorry about that. Patch is fine with fixes tag, I forgot to drop that
part of the sentence from the cover letter.

Let me know if I need to resend something.

Thanks,
Dragos

