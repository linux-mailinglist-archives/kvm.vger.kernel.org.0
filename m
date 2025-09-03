Return-Path: <kvm+bounces-56699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 276F0B42B7A
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 23:02:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3FF6582C40
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 21:02:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E4782EA72B;
	Wed,  3 Sep 2025 21:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NO1ug3GP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94312DAFDF;
	Wed,  3 Sep 2025 21:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756933313; cv=fail; b=ulvAuOndvboC2RgzeQcLZJe5HDGqaQrq1ZXulU0DVZZB/WGshPSbDReuzjxDQwdBtiT4QMyVKcBMXydLv0v37lTHyIjGjPeu4KapAY/UYHKJd9tP4dW4axZY5/NxjvVS1U6nTu6VBhjlp288rxqmxiKSVwWOGBgsFc2RDlaP8EM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756933313; c=relaxed/simple;
	bh=GRMKE/LHDmuH2ATlD7o2QGoLaa6jUlqNSbU7YGkQXhE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=g7IFmNOcgURBl4MCuSn+nRsieXHrb5XEd+B04mfgn5fFYMlKRwQeKXKiZL3jX8akJsbKtHuQ0TDv81QQZSp4N/p7vhoOAccew8yUoVh5oOd195B5/bki513mDCy9qHl5i8mz15GraNnRSnm66ELcZLdTSIRdydnXvdtY8mDIj+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NO1ug3GP; arc=fail smtp.client-ip=40.107.237.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CGhEz0nPY4o0y5x3gQkR2flbmg/plLNZLA9zoFgXL7cnlUltSyJBfgMU85ziqD1hyuiR3ZDUIg8fgO/QlecLVZQdRoq8/n86QeY9gjqHZJyXcvvurA6crR+daWquMSjSSJXCxaeyiNXyhwBeEs3z4YssClTY1Z6XM1UmvEH/uN5GdTn9RIdTItOHdQ7nQeqYCVQwm/gIkdZOonUK+SOh9pnllAh5YNS1LYLV33Mq5wg06aEJQGaU8BUtKn5/vTsRHFFaVzzn7Wzj4+aIUYPhl2/MRS/ckBTevs1ripUECRsO1kGOPMLR2tmZYBjU5Da/MiAB+zGALWSA7txGL8/MXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+yhRmpmZiHZ6ZOh6n051uyGGRgpaozbKigB0mrTI8tk=;
 b=FAVtRS9HPEoJyoX0shuo6byHmTt7x+Hb0hrcpUuFV84/6fafrG4zaY3KrjqC/DpsmrU9msD6TkXORx0Q/aDCW+CxsGMl4S1N6ud90OnCOOh0psGX0fsEbGvPReRY9WjnnmPwD6/k2as0dzDDA0Wwf7oydN/CTUCUcwaJwdy2SwpbToqSk/FfZPaPQ9kvLOBJVaB2cs4dPGRu4uQJOxge2wdt9J9/m9pVjX4I6MqE38gj94dQ1FLFNOlSI99sx+6m9shc90X5XsOOP0ja/srKdk7DAxPbhB13eEBqNt+vYeb/DUQ+S70rrtjfwT8PWjOkjdv8mgfoTYj+apbr6+CKdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+yhRmpmZiHZ6ZOh6n051uyGGRgpaozbKigB0mrTI8tk=;
 b=NO1ug3GP8ds5DorvA3mg2MixQiwRUdhEnB1sacK5IsMUJmxIHlJFXkbBjdlE+4x1sVVkNMcuoDBbKFQnreIVTgrUlKc31KldC0cGp1OvX6qNXeCE8JE/T1/VLjHvYa5FN3+EFIVM55ji8k186Bmwc2OKiQFK1pjDLLKKKb+1RBs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by BY5PR12MB4323.namprd12.prod.outlook.com (2603:10b6:a03:211::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Wed, 3 Sep
 2025 21:01:48 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d%3]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 21:01:48 +0000
Date: Wed, 3 Sep 2025 16:01:36 -0500
From: John Allen <john.allen@amd.com>
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
	rick.p.edgecombe@intel.com, mlevitsk@redhat.com,
	weijiang.yang@intel.com, bp@alien8.de, dave.hansen@linux.intel.com,
	hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
	thomas.lendacky@amd.com
Subject: Re: [PATCH v3 5/5] KVM: SVM: Enable shadow stack virtualization for
 SVM
Message-ID: <aLissKgzL8fX+tXr@AUSJOHALLEN.amd.com>
References: <20250806204510.59083-1-john.allen@amd.com>
 <20250806204510.59083-6-john.allen@amd.com>
 <aKu9VfW0FF5YeABi@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKu9VfW0FF5YeABi@intel.com>
X-ClientProxiedBy: PH3PEPF000040A6.namprd05.prod.outlook.com
 (2603:10b6:518:1::55) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|BY5PR12MB4323:EE_
X-MS-Office365-Filtering-Correlation-Id: 3253c606-fbc0-4447-8e06-08ddeb2d1916
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hbS/A/ONGRpJNVovrtHLV9F2RW99/qjfDKkQrMOs27DOcaeGN7nKpV8hRmN0?=
 =?us-ascii?Q?2LhsiIVNOjPqaj4F/toh+gHRknaf1Y09hqXHCffsio3DKRV9PnBuVSQU7xcR?=
 =?us-ascii?Q?nZBvWdykicTZXCQ4N8OsnlKdXi752EeBm1RqMscgzHDDj+zC+2vg6OEk400H?=
 =?us-ascii?Q?kaorT+txPXhKLGP9/8f7HRd/Y0R9b++CTsCGFU+hbU0/6VbM5JlPxrFB9iuA?=
 =?us-ascii?Q?VwaGnTTOxWM4Dyc+SxmNTiMZ1rl1w9BNqVXj3Emlt/LlqzM0nwVjSR6niqRf?=
 =?us-ascii?Q?MuyE6kH9jRqa7aZHjvmhTp8LQsK+t4VztPoBOg8zemyQVrNiMsjm18cz1g4F?=
 =?us-ascii?Q?qQ9tsUFTCyH+1NBT+xdRTTxp+9aIRLPQMpYAQXUPDdMI46iBrt+oAR2gcVWq?=
 =?us-ascii?Q?OHHo1cQ1pia5owRRZkIBEEi02dEsm0KqRZ4i/jyLkx2FdyEFkWmYRlp2ZWGx?=
 =?us-ascii?Q?kCBX7T60GCxb+6V4l77F/KqC2BPdmg4JJJ3oKy/4v9hqsyZ+/i0J0psXwt66?=
 =?us-ascii?Q?+4SI3V1LM6RSK7erq4oJXQXjZTR9xSCjE39hkhNk0XPjBn9282Ggx0pt9m0D?=
 =?us-ascii?Q?dGm/Gfgc/kcicihbpwoXhKpfFq0hrYCUmZfyxiPLK3O2t8yXqyE0fa9CKsSP?=
 =?us-ascii?Q?Tjya5lZutNFcOggaQCaicLZR6CsmaaWbr2+twflQF3/CJPtKlHK0CzpT+3a0?=
 =?us-ascii?Q?KEH8YEyGtMpdMGdWrCjvXp0Pp+Gfdm6J/PNB0jixXPwIdVpKFZAFuXbGY3UH?=
 =?us-ascii?Q?r7ukNm5NHaLRhY0lrEXTBlkjDAKHazLcNxL1m5R8C91up0OdjeUsOhyrLRD1?=
 =?us-ascii?Q?mb2N1Kdloo390BQp0B9r6rbJVoX160sXu6TQDnWpzuSeXgUZW7d3lQ3VZh1W?=
 =?us-ascii?Q?vWa2mfkEad8gxhJwiW+SKdqa7KVurl9RSIm7b1OUx19zXPvM0BmfTVElVSfw?=
 =?us-ascii?Q?2TdKnmAiGmOLsDRAI78w1/BiIj5Z6IjlZPP8cm8GqWc22nDPNQ7eD7u+2FGH?=
 =?us-ascii?Q?1R1n+PUKpf3MPPqEWYDbw3IcqDcgNh0T2dDFVtXi+G44bPIwTBmYJcGwNIXs?=
 =?us-ascii?Q?osUaNO+YNa+3PRwGBVcvitQ6KfUYrAesiy/AxI4pJt5dXc5VaNpCTy/cT2NQ?=
 =?us-ascii?Q?TAX6552GKpvW08kB/mcF+lHildl3aVhzQKgcp1rPs6o8pJWPqEk8iDQTsoxD?=
 =?us-ascii?Q?celLmvHkxpLA8ILxrkG3Tj5Z/c8BU+Fuq6CsBkIKX5YZAP8dBt58pkSOVIJY?=
 =?us-ascii?Q?PoLuCqJTtWNbmRIb7A8ihbQPWeTHmopJh0oQgkQ+IH3QXYrd5HfmgiKUk1j1?=
 =?us-ascii?Q?vNTs+KiM9tfaGvdQs+Ha+/9fW3ZxgZqLOmDt9OUkAToyl/bBXgejE85aKbl7?=
 =?us-ascii?Q?yFB0sh8dUCPpzHZGq4HcMxhg+i0eSHBjhYwQSD9hsTeSkQ4uFPrTZRElCoSB?=
 =?us-ascii?Q?QNhzEzXbPtU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D8k7PuGV99bM0c4oEpqjMkw0Q+r5kiG2Sc31S25omMo/58T1aUDYvelYZT1f?=
 =?us-ascii?Q?Ex4V1gbB7pqThtI1f956l4OANxFIF2el4oWFSG2Ebk/0lOGb2YJyoH+q3q0d?=
 =?us-ascii?Q?V+pLO5xQmKGWC78g52SJO0ZluwA9A8/4OW580+I8/VujM1ImpamZQz+LzNJ+?=
 =?us-ascii?Q?Urca2hkTfuJT8KJnjZ4jhGMKoS7votpv7rDhgbGvf4y9rG5xOF69/wle0wPC?=
 =?us-ascii?Q?JBZtwdLcbArJI26vswpnOaU65nN1pSD1+FJdVYY4LWdnLTaXiaUCVJ0AXiUF?=
 =?us-ascii?Q?7blXpd5aQWIg1q2NMK9gqVJdbyn5PD1etm/pL8ac8phLl0bPHFf7zLk6j6uu?=
 =?us-ascii?Q?kCkO79IElLw4MynRMl3DeOXCpfguE9Ft4+AOmuRUH8H4CoXXYSPI5GDy0FWi?=
 =?us-ascii?Q?nJ6WeguwAvbGSNGiOhe9jGpenA3FIlcbuCywW9Mdsh3u+UEo5ZqNm6aalC3m?=
 =?us-ascii?Q?CL3sb8PVSYF8z5uMa5EFmVpUFR2JhxJXZAzI5Coc4Qs0Y847QULA7R8p4RRk?=
 =?us-ascii?Q?taRZVRRxOovBeXSKhCLP01UTIVUlFPgcJrFdJaVw5sXFCumNjAVOoBJ3565k?=
 =?us-ascii?Q?lbm0TwGlRs2ljP3wNQAD9qR1nnYC1Y2Rpm3SAqr9gPxfBCD2JTrY/PzzEqpI?=
 =?us-ascii?Q?xCE7FijCkIdLknR1EaIXmvWOX5312fxorY6o5XMUzXTj08WKbdt0MSJWv1zV?=
 =?us-ascii?Q?eY3b7nXZ9qMP6caOrUu1q03NlectGXfKNWokKrEfyTk+FcUQHvLG/RrTeUiy?=
 =?us-ascii?Q?mNE4U6LRQQ3Pr+lWkL3vl1H4P8XVlAqswPZkQY6SjwadlBsorbZzpm8R79nt?=
 =?us-ascii?Q?lt+USl/CivNaoaYtcRd+16R69ci6RyAAl+ZR7sxpFHb88O6pcuh04Uz1IWRt?=
 =?us-ascii?Q?JArf04ma8X0eCVth7AZgybX0tUUitwmUmO5ceJPu7SaR2qfnHrmC0MdwQYv+?=
 =?us-ascii?Q?KaDMQKfKxYHx0IgHuTqhmotBSSuq50dJRlklJwQgoVnz+AQTtS3pMdKyytdf?=
 =?us-ascii?Q?UuN9BYMs4lmY15zCI2ft/B2U8ZESIoTzLL37qc6lzrrye0Vu8DCTv6D2Dv7T?=
 =?us-ascii?Q?PPEZwdpWdMR/XqVPwXMULBqQgUzXPJTIzhjyN+5ryBlFinglfwnPjMwngWWB?=
 =?us-ascii?Q?A6rtmB/324KlVRjgxgIWqCDODZpM5kUoh8WwYYU38mu5nHNycyoqWcoto+ZF?=
 =?us-ascii?Q?E73QbydYF4KvEMGPjRjKpm75Cwp6OAhPJPwTRVft4TDbah3Yd6j/kEeaqh6U?=
 =?us-ascii?Q?p0fYJe7PWsD/bhWT5cWyWGwh2VyR+ag7uRgSA2V5yibIjqEK+aFfRpIOlKLk?=
 =?us-ascii?Q?XIP5opu6/54PeEeUIeLA6qQQ1FNFMj6thlui/sBjOb5GhdvrY1zuCvS3MDkV?=
 =?us-ascii?Q?9ftonxj7jdNsytKZ3Q0MhB1JGQcKFwncHdC89COT7XfgMxAWB339HS730k9m?=
 =?us-ascii?Q?VsoLjtPEiQ4hkVbeIWpJ2L3wvhoe+mAd/UTM+inrDoDxlehNF/Uzezusf6NL?=
 =?us-ascii?Q?YLI2SdhCziroQ18Xbrws7lVcLsz8is3lqTKiZEv6ZwNfMa7jNHIOB6Snye7I?=
 =?us-ascii?Q?xzTikGIQXI5vwCl4Lam5Qa6tmVuCoXZduGVvHRzq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3253c606-fbc0-4447-8e06-08ddeb2d1916
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 21:01:48.6255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sw0eXwQIeGCgwzUjmery05REdDUKaYvkNtQKSkH7gslhP1eB1vLXNWcjTVwQIO/lRtRhZRe/8iUFkW/Iz9USgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4323

On Mon, Aug 25, 2025 at 09:33:09AM +0800, Chao Gao wrote:
> On Wed, Aug 06, 2025 at 08:45:10PM +0000, John Allen wrote:
> >Remove the explicit clearing of shadow stack CPU capabilities.
> >
> >Signed-off-by: John Allen <john.allen@amd.com>
> >---
> >v3:
> >  - New in v3.
> >---
> > arch/x86/kvm/svm/svm.c | 5 -----
> > 1 file changed, 5 deletions(-)
> >
> >diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> >index 82cde3578c96..b67aa546d8f4 100644
> >--- a/arch/x86/kvm/svm/svm.c
> >+++ b/arch/x86/kvm/svm/svm.c
> >@@ -5255,11 +5255,6 @@ static __init void svm_set_cpu_caps(void)
> > 	kvm_set_cpu_caps();
> > 
> > 	kvm_caps.supported_perf_cap = 0;
> >-	kvm_caps.supported_xss = 0;
> >-
> >-	/* KVM doesn't yet support CET virtualization for SVM. */
> >-	kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> >-	kvm_cpu_cap_clear(X86_FEATURE_IBT);
> 
> IIUC, IBT should be cleared because KVM doesn't support IBT for SVM.

Yeah, I wondered about this. The reason I chose to not clear this is
because we don't explicitly clear other features that are not supported
on AMD hardware AFAICT. Is there a reason we should clear this and not
other unsupported features?

Thanks,
John

