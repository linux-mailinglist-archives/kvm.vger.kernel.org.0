Return-Path: <kvm+bounces-23320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1042A948B0A
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 10:18:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF6B21C22785
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 08:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D6AB1BD00D;
	Tue,  6 Aug 2024 08:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FG11IDgj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2074.outbound.protection.outlook.com [40.107.101.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC0B5464E;
	Tue,  6 Aug 2024 08:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722932294; cv=fail; b=cqlVeRtWdY+1NsM3cPCa2tE/1dObL6Y9KZsbix5GrJwHi92qzqkuTHrfBUTAl+1SHmiaTNmOBeTGQSbr6hfEWcQTqTlQhaeP0BR5XKu1fih0IMIpaNccgqr7GMShywzNF6fczhD63LtDekqYAQk9LbzE7KjvhymRECizqL6yXnI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722932294; c=relaxed/simple;
	bh=/IDCvvhtKMiUIND0XN5p3reetfRuasG0y98Nv9BQjYg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hpC/74xGaO9aC/i7bmjhhu82HV+2N0V9V6qXzilCJZGNe3VrwV09Ut8bwSCFSR1CyjBT89J7e31qlFtbyud48l4ASFqXonCITj+LesmXvNpm/1aAYWiZ4oDEzIZ/DmrNgh8njwqUoRjuT2rcW92Zq47oAviDOI/rzsYXBgaAH+k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FG11IDgj; arc=fail smtp.client-ip=40.107.101.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TteWGAqCyoRRyTTjuxr4JfJymE2K+odPlvk4SPKpT4k3eASwIlRQw/kM9LqNXow4LVXk9wH1mMMlY7lnBZ5STt5yXaS+bhCHt09nj4RIshVpW2IXcyKSdnuRymWNzaxY7+j/0/nzFKdv9RVhVBQjqvGXS38FwzKBbSNZRE84liZYi8UU4PAQcDZYQeiY6rNpHXbe1s7PPrFv+YTySRhQVksb0gXcjFam0rIg50UgJGIYc8yvE3KPNbUxJVf1fc1P+m8+NYRWs96L8WskwC+BPsy/GmnjouVsIRp92v3uWs394f0c4Q0APApVrHK724nY9qRrAoQHqc+7boANDxFsqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cmL7shNahY5xrmbaRksm5VWH5mbrRZMpxHUILcKUz8g=;
 b=t/GzBwbRwH5uD6ZJIC+9hCoqnmHkyH61wJ044JimjA9J8PN3OQ2Y60VeY95cVdBg9z/3swdcQzth7MDKerVv0PDcd0Emy5UGVjhPUGLaZsrptrtkDpaPAMNA8Wt8o5RHCN1sElfD1nSxwZrwEk4K4qtHgBqzZ/leIPih1BqtHzSV5rWfKQTw5RK7jxu8jGIQKGWKpZzA8GyNXaj7d7rOp1nysjqsToCQyUwfNGRajKL6C697vbqhvRaIbsG2SSeB2onXB4Vj9Hyya91pNV0nS3orkooyINWn3qvhrxfvcGR7k1IOMla8hjJf+xX3R2xrHIueDuaJ3EZ7rXoHJex6JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmL7shNahY5xrmbaRksm5VWH5mbrRZMpxHUILcKUz8g=;
 b=FG11IDgjvaLIS94RXU66CuWU9iG0Amk5O9zX4nHsFBUwz3H0/CLtM28i+84jJGnErH8vnUbm8ylPF7xukJNYa/M6oZW0XSwiPvFZTnRD/17oEa0WieU4GYqAmdEyA8SwmJOHR1XoiCYHNxCrX/iobXdJnTsBSAV3SXyVSh95IdF7nY8gB4BGu9ROcFvltSl+NohjbYYTyieNsJ2ytUsewN/GVESv9cP7VNjrtErXDbaIfEqam6s+7rPwwjKwtbOVK4SbZ1pc9UId8M0xNPx4r7lnq3GqAIDR1sP2CRSq0SVqE6OrxvYEooY3QsKv0AtaTqv2OQ3C60mrnL8fmH8hhQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18)
 by SJ2PR12MB8133.namprd12.prod.outlook.com (2603:10b6:a03:4af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Tue, 6 Aug
 2024 08:18:09 +0000
Received: from CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4]) by CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4%7]) with mapi id 15.20.7828.023; Tue, 6 Aug 2024
 08:18:09 +0000
Message-ID: <b603ff51-88d6-4066-aafa-64a60335db37@nvidia.com>
Date: Tue, 6 Aug 2024 10:18:05 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH vhost] vhost-vdpa: Fix invalid irq bypass unregister
To: Jason Wang <jasowang@redhat.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "mst@redhat.com" <mst@redhat.com>, "eperezma@redhat.com"
 <eperezma@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240801153722.191797-2-dtatulea@nvidia.com>
 <CACGkMEutqWK+N+yddiTsnVW+ZDwyM+EV-gYC8WHHPpjiDzY4_w@mail.gmail.com>
 <51e9ed8f37a1b5fbee9603905b925aedec712131.camel@nvidia.com>
 <CACGkMEuHECjNVEu=QhMDCc5xT_ajaETqAxNFPfb2-_wRwgvyrA@mail.gmail.com>
 <cc771916-62fe-4f6b-88d2-9c17dff65523@nvidia.com>
 <CACGkMEvPNvdhYmAofP5Xoqf7mPZ97Sv2EaooyEtZVBoGuA-8vA@mail.gmail.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <CACGkMEvPNvdhYmAofP5Xoqf7mPZ97Sv2EaooyEtZVBoGuA-8vA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0110.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::6) To CY8PR12MB8297.namprd12.prod.outlook.com
 (2603:10b6:930:79::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8297:EE_|SJ2PR12MB8133:EE_
X-MS-Office365-Filtering-Correlation-Id: 4991a1f1-6eff-4cbc-cd5b-08dcb5f04e7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?enFjV3FTVGJWYjNpSFBpenpaN245S3F2Z0ZlTjBDcGVaN08xWDg3bnhYdFh0?=
 =?utf-8?B?S3dvN2FUNUFTUTBEeHdMc1ZSSGw4MDkzc3lKb1BqRkMzYTJ1SW55UUdROHRK?=
 =?utf-8?B?cXY0UUhSMkFCNjhlYmFkRHRVMDNwTUVxUVl2TGQ2WWZ2d29Ga0NvTVdjNEIv?=
 =?utf-8?B?bVAxdTQyWjlqdTg4R2NzMFZTQVBmVDBhZk8wUjc1WE10cmJSTFlwSzdEelBp?=
 =?utf-8?B?VFErZGxaWU0zTjl3blRRY1ExWXg3UXpiNHZBOHVKR3ZyZHQyTVpYUHVCQWYx?=
 =?utf-8?B?OGgraEs4Ykw3NlowTHRWTnA0MThkUjRMeTFzeG5wY0NqbmF6WFhCSjFkeExU?=
 =?utf-8?B?SlIzbUZWVnFVN0IxREk4cG5tUWtzVUQzTFpjUDlaUlpUSnNLS2VKcmU3Yk1O?=
 =?utf-8?B?dEE5cGFaaUdvWVBmZU1sVkF2czEwWWduZFZFaFlzb283NU5yRVNaS0RJcGx6?=
 =?utf-8?B?YUlqYlh3dHJOc3UybHRPWW5QVkZXcnZVSlJSWXFPeGJXR3lXK2pEWWFxSWM3?=
 =?utf-8?B?WFVEZVpXbW90YXRUWlk2eHIyS01qbEVYS3M2ck9SUFhjNVRReXpLT1dLSDA4?=
 =?utf-8?B?dDcrWUZ1SEFGSWl3Rm1JbjFyQUFadlVNOHZLZmdoTEtMRFNXUCt1Q2dHeGZP?=
 =?utf-8?B?enVyV2JoNEpSWllvQVRhWEs0dU96UjdPbVdLak9xSlpwY3A0L2lqRDY3SWJy?=
 =?utf-8?B?N1hka0J4U0V2aW1KVGxYbkVxdk94SGM5TnIwZnRLWnRjVzF0MG5CbzU1SFAx?=
 =?utf-8?B?NVJWbjZPVU1IRk5QQXY1V2VVRkt6NFQ1Q3doUENsdzQvRk1jK1lQamlNTkRF?=
 =?utf-8?B?TXQ2aWV4OVU3ZFN2bWc5bEh2L3VQbHowakRaZW1VNzVUbHRyQWVROXNjK1VE?=
 =?utf-8?B?MzhlTFJLcHRtN0o0Q2g0RjBNaTRsVGYzaEczWXpWQlhjK0Y1ZWpua2lEZzNL?=
 =?utf-8?B?NGNWSWNUWlEweVhhcG44V2wzRk5xV1Fid2JoRys2S3hzendKR1c0WmJobEpK?=
 =?utf-8?B?Z2x0cE5CQWxFaDhMbS9PaldYT3BBQWREVERrWWZDZmZQSkV0ay9GdWo0S1ZG?=
 =?utf-8?B?akdiS2pHZ0VpNjVuZ0NnZGxPNEF6UW9Zb292SUd5YzEzNGQvSWowKzBpcDNI?=
 =?utf-8?B?TElHSlBwbTQrb0V4SkpyaXIzWlcraERBeFJ3WldFNnBPcUtjVDEraWgvNjNm?=
 =?utf-8?B?YmJ2SXIraE1GUmd4Wnd3cVB3WnFiSURkQ2dLUklCYnQ5U0RZUHZPVnA3Qy84?=
 =?utf-8?B?WGVBQ0pWbFNGVVdqSWFIVHh6SDkrMm9vamtQVlcrY0E3dFNDc1E0V01lQ2dW?=
 =?utf-8?B?RnN4TTRMVWdIRk1yb0tieHp6V0tTZ2owanJsQzJxTkMzVGFKZmNxajM0QklD?=
 =?utf-8?B?ZUtMdElDa3Znak96T01lbUF5UDFoZ254RGhwakM0MWhZMFJvT1Rod1p3OGY2?=
 =?utf-8?B?YnRFOXZObyttbkN1V214ZWJ1RmM0ajhRZmdVVEJNVlF6Q3RxczVaUk1jTzk0?=
 =?utf-8?B?QVBtUFk3M2EzS2Z1NmpmUFRoZEFWUjVnZmdjVTI5QjV3WjJwVFNQMXhnSVRj?=
 =?utf-8?B?M3dHTGx4M0pBbnBSaU5SV3gwZnY5dzU1elE1MFZDcEorV1BRKzZsS0NHRDZl?=
 =?utf-8?B?aVEvRjhscUdSc3MvaGlrc3U5dS8zSll4dUdsdTdxNlN5djRudTZQVTBqUkFM?=
 =?utf-8?B?TEh3VGwycGlhQTZDVDdRRjYwY3J2OFNxMGgyQWlJelhKWlA1MlpSOXRDVC9u?=
 =?utf-8?B?a0RuaDc2enFXT0F6UzE1bFhQU1JJMlkwa2NjREJTTUxqVFA1ME1qdW5PcnJV?=
 =?utf-8?B?cDRJNWxhamlkb09USkVyUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8297.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SmdORmZEN2NXQmhDNTZ0VG9IaFpUY0lZWWsrSTdGdVhQRzJQR05ocFQrb3Ay?=
 =?utf-8?B?K0FaSCtIb3l3K0FuYnZGR2cxRmxBSGxsNW9DU2JId0licjA0K3FpcXJmRnJG?=
 =?utf-8?B?RXBXQVAzUGpUSk9qWUlOMS81SDF1dW54TkVTMFl0WUk1ZUc5ZG9MaURKQzFr?=
 =?utf-8?B?UTJHbTkrUXNDaDlJYVlOa3dlVGJMVFZDUGxWNEZLaEVJTDZMbGVVa0Zkc25q?=
 =?utf-8?B?OHlDdFViTEFuZk5Tb3pORUwyTGpEUkdjai8wQ3JGL1c0dmxQUmpCdW1iK0VQ?=
 =?utf-8?B?TVdvd1dqVVFYWkl2TnBhWVd6ZmhNaFVJbWJWVEhCU2FJVVlDNVJXQks5V1hU?=
 =?utf-8?B?UzVyNjhOL0g4eVBRVEdXWHJLc1dTRS90KzVUazQ3S3Q3OEZTbXVSZDBJL3lx?=
 =?utf-8?B?ZTRZSGdOb2VtVCtYdjdUaHZ3dlpOc2s0dE1lL0gwenFNbUdKRUNMeDd0TmNz?=
 =?utf-8?B?V3dnODByYVpWbFRzaDhRdlQvWmlvckdJUkFBcjF0dGJqSDQrNUhTUUdVYXJo?=
 =?utf-8?B?Rm5zOFliMUNUczRLTUhJdWcySTMvM0QvdTZBaDhab1hVUTRTamljT0hTR29Q?=
 =?utf-8?B?aldCV1c5bU1pcUFhQ01kTDN6TnBGK1plMDlVRUhoZnpMT0RCWlJTZVN5VHNu?=
 =?utf-8?B?bjJ0RkFkeWhDNkJYdUF6R3hlcXRoV2hUbU45QzFCMUg4RUYrVFFTa01HU3Ry?=
 =?utf-8?B?bkc3YUJ5R3duR2MxamkyWmdhTWRhelVXZmNLSXVIOU41bzdyVHlwaXFlWW10?=
 =?utf-8?B?NHVvQ2VnSWdOM0ZkdEJEMVJyYlFWdWdJaGIveFpBcVJKeWFGWE9kd3daRUpT?=
 =?utf-8?B?eVlWanRMZER5RUpuOTVNODQ5ZUZFVmdrUGdFaG9yc3VLVXpBUjhRQU9UYXJ5?=
 =?utf-8?B?MEJnUEpRYmZLc0dmOWU2dDFFdHNTNU01Q0piVStySlFlWjM5azFucWQ0YlQw?=
 =?utf-8?B?UlVwcGFueTNsSEhHcGRvV2EwYkkvMmMrUDRFYTdFRG9MbHdRNGZ0S2VLRGZt?=
 =?utf-8?B?R1dJczB5MTFBYVRlRk9mcjZYd3ZwMytHYzZTRFRoWFB4cEU5TU1obmgyNFlw?=
 =?utf-8?B?THREeUoyaXlKV2FESzNTaXBlUXVjeDZoWjdVb1pnb2d4Ym9QUlZKbkVzaWRt?=
 =?utf-8?B?RitNUW04b2RUUTh1Q0tZcy9aRi9wRHJFNjlLSml6ODJoNW9VcisrK0g1bThD?=
 =?utf-8?B?aVAybnJrRUdWcmdnT2VZWjhnS24yRG1KRk9pbmFGejVMZC83YlZGaTFRL200?=
 =?utf-8?B?OVRCZ1RXWW5wUGlyVzFkSkpRaXBJRXZFdFpGK0x1TTQ5ZU9ubjg3U3VpYzZI?=
 =?utf-8?B?T3E3d1RHWEhUaTNYRDliWGJBblZEOHRDTjloc3c5VUF6dlNhYllKV3IwcEdz?=
 =?utf-8?B?aVQ5UThQUE1ZTEx5SXlkVm8xT1BQYVN1dzE4b25pS1NDK2FlYjVITHN2bCtR?=
 =?utf-8?B?Tmphb3FEWEZDdjFkay9hL2hZNmRJVy9vTDFwUlpqSTlZU2JCYmk5ajNacDFv?=
 =?utf-8?B?TE9IcnlZM3Y4MktHa09OSEFvUDdyVG5IUUFrOEpkOTI5Sm9KM1IwUU1ZaFFp?=
 =?utf-8?B?b1hmVTN6YlYwblJpMDQ2dzNvcHh3UjU5Z3Q0blBrL2xqTHVOc052VG9PcXBt?=
 =?utf-8?B?ZU5zRUxPeWZFSE9xZU1JdkZ1MVBFUFdaQmZPaGVNTDdmOWJ3OUh4bVVieExR?=
 =?utf-8?B?VzZCT21IRmJYOUlRTFN4dUdud296aWYxNnkxUmpTUkVGblBXOFJ0NXhMRlBn?=
 =?utf-8?B?c1NvS3NPeDZyR2tDUDZMbk1KK2VuUkFkclNSdW83QU55eWNTYnRmRDhURE9y?=
 =?utf-8?B?N3pTWUx4OHpPSW1ubEQzMFZ5UHV5N2J0UzFscFIzNUdpMWNuZVhwdTVtMXRS?=
 =?utf-8?B?bk12T01ob0l3U2ZZUDNybEcvNDZ5TmRUVjhobEF2N3NHNmFFdTVmUnRkd2VC?=
 =?utf-8?B?anVpL2ZyYXpRU21taHRZbDdqNEVxRW4xbU1SZEM2d3pCYzNJdE0xNHZRU2Q0?=
 =?utf-8?B?bmZmR2l3MklkNGpRU2hVbElnOGNZRmJYaVQ4aDlOQW93MU81bzNIM254Zk1K?=
 =?utf-8?B?Nm1aUjJYbmhvVkY2Y2srNzluL2VEUE4zOXpOUXNMRWtxei9iRStjT1lVY3lP?=
 =?utf-8?Q?jkE+6h/wipmQ7uumNyCpEemln?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4991a1f1-6eff-4cbc-cd5b-08dcb5f04e7f
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8297.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 08:18:09.5665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JUykBzVDx4MVc2KX4mq4kvJpg9tgzZ4Oys30Ugw8Wf7UWcV46ku54/852uzAEdXyoSBi8+pQZROwzFiw3CfQhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8133

(Re-sending. I messed up the previous message, sorry about that.)

On 06.08.24 04:57, Jason Wang wrote:
> On Mon, Aug 5, 2024 at 11:59 PM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>
>> On 05.08.24 05:17, Jason Wang wrote:
>>> On Fri, Aug 2, 2024 at 2:51 PM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>>>
>>>> On Fri, 2024-08-02 at 11:29 +0800, Jason Wang wrote:
>>>>> On Thu, Aug 1, 2024 at 11:38 PM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>>>>>
>>>>>> The following workflow triggers the crash referenced below:
>>>>>>
>>>>>> 1) vhost_vdpa_unsetup_vq_irq() unregisters the irq bypass producer
>>>>>>    but the producer->token is still valid.
>>>>>> 2) vq context gets released and reassigned to another vq.
>>>>>
>>>>> Just to make sure I understand here, which structure is referred to as
>>>>> "vq context" here? I guess it's not call_ctx as it is a part of the vq
>>>>> itself.
>>>>>
>>>>>> 3) That other vq registers it's producer with the same vq context
>>>>>>    pointer as token in vhost_vdpa_setup_vq_irq().
>>>>>
>>>>> Or did you mean when a single eventfd is shared among different vqs?
>>>>>
>>>> Yes, that's what I mean: vq->call_ctx.ctx which is a eventfd_ctx.
>>>>
>>>> But I don't think it's shared in this case, only that the old eventfd_ctx value
>>>> is lingering in producer->token. And this old eventfd_ctx is assigned now to
>>>> another vq.
>>>
>>> Just to make sure I understand the issue. The eventfd_ctx should be
>>> still valid until a new VHOST_SET_VRING_CALL().
>>>
>> I think it's not about the validity of the eventfd_ctx. More about
>> the lingering ctx value of the producer after vhost_vdpa_unsetup_vq_irq().
> 
> Probably, but
> 
>> That value is the eventfd ctx, but it could be anything else really...
> 
> I mean we hold a refcnt of the eventfd so it should be valid until the
> next set_vring_call() or vhost_dev_cleanup().
> 
> But I do spot some possible issue:
> 
> 1) We swap and assign new ctx in vhost_vring_ioctl():
> 
>                 swap(ctx, vq->call_ctx.ctx);
> 
> 2) and old ctx will be put there as well:
> 
>                 if (!IS_ERR_OR_NULL(ctx))
>                         eventfd_ctx_put(ctx);
> 
> 3) but in vdpa, we try to unregister the producer with the new token:
> 
> static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>                            void __user *argp)
> {
> ...
>         r = vhost_vring_ioctl(&v->vdev, cmd, argp);
> ...
>         switch (cmd) {
> ...
>         case VHOST_SET_VRING_CALL:
>                 if (vq->call_ctx.ctx) {
>                         cb.callback = vhost_vdpa_virtqueue_cb;
>                         cb.private = vq;
>                         cb.trigger = vq->call_ctx.ctx;
>                 } else {
>                         cb.callback = NULL;
>                         cb.private = NULL;
>                         cb.trigger = NULL;
>                 }
>                 ops->set_vq_cb(vdpa, idx, &cb);
>                 vhost_vdpa_setup_vq_irq(v, idx);
> 
> in vhost_vdpa_setup_vq_irq() we had:
> 
>         irq_bypass_unregister_producer(&vq->call_ctx.producer);
> 
> here the producer->token still points to the old one...
> 
> Is this what you have seen?
Yup. That is the issue. The unregister already happened at
vhost_vdpa_unsetup_vq_irq(). So this second unregister will
work on an already unregistered element due to the token still
being set.

> 
>>
>>
>>> I may miss something but the only way to assign exactly the same
>>> eventfd_ctx value to another vq is where the guest tries to share the
>>> MSI-X vector among virtqueues, then qemu will use a single eventfd as
>>> the callback for multiple virtqueues. If this is true:
>>>
>> I don't think this is the case. I see the issue happening when running qemu vdpa
>> live migration tests on the same host. From a vdpa device it's basically a device
>> starting on a VM over and over.
>>
>>> For bypass registering, only the first registering can succeed as the
>>> following registering will fail because the irq bypass manager already
>>> had exactly the same producer token.
>>> For registering, all unregistering can succeed:
>>>
>>> 1) the first unregistering will do the real job that unregister the token
>>> 2) the following unregistering will do nothing by iterating the
>>> producer token list without finding a match one
>>>
>>> Maybe you can show me the userspace behaviour (ioctls) when you see this?
>>>
>> Sure, what would you need? qemu traces?
> 
> Yes, that would be helpful.
> 
Will try to get them.

Thanks,
Dragos
> Thanks
> 
>>
>> Thanks,
>> Dragos
>>
>>> Thanks
>>>
>>>>
>>>>>> 4) The original vq tries to unregister it's producer which it has
>>>>>>    already unlinked in step 1. irq_bypass_unregister_producer() will go
>>>>>>    ahead and unlink the producer once again. That happens because:
>>>>>>       a) The producer has a token.
>>>>>>       b) An element with that token is found. But that element comes
>>>>>>          from step 3.
>>>>>>
>>>>>> I see 3 ways to fix this:
>>>>>> 1) Fix the vhost-vdpa part. What this patch does. vfio has a different
>>>>>>    workflow.
>>>>>> 2) Set the token to NULL directly in irq_bypass_unregister_producer()
>>>>>>    after unlinking the producer. But that makes the API asymmetrical.
>>>>>> 3) Make irq_bypass_unregister_producer() also compare the pointer
>>>>>>    elements not just the tokens and do the unlink only on match.
>>>>>>
>>>>>> Any thoughts?
>>>>>>
>>>>>> Oops: general protection fault, probably for non-canonical address 0xdead000000000108: 0000 [#1] SMP
>>>>>> CPU: 8 PID: 5190 Comm: qemu-system-x86 Not tainted 6.10.0-rc7+ #6
>>>>>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
>>>>>> RIP: 0010:irq_bypass_unregister_producer+0xa5/0xd0
>>>>>> RSP: 0018:ffffc900034d7e50 EFLAGS: 00010246
>>>>>> RAX: dead000000000122 RBX: ffff888353d12718 RCX: ffff88810336a000
>>>>>> RDX: dead000000000100 RSI: ffffffff829243a0 RDI: 0000000000000000
>>>>>> RBP: ffff888353c42000 R08: ffff888104882738 R09: ffff88810336a000
>>>>>> R10: ffff888448ab2050 R11: 0000000000000000 R12: ffff888353d126a0
>>>>>> R13: 0000000000000004 R14: 0000000000000055 R15: 0000000000000004
>>>>>> FS:  00007f9df9403c80(0000) GS:ffff88852cc00000(0000) knlGS:0000000000000000
>>>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>>> CR2: 0000562dffc6b568 CR3: 000000012efbb006 CR4: 0000000000772ef0
>>>>>> PKRU: 55555554
>>>>>> Call Trace:
>>>>>>  <TASK>
>>>>>>  ? die_addr+0x36/0x90
>>>>>>  ? exc_general_protection+0x1a8/0x390
>>>>>>  ? asm_exc_general_protection+0x26/0x30
>>>>>>  ? irq_bypass_unregister_producer+0xa5/0xd0
>>>>>>  vhost_vdpa_setup_vq_irq+0x5a/0xc0 [vhost_vdpa]
>>>>>>  vhost_vdpa_unlocked_ioctl+0xdcd/0xe00 [vhost_vdpa]
>>>>>>  ? vhost_vdpa_config_cb+0x30/0x30 [vhost_vdpa]
>>>>>>  __x64_sys_ioctl+0x90/0xc0
>>>>>>  do_syscall_64+0x4f/0x110
>>>>>>  entry_SYSCALL_64_after_hwframe+0x4b/0x53
>>>>>> RIP: 0033:0x7f9df930774f
>>>>>> RSP: 002b:00007ffc55013080 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>>>>>> RAX: ffffffffffffffda RBX: 0000562dfe134d20 RCX: 00007f9df930774f
>>>>>> RDX: 00007ffc55013200 RSI: 000000004008af21 RDI: 0000000000000011
>>>>>> RBP: 00007ffc55013200 R08: 0000000000000002 R09: 0000000000000000
>>>>>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000562dfe134360
>>>>>> R13: 0000562dfe134d20 R14: 0000000000000000 R15: 00007f9df801e190
>>>>>>
>>>>>> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
>>>>>> ---
>>>>>>  drivers/vhost/vdpa.c | 1 +
>>>>>>  1 file changed, 1 insertion(+)
>>>>>>
>>>>>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>>>>> index 478cd46a49ed..d4a7a3918d86 100644
>>>>>> --- a/drivers/vhost/vdpa.c
>>>>>> +++ b/drivers/vhost/vdpa.c
>>>>>> @@ -226,6 +226,7 @@ static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
>>>>>>         struct vhost_virtqueue *vq = &v->vqs[qid];
>>>>>>
>>>>>>         irq_bypass_unregister_producer(&vq->call_ctx.producer);
>>>>>> +       vq->call_ctx.producer.token = NULL;
>>>>>>  }
>>>>>>
>>>>>>  static int _compat_vdpa_reset(struct vhost_vdpa *v)
>>>>>> --
>>>>>> 2.45.2
>>>>>>
>>>>>
>>>> Thanks
>>>>
>>>
>>
> 


