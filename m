Return-Path: <kvm+bounces-63667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id B651DC6CAC8
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 05:08:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CD773359C2E
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 04:08:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 441E72F2605;
	Wed, 19 Nov 2025 04:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="Fr+fzwqJ"
X-Original-To: kvm@vger.kernel.org
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazolkn19013072.outbound.protection.outlook.com [52.103.74.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF25298CA7;
	Wed, 19 Nov 2025 04:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.74.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763525294; cv=fail; b=q11Sz0JaJYEnATch5TTg1RGwyYqxdfpd72SmUHegFkM2XT1i0HrJAXWngHjQ9N204oSdbTQyeCRDbkD0bBg+TwucWSI5KGYlpcJwAiLxBoTT3AAerfKTjrbQmKoyMCi3zz20q0EZnGbLnNmzNkb3UqaPAexMn+u1/1sKCsJugnk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763525294; c=relaxed/simple;
	bh=kSM7cY6ZzajcFONO2szAZjQwGwtclBZyQsxrA59ZMuM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mHzRdxVlLJJLjoliYBuz8URthMZX37GuAvATM5P4LYU2ucEOboLtwUIAXJpbq/M12gfoWI+rjOCxi32KlGVT+N8r/RKnM3pOYcJFnjVkBEUgKVorBjm7x1S1y/bAgPtrebkcGX/HB0e6IMElAbt++Oup/peFEjNxkOYDH9XrrT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=Fr+fzwqJ; arc=fail smtp.client-ip=52.103.74.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TBValU0AQaO5mpYafwwSr5Af1izY87AKkNnaO/rVGa5O5S/0zj7i1esCQNuVfzl1s2qZp+QGywYVa3UvpGYV0PWNOHPELmhbO7WxfoGxUSePqwGLO/jGBFjvb9VucKXJ/Th2ccaO9E064nlmVmRLauv2bbl0hvDoabaV2Mx+aZccWRjJKy3mWk/t3i+Jgf1jct3xECMDEKjI6lP9QeK05AScWcwJI1AIzDivoyGVdEVkwATfiNW/mc/sTIDLRDeBtxbU5H1g2yVLUipWhEYNbFzVAracJhZv03svZXg3Iz4eIYiWufhJt/NTyFRTI925uHmUQP58m3RhFxVCHfqmhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cBzyt50IjVsaeNObtcY0k6SelQZ8ACdxloBtflm79YY=;
 b=qUTX72pdS8sI0tgSfFs+4FtltSNkUR9egYWGuxvpZkUzr3RZcNnythXaPvurhVtc0tRD1YlUS+oSs5Uz4BxhpuTGghZkULf/n8CgwVSF8FVluxOmlTJMIl5w0ckbeIMrwBDM6auG6Y6VHssTLl8zVt7okPcbFQcbI7hKgry0L+F7etPiW7PsoGqQfCen98n/STOTpl2yfa8q+/cG7bDLUGJStwLiJzDDQoe5AH6dP9AQbwbsgCGOx9RmgfuVJnsn1YU8aUKiBd/A5tD2+ZPG5EA/vidaCVffGKG5qVISTtFTN+doDTXSYEfVOIi+CcaqoiO2h0uNtR371qZs46niUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBzyt50IjVsaeNObtcY0k6SelQZ8ACdxloBtflm79YY=;
 b=Fr+fzwqJ0ZHaUHXoSXgIsuVgnhAYFHdMVfP8jKP9zXeVIF/qLEQAuBZTS6634EFRuhgtj9sGXz15p0IeqxpXZ4NSNjw4KARcP9pYmLBZmYtKkwEtyhlC46ylDE34S/VpH5x9EiMURRwfqF7l5YKDMWeOuGq1n1HJZ4Ge0rPRuZWGUhXUbC84Sji1NOG+vvIZi5nLxwvS5a730Zy7rHQw+VR51gkEG2YjUR50L5f6zIEVHWGwxo3eD8bzrnaqHyMXUbkEpPWG3/kZ/ctdGQA6evzc3KhxVbOuw4tUCrA5uKbZNXAoaSMO4bFPVL0JtGge+IpfXKFyB62WYKZJJ22RfA==
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com (2603:1096:d10:5a::6)
 by PUZPR04MB6608.apcprd04.prod.outlook.com (2603:1096:301:fc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Wed, 19 Nov
 2025 04:08:03 +0000
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa]) by KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa%6]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 04:08:03 +0000
Message-ID:
 <KUZPR04MB9265F5F027802D0C0C7F429CF3D7A@KUZPR04MB9265.apcprd04.prod.outlook.com>
Date: Wed, 19 Nov 2025 12:07:55 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] RISC-V: KVM: Flush VS-stage TLB after VCPU migration
 for split two-stage TLBs
To: Hui Min Mina Chou <minachou@andestech.com>, anup@brainfault.org,
 atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 tim609@andestech.com, ben717@andestech.com, az70021@gmail.com,
 =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
References: <20251117084555.157642-1-minachou@andestech.com>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20251117084555.157642-1-minachou@andestech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TYCP286CA0269.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:455::20) To KUZPR04MB9265.apcprd04.prod.outlook.com
 (2603:1096:d10:5a::6)
X-Microsoft-Original-Message-ID:
 <20b50307-213a-486a-a2de-fd813aa03894@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KUZPR04MB9265:EE_|PUZPR04MB6608:EE_
X-MS-Office365-Filtering-Correlation-Id: b49ac32e-96d7-4b0b-bca9-08de27213c10
X-MS-Exchange-SLBlob-MailProps:
	98ioH9+sI7+gyxcU3oOsnpgf49NmJk4/jWo94n6vp1sc230NDXLZE7LaLIb/rdsZuPPzTAffhISSFZRHLewVFPtSRNzJBI1O/M2o+oI8sv+Le5QqJtHrg3oIwdH+SoiWyz/8zxKRwU90N1QrWySJpZfVUyWO2Jd2/8WHLKQ6zBTRqUA+Dze6XSoqrR9np1B3jYYCx5xuII8xWts0A8v/8N0RUyHFGfWuVMajiiuV9wrBiJ4jhYjrizg2FO01h7GOc+wa5UeEenwSn4Xh9Qs8sxB70GsS2JE16AqAWkdLj7jmyh497lp663XM8dtmkWz1XCtyRUvIYsUrdru6vwHYjU3JRH2wDvZb5xBS9nyhKkOklkUxO3gm8qXEcjv2pYW0Kljmq50KMcZJal/X3dGY6W6AnFcwK65bdJB+9NnqIrLli1rsQ4tCXvmSO2pN3LwKUB+YXvJNQ+izxpGkqULG6wa2iQxM13ZpJpG9dr8IruMOBiE/ztJTvXPjze1kbu8JXUaZnG71JPDXKQPo1hqojHyhv0kqISn7DeRrTd25+GeC9OQtjwEJ2RWIVpyXon5QxTBuKAQxtTp7HFevP6Y6t9okzXJkQ1uf/g4uGu1rSHHPD6OOtpV0RnrUjy1hdk7g5fIj1n/8e1LucyORrsgGEyWJtyRO7gI6dfuAzmr4afzkXL1w96MAZv7GJF33JT1dyQJlruoX4xIMo93gU7bb772ZjxkIZFJFOPQgqd3bAnJ0ADiCfK86Jw0EnpnAsFB8g/cNGZyT8l9PGV9jkANx+gfWYr3cbOUlxwLkpWhPa5YPTIyN0M7JiRn6zVtU73H/fdZvsCNQk3V0cgbAQlyGnYM9LMnpozpS9Ldjx7HxbKLE/Nv9iUIFVQ==
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199028|37102599003|15080799012|23021999003|19110799012|8060799015|51005399006|6090799003|5072599009|1602099012|40105399003|440099028|4302099013|3412199025|10035399007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bVN1YllXcm41WjRGRFhGRkMzdTE4bDBCelN3cVZJOUovNVZ4SFg5dUxRc082?=
 =?utf-8?B?K3lzSWJSY1EyVXRQWnZMQjBsdUV5OWFVenJOanR5Y244amZaN3E0YkE5Qk4v?=
 =?utf-8?B?QmJ4U0hDZmxVanU2eExjQi9hY3kxT0ltcnhSbUJkWml1czJuak1aYlNxVzBx?=
 =?utf-8?B?VjltTXhJWjhmTWpKbzFmNlFpN2NWRklyMTNDUzZPdjRmNHVqbnBQcDk2d2pO?=
 =?utf-8?B?WllmUFh5NkJDOEp6R0VnMTV2L0x0N0hQeXdNTWJmWkpaRFdMRjVLY25SZXd3?=
 =?utf-8?B?c1J6Q2hMbUNtbElPK3J5L2pNd1RvU0dmRUtSelVtMHVpK2g1M0U1S2drc0hP?=
 =?utf-8?B?QnNOK0xHWVU5aEtCeTdsSjEwdW9LRGQwblROVzZhaHdBdEF4a05wZUpFTXF0?=
 =?utf-8?B?bE9YU1VnT3F5S1NZOWJiTUl0dmxpL3JHeXlWSWVRRjZlZVMwNXcycTNhb0t3?=
 =?utf-8?B?ZGNSaStZMHBLYXBwZ0NJN2gxTXZaYitBS2dpTmlQV1NQckk3cWpGNndtYmVp?=
 =?utf-8?B?ZjVCTndrOTdVbjNlRkZOQ1RSVG1kSFJuemlLbnVLcE0vRG1BSzFRRTRJR3M3?=
 =?utf-8?B?eXQ0RHFrSDdxaExrRFRpOWZUeGxNUTM1cERNQmRIVTVIM3k1bm8yMEYyZnBH?=
 =?utf-8?B?eDc2K2JCeXFzemZMS3REcnZJbW9DbXgvR0xFUklUbU9WdlRDVk1idnJKbVlS?=
 =?utf-8?B?aW0rRURiSVk4M05MYUFEMUN0QXdJUTFSYkl0ZmhYdUlrYmJXK1hyRmFWRldh?=
 =?utf-8?B?dU9EdjdmWDBqdS9MSzlXTFk1QXNRWGNzT08rL21LZncrQk9DM2d5NGw1azBt?=
 =?utf-8?B?SUl6VUoxRUtBbkJiVjVnTFFTZnhkcTVTVXVOVDQ3ck9hSDVvL0grZkZHVkUz?=
 =?utf-8?B?SXdhb21JU0ZrWi9yNjNheVlZdm40cGpRblA2Qml4Y242ay9yVTFrQnk2TXVy?=
 =?utf-8?B?YW1QZ1V2UmlSRTVRamdPRzh4QnU4YURLQTlqUUdJQlhmTktNNHUwYWtSenlH?=
 =?utf-8?B?aWdWdXBTeENFdnlkNWZlWVN6dWJrK0IyTXVmazhTcW1pMGtRK21wV01sNjlH?=
 =?utf-8?B?NmNGUU05b08wNm9HaHpZRFl1cWFyUVkyMFJqT0VQTHhOdUFmQ3A2a3lGeks5?=
 =?utf-8?B?WTN2ZmhnaVhNK0Y1azNYOUc5R1RjSElyUEJUN0dQUk94MmVGd2VyR1ZvNFl0?=
 =?utf-8?B?SVB6QkduYVVvUkUzbFRydXJDbnVudlZZMEhsd2o4cTFiZG5PUUdZY1daaFJ3?=
 =?utf-8?B?TkloM29ZdmljRDQrUnV0cXRNeEZJRmRqNURWVXFoRU1vdXhIMjVtUEJQTjJH?=
 =?utf-8?B?MzgwZ2ZEbzl6R1l4dzg4YWhSdmlNRHdTbVBxY2ZkR2xhQUJ3Z01DN1duRHFz?=
 =?utf-8?B?V1pPTXVyWnBLbGV4em5rMExhT0xFV0lNMHdMTm5xV0FOaUdWOXdwU1VWK243?=
 =?utf-8?B?NFFPRGV0YVd1dzVCQ01jekc1ZTRuMFVvelI1TTR3MzNmTWw5TTlTMUZ1YTdr?=
 =?utf-8?B?SkhzZmVDajFQMDUxdGNmUjQ4LzVkVUlaOXMrMi9jQ1BYd09mWlRPeUx3cVVq?=
 =?utf-8?B?T2VpamlkU0pLS0E2T1AyWDdOdEg3QWM3UEg2SGlXY2R0Z0NqMDd3R0ZUWTZk?=
 =?utf-8?B?Zmg4VUthdU9tK3lmSkNiaFNzL0Z4RWs3SE9pT0JJalZUT1grWjVYZDJJQzVv?=
 =?utf-8?B?VTlFd1EvbDZOelBOZ1lFSFdTVmpRR1RUYXpsNjduT0hJOHhHMjBQc2RMbjZX?=
 =?utf-8?B?REhHZjFSeFlQVlB6QUR3eXl4K00vakpvSjZiK1F4K3k0c0NrYUdWc2JYUFVy?=
 =?utf-8?B?ZXRnREw0K0Rxc1FSa0NDL3ZkK0Q1Y0c4Nk0xaXFDZXM5U1pRbzJIWGwyak1z?=
 =?utf-8?Q?YDBbL4v1fQyTU?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZU40akZLdHl2alBZVzlNcGw3SUg1UnNkRXhqYmxOZ2Rad1FHME9seENycnRY?=
 =?utf-8?B?aWFaSWN1YlRmTUdORUFXMm16UTFnYUg3NDRZdkdyU1V1Wk5XeXQ3Rm9hSXBn?=
 =?utf-8?B?U1RzakE5M2hGa3hXK3pDekNkTFhzVTZDbHBqRHlBT0pwVGw4Ym9IODZXZlBO?=
 =?utf-8?B?NVZOS2J1L0tjWGdzdmZidkRZVFFCSU1uWmlsVThEdGR0dVdKK1BpczNjT0pR?=
 =?utf-8?B?T0lZNm0ya1NPWExvZ0JyWFN5RmZQWmk0aWxScUJUYXluM3pHS3NzdXEzdmhI?=
 =?utf-8?B?WTZLUlVlOTlZd3RGZU9BbmJmcDBBYTNCZkxuR0s5NmxBMktmem5jUUN5MVU3?=
 =?utf-8?B?RGpKbkNWVmcvaUNWQkxtNGhIR210U0JLN3dkMXVKcXEzeTFVQTdyaUVNU3Yy?=
 =?utf-8?B?WDNBb2dFSzZMbENoMUVMU0RnejlwaisvanBrYXN4VWcxOEswbnZjREE4eGww?=
 =?utf-8?B?WVZKbGM4QytLdG14V2Zlcm02eHlsMFU1RlNocDVtOTFlRkVVRTFSMFVNSDR4?=
 =?utf-8?B?dm8ya1FFRkJOSGR3MWNhZzBmK0ZCMDRzZ2xlOW4yTlJGQTZlTjFhWnA3T05M?=
 =?utf-8?B?Mk8xbVQvZHU3VlorNFNZbUJaUXl0eHFwTjljQzkvOWZNbEFaajdEL3BqZ2dK?=
 =?utf-8?B?UDhHUDZlSmhxOUJFZG5BSUpCdTZZem9pUk9pc0JEZk1GR0s4QmhCejVxTlR2?=
 =?utf-8?B?L29zaE5iKzRaSW9nMmpLcmxvUTVIdnlabDN0N0c1elRJaXFuK3VPRklJRklK?=
 =?utf-8?B?UmE0MnNldlpoMXM1c1dVYTN6VEhpbmV0M0Qzd0NHNzZ0WmZCR0YxS2EwaEVo?=
 =?utf-8?B?QnM1ZDV5K0ticUtldyt2b1ZxRG1GeTVGM2xVWmsvOXBDNnByYTlXQ0kzSEh6?=
 =?utf-8?B?TUdpaDNUcXhSb2xKckR5bEg1YndKK1M5K3hSZ0lENm5RQWdsOXVvMWhneXVx?=
 =?utf-8?B?QUhycnJoUTYwM3JwVHFlNUVrUjNGc1l4RjkyZFNKa1IzMkRxaVVLOStCa1Fp?=
 =?utf-8?B?V0N1WG4yV3kvTHFZMTVkNDN5Wmd6MTI4Zmtxc0J0YXVyeDNJZ1JpOTgxYVZu?=
 =?utf-8?B?Wmh2Nkd0YjhaZzI5S1NlVkd0RU5Pdmw0c05LdDNzZ3RRS3RCVy9KY3pSa3Bq?=
 =?utf-8?B?U2VxaDFpV2s2WjFrd3lOeWNaNFRYS1pRZS92bWdhdFdFcCtXUkF4Rkl1RTRD?=
 =?utf-8?B?RTJGbnRCSVJRUktCVXVQbGtTYVc0L05kOG13bG1ZN2J0a2NGSHdCKzhGMDhk?=
 =?utf-8?B?Mlk2NytxUzNrdklmbnpmQmNoMDVsazh4eEphVnl4WTBSNUFoaHBkUmtrTlpQ?=
 =?utf-8?B?Nkw5TFp2V21zUFd6WXRsU1Zma3RMSWwyODZDZVZzREZ6VC9YQjlRbTJqUjdB?=
 =?utf-8?B?YnA4Qlk2TWd3blhNbHZBVzl6TFdralJqRDBEcDFzdnRtVzV6RFZnQVJZaTdp?=
 =?utf-8?B?SU5NZFBuaDZpOFRFam9wZEtiMTJaVWRudGVnbFpIR1h3dHl1OGVpOVBhZ0pK?=
 =?utf-8?B?M2pQS3JWVFhDU0dCbXpmRm1hbEdmRncySitVbXNqcWFKR25wSUs3d0lkOU85?=
 =?utf-8?B?VlBMN2h2NDhoTUR5VksyNnExQ3F3dXdnWStwVUZMK3FaMUwwUGtwS1hrK0lP?=
 =?utf-8?Q?ocq+8fo70DgJL9E3jZ2bC0Zxa+lKz9JEIUtMsFXPj4LI=3D?=
X-OriginatorOrg: sct-15-20-9052-0-msonline-outlook-38779.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: b49ac32e-96d7-4b0b-bca9-08de27213c10
X-MS-Exchange-CrossTenant-AuthSource: KUZPR04MB9265.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 04:08:03.3828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR04MB6608

On 11/17/2025 4:45 PM, Hui Min Mina Chou wrote:
> Most implementations cache the combined result of two-stage
> translation, but some, like Andes cores, use split TLBs that
> store VS-stage and G-stage entries separately.
>
> On such systems, when a VCPU migrates to another CPU, an additional
> HFENCE.VVMA is required to avoid using stale VS-stage entries, which
> could otherwise cause guest faults.
>
> Introduce a static key to identify CPUs with split two-stage TLBs.
> When enabled, KVM issues an extra HFENCE.VVMA on VCPU migration to
> prevent stale VS-stage mappings.
>
> Signed-off-by: Hui Min Mina Chou <minachou@andestech.com>
> Signed-off-by: Ben Zong-You Xie <ben717@andestech.com>
> Reviewed-by: Radim Krčmář <rkrcmar@ventanamicro.com>
> ---
> Changelog:
>
> v4:
>   - Rename the patch subject
>   - Remove the Fixes tag
>   - Add a static key so that HFENCE.VVMA is issued only on CPUs with
>     split two-stage TLBs
>   - Add kvm_riscv_setup_vendor_features() to detect mvendorid/marchid
>     and enable the key when required
>
> v3:
>   - Resolved build warning; updated header declaration and call side to
>     kvm_riscv_local_tlb_sanitize
>   - Add Radim Krčmář's Reviewed-by tag
>   (https://lore.kernel.org/all/20251023032517.2527193-1-minachou@andestech.com/)
>
> v2:
>   - Updated Fixes commit to 92e450507d56
>   - Renamed function to kvm_riscv_local_tlb_sanitize
>   (https://lore.kernel.org/all/20251021083105.4029305-1-minachou@andestech.com/)
> ---
>   arch/riscv/include/asm/kvm_host.h |  2 ++
>   arch/riscv/include/asm/kvm_vmid.h |  2 +-
>   arch/riscv/kvm/main.c             | 14 ++++++++++++++
>   arch/riscv/kvm/vcpu.c             |  2 +-
>   arch/riscv/kvm/vmid.c             |  6 +++++-
>   5 files changed, 23 insertions(+), 3 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index d71d3299a335..21abac2f804e 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -323,4 +323,6 @@ bool kvm_riscv_vcpu_stopped(struct kvm_vcpu *vcpu);
>   
>   void kvm_riscv_vcpu_record_steal_time(struct kvm_vcpu *vcpu);
>   
> +DECLARE_STATIC_KEY_FALSE(kvm_riscv_tlb_split_mode);
> +
>   #endif /* __RISCV_KVM_HOST_H__ */
> diff --git a/arch/riscv/include/asm/kvm_vmid.h b/arch/riscv/include/asm/kvm_vmid.h
> index ab98e1434fb7..75fb6e872ccd 100644
> --- a/arch/riscv/include/asm/kvm_vmid.h
> +++ b/arch/riscv/include/asm/kvm_vmid.h
> @@ -22,6 +22,6 @@ unsigned long kvm_riscv_gstage_vmid_bits(void);
>   int kvm_riscv_gstage_vmid_init(struct kvm *kvm);
>   bool kvm_riscv_gstage_vmid_ver_changed(struct kvm_vmid *vmid);
>   void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu);
> -void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu);
> +void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu);
>   
>   #endif
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index 67c876de74ef..bf0e4f1abe0f 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -15,6 +15,18 @@
>   #include <asm/kvm_nacl.h>
>   #include <asm/sbi.h>
>   
> +DEFINE_STATIC_KEY_FALSE(kvm_riscv_tlb_split_mode);
> +
> +static void kvm_riscv_setup_vendor_features(void)
> +{
> +	/* Andes AX66: split two-stage TLBs */
> +	if (riscv_cached_mvendorid(0) == ANDES_VENDOR_ID &&
> +	    (riscv_cached_marchid(0) & 0xFFFF) == 0x8A66) {
How about to define a macro like 'ANDES_ARCH_ID' instead of '0x8A66' 
(like 'ANDES_VENDOR_ID') ?

Otherwise,
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty
> +		static_branch_enable(&kvm_riscv_tlb_split_mode);
> +		kvm_info("using split two-stage TLBs requiring extra HFENCE.VVMA\n");
> +	}
> +}
> +
>   long kvm_arch_dev_ioctl(struct file *filp,
>   			unsigned int ioctl, unsigned long arg)
>   {
> @@ -159,6 +171,8 @@ static int __init riscv_kvm_init(void)
>   		kvm_info("AIA available with %d guest external interrupts\n",
>   			 kvm_riscv_aia_nr_hgei);
>   
> +	kvm_riscv_setup_vendor_features();
> +
>   	kvm_register_perf_callbacks(NULL);
>   
>   	rc = kvm_init(sizeof(struct kvm_vcpu), 0, THIS_MODULE);
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 3ebcfffaa978..796218e4a462 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -968,7 +968,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   		 * Note: This should be done after G-stage VMID has been
>   		 * updated using kvm_riscv_gstage_vmid_ver_changed()
>   		 */
> -		kvm_riscv_gstage_vmid_sanitize(vcpu);
> +		kvm_riscv_local_tlb_sanitize(vcpu);
>   
>   		trace_kvm_entry(vcpu);
>   
> diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> index 3b426c800480..1dbd50c67a88 100644
> --- a/arch/riscv/kvm/vmid.c
> +++ b/arch/riscv/kvm/vmid.c
> @@ -125,7 +125,7 @@ void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu)
>   		kvm_make_request(KVM_REQ_UPDATE_HGATP, v);
>   }
>   
> -void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu)
> +void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)
>   {
>   	unsigned long vmid;
>   
> @@ -146,4 +146,8 @@ void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu)
>   
>   	vmid = READ_ONCE(vcpu->kvm->arch.vmid.vmid);
>   	kvm_riscv_local_hfence_gvma_vmid_all(vmid);
> +
> +	/* For split TLB designs, flush VS-stage entries also */
> +	if (static_branch_unlikely(&kvm_riscv_tlb_split_mode))
> +		kvm_riscv_local_hfence_vvma_all(vmid);
>   }

