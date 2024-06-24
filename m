Return-Path: <kvm+bounces-20411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97B8A91555C
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 19:29:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA1171C223EB
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 17:29:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B346C19E81B;
	Mon, 24 Jun 2024 17:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="N/6pjXhq"
X-Original-To: kvm@vger.kernel.org
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2129.outbound.protection.outlook.com [40.107.21.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C416A7604D
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 17:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719250165; cv=fail; b=oC5B0OTytljyHvP+YCiTJCdtsVGZLaP1sUV6F/XFvsGUDmn19StEinnjPBlqNIE/mrGvJYMg82P1mBHjWN6GGkyISjEH1BiScWfqO0ECAT7+pLSyoa0BzTjzT34O8JiSw0O2VFFnw4cCedHn84lrsvtcfRz2cpFOe95cZeEMt+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719250165; c=relaxed/simple;
	bh=ZN0iSezAYgLSjBI6gDK0Ei6L7txDcO0ziv7c/IMu0lk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tLv3f4q/2jemCjr4rUidCDeMlGlZ7kF7p/TsCG19vq3/V++g6+IEOElq/w9ypZCgHN0Kzf2rK08Dpc3LXMnI6YYGyf58qdQEZG6f1PnVjBBFJAJInVkhQipJaLBmAjHWjecIb4eSlfPxt7zd7p02ryPyCbSDM0INcIbnl2lQ6z0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=N/6pjXhq; arc=fail smtp.client-ip=40.107.21.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j0mW9Vc1FalzBTUXJd43iaswZFF8wHHAEG9LqZ8SmM83+rKjhKh6XkgKlyMiaGuN+eg3hgt6OPh33HMlzl1MMJg1t4/bAhbHSSKFbxJiOJwDhHq9oEgT8PxBLtSAoNl22uPGzcqVlbeOCITT78nfIlBx79aHIMC8ZIjvHbEV9r1qQ4FoszGIMeVNHJFNrfeCg1ooIZ/9F55ZktRA+HhsqRJ5ZSyXJBMisgL9myOP/rFiS3RS0Ze9odEB1E9JKVQ0Ov/+Iz7jPPOQQfHxgXikxQfygj34AbJQK0XHWV8olwbzXZfy3/Tlyal3GM6gGMvFG8p7Cf2M93RsHKsNTNqZ7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KBwE4OY9zf9fMXlYcnwxsvDwDVDiTLMWEpDeH+eBhsI=;
 b=gMvuZSi2iR6RnWpQLU9zEhzb1eglUXEAQJ4f/QpSEHRnEIBCiOtH+145ZQgoT894jyovuHbyYIrKIJxw1HS2jQ0vm3tjGPeRI/XaY+l04ZXePQpxHbTPT8N37cRK+U8tmd6Ak33Gv2pmqh+Q3dNHYBhRqAhcGsJ4H4DhhQ8s4V0IbqmfHF32D3QE49ATxIiZdVSCWY0mmuG5gPS2gt35oGKbfDPY7F+sNfdFhTxSdCbGi9v5GMVHdMe/im3QUYewBIwpEFBjMELfN0Yj7GNiRLDhA8aiN+ppH2/uxQryoQhnOn5gCJg0cfPPchq0oRtQfZXzeYkZu6pGaI9+vK1Ksw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KBwE4OY9zf9fMXlYcnwxsvDwDVDiTLMWEpDeH+eBhsI=;
 b=N/6pjXhq8biBz6vKkoD+LqSDP1A4cofGxT07UuaHOzmAwpvHlgQbaNAP2I3R1qJT+ZdYeInAn2Q4a7L9HVTgDQBJSbBXB32oJiH/xzP+b6sKRprRVPSe2knqTgEg8maVFNyk4VKw09eMarw8YhEawYwMzCU07lRRA/6QAmTB+2Q/Bc0emT/OYGxMj5MhGRXe5vKQvSJJjjG8RCAKhw428H3kIESRCPyw5cp1rHZJRf2xSrpWgUHhFB9QSYS6hqUT0udISNvRPw5GRqeUFw4Oe3xkfs6ILfeUpIP2yy5rTiW+t8/Vm1yVmdKm01Ipkhm01WYHlo1ovBCRkSnf4YXd2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from DBAPR08MB5830.eurprd08.prod.outlook.com (2603:10a6:10:1a7::12)
 by DBBPR08MB6233.eurprd08.prod.outlook.com (2603:10a6:10:204::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.29; Mon, 24 Jun
 2024 17:29:19 +0000
Received: from DBAPR08MB5830.eurprd08.prod.outlook.com
 ([fe80::574e:cc8a:6519:efdf]) by DBAPR08MB5830.eurprd08.prod.outlook.com
 ([fe80::574e:cc8a:6519:efdf%3]) with mapi id 15.20.7698.025; Mon, 24 Jun 2024
 17:29:19 +0000
Message-ID: <9826b228-1dfc-4fe1-8eeb-796d74182344@virtuozzo.com>
Date: Mon, 24 Jun 2024 19:29:16 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Fix Issue: When VirtIO Backend providing VIRTIO_BLK_F_MQ
 feature, The file system of the front-end OS fails to be mounted.
To: Lynch wu <lynch.wy@gmail.com>
Cc: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>, jasowang@redhat.com,
 kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
 vzdevel <devel@openvz.org>,
 Alexander Atanasov <alexander.atanasov@virtuozzo.com>
References: <5bc57d8a-88c3-2e8a-65d4-670e69d258af@virtuozzo.com>
 <20240517053451.25693-1-Lynch.wy@gmail.com>
 <af6817c2-ddee-4e69-9e55-37b0133c1d3b@virtuozzo.com>
 <3fcc1210-a4c9-4391-9583-a2263dbe6e72@virtuozzo.com>
 <CAHKanihHAjMF+OdozhRoq0ZMODRFZhT=Ze6b8q4S02Yp_cOwNg@mail.gmail.com>
Content-Language: en-US
From: Konstantin Khorenko <khorenko@virtuozzo.com>
In-Reply-To: <CAHKanihHAjMF+OdozhRoq0ZMODRFZhT=Ze6b8q4S02Yp_cOwNg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR03CA0015.eurprd03.prod.outlook.com
 (2603:10a6:208:14::28) To DBAPR08MB5830.eurprd08.prod.outlook.com
 (2603:10a6:10:1a7::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBAPR08MB5830:EE_|DBBPR08MB6233:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e6dd148-9780-452a-2aa6-08dc94732dde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|366013|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V1BGMDI5b3ZHUW9tdTR4STkyajlzY3VEdFNSVEFlTWszZVBHbmsrTmVDL3JB?=
 =?utf-8?B?TjQrUHVmbXdkek1wbzFuMVJZNWVUdXdVOFo2MHlkU1JPc0w5UHVKTzkzdTla?=
 =?utf-8?B?ZEN0TnRidU5QUkViTEh3a3pyNnYvWUVQOEQvcG1pR0g1OWRmK2tTeHl1VWo2?=
 =?utf-8?B?Z1AwV1FMMEMrWlJVTmRNa0d0bitGcnNBVzRwUlpNOTZ5dEhlWEkrLzUxYW9p?=
 =?utf-8?B?U0JMUTJ4YWx4dVBtWGlQa0w5dS8ra293L2RMb3p2bzlzSWNUaWZydE1FT1Bp?=
 =?utf-8?B?dlFIR2NIUFlvT3ZwV1kxdUo0ODY2Z1A3b29ZQnJTVGMrTkZLNHVRTVZVT1Qr?=
 =?utf-8?B?TGV1U1JlcmQydjRSWEpSWjduVEUrVEV0bjhXZWF4eE9OWUpJdUxXY29HUlVG?=
 =?utf-8?B?WFVvT2VjWnloaEZUdThieDNMTk9tbnNrK3FyeXlUS08wUUdwQlYyV2dUUERT?=
 =?utf-8?B?dmZpR1RZc2paM3ZaME1vb0kzaytDelc3M3hNRFVTRWZJYTlveHVMNlFCbzk0?=
 =?utf-8?B?OGJnc1hiSVZLbWlRb2FSMjlxb2NYd1VNTlNIamRuUXBSNmlKNi93TzlMSGVu?=
 =?utf-8?B?aDhLS2JmSzM0OS90ZmR2aDdPS3hOU0M4RkJ5cDYzUkw4V090QVZMMjhWdU14?=
 =?utf-8?B?K0VpNFROM1pjKzNCM0U1eDJSN2w2NVRsRk1vM3k2QWEzWkRQb0x0eUJyNEtM?=
 =?utf-8?B?U293Rm9VSCtUcmhsc2hRYXMwazZobUUzNm92b1ZKS0dBdFlRT25JSkwzekdM?=
 =?utf-8?B?R1MrZWJiQUYzVThHN1RYN2pnTnhBUTU0MFhwUzA4NnNVVjVpekxuN21TakdD?=
 =?utf-8?B?UFczUituOXN1UUJNZlk5eDc4OTY0ZDVTd2VIOXFkaWh4R3VMTi9WL28wYkVi?=
 =?utf-8?B?emM2UDVWK3RhbXRKcjN6NFYyNGFVWlBjajNRYUlWVFNjcXRsWWJudVdpOXls?=
 =?utf-8?B?VnZqdS9xbXpvekJGM1ViTEFDM3RQYmcybWpNVlhkTmFRTmRIcThSejU5SFFa?=
 =?utf-8?B?UjF0a2U2TnU3aHY4OFJwRFdDT2FJdzVlNDM1YitxWi9xSWR6TlRpKzhtK2Ra?=
 =?utf-8?B?R3U0VnNGRDZBK3ViTlRnRzNxNk9EcExrV3FraGRQY0JlNk56bnRwQmwwbWFD?=
 =?utf-8?B?UFBzeDg4OGNLcnArVGc3NmZ6ZEJqYUFHL3BtMitCUk1ZaWM2ZjRxWTd3a0Iw?=
 =?utf-8?B?bWJPK2MyUHpOV28vb3QrYWJ4YmNtN1VPQk53N2FPMlZlZWV5aDdkdTkycVJC?=
 =?utf-8?B?SXhwZ2VCd0swS29BTDNTenRJaGpQelVHN0xud04yUFVQY2VuOVY0ZDBnNC9a?=
 =?utf-8?B?N2Z5ZmswSXZSQjJNOEtEdWNyNmxTTTdtV3Rsd2w2ZUQ5RTdHSUhHMDRaSnNn?=
 =?utf-8?B?NWFuR2tTNTFia3JXV0xIZVkwZXlxMXQ3RmlmNkR6SGVreUNuL1dPdEkxNkUy?=
 =?utf-8?B?aVptMXAxN1Y1d0dXQnlMMFdPUWNpLzVBWUg1QWc5cUVxL3hOSUNPQ2tGajR5?=
 =?utf-8?B?Wkw3WnUyL0p3SUtURm5oV2EvTDdpbm5CWFVCM00xME5iN1JBeHN6MFRWTEdG?=
 =?utf-8?B?czVqYVRycThCVDJBODJCUFJzRHd3THZ0eEJzQmUyQWZ1b0g0YStYd2V0cm02?=
 =?utf-8?B?Rmc4aWlMT1kxOTlaWjVmT3V5LzlVK2ZzSk9KRTYrY0FqZU82aHVIVjBYeFhw?=
 =?utf-8?B?d2hicXk2UGJvdWQ0Uk5PY2pQcy8xV2thRjc0Q3NaYnRPQzhwQy9NbHY2aUxZ?=
 =?utf-8?Q?KGammPAoeLId55qgmypeXYxCVU+WKRiAWeyTSCj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5830.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(366013)(1800799021);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dzQ3WndxRmlvM1RVbXJTUFBvSHFXZk13UWdtM2VlRVRRcUF6aVJVZkdzK2hu?=
 =?utf-8?B?OFljU0NHTTZTcmpCaEdpOUh1aDBMR2JIVlprNnFoc21OTHR6T3lTMXBhZ3Nw?=
 =?utf-8?B?V2JFd3NmMTlCZC90VklqNU9IU0hqRDFOWEh2VmxTRytYbnFSNGxneUhwdXJS?=
 =?utf-8?B?eWtXRWIwVGRVSmlOVDZMSXJMd3Zrc0JVamwwa2h1bjNramwvSDFlZk1zT256?=
 =?utf-8?B?OEIrT05sVHNJSUl4MkgwTXZnSHU1b29oaVQ1Tlc4Y0Y3YTFTYWVZUkFyMU56?=
 =?utf-8?B?azJnVEdtQnBoV0c5aUE1RkY1bzZzeHlGMkE0TnhIQTIwTFF3Vm5PV1VpWGgx?=
 =?utf-8?B?N0RUSUdJaG45ZkF1S2tGZDNOWXVEdFVtaXQ3RWVCUHJtNjJKUlUxQU9EQnhr?=
 =?utf-8?B?d1cxSUd3TGg2MUMrclVpUXc1QXhGTlE3cGd3a0hadWM2QlFnbXRNdUdwc3dB?=
 =?utf-8?B?ZmtySjJvMWJId05QQmw3WWthMGZJaFN1TEx0Q0VQZUgwLzVKY2ZjT3hhUkxM?=
 =?utf-8?B?OHIreHRMeUc2ZGVOOTRYVXdheDJEWjZ4YmN6QzZRT0xzaHpyRTI0b3FiRExY?=
 =?utf-8?B?aVdQQUFSVU5KQ3BESkVhdFZPdkNNSmtoZHl1TTRXdnJUV0sxWGtPZ2lVTGUy?=
 =?utf-8?B?OWZrQ1lGc0R0b01iQXlyK3MxcWd3cFJEU3RZdzMxZnNyRHdzMDd6M1Fkb2pT?=
 =?utf-8?B?R2ZRM1QxOXBFMWRXcEdlc1RZMlFBSysrTlIzV1BMZVRGWXdLNVg4VVQ2ZU1N?=
 =?utf-8?B?cU94RUZpcVF5bEw0VDhmWE9TMjFxOXN1TWNpL1l1b3p1VThqSTRzdG45SSs0?=
 =?utf-8?B?cW5MRy9Rb2dXWWlGVGZ5Z3Y4WllCTDIrcU5DOEVRSk1HK0ZXVkQvVklFbHlR?=
 =?utf-8?B?T2MrMi8veVFNWFk0RWNjTS90Qk00YUNBbmVZV25kQTRtU296d3FERElibEdM?=
 =?utf-8?B?SzZzTzA0amZTT3kwSzU2SmNjVytZUmNML3FpZ1BsN01obmFXekJBQU96dWYr?=
 =?utf-8?B?a3RDbHJaY1VoM0w2ZDFCWjNkSDZ2WDRaL1hDUXJ1VDF5RlJ5R2pNTzNHSDV3?=
 =?utf-8?B?UXdPT0oybDM5eFBnbzQ5cDk0NG5HVGIwelJ0WFdjbituallYbkV4VjZrdlYr?=
 =?utf-8?B?MGFtWHA0UnhtTmF6dUpkMkdOeGF3TWl1b1RJUTRyWFFwM1pwTjV5aWdKZ1pP?=
 =?utf-8?B?WDIrUUhBRHVYN2lMY09tbElRc0Vabk44KzJzYnBCUmZrSlVMSzl6aWo2WnI4?=
 =?utf-8?B?Z1FFRGgvTVlnUDMwdTFUbXVkSU1YNmRoM252R3BEdGIrV0dnVEZpdUdNaFlC?=
 =?utf-8?B?eUtXbkl2S1FLa3hENDdLYi9JN2JpMlc1Z2tXenFWR0F1bWM0RGQyb2lZYjZj?=
 =?utf-8?B?Q2pSUTZVL2U2VlplaXJQR1pGSTRTeGp5Y3RzNFFCdW5GN2FyK1lwSU1qTVUx?=
 =?utf-8?B?N3dGc3N2K1FJYnlhaTk4UGMzcUZXaXFxMWZ0TnRqUm9KUS83QTFlYjJlWSt6?=
 =?utf-8?B?SFJKSEpHV2h1R1htaXFNNU9RbDU2d3ZnOGpKdlhtZ1NWdGwrVWNGMlhGWXJK?=
 =?utf-8?B?cmtXVFYrdmhnOWM2OFlTaUdCUWtYTmx5VzhFd2RsNmdCWEJiQmo1N2xYd1Rs?=
 =?utf-8?B?a21aTUh1bjFzMGNyMFIvWlhEMUhnQ3FvanQ5OW5NTXlmL0tQV2Q4VEhmZ2RQ?=
 =?utf-8?B?YWhYVWZsV1RLRENyVzlGdXprcVFFRnZqbTJCTm5wRS9kMlRIWVhRQjNmS1Z6?=
 =?utf-8?B?WW5GQllLbDVRZG9GcTQxTEhKTUc1eU5yN1NpU3VvaWlzM21HZWkzbFdPMHFS?=
 =?utf-8?B?QVBsdkw4ZUpIRjlnaS9mUUlOZlpHTXdjbTloTUE5OG9mbDZaRlF1VkJld3VZ?=
 =?utf-8?B?SkNRdWFCN3JrZmQ2VGxOa3F5a2EzWWUvMnBoUXRMSGxPY1FacEw3dXVBZkND?=
 =?utf-8?B?dVFoYklFK2VJbkh1TjFQRVREelNXS3FTZTM0dkJzNjdDcVc3c0M3bS9YT0Rn?=
 =?utf-8?B?N0V5K2EwdUtmOTBVamV2dktCQjhsYjgwU09ZQ1BFbjNRRTUzZFIxUzBveG1C?=
 =?utf-8?B?QysweFdhR3hvUUt0UVlIaXhCL1dtMEkyNGRabmxKTmZVV2x0S0JNa1AxcHFK?=
 =?utf-8?B?VjJ3U245ZjVmb3FXU0liVXh3ZU5XY0VaZmNDRzRoa3QxdlQrZTMyL2dYNHA3?=
 =?utf-8?B?Q1E9PQ==?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e6dd148-9780-452a-2aa6-08dc94732dde
X-MS-Exchange-CrossTenant-AuthSource: DBAPR08MB5830.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2024 17:29:19.3352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aLKHu5AVrRvttm5T7b3K3CX5UK3OE8WDeeKwkcu6NGSG5WM3OrYGSUl6FrliFBs+gnb1/x8Fd8iGAh+UAHVC9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6233

Hi Lynch,

thank you very much for your reply and for willingness of making the global open source better. :)

 From your replay i clearly understand that you have tried to increase the number of segments
and that has boosted the performance and that it did not work properly before your fix.

But why this particular patch fixes the problem?

What was the exact root cause of the problem? (not high level "front-end OS did not boot", but on the 
low level - what caused the problem?)

As the patch effectively preserves the original req->sector of the request - how did it matter?

Is there a possibility that a single request is handled in parallel somewhere where req->sector is 
checked?

Or is the same request is handled sequentially and the second+ usages suffer from screwed req->sector 
value?

Can you please show the call traces?

Thank you!

--
Best regards,

Konstantin Khorenko,
Virtuozzo Linux Kernel Team

On 17.06.2024 07:51, Lynch wu wrote:
> Hi Konstantin:
> 
>    Thanks for your reply.
> virtio_blk.c is the front-end driver code of the virtio block, which has the following code:
> /* We need to know how many segments before we allocate. */
> err = virtio_cread_feature(vdev, VIRTIO_BLK_F_SEG_MAX,
>    struct virtio_blk_config, seg_max,
>    &sg_elems);
> 
> /* We need at least one SG element, whatever they say. */
> if (err || !sg_elems)
> sg_elems = 1;
> 
> Eventually, the max number of segments will be configured through the blk_queue_max_segments interface.
> When I modify the value of the sg_elems due to performance reasons, such as 128, I will find that the
> front-end operating system cannot be started normally, which is manifested as the Android file system
> cannot be mounted normally.
> 
> You can do a simple test to modify the default value of sg_elems virtio_blk.c in your company's
> virtualization solution, as follows:
> vzkernel$ git diff drivers/block/virtio_blk.c
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index fd086179f980..0a216c9cb563 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -719,7 +719,7 @@ static int virtblk_probe(struct virtio_device *vdev)
> 
>          /* We need at least one SG element, whatever they say. */
>          if (err || !sg_elems)
> -               sg_elems = 1;
> +               sg_elems = 2;
> 
>          /* Prevent integer overflows and honor max vq size */
>          sg_elems = min_t(u32, sg_elems, VIRTIO_BLK_MAX_SG_ELEMS - 2);
> 
> At this point, the expected test symptom is that the front-end OS does not boot properly.
> 
> In our virtualization solution, we used your company's blk.c as the back-end driver of Virtio Block,
> found the above problems, and made problem fixes, and at the same time, the performance of Virtio
> Block has also been improved, so we want to give back to the open source community.
> 
> Konstantin Khorenko <khorenko@virtuozzo.com <mailto:khorenko@virtuozzo.com>> 于2024年6月14日周五 19:23 
> 写道：
> 
>     Hi Lynch, Andrey,
> 
>     thank you for the patch, but can you please describe the problem it fixes in a bit more details?
>     i see that the patch preserves original req->sector, but why/how that becomes important in case
>     VIRTIO_BLK_F_MQ feature is set?
> 
>     Thank you.
> 
>     --
>     Best regards,
> 
>     Konstantin Khorenko,
>     Virtuozzo Linux Kernel Team
> 
>     On 17.05.2024 11:09, Andrey Zhadchenko wrote:
>      > Hi
>      >
>      > Thank you for the patch.
>      > vhost-blk didn't spark enough interest to be reviewed and merged into
>      > the upstream and the code is not present here.
>      > I have forwarded your patch to relevant openvz kernel mailing list.
>      >
>      > On 5/17/24 07:34, Lynch wrote:
>      >> ---
>      >>    drivers/vhost/blk.c | 6 ++++--
>      >>    1 file changed, 4 insertions(+), 2 deletions(-)
>      >>
>      >> diff --git a/drivers/vhost/blk.c b/drivers/vhost/blk.c
>      >> index 44fbf253e773..0e946d9dfc33 100644
>      >> --- a/drivers/vhost/blk.c
>      >> +++ b/drivers/vhost/blk.c
>      >> @@ -251,6 +251,7 @@ static int vhost_blk_bio_make(struct vhost_blk_req *req,
>      >>      struct page **pages, *page;
>      >>      struct bio *bio = NULL;
>      >>      int bio_nr = 0;
>      >> +    sector_t sector_tmp;
>      >>
>      >>      if (unlikely(req->bi_opf == REQ_OP_FLUSH))
>      >>              return vhost_blk_bio_make_simple(req, bdev);
>      >> @@ -270,6 +271,7 @@ static int vhost_blk_bio_make(struct vhost_blk_req *req,
>      >>              req->bio = req->inline_bio;
>      >>      }
>      >>
>      >> +    sector_tmp = req->sector;
>      >>      req->iov_nr = 0;
>      >>      for (i = 0; i < iov_nr; i++) {
>      >>              int pages_nr = iov_num_pages(&iov[i]);
>      >> @@ -302,7 +304,7 @@ static int vhost_blk_bio_make(struct vhost_blk_req *req,
>      >>                              bio = bio_alloc(GFP_KERNEL, pages_nr_total);
>      >>                              if (!bio)
>      >>                                      goto fail;
>      >> -                            bio->bi_iter.bi_sector  = req->sector;
>      >> +                            bio->bi_iter.bi_sector  = sector_tmp;
>      >>                              bio_set_dev(bio, bdev);
>      >>                              bio->bi_private = req;
>      >>                              bio->bi_end_io  = vhost_blk_req_done;
>      >> @@ -314,7 +316,7 @@ static int vhost_blk_bio_make(struct vhost_blk_req *req,
>      >>                      iov_len         -= len;
>      >>
>      >>                      pos = (iov_base & VHOST_BLK_SECTOR_MASK) + iov_len;
>      >> -                    req->sector += pos >> VHOST_BLK_SECTOR_BITS;
>      >> +                    sector_tmp += pos >> VHOST_BLK_SECTOR_BITS;
>      >>              }
>      >>
>      >>              pages += pages_nr;
> 

