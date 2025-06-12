Return-Path: <kvm+bounces-49264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6E07AD7033
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 14:24:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADD7C17AE77
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 12:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C8301CF7AF;
	Thu, 12 Jun 2025 12:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="zTl0FZwZ"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11021126.outbound.protection.outlook.com [52.101.65.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76E11A8405
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 12:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.126
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749731033; cv=fail; b=MtX9lUmZoaWm/7qaKk8xyAm4LUZ8fe+oTBOPhu8UU+pciBswjoifxA4nppKbdJYLAS4Z+VmkA/A78XrEnLPFdTQwXtwdaF28McOp64pV4iKY08P4LigBDmCIa4KxFW4Sx1ZpSBkQmbXxE0wKCc2UJFriYEziEDFjk8XeWX7LKsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749731033; c=relaxed/simple;
	bh=PI8+dop9S615MRgn28CGdydDSXLgpwmnAZMohQfNwMQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mafdGD9dO9EQlM3wQMbK4wAK16x5PNbUqZ+x0MvEmwdfpDn7/JmvZeuhkSVznI6JeWbR6KuVutQ6YFDTlzQrULNgcIJeRxXjl+iL7RoEVi9tf/ZAEaLy/2X0tYOBHVhDOzPH+4Nuwe/5S7UFauRPig9HHBZ3eaPhkP+/gcOd92A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=zTl0FZwZ; arc=fail smtp.client-ip=52.101.65.126
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OKLfgcJOBQmQTT8OtM5MxZ17GOcIYbHpVJV8/9lsEj5vZywWoNcalOmmgVaK99lDAIUev5JNsoSM+krJpLeeZrnwESSHV7PijkjPsovJS0Sr2o0ToS6G1A62Fd95WB+0FCgI3zkBGDROYNuy8MgdRAeL1HDN8uSi9Hli+tD568iaKkw2qSbcdQCTSZjTOgKQz4rAadueB3bWQHZ0eMBGG5di8+EhFHni52edXsqI6VstvHjcYLuwQNOTiLBZWR2KkRY8Si9uZaEvqlgJ6yU8LOpF0QEbCqpZeYFxAndXyy7U6FgJAOX1EC3yyPRPFONFIynd4aUyB3icQDCGqMVDyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VG0Xyf3te65eLoGFpnbJuYIgyscgjvu02bCg/Y/BxQ8=;
 b=L+49K97b66yWE06PzhJF1oAQGGFQt28EGz1x8VZ5GjLWdYjr3quQDCDV9WOIe+t0pLONA8tay9aNNniVQ7fIDzYWa5dH+o2g/IVYwiI/qT8rDBL/nuQgu7wjAVxbgEMojxLqS4SCiz13R60ZboncUtzTO4hMfnpM8UDkuxID/hSyfQ1Ous41WXYJ2IFui1uvbD/ifYQ3Eh+CRsSV+KwjwPlh2wjTOM+4pREaXjALrVbC047q8n+hFYvNr1R/IUSmIjZ0V/8gX6yMZDxwU5UoHBEiD6tUN6U3vsETfAYnMcy2oDAyriB1ORkdKHRPiF0SsZlkZt50RAo82kt9606ghw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VG0Xyf3te65eLoGFpnbJuYIgyscgjvu02bCg/Y/BxQ8=;
 b=zTl0FZwZCMhHAP96FnFqF0fMYkP2a5xIADS4b8uN+ZYOpetWpsLQoJ54IvgQ8JQmMmJMCjn2TnEB9Z6BzEg2u/wujd3SSJE7GkMiCHELX2wVFCElGdRYNjvDJLh3J9/cn0TsITBTkOMwVEupWpxKjl4jd9sb8Du9eXDLPxN6mwyTZS73v5I5RrIBJ+R14V1y9eshgqWohymAVXEf6e5kC8vs03LXP3KPpHKjfVVxuyfBpn/dq4Cq7gfHFOvJx3Dr7TuDa3/HWioARyOgeQU3RcXBiObDAiI+ekSkH0iu56lIOe/evUvnnr/wQICMAy9VLu4mzICAzjhHi8yMbqicXA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com (2603:10a6:20b:1d4::16)
 by DU5PR08MB10703.eurprd08.prod.outlook.com (2603:10a6:10:520::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.19; Thu, 12 Jun
 2025 12:23:47 +0000
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::e543:a83c:a260:602b]) by AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::e543:a83c:a260:602b%3]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 12:23:47 +0000
Message-ID: <2b2838cd-9285-490d-8ad0-c61bfba92a96@virtuozzo.com>
Date: Thu, 12 Jun 2025 14:23:45 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] target/i386: KVM: add hack for Windows vCPU hotplug with
 SGX
To: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>
Cc: zhao1.liu@intel.com, mtosatti@redhat.com, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, andrey.drobyshev@virtuozzo.com,
 "Denis V. Lunev" <den@virtuozzo.com>
References: <20250609132347.3254285-2-andrey.zhadchenko@virtuozzo.com>
 <7ce603ad-33c7-4dcd-9c63-1f724db9978e@redhat.com>
 <4f19c78f-a843-49c9-8d19-f1dc1e2c4468@virtuozzo.com>
 <aEcOSd-KBjOW61Rt@google.com>
 <203f24da-fce0-4646-abed-c6ca657828d1@virtuozzo.com>
 <aEcnMFzh-X7Aofbl@google.com>
Content-Language: en-US
From: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
In-Reply-To: <aEcnMFzh-X7Aofbl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0229.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e9::7) To AM8PR08MB5732.eurprd08.prod.outlook.com
 (2603:10a6:20b:1d4::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR08MB5732:EE_|DU5PR08MB10703:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d4d4233-c5c7-4994-97fa-08dda9abfa6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c3Arb21zcksrSk1nSXVSbHpEc29rNm9LVXovQWkvcERraWJOV1VMSzU5c3Fr?=
 =?utf-8?B?NUFUbkNTRUZCcU8wS29zZXFsYUFJY3lQc1EwYitXdnRCV1o3b1RCVUwxdFZG?=
 =?utf-8?B?Zm03aGg0VXNzR01yNDI5Ty9mWlVkMDR6U285c0Q5NjJJRFlWYzhzNVBFT2t4?=
 =?utf-8?B?RkduWWFZcmtLVW1wOWVGT3dMVkN1S3R1Y0g2bXNjcDhrWlhqYmFCVk9rSnJG?=
 =?utf-8?B?ekZsMWZLeWxYUnFVbkt4QmZXd1JyNGVEVXhMZ3VSeW1sKzdYQko5WHprY3ZI?=
 =?utf-8?B?aGZwZGlPcE90WDJHWm1nYmpJcUFEOWl1R1g0REhtcFpRZjNaWnFnZ01ralhr?=
 =?utf-8?B?OGZiZGFXaTUzRjFwT3JtNy9NeWZ1Z0c4ZHNIUGlsS0xONXJDMWk2a2RJcXZ2?=
 =?utf-8?B?ZTU1MEY3d0tpR2IrNzRXT0VmR084WFUvSk41QVdtRzZ1aitwenJPT2prS001?=
 =?utf-8?B?VnJZc3ByZ21ObTRWSm9OV211c2p4ZWhFQldhUC96SWFmMml2ZmRnNFgzYUNC?=
 =?utf-8?B?VS90UERkRmF0VFhadnphUXVrSXRxVXpHME14Nkw0UExGdHBGTlQzSXJpYWtZ?=
 =?utf-8?B?T3BkYWUrTXNrcFRaT2xvVDN1RFVyYXpTM3BTVG9sTGE4WWZ4L3pjRVJCRTBL?=
 =?utf-8?B?YmxCU1JnQ3RkYlUvM3dUSUpwcFd3cmpSd0VrWUxMRWIzWmNsWlQvSmNlYVVw?=
 =?utf-8?B?QkhUS3BCT0J3NzZWRGJTRWdtRGdPQzBmNzJ0QlRKSGMvNUR1WmI2aEx2WVJH?=
 =?utf-8?B?b2RsSEFseE1icTFwRVdOSTdDalFzU2I4eWJOMUFseE9CTHJlM041aUFpVitV?=
 =?utf-8?B?MGlua01PcncwVmswM1RDT3pTZDMzYUVKNHcvNUJmdTl0QnMyTXRaTzlrdnhq?=
 =?utf-8?B?R2Z4UWFCUTdVOUczZUN6Rng5dFFHSm83a3oxbGdvK0RNSUxvUnNxUzY5T0tM?=
 =?utf-8?B?cjlwZC9hUi83ZzZvMzIrbUpJekhCTG5iVnhSMTlUSm9LNVh1RlZzRWJDZytw?=
 =?utf-8?B?WXBzSHRKUHB4WHpuRjJoc3VObnV5ZWN2K28rc09zSzdVbE1zODg1ZmpaK3Zo?=
 =?utf-8?B?bzg0YituR2ZRbmJvZng1TkhUNThab05KcU5BaGxOZ2Y0WExkeFZ5dmtYQlE0?=
 =?utf-8?B?V0l0bTZnMTZuQVVIQTl3cnBOR0xqcDRSbFlRbjVKaUNjSy9sS2RidlhMbmFi?=
 =?utf-8?B?VXlNN2czN0JzYWlkK1Jub0NXWlJxeWFVcDlJTEF1WDVCcTlEcEtDNlhQM3lL?=
 =?utf-8?B?cmtPRXZCMFBKWFQxVEhXOW50QSs2QWFxbFJ4dUJodTlJdWlSQ0wrc0NteTJt?=
 =?utf-8?B?RGF4NEJoNEFWYzgrTWdSYkFqOTNzdjkyWXZ0SEVRNGt0QmFQYWNJcEhOWVhm?=
 =?utf-8?B?aVpOalVLM21lQ3BBN1NYdEJ2dGFkaW9hcEY2L2xlUFpqTVJDUFNDY2p1bWZv?=
 =?utf-8?B?Qm4rWncyRm82MS9pZW56RjJDdjkrQzhhdEhob2FPR09sU3NscVBwbVFqMXFK?=
 =?utf-8?B?TVBrUW50UEE3TzVjL29Xa0N5NE9od09qOTZiSm5QVnFMTU0xMnMxMGRHTXFK?=
 =?utf-8?B?dFBoMG12eEo1UUl6RGhvMDhmSWhQekgyYWRabFNMUno3UXdETFZRUmthczFv?=
 =?utf-8?B?cW1EZTEwMGczWTliZ2x6TEtLd1p0T1V6dnM1ZytDZzBoekZCWXFVUUQvdVJW?=
 =?utf-8?B?WEZrTlpKWTBudllZdFlXUnFhYVRqbXNNVWEzYmQyR2tybGx2TWY1QTRWMDJm?=
 =?utf-8?B?TUxTRmVTQWtpY1dXSGl5Y04zaXM2S2d4YVhTLytIcU9DbHpHc0hFMm9VNzJZ?=
 =?utf-8?B?b1RZZ1lBZDVGakFOMitDS0orYnIyYXgvbXo3NjJYcEtkQWNDUHlPVm85cS9z?=
 =?utf-8?B?anAxaVlERVVWYlFaYXJKallwNEhodUVjV0JxWDk1MkRrdnc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR08MB5732.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TmJuY0hFcmVxdHZkbjIveGdEaUZrT2k3RjJCQUpqUk10elFFOUU0MU5FK1lk?=
 =?utf-8?B?c0dnOVFjRVlEanpJNUREaDdxeWxzcWVydWpoZC9BU052YWs5WEFYTCtBZld1?=
 =?utf-8?B?N3ErVVdSU1podW5VRXVoZHNGM2JyUHdnNzlSVWdPSk4xVURwVUhkeWZqVjc1?=
 =?utf-8?B?bGZObkh4ZTZYNzh4R1BjT01XWHZEcVNpS0ptekpnUC9xV2N4NHBwTlArbHFI?=
 =?utf-8?B?eElybEFkQlZyU1M5YlBGcWhaWjlIeXZKOWpibEg1SXpkQ2FWWEpXUTRhdEhY?=
 =?utf-8?B?a2ZGOUg0QVhxVnZVb1ZLTkNPdDY0WngrSFk2a3VtNmRHd0tQNWZWQWlSUVFw?=
 =?utf-8?B?UUJiQzhCQ1ZSeTRzTTZRbEJGSTBhQ1orTEFBa1dveVVTU01lUXo2R3JNMFVo?=
 =?utf-8?B?Zm9HT3VDMjRDRXYyS3NhV3dwb3AxT1FJOHRRMzlCSUlkYVZ2YzVSQTFCL2JQ?=
 =?utf-8?B?RGJoMklaZVZBK05Pam8wVSs1enB0TzVSMUhPUi9LZzlWZktDaS84bnRjd0hL?=
 =?utf-8?B?NXBNdHdDekZDa0hCTUZpSWtMRWY0dkZ1K29FZDZBVnYvTlRmZ1NNU2JWbFpE?=
 =?utf-8?B?NWJ6SENuVkNhWktDRnhmYlVYVHBqbzlEUVljalhaNFdkZWlpNHFrQ24vWHRw?=
 =?utf-8?B?d0NXeTZMWGhGNDFrbndsSlA4NHAvcnFUQzN6VlMwTFFyczhQclpYSzErb0Jl?=
 =?utf-8?B?NVlLRTEwd1V6ZERRRlNZNEhJd3lWQXhxWCt3Y1JmTTIxU0Q4Nmd2NmEzeFND?=
 =?utf-8?B?dkRLL2tiZFN0WDV3bGlTZ3d5MWpITUhZVGlYNUMxUFlNNE45QXZPYlQ3eFRR?=
 =?utf-8?B?MXlTbkhUTzlGN1gxMVZVL01NY2srWXk2T3RvWWdMeFlEREd5UkI5L2V0eitV?=
 =?utf-8?B?OEM1NFVyRHphR0ppWnhEQzdkRkhpWGp0R21rdHBSZXNUa1JVd2lhbVRXTE0x?=
 =?utf-8?B?enA5L1JHcC9jSUxDdkgxa1VNZWtKdWNQY0gyalpLOHN3bWdmN1dFTS90UnlC?=
 =?utf-8?B?Q2lUSE9PQ1JXaUc5ditPQkRkbHVZTFlqczl3R1piUjFLR2lpRUtYalBUTngv?=
 =?utf-8?B?dFFkV25NbUw0UDhMVGExdk42aCtaU2VBTlFUOHF1ZEpTV3kxUEl2elBRTnph?=
 =?utf-8?B?WWxsQ3lTREo5bS9MYkxIS3ZodTNxR08xZW5jQkVKaGltb3dyYkMxSmR2aHd4?=
 =?utf-8?B?UzdiSGU2aHdobnQrRks4Yk1nUVVKNTBiQXVYcnJJVHpVNjFPT1Y5V1RmRHhB?=
 =?utf-8?B?eDFNdU51WVVBUzZiL2g5TzRHOUlnNVFoS0RQdm90YS94WHA0RWhSRWQ5U1pm?=
 =?utf-8?B?UzQrVllkM0pNM3ZUd0NlS2FVRXpla2F3RmlKczRzS3pRbWNYMVBJUTIzbG5t?=
 =?utf-8?B?ZjRyS2VVWEZRWG1YSEFXaktlSzVmVUF6ZXZFTEdCMmZEN2loTEJKNTdoWGEx?=
 =?utf-8?B?TzV1akhuVXU2Y3laOTA1elJsdFZUKzRzYytiRm81aXJ0MUoveldEdE0wWEJD?=
 =?utf-8?B?dkhCQ3NEVTh1cGcyNmhCOHBIYnhvRmJxYldjOHpIY2x2WS9ZWnBaWWJzM0k4?=
 =?utf-8?B?aUoxcXIybXdjK1BqNGVGSUJ2VndtUGg3RmpOUGV1dkpwNEF2YS9kdTJUYVZ1?=
 =?utf-8?B?MU1YV1ZtZW5UZHQ5dFlyaVNoNmtlZnpyYVVjVFZlRm5XT09SQk5paHlpNVlH?=
 =?utf-8?B?T0hxT21yUTk2ZHhkVUgyK2ErUFFEeU9veUd5TStNbVYxM2JMcm9qaGRMUjJh?=
 =?utf-8?B?OHArekxaOE42YzE5VGVsbzYzS3o5cGlyV0NqZ0tlQmZiMnJiN3FoOWVnWUxI?=
 =?utf-8?B?UGt6NEx5d3BlWHRxOFJzSThkRjdIaUR3eXRzOFNLVjY2aUtkVHl2Z3oxZ05M?=
 =?utf-8?B?YU9xdTFNSEp5UllZaTRMTXdaZ280U3FUdWduTmc0eDcwWGNzekhpcHRValFE?=
 =?utf-8?B?WmVnalNLZS8xRUlpSHQ2cCt5cGxFUjczb1FJYXpDZG5OQ0lPVVBIa3RmVnRp?=
 =?utf-8?B?bG81UkQ2NGpodmVGeUQvMHB3bUlRNE1QVGZIQ2x3RFU3a2svQUVEVWVITU1L?=
 =?utf-8?B?bkFDOFdaTGRUMktRcGZtZDdMR0NyYVdHbzVaaXQ0NDA2OE91M0U3cEo1VitX?=
 =?utf-8?B?OEF2RzBEam9zanBEWG41cFM1YjlPWHgzZnp5aVJTTjhJMmd4Z0RGdnhYWHYz?=
 =?utf-8?B?M2c9PQ==?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d4d4233-c5c7-4994-97fa-08dda9abfa6e
X-MS-Exchange-CrossTenant-AuthSource: AM8PR08MB5732.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 12:23:46.9444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tr0BDuvAF/+uHB3cupHxLWXzpHt1hAI0v6hFoD7E7y27fjPhym2x/W1HlOro4LtE84u8Do/E/yJqIJGwVtrkx2MoH0Ir2dcrmlx42rvoc5k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10703

Apparently, looks like it is a firmware bug.
Both seaBIOS/OVMF set IA32_FEATURE_CONTROL only during init from 
qemu-provided etc/msr_feature_control.
So probably the fix should be done in the firmware then.

On 6/9/25 20:25, Sean Christopherson wrote:

> On Mon, Jun 09, 2025, Andrey Zhadchenko wrote:
>> On 6/9/25 18:39, Sean Christopherson wrote:
>>> On Mon, Jun 09, 2025, Denis V. Lunev wrote:
>>>>> Does anything in edk2 run during the hotplug process (on real hardware
>>>>> it does, because the whole hotplug is managed via SMM)? If so maybe that
>>>>> could be a better place to write the value.
>>>
>>> Yeah, I would expect firmware to write and lock IA32_FEATURE_CONTROL.
>>>
>>>>> So many questions, but I'd really prefer to avoid this hack if the only
>>>>> reason for it is SGX...
>>>
>>> Does your setup actually support SGX?  I.e. expose EPC sections to the guest?
>>> If not, can't you simply disable SGX in CPUID?
>>
>> We do not have any TYPE_MEMORY_BACKEND_EPC objects in our default config,
>> but have the following:
>> sgx=on,sgx1=on,sgx-debug=on,sgx-mode64=on,sgx-provisionkey=on,sgx-tokenkey=on
>> We found this during testing, and it can be disabled on our testing setup
>> without any worries indeed.
>> I have no data whether someone actually sets it properly in the wild, which
>> may still be possible.
> 
> The reason I ask is because on bare metal, I'm pretty sure SGX is incompatible
> with true CPU hotplug.  It can work for the virtualization case, but I wouldn't
> be all that surprised if the answer here is "don't do that".
> 
>>>> Linux by itself handles this well and assigns MSRs properly (we observe
>>>> corresponding set_msr on the hotplugged CPU).
>>
>> I think Linux, at least old 4.4, does not write msr on hotplug.
> 
> Yeah, it's a newer thing.  5.6+ should initialize IA32_FEATURE_CONTROL if it's
> left unlocked (commit 1db2a6e1e29f ("x86/intel: Initialize IA32_FEAT_CTL MSR at boot").
> 
>> Anyway it hotplugs fine and tolerates different value unlike Windows
> 
> Heh, probably only because the VM isn't actively using KVM at the time of hotplug.
> In pre-5.6 kernels, i.e. without the aforementioned handling, KVM (in the guest)
> would refuse to load (though the hotplug would still work).  But if the guest is
> actively running (nested) VMs at the time of hotplug, the hotplugged vCPUs would
> hit a #GP when attempting to do VMXON, and would likely crash the kernel.
> 
>>> Linux is much more tolerant of oddities, and quite a bit of effort went into
>>> making sure that IA32_FEATURE_CONTROL was initialized if firmware left it unlocked.
>>
>> Thanks everyone for the ideas. I focused on Windows too much and did not
>> investigate into firmware, so perhaps this is rather a firmware problem?
>> I think by default we are using seaBIOS, not ovmf/edk2. I will update after
>> some testing with different configurations.
> 
> Generally speaking, firmware is expected to set and lock IA32_FEATURE_CONTROL.
> But of course firmware doesn't always behave as expected, hence the hardening that
> was added by commit 1db2a6e1e29f to avoid blowing up when running on weird/buggy
> firmware.
> 


