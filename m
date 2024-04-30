Return-Path: <kvm+bounces-16257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18E438B7FE1
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 20:40:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3A30281E38
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 18:40:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94F2C1BED67;
	Tue, 30 Apr 2024 18:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h9liy6/e";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SV5zux2w"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EE6194C92;
	Tue, 30 Apr 2024 18:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714502311; cv=fail; b=pHTcbdYJcGyQ2der2LeC3LktLT8eiC8NJ7TwDFSH+6MlKr7Ex6P5CKV7knMG690JlpTWgKPoz92FAw4E9o1Z2h6ejasc3lhZd7CqqwkGt/VU2x0QzYVlp4DBumDLYDDf2NPKA4Yc4phjQBPj1Hhtn3QQddhL6ghVjTkh8fBobSA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714502311; c=relaxed/simple;
	bh=l7Ohyfgcv+gHPOIGGlqVZqif1FzxNBEPOoEK79ntrL8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WEPrO4q2EM43IzjKVQ7szrxI0ybt5EEuyrT+qQSP4X+Va+SPxhGDBmambNQd6WPF3PHyrR6WlyogNIMf7Nk+Buu4MyEAgTRaQ49G7DzZDiCVesnzhT8XYHUfNIcDKzW1iBpBue+qbq9SuE+vj4DEtmGShu8mPf9t8wtSKQPM5wA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=h9liy6/e; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SV5zux2w; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UHIchp015452;
	Tue, 30 Apr 2024 18:37:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=CkE+FQofaQZB21BMzCKAtZTmDzS1Gm1fDdPRKdgpBKg=;
 b=h9liy6/eZA3oryrErLA+t3LucTFC+LuLgngegzrmvJERaKKk8U2IW6ZqBrlP7vePksN3
 fmWE8hSqEvyePVUmBuWQiUQNB4j/9UbDhC5VZNuDhO/R/xfNvuiIcuwzx94Kb6+yDZav
 R/mfcUrA/tqFvWb+gqiDNPq5F0lJU7q+S+Rv2f8Ykk+w22xjckezyRtbt+Hr9bjrz7KY
 zPeELFMZpIzn+oZ0xMNmPHr6RZPMYqU68mJlq9IdOc8/7gc91Ojv2/e75w+UYDjDUGhx
 meDcdaeyTBFa3p2EZ/lzte8li65blr1/KlF3OcVqTtFwv+6XBsZb+PhI5Yxe0wXS7dM9 Kg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrr9cnxgf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 18:37:54 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43UISs8P005044;
	Tue, 30 Apr 2024 18:37:53 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqt7vk17-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 18:37:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4J2BrsziaxV4ycMDDJyKqu3+taiZ7eARAKt4QsO5L/+0CbLvn5hQ3HmQq6XmTUCKBnJcTAIjyvz/AO0R1MiUnoN9wUJeEOKSv43ga3DYigRQoAJwzXKXVXTrpWXQT8/BMHsjR1nbK7Ej5MoJ5jJUSb/dQUfv2JMO14hHEA4lwKa5PTop247lHJ9dT7pABzOiXyHdGLoTfKKl+4Hx8mvE/4kmp2VVV0q673ySskc9jiecjZZwiLQyhRo4lXT3EcbIGEJ5TgoKaD4bhUILHOH6XuJi6ro/OGNqTAD8SUgCKVBprb46LkbxkKAK/DXUox99NWn47FqamulmgKirVY8Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CkE+FQofaQZB21BMzCKAtZTmDzS1Gm1fDdPRKdgpBKg=;
 b=m9Roq4olbDe1abnkf605ACYqRX9TGZIIFlQUHNsHq1hTki/XYvlMs1DafihKFEOFi3B2JDFoHB/GZHaacZCFclIdmfd8K1VxF8Jon6THnugqMogQFvPLhOEXqOxwJyFSEzxIkAW6faIfJSOr6tdm+fXzKzsWHQdr25m5ahtqLLMOWUVbfdZ9ULfnMlkInMDuUrfJROdnmROufVW241/dXdzkLYKfrll07bGCQ/NOYuVvVb9kIZDGG3gjmGUswzRF4LSrrUTPZ7myRNtq5R3hL6m//jt2er8d3TIlVwPiQYPYlm8hHwS9d6qLCHTBTbCjDfS/4eqCJS4QwU96IynDJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CkE+FQofaQZB21BMzCKAtZTmDzS1Gm1fDdPRKdgpBKg=;
 b=SV5zux2wISNAncJNIJOrOMIKFZBuXwY9TDn1uDcgGZznPnRe1S3TQI0pXGmR+8dpNAHWgbqP1V75RwBD9I1M+TZrSRfqhqSqk74tN6NCQzUH0LVjJY8L7A3FSsBdG6mWil3EEuFVDn3bdWVsIALouJZjqK3H9GbATxmi7W/O1Ak=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SN7PR10MB6308.namprd10.prod.outlook.com (2603:10b6:806:270::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Tue, 30 Apr
 2024 18:37:50 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8%7]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 18:37:50 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
        arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
        harisokn@amazon.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH 6/9] cpuidle/poll_state: poll via smp_cond_load_relaxed()
Date: Tue, 30 Apr 2024 11:37:27 -0700
Message-Id: <20240430183730.561960-7-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240430183730.561960-1-ankur.a.arora@oracle.com>
References: <20240430183730.561960-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0078.namprd04.prod.outlook.com
 (2603:10b6:303:6b::23) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SN7PR10MB6308:EE_
X-MS-Office365-Filtering-Correlation-Id: 408bfa6a-be96-4d43-0866-08dc6944a361
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?VNzKRDzIATLjKX2v1iGRk11XgidLzvBED7fu08gNF6g0zWrIRdLcyHctYOsV?=
 =?us-ascii?Q?qbW5qrdAnps+7Ik6TwMLk0hueCuxa8Dp/BEX0I0mfpreP/GZArwOZ2evex7Z?=
 =?us-ascii?Q?yw8CT7lr+n5o/0GD1ptGEOiNnNLRifxa6T+uA+ZqssDjJGiG9nLtZEGRD8GV?=
 =?us-ascii?Q?X6bzqrSm/Q3tr2olDF1nX61yGlxpUlrPj/ycbJWp2wQqnK6zuUAbLbexuTJo?=
 =?us-ascii?Q?Oo8WlCQatFLt/4HXiHDf+xe4dTBllGGbcZMtICYHILjVFVafSCziXK7ttOrb?=
 =?us-ascii?Q?mrVr7ZB3QJQzKW+JEqCpNhT974kyheFO3P4ThYKQaU/XmO1vapPbG/jnSmno?=
 =?us-ascii?Q?BM34edHFSjVpuRi5zs+GAVECbcbFiLVjR0Nk+c8dxuSEPGRTo7JgyvlXFZuj?=
 =?us-ascii?Q?a3nUKtbHtXpEFO+MPWXGZXJ+/ihWXN3GlDvQtiXv6feGfqywfkl1AYUUi17u?=
 =?us-ascii?Q?FfS2qS4whA8ITKPud4gfkdfAmESnNNz2B/WqA7vaZ5RW9oTczTO90i920Rx6?=
 =?us-ascii?Q?AZ8F9qSCXB5kUuZ2Ruqu6n1DxQ34ZxQfLsmnW1tmvYsTstsDJqbHAL40Xbax?=
 =?us-ascii?Q?7R4mbFOXNhNrg/SVX0eunyJmMHifDwwbkL1yo/h3ZlBv7nBSoHZgCtkSC2oE?=
 =?us-ascii?Q?SfJeTYiYfLNq9pIPHQDmYHAVIyEYam0Oc7I45Ij7qCKxmLMOqrQD++9CRZQC?=
 =?us-ascii?Q?ZBLdg1mgSrNc0goCBofgoJvMGhfmyJDSJeFNHzP/hL8TlDVqiVdBNwJCQC6M?=
 =?us-ascii?Q?+aPpFL2M6Ls2ogp/6g5Rz2RtCTN7OYt43CTWg6McI4HU/zL/unnkduKTiggt?=
 =?us-ascii?Q?4wxHFojt+xJN3j94/QmIePgBvjmSTetmPsR8ydzPcy/3vmZskPS/ItZv3uhC?=
 =?us-ascii?Q?HIsLO6v2GaQGjkUebDz/cb9vLFcdo3Y7GqsVi2u5T+Rxdx/oiDJX28o8HfbL?=
 =?us-ascii?Q?9O0oUydW5u4FOryn3P7Xun4W/O0BrYHdNUEngZnJqWoOJ6aRJJ6JnyL7FhtG?=
 =?us-ascii?Q?5FsZ/hsr8tzOJ6QO28/2JTv0D5iZKTYBe0fm6QOo6Q6BpESeRgD7v3TkPK7s?=
 =?us-ascii?Q?o5BZ2Pktuht40nynwv2fYHeS+MjNeFOngj9eYck3pbh0oWQ6SsNi6zWPkyHI?=
 =?us-ascii?Q?3pFvuCjrWFLe/7WysOLezi1Qxxa03ueftWG5Q5ds8gR3t7q40uYb0rlFxs7o?=
 =?us-ascii?Q?3qXb0yG7OXnszBp4c5kgFGGgWOMrM0a85qjB6ZNF6cVLqckrcUUEYN3SU/ra?=
 =?us-ascii?Q?HG7QkPPK2PuiaMMBiUALKmNJ/MRLn+mxeutW4y1iGA=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?FqpEcDCs6OCEUchDX9jRUuBnRmrswe9f5hMbulBF9EV8X8/7L3ZOf4zW68uG?=
 =?us-ascii?Q?DVIjTo8Odm16u7VD/a8ALuabWniiu5h9Bt4Q0ekGVfDN32KNtGwhxzxJkAYk?=
 =?us-ascii?Q?Q3Y7ep3rUMPo+ATgbjKjXAF9GRTgp3vZ3wuKyv0QcC0qbDihOvsI1i1mM4UY?=
 =?us-ascii?Q?kgNMgEGnx/Nfr63/8dPyYDK5jdr29822453oKVpRiKwOlcwM66WYS+dPnmbo?=
 =?us-ascii?Q?65gU8kruoiVml9of1P9KOa7BcoXXc/Gsoslr5u/gjHtVX3QD2WQQLfmrnquZ?=
 =?us-ascii?Q?QUiq+HSWlbiVax2nZpt4ecEZ254jVFMv2iIMElIHGUcV9KBmiSh7v4sA61Ex?=
 =?us-ascii?Q?SrsDE3vBwqDmgCFjOVvN9IVShiaH7pdAlVltfE4dye0a5L3rKktsD8pVsZu6?=
 =?us-ascii?Q?Jv6HxbctVjlJFxl9LPVgHmlFmyhjR9roRrdIBy3aviTXmmaaAg6N+74VH9Bs?=
 =?us-ascii?Q?pQ97qdvGUiStu/IOw09dkAAFqP7Xjqwi7tsXlLG5qg07FBQ7kyUxl6wJ3k7Q?=
 =?us-ascii?Q?++w4H0j/ndaZCS/6ZIeLnGJ0p3buklA+dGug/yqfblaq0PL5NjdyEfntuGBa?=
 =?us-ascii?Q?H3zHShbCUOR0cPk9zHWixxgfWsJ7RcbvzDml3O+lAckRM/BvaWQhmCp29BDL?=
 =?us-ascii?Q?VOZhO0Q7nPvuaANg3nPT7e7+4yjlkO6euBK4t0qwOVzpVfI/GDo42IxkjjS/?=
 =?us-ascii?Q?Wir2iCqOooLgNZsotkDVBwFop4EDoG/E8xsXqUys0EikQIwlPl07piC1grUS?=
 =?us-ascii?Q?t37KefQjBkorBrcv1+RsVg5Q9uWSw9DaMZ3V0n04zHJwNw7LPa6Qrx2TLUXb?=
 =?us-ascii?Q?yW0bgyX36QTdUpqj/HnJOlVvCHtROFyrHlFNKTzB/RfVNlhzfFSYdVZ6+25+?=
 =?us-ascii?Q?rDajBT1diVR64OfnTa+CfytLNwhZi22USH13MBD1kz+aQ+pkMgyZyqGDOLju?=
 =?us-ascii?Q?LEQNTfi4jkEwBFCHmY7L09edYFMQgMpqQV25hy9l51zX8Y6ThI1Y2DhU1PvA?=
 =?us-ascii?Q?tnKdBNYntzLp5DMc0y2poWoYZ4oNrbAd2f1DLNGuVHO9W+CtHALM5a7gaR8a?=
 =?us-ascii?Q?V3K2NLggUB4qiLhPdHIq0+/fEUfUsrkOsJMp7SKUrcIzKbRMgoSSdFhHJoHw?=
 =?us-ascii?Q?7f135EX6eGx0L3WUvgrxka0zUx8UM3BqXQMDLFCjb22Xz0Rf2T5Gfw5+SyQP?=
 =?us-ascii?Q?QWyV5rgAGnyMhclFbLkvycpvWOJ6WvsDZu6BSOPKNZ2DPbGD0mk4JchoSHXI?=
 =?us-ascii?Q?cc2/v+CxUTNdy2YnPuEK98Io8DLv9YeqFkiiKNgEFd1XuIA7ijDG0qadd1nU?=
 =?us-ascii?Q?YYrzm3i3ulQi6x3OGNHhGmdP8ujx34tRSayS2E4R/z769NvREu7OLKf6Jaat?=
 =?us-ascii?Q?POtsttZKUN0FxzNtt8wZ4jAM9/7UoxwNNku1IJkeRSaXFr1whMNrXiUzBEBw?=
 =?us-ascii?Q?K+7e8ZkQxhVJ2kTrjd600M1WzvvynkQQKhXDoHBLf0fUu4W0niax9662+cPL?=
 =?us-ascii?Q?0fkmURgVOkc8n8iIS1Qgbxg9FboVtpnevjtqKPHI9YoieOzYB5NIYkVnJtIq?=
 =?us-ascii?Q?mfSLidRC37xZUjW1TlE3v8fi4HYPiQ2Doltk7yF3jgHRP9eETMGDYVs0j2my?=
 =?us-ascii?Q?/Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	d+GHLz7uZ1a5XjGSox4l15kC2o4AcPjB0MSsybfgMeEJS/oAknGQCLf7C6S1RArDiWEOU06FvJFHBbRIsPaD/WjgqAEjA0HeDWBwXR1Ox28jM4BNv21kmO/nLhlliW5r2cUxQuWxopg67YtE+CFv7GjavjqdhilzSOwdRudBFNgtlEME4Usfm2LV9LqlhwGJ44Nn8YIj0Fr7keT8vydVrSz2s2+DFXYKyfl3JZv8L8tqPi3QCn5Mf4+O8lml7aNV3SXDyXuSvBShSogiiPDMikio+prWpfPOqxzHkvtIEzCq1mTs+KtDHHsD7BzmXo6CeJCIC1PHqH13FiFRYMqayGdOdBJYDaH7zP7BDT7nr9lWl6ZQWaqAQBfsVfkhMPciNCHNQEumZJTJ4KHMwcQmz7AlsaYd0N4C55hwqIl4Pf60ClLSLILtBHeYOqJ5MCdfEo2R1Z/DTUsVWY9jJbUB9Xhpzx2wSUnK3paKfc/Wwp8rxAL3l1AxF0IBSFDbvJhZUXVWsDAKX/vHBpahpryu4UqOY2JhADLRSfvQoUigemSd/qOvtIa/Ha0zDoi+E82YUaUe9KLO0JPzVjzGo05ibeI7LyqZADZIs6JcrbiU0PM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 408bfa6a-be96-4d43-0866-08dc6944a361
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 18:37:50.0610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UyvYGDuoeaX0LJav34C7IV5nx0POMK4Mr3kKr7Cd7/u0RkmMVX2Rqp/98pZnMITwriIPBHMUIe0TRVTFQ1q0oJPpzCS3eTZBlydASdElfkQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6308
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-30_11,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404300134
X-Proofpoint-GUID: pNqSBNTgMbZMg0QJ0a_wH0dso5GEz-hT
X-Proofpoint-ORIG-GUID: pNqSBNTgMbZMg0QJ0a_wH0dso5GEz-hT

From: Mihai Carabas <mihai.carabas@oracle.com>

The inner loop in poll_idle() polls up to POLL_IDLE_RELAX_COUNT times,
checking to see if the thread has the TIF_NEED_RESCHED bit set. The
loop exits once the condition is met, or if the poll time limit has
been exceeded.

The time check is done only infrequently (once in POLL_IDLE_RELAX_COUNT
iterations) so as to minimize the number of instructions executed in
each iteration. In addition, each loop iteration executes cpu_relax()
which on certain platforms provides a hint to the pipeline that the
loop is busy-waiting, thus allowing the processor to reduce power
consumption.

However, cpu_relax() is not defined optimally everywhere. In particular,
on arm64, it is implemented as a YIELD which merely serves as a hint to
prefer a different hardware thread if one is available.

arm64 exposes a better mechanism via smp_cond_load_relaxed() which uses
LDXR, WFE where the LDXR loads a memory region in exclusive state and
the WFE waits for any stores to the region.

So restructure the loop and fold both checks in smp_cond_load_relaxed().
Also, move the time check to the head of the loop so, once
TIF_NEED_RESCHED is set, we exit straight-away without doing an
unnecessary time check.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
Changelog:

   - reorganized the loop to keep the original poll_idle() structure.

---
 drivers/cpuidle/poll_state.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
index 9b6d90a72601..532e4ed19e0f 100644
--- a/drivers/cpuidle/poll_state.c
+++ b/drivers/cpuidle/poll_state.c
@@ -21,21 +21,21 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
 
 	raw_local_irq_enable();
 	if (!current_set_polling_and_test()) {
-		unsigned int loop_count = 0;
+		unsigned int loop_count;
 		u64 limit;
 
 		limit = cpuidle_poll_time(drv, dev);
 
 		while (!need_resched()) {
-			cpu_relax();
-			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
-				continue;
-
 			loop_count = 0;
 			if (local_clock_noinstr() - time_start > limit) {
 				dev->poll_time_limit = true;
 				break;
 			}
+
+			smp_cond_load_relaxed(&current_thread_info()->flags,
+					      VAL & _TIF_NEED_RESCHED ||
+					      loop_count++ >= POLL_IDLE_RELAX_COUNT);
 		}
 	}
 	raw_local_irq_disable();
-- 
2.39.3


