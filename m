Return-Path: <kvm+bounces-45888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EBBFAAFBEF
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:47:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03B9E3AA153
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E4D622D7A6;
	Thu,  8 May 2025 13:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="A68A6OAE";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="lcL0/zvU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B1A18DB14;
	Thu,  8 May 2025 13:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711974; cv=fail; b=mQ3BHC1w09TvLwftAAYxP9hrk3DvVCAHOXmzkA1ZZpLMysTZbk3IUu+2TjYQh4GA0sVNcDcPZP9Qqv3oQGB0xAvPQdJgZVT08z7oV2PNr1qBgTOD6SQVZzjjwTBCamj9pogBLw3kimqLqrddJ8UxBsRP2qsZ467WDII5C93E95k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711974; c=relaxed/simple;
	bh=ul+Hl9SxzlQspESZPCxEegVY9IVPk3LrnPfyRkP0vI4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YQNfAgsD/6QioS+nCJ+mBr9lwVa36xS2XmCudmG223jfxs2dtvxaIogUBT1VqBwx+4aMPROUwsc2OcVLUTFTS1knAjuIghVaTil+n3+TPDyyhnqFte1D+iPzlfFpN7+AUN9AZrytn4xWsWoGd7zzfTi+Nyn1p/GLNlcscty/ya4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=A68A6OAE; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=lcL0/zvU; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 548B97cb003373;
	Thu, 8 May 2025 06:45:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=ul+Hl9SxzlQspESZPCxEegVY9IVPk3LrnPfyRkP0v
	I4=; b=A68A6OAEutIUP/0X7/R1EDUlosJbfbHBtQ5a30yGYJStTrIudmJypLoIO
	dWi5vDMdfJThA5NOnzYCQKSYKIpWaUfffoGyyJ4klASB8ZQNhCdPS29AwEWr8O+4
	54XPeBBbe96C8OgnK1QXtMIZep2pTnVkEHIwGq0mgj4VZbKC8qvPf8curyHHoEnV
	dMYU6oR3C7fzmHpwFGqK6jPqKCpKHfdQ9ACtRBPpUQw8gsAnDpf4vsCTQpeOp1lI
	v+yzbS1JLI6Sg/2JaynWfRdrFe7wz03xMF4oLJ1/efnoIlWRjV+q0JnaEBQ/yDXC
	In6jpi3qYCZileaWk3iPIBerL1rpA==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azlp17010006.outbound.protection.outlook.com [40.93.10.6])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 46dh8j3uxc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 May 2025 06:45:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JfRpg/2JknvbbS2c04z1R/H6NrmzNDdjBhSblNukwJzTScxQZgRI9Q8PcNmkpwwKkhA31H/04Z9rJ3lSGQ3PKaVGP8Ik+BSjph4/YeGkGYZledpNDijPIn71uDfdI+TY4ehipdYfww2jhUR9mADyZZNr7ZjE8YB0znXjGEQofEAdLjfXpXgCb3orLGhvpavuod3gEdT5TxFeL6sLb7LT+Duq3U1SIWaTnRK4qCDml4Y0U9j44c3MqJz2Jwkvnee7j/9iR26fCr3qNK1LJig3omhgCOfdoS3pc9+JLgq+5BDndtUgeKKXYhas9SiABIIugfFnbzCMaYxZ9qKMU9P9vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ul+Hl9SxzlQspESZPCxEegVY9IVPk3LrnPfyRkP0vI4=;
 b=I14/S4Z5jpal0GDAvhW0oLhmRbMOp4wsbruETs0mMaBe4pX0wZ3OVzDpP98VIadjV3Oyx9+HBL5ZoagAC0RGPkp92ixH1yCaO9k+gEsG8qtybwNt6hV/BQODvhxOhmAFHQe1+uCrH1E4mt6mK2VIDZL8TFDnhEMtvbNTjbz9Ncw+R/ZjkeB7rbIQhEbLUYSUAIRVE3NbL9nZncJegSiDaU9mm2Nq0UT8NVv2Ff7q0xZaY4IkvMAMo+0pCB0NYJ1MCKqw7oWytf2xrrol5PpXVIoTYYUknhu/wevPLgZJO8gdZUvJdgNi1SuEJESVaY5oFEjILHIIEmgHs9IgZzTvxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ul+Hl9SxzlQspESZPCxEegVY9IVPk3LrnPfyRkP0vI4=;
 b=lcL0/zvUaUBSAYZGS1MPHjJTsulqaODT9eBZYdqRZamU+HItbMZ0GHmBEp5KTIbIMoE4t0SRxYlsMmQEhPVwzsb3vxxpMxXadWtYTRSFnsdIoh5l6A/FyNhzlCYqkGfQzy+uR3LrtxYYA06PeDmGOic/1agbD8pd/FnRtwslP3lasYKJbCA9932z1gFV/nDXdqPzYKQZIhohCKOwfQDxh2pXz6o6VSG4/sIwZj8gV0Yqgcds+RnHC8Q7ehSoWxZ/qgNUkz1zYNnEQ0BEk/v1YPkLhWwIRCoyp2DzJMh4LxtXIP05JATnyKCJ5xGjk2HGjBAw0m6tpWaHH8QFsjOIHQ==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SA2PR02MB7612.namprd02.prod.outlook.com
 (2603:10b6:806:134::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.12; Thu, 8 May
 2025 13:45:42 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8722.020; Thu, 8 May 2025
 13:45:42 +0000
From: Jon Kohler <jon@nutanix.com>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>,
        Alexei Starovoitov
	<ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller"
	<davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard
 Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next] vhost/net: align variable names with XDP
 terminology
Thread-Topic: [PATCH net-next] vhost/net: align variable names with XDP
 terminology
Thread-Index: AQHbv2Unji7kqewsuUawCHreFj4VAbPHapkAgAACYYCAAVJCgIAAAOgA
Date: Thu, 8 May 2025 13:45:42 +0000
Message-ID: <311D4948-8EE4-4A84-A2C4-6B104CEDB81C@nutanix.com>
References: <20250507160206.3267692-1-jon@nutanix.com>
 <681b96fa747b0_1f6aad29448@willemb.c.googlers.com.notmuch>
 <C9ADA542-813C-42C4-AF5D-92445EB70A6A@nutanix.com>
 <681cb4b95dde7_2583cf294d@willemb.c.googlers.com.notmuch>
In-Reply-To: <681cb4b95dde7_2583cf294d@willemb.c.googlers.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|SA2PR02MB7612:EE_
x-ms-office365-filtering-correlation-id: a93eef34-4f61-4d26-69c2-08dd8e36a079
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?VWdsMk9HM2NCalk0YXBQMytGeU1NM0cwRzJPOHpBK2plS1d2TjgwSklrcWtW?=
 =?utf-8?B?YytUOGwzRUNHU0dTdkVLSjhtK1J0Si9uTU13Q1YzNlhJUVloenZUU0s2Ynkx?=
 =?utf-8?B?dmNqTmJqbFJrQWI2NW9vczNkbHFkVXZaRXczNkNoOTJtd2JMcjUySFM0bHB0?=
 =?utf-8?B?UnFFQ1NRYVRXV1hrUGVzZUlZaVhXdjNuREh3cWlpaHY1T2NNenVWcG1TaU1u?=
 =?utf-8?B?NkFxRkEzc2k3K0Jqby82MXMyTmw1ZE4vYUFpeXNRRTlTaHlrcE9sSU9ha0pH?=
 =?utf-8?B?a2F2Y2owc0NlazhBTFN6dC9IeFZHMVdpc0crckJZS1RGdjk4Q0ZnenBwbVQw?=
 =?utf-8?B?STFUSkEvM0hmM0FWd2tkTE9DMVp1ZTN3YkYzU3Zha3M4UnBVRThyVE5RUlBp?=
 =?utf-8?B?a25ETzVlYTl2SlE4NC9lY1g0YmEyUXJoTkluZElHc2kvcVRPTkRIamM4RFZE?=
 =?utf-8?B?Z3NYMW9La1ZvcHY4a3JtQjVyaU1vU1ZwbS9uRkRjRThtenU5TStrb21mYWxQ?=
 =?utf-8?B?UUJPUDlNSDlETTdRejVWaGtxVHlLUmZGM3FMWTN6MlFrcnV2dW9vdVh3bG9Q?=
 =?utf-8?B?bGEwUmdSeXVjdExEWFNrbE9HUkVsZVE5eEJGNlZrQ2VvdkFDTTJUWDZsN09U?=
 =?utf-8?B?T3I3Wmoxa08xK3ozNE1vZ24vbTArSlA3NTN1c1A2SHh6ZnRTN1EwVGtEVjQ0?=
 =?utf-8?B?RU5scjBCL0p6OUlXQkFYOTdMelMyUnRjYXpJa09YWXVseGRONzM2d082SkFp?=
 =?utf-8?B?OVlwNUNCemRNMVVRTTZVU1oyMG9nT1VMNUpqalBXWnhtcjdYQUpXTndYc0F0?=
 =?utf-8?B?aXN0YytydzZ5ZFF6WWo5aEdqS1hiMkVTQmFrT3M5NHBqNUtQRHV5VGhrbDBW?=
 =?utf-8?B?Z21EZUsvS2JhQ2E3Smw3YkZCL3ZseE1mN05EbERDaUxEMm00NTVuSGxhMHFw?=
 =?utf-8?B?MGYrRytRMi9YSE9TWVVLV2JET3dhM2lmRU5mQUZkVE0vRTN3cjJvZU5GUytJ?=
 =?utf-8?B?eFd4SWR2b0I0OFVtT0Z6eHlHOVFpMWphMDgwZFA5cFdMM1V4cklOZTA4dVhv?=
 =?utf-8?B?ZXpKRFNIQk9rYWk4dWRmanBHRFlaNGcrUlFURU1rSEFGakpibW1KUDVraG14?=
 =?utf-8?B?RTVUcEplWGtWZDRBQnAyaEE0a0NHWVEwaXRhcUNFNVVjUWZobDhOVXFLL3Zt?=
 =?utf-8?B?KzhvUE5PeFFraUZsMTR3cXJHbVlraGlCY1Z6N3dFTjg5dUZpRWMwMjl3OVIr?=
 =?utf-8?B?eHpBYVpMZWdGbTFoNUNxRkFGbmE5a0xLRTF0alVEYmNKSWtwNFovUm5qa2p5?=
 =?utf-8?B?TUIzL29YakY5QWRLSmF1NnRzaEhLcmh6ZnA3R3pqQjdRWWpibVFWaHVkdnZM?=
 =?utf-8?B?RklhaHp4QVByenlFSEIxRWNaMG9LVFkzS0RZVGdoYXNwdjlJRVJrdXU4UU9T?=
 =?utf-8?B?bDFzYVNlMTZjdElqVng2YUpjRG91Q0VLM3RWemZhVEZuV1BsaE9RZlAxVUow?=
 =?utf-8?B?L29IR0FneUFLL0RLd1hmck1nVjJ5OUNMcFBTYTJkdDl4YkpEQkZDa3pKQUIr?=
 =?utf-8?B?UkJ0Q2JyTkRFVXBLUWs4ZUp1QVExWnEyQ1RvRlM4MWtBM1NVNmlsdVR1TCtK?=
 =?utf-8?B?MGNPc2grWDZGMHhRQitod1hjbXFNaHFWZXVmODZOOW0rS1pyenhDcHI4eWM2?=
 =?utf-8?B?OEFMcjFoYjk3bzFoa0NCYVk1dnA5YWx0d3YwWGxUdTI2UnlkNDZQOTE1YnFQ?=
 =?utf-8?B?bFpHd2dKVk82OStsRzl5NmpzSDB5NS82R3dQTkZwazFLUjJrbi9PMVBjN2dG?=
 =?utf-8?B?WjJ5eHkxMS9JRTNKYjBZWTlzeEFydEF3US9aUkx2RUMyNy9SZnhKTHJGN04w?=
 =?utf-8?B?dXZnNlErdEwwcmFyL0FuVlFLTFNHcWU0VllqeDRNTVdZOWlWc1FXalZSUC9y?=
 =?utf-8?B?cTZXYXNWZ0hwdnRwMVloSUNoWDh6UjN5ODhHbHBWc1BTT2JCM212RjJvMTVH?=
 =?utf-8?B?bDFXaUVSazBRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RkJvYm5GbmxGcW0zUC9lMnE4UjBwc052enlkUmNsVElyWVN1QWhxZUx2MFlT?=
 =?utf-8?B?Yk9xMnVNMDVOVWxDMlpYVUlRbVZkQTZuM2h6SVEwbFkyNURBYUZSZENFOTJZ?=
 =?utf-8?B?V296OU53VDR1WnJ2K0dmNGw3Zi9MY2FMdHV6RG5YZWhoNU13b0V2bG5zbTJQ?=
 =?utf-8?B?STA2ZkwyZXFNMTBzTmlocTNzRTJ0RzBSYWIrRGlBbmdvTSsxdjl0aUlaS0JT?=
 =?utf-8?B?UTg2bUJFcUlwaUJrOVZiWEtMNnZ1NmRNZm1xeGVncCt3czFrM054MnRTRkQ0?=
 =?utf-8?B?MkhwbTVGcGRDSFRDQW1HVDVpSEtsZTNES3loZGhVR3ZWd2o1UzBuVmZzb1Rh?=
 =?utf-8?B?cTZUMld2WlljYTdVVzlYejQvNlBLZDJTcmFvcHJwdGNpeVBaNk9HZnEveTdx?=
 =?utf-8?B?VElXTC9lbU05UmN6dUJmenV2eUh3TUwxV09LNGN0L3FSY3ppd0NaNjBHNG1W?=
 =?utf-8?B?MUtHQ21UOXV1RFoxUnNyWDZQV0lYYjVjV1Rqa2t6MDQyYUpwdXNaekdaMTBv?=
 =?utf-8?B?OEFDU1VkVkhCeFA4V0xTV3MwQVkrVGxWb1Y4Y2l4UnV0VUF0anlZdHpYSi9n?=
 =?utf-8?B?MDU5bkZzWHhjeG1Ea3hlN1pxTDYvYjJiL0lIZ2hHc050Qkc4Q2NkanNMVVhz?=
 =?utf-8?B?bUVUTjB4RCt4dEl0OFJTNVpSWU1WSkYwazErWS85anJyYlNtU3VPd0V6Q1k1?=
 =?utf-8?B?Ynk3Ty8xSSthcVZOZExJVGFHMWJzOGVKWGFJWElTd1ZLa1JVWEV2dVdWa2Zj?=
 =?utf-8?B?YkxENStScW5zamgxMG1uYXV0L3FkTmQ4WWkyNW9jV2gwSlFPZkh1UWJQUGU5?=
 =?utf-8?B?TFhENjJ0VVRvTi9teHREUnpaQVBPL2Jxdm8yVmdtUjhSSTRoZG9hZ3hTTmJE?=
 =?utf-8?B?UFdvemp2SHFweGplRXptMXFqeVNaZ2pXODNXbEpuR0dQMXVSb1V6ZUhiOG4x?=
 =?utf-8?B?enp6cGY4R1V5QWMrWmlYQW5KaGhLQWxoVXl3MWF3NDZDdXJTR1FlR3V4TFp5?=
 =?utf-8?B?dkR3M1lUWkJYUjQ5ZlJXbWZqeG5POXVPVnJacFhVdlh6S084YjBoMXY4aWhh?=
 =?utf-8?B?bUJQODBxWTdVVFdkaklTM3cwbWJmTEZodkdycjBFcVhZdEV0QXcxUDlOdWdt?=
 =?utf-8?B?Mlg4M25ZSWNEeGlVd1BTTCtHS3VmQ1NSWXRpY3B2YlNyTHEzWE5IdGRHNUdR?=
 =?utf-8?B?Z01ybmwyaml3Qk1ydGJJNVdiRDljOEdxaUQvdEZrRmZMR01oTkM4bmlFcmla?=
 =?utf-8?B?a0Y3eHVZMERQTE9EZmE2ZTNMOUJYMDFONEpFQko4aU5MUDdxc21EcTRkMVN1?=
 =?utf-8?B?cjJVYXcwZE9JOWZpQ1YvUnVMTnRjTmljRW4rbkUrZEh5SEVDbW81SjdIUldx?=
 =?utf-8?B?SVVRTHlXM05ZUXN3enZoUUk4YnZzdWFMT1hGK2RKb1czaWNNV3lScVNBZXll?=
 =?utf-8?B?a3puVk5RTzBhb2E3dSs4ajZXQ01XQWdDem8yRWRyek5KVE5Vd0U1TkFUNWJH?=
 =?utf-8?B?S3hhOFZNZU1qNnRKWG5ZMnFIWVFiVlBaL3JBU05IOVA1WlNRSU4zUDkxNjRJ?=
 =?utf-8?B?YmhJTGVvZTExc2xpS2hEK0cyQXZlVlV2R0ZJQkw5akczYWE2U1I2RC96anVY?=
 =?utf-8?B?V3Z2RHpJdkJReXpzRzdOdWFuTzdoTnlRelhBRXNxeElUMkw2VWxoNFNZZlIy?=
 =?utf-8?B?VFNNOG1HTmYxYzJuNVoyRXFjdk0rSWlMTEVMWXJTNncrT01xaWx3QzJLQVZZ?=
 =?utf-8?B?WjVmK0RkR3ByVlhZNEgvSzhkWS83cW9xa3RUdFZhWGVDZGJaUWFZMDhLbnVF?=
 =?utf-8?B?bmtpSEhUa3hxSlRxUzVwNFN3V01seWJGaDE2dVhkR296WjhMV2QrTzIvdkts?=
 =?utf-8?B?K1JkeExzQjZ6dTlOVjVRa0luMnYzaGttUnllenh1NVE4YjVqWDJvSVNjUW1w?=
 =?utf-8?B?WEhvZVBWSUJTdlNFejMyTGhBczE5VXJMbzNKMVkwRlVaRVcwZTExdS9LOGh0?=
 =?utf-8?B?bXlPYy81eGdvMjVEdVdTUE9wTkg2VmFrRkpHMkY2WDJKSzhaZzBXcm81Q0hk?=
 =?utf-8?B?TE95ZnI3eFZJWlhyQ0h3MEsvQUwwOGpDZ2hhU3ZWQ3ZtdEo1RXcwU21pWnBu?=
 =?utf-8?B?bjRaL0VEbTRSN1BveXJnTWJwaEFHSWd1RzBIOUhUOXVQUkJBTVFoS2JiR0tC?=
 =?utf-8?B?VGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D0D4EE7868889F4781FBED4A19C0265B@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a93eef34-4f61-4d26-69c2-08dd8e36a079
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2025 13:45:42.8055
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YMq3t0rBsd8JSw8//Me1yIL6Kf/kPL8lQxqCQ0/RcrNQfp21RdbKosOJINDkLAzRviiKahe9hgzTdRiEoHkZRp0uzXg2knpLGalvCN0GQlQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7612
X-Authority-Analysis: v=2.4 cv=B/y50PtM c=1 sm=1 tr=0 ts=681cb58c cx=c_pps a=vje0JErTBFrk7BtAX1kshg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=dt9VzEwgFbYA:10 a=0kUYKlekyDsA:10 a=pGLkceISAAAA:8 a=64Cc0HZtAAAA:8 a=y0Qn36cfibLKL93m3YAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: yX4rY0ug2kdmUcjiFXJVh_TyLkSmjmLN
X-Proofpoint-GUID: yX4rY0ug2kdmUcjiFXJVh_TyLkSmjmLN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA4MDExNiBTYWx0ZWRfXyg659vh/wiJ2 8GRKBWfnXjdpScmH1N60LCzveFdm6NSBB5MGWQMbrLEdMJGPFK3tThXWk2WvB4t9c4U/Rik68YZ wWJaFyrzNWccap4euTHPO1HCY9BA1v6DKqMIULzop+syXa0HaVvLx8AxL8Bxhd0TWjd/uMehgMn
 tfPxm1XK4Ob7IW3mpE3j+Kfu5Jh4sAaDwyEEMvVGI8cBm6fUDVVmi1lFBcMiy2rqGMbgJBHBD6p QEsW2ZY5td8clDVl0UJOlqijuhmcbdBxnjKDmzkWahWTqfIwX7CnQf+WY24ItSSxgWOAZTljNv1 Fbd6edRqcs5fJeznjTCMNq/ng9UMky6Q8Epsb8pY0WGdV1VJd/tz/gtPt8Bumrt12N8xImDRbQc
 UEvXO3aXlJMYOcCHTfzaESJqV+Ajes6Ck0uNYzBBN9zpJ8JApy9B1f5tdA9It9EjeMeG9DCt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-08_04,2025-05-07_02,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDgsIDIwMjUsIGF0IDk6NDLigK9BTSwgV2lsbGVtIGRlIEJydWlqbiA8d2ls
bGVtZGVicnVpam4ua2VybmVsQGdtYWlsLmNvbT4gd3JvdGU6DQo+IA0KPiANCj4gSm9uIEtvaGxl
ciB3cm90ZToNCj4+IA0KPj4gDQo+Pj4gT24gTWF5IDcsIDIwMjUsIGF0IDE6MjPigK9QTSwgV2ls
bGVtIGRlIEJydWlqbiA8d2lsbGVtZGVicnVpam4ua2VybmVsQGdtYWlsLmNvbT4gd3JvdGU6DQo+
Pj4gDQo+IA0KPiBNaW5vcjogY2FuIHlvdSBmaXggZW1haWwgdG8gYXZvaWQgdGhlIGFib3ZlPw0K
DQpJIHRoaW5rIGl0cyBhIGNvcnBvcmF0ZSBlbWFpbCB0aGluZywgYnV0IGdvb2QgcmVtaW5kZXIs
IGlsbCBjbGlwIGl0IG91dCBpbiBmdXR1cmUNCnJlc3BvbnNlcyB0byBub3QgcG9sbHV0ZSB0aGUg
bGlzdA0KDQo+IA0KPj4+IEpvbiBLb2hsZXIgd3JvdGU6DQo+Pj4+IFJlZmFjdG9yIHZhcmlhYmxl
IG5hbWVzIGluIHZob3N0X25ldF9idWlsZF94ZHAgdG8gYWxpZ24gd2l0aCBYRFANCj4+Pj4gdGVy
bWlub2xvZ3ksIGVuaGFuY2luZyBjb2RlIGNsYXJpdHkgYW5kIGNvbnNpc3RlbmN5LiBBZGRpdGlv
bmFsbHksDQo+Pj4+IHJlb3JkZXIgdmFyaWFibGVzIHRvIGZvbGxvdyBhIHJldmVyc2UgQ2hyaXN0
bWFzIHRyZWUgc3RydWN0dXJlLA0KPj4+PiBpbXByb3ZpbmcgY29kZSBvcmdhbml6YXRpb24gYW5k
IHJlYWRhYmlsaXR5Lg0KPj4+PiANCj4+Pj4gVGhpcyBjaGFuZ2UgaW50cm9kdWNlcyBubyBmdW5j
dGlvbmFsIG1vZGlmaWNhdGlvbnMuDQo+Pj4+IA0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBKb24gS29o
bGVyIDxqb25AbnV0YW5peC5jb20+DQo+Pj4gDQo+Pj4gV2UgZ2VuZXJhbGx5IGRvbid0IGRvIHB1
cmUgcmVmYWN0b3JpbmcgcGF0Y2hlcy4NCj4+PiANCj4+PiBUaGV5IGFkZCBjaHVybiB0byBjb2Rl
IGhpc3RvcnkgZm9yIGxpdHRsZSBnYWluIChhbmQgc29tZQ0KPj4+IG92ZXJoZWFkIGFuZCByaXNr
KS4NCj4+PiANCj4+IA0KPj4gT2ssIEnigJlsbCBjbHViIHRoaXMgdG9nZXRoZXIgd2l0aCB0aGUg
bGFyZ2VyIGNoYW5nZSBJ4oCZbSB3b3JraW5nIG9uDQo+PiBmb3IgbXVsdGktYnVmZmVyIHN1cHBv
cnQgaW4gdmhvc3QvbmV0LCBpbGwgc2VuZCB0aGF0IGFzIGEgc2VyaWVzDQo+PiB3aGVuIGl0IGlz
IHJlYWR5IGZvciBleWVzDQo+IA0KPiBJIGZvcmdvdCB0byBhZGQgdGhhdCBpdCBtYWtlcyBzdGFi
bGUgZml4ZXMgaGFyZGVyIHRvIGFwcGx5IGFjcm9zcw0KPiBMVFMsIGRpc3RybyBhbmQgb3RoZXIg
ZGVyaXZlZCBrZXJuZWxzLg0KPiANCj4gU28gcmVzaXN0IHRoZSB1cmdlIHRoZSBqdXN0IG1ha2Ug
c3R5bGlzdGljIGNoYW5nZXMuIEZ1bmN0aW9uYWwNCj4gaW1wcm92ZW1lbnRzIHdhcnJhbnRzIHRo
ZSByaXNrLCBjaHVybiBhbmQgZXh0cmEgd29yay4NCj4gDQoNCkZhaXIgZW5vdWdoLCBJIHRoaW5r
IHRoaXMgd2lsbCBtYWtlIG1vcmUgc2Vuc2UgaW4gdGhlIGNvbnRleHQgb2YgdGhlDQpicm9hZGVy
IHNlcmllcyB3aGljaCB3aWxsIGVuZCB1cCByZS13cml0aW5nIHRoZSBtYWpvcml0eSBvZiB0aGlz
IGZ1bmMuDQpXYXMgdHJ5aW5nIHRvIHNlcGFyYXRlIHNvbWUgb2YgdGhlIHByZXAgcGF0Y2hlcywg
YnV0IEkgc2VlIHdoYXQNCnlvdSdyZSBzYXlpbmcuDQoNCg==

