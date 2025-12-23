Return-Path: <kvm+bounces-66592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 08AFBCD8193
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 06:08:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BEDC0307D68E
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E57D3009C3;
	Tue, 23 Dec 2025 05:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="IkSS5CJP";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="MPv89bSM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCBF2F361B
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 05:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766466307; cv=fail; b=ondcR4CcJThggoly3G7g05V7GMMnAETt1gl0cgUL2N/xkBZlhFIeP6VqLQYDy8lylm76ioX5TIUZLLMfRqaL8wR7rOoQavJM75NjQfe77DrTQRdcJp1dA4AbpY0N7eupI1ASCp2gWEKExo59+K9aC4/Buth/NzV8Kss80epVrU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766466307; c=relaxed/simple;
	bh=0K09LZ39dclGwUY/I9+unICBJ2vVvb6UJnHAus8s7uw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=eDOLJEuRsDU0nlfI3dDDbJ/TkRDGOKZIXoWQKj9s9davETta9QnZ/cOq9zFyVLbIyRvebbWMQWMSdveV6rVBTIE9ndMYrBkTmMb0x81QC8j2SOYfpdnI8zVrUVqG3nMRM2EMics37/EYkeGL/3U3gmMlfcd7r9APbNVfUUcpQcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=IkSS5CJP; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=MPv89bSM; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMLNNoN723792;
	Mon, 22 Dec 2025 21:04:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=fD9qp1T/kMp0n
	Hy0r6qbB7Ev7/3lh4J5DnxBs6bgxv4=; b=IkSS5CJPhUVBfqSobrhPs+LwrAkVp
	mt5pdx6j952tNFkxwJwxN/+mIAfjsuF3fMjFhv3KXNzaHgIuBn1gNZJW5X83hOdU
	njNjjLWGRrxdsUcdovV02cLTFhSjNZyZkpH8m1iKxVVaI4HIqbp0NDzzw2sIOH+o
	aCke8M7gxY6anX5uePPNSziU/XRFz7eHJXh9zz7oRye2M324q2Yq7RGKvevK+BOa
	eLDByC+M77OlWN9T/x38J5GMPQZN2ywq0K17YEvDp8T5bqduBQqP1XJgfid8+oBl
	QRcjZc2geY2Vis0lYogwkLjF+mgl/nLX9/wLB+hTL++TiSRCD0j5ynUWg==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021103.outbound.protection.outlook.com [40.93.194.103])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b5tsjmwva-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 21:04:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UpDJ4BygoJE+nJJWFVSfbEezQHlEbHwo92vNu0/Kzakztk/ZTF+EeWoRIFMyxozZbjslgKJ8xPgzbthvGf7Mve0hKodAdAaa7W6NDOY9SmajAHyZeCOBsSlv7cQ2O2SWIbly7Ky+K9QuLF0T0qGjDVB2UtdCCMo+4EzcVT1tbBnJjczGuvnpNPCmL8yhPgZDtSFFMLJGeNc/FjprQ81MaplkgPt5OuU+5f+5V0Gs3WpYD0rEVin+V1MrR+rLMMkPtZIS1GkOvofW3Te0RFr7BICPl6EoxlrwpeJbhzPQqEGSfdKUDsuaFKKqsu7r6fVDBI+iTTZV0iBPup4TSvo1Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fD9qp1T/kMp0nHy0r6qbB7Ev7/3lh4J5DnxBs6bgxv4=;
 b=TldGay7FwVYTt3nWiOop6W0iy0OHVPjci9b3cGhofnmojo0FZfJ7kqddy+sm/I2uowpprxZUtzHDllqQNI/TvX0Mlnso1WhYhkJeA8MLg27GBLOOJu/CAmP0F9ksgej4J6IXL0vAQbya96dXPHFP4GhVQV80JMwAtYqDqAkSpObGktPSv6BzFjqPlXpO2Fs61hMVQlJTzTRRP0Q9ri2vKexolqoeSaCNDioOWfMmEclnsTl3unm8eXXJPU35AGHt8qO8l/qhPbQrZ8HOTe5OnyulOSgZxVIBXu6JgvwOORY6oleJOHGSp7dlL9NJg6SQASt+BmuJ4hxXc2ZkIYv62g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fD9qp1T/kMp0nHy0r6qbB7Ev7/3lh4J5DnxBs6bgxv4=;
 b=MPv89bSMW3lEblFA1YgIAJIx5/nClltyc07dNFMRC6AJi9rrEuT3/aeFokkRNjeQalu2oRCgrVsa4mRVMVjijOko8Ymib62frSqIWdcoRGEyvbGFU4B8YzwaoDhcathyNYFRgAfSoX++DlQvz2sKMktun1PZMfBpfDqE27rp1tTydJknvOpkDhMqD6iDLQ7uwhTHrLtLti4B43vPMC7beGF0Cm/xw8ERld9USqBO4+8SzQG01NdwPFes11sgT3Lz68BLgQoMvzNTTvVof+htH3U9aS2/iz0Luj/NGx2f3pAEfCZNaBRapuHVspBSXkaL6cMKxZ5Zi4kv5uJ6NbUj7Q==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8560.namprd02.prod.outlook.com
 (2603:10b6:806:1fb::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 05:04:57 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 05:04:57 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 00/10] x86/vmx: unit tests for Intel MBEC
Date: Mon, 22 Dec 2025 22:48:40 -0700
Message-ID: <20251223054850.1611618-1-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0018.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::15) To LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV0PR02MB11133:EE_|SA1PR02MB8560:EE_
X-MS-Office365-Filtering-Correlation-Id: 98968d49-e2c6-4755-cc07-08de41e0d14c
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fmUUHdCy+iiQJdA3zWs8gbNUhowKgcE9gapQITcXDmZ0C0TXjvJj1at4bqz/?=
 =?us-ascii?Q?chveFDyKze3VOY76PrY2J1YroECpQeeWQSCiNIRK1Rzy3Dctz9lJacjRtMr0?=
 =?us-ascii?Q?MfrvYQKQMNQ/r6ITvwjADTaqdHrNpMnkkVKcxojMzz2AAB7ZUWJ5oFJVsOwW?=
 =?us-ascii?Q?msVP6Ew8SIsZxLFW/pDEJ74FDt15a/tjlzU90HpKEHrrIE9cfNNJwzarU+PD?=
 =?us-ascii?Q?QPf9LWiDZMcm9q8GS4C2s4I5UnKpxIcJhCg/BnGrC74RsNCjVucgYSqCjuIe?=
 =?us-ascii?Q?e5MaSBWLeGBXYYbVWmNjadKOI5yIdG4Bw+uWb/yfHFyTUsRv2iQEDnHIVkuQ?=
 =?us-ascii?Q?r3Br16iMdPmVP2QewoTHIBcgBThqQW2SUqqSFFicJ2ufvTSGbNmOkYZQ9MYc?=
 =?us-ascii?Q?TohZk/olrKhoVHDHZs8qtAclDLMzJAAUGLKvyqpd9irMCFitw6D1dAkEId42?=
 =?us-ascii?Q?OwF8bFDvexHF8mU/M83XFDlr+wjyfRG+9SSwAUDkRCoSRvfkYxMfhZiqfaRx?=
 =?us-ascii?Q?458fiM6Eaqqq59LH7mPZctaTjp0RKKE4YkzE5oexejrYta5lIU2E/xAw+p8v?=
 =?us-ascii?Q?GoJCJzt6tB+ynDuAqLDy3qLYbtFNqyVnyYLF5ro/6nwM+tvegciob5VyuTK9?=
 =?us-ascii?Q?tpKtDpo52d+ucarfaS8Su+Zd/JyDGTQ0okIefb610CbNO2hMzUGGtNsaY3kc?=
 =?us-ascii?Q?TMWBZGyDXcGcd9R/tIcsL4ote9j32xvubrurqkE92UWPWNr1AO5Inv8r8j0r?=
 =?us-ascii?Q?NeYvQTIbGtyEd4GF6GNAuObMPId8Ezq9hI8A1JNh3eHbxTXb7ZVc8/WqQjSl?=
 =?us-ascii?Q?DKj43bDRGTyQI3DHbHNH+cVrJuhxHSEHkQS394+DbDl/jinPg9YXXXlqdV9n?=
 =?us-ascii?Q?bhWuQWR3tvyffbanUMZvNMlFGzOvVBiLCnL4LpRc7Up2ZABCAf9ibwabGnxZ?=
 =?us-ascii?Q?tGq/Th06UeaxZfnG91grFVqjjF6giPAXQjWR8Zikx67Phn0iqymx0WjfugHr?=
 =?us-ascii?Q?gXb9NfI1LWZyLe62IxxMMjdH4rNFr1sIUFcmRveq+cbIM/c0psEvT0M+yaOc?=
 =?us-ascii?Q?8RcSWF+YKR8wR6ia0/x+ann/l78PXdIdUXMR2QRVsU4vBATyyqDIGAaXcGJa?=
 =?us-ascii?Q?DoqVGYYXrz00U9TP2kqaBtjMvyXbCWiQxwYsnPlIAlUiRTsPnjNsEqujrNpW?=
 =?us-ascii?Q?ORxfnp3QHepwzHY+rvB6uaTuMIJnWNIARURKjsCjJi5KEF/DwgiHx8qp8Q3S?=
 =?us-ascii?Q?d8FTprLLL5Nxs9+TeuI9Dxx2jdbRwQsWPfAXcRxPaSZUsxzIwc4tzJmcmm2F?=
 =?us-ascii?Q?Q0VEb4ETpA5ED0qjzNRHwP07o7pOywviUV71jIJH17Ll7t+jzQ8CTsQRUv/P?=
 =?us-ascii?Q?LkpJtlJUgquIB4VZDcS1nn2Os/ON3wd/5GULE8lYgycDbUTOHSzYQBU0s1mi?=
 =?us-ascii?Q?lD7MgcK3CeYq6CEnxWrWaeUuF88jGwybr0rDBixgAC6GtL+bs66mEJQmPVwY?=
 =?us-ascii?Q?Ngirscp/mqL+b/IwOpqIaq5Pk8r3Dn4JTWaS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(366016)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Wr9EKm5X9TYg7tzxbkEEtb3bYcTloAFZ2MvJIrc16dMri0xVQti+6goXSVCL?=
 =?us-ascii?Q?S1i6e4NhsI4+HafDv7NNI5Z9iwtuCKpQKUnt5Uruw3XBRB07H+Aw0TM2Dwrw?=
 =?us-ascii?Q?RzsGcoICCTAhSBzwjjWQ8ENEmwEw/+ha+bNNtyRW480vlhliDu2wnlDALkKx?=
 =?us-ascii?Q?KIFKFCOJy7dAiZ00P7KTJ8ezVc+jC8IBUf7pB4LDmiYvJiJeZZnoyKoL3BlW?=
 =?us-ascii?Q?U9D+mAAMTvYiWavsJOYw0r4HStGQam1ytKO2/qchLuOJF/U0PwTY8ertTQtV?=
 =?us-ascii?Q?NMs/KKHF3hlSdTWxuusVxzToN4Fr5JBHChwV25h1go1OLT92BebCYkEekrnM?=
 =?us-ascii?Q?8OuOBmWYW3zvqO7tIJ7+BaqTKEtwQ6PYrlIIaZtYqBNJrfKL3pXWWrqzGfGI?=
 =?us-ascii?Q?F/YRit+O/hFRGxgo4git0HYcHoQr7rYQALnv6in10ygAMdJu2DDa4TF30L9L?=
 =?us-ascii?Q?Ypkc4r9Xkwm8Y9OI2+x/XPitFXlGgjqGTCZ2F1eUun9OsxM2juf9PTB4tRUo?=
 =?us-ascii?Q?4DyX8Zm9YzSX/CcJSRnNIYWjndWKLA4gNTabG2Gek+9k/KRNPWaVAu6yRhhn?=
 =?us-ascii?Q?BMwYzvkxSx8aKd4vvYCthgo52vzyEkYeDt+xjF+EhmSM5UC+nNHEQwXm0WnJ?=
 =?us-ascii?Q?VOV9ENWy2qsowINfPWwOHLWSfP59cTJhNdfT8nuOV4RB/E5PVzv2diCiDDZJ?=
 =?us-ascii?Q?OUTsYbMhnSOLOTPT2jKx2a+CTzGW9zcjhhDHtukgJ8QPtqLuehOXjbUokfx7?=
 =?us-ascii?Q?w5Ccsw3pr7naMpYphDkPqKBRfMo39pGHUH1wQ46MUZBNGFO2sMCCJVAz3qhf?=
 =?us-ascii?Q?zfKpjOU/mhSv4HbhtL7a0z/rSjRI84d+YcLgQ5mEtZxJ8YzLWOVpdoz8JFx5?=
 =?us-ascii?Q?mz0gw49KdYzNmDedM/nJuj4Ojv5a1ruoNMRg2lca092GAxA4++qTqz+lsJeS?=
 =?us-ascii?Q?4leSf0kayn8AS4grVSVcAJOYuUeViw5ZgMJSqKyQxs6aOT/iL9lUcK8uveve?=
 =?us-ascii?Q?KpDMjp+KdekpOnhjOZtNAuc+VUNi4pB7nJMpXToRrT5UDclt6Eyk2m67q6PY?=
 =?us-ascii?Q?SIKSGjSTwvUUEGD4D2UUFNCRcGk3UoPv2Lrzngup8amtE09qT8M8m34ZASSa?=
 =?us-ascii?Q?T+b4qH3+H07zNBomR1XiDU9sRmQ/Z6+9wRP8sJsU/h8KUZIZ8RNhbBMwjBQx?=
 =?us-ascii?Q?99S9DyCFZQ1eDf5vxDopKZUd533piI0FgO+NaW1IPboYCYBplF0UwDetAmQT?=
 =?us-ascii?Q?Otl9EKcXeOpKHRT82YUogyFM+AxdI8PASyxeLmwGrcLRpGYkw3zWG9dlIXsB?=
 =?us-ascii?Q?NmYT7Gybw9WtsmwQUPT4C/5lEw4ocwnPMHAbLoUIdEBnVuaCNHTRwPb2O4u4?=
 =?us-ascii?Q?7OFzhxaqE4/xsV7Z0fN1nT5jFYcCJ+19hXw7x2RSv9bHHrHBdye8HV0Xxn8c?=
 =?us-ascii?Q?QFKqluo5dDwe1Pb8lAVwQCkUexqG8r/sDwD9oG+iHnLlCi4MkY+I9TezPNFS?=
 =?us-ascii?Q?cToAuJ2nXOkdVLpmj0kqADFXtvtX3865Us5Xm4GrElbIqpWHqr/6PvH0zVo5?=
 =?us-ascii?Q?PKJL7osMTDsBZqyMvxjYT8cRtFvsLlMX/2NU+Hhca6aIDnRHjTQvCKZ7pcFa?=
 =?us-ascii?Q?tE7RZLHh8H9U1sg2hudU3piO1+OdVnd9kzvecEMlGVznyGTRIrSUqwj94AIk?=
 =?us-ascii?Q?J2DKFj8MLGDhvTLLmqV3zhiH9iCXH0nf0F+HZSWuO9FFuxY9BLYp/wGLFXOx?=
 =?us-ascii?Q?ZWuPIO+wTLk3DRPw7Pns6LRNrCFpXyI=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98968d49-e2c6-4755-cc07-08de41e0d14c
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 05:04:57.3595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Sy/DXTFXZfNA3Gl93JC8JkLd+H9QFWlzvaFhe76ExqL4D3pc2cbsBpuB16LPXluch555FJ99V8aC5me0CZS6Xk1xsaV3drDS5es3H+cR0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8560
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDA0MCBTYWx0ZWRfX2pc/lOqRK4Lb
 ZuvRrd6QtxOUuO4oM9Xu9YAG3dkg4ppSVUh6HBZsmskzaw96J+3CDraD4Ezg62//f38eWbXTMnR
 A9ziiTUDd+0h4XUorqTy57AVaSCbrGvEXwfY6276FB6Tq5pWE7NkKHb58akt5lKJzoH5jg3nf6I
 HBu05bmNWhXwimNB3xBChS7G4KJFua1qJ3lzTFXMH2lPlPpS3YcFmwd4mRfmvNA1y1fE8DjnDiD
 cNUqNiz7+5qaNEipJQrDkfYMHfficEXUCOlEuYnY8ajuY80aCqfRgOChzJtUukggn3FBB2H5rB6
 ejQ7zhBjChZTExct33JeHcK1Nd6jO4NDGsyCorRvJcFkGJSVd/GZOOm7hB7gdGqniyJ9GjsxBCU
 QTBCEHM5JIrPj/As6fBl2NzUbHOIMtSzRXYwADCjHAly7xjBfWeVdu4on8cn5OOuGMUquKhltsp
 DoteRZU1uJobzAviekg==
X-Proofpoint-GUID: ET46EucsANL4hOeFDu90oxB0NaqDvZA2
X-Proofpoint-ORIG-GUID: ET46EucsANL4hOeFDu90oxB0NaqDvZA2
X-Authority-Analysis: v=2.4 cv=Xr73+FF9 c=1 sm=1 tr=0 ts=694a22fa cx=c_pps
 a=GZ5nxs7iJwyXCG4rR3qJ+A==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=z8DzNj91VmNzxGGA1ekA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Expand both VMX and EPT test cases for Intel mode-based execute control
(aka MBEC). Knock on wood, they are mostly functional and provide good
coverage; however, I could use some assistance with the last four
patches. I've added in-line code comments (as well as commit log msgs)
explaining the observed issues. I suspect the problem is something to
do with how KUT is allocating memory.

Knock on some more wood, anecdotally, Windows desktop and Windows server
with MBEC work without any issues, so the core "does it boot" and "does
it perform well" are at least sane from that perspective.

Jon Kohler (10):
  x86/vmx: add mode-based execute control test for Skylake and above
  x86/vmx: update EPT installation to use EPT_PRESENT flag
  x86/vmx: add user execution operation to EPT access tests
  x86/vmx: conditionally include EPT ignored bit 10 based on MBEC
    support
  x86/vmx: update EPT read write execute test for MBEC support
  x86/vmx: update EPT access paddr tests for MBEC support
  x86/vmx: update EPT access tests for MBEC support (needs help)
  x86/vmx: update EPT supervisor execute only tests for MBEC support
    (needs help)
  x86/vmx: add EPT user-only execute access test for MBEC support (needs
    help)
  x86/vmx: update remaining EPT access tests for MBEC support (needs
    help)

 x86/unittests.cfg |  21 +++-
 x86/vmx.c         |   3 +-
 x86/vmx.h         |  24 +++--
 x86/vmx_tests.c   | 266 ++++++++++++++++++++++++++++++++++++++++++----
 4 files changed, 286 insertions(+), 28 deletions(-)

-- 
2.43.0


