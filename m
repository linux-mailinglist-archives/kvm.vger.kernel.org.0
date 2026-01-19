Return-Path: <kvm+bounces-68480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C4D21D3A0F5
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 09:04:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 45C023003862
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 08:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CC1533B6C8;
	Mon, 19 Jan 2026 08:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="hefsR0RS"
X-Original-To: kvm@vger.kernel.org
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazolkn19012054.outbound.protection.outlook.com [52.103.43.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7930E274B46;
	Mon, 19 Jan 2026 08:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768809897; cv=fail; b=Aqac7tf23qnGf5TgArclk/sL25WhaRUhxH+VKMthupwUcQrjOC1MOpdchzWx96XpWnF4ymori3K57yCNXUgYRXPuiYYVgu0F9wZRPEhlQWvm6M6IRGmwg0EJSXK2tSCMLxPwcLmPxlw7ck0wg9CIA7Vq1hiVRK7pZoZqWF0AbX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768809897; c=relaxed/simple;
	bh=FbaaMfncUhpkvnzNf3efArSSJ2bO+9+CSuZT1JiaaC4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Q0oC7Qt23sXV/fDNes1Toc+ggO0P6ZCV4RsfrxsINdTljiDet12tYp1XECxLXBaVbli2tn0MfI597G6TKEqGqqinROZBbGlv7HMNui7ZqBl9iY5/eIDVoOWo5qUfzfLDJ2/TPRGR4wFIJCOEPm90Sm9e6ikjUhfZWLXcdv0v+8Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=hefsR0RS; arc=fail smtp.client-ip=52.103.43.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OwVIvLSMHrnCQISq3P0TCagsSXqtInP7gq4Hgi22TjZYwZ44S+2w8vC8FhNMZFkELUXmnN7BWTXMf4YvKW9IkhR2zkhJBDQf1vsH22yycnmCXS/qNqO9V7gjjZdK9gnqT35tICgUQ3qoUlQ2rfqK23iq3IumDpHVtOjRGxcwkff/4CBRjAeJXytojT9IwRrDNfc0QD554SSfNT4UK1kPZDvqUOvM+NojvedPiW5qyYYP68rggAjfDP2GVo8nRf8pToo0Vb52Mv3kNIDPj43pboX13/1xoSs5xraFUmfLu3TMJXK/5wiBNp0RzW7xswmJOSzCw3qZDY+aF/8phU9iig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ei8K6vIu0hq3yxOwXvpDvqb4ju0b3d1OzSRChd3GmyE=;
 b=ZLBCmjXyvWDKmEb7OYEkM5+dBo0+lMKvq7Sk9HvPKWy0xc6OQP97l8nFW2jc/+nYVSOr5TF2R1xG4Xk+BBJvLwxBYCPkyxld/nyHS4ZHHloeEbLF2vYfgMRxV91O26fu35oVVcjMp1TW1en1gmjmCX5xvMcyqv7UmG9mRcUa/Jdj9YVK/RX0fCkeELOf15LKVDR57R7g0J/9Fc3K4vnEHGktTiHiFchcJPc2sI4pINjPk2Nv1Yd0n+QDIjvg1T2vXUPrAvbF7ILlfXNg83fUzRobd56j0m7ZIw/jDSg8bAdTX37hADLw+OkegEMHAluetnBODVLJUQZIrwdemp0efQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ei8K6vIu0hq3yxOwXvpDvqb4ju0b3d1OzSRChd3GmyE=;
 b=hefsR0RSOi65MbW3s9cCjuGMZs6wox8HsAX6e/v5xtaVuT6x0iVXQ6sObdvvunrIG11zrKFGb3tekwxxWGfWuvm5WBTm1lP85Cd8POTc19fGB4zxI+oX/WlAJqOi2qSMmDoF9zumeTbc1vWbYSlOevzGEkXb8h+SjQpiXYnPizOX7DNjvhD/tRWRTBMyCVxnnStB7B12FHmMyyKRYFs378SxztTxDRYXZR8unF/YsmZUBS4jvwWWtdiLzontqnNhoKwydKc398/M1MH4l9RS4YlXlFVwl3LnFucvksNAm/SOZ8Zj5F7QNpo+hhN3bE2fNySq4SZlozsOAe+gPyEKog==
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com (2603:1096:d10:5a::6)
 by JH0PR04MB8132.apcprd04.prod.outlook.com (2603:1096:990:a3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Mon, 19 Jan
 2026 08:04:50 +0000
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa]) by KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa%5]) with mapi id 15.20.9520.010; Mon, 19 Jan 2026
 08:04:50 +0000
Message-ID:
 <KUZPR04MB926578764A9084461E2CB38EF388A@KUZPR04MB9265.apcprd04.prod.outlook.com>
Date: Mon, 19 Jan 2026 16:04:43 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] irqchip/riscv-imsic: Adjust the number of available
 guest irq files
To: Xu Lu <luxu.kernel@bytedance.com>, anup@brainfault.org,
 atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, tglx@linutronix.de
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260104133457.57742-1-luxu.kernel@bytedance.com>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20260104133457.57742-1-luxu.kernel@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY1PR01CA0184.jpnprd01.prod.outlook.com (2603:1096:403::14)
 To KUZPR04MB9265.apcprd04.prod.outlook.com (2603:1096:d10:5a::6)
X-Microsoft-Original-Message-ID:
 <e868e849-5260-4adc-9211-5601ed3e004e@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KUZPR04MB9265:EE_|JH0PR04MB8132:EE_
X-MS-Office365-Filtering-Correlation-Id: f03fc7c2-81a1-4b28-58cc-08de57316b44
X-MS-Exchange-SLBlob-MailProps:
	qdrM8TqeFBv5zL3Pq3ogIg0sNnRYStpo7lruchUQvmpF+sBvCPh6+zuL+4jZBErBWrt6yA8mtoZ6K+Ar41h2GP3SMwHvGpJky8vEfRZppV6jaW8LS0uTrXKE30/xgmqWdSuzTeQIREHGxFM7e8Mt0tCDhVYEjJx2gCQ6RYqTwjnqe+wskZTtJLVSd12En4WKYywIeP4sHbpvccysdCGSkCQioFq99/LF05VI8Mt1jGZSYIrEXJUENqVqThVhDZlCcIP9SZiU75+xGMOpl+Zs/yydYZjmMnAfKf0RRtPWolR2pfff9DJ2A7GX2GukDewkAMTBoqDCy+M4a6HWEeePgZ5u1XISPNt0GNiPXW6JZ5nyDf7c4KPEiGAbyjFJOilJ3XNXEm9OBk+t3Tkmtwy+B6wKl2XIqrQsCq2aw4CknfaQ0Q91lQaK3SsXWqf4rmBTTAwup7n/ACbdehF5/4MNaDwhn6oT3ng/zZLdr/WvKDspztjbZ+CP7ZIkKlUCQB/M8WRvNbqZuhs+YotpCpawiY1tSKbIx8o8d62Xx24lmYy0I8YrbUcOdRUrWYROm0x3QndYZYAtSy4Yk8EQO2+uFXeDfeLb91NwWWpyVnLdH2tB7nlyPC6JdxDi1rzsciY7R9k7KkPXP54YzLcj+BVZYk2kjZvVEuUjRdW1KAZeCmRp481d/oCeTxF3vgec80p0iioinFaR7DLIznOW6f8gu5LovBgwkR4NiMw/p9RW3w0lnjmoRgeih1kztPYAurdt1nklRIZce4QUkUlCf1T3HsJjjY1m7XBX
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|41001999006|23021999003|15080799012|7042599007|461199028|19110799012|51005399006|8060799015|5072599009|6090799003|440099028|3412199025|40105399003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S0tOQmdDN1VzR1VHTG5LWEhFRHdhcWpXWWMyaEdXN2ZUak9MaTRzQ2lDN2JP?=
 =?utf-8?B?Y04yT1pHYjIya3VhRXBmNVV6dmRIWU82cWlxdHZBMTJFVHFNWS9TZ21TRkZ2?=
 =?utf-8?B?Mk43bFJaQXdLQXdMMU9FNVoybXkvY2FqdWpGWTBhelQ4c0NhNTBuRnorMFVT?=
 =?utf-8?B?MFFlOEFlYTZQYXdqWlRoVG9xWFFtODJ4ZTdzY1dJVWRvNTc4Z0xmWnovRldk?=
 =?utf-8?B?bkdGTHNtQnhSVVZWaEdyL0tzWjBmelU1bVJRQkU5enJuNDFCejFSR0h0RHFm?=
 =?utf-8?B?amdpK2gvaVV6UkFGNE0yYmw0QkhVdnIyTGx6NS9Cb2FBL0lkd2RSN3pSeGJT?=
 =?utf-8?B?VmhGUTZqblpVUmZnbW9tUXNHYTFFSUowQ25ZTFhmamhKYkVZZ1F3dXZYZ0xo?=
 =?utf-8?B?b1NMTDRuVXUwSFlyb1NhRDRrVXBVMWZyRC9FdHFNMWFEMkNMMmp0N29Jd0Ux?=
 =?utf-8?B?S3FGWmY1b1pSUjJkNDJqay94N2RKN2tkL25iSzVvVFFMRko4UUJNQWZYSjh5?=
 =?utf-8?B?cC9kRnBUcE9rUXJJNTZaZE8rUG5CKzlBSFZvcExWWHB4TzluNE5jU1NxTE9r?=
 =?utf-8?B?K0k5QVRpUGRnby8zbkNFMjVwZzBEd0g5QzZJVW82dWNkZmRvcDRlcUpQZjFE?=
 =?utf-8?B?SEsrQkpHWTdRYU15YTV6alZIUmZWcUxuSjRWbWpCZk5ReTdkWjlZYW9xbW1a?=
 =?utf-8?B?V2oyc0RMQStBd0FJcUEwZWJCZDd2RFV6TCtaWEVRaDV1LzVzSjMyZDliRURY?=
 =?utf-8?B?ZHlZd3F5R2dOZ2tla0hnUngxSHgrV1owbWRReUhQNm1lSTl4MW11T09RUkpW?=
 =?utf-8?B?OHlZWkdQQTZLN29RSzZyZU1ORGd3WWdpMVhMU3VzdHhteEFNS2tyVVZiczFo?=
 =?utf-8?B?UjNKZ3FLRW9jWUJ6Slk1RVBzTHlQUXRqRkxvUVEvMHNQRjNOVkJvVVQzNHMw?=
 =?utf-8?B?QTMvRXc1QkVZc3FIbmIvQWFwLzRseVJVSmV1STJKNjhpR3h2Mmw4SERQY3J5?=
 =?utf-8?B?Z1RLcDNyY0ZqRFp5M09jM0doUzJaajNKR2M5S3ZsRG15cnVDRzN6Z2phZk80?=
 =?utf-8?B?QXpaUldHQ09ldWM3SklsWDUydkZYWndoU0k5U0ZYTFl0UnRhLzJSSkNQdHAv?=
 =?utf-8?B?UFp4cDlBSXN5aDJYNGtZU2NMczUxaXNKOUVGTUlzeGxjZ3F6MjZRZi9JM3pC?=
 =?utf-8?B?M1MveElqRUtoMnpnYmkwSjE3Vkk5VXh4SzlGeVZUOE1PbndBRzJxOXhOMFAx?=
 =?utf-8?B?RGZ0V0QxNk5mTUt1SndPRENXRGE3cTE4ZDZiY2hib2lOaTNZSUFMS2dUTDJw?=
 =?utf-8?B?ZWRNd0M1cUh2OWhmTWVWTEFBRmszM3NJekxiNzRQL3h2VDdyMyswQVIvL0do?=
 =?utf-8?B?bDl4ZW80MzBxR3JlMjk3Z3cxaCtOZld3ZWFDcWFvM09vQ1BCTDRWZjR4YWVW?=
 =?utf-8?B?bzF0RUxSTVFudHk3UXNIdFBDemExV3NqV1NuTHdVcVl3LzFLdFNrcFNvN0Zz?=
 =?utf-8?B?bHFMOTB0N3paaHdYU1NyUXlmYWgxREE0UjIzd0Q5M1FMRUdjdGR3akI5Smhl?=
 =?utf-8?B?V0w2TTN1cnFBRU5UeVM5Mk1CWkxJdC96cEluZzdxejhtUTdFRGtGdCt0SkRP?=
 =?utf-8?B?a3VXeW4xSXlxUlM2TW5CQUVpNG4wY0JTRW8zYUdaaW52RDgrbkVaR2RIaDNX?=
 =?utf-8?B?RGszQ0JUSk5xQW93T1JZeXl0OXVlVUxtUjZFMEh5S3gzeGVmK3RkcVVBPT0=?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OWxjWW8wWGlDQjhyYmVzd0picDVuc2x4NmxlbzhBMkRSSVBOdHpocnJFUTYv?=
 =?utf-8?B?cmQ1WlR6VFFha1lRVHJZdGx6amQrc1BwNC92M0dVTlcrbGN2RVhGT3J5Zmcx?=
 =?utf-8?B?S01rTzhqV2FhSjMxYlN4Nk5VT2NCcXVVWldmMktaOUk4S1dqam51b2UweDI0?=
 =?utf-8?B?MWtXWS9EVGZqdUwrVDJUSlh4Ym5TOThJbGZ2T01VR1lxMDgvbUhPdk9mUU5V?=
 =?utf-8?B?eml1T1RzSEJUYzBMZkFSTVlrZGorV0R3TURDaUFXZ3VqeDlPNEtuZjBmL1Bo?=
 =?utf-8?B?RngrOUNtM3dXQUNrZ2tJWVR4U3FHdytFSWFaMjFLY1gwT2JrNWpHU2ZtS1ZM?=
 =?utf-8?B?YnpzZEp6bmlkdjBzSnRBOEtCOFJHS0Rua3FJdzhSaDR5OUpGbGdyRE41R1Ex?=
 =?utf-8?B?eDI1eUVucVBVOUVEVXhNWmovcy8rQkYxNks0M0d5WjZReW1uby82eEQwM1dJ?=
 =?utf-8?B?bXNRdW9tZlVNQlBha09rZk1oWVhJMHZtb08vVGREWVpuYkw2SGhqV1BSREp6?=
 =?utf-8?B?VkVnRy9HRnVrVTFObFBabVV4YWhOMmZ1Z3VLZldSU0pBc0dEOTluZi9YQ2Fz?=
 =?utf-8?B?Q1dhSzB0WllOM3JxUjJSMDkraUJ2WGJVK2RLNUs5V3RveHZNM1RVYUU4d1lp?=
 =?utf-8?B?S1RCd2twRlpHQ0lhQmVsTGtncncwa1VuMlFXN1Vob2EybkVGcnpEcXhYZHVY?=
 =?utf-8?B?RDZiRFlBbGE4NHZsRjhIbVFiY3cvM3kzSWczRHVQRmZGNTZmS015YTIrL0ds?=
 =?utf-8?B?SzEzWGdHMjlBb3RoSlJ1YUxiUmNaQkRuYXBaWStyU3RTNFcvMTRad3dSbXRD?=
 =?utf-8?B?S1E5UmFDQUtlLzNkRVpQbzRtbUNaa0o2eUlLcEhTU0hGb2IyY1h0dllxNnNi?=
 =?utf-8?B?ampYcEhFK1dnT3pPQitIMk90M0N1UWpGZFhMb1NGMUhwQlBSWjZZdlZCWEdV?=
 =?utf-8?B?Y3lOT2RQV3k3eHA0WWVSRFZMcDhMdnBhbW1NNlo4aU9BOFR5QXJ3ZE5nWXhu?=
 =?utf-8?B?YTNFUmk5VXJ4TzdRenloTUxKdXpQeS9hNVNIc1FCVkY2eElMci9rNENnaDNL?=
 =?utf-8?B?ekZMcnlubFhUNHV6UTJlZEJBRmhzamxQRmdnYVdKRHhwN2l3UzFCUHhaTk5P?=
 =?utf-8?B?Q2lJb3dLeVp2VFYzZU5NWVc1RGs1ZXVNOTFva2RlY1crYVJoQ2djaGYzYzcw?=
 =?utf-8?B?dWRrTTd6bnJjVmpvRXpwdk5mRGxkTGtueG8xd1lYb25KNldOR0ZYZlE2b3Fq?=
 =?utf-8?B?TmRWRlhyZFA5V2NtajJQUXM2UGlqWjhVNlpKOTRBU2RTUlpIWUxrYVIyUGxz?=
 =?utf-8?B?bnNsZ2FQOXByWFM1ZGpQT3lGVlF3aHhGZnRpVFRocGlNOTFSNVlrV1JwWTg4?=
 =?utf-8?B?ayt0MmVUVmRlb3dSYlpTc1YvT2djbGdCWm9qc0tNYUFpKzJTT0dSZTFXVTFL?=
 =?utf-8?B?NGJ4WG1XMEpVamc2R1luS241SEU3KzFDRHRYZVNmOW5MR2M4cC8xNzNpZ2k0?=
 =?utf-8?B?UTM4bVQrbG5CMldMQmI1ZHBXSGVNN1RydW9VazhGR0M0ZlJjS2JWd2ZOamh2?=
 =?utf-8?B?cXVRM3NsRUhuamMzbjRMbDB6Tms5QmQvb0o1WUVmREVEUXBVUG5Pd2tuZFo1?=
 =?utf-8?B?dHFSTHVqTzNLcTArMExzditKODBWaWVVMmw5eGhoVDRHSjRPcU10S1IzVW1Z?=
 =?utf-8?B?bSt0c2VHUktXZTVpdUhzRjQwKzU4RGlXRkZkRnVtdXBlWnlJb3ZJYVNwY3hD?=
 =?utf-8?B?eTdTRnZDS3cxWndYODM4Y294MDJLUURYQVBjM2J5bTFkMStETVJVMzVtK3FK?=
 =?utf-8?B?c0tDUkphbnNrczNOUjFpRmE5TDg4RjdRd2dNTUtOTXM0UmR0Mksya1hacDJy?=
 =?utf-8?Q?DizHJ1S96yuDR?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-515b2.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: f03fc7c2-81a1-4b28-58cc-08de57316b44
X-MS-Exchange-CrossTenant-AuthSource: KUZPR04MB9265.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 08:04:50.2880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR04MB8132

On 1/4/2026 9:34 PM, Xu Lu wrote:
> Currently, KVM assumes the minimum of implemented HGEIE bits and
> "BIT(gc->guest_index_bits) - 1" as the number of guest files available
> across all CPUs. This will not work when CPUs have different number
> of guest files because KVM may incorrectly allocate a guest file on a
> CPU with fewer guest files.
>
> To address above, during initialization, calculate the number of
> available guest interrupt files according to MMIO resources and
> constrain the number of guest interrupt files that can be allocated
> by KVM.
>
> Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
> ---
>   arch/riscv/kvm/aia.c                    |  2 +-
>   drivers/irqchip/irq-riscv-imsic-state.c | 12 +++++++++++-
>   include/linux/irqchip/riscv-imsic.h     |  3 +++
>   3 files changed, 15 insertions(+), 2 deletions(-)
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty
> diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> index dad3181856600..cac3c2b51d724 100644
> --- a/arch/riscv/kvm/aia.c
> +++ b/arch/riscv/kvm/aia.c
> @@ -630,7 +630,7 @@ int kvm_riscv_aia_init(void)
>   	 */
>   	if (gc)
>   		kvm_riscv_aia_nr_hgei = min((ulong)kvm_riscv_aia_nr_hgei,
> -					    BIT(gc->guest_index_bits) - 1);
> +					    gc->nr_guest_files);
>   	else
>   		kvm_riscv_aia_nr_hgei = 0;
>   
> diff --git a/drivers/irqchip/irq-riscv-imsic-state.c b/drivers/irqchip/irq-riscv-imsic-state.c
> index dc95ad856d80a..e8f20efb028be 100644
> --- a/drivers/irqchip/irq-riscv-imsic-state.c
> +++ b/drivers/irqchip/irq-riscv-imsic-state.c
> @@ -794,7 +794,7 @@ static int __init imsic_parse_fwnode(struct fwnode_handle *fwnode,
>   
>   int __init imsic_setup_state(struct fwnode_handle *fwnode, void *opaque)
>   {
> -	u32 i, j, index, nr_parent_irqs, nr_mmios, nr_handlers = 0;
> +	u32 i, j, index, nr_parent_irqs, nr_mmios, nr_guest_files, nr_handlers = 0;
>   	struct imsic_global_config *global;
>   	struct imsic_local_config *local;
>   	void __iomem **mmios_va = NULL;
> @@ -888,6 +888,7 @@ int __init imsic_setup_state(struct fwnode_handle *fwnode, void *opaque)
>   	}
>   
>   	/* Configure handlers for target CPUs */
> +	global->nr_guest_files = BIT(global->guest_index_bits) - 1;
>   	for (i = 0; i < nr_parent_irqs; i++) {
>   		rc = imsic_get_parent_hartid(fwnode, i, &hartid);
>   		if (rc) {
> @@ -928,6 +929,15 @@ int __init imsic_setup_state(struct fwnode_handle *fwnode, void *opaque)
>   		local->msi_pa = mmios[index].start + reloff;
>   		local->msi_va = mmios_va[index] + reloff;
>   
> +		/*
> +		 * KVM uses global->nr_guest_files to determine the available guest
> +		 * interrupt files on each CPU. Take the minimum number of guest
> +		 * interrupt files across all CPUs to avoid KVM incorrectly allocating
> +		 * an unexisted or unmapped guest interrupt file on some CPUs.
> +		 */
> +		nr_guest_files = (resource_size(&mmios[index]) - reloff) / IMSIC_MMIO_PAGE_SZ - 1;
> +		global->nr_guest_files = min(global->nr_guest_files, nr_guest_files);
> +
>   		nr_handlers++;
>   	}
>   
> diff --git a/include/linux/irqchip/riscv-imsic.h b/include/linux/irqchip/riscv-imsic.h
> index 7494952c55187..43aed52385008 100644
> --- a/include/linux/irqchip/riscv-imsic.h
> +++ b/include/linux/irqchip/riscv-imsic.h
> @@ -69,6 +69,9 @@ struct imsic_global_config {
>   	/* Number of guest interrupt identities */
>   	u32					nr_guest_ids;
>   
> +	/* Number of guest interrupt files per core */
> +	u32					nr_guest_files;
> +
>   	/* Per-CPU IMSIC addresses */
>   	struct imsic_local_config __percpu	*local;
>   };

