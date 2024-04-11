Return-Path: <kvm+bounces-14254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D75F88A1595
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 15:33:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5772F1F2399C
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 13:33:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7603514F9D8;
	Thu, 11 Apr 2024 13:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N6CVP/7B";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="unzRvBe/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F4514F126;
	Thu, 11 Apr 2024 13:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712842410; cv=fail; b=kCkoJYYhoQ7Ng2uGSreL4t0OClbJbtxyzRI1WeaEQu1BTl9xczJxHGpC7HYL4z4R8JfPJiAq6F7OCoFto4ZQ7xfBwWowgqjqhjZZ2Z4OKZqdW54mQ96zBxndjchno9881KsguEyis1DgJfmRZ7/CtEqxy+H/K6YqcrJCY+9uHRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712842410; c=relaxed/simple;
	bh=U/w6a3yxtx9AI/tCenZ6yKGix/ddU3+J82oVl6Qev64=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Cr3Vh29rWehlhltXR3/5S2Bq25htG3wCSmVS0M/+4oRUSrQZtLPHV37vUQF1ug9W25WxDcnyVtNSxuCwNBdtILAm2Zkm7txSC0fmAJFHMTaVFTwltR2saK3N52WIcxxJHPajftmhbkY1JYRy396KGrUJ7MY3LavVBq38Q67nxBA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N6CVP/7B; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=unzRvBe/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43BDUK5E014539;
	Thu, 11 Apr 2024 13:33:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 cc : subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=rQMaKR6K/JHc150sBbYRt73qoFENYtPgBny6uzOXlng=;
 b=N6CVP/7BLF9wyvI7I92tXW2FkRuQSZbC3up/duzQoNm3lXiqHR4Qfr/LIAokc29AOYsy
 wU/j8b0L57t1zA0mPb70pmUMr/ygIlnY0NcOKgJ5fFtTXIO6IW/CrfgFYyDfJ68kx6Tz
 fqJVdIc1BAO8q2MESDviiDhrwJ5e1duVHe6Xo0+wVkRvv6n/X4A6qAh8L6jmuTOe/JQd
 wPmGzMpgLlPeJPDwal+FrVLfQGZaFAkBPjUrR6btgQLQFr7r9iOaaJd2RRXvKv2Eq4qk
 sFkceA3CCYzIOWk2QyQBen9Qdx17Ek5DlwIv/EuQrwpZK3/564Z5274IRsK35DwCFbFw ww== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xax9b9ebh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 13:33:00 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43BCYVJU010765;
	Thu, 11 Apr 2024 13:32:59 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavu9gxff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 13:32:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=azCVH/o2c3riDuGSLcQmohioZxq1KP23N8yJBQHne+4h4HKSgVREkxgblrXzWnVa7OBOOR2+ikQEgFtYSTYEulREruNG3K0O10u6Hw/TlG7OMVySls7jc/9iJGYmTMYMReQ+NjWm209k+dGNksEwQp/cZoWoFYY9vNtd+Jljt8rV++kwKh9yHxVKproWBWhWGDjW3qhxneUdL43RO+3jJ40c+MUSpQjoq0sw6ZR6tsbNN8iu6hRxEqabBKF1qeRSFXggRAwQg/yvNgMlM+rFgwn6UYYY4vsZcoJof1idnwe5h6v/lQd0n/0LO/bax+PfcUks8CwkLZ9P7gCEud72Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rQMaKR6K/JHc150sBbYRt73qoFENYtPgBny6uzOXlng=;
 b=h4QU8xyfOZUxY9S36qzP3qL1zgYJud8mWEUtJPzLjgEOR7555jNJTfVT2XOQoJlu82f9MXSEj67nQUysZ49T2WE7d8vBv7WN/1PzYYWZ7GrvslDw/MgeSchJTw0yyCci1ceAyaXOg5DAL/Nv0KZm+Mg9cRH+YCTv/KTmwqARhCGixBqPVGncnysSnkGs4k/EitE/GA7u6cZigqUOnIoPxvxnq6qISSyad+IYrLMShVyT0VE5LuxdCs2zn6TRY5AN2yZsRTkaH60j/aFu5/jjhAGls7dKM4xFqp0tsbATcRiiV+bkns5qmwAopQjY8dYTGrVy1esV2dmVd6g03CKs3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rQMaKR6K/JHc150sBbYRt73qoFENYtPgBny6uzOXlng=;
 b=unzRvBe/3IeoXEk7lzK8M/NhIhijTNiMtnzT8O7z0LCqvQ4KbGi3eE9XSYwoVsyjB3+aGVhNAS6nkBr803Mtt0Q1e0CO9E9R1iI0puTzXFF7pwy/JUSbuLYjlSd4e/5gCBxXIyZHqxY1qnDuVohKojxQ/Vrd9TIuNHvP/3uaAJo=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by CY5PR10MB6021.namprd10.prod.outlook.com (2603:10b6:930:3f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Thu, 11 Apr
 2024 13:32:57 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::1481:809a:af18:ac44]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::1481:809a:af18:ac44%5]) with mapi id 15.20.7409.053; Thu, 11 Apr 2024
 13:32:57 +0000
Message-ID: <abbaeb7c-a0d3-4b2d-8632-d32025b165d7@oracle.com>
Date: Thu, 11 Apr 2024 15:32:51 +0200
User-Agent: Mozilla Thunderbird
Cc: alexandre.chartre@oracle.com, Andrew Cooper <andrew.cooper3@citrix.com>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel.sneddon@linux.intel.com, pawan.kumar.gupta@linux.intel.com,
        tglx@linutronix.de, konrad.wilk@oracle.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, seanjc@google.com,
        dave.hansen@linux.intel.com, nik.borisov@suse.com, kpsingh@kernel.org,
        longman@redhat.com, bp@alien8.de
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>
References: <20240411072445.522731-1-alexandre.chartre@oracle.com>
 <7f1faa48-6252-4409-aefc-2ed2f38fb1c3@citrix.com>
 <caa51938-c587-4403-a9cd-16e8b585bc13@oracle.com>
 <CABgObfai1TCs6pNAP4i0x99qAjXTczJ4uLHiivNV7QGoah1pVg@mail.gmail.com>
From: Alexandre Chartre <alexandre.chartre@oracle.com>
Autocrypt: addr=alexandre.chartre@oracle.com; keydata=
 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
 swLliy6PdpST
In-Reply-To: <CABgObfai1TCs6pNAP4i0x99qAjXTczJ4uLHiivNV7QGoah1pVg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR1P264CA0066.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:2ca::20) To SN4PR10MB5622.namprd10.prod.outlook.com
 (2603:10b6:806:209::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN4PR10MB5622:EE_|CY5PR10MB6021:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c3a19a8-842f-4366-1643-08dc5a2be5f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	TCCHrXRpeBNpLHs3IrAu+HaegRU86S8Y98B0q5yv0IA9w+e3rvde0YZoQjGczkMhDYt65Eii/ywEkTuN0hH+62lXB26HYKKrJut9kyscns3TsdCmwaiItDPFNYH/LPyH1dzaRxk0t8BM1YbgEnoSulVQpCO895yOXdCQmubgsOnwCbwYd8hnKkg5h7KDGcVAyntpH6x960YAvkw8TfzzCL03EqISTfvVKxKssOxjb6noIavc2R7hkoJvKdPZii3R6LICQpwPC9Qeq12UmOP9gPC1PFq8nMMw3a9XMQ6kuesIhhqKiD/bXKwtsTb53pRCKKjezW+i7TTidXJPRXUzDZ5LdOsRcwI42/6mt2McKSkzJekrF6bMalfkYK3yLBWxn8ub7JHa3MNzg5FgSXESt4JVudTRxliecGtP+OgL5UcrIxhFZB72giWRwwp2Xp77hCcSt6JGWn/PjRty8urVCyp4ukuCU8ZbLzq/7pUmUhfGHk6h8QQnkMkbC0xaSLZSmVpno1Wo58KU9HcUnKXm//b9+EsWekdgn31VVvT/V3tRsgRUbniJpEVKRKJG20saQr88KelQ/cy8Piq0HtzzlwDuj+lc4dtc8rraqpdBmvHzT/CItU6rH2TJwoHiq4sGwYcoM6hhyafUx/iaTNXVe3uMpbhqXeKexuJVGkDKd4k=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?aGo2ZGhlem9ZYzYvOUc5aEw1aDBUSWh1TDVudkFURlA4QzVaL3hYYkc2c2l1?=
 =?utf-8?B?ZkwvbHQyNHU2UUFOeWR0aTRWcTRrOFh5UWROOEdyWStUNjgyb1lqUzI1YUd5?=
 =?utf-8?B?YVIvenVrK05rNjB2aVFXczJFelBmL2xsZTZRci9SYVpERUd0d3VNZEhUT3hl?=
 =?utf-8?B?WmJmN2t4NWFHQVhlM0tRbzRCOHdDdUtBM2cwazdOY0RDa0E5bUFKaFQ2SGlS?=
 =?utf-8?B?Ukhqd1Vnd3hGcUphZXQxWi93cWd0VnQyY055aGlneTN0L251RWZGaXZNMFlB?=
 =?utf-8?B?bnhZOGE3YVd6c0ZTcjBVcWdyVkc4S0NwL1JuSEhGeU1LSjgwT3ZKSlJwOFBY?=
 =?utf-8?B?YXZRbnZJUzRocDdXRnlMd0t2NCtJQVd4MkNKbmF1ZWloK015TzJGNXl4NytI?=
 =?utf-8?B?VkhYazRNRTltbmtJYkZCRzFoZWYzdG5UN0tOWDB2a2pHdDlZcmVvc3lkRTdP?=
 =?utf-8?B?TTJZcm1TeE4zN3dpQTNrUG91VUg4L0cxYTJuKzFGRWw2M3QzQ1I3OHRUZmVO?=
 =?utf-8?B?OFRlaFBENDc1Y1cyMTZVYlM3VEttLzlFRlI4MytKbWlpcStISTUvdktnY1Nl?=
 =?utf-8?B?MGZKWTlSNkwrUENLdkRVbmkwL09RamQ5OEpWbWVDZkZQZEdzV0JHV0N1VkhK?=
 =?utf-8?B?SERTNC9va050R0VMZ2U2d2wyb2lOaUR4bTRXdUtUbkdXVERoaXRMVDEyWUwz?=
 =?utf-8?B?SXBuVlZvYTdkaitMZlZObC83Vk9OSnlJUkZjemgxdXJ1SEpCL1JjbkpHZjkv?=
 =?utf-8?B?am9KeDZVTXdMbmQ2WFVDTXFBYVBjd0ZIOUZsWWIwUUFjOTNJcS9rVzQydWoy?=
 =?utf-8?B?OTFsdUdRRWozMjc2YitxK0JHd2FtSXVoRE9IY29rdjRGSDdmdjBUaVZDN3Q2?=
 =?utf-8?B?enNMb0NFRHhyOGV2OE0vaDVROXZKL3g5UG8xelFibnFBRmFCTTNJdHhaSFZD?=
 =?utf-8?B?ZXlQdkdFcUg3bTgxMnpKc0hFMEE2RTMxRkVQRDRXUEF3ZjhEbHdabVY5SW91?=
 =?utf-8?B?UnRCcm1TK09sR1lhNWxiQ0ZqYVRDTFJVeThtdmg0QS9kUS9CbmJCd1Y2dmNE?=
 =?utf-8?B?VlpQaW1XcUk4TERud2QvcHl5TUIrTmVqeXU3aTZNUGx6YjlHaTJhR096Ni9p?=
 =?utf-8?B?VHlTQU9LVDd3MGdScVgranRCTG03VTVOY0pJVjZNc3RNZk42aE5BQlp0UHZj?=
 =?utf-8?B?QjA0c0lMRXhNcDZxa0s5cThCRnMyY0l3TktON3hWTEt1S2ZkRm53b2M1Vzhl?=
 =?utf-8?B?NjJqbFdndFZLV1VRY2k3c2I0VDlqM2V6VXpnMnR3d2IwOGVCSllVcVpMYnJ4?=
 =?utf-8?B?d05KZjNRQ09PVGM5NlA2WGg2STJpOGZkUmtyT1FRZGJEbG5IWXovVUo4Mkow?=
 =?utf-8?B?ZFJqdGplVlhOV2c2RTZVM1Z6U1duSkpBbHdKMUZoU1owT1N3bnd5UlFrejJ0?=
 =?utf-8?B?YVdZMjI2SEYwa1Z6RFY2YXhYeTZ6emlkdkttZTlBNHVBWjAwMkR3YXJNT1hy?=
 =?utf-8?B?NFc0ZjhtUElMRFhoYzhuOFdsdi9waTNJajladTBoSzdSZTl0OGhoNkNncTdN?=
 =?utf-8?B?T2V4Wk8rcU1pMDhGNTltR3FvSzBDRDk5d2pMZWdvUjVub0VoSHc1YTFJY2E3?=
 =?utf-8?B?NXJVUW1VV1lwSW1ocnd1U2lFRmZZNjFRdWdFSVF5TWZSdVJvajNTcGs0c2tr?=
 =?utf-8?B?SlAydkdJQ2Z2ZS9Ob1VSbHJrQnZEa0VnOVFnZWQ5eE9MKzNiN2RaZEpwUDJv?=
 =?utf-8?B?TWpvMld1NkJSSnZRZGlwU080dFRydmFMa2wwbnhwZDZxNkViZnEvVjd6SFdJ?=
 =?utf-8?B?SWRkODVrUzlyZWtYOUZOQUpmV2ROWjI0ajN3bEF4MFJZSVhBdjdCSnpEemZU?=
 =?utf-8?B?RTFRQ3FGSnJvV2J4RUFlVHlqTU8vTXhvLzJaZktSUjYyb0JzbisxMnQ1Z1dR?=
 =?utf-8?B?cVo3Y1lvaHRMT3huZVA5RzdDVDRUSHhCT0JEck1jSENYRzhhWW8wekg3V25y?=
 =?utf-8?B?K01JYlFRTkFLRGZYWDVVMHlLdytrcUwvWnJWdEc3Z1pjOWVFd1JZWVBEVUox?=
 =?utf-8?B?T3hLMngzNzJ4a1RmemxmemRWOXYzRlkvbVBjSlQ5RlYwZDBLYmEvakgrZnRr?=
 =?utf-8?B?OGFLQjAwNDF4NUx4VUNwd09kM2lXSEFKRXBTSWZ2Zm9wTi9wTTh3NGJyeUU1?=
 =?utf-8?B?ZGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	PULIgzG/PM9sbdYXmxBO+4vxLTbzjMBSXJaTV72w0W3ByYRo9VZdCl3siKF7YNglGEZcfPqajFDYLQ+wL9XehAiTPf+Idmk9JWlArnyBvCRL7zyxx8MHymevRRvXTc7z1eBR5JQczaF6bPNzNR21XCQQFW6iy149sUd4Y9+SBz+RlVeG2iWdyqSNT7w6WD6NJCaSLBET+haVtfZiaXh094C0kjSn8YoSx9sGXI9Cry/FdD1hs2tuK0hwlFzduzd6VJS8pA7/99KI9sDsO/coCDHBd0dgXVVGY+vjQz2kQAHxXCF/T4HL2jZHvoomBWAy58z0t/Gc5pE7YOGoI8U9BMbYPWc0F8RigdVfqkqv+XnGsi6UT1Y24zfxKI9724Ko08eTuKzWijyauCMC2z6K36ewl9947i6ABXclCrtIRgXbMFsVA4wTF2WHXQ3Q/vUCXgEMKdyBxbz/esk7I2yvsQTOrva5hS5M35t+JB6QZN0OWOOH9Xi2Pt4CS+W/4LIEku80tTzlSBwsO6YxLaVYZ4/RaueN4BlxkfleYt84U+ezABwiT/ENCQ9QhdK5LlZFdQivsB55ryxTkiVl6Ip7dyshU19U15koMWU7z889+EQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c3a19a8-842f-4366-1643-08dc5a2be5f8
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5622.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2024 13:32:56.9186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NGnNJS/15DSPZL70ZCWTCWliF1UspgWM0Fh36MuAxCNnAX0As8I+5P+Q4EE1yPQExEYPjVQnI3+IsmdOWCL2uSAQw3o80iayMBy5q60eQ/c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6021
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-11_06,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404110098
X-Proofpoint-GUID: av90BvDOhQn3fycy6_fICILXSeYHtFLT
X-Proofpoint-ORIG-GUID: av90BvDOhQn3fycy6_fICILXSeYHtFLT


On 4/11/24 15:22, Paolo Bonzini wrote:
> On Thu, Apr 11, 2024 at 11:34 AM Alexandre Chartre
> <alexandre.chartre@oracle.com> wrote:
>>
>> So you mean we can't set ARCH_CAP_BHI_NO for the guest because we don't know
>> if the guest will run the (other) existing mitigations which are believed to
>> suffice to mitigate BHI?
>>
>> The problem is that we can end up with a guest running extra BHI mitigations
>> while this is not needed. Could we inform the guest that eIBRS is not available
>> on the system so a Linux guest doesn't run with extra BHI mitigations?
> 
> The (Linux or otherwise) guest will make its own determinations as to
> whether BHI mitigations are necessary. If the guest uses eIBRS, it
> will run with mitigations. If you hide bit 1 of
> MSR_IA32_ARCH_CAPABILITIES from the guest, it may decide to disable
> it. But if the guest decides to use eIBRS, I think it should use
> mitigations even if the host doesn't.

The problem is not on servers which have eIBRS, but on servers which don't.

If there is no eIBRS on the server, then the guest doesn't know if there is
effectively no eIBRS on the server or if eIBRS is hidden by the virtualization
so it applies the BHI mitigation even when that's not needed (i.e. when eIBRS
is effectively not present the server).

> It's a different story if the host isn't susceptible altogether. The
> ARCH_CAP_BHI_NO bit *can* be set if the processor doesn't have the bug
> at all, which would be true if cpu_matches(cpu_vuln_whitelist,
> NO_BHI). I would apply a patch to do that.
> 

Right. I have just suggested to enumerate cpus which have eIBRS with NO_BHI,
but we need would that precise list of cpus.

alex.

