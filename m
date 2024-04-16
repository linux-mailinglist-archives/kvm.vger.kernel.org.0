Return-Path: <kvm+bounces-14764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 08DD38A6B5E
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 14:44:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63D10B22056
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 12:44:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CDFB12BF02;
	Tue, 16 Apr 2024 12:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b="IycdZ+eJ"
X-Original-To: kvm@vger.kernel.org
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (mail-be0deu01on2100.outbound.protection.outlook.com [40.107.127.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837A4128398
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 12:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.127.100
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713271458; cv=fail; b=nF+5gS02VlowvE1yEAdMInQWtaLbenT1b3B2OjvtwjLGCDN2xNA5st+K4Pz4OunjTT7HNFY42Jx8r0m0WldgZKn8ZE/+VKDZTpzEV0IQ23AWJcKTMTzznEnjpdZziRtdssSj8gMGvMl6YTHAktdDuruGiddcmBhsc7EzrnHnxuU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713271458; c=relaxed/simple;
	bh=nFSw4EhZOPBbrESykFUSh43x4xlvvfWguGoXIrWIrO8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d+hdlhnxZRFFOxtNf0z/QaAYxBuLsmHGWYhLBG3DGTYlHxjwuhHfM4z81Xu5rG8ZPEWlrZPgMhhExcR3nWyn3JqohInkX0XgNPO1sOlE5lsNVQyCliYzrUaqFploUG+VUoFvC3i9h0T91D61rfObr4JXIfh/c9QTwtAPWAjQ68w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de; spf=pass smtp.mailfrom=cyberus-technology.de; dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b=IycdZ+eJ; arc=fail smtp.client-ip=40.107.127.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyberus-technology.de
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SdDGTKKPvjCBIgbvvBXibUwhAwAEvth1cShibZx0iox+H+vxMQDFEfuEiy7CipQKxgktCMswbiMqy3Fs0Le6QXpNxISnsrXeVlzNqsgVsGriNSZlpVYJXzhM9D07ipvOwTO/eJrikSHSJpfFQb5n6rMnXD1mx5al54Po5l04H7c1BVS7/XKp68dFNSxbrwI4tSUtcXE7b4AEsYIuPrQGyoAm8tfUcBcYn3p7tg0c5Rks5gLNGtVvfbKei2/Qc/Ii+LGSZG4pXnd03M+lRSW0EV2bb2BauRs4p0TPgMcjtdwIisX79ZEAJud8QUWUVlpsFNYt8wyVVLt/I6YSQPv4Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nFSw4EhZOPBbrESykFUSh43x4xlvvfWguGoXIrWIrO8=;
 b=G8ZHUxixOh/snTOP6nyEHwB1uULubtdoS6ViqWk+RgJbsS4J2FKu80y6QmO/6J+2Jh3orGSzMdD4+UKVxhA2xdFs1q9IZot4CMxBtgL7e/EzETbwqzEN68Z4z1gy/GvWPDeePb9k3zkQbqCiluWJI/fxDfLHgZzshdvPQIU0iOYSQM0pXAVV+njewo4rGVC9PF2hiLBo9y9iGOhERNy1VpMF/nGSijSRwxNeX8esak8Bjgo0mOVzNSb/GEpCVlMU3oy2UHPuxIaceM7xPdrVtFqufUqFZ9EvgCiYEUF5ZtyF3aa+NPUZyw9RhuDA/thrba24y3G7/Jlf2XQlwlqG5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFSw4EhZOPBbrESykFUSh43x4xlvvfWguGoXIrWIrO8=;
 b=IycdZ+eJCxxejd4xNXTQYJl+oqu70cBTMJ3JTJt/FeD+AsMAFZ4wSHXSNZexuY9dryskB6fmXfGt85kaLrMKI00xNnTiubmdwbOFGMfSihvV969ZXs1HHQ0xRpSSN/4kNhpwjqMP29n9toHEu29deb8Gib8zPbnqzihRlqgezRo+KkEnZuui+gwrfjIVV3ttGJ6DwrxiVo+Vx04ZOK38NyM5+EwRpOJcEQzX40yWvgjWsd/mSAWbX/o3sYGSopqXNxHtdxcy57nnZhTpdO80so7B3P007zbhUkSWzh08aMlx1HtbQKk/OEroveY/wk3BfByMtWPjjL7NEGh7Gt+2Lg==
Received: from FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:38::7) by
 FR5P281MB4056.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:106::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.50; Tue, 16 Apr 2024 12:44:13 +0000
Received: from FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 ([fe80::cd58:a187:5d01:55f5]) by FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 ([fe80::cd58:a187:5d01:55f5%6]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 12:44:13 +0000
From: Julian Stecklina <julian.stecklina@cyberus-technology.de>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Thomas Prescher
	<thomas.prescher@cyberus-technology.de>
Subject: Re: Timer Signals vs KVM
Thread-Topic: Timer Signals vs KVM
Thread-Index: AQHagE068r/MPqfdwUiSZ7JW+AmgHbFUBZKAgBbxZAA=
Date: Tue, 16 Apr 2024 12:44:13 +0000
Message-ID:
 <af2ede328efee9dc3761333bd47648ee6f752686.camel@cyberus-technology.de>
References:
 <acb3fe5acbfe3e126fba5ce16b708e0ea1a9adc9.camel@cyberus-technology.de>
	 <Zgszp5wvxGtu2YHS@google.com>
In-Reply-To: <Zgszp5wvxGtu2YHS@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyberus-technology.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FR2P281MB2329:EE_|FR5P281MB4056:EE_
x-ms-office365-filtering-correlation-id: 21261803-a4da-495b-e129-08dc5e12eb70
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 =?utf-8?B?eGNMcXFaVWs5akI2WmdTSG9zQy9odkl4ZXg3eXg5SVRzNmwzSlh2S3RZWXlB?=
 =?utf-8?B?UHJVMlJUYi9MNmpIdXVQclZzb3ZDR0YxZzNNcE9paHQza2RTd2RvdHBQbyt2?=
 =?utf-8?B?STlnQWlBQ0tRNC8wMFBLWm9kVExqSGhyZXVZeHNCWEtLUkI2QW56QlVEQ0tj?=
 =?utf-8?B?RmNyWERjSVpWM05CZkl1UlpJS2hhV2hBUHVTTzBvdUx3SjZMcVFnWlY1S0I4?=
 =?utf-8?B?WHBSZU9PL3IvYXRxZzNOSjB0dDMwL3RETHRvNUIzL3ZIN3liUWVtMkVrYlIx?=
 =?utf-8?B?VmxFWDhKVVVzYTlDbG9TT2NEaUdhZUxSNWhzcVlRY0V5bUJCaTRXTUIySWxI?=
 =?utf-8?B?eGlpdTR1ZmRpT1JyQzYzRi9TUUR1SzNmZ2lobGdXYXMzRWpxSkU0eXlYT0Mx?=
 =?utf-8?B?NE5mVHVIN0ZuQjA5UzZUNlVYa2M2N2NrbDA4WkJQVmE5cDF4d3BvMXFPNXlx?=
 =?utf-8?B?OW1ZMythWGdtYXF0WGdKNFZZSGxMOXlMbzZ3VTlLSEJEUmtZSGpOVWhpTEJ3?=
 =?utf-8?B?bkNGWnRoY1V4dTFLaStKcnNyZDRCajRpQkZhOVdVeDRZMTVIWG1WbWYxc0xV?=
 =?utf-8?B?RDB4ZGlLMFhCTWNvbzEyUlJYbXRkaVYvamY5Y01Ua0NvNFg3anhFZDdwa25m?=
 =?utf-8?B?UWlsUXJJMGt0YkJqcCs2eDhwOWNoanYvcmNuck9DbS9qQXY2UDA0VDFETXgy?=
 =?utf-8?B?R2pUSUFVY2FXdEsrZmQ5bWdsbWt4VEZROUhBWEFmWEN3cGduYytzZ3YydkxX?=
 =?utf-8?B?UEljbllwYXdjMEFGa0NtWjNiQ3Brby9GL01yZlpIZUU4R1BNYVIwYm5nblpw?=
 =?utf-8?B?QXNLR3JrQW9rclVrRWlvRzU1eEFIRXE3SmFXOFpmeGZxVVJOZm12SGdFM1l0?=
 =?utf-8?B?dGRpTmMwZDdjLzRCZFNSalNzUGZjRFZwRERsbW9NTzJxU0FsdlJSNVV2NHlo?=
 =?utf-8?B?R2lwL00yUGoyTUNEOCs0NnN1NDUwb3ZYSzJ6WkdaZkwvaEhXb3hnR1ZuTmd1?=
 =?utf-8?B?RjczWHNLNW5MY3U3T3QrT0tuRjBhWDRHc1FlNVRTNEtFVDlNS2orVVNBZkFM?=
 =?utf-8?B?eVBCWVlJdzk3TGhxcXdjVjRQZG5qMlN3RGJ2Yk1LREtUVVd1d0ZlMVRYV05K?=
 =?utf-8?B?N2J4bDVmM28xVHFZSVlua0NEV3lSbDBPUGVEemloTjVTRGpFRXpCVkoxaEtQ?=
 =?utf-8?B?K3I4OTd2QkEzQUlTK1FXeXFQSFpvVCt2WUJiNW52aDRVZW92UHpJekVHbCt2?=
 =?utf-8?B?azM0eWZ1NjZJVlViYzc0L0R0cDBTdS93Y1B0WmlRbWVMcTN6dklad3VRbmhE?=
 =?utf-8?B?YmplcXJVMk5NOGI3bUxEUk1wZG95WHdwdmVPc1JqWjRDbHRFR1ozenN6V3ZI?=
 =?utf-8?B?b2ZhNEdFUHpjOHpha21CWWkwUGxPUEhBTmNLQ2VJTjZpMjFpMGRkcWxRZ2pq?=
 =?utf-8?B?enhhWk1FNXFldTBxS2VTVDM2SmM1M0RVQ21EWW91eFhvUXUvVGZ6SEJMYkZF?=
 =?utf-8?B?Yk0xWU1jdjJyb2dONzNyTW16SFNhSDFoNC8vZFg5UWJOTk1KdnppL0dPeU9E?=
 =?utf-8?B?OEREWUtEWFJ2bU9IblJGTFZLbjZWUmJldzRXTFFRckI4eHV4WWswMHlMd04r?=
 =?utf-8?B?TEtJcExDSTNScFhjMFF4aVZoOHJzaDM0WWUxSjAyb2s1NjdrcndIR25ZOFBB?=
 =?utf-8?B?LzNDUmdTeDNXTVVyWXFZcVNXWVlGNHltUFVtZmRVa0pBYmNBV2VvMThRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QTNnSzhlc1hMZVgvbnlrc0dlMFRGMHhTUkRBdzY0eENCK09vMVpySFFyNlRM?=
 =?utf-8?B?YTNFVEtrRnA5Z3hsQld6aDFXMmFUUldGOEVwUzlyanJEUUw1V1hFT1pOODRp?=
 =?utf-8?B?UUFRZnZ2ZXhndzFVSHROVEsvbjh2SmMzQndKclZPbDJsTmlIdmFrOHBOMDBr?=
 =?utf-8?B?YnRna0VMMGk3Zi83SGc1MWNIUy8rV3JKb0lpaVBPU1ErdFlUWHBWVGpxS2lW?=
 =?utf-8?B?SVNzMkZZOEdBeXpObm9UcmtaRjZwb0pGb09OelBmdWo0WUhGb3k4K1dpUWxS?=
 =?utf-8?B?M0prUXoxVHg1eXc3THB2UHVpZE1XaFVOMHJmWDNBV0t6RE5zMFkxK2hTc3Fs?=
 =?utf-8?B?ZlN1REsyOUNqOW91ZVBMNVQwcHY5MTFoUGJkbnpQUWlCNXFSeVV0RmhlSkpk?=
 =?utf-8?B?cWNRWnJvYVA4ekoyeXViejNnVEJkNmtIZG5nbGl3TFJ4RzlRdmo0MzE0dWNw?=
 =?utf-8?B?akN3ajBaQmVQWDJrR1dzY0QwOUQ2RTBPY2d1VkF2dFZ2cUZZUElnVzVpQ0NH?=
 =?utf-8?B?YjlyOWZ5Mlo4VEJ2Unk0eUNFckt6WGl4cXlnaHVuVW1tOHhzR1Nja0dFT1Vk?=
 =?utf-8?B?YVZsN2U2VEVNbFJZRHhxMjFzTlhIKzI1RFZ0TWJHREtKMXR4UXJkV3V1b3Vu?=
 =?utf-8?B?RVlTWVJaRXJVK2s4ZlE3ZWdUYmptME95TDV6RWFqMXNJckd6dXNwWEUrN3Er?=
 =?utf-8?B?UWl1aFh5S29MbjhiUC9laVhPMUwrMFBPVWxYZkhleFBDS2RVOUx4STZRRlBG?=
 =?utf-8?B?SElrQjVoOGpJZThnR3B5ekRkTDh0UHQ1NEtzcE1GMFRJRUdLc2tkLzJyMGht?=
 =?utf-8?B?K3d5cFltK29wNVp4YmZPZStKeGtoaXM2cmNqRG9BQ0pLV2NNeUFsbE03Kzhz?=
 =?utf-8?B?Q2VWRyttcU01RTdFSjhCQi9qL1RTdE42YmhBRzIzSzd3RlZrdHdMVFk0dnBh?=
 =?utf-8?B?eDBHNFVnSWMvcDQzTTQyTlRHUkxHT2VEV3c2NTByTEVhekJrcUxjeWJ0TUJN?=
 =?utf-8?B?Z0RzNmF3RHI5Nk1GbFNCSGtrTDBwaEdsZmJqV0t0OVJZT3hkRGRTNUNVcmlp?=
 =?utf-8?B?TUVqRXVXdGxkaXJYNUZKMDRrM3FhNm9OVVBzWUNnYVVxY2hLKy9ER2UzelpF?=
 =?utf-8?B?Q0drU2N3VUNIUEF2SFpMamRVMXhlT2pzbnpaTUIxejRjdmlGT0c1TEJkejBT?=
 =?utf-8?B?bm1wWkxObW1rM0xvelhlQ2FuK205SkR4Uk9qMHU5TWV2T1ZaREE0ZnN4OG8x?=
 =?utf-8?B?U0tIa2l5a205Um4xQ0t3VGd3VnNwV2E3ODlMSG5BamVieEg0cDhySVY3QTN4?=
 =?utf-8?B?TFdlcGNaazBEckNheUVCMmZvNmtjeEQ2YW8zaFNCSU1ZV0RsNDZ1bDRraDRv?=
 =?utf-8?B?azhqS1kyQm9kVEpCV0ttNDM5QnJuWCszU0gwZEhXYXpHR0liSExmY2JwRzRH?=
 =?utf-8?B?ajZHRThjN0lTWWVyNEVFOGR4WGc2Z1BqWVVJWWVaYS93RkxnOVVmL2lpQVFy?=
 =?utf-8?B?UjhaQ20ybndTbEJYeWhRU1dCVVcvVVdCWE1ESkl3UVk1Q2ZaMFRVSG5mcm90?=
 =?utf-8?B?T2FObkhqa203ZmJnalRkbFZGd3BiVU5UTW1PMUFYTEJXMllxTjhObEpWdUNU?=
 =?utf-8?B?K0Q2cUhwbWY5bnp2UGI2Y3ViUjZVTHBid1RodDJ3cmRCUjdiblNKR0wwUmNh?=
 =?utf-8?B?OWJjSzFWa01zOWtMNForUkE0SGd2Nlh5VGxMblRIeFlHNGxLd1NSQ1FpSDlY?=
 =?utf-8?B?bkFpM1RUSk5uSENLY0FQUDJjY2pUbVo1VTBTT2N6c3VBUmNNM3FYVmpqZlpR?=
 =?utf-8?B?alRrWDBOVjVRUXlXWEJMNy9RS05TSkVEZnNCenlYUGNVK0lJNUhDclhzenQ4?=
 =?utf-8?B?UnU1aFBGUnRjdWtXcHlGckJQT3M4Tzg1Nk1XeC9CVnpPUEt4NHcwcHZjQWVZ?=
 =?utf-8?B?RVhDSmorZnlJWm9KMkR4OWx2WTlDUys4UERPbU4wY1VRYTErQ3c0aVRFZmJ2?=
 =?utf-8?B?bTRIWUVDa3NGS2ZJTXdTMUJmY1lOanM4R05wQmQ1dFgyb0dDZjluTUJxVjRy?=
 =?utf-8?B?eWthbW9kenREWFhxYStueVF2L3lmODJERTZDV1lsZmYyc3ptOVNDRjJLQi9l?=
 =?utf-8?B?NXZ6VHAyL1JSVkFTOXJCcThHWVFrdkRmQnBOZmNaVExpR1h6YkNvZjY0d25X?=
 =?utf-8?Q?sGVJ6dgn3c4mR048K3TbxccvmYqNwbLC4kKjkQwixPbd?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <88F875BF29FC8D44B78B8FBF09A6F0EF@DEUP281.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cyberus-technology.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 21261803-a4da-495b-e129-08dc5e12eb70
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 12:44:13.1853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cPGrkLEtqUyHD8Upp4T8pOrluOewqmgaZUfC93CU4XzzQIMkLeZ8JJwGIhfcJKDyCk+08wx8Rj9w9BSt7gPqUJpOSiLr60EyHyk5p7YIUgNxiHjlcw2/T2TrV9wGOJHl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR5P281MB4056

T24gTW9uLCAyMDI0LTA0LTAxIGF0IDE1OjIyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIE1hciAyNywgMjAyNCwgSnVsaWFuIFN0ZWNrbGluYSB3cm90ZToNCj4g
DQo+ID4gDQo+ID4gV2hlbiB3ZSBlbmFibGUgbmVzdGVkIHZpcnR1YWxpemF0aW9uLCB3ZSBzZWUg
d2hhdCBsb29rcyBsaWtlIGNvcnJ1cHRpb24gaW4NCj4gPiB0aGUNCj4gPiBuZXN0ZWQgZ3Vlc3Qu
IFRoZSBndWVzdCB0cmlwcyBvdmVyIGV4Y2VwdGlvbnMgdGhhdCBzaG91bGRuJ3QgYmUgdGhlcmUu
IFdlDQo+ID4gYXJlDQo+ID4gY3VycmVudGx5IGRlYnVnZ2luZyB0aGlzIHRvIGZpbmQgb3V0IGRl
dGFpbHMsIGJ1dCB0aGUgc2V0dXAgaXMgcHJldHR5DQo+ID4gcGFpbmZ1bA0KPiA+IGFuZCBpdCB3
aWxsIHRha2UgYSBiaXQuIElmIHdlIGRpc2FibGUgdGhlIHRpbWVyIHNpZ25hbHMsIHRoaXMgaXNz
dWUgZ29lcw0KPiA+IGF3YXkNCj4gPiAoYXQgdGhlIGNvc3Qgb2YgYnJva2VuIFZCb3ggdGltZXJz
IG9idmlvdXNseS4uLikuwqAgVGhpcyBpcyB3ZWlyZCBhbmQgaGFzDQo+ID4gbGVmdCB1cw0KPiA+
IHdvbmRlcmluZywgd2hldGhlciB0aGVyZSBtaWdodCBiZSBzb21ldGhpbmcgYnJva2VuIHdpdGgg
c2lnbmFscyBpbiB0aGlzDQo+ID4gc2NlbmFyaW8sIGVzcGVjaWFsbHkgc2luY2Ugbm9uZSBvZiB0
aGUgb3RoZXIgVk1NcyB1c2VzIHRoaXMgbWV0aG9kLg0KPiANCj4gSXQncyBjZXJ0YWlubHkgcG9z
c2libGUgdGhlcmUncyBhIGtlcm5lbCBidWcsIGJ1dCBpdCdzIHByb2JhYmx5IG1vcmUgbGlrZWx5
IGENCj4gcHJvYmxlbSBpbiB5b3VyIHVzZXJzcGFjZS7CoCBRRU1VIChhbmQgb3RoZXJzIFZNTXMp
IGRvIHVzZSBzaWduYWxzIHRvIGludGVycnVwdA0KPiB2Q1BVcywgZS5nLiB0byB0YWtlIGNvbnRy
b2wgZm9yIGxpdmUgbWlncmF0aW9uLsKgIFRoYXQncyBvYnZpb3VzbHkgZGlmZmVyZW50DQo+IHRo
YW4NCj4gd2hhdCB5b3UncmUgZG9pbmcsIGFuZCB3aWxsIGhhdmUgb3JkZXJzIG9mIG1hZ25pdHVk
ZSBsb3dlciB2b2x1bWUgb2Ygc2lnbmFscw0KPiBpbg0KPiBuZXN0ZWQgZ3Vlc3RzLCBidXQgdGhl
IGVmZmVjdGl2ZSBjb3ZlcmFnZSBpc24ndCAiemVybyIuDQoNCkFmdGVyIHNvbWUgd2Vla3Mgb2Yg
YnVnIGh1bnRpbmcsIG15IGNvbGxlYWd1ZSBUaG9tYXMgaGFzIGZvdW5kIHRoZSBpc3N1ZSBhbmQg
d2UNCnBvc3RlZCBhIHBhdGNoOg0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vMjAyNDA0
MTYxMjM1NTguMjEyMDQwLTEtanVsaWFuLnN0ZWNrbGluYUBjeWJlcnVzLXRlY2hub2xvZ3kuZGUv
VC8jdA0KDQpHaXZlbiB0aGUgY29tcGxleGl0eSBvZiB0aGUgbmVzdGluZyBjb2RlLCB3ZSdyZSBu
b3QgZW50aXJlbHkgc3VyZSB3aGV0aGVyIHRoaXMNCmlzIHRoZSBiZXN0IHdheSBvZiBmaXhpbmcg
dGhpcywgdGhvdWdoLg0KDQpCdXQgd2l0aCB0aGlzIHBhdGNoIHdlIGNhbiBydW4gdVhlbiAoYXMg
dXNlZCBieSBIUCBTdXJlIENsaWNrIGFrYSBCcm9taXVtKQ0KaW5zaWRlIG9mIFZpcnR1YWxCb3gu
IEl0IGFsc28gZml4ZXMgdGhlIG90aGVyIG5lc3RpbmcgcHJvYmxlbXMgd2Ugc2F3IHdpdGgNClZC
b3gvS1ZNIQ0KDQpUaGUgcmVhc29uIHdoeSB0aGlzIHRyaWdnZXJzIGluIFZpcnR1YWxCb3ggYW5k
IG5vdCBpbiBRZW11IGlzIHRoYXQgdGhlcmUgYXJlDQpjYXNlcyB3aGVyZSBWaXJ0dWFsQm94IG1h
cmtzIENSNCBkaXJ0eSBldmVuIHRob3VnaCBpdCBoYXNuJ3QgY2hhbmdlZC4NCg0KVGhhbmtzLA0K
DQpKdWxpYW4NCg==

