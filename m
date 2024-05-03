Return-Path: <kvm+bounces-16473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B1F748BA5EE
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 06:15:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29E7F1F22DFD
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 04:15:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6179F23748;
	Fri,  3 May 2024 04:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Rg+DVXDN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ix9ItKPp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF52D20B0F;
	Fri,  3 May 2024 04:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714709690; cv=fail; b=jdxiIExqUlo1yR+S+5M7wOSUwwg3K67XuTSvT/FXOYKqmfGoNYwDuEQh9LK8df7XDCRrecrvxFe8IuX2yPfQSUKxzJZveQnru66cXvcBx1IPRV0AMZodXDCFh1hI9M/fJN+hLTIs0hJ5joCeCJFOqw9G8xvULJOWIkol8n9Al/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714709690; c=relaxed/simple;
	bh=dcfty+rYlmdAlpF1NGtR0EEANtzAg4ECU4LE5PsrSJA=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=ouLMPDa1Hm7daTQnX3Gzp/sPle882kJ3LnkXFlApE7HJ3TiB9ZnY3asfDvsin5jPWPE5G+XzHrI3Nq8qqyLhvJwAIJECN77HsaN2c8TUrC8TNulbBzomBGPQXAGR399dy0PLnnsCMAPxF1Qqy1BOQA6ht+HKzppcIzSKkvwcSjw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Rg+DVXDN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ix9ItKPp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 442MYMtP005060;
	Fri, 3 May 2024 04:13:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : date : message-id : content-type :
 mime-version; s=corp-2023-11-20;
 bh=dcfty+rYlmdAlpF1NGtR0EEANtzAg4ECU4LE5PsrSJA=;
 b=Rg+DVXDN9TxTlHiXIKPCrfie7pS1kOfj0PKDWEJt0XO0S8o6k5GhZXTFW15upTFDXaWr
 uzdHBO5tJ1XwkSmoWJmT9g3nE3I5Q5ssGXQGv/KbmEIwyQ8z+ICXosG3vEetO4AdKPJu
 lb4yV6sDi4K1CdRr0CxB+oRfSfTCX8tT4UUS68ZrZCUtNaehexhjj0lRgzeycPqG1PdS
 kSpk9N6otUEBSTPu0cKZndT1VFiGy07v1VB+SwnfnO5Y3AK69Uf9gDP7aOGIccQdiuYS
 JS2AtrakXlsR93BRXg4p5/bJMWlPmyJGowEsm3TZMSRnFTeFQW8Q3OOoe3c2XbOybmK4 pQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrs8cxyb3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 May 2024 04:13:46 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4433xBrD006148;
	Fri, 3 May 2024 04:13:45 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqtbt46f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 May 2024 04:13:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WpEZ3RBSuyNgZdyVB/HhM8Em+QRnoZAB1cQ1DGoV/vyWcpD9d5l/OKfk6A+YvN/UQTbg9iGSFST6vdwJCOgc8Mb4OpYCTPR2kJbz7fUYGo7Qda0G5jDAS68l1StLkQqZNgN4LxqhDWVuosDUifDhqWyX0hwQAIWJnCYENEWyLs7QObTM5WnXgRXjA/NfBw5J3I6Bb+hmie1Hc7JQYHDvn1SbF2hEktJakzpimvH34iElvRkboq3rEQUCtxr/0aDMcYSymVTh99O8ZCQg7ZXPzbYEK+fND3bVGT0TNn0Hy51/jCUNeHicT4RJv2W7gywkPJigjKJsyktBrSt95b/jNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dcfty+rYlmdAlpF1NGtR0EEANtzAg4ECU4LE5PsrSJA=;
 b=QyXc1k3DyxCUhnhAdAs7xUy3mt00dZ+4ftJgri/WUBW48/ck8eqSONibKItvU0lfPV1urfF+njoi7WH2Sq7FcvK6KhpuFzawsh5YPG7G0z7uJeg6NtY3yiYgnLzK5m3zcIOPQUlJi/ghgqcpBsucuebbdq+zd8zN6ZnMpy2HlPjBbLhWtt9lMbZBgl9rCGgqKzDN0OYh1n7AxzyVjFHpGFao3UinTjO7LpzjYTk3BxuoLhmiLG7QXfUAWNn3vnIKZ+6ylcvMpJMDGA2Wvd7ZiOtT9EY7JnHFA/W6UzPzg81PV2A2Oj6rS3AAbg6L4uA0j79Dqk7JzWz4UCdL6hww5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcfty+rYlmdAlpF1NGtR0EEANtzAg4ECU4LE5PsrSJA=;
 b=Ix9ItKPpt3V4g7APRZT3+6DmzXsksogqO+Fu5SjfHtKJOwZdSFJ0QkdL/stwaB2RdK87t+tRv1VymxAg6557ZkR5X1c/JLmD7qmyombgnZITiL3Qh30BuDbusc05Gsyl/Hbq/EKOMdLV9AFLy2i5ngcOpHKAWr4UIPFdYuBitXQ=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CYXPR10MB7949.namprd10.prod.outlook.com (2603:10b6:930:e3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.30; Fri, 3 May
 2024 04:13:43 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.7544.029; Fri, 3 May 2024
 04:13:43 +0000
References: <20240430183730.561960-1-ankur.a.arora@oracle.com>
 <20240430183730.561960-2-ankur.a.arora@oracle.com>
 <7473bd3d-f812-e039-24cf-501502206dc9@gentwo.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, pbonzini@redhat.com, wanpengli@tencent.com,
        vkuznets@redhat.com, rafael@kernel.org, daniel.lezcano@linaro.org,
        peterz@infradead.org, arnd@arndb.de, lenb@kernel.org,
        mark.rutland@arm.com, harisokn@amazon.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH 1/9] cpuidle: rename ARCH_HAS_CPU_RELAX to
 ARCH_HAS_OPTIMIZED_POLL
In-reply-to: <7473bd3d-f812-e039-24cf-501502206dc9@gentwo.org>
Date: Thu, 02 May 2024 21:13:40 -0700
Message-ID: <877cgba5xn.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0216.namprd04.prod.outlook.com
 (2603:10b6:303:87::11) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CYXPR10MB7949:EE_
X-MS-Office365-Filtering-Correlation-Id: 97c99ea5-caaf-42e2-232e-08dc6b276b78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?THG4Gv25CkjAW6TJeXGuUXPcEUHtxSlHt5FlP96kUnVsGL+11r1xqBFcvOxf?=
 =?us-ascii?Q?3JnpmpDB5fmRHb7XUIT6UNrhGW85SamUo23XhaSemo9nqyNKjVxCE0K1Mi33?=
 =?us-ascii?Q?khXJwqnc/ogfIr13VDSFwDz5Tt9haQfZt8MFi2d9t6i2dypPDl10GvqBaUpd?=
 =?us-ascii?Q?hQpaWcEJyWybUn5ICoVy7o2EyrZfVt9zERyYVSsjsgE/BJfy9J6vt9fGZkky?=
 =?us-ascii?Q?ToICi3xO49hdRe6NBl/eiu4zn5qCIHYEEweb0oZoDikQZD6fJ2bmeSa88gqX?=
 =?us-ascii?Q?C8+OvNaoe4CHzTtcgZRzHYzpVuwyas+UEY+T32PESf/GCxmK8Sa9RxWVBCVz?=
 =?us-ascii?Q?Hl5nEJBpnGdGn/xRlNHDJ7WntTYbxGxOZMpc5Fe39GKjoxlYOuz7vBm15dHP?=
 =?us-ascii?Q?fqa2cGtBV3oKs2ycu2fZWOe7RBZscPBNXADZYrPGI76oiQR6hsXh86B3eaB0?=
 =?us-ascii?Q?MPUXeF3jnhavcjxc/6CJypYANogvwerb5QFdkSQCqlXOzgXXihD/Qeu4aNva?=
 =?us-ascii?Q?VKxWehWad8OjemBGbIveTw+8nMmhP0dHud0nBGScpw3wq0VHU6aoOSAKnHx+?=
 =?us-ascii?Q?G+0fLv3AS1GVjds69IJMwtGjRUWYERL6F5iFeVNrKk2w27zRuXEoFeNWtvS9?=
 =?us-ascii?Q?ycQPEp8/QlO0NB8JsSABnsnoYM9ECE2rQD+qDXUDC/rIaj7teluvma9bT5nM?=
 =?us-ascii?Q?bOkE2nGf7MCYHMeSyv9ddj8O/ybMvXnkKum/immI/29cH4+ppQTa9SyIlfM/?=
 =?us-ascii?Q?ebRBtpNyLfW+RoVIlFLqb+epyx809pIR4d7Wy4p9+/gtcwWv9CK/Ivuv60sQ?=
 =?us-ascii?Q?fEWHwbzNo0amDloQQl26+gphEaVq22g88VFoZyL60lhQ3n1H7jttbvcrWBEm?=
 =?us-ascii?Q?aF/Lr7e+5QXuOaErGMD9aEJ4D423A2uE1KpNL8NXgknRpcTdFrbriyet2cpJ?=
 =?us-ascii?Q?IqpMT6UIcArJZRvRJIE7xMneKxCo6H7xOJBrAbpVrAzIsQ5Qhni/9jMi97MF?=
 =?us-ascii?Q?xmccPuVhRHm9NGMhhJYgZJ/1EdBNowYM1c7LrznmWIXR0G8GYID/OVAbAIkF?=
 =?us-ascii?Q?JrLMuAjW3YmGNpP0pVe7zYSXXZTnh8+Jdu445zgWLCLE374W4/+PoLXaF/8x?=
 =?us-ascii?Q?w/FxYGkUVMa20M6LFe/HI6OEIuZpY+kJE4WQpgRo8XcWW0ED1lV5JNwNcKsi?=
 =?us-ascii?Q?ti10OSXgUtUhxHcjDCxZGpPEABNzgLwvYFEd0TGAVQTqkglIiPS4DUwEkwxf?=
 =?us-ascii?Q?lFSKR3Wrs1GWSUMoYUxiSeZhkncA2e2Rs2QGSayJxw=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?3IwFbjXwt2iAG+QiK/os5HhtxPhPi9ybGzu4ATyxeiN05zkZnGVDgrrAM+iw?=
 =?us-ascii?Q?chtrB83Ctb3O7dyINEPJidg3GslgJeFFlPlpBpxYDxizqt6gwFSCpVY2NBgr?=
 =?us-ascii?Q?9Xx9svl/4fPdi5k4rMM8mvgLMJFcwDGLImE3f/graZEVGRgVPbJBx/OwwQGZ?=
 =?us-ascii?Q?Zxd7TtOYHNnf+xrfvyvKj5GpNbn+DN5EEu1Aa0T2GUMNGt0GkpCZe+FzMDgI?=
 =?us-ascii?Q?lMM07PQggmbqoKUbooi5UfyifuEt75rzOh30zBzzSrSTKWJQ7PtxhAaQJWQw?=
 =?us-ascii?Q?/cvYaVj68DP7QRcli3RMW+V5VOAC8/9rwDWvfVdj5755P2JfjPVbZ1u2iE9d?=
 =?us-ascii?Q?bocjrW6J2Yi6sytHxuFD+JXnZlrr8xx2vlFCe5mcbhil+guUZChnKVwBXHtV?=
 =?us-ascii?Q?rieIP7+AgaTivwvCDE16WLFaQ6EKUCwCS6I4RcAOYYebRUmRvOOsMEnhc11x?=
 =?us-ascii?Q?I+hkkswCYXqwKiu/QUOH3MB0irN9rr5AJni8vSabrFuqqCGvBkZKLaHKe8L9?=
 =?us-ascii?Q?csWp900k3kUvpb/tWk3yzVlAu9BlePtiyKCB+aKTS3K0J5OnSJiwvCbHe6DV?=
 =?us-ascii?Q?mexruJKsTsRyQLfXgybMKVFAckw2AmG5EeXlWTBpbDusW6Tx8SSyJlN76xkZ?=
 =?us-ascii?Q?jEFdwh+k5OmI+Cxubg/fcVWcYVjMwsoLlor29xuhHdMqWARN2QOcFe2OEZsh?=
 =?us-ascii?Q?aThzNUTsHaCjCqgyWbYWhaqwIscJoF/mT2May0v7UZv9UEDbnMIYAFcxE9D4?=
 =?us-ascii?Q?ZNt6OcfKa1+Hp6xSFqC1HWN2YDMFDWYu9/cjodQ50DJYZiGQlks5EobyTMVh?=
 =?us-ascii?Q?yav0SMxJNbarW92Ms5i2vs9g6XRavwhUT1TmwiElvQS9hAouec7E/dsYPGmM?=
 =?us-ascii?Q?Z/rj/R8XgTOTWB7nBqVfLcxtmLuZrcQDhnIRBC+2wd+QcAVyXQbgNUbTUa3T?=
 =?us-ascii?Q?+Ue/DsL7QGG4uwpo3tSNFZiFCpr4XakLLrqNqvvX0NNiX/SHBJ0qGWbRL28F?=
 =?us-ascii?Q?sutO5D2gbEb+adryY8z4U0lb87pE0ht7awEjTKGYjBckzEMK0MZUJQYNMmPr?=
 =?us-ascii?Q?sDf8Hdn8jCIcTbrupuyo/4KYGS7/xwzeYQPZEvVHzSiAtDg+qMEGCKGEfMzj?=
 =?us-ascii?Q?9nqUhwLJiUQOWOpwuTSb00CNvgFJqxh0TCBSbDuM4qzsVIPCMEw8gSbbp6bS?=
 =?us-ascii?Q?jBThG609ytmGYTgnJr/eX5Ug4zFUFzuNi0+T4w7+t/+PraaWCO8+gWlUfXcv?=
 =?us-ascii?Q?ozYQKqAUCO40TPg00COWf9KGlRjYCPnQWj9oZMMhbyt7MDPgcwksTzs2mYhu?=
 =?us-ascii?Q?nha+Ons19Gxy6fBqWbVzkP6OV3AEXmi0oJ9ec+zm3whjzfERfzq8sSPlF6ze?=
 =?us-ascii?Q?x1cqUnVKfY+PuNc3b9J6ZyzcMA+96+AiVXAQAiXhIPFA0OIzQ8zWk9ipZRn8?=
 =?us-ascii?Q?oAL6enFdrcwMaWw86aGMKhTfkr6hNFozdEiNMJCNwzSFRVg+zbYYjrzh5B/R?=
 =?us-ascii?Q?Af5yUnzd3Dl/cFws/sofU6ds9VlLJSN/J89cguR3K4Ez84d+bUHWrXzeS2su?=
 =?us-ascii?Q?LQuvpeYctgsP1rckadTJ2pt6haXwR1OtO73agcB/VQ6yPApk8j0NhKG1fuQS?=
 =?us-ascii?Q?VQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	0GUq305l/cOkq5EQQcv6BCbKOI7hJmLHKwLaq+Iqh+sMiudAGeUvMLD1jq4SrCctiyfdl65ej1JC836xAMPNRcMrGi8D29iFjmE+lGlsxgbR7Tu/WFvkL4wqXODERbqfHEcl1N0LC+HDtMWexZPj0GEKfwg3zpPjErTZmWudGW7CpLjyXW1osVGhx1RWu+D6jzMO8hTxMq87i19vBgZS/vnv4/a+E4et/jMcNj4Wi+cO6A0X+772IxZt/upB26g7vtHDCf30+BE+znqRvv6F1T615uw5RrJuLZ/5/3Hch1P9UvCjNvOibIew9Z0u1udJ0jHZlGft0n3S8qUqpj2ITA7Hs5ze89JOzDPY83fBKNxveJJfgGRm2LENcULI88IEGaDgRWiRWkB4Y6FEuKL9ZoaJasxj8N2AGaE5/YwHR/rvBdDmcp6rRdrfUvz33+Zd2aWlfIrWhQTfhPcxcR+3ZNWier1s8Ef07FH6WBL/Vg64aea03o1uQ2+jzbAjGTnK3grIW4AY/OqDf9IrrrBjsPf2I+fT+LBs+1XOIWwX+rsDF/uacr1pNJSTHXjcNuh4OICrN3FkBUXSBcbVzHIK2VoZ7TKbgtliAMuE0edm9mY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97c99ea5-caaf-42e2-232e-08dc6b276b78
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2024 04:13:43.2306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tl1/0lZtcboCdwSrbxkKDxO2XqolEhiPn49gYtiOGGzPTb5FGnjk8JcdpcsfksKSsMIBqXQ/zps6D3ANsmQzL4SNf35KJC1J7rDp0uEkkp4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR10MB7949
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-03_02,2024-05-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=810 malwarescore=0
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405030027
X-Proofpoint-GUID: t---21aPXg4hwl6L23O02oGEARWdxbzZ
X-Proofpoint-ORIG-GUID: t---21aPXg4hwl6L23O02oGEARWdxbzZ


Christoph Lameter (Ampere) <cl@gentwo.org> writes:

> On Tue, 30 Apr 2024, Ankur Arora wrote:
>
>> ARCH_HAS_CPU_RELAX is a bit of a misnomer since all architectures
>> define cpu_relax(). Not all, however, have a performant version, with
>> some only implementing it as a compiler barrier.
>>
>> In contexts that this config option is used, it is expected to provide
>> an architectural primitive that can be used as part of a polling
>> mechanism -- one that would be cheaper than spinning in a tight loop.
>
> The intend of cpu_relax() is not a polling mechanism. Initial AFAICT it was
> introduced on x86 as the REP NOP instruction. Aka as PAUSE. And it was part of a
> spin loop. So there was no connection to polling anything.

Agreed, cpu_relax() is just a mechanism to tell the pipeline that
we are in a spin-loop.

> The intend was to make the processor aware that we are in a spin loop. Various
> processors have different actions that they take upon encountering such a cpu
> relax operation.

Sure, though most processors don't have a nice mechanism to do that.
x86 clearly has the REP; NOP thing. arm64 only has a YIELD which from my
measurements is basically a NOP when executed on a system without
hardware threads.

And that's why only x86 defines ARCH_HAS_CPU_RELAX.

> The polling (WFE/WFI) available on ARM (and potentially other platforms) is a
> different mechanism that is actually intended to reduce the power requirement of
> the processor until a certain condition is met and that check is done in
> hardware.

Sure. Which almost exactly fits the bill for the poll-idle loop -- except for the
timeout part.

> These are not the same and I think we need both config options.

My main concern is that poll_idle() conflates polling in idle with
ARCH_HAS_CPU_RELAX, when they aren't really related.

So, poll_idle(), and its users should depend on ARCH_HAS_OPTIMIZED_POLL
which, if defined by some architecture, means that poll_idle() would
be better than a spin-wait loop.

Beyond that I'm okay to keep ARCH_HAS_CPU_RELAX around.

That said, do you see a use for ARCH_HAS_CPU_RELAX? The only current
user is the poll-idle path.

> The issues that you have with WFET later in the patchset arise from not making
> this distinction.

Did you mean the issue with WFE? I'm not using WFET in this patchset at all.

With WFE, sure there's a problem in that you depend on an interrupt or
the event-stream to get out of the wait. And, so sometimes you would
overshoot the target poll timeout.

> The polling (waiting for an event) could be implemented for a processor not
> supporting that in hardware by using a loop that checks for the condition and
> then does a cpu_relax().

Yeah. That's exactly what patch-6 does. smp_cond_load_relaxed() uses
cpu_relax() internally in its spin-loop variant (non arm64).

On arm64, this would use LDXR; WFE. Or are you suggesting implementing
the arm64 loop via cpu_relax() (and thus YIELD?)

Ankur

> With that you could f.e. support the existing cpu_relax() and also have some
> form of cpu_poll() interface.

