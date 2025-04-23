Return-Path: <kvm+bounces-43916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF584A98737
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 12:22:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DC575A2656
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 10:21:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4A79266EF0;
	Wed, 23 Apr 2025 10:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KlAChF1G";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pjTgCZpi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE29242D69;
	Wed, 23 Apr 2025 10:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745403718; cv=fail; b=r9HAHrGkwXWKUm1b08tR7wWdPsfVOeDQND0GJ7ZuUMdLgdBiOmDDJiVlK4HyOscFTERQUEOzeyr9AfbvjIltf0sosDP0asXm8vWJTk8mDNZo70t93aO4/9adT3PL/n4UEohRl51IAlRBkgUOUPyN9+FIntTBlU/SxfWrQgaH1ek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745403718; c=relaxed/simple;
	bh=5ZNXaWfyGjyWsKGO1yqunjyHCxQPNjD3JFaRbN987ZI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I3m45k9KlDg7AYm2hJcE63/Cd8PtJlpphqEnvXIraAClPa4guhi3Xi0QgVwwmOB22tsSwJwRWfxjZr8AOWddrFINCrwZvb9UcAxpDyo0TzFrsxJV9gEyDq9+zb4495i83CNi1pienlOQqnnc79YlS7+buGKiHw5fFfVNuUFTkes=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KlAChF1G; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pjTgCZpi; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53N8fnou030525;
	Wed, 23 Apr 2025 10:21:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=1k16YmgbhUXjU3fPMmy3Wj2OPh3c0GowQL+tt+nWjxQ=; b=
	KlAChF1GYi01iZnDTvSkGLFuyjGYx2ki7GSMP3wgb2OD6GWbeLg+Ux5xeZm1JbEn
	ZIZ9LbG/cebzJ6z9aUykIh6kKIldYmI633rs+p3Vw/pjlHDU3yz/fxqOiPmN8F28
	pW86IszosbP46JwYJ6pkXCIfY58M5N0v1oVBrjWIpbnkEjHO75EUK2FNhp1o2Yd7
	kSkGCNKVnHCCAFdRTtwW/rYAFcJ8f8HmFZIk93+txu8bRGNE980sTKykaNoPx9Cx
	8fub9wO+yKOgReKG5Uggb2oEPKZoLQf/xWU4tpaVnNeQuSB4go8lVnoh+zAyW7Ui
	bzhhx7Hran44lWxBRh+bkA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 466jkjgwn1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Apr 2025 10:21:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53N9vMEM030957;
	Wed, 23 Apr 2025 10:21:40 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazlp17013062.outbound.protection.outlook.com [40.93.20.62])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 466k05mx72-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Apr 2025 10:21:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WuCWpS/khn1YiNFGFKhdEZ7/oVow6G3L+xBAB/BCo4Jc7KSNzm4gj0CQ+UqLSxfBPAiKlZuVflXBOyzMwuuaGkx6nIE0+3noMCOyHdlc1w02XGB42nxuoszmh4DfYBu+vBvRu6A+cHUfTVo0UEPNFORKYN07yENXTp0yvcjxFcibtqm94g+5EmiApl2a8L857BIePsTcQgcqq0PmeK7TGlxoZ66Q4ncIvtFcoaeWLfktD26Am6vsJdUDPzpq/LEuphsDSPjPNxe1DnuWhWDCl3czZ86MKqP9Mq0zpUSeGR887Kv90bJt+J5j+ifWG1GsEbS1slF5r0l2WdeIVwRkHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1k16YmgbhUXjU3fPMmy3Wj2OPh3c0GowQL+tt+nWjxQ=;
 b=Rv3lg/MUypbMfdjw7wp0i4NNQsDzV51Q4HLLlUz0BEyqSfUqAKmowKT5iCDnVkzoxyNcIYVQ2W7bAbbR44clRX6tvDbBvME5aya5GCsUvXwx/F8P/+Zhp5z8zZs9+Kdr9QPhnJXcSqWXsGHQ5QR8CIUk27M84pOb6MrVivyPgZFHe4zvfycYKHtL6l+u6FckQkyAhZWpBKhNarT2nrzS84dpagCrNItCOMbcNFIs7jSgKTuC/w9rRjqU8fIvobLumox5TeytYv+PyR9zBBKbdtrNuWiScMrwT/NJDDluNq86RaBq9Yim8bRPRW/ZapGGAZ2zBLCT8c7nvt4hdTExzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1k16YmgbhUXjU3fPMmy3Wj2OPh3c0GowQL+tt+nWjxQ=;
 b=pjTgCZpiDGN9h1f16L16kDM+gM/c3W6gynFsAvC93aOuBuo41evM4sqLQYGFXqjaDzaRl2iMj2wRY2d+FwFDf6eOkF7gnSH9O3Lz7kqeYc3leMhfzTTgWXiot7Vihm1uaCsYA+hfLe392+gDg+NDExra8L0TjCFTo4psrgKKFQQ=
Received: from IA3PR10MB8735.namprd10.prod.outlook.com (2603:10b6:208:576::20)
 by CY5PR10MB6117.namprd10.prod.outlook.com (2603:10b6:930:37::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Wed, 23 Apr
 2025 10:21:38 +0000
Received: from IA3PR10MB8735.namprd10.prod.outlook.com
 ([fe80::396b:a1bb:fdfc:d599]) by IA3PR10MB8735.namprd10.prod.outlook.com
 ([fe80::396b:a1bb:fdfc:d599%3]) with mapi id 15.20.8655.031; Wed, 23 Apr 2025
 10:21:38 +0000
Message-ID: <fc722315-bc9e-45c6-9aad-3b64b04404bd@oracle.com>
Date: Wed, 23 Apr 2025 11:21:08 +0100
Subject: Re: [PATCH 64/67] iommu/amd: KVM: SVM: Allow KVM to control need for
 GA log interrupts
To: Sean Christopherson <seanjc@google.com>,
        Vasant Hegde <vasant.hegde@amd.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-65-seanjc@google.com>
 <9b7ceea3-8c47-4383-ad9c-1a9bbdc9044a@oracle.com>
 <b29b8c22-2fd4-4b5e-b755-9198874157c7@amd.com> <aAKelotoUX3qCINt@google.com>
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <aAKelotoUX3qCINt@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0016.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::6) To IA3PR10MB8735.namprd10.prod.outlook.com
 (2603:10b6:208:576::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA3PR10MB8735:EE_|CY5PR10MB6117:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c7cad7c-2519-4b62-433d-08dd82509fc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VzlGMUR1cTFNeHdmYm9MWktHMVpJdHFDVnVSaUNLbHVabXFoc1JVNGlrcCs0?=
 =?utf-8?B?bE9CTnZrb2thelBNMFZHMjgxNjhycHNHSmdtSXJvbXJoY1hOaGQ3Q0VKNkZZ?=
 =?utf-8?B?Ri9yMm80MXdoTXpCS2RvbWlkdFZIWjhYR0kzamMrRkdEMzB1b3VtSmlaMGp6?=
 =?utf-8?B?VVRMQWdieGkzUXZkN0xmZzdTTnRKU2NubW0rdUhUT0VoNlhFVklXR1F6R3E1?=
 =?utf-8?B?SWVSMGFubFg4OXdoMkZhcHNZZFFWYVI1aWphWk9lVmIrL2gxRllPbWM2TG9v?=
 =?utf-8?B?dTJ1NURNa2k3Q0xhNEZFTk1TcDFmNURSaHdkTFNWMUNwWUhJeW5VYW9RL0R0?=
 =?utf-8?B?MmdLeTFQSzR2Yll0YzZaeFZnWm9SNEFQZ0svR2RiYkFHSmlzSUQ2ejA2SHQy?=
 =?utf-8?B?WmVMM2ltdlZ3RlF4bEdJdXc2NWpYYlJlNkpSWTljVUhYbkNiWGVuSDk0R3Ir?=
 =?utf-8?B?YWJHcEIxNlhEUVcwK3ZINHFFNnZCSGxpVUtIZTN0SkdXdVZiUjlPQ1VzMkF5?=
 =?utf-8?B?a2hRTTJaODhsSFlycHNoZFpvbG02eHV1T2M2SVRhaXFsSVRzbUFPMERpSE9B?=
 =?utf-8?B?M05ITEN3NGpYWjJDeGRJRit1MjdKN1RKTG5TVjhSK2NyRnk5WWFNcU1kbjhY?=
 =?utf-8?B?dXJ2T1Y4bHl2WjNvSzZ5d0Q4M2c0dG00MXVYQXVVM3E2UEpTbEE0MFdtQStw?=
 =?utf-8?B?cE9GWmV4aUVvWlFGczQ1bklhcDJNMVByYzNkWmNMdzB6ZUlHWGhXMFRIaTBS?=
 =?utf-8?B?TmhjTnhPY1pBSTdidmM3WTlra095cThuSVA4N0RVT2JVeGtFYjUxcXg4QzJn?=
 =?utf-8?B?M0lkRmxVTEoxUzFwcUpaRHh2VkVkWG5KZFlKOHkvNnZIZnV3QytNUFFJQ1U4?=
 =?utf-8?B?VjFSZGN5bStkWWpsRlcyVm9xczZwcVVJQlg3MTZWb0hyK0Y4QUIzdnZjdEZP?=
 =?utf-8?B?SDRPZndoRHZMajBFV1A1TllBZ0V0N0NRT3lqajhBR1Y2Z0hkVFE1R0FTa0Zy?=
 =?utf-8?B?dnh5RTI5NWV5SHJqNE9idHVzeWtBSXhUR0hjVUF1M3ZPWU9QOTdITlcyLzJF?=
 =?utf-8?B?MjkwSG9rRlo5U0hhblE1U1dpcmtSWDNsK3VTdVpBNmgrREthWlF1VjVYQk9y?=
 =?utf-8?B?K01OcGZ3U2Z2bndncGwxNTVraDVYZ1VGN3RQYjg0aVhYbzVycTNKcS9HVVdw?=
 =?utf-8?B?czl1dmJXYTZhLzZqTDVwV3Y5VTd4aG8vSHZERWZxUkNodFZ3Z2hUMDM2SDJn?=
 =?utf-8?B?S3d2RGx5NDZ5VFBsN1RtQzB5OERqRy9CMlZhY3FmYnRtVUp3VE9PQ3RTVDF5?=
 =?utf-8?B?TWhCNFRIY2JwWmcvbno3d1pKZ3pPejJLTGtBRVZDaXRMZWFpN3g0bWUxOWJM?=
 =?utf-8?B?NStjeVhVbDV5TnIvTk9meGhuNUN6dFlUYUJsNWJSa2EvQ1pOaVo2TU9NYkNN?=
 =?utf-8?B?UzZFUlVGRnd3Y3U4ZzZ6WTF5bWIrUVFkV1lod2ZXTlVjRXN0UU5JU0lMZ09M?=
 =?utf-8?B?RVg1ZHhZakxSVDA3UFBLM3dGYWlWeEZsdll4QkRNRDdjdHk0b3hYZ1pDTEdF?=
 =?utf-8?B?TEt4N04vWnFDUi9mNHpjc2VqWDhJRWtYK0NLZzlsVmlUQXIzWWVJOWl6dS95?=
 =?utf-8?B?b01wL2VMTG5nUjhTWEswbUU2ck10V0t1VHc2WHh6MnlaeS83Z3VON3Bpb0s5?=
 =?utf-8?B?SVhwR2tpMHIxblZJL0FoNi9rWmx0cG9VUFJ4Z0NqdUNRVHhJejVjYUtTQjNt?=
 =?utf-8?B?cmJpTjVlSExsZmlDWElqZXNkSzczTjRKeEVnQlRWb3pnVnlBaWc3cmY0UDFu?=
 =?utf-8?B?dU9qRVE1dkdmMEkyeWFpajEwbEc2bGdvZER4MFJyRjRmOU5OeExFNXJOc3Qr?=
 =?utf-8?B?V2MyMDk1MlA4OUpTRlZnQVJ0azk5dFgxNkNGdGtjQk1uSXBwNjRwaGR0RE1o?=
 =?utf-8?Q?oUQgqfJNz8s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR10MB8735.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dG1mbDRnNlBmWGFpMHlLdnpCWFZlSmpwYVVaSGx5RXVNUFdOU2tlTTBaQjd4?=
 =?utf-8?B?dXE1VzlpZnlzT3pyaVRXcGtyanNQZWhJUmR0bjVTazRoR1Vubm1KbnUxVjlh?=
 =?utf-8?B?aUhLaWpBU2NhTnJobm8wL3BweWVpNUVuNFlqUUpsV3FJRTlYUVFaOFZYS2s4?=
 =?utf-8?B?eDErOGt2eEZZNVJIZlU4VnRKMGVJWnBOTUZmR3lyWmhWbWhuS3U4YmhJT0hG?=
 =?utf-8?B?K1p0cTRoWWlPdzlnNG10SDhRQllGcFhsN1VjQmxwRzNjYlRVZEpvRHRYMjF2?=
 =?utf-8?B?TWFOQU5ndWhCSzZzS2h1aE5CL2ZLYU5BUXN2blBWT2cwSzFDNXZUdjk0aVdq?=
 =?utf-8?B?cExTVW1qVjFxNHRBNFV1VWR1WTNqa3hIakRKVmw2QlRYS0JJREhabm9oWDJD?=
 =?utf-8?B?NHVkTXJTbG1wcFZzUUtDRDFsdVY3NEc4TFo4MjdnZXJrSGpsajVLUDluU1Fw?=
 =?utf-8?B?aUtkRitrLzArQko0ZUQ0VThkQUFSSDdZQVNuS2psTzFTWjUrdndndnYrSEFk?=
 =?utf-8?B?YUgvM3ZPbjVNYXMwTEtSMHlFUlFGTGUzdU90ODFaM25OdU9hZUsweldwMytr?=
 =?utf-8?B?UnVDM0w5dXBxblUvK0RGZFFCcGZzZHN1UkZaTE1IcDN1dVYzY3duOUNrMkRz?=
 =?utf-8?B?THRiSFNIRzlFbitvYm96c2xFTy9zNGkrb0UySVZIZjlES2syWmlNQUorRWZI?=
 =?utf-8?B?aC8wbGxXU1hMdW1KZm5FZkNpelpzQlY0K21kZkpaZ3B3bk10MjJiL2JUdEpa?=
 =?utf-8?B?U01neXFXWTd5S3dYRUJXbjVhZEsxaUpDNzVwRnlVb3ZmQkxpNzgyb2h1ZUdF?=
 =?utf-8?B?dVBKdWNPU2wrN0s3L1pRQW5wZXcyLzZuaEVmVmdTZHVmZkFJM2ZJYjV4R0Nv?=
 =?utf-8?B?WGxXQWd5ZE12aFMzQ0h0dk9DRDZZTWd0ZnQwaTdtVmk5RzBjZFpEbStjY0Vo?=
 =?utf-8?B?cXYxOEJzKzRSUWlMYWlpZUMyTjFxektGdnpnOXZXRS9HN2s5QXBtQ3dhKzBT?=
 =?utf-8?B?bEt1Rmc1Z0R5bTZkQm4rbGRWalVzdHFWRHU5bGNXUVlwM1ZJRG1mMGtaV3BU?=
 =?utf-8?B?Rjd6YjllMHVNMTh2bS96VWZVSnpBbzAvNDdSc3FiWTcvcG5iT1cxV1NrY2V6?=
 =?utf-8?B?Rm1TQTI1RkMyb0FBWFVhUitldE0vNUxIMDFDVThVK2xmRXZjSFdHSS91VzhY?=
 =?utf-8?B?bkhZRkpKL3JHZ0o2TWlndUUyRlMxR2FSa0VmeDFBMW84bzU4UnFxUUNMNTNy?=
 =?utf-8?B?OUdnN2pPelkzUXNnbnV1V2V1elgxSVRudG1QV0s4bURzWUZGSEF2YUFWdEMw?=
 =?utf-8?B?S1IzVTFlbDlyc1RyZVZRd3FRbEFUWkNnTEVnazJ4enEwZEZTVk9qN0tEaGI0?=
 =?utf-8?B?cndPV3ppMWJyZjFSMkE4WDRRKzBxdGN6bXhFLzJySWN0cHh2Q0RiZ0F5SWxm?=
 =?utf-8?B?M25hN0EzNjVEUlpQcWNuMDR6eWlpZmNlTGt4S2huaUJlemptdWJlbXQ5UUFV?=
 =?utf-8?B?d3VIWUM3UzkzWjhCTGsxZGZGVkxPTDZ5aHR0aHJTS2piK0NxNmhjRGR6cUFN?=
 =?utf-8?B?emtoNFNwZHptQ3dkS3crS2pQMXMxdkQ5SmdFRTZIOSszbkJtU3N1N0t4UWFx?=
 =?utf-8?B?NnBrbzl2akI0cXNKSE1qV3ZTbmFQeWorcURaemEwYkp5MTVkQlJyZ3QzREVK?=
 =?utf-8?B?VzJmNjFNY3g2eXJsa284RWdXWk9adWlxbUkxWUhHSFNIUmlYQ21vRExBeWdr?=
 =?utf-8?B?TERHRzJndzc4QytFVkk5blNYb0JLVEtySHRIZndPOXB4RmxqVUhEZUxNa2lP?=
 =?utf-8?B?SXlyOU00MjVpZ1lNU0p5WHlVYlVlSDBPQzBHTXA4eWtvbkNkaWRiYlM3aG1C?=
 =?utf-8?B?QUs3Vy9IMmZjelR3VXZvdDFFS3daRXpqaU9LWlA0YlB4NjVrN1AxbXJOWDRI?=
 =?utf-8?B?NmJzek1NT1h6WnZhTFdZTFRGNGp5RmY4Qk9aR2cvemh5ZXYxczlndWh0QkYz?=
 =?utf-8?B?QVo4aE9HWWQ4WVVYd25RaTR4TXhYNSswRDZTUzhramExeGoxUHZTNGpQbkxr?=
 =?utf-8?B?M2ZVTHczazBpcGdxdVJ0MVBMSzUyZUhYMXBZVmp2ano5NmhYOUl4MFdwM0k0?=
 =?utf-8?B?aUxFVTlYTkVwajl5STZkMWhPNVhLNFd4K1ZzQ3J4ZlJNK3U3N3BDRnB4cHdk?=
 =?utf-8?B?MXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5YPriWEseMaSoiSOcWWDJe4bXUXiCSRzubIasca/pJPtXIaz8+LyJIKPT2rWSiJkMIig8AGr99CYA5IlOHxE3hQqju5XTaWlFlOs7PSAbzvOO14eel6m+/0mTJinptwfAXTbfI4CQdmVJo9SZ4sgK8B3LR0gRNUsYKgVgb7nnd6S8xBqQdPhvgnDvsnNGbNzULnscpMT9ytCemILfxB1Zgza0Zafpl+9dmcpPLDO/wMxsaHa86Uut0ABRvWn7dI3t73kK2DVwf0W3QWZIsr8kSZRbMPea5bVvIR1w8HjdJkb6mKp/JbbjL5KraEK89ajfhRZOL4in5UAJ/a/R3FdBU271Ec/1Z5XoNKDszbno05UZ5qA/Evj4cgUqQZhbipHgqoUz0SA6H7d7qKr1WN4IYzPUaQsL0floxz2gGFcx8eaFSVHzFfTmBchxJhSt6SXk8Ysehes8R6s3pyYyx+Gtc2CaIF0zg8RWuHjCvKaGYT26GDer5ToxHEl6Gb7OFRKli/3jPEhgCaHyUAlv4+KUEk7Zb76o9BhNCfboprHSVfD2+GT8SZbgOOZo0VuTg+hiMuvpA4inIvXS5oxUTeLxoYkuKYE49UCADCT0dwYmTI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c7cad7c-2519-4b62-433d-08dd82509fc3
X-MS-Exchange-CrossTenant-AuthSource: IA3PR10MB8735.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 10:21:37.9493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ge3RqzPXp9NiYXT6dQAbsouC+krOlftumxbhGLSzcuIA+0PsOPfTydcluJei+qAYA/O0evd7nGd3lhPwUa/vRhijT5PMhge7S42Ost+jNZI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6117
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-23_07,2025-04-22_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2504230070
X-Proofpoint-GUID: lMQLagew8Ag2OrjabXD7DY_pwJzYOeec
X-Proofpoint-ORIG-GUID: lMQLagew8Ag2OrjabXD7DY_pwJzYOeec
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDIzMDA3MSBTYWx0ZWRfX04HSG3aWIFva /dTHv0gpnfX/DN57B9k1GOZi+UtCGAif9NhNU9q2d3yEBvWY2o3BrK3YqXlB1v9Pg+EdzN888IY 0XHFiTwE4Sx5KRn21Y74C7ShXgC80aCo4RQoLW1mb9V0S2irf0oYdQmAGm0yK8imFWoKAw0kIo2
 VD5rI28HaVVuJQDl6ztz00Qc/4oV3V+lj/UyspmOLTcH/QgDfi1vIH92hIqQn+II4hGS6PzOq56 Yaug4R0JpzoM+oth4sk6syMYRWnLMKT1IIsBsZSMhGp6JrXUSKRueWmqoie3uwbwrQsZOAOM7Jt 05nq4SoXlcG9rvVgTloCLmBTvJAS1yMqTrhX+/LOCZLsB8h34P1fyTQtXOcFopqlwtl8krgwJu6 Q2t4Gugx

On 18/04/2025 19:48, Sean Christopherson wrote:
> On Fri, Apr 18, 2025, Vasant Hegde wrote:
>> On 4/9/2025 5:26 PM, Joao Martins wrote:
>>> On 04/04/2025 20:39, Sean Christopherson wrote:
>>>> Add plumbing to the AMD IOMMU driver to allow KVM to control whether or
>>>> not an IRTE is configured to generate GA log interrupts.  KVM only needs a
>>>> notification if the target vCPU is blocking, so the vCPU can be awakened.
>>>> If a vCPU is preempted or exits to userspace, KVM clears is_run, but will
>>>> set the vCPU back to running when userspace does KVM_RUN and/or the vCPU
>>>> task is scheduled back in, i.e. KVM doesn't need a notification.
>>>>
>>>> Unconditionally pass "true" in all KVM paths to isolate the IOMMU changes
>>>> from the KVM changes insofar as possible.
>>>>
>>>> Opportunistically swap the ordering of parameters for amd_iommu_update_ga()
>>>> so that the match amd_iommu_activate_guest_mode().
>>>
>>> Unfortunately I think this patch and the next one might be riding on the
>>> assumption that amd_iommu_update_ga() is always cheap :( -- see below.
>>>
>>> I didn't spot anything else flawed in the series though, just this one. I would
>>> suggest holding off on this and the next one, while progressing with the rest of
>>> the series.
>>>
>>>> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
>>>> index 2e016b98fa1b..27b03e718980 100644
>>>> --- a/drivers/iommu/amd/iommu.c
>>>> +++ b/drivers/iommu/amd/iommu.c
>>>> -static void __amd_iommu_update_ga(struct irte_ga *entry, int cpu)
>>>> +static void __amd_iommu_update_ga(struct irte_ga *entry, int cpu,
>>>> +				  bool ga_log_intr)
>>>>  {
>>>>  	if (cpu >= 0) {
>>>>  		entry->lo.fields_vapic.destination =
>>>> @@ -3783,12 +3784,14 @@ static void __amd_iommu_update_ga(struct irte_ga *entry, int cpu)
>>>>  		entry->hi.fields.destination =
>>>>  					APICID_TO_IRTE_DEST_HI(cpu);
>>>>  		entry->lo.fields_vapic.is_run = true;
>>>> +		entry->lo.fields_vapic.ga_log_intr = false;
>>>>  	} else {
>>>>  		entry->lo.fields_vapic.is_run = false;
>>>> +		entry->lo.fields_vapic.ga_log_intr = ga_log_intr;
>>>>  	}
>>>>  }
>>>>
>>>
>>> isRun, Destination and GATag are not cached. Quoting the update from a few years
>>> back (page 93 of IOMMU spec dated Feb 2025):
>>>
>>> | When virtual interrupts are enabled by setting MMIO Offset 0018h[GAEn] and
>>> | IRTE[GuestMode=1], IRTE[IsRun], IRTE[Destination], and if present IRTE[GATag],
>>> | are not cached by the IOMMU. Modifications to these fields do not require an
>>> | invalidation of the Interrupt Remapping Table.
>>>
>>> This is the reason we were able to get rid of the IOMMU invalidation in
>>> amd_iommu_update_ga() ... which sped up vmexit/vmenter flow with iommu avic.
>>> Besides the lock contention that was observed at the time, we were seeing stalls
>>> in this path with enough vCPUs IIRC; CCing Alejandro to keep me honest.
>>>
>>> Now this change above is incorrect as is and to make it correct: you will need
>>> xor with the previous content of the IRTE::ga_log_intr and then if it changes
>>> then you re-add back an invalidation command via
>>> iommu_flush_irt_and_complete()). The latter is what I am worried will
>>> reintroduce these above problem :(
>>>
>>> The invalidation command (which has a completion barrier to serialize
>>> invalidation execution) takes some time in h/w, and will make all your vcpus
>>> content on the irq table lock (as is). Even assuming you somehow move the
>>> invalidation outside the lock, you will content on the iommu lock (for the>
>> command queue) or best case assuming no locks (which I am not sure it is
>>> possible) you will need to wait for the command to complete until you can
>>> progress forward with entering/exiting.
>>>
>>> Unless the GALogIntr bit is somehow also not cached too which wouldn't need the
>>> invalidation command (which would be good news!). Adding Suravee/Vasant here.
>>
>> I have checked with HW architects. Its not cached. So we don't need invalidation
>> after updating GALogIntr field in IRTE.
> 
> Woot!  Better to be lucky than good :-)

Probably worth using this thread Message ID as a Link: tag while the IOMMU
manual isn't yet up to date with this information. That usually takes a while
until formalized.

