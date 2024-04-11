Return-Path: <kvm+bounces-14263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 23A1B8A174B
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 16:34:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50F661C20F2C
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 14:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F8DCCA73;
	Thu, 11 Apr 2024 14:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E0ldvbvO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Sr5w8ETZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC87A4A0F;
	Thu, 11 Apr 2024 14:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712846046; cv=fail; b=rxN7Z1z2veQwoNcuFnmbJow0JEglqSxyxHB2XDNV/4PZblY6+Yq5cjkSx7J61F0NJaYtfTiHyAzzduotCuNdlE7+yapSxdgBxxgNq6QvwieCOjB0zI9n7r0LieHSjbHjBTVeT2bR5aSrV96sAlDjEowAjrim4Lmou6jiL578YIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712846046; c=relaxed/simple;
	bh=XnZm3iewd80LsXOGIvZqZQ24q2AUGcxNkEisNsv3AWQ=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qW7TlClc10xMlVtvhwDl+kUBPUwpEX2eGe67t60rFteGeiIgYSeNveW3zLnbtsMG6COvIlY5c1/IvkWT98xgRJJl4CyTflH8fdYFWR3gpoRFMuvpn75wD4jVoCJkv8T6YJ92URhpu6B3UP+chNJy85MVRVKLUVXMtOnd1pmkDDg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E0ldvbvO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Sr5w8ETZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43BDxlaJ013733;
	Thu, 11 Apr 2024 14:33:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 cc : subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=xDiO5O4FsrWLFI5sj0LiSbRGqI5bxJvsNDijtuGfHuQ=;
 b=E0ldvbvOuKgoxyjJFnqiGcjs+0GwQ9udD7QInSMfqCeaO3qrRZ7ny4Q8DGjtJ9xtLRAs
 R/tcRiuYcYALNbdZFGrhLPXxejhQX1ixvWHgtVB+7CXxEJFaqk52pJ82+6uXlMPQQhYN
 Y8/zRHyXsIS0TTUsWf4I831qiMhYKdjw7Fc6/lRlj8ALfV2YG8BWZuBn4lYi+K9cG7Ih
 2t/NKydvnFzS24XDHvGUEYlIRcIbFz+J2pCr4/DufSYZ9SuBJvQ59/xTRs527LTVRtc8
 tctOlbEBU8L9oi6EdQ7meaqpNkoGIsb0UCqJpX3w8ZZRB+sline9r+X7NZKsf+qgSIgC LQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xaxxvhsf4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 14:33:31 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43BETulN007902;
	Thu, 11 Apr 2024 14:33:30 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavu9kneh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 14:33:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/qm3IVUwb/YAhFAu0kMS/v1YVbyjIRqYMg9zoEqS5d8oUdLU3+Az9KEAdAkhmGzdeK8H36+cIDlcmDjRck4jvTFyLCDoppgc0KaWjPTCdTgyPbxFfbAtuMQq941ev8CG3ViHrjnkhsNezUshISOmMUjwcA278TfIjL3QW9WgvyrR7WuDlmDdS+bMq2/wpZqd/B6Su61t43ZzDsAUqiRS0YrLMyy5onr1QRopNO466gnCvR83gRabJpH/ePByG4Phui8hrOnEsg/EoBlAhKrVmZdAXghWxP8qp/SoxXM34xP88qAgl2mNq7rBbMEN/+wcKyBRWRWWCG6wQUos6qlDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xDiO5O4FsrWLFI5sj0LiSbRGqI5bxJvsNDijtuGfHuQ=;
 b=WWYDYBPlc5sWvjuerw30Hg4Itx4YvjbbEXg7mBLCNr2lYKEpptDoyRsN7aCAqfMPm90Vhf2kJL2eIYWRGXZS7wxqvIfVDemRUI2GK7ZDptUERGULhfFKIWEPWo4VaR/zT+wrbac6N9eAJeeZrh7VCbaGR7kPsHnl6HtbtRGTAGKJn/9zk9c9N49lTJJHnm468cwvzc8NwyA/R530bkG0wAI8bFkRHKwrEMBNsMibzLh/9I5NO1zMOAj5hjjsnooYD4YTuB4oS5HmskH1db9/aA/HNquaPBn0ycv/eJPSYp81XeD8Ky4AuY55R64H4UVMJGUSijzleq4TqtS2lkm9mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xDiO5O4FsrWLFI5sj0LiSbRGqI5bxJvsNDijtuGfHuQ=;
 b=Sr5w8ETZ/b7vfzfsnx0lQmpVSB+Le8MkHcXOQK5sPUIn4wK4oUuzrBfjpapswPlSyFV5cx1yQR6JHvQN48sX7mRAdM4oGU7J8explcokbyL9v1/zxaYFMXF+r7ITtTZnpTUUmh/4GYJItvjeab+VxN+JQVa+OehDRlymDm3AIwc=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by DS0PR10MB7295.namprd10.prod.outlook.com (2603:10b6:8:f7::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.55; Thu, 11 Apr 2024 14:33:24 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::1481:809a:af18:ac44]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::1481:809a:af18:ac44%5]) with mapi id 15.20.7409.053; Thu, 11 Apr 2024
 14:33:24 +0000
Message-ID: <ff3cf105-ef2a-426c-ba9b-00fb5c2559c7@oracle.com>
Date: Thu, 11 Apr 2024 16:33:19 +0200
User-Agent: Mozilla Thunderbird
Cc: alexandre.chartre@oracle.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, daniel.sneddon@linux.intel.com,
        pawan.kumar.gupta@linux.intel.com, tglx@linutronix.de,
        konrad.wilk@oracle.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, seanjc@google.com,
        dave.hansen@linux.intel.com, nik.borisov@suse.com, kpsingh@kernel.org,
        longman@redhat.com, bp@alien8.de
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
Content-Language: en-US
To: Andrew Cooper <andrew.cooper3@citrix.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20240411072445.522731-1-alexandre.chartre@oracle.com>
 <7f1faa48-6252-4409-aefc-2ed2f38fb1c3@citrix.com>
 <caa51938-c587-4403-a9cd-16e8b585bc13@oracle.com>
 <CABgObfai1TCs6pNAP4i0x99qAjXTczJ4uLHiivNV7QGoah1pVg@mail.gmail.com>
 <abbaeb7c-a0d3-4b2d-8632-d32025b165d7@oracle.com>
 <2afb20af-d42e-4535-a660-0194de1d0099@citrix.com>
From: Alexandre Chartre <alexandre.chartre@oracle.com>
Autocrypt: addr=alexandre.chartre@oracle.com; keydata=
 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
 swLliy6PdpST
In-Reply-To: <2afb20af-d42e-4535-a660-0194de1d0099@citrix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR3P192CA0024.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::29) To SN4PR10MB5622.namprd10.prod.outlook.com
 (2603:10b6:806:209::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN4PR10MB5622:EE_|DS0PR10MB7295:EE_
X-MS-Office365-Filtering-Correlation-Id: 39c3074f-f015-4566-5fca-08dc5a345808
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	euhfE7ju/LCDgoWJbamS1/YOqDMjWHIimBctKKcdl3OqW8C4qd+h2pLRrKYeZLfzwaQDiSDrxJFFB8x+1pj0qO6WDiHGmheE/m9PaybKk/vWu1g2snJ+Kepm+9pOqgDZL/4ll9WCJHQRRXSmc2MLPvlxqA0uenQKdlxYWYDVnvjx1XipxT3+GaLxljol/7x7rcRRlEU3cgtsKF46MOFJhTpV7Hgcmn0qotQDfG6e+u2xvjqGTDqJ5cLbkbqrTuFR4wrwQ5XbA7XeQdngcJXJIinQ82mXcVjvcls3vl9Dj3NrXxBwUX36oZ+Jp+NYry+/ENBypXK6xzCGkfn1+OUnHlfbb1dSVrDLDoKyzMT6gj16MqGAjN2mcBaNaNW288S8U9z1dt2cl9hY0aFwl5PPHyKs78Csv4cE2Sp0uJP9ioDG7wwRfZ9Cz0rR84O/0QolPxrHtRbLuc/yhBKqEAFunK2nSeV6J0+2YIyhmJQc3gsLWojfZ2fzuE44/2AA+T2DM9+rFLCRKQrasyTSKXrmjo8nGIfVTk5ndePGtXg2fmksSuGQENs8TVS1acocl+KurCyAHdE1feoo7qgzy9lCYRlaxziK37f0yoZmgQ8XfFY11sFgS4Npq47dA+KmdB4lyXA2rOEfMHsJBdLHdfvpN38BjMxfOYeXArZ2HutnD4o=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?QVRJNktlcjVVT0kxUGluMk1Xem1GQTRhNDZOclVFMlBNSHR0M3BmSnVWZTQ2?=
 =?utf-8?B?M0hhaVRYRjd1RUJMMWJwd0swMlVETXgybUVzWEJ6U095Sy9tMmM5cGo5VWJx?=
 =?utf-8?B?ODRsK000bmc4cDhKTUFEZndFZ0E3VVdqTjIzRkxQYUdNckcyT01RU3lobEd5?=
 =?utf-8?B?L21WUlVlZ2p1ZE5aVlp0eVJCTWZpa2NGWlk3TGhhQXhETGJ0Y3NRaUlEQzR2?=
 =?utf-8?B?SGkydC9CQmNlZ01VaTVjVmZSYmluckdNSURFNTZPekVhVDRsYjhYWEhubVEr?=
 =?utf-8?B?by9xNThqR2R1VmxzTWg0Y0o4cUtpY05WVWV0a1JYckNKWmlPdU5wNDBMc1lI?=
 =?utf-8?B?emVvSnV1ZWpFa0ZPZzArbUJEQ0lPMTVsczVzY09mTkJpTlhpQytQZ2lUSFht?=
 =?utf-8?B?R3YzajdVd01kdDhhQ1NHOGY3MW1ScjM4MDdJOGJNN3V4OFRNc0hUS3M0VDJJ?=
 =?utf-8?B?VStIenBwSE5WN01UclN0V3dsZnhLakdzbE82cUZhcTF3VDRFMThmZkF2a3FQ?=
 =?utf-8?B?aHNESkJaSm1scDI5MURwNmo3Y1hXRXBWcU5PTmxDMjFxNzR6S1YxdVdpeFZa?=
 =?utf-8?B?TkpKdk84b2dRUzdUK3FPZFJaNjhqQzMvN0pFSUhJTlpyYlJzV2x2Sm15cit4?=
 =?utf-8?B?MVFDWjM1Z3pVTUNYMTVFYk0yMmtxdXI4REV6RTU3bC8vMHFXa1FuTkxtRjRu?=
 =?utf-8?B?TFB2cis1dXJaT0w2dUtSamg4SGxVSVppMGQ4SisyM3c5VnNtOXNjcEpzdXhy?=
 =?utf-8?B?ZEdiWGdxelc0Z3hpYlF2aVUrQUVwTjZyb3BwaHE3ZXNaNEhTNlF1blNkWFZi?=
 =?utf-8?B?ZWV6dnhUSG9xOGdFT2I1dUg2eVc2RjNZRjR5alArcXd6OWVXckdZa3Z2aVkw?=
 =?utf-8?B?WVFDWThza0JDR3dKMlJYTGlCeWczSWJvREhxSy9QM29iSnJ5eWJDeFlJUTFN?=
 =?utf-8?B?RFRpekVqU0FUZEtFYXg3alY1M0x0aWhGMEhJeFpHc0x6TmQ2YlZDd0ZoekZM?=
 =?utf-8?B?Sm5VQVEzaG9rMTg5YXZ2S0NicHFEMWF5MTBvVzVNbU1SWE1ROHBjKzlXRUJs?=
 =?utf-8?B?QTBKVTM4RUtRZ1QvNFpmd1B0Y29TTU85WDY0cnRnQU5kVzFvcFltVzQ2RWl6?=
 =?utf-8?B?eHlJQlBaZEcvcldyL25tZEptVFY0NzBQZlNPRnhYby9NK1ZKWkh3aDBvTFRD?=
 =?utf-8?B?SEVKL0VQUmdnYklnbG9UdHdCQU40elZBMlBaMHFDdWZLZTJ0WU5NWGhxVExE?=
 =?utf-8?B?OGlVeHVjM1ByaVFYNUk4bmRreGxiUjBCSlB0YWdUenRLT25zMDhvdHY4RDgz?=
 =?utf-8?B?ZUFYSEZRLzdpNWRtVlFqTU13YzBPeUNGZllSZXhRQ1hKbGJHeDR5M3Z3c09k?=
 =?utf-8?B?ZitJc09iSDErbW42cnFPMCs0Y1l5SUJsdnBKQUxSblhDWTNIdFhjd01VaDRD?=
 =?utf-8?B?UlltK1A5Yytra1czall5YTdKY3IrR3JUbmdsWjVORWk2RUVUWnQ1OHAzQjhI?=
 =?utf-8?B?MGI0UzVSVEpObC9jNTNKT0FmZC9lWnNhNWt5a3crYkVSS25ha0lPNmdrZU5n?=
 =?utf-8?B?Zjh3dkhGa3hxUzJzaisvYkNab0R1aDlhZE9udHVQQW04Vk5jMUtEMmRpR2Fj?=
 =?utf-8?B?RmlDcnpmaW0zNmxGNGhpeXZOUnZ5aWpPd2g0QThwSnptYTRZc1Njd09BU0l0?=
 =?utf-8?B?alRGMlI5S0JDOWZ2YXFBNnhDclVCdzFybkg4NW1DdGpEK1RGWGgzSTNIWmo5?=
 =?utf-8?B?Q2lzc0MyWk1DZHBaMVg3YUg1MW5tdnZ0TWMyMHRRblRNRjV2YU03d1NDTVZo?=
 =?utf-8?B?SEJrV1hQK0xFRnBHNFdJQjYyeW9aZFZpSVRGM25LY1RvU3BoeXVyQkYwd3F2?=
 =?utf-8?B?RGxoSE52ZnhDZUx5alZOZUsrY1k0UmJYRThjTFA1RGpaL0FZOWRlVHE5Yy9v?=
 =?utf-8?B?cDhueGFaQlNDVW9jUTVoSW5PdS9aQ0VVbFQ0ZURYR1NXL3JQMVlJcU1KRDNy?=
 =?utf-8?B?ZkJmM0JWK2pLcUppdzhMNFhSblNqajY3RXpvald6UndwMW9UYmJQQkxQUkx5?=
 =?utf-8?B?dytZZmRTbk15bnRSRGI4eDhKMEUyOXBES1hnVWJmRnh4b3NwQ1VOdnRjd09I?=
 =?utf-8?B?dldIc2ZENU5BWEdpeU0yOU9NYVJMUGt5Nzg1MXYwUTZCNlZJUG9YL0dKZkhv?=
 =?utf-8?B?TkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	i1GPL/XXFRBQhRpPZoxnHVx2paW4hIv4cH3PNzAWfCKWa3J9uOa+wM2yQHr8+tZsv0VBgeJKR9H5SjRuGwLfTqTbV2HlYBc1ncMZDSErwWqMi9NPxjc7+rwxV0YuwwiSMhPPxHTzezHthcteaaCDobJme2Leew5D+jKN+GnoS2WcgPQhBRh/efviPQL9FO2JL35cIIrEwhXm8ImBaJKDu0rnezhxkmxJyTBtCcYcb9DHs/MraQT2epOXlO2ZKnnaM6aoZ8s+kbdHUzndAKMcF4UGry8MutPTlIh2GYun0r5uaIXHPBQ9Bki+E53JKx8NgDgL67NkZojhegugY3Y7Y+DFFr3+y0TR+q4AywGHWJuiktgq7783uAaLWEHcfHJLLcJvBBeQUCAbHUQervIecabCU3w+L96fw3Yxqdq2jNKbYmA/70KKmYUHC2aj4Rci7xemif0pTVo3kbgLkVVxrcLfmbcTLl5XsGCASwbzMe1d7hd+nsA3zYNj7NKDz7D3Csm+GTYrw075A2hmaeiMqj9hlE+LgHJ3KhC31UYDtH1G+HjOBeMdG46djlbFgghXalxVEQnOb8+ZonZN8QSVU+8N5QbB5/uhJyVa5iFQG78=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39c3074f-f015-4566-5fca-08dc5a345808
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5622.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2024 14:33:24.3820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lgFjlFfOSCHk6+PB6SOI3siEaQMtKCJvoxThQuyY/KauegweWKCMRhbS2UDXp6dvzmRcOI/6XhKGTjiPTEJ1q5t8R/y9k4rhLW4xbfHikhg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7295
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-11_08,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404110106
X-Proofpoint-ORIG-GUID: 7bKyEgQyaZcg99M_j6rjGNqk5eCP3esD
X-Proofpoint-GUID: 7bKyEgQyaZcg99M_j6rjGNqk5eCP3esD



On 4/11/24 16:13, Andrew Cooper wrote:
> On 11/04/2024 2:32 pm, Alexandre Chartre wrote:
>>
>> On 4/11/24 15:22, Paolo Bonzini wrote:
>>> On Thu, Apr 11, 2024 at 11:34 AM Alexandre Chartre
>>> <alexandre.chartre@oracle.com> wrote:
>>>>
>>>> So you mean we can't set ARCH_CAP_BHI_NO for the guest because we
>>>> don't know
>>>> if the guest will run the (other) existing mitigations which are
>>>> believed to
>>>> suffice to mitigate BHI?
>>>>
>>>> The problem is that we can end up with a guest running extra BHI
>>>> mitigations
>>>> while this is not needed. Could we inform the guest that eIBRS is
>>>> not available
>>>> on the system so a Linux guest doesn't run with extra BHI mitigations?
>>>
>>> The (Linux or otherwise) guest will make its own determinations as to
>>> whether BHI mitigations are necessary. If the guest uses eIBRS, it
>>> will run with mitigations. If you hide bit 1 of
>>> MSR_IA32_ARCH_CAPABILITIES from the guest, it may decide to disable
>>> it. But if the guest decides to use eIBRS, I think it should use
>>> mitigations even if the host doesn't.
>>
>> The problem is not on servers which have eIBRS, but on servers which
>> don't.
>>
>> If there is no eIBRS on the server, then the guest doesn't know if
>> there is
>> effectively no eIBRS on the server or if eIBRS is hidden by the
>> virtualization
>> so it applies the BHI mitigation even when that's not needed (i.e.
>> when eIBRS
>> is effectively not present the server).
>>
>>> It's a different story if the host isn't susceptible altogether. The
>>> ARCH_CAP_BHI_NO bit *can* be set if the processor doesn't have the bug
>>> at all, which would be true if cpu_matches(cpu_vuln_whitelist,
>>> NO_BHI). I would apply a patch to do that.
>>>
>>
>> Right. I have just suggested to enumerate cpus which have eIBRS with
>> NO_BHI,
>> but we need would that precise list of cpus.
> 
> Intel stated that there are no current CPUs for which NO_BHI would be true.
> 
> What I take this to mean is "no CPUs analysing backwards as far as Intel
> cared to go".
> 

Still, we could enumerate CPUs which don't have eIBRS independently of NO_BHI
(if we have a list of such CPUs) and set X86_BUG_BHI for cpus with eIBRS.

So in arch/x86/kernel/cpu/common.c, replace:

	/* When virtualized, eIBRS could be hidden, assume vulnerable */
	if (!(ia32_cap & ARCH_CAP_BHI_NO) &&
	    !cpu_matches(cpu_vuln_whitelist, NO_BHI) &&
	    (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED) ||
	     boot_cpu_has(X86_FEATURE_HYPERVISOR)))
		setup_force_cpu_bug(X86_BUG_BHI);

with something like:

	if (!(ia32_cap & ARCH_CAP_BHI_NO) &&
	    !cpu_matches(cpu_vuln_whitelist, NO_BHI) &&
	    (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED) ||
	    !cpu_matches(cpu_vuln_whitelist, NO_EIBRS)))
		setup_force_cpu_bug(X86_BUG_BHI);

alex.

