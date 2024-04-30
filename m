Return-Path: <kvm+bounces-16261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27B558B802C
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 20:57:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 474501C222BA
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 18:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17623194C6B;
	Tue, 30 Apr 2024 18:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tc5CcSYd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xYF6JT0E"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1B717BB1E;
	Tue, 30 Apr 2024 18:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714503461; cv=fail; b=dBdq1vdzubJ2ENYMwNmAqliY02wJFgTCK31IsififYqEaZPNk8WFsBWNOO0JVgJ0s7P6sQNuPtgBOw6q8CrpllF1TUOVPb/EJWsSl7C6a41P8Q7+yVRJHY7Cb3yX4trQfP4mdLUhrvVSgVP5g5LLEqL2Uehj7+MHwQpXClhRmLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714503461; c=relaxed/simple;
	bh=FEGzQW6+QB8y4Pmz6Ubm1+sFxjmZomZfD0acXJX71ZU=;
	h=References:From:To:Cc:Subject:In-reply-to:Message-ID:Date:
	 Content-Type:MIME-Version; b=ZnIrMSzLrNp83yaKkJwh2kagEtSuDGi1C3e7XJ3GWOdhwLkmCtTjdlK2LCe3n6ZImouItlR5+KvpJf3NU3pRcZVukj9bzhbBlnTW2ByE2kNAF2P1ffK2EOY+FhW4K0hVFxhec0zLHqWTb8Dk6Wd+s0qynErjyyyhOePGxYQVcPc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Tc5CcSYd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xYF6JT0E; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UHIirG031819;
	Tue, 30 Apr 2024 18:57:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=rxuqjcoL+jf5osA2Ri5KiPe2E4WAq5j8FTukf9nMbE4=;
 b=Tc5CcSYdIjp7ZegoehcgG0FqZ7ETnMIcrRKT2pCr9o7sG8NLxvG7ok5CpYvYqVLkhUyl
 uhlri/DkMZt3qhD8WPT+ecSj84z9S+LlS2g1lqHe3ofK7quaZ8vHJb7U+1xQJZB8k8cZ
 OahKS8RAg/e3xj1OsM72ERR8oiSM6is2sM0Rc9rKzjaSaRiNXVS5EbyVT7vat69jlc85
 kAM8OMCWW8SDaxzaIJr7oQJx3uihttWOuknaYvbYRuEmII6EzEpxR634GkPU3cfjK7Z0
 qSTiZYjXtezJRsCjuZiqcH1YGOme4OMjZK8ZOYs8bkFEzkVKQKONEX4bApoob5DQq7L5 vg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrqsewtsd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 18:57:02 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43UIZfaq011502;
	Tue, 30 Apr 2024 18:57:01 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqt8d45p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 18:57:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/GzlfUdK15Ve7ks9yMz9hPa9AB/qB8zIMzstOAAdAhmxE3+qMdHix7+40kjwCz7hdKfplBj17lzGuhUQYmx6jvtU0uvIvvcM23E3CawHual/y41BvRjN8lE7tos0j2ccQY+tb0oGeOeWPhShjtrrzWPbx0DB04kSqg+w8v/YJFvJku/j0MreiXWCcM2IWlRp+Z00zljlBXh5Rnn632FnCXFtWZXR5js48ofi9ksafoVRWYudA7EcSvUX2POhqFipy+K/IF39w/czNLFn3hgvb3VHkOMkxkbEMvh/vzjbA5XTL40izJCnorHPcvzpjWt1Ra7ZJ/6YmWqW7fVKyQ/Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rxuqjcoL+jf5osA2Ri5KiPe2E4WAq5j8FTukf9nMbE4=;
 b=UV0ZgBH5Qow75BJ0xLh599fso2vaAPSAjjh73WC+umOcbHbfOMfDd1CXemCfYVKiGxGZMkBKmCjNN/LqSyJ0LbQ+WaHK49knio9J36MsII8VjyR6fT/NF/i0cAe99pVUw4sGSLbmxL1Kk/87k/LoACwWzW0LCHZcXzr0pb+iJyuPjuRAmA3w9V2eg2nC+wxik3y3tLNvLM/cwyL5A//TZBcc+wTImUI5dS+YtlvA342LgW/z5Ah0PQOd2mgiBQO+s6ahfqhXOnLpPY5J1yZ1cxqpJ7pltM3yJT/w8rCL7YAmpTgpcZJzdb5sTrmNfBO0OEUICpuQKuGdnP2J8phD6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rxuqjcoL+jf5osA2Ri5KiPe2E4WAq5j8FTukf9nMbE4=;
 b=xYF6JT0EQEg26PgMfIkGLvINGOXp2pzRJrQppKS3EaQq3Wo7UHs/J+CRlkKzqj2Dz5eAmag54V9qmXT8OgnehnVGlb2cex/u5MIsdtInrFP5lOAtgPRYR2vhlMMZsZRPOYbSSXenjgop9OkheMdONwXBeUFUoiXXm5woOOA4hPs=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by MW4PR10MB6606.namprd10.prod.outlook.com (2603:10b6:303:228::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Tue, 30 Apr
 2024 18:56:50 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8%7]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 18:56:50 +0000
References: <20240430183730.561960-1-ankur.a.arora@oracle.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
        arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
        harisokn@amazon.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH 0/9] Enable haltpoll for arm64
In-reply-to: <20240430183730.561960-1-ankur.a.arora@oracle.com>
Message-ID: <87y18ubrwv.fsf@oracle.com>
Date: Tue, 30 Apr 2024 11:56:48 -0700
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0298.namprd03.prod.outlook.com
 (2603:10b6:303:b5::33) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|MW4PR10MB6606:EE_
X-MS-Office365-Filtering-Correlation-Id: dd82d738-11fd-4da3-5ba1-08dc69474b41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?IbxqIWFqSq0OY5K/DbwJXGk2a56dfTNc/e8tdvhdi2DeFxj6bNIA/OpwUyJs?=
 =?us-ascii?Q?F0S4slXK7EtND02gBt7TSHP9jncVpDv3lhrBH3aWsw2OZbmgd3EEDR6lqFq3?=
 =?us-ascii?Q?Tv5gHSYjDmSb4zZYSu8hzvLHtG80yrJymu7w6xp69gKWG/kCVvR04tkz8Cvs?=
 =?us-ascii?Q?jmC8wb1K2kynQ1+0JqfQnI4EAjkrX7jlavpq23f02BaKL+LrGYPeYLr4StW/?=
 =?us-ascii?Q?26mlAWXfvoK1Lh1BFiWXwI2fJQSfbbl9XQbzcTMQy2hkU7q0jiGdgbKkpWDL?=
 =?us-ascii?Q?Rfp/l9Cv40qsAVetVN0n9w1wcjhgoIYq4oefcdEg0oM7i7O+St3JK864vsCV?=
 =?us-ascii?Q?ZchmvaRh0VGgtl+wm/HXGR76N+c4h0SJhDHYtoRk/X55+gm5FWrSthex4lIl?=
 =?us-ascii?Q?QgPtnHnE0Dc0n0u5UQx6hQfBIpAm7m1nAVyxKSQFGcCdcJmvfN0d6Hrm3TLW?=
 =?us-ascii?Q?HvgI8lKAgV+1rSXhjQRN4Zh2S09QA6ox+IjftNXQbp1UGymYgLKojTnrXBGW?=
 =?us-ascii?Q?6tCg6ccheas4FoizGzzHTw3nivUAom9P0NLCbMze6Q3Ags8DUFF8Rs7NKg8O?=
 =?us-ascii?Q?FrwwIrTYdMVEOPeYS5cI3xD2o7I7g8nJi8ejUc6Clq7AeXeCNDe40ZtRj5xT?=
 =?us-ascii?Q?xPX92GGaAU6+SdWfCwkEQn7pXA9uErYDT7ykdBKATeHhwRblnGQiGcujl3Kx?=
 =?us-ascii?Q?3kr1K3UaUkBT8m6vbx4nmF8prsozTtkQPrFzx0rI27//sKHqPktPzzuHiGcn?=
 =?us-ascii?Q?CvPxppwY+1MgdVjRytinPsWGdbo2SdQ5gkwtqxrCPZ+9R+ZEVopc9KFGT8a7?=
 =?us-ascii?Q?93lqzmbGKJnsKGyA4NxwPBJXqaftJnJLcEQ5xRDkQewvdkaVktiBkHmh8nec?=
 =?us-ascii?Q?bmyyfBvatO4ra5AILlqh71ZezBWgOsRbayWNGk5iaX4alF0rd0NCbRUuZfcq?=
 =?us-ascii?Q?8w+bHSBidMpD6eOO96UFQgKX+kY7VgyFb3lyKWBsAuaQLPlByBXODhxMQ2zX?=
 =?us-ascii?Q?8zPLdggnm5LJq6AJW61PDITNq4GfEeY7FChTi7L+C4O6NtzFymk5YV8PfmMR?=
 =?us-ascii?Q?EyGYz4N2zKk14L7/P0RI5W6joaGOTAuzdV6nFI0p5J3HHH618pDrU2tTMBZV?=
 =?us-ascii?Q?SiflLeBAjrt1hStklRc328Riyo+qL8ZQsifD3dcLi6gM5QVy2ocK0fFRdDdO?=
 =?us-ascii?Q?WnTSMGkzkeRu58pT0D9I9jCWK6Uo4D7kgNSSSj0D4YRuNbS+vyGIZf2HdFzq?=
 =?us-ascii?Q?iBuqd8KCC24MxoBI0R9mxt6MrpuqaeP6lCSz2zPWvQ=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?qmrEnLHCIgARarzivy1Q5Rp9d8s2YkrMGIZoX3l5VDXSinAP6INM1cCuHJle?=
 =?us-ascii?Q?PiJKujj9iyHqkTglIqPSvtGifnV6j+uqHWz+WTnvtezwNdN5v46nLIpZuDfT?=
 =?us-ascii?Q?Yx65cHIHytumfHsBc91qh782jqYBqc2K6UDl/g7wp42nymuVW6ttiopxJ1l0?=
 =?us-ascii?Q?hX6Tlku/afwqRRHKmD2lSZoMwflenrI0ybCwuWNyU61DwzQodOuw0nkxxzUa?=
 =?us-ascii?Q?qmSDraMTmrzsMdl2I6Qev+yoksBOE+/K1Dbq5ZOQIlaOyMEfuoFfU+mxx5TU?=
 =?us-ascii?Q?22R5o7rIh4HCQdFxHo6SInNX63R5zzvd4fxguTTn5kBtM4w5cf4URWv8WpoL?=
 =?us-ascii?Q?LDbCC2LdDguJFVxsaw0bM/cgBUac0laip6nOBBhjKqKxAyXpv7c9R94ifBbr?=
 =?us-ascii?Q?m5b0NFazhKtZrpKMZd8moN1mzPZ7oDVlgDWZtGI0B00lkX42ponyq2mfd36A?=
 =?us-ascii?Q?uaK/3/T3DVlCp1ymDug8xfsrUeGDBFiY0IHLiKQhWlBxzqRtVDIVaJTmniZD?=
 =?us-ascii?Q?kzM0FIGMF4lP2XxKW7IXq50kFnDetx0muPI3ZO3HOwd7XgNpGyXmNs5SdVCR?=
 =?us-ascii?Q?qiKxEAuP1nYJE9Vu2FB47TuyqySKqlmfCpUmTCXI7jFrtN2OPcJ9cPnLOMsV?=
 =?us-ascii?Q?fG05a/qukQb7vNEaomdT6mQE+zpwJ9gAsKz785N63SWAaxIL4nLNbUSrAiY5?=
 =?us-ascii?Q?kb0PKREVnhrwpeqq2OBol1YxEo0KpVkNorosyMpYLlETNeY0uGGv7rsBAeSs?=
 =?us-ascii?Q?euCxg24zrnhMxlOcgV0mHNmaZhqW6jlSLL0HJAZrru01cv6dzYX4GnodNVLo?=
 =?us-ascii?Q?dlWTFpH2WLaWXIKO3jlsQ10K4n1WZS/2ClM3z2YWe5iE/UDmuNEgcJgA6GT5?=
 =?us-ascii?Q?P8+R7CtN3PFqVX9JLH9PNEvFxocl7vgNjYq+3trbkkh0VyeNFjOtPoIBU/G9?=
 =?us-ascii?Q?g5F2+Em4563Wi5z8BH6UdLDpCmOhdKmZsMhR5hgUoRGRIuuiOjF70qVowYhL?=
 =?us-ascii?Q?m1ySpn0Us6Vpik0OXf7zh4BglbN74jDv96TZA5po5Mlma3dXzlEnvbyDvDje?=
 =?us-ascii?Q?YL0V24DwPS+cNkugTGBBoQR9MPpWiTy+ddD88q9BvPit/RlYAb+RdoguNBU8?=
 =?us-ascii?Q?XMTIcgdth1F7Gy3mAqnoqHsxNCB5daNO5edouHp+NO4Wxc7Fqh3UBSjAl7tR?=
 =?us-ascii?Q?cORM5KVi6mPnqA96DaNjrXQHNW/t6eafFuiq+1KQdHtVXP9y4f7BH3JrjPzi?=
 =?us-ascii?Q?brg+9aKwTpPY5G0DCRZZPFManVUtRdeRYC+fH8hSTsBLn1+yVsQ5I5QHd72m?=
 =?us-ascii?Q?qOMXTB+OFaY9Zv/QdUwYkpHa3tH4WJUsaoL/LD/NlwIS/jpozTe3F05dYKBm?=
 =?us-ascii?Q?pFT5Oe99paVU82eswwB6UVOi5fyH7CYI7b1con01e/4JuOdFLDGipAA0CtDr?=
 =?us-ascii?Q?cjSV/k6XcBauBoYKxE5QeUGPnoPcEaWNr3W9ixbPlXjNZTfHWAFbUEj2NDzK?=
 =?us-ascii?Q?rmH291rNzavTtAekVwj+vS0RWT81xCERFbl/yWSoaN4IZM/GGOj8azff0ffi?=
 =?us-ascii?Q?ZSk43kbf4xVyvOI9sP0h1lb4DNMFy+U5d6EMqDuxaRp7JAqdWI8yivKpkEaR?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Qir7zLj9gnCUTtJz8q9XbsKcVokMzscol1ek0youJf8bXCivDuWB437YyKkQeaKCnbH1fgpfMFQR3AHz4Jc1EgXDjJQUkqNMkwHkifvMDH4DOOK9xBA1e4sK3kBXtWW+u8lPgaVkTK7uKrOeQxoPeA5N3xV0VsjprAyeaZ+Pdf/x+wWoKFQ9xUOrXmX/bMAZxW8+brx2xVnS75b6lbmyJgg7ZpRnkpN9BYgiaGrY1rX6ngBwvkr1azULCRGjOQmu37aDJyf7szQyKk3eNboP4Dy8W9xkDmQItqhEg6jQNDMMZZHMokmKXZ5viz6LzKIQ1WI84cOK9g6hBeVD+/TI1ZCB+TKuNB2OjqvqMvDpJczCIigpZjmb+wpcqn1tx6BsG0d5MCB8oJaYfiFpGNg+xUFD2fHsJsLU8GRbEQJr7U9qgwP9xadtr7J93/aPzq7wMjxqJXUFVmmk2ygdlB0B6JbgPrAyfKY7ZyCLS8mKD/t1jBL7apFN0CmNwWahT6jqN2nXQCxjqSEKjTYUzFnsbpeKyN8Vq6VTSGt+U2RhG/4Fb/0JdFVdhq2pTJu0Q2JaETGCh4WvAz/i6kysfwLRTen8sOvRyhKeuG5eyfcp0F4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd82d738-11fd-4da3-5ba1-08dc69474b41
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 18:56:50.7067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dI6gUZl0YyzwdTZRccrBuYYwH/TxaYAV1glcrEr5hg6Lp3/mAsXA3trXQ+2OU9qUK3QFGg4jmL3f64OVNMmiWazoZJlW61KBfE5H3dQqcJ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6606
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-30_12,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404300135
X-Proofpoint-ORIG-GUID: zXfGw4lMc54dAPXrH1AVHx8wb7hAZBBG
X-Proofpoint-GUID: zXfGw4lMc54dAPXrH1AVHx8wb7hAZBBG


> Subject: Re: [PATCH 0/9] Enable haltpoll for arm64

A correction: please read the subject for the series as [PATCH v5] ...

Missed the version number it while sending out.

Thanks
Ankur

Ankur Arora <ankur.a.arora@oracle.com> writes:

> This patchset enables the cpuidle-haltpoll driver and its namesake
> governor on arm64. This is specifically interesting for KVM guests by
> reducing the IPC latencies.
>
> Comparing idle switching latencies on an arm64 KVM guest with
> perf bench sched pipe:
>
>                                      usecs/op       %stdev
>
>   no haltpoll (baseline)               13.48       +-  5.19%
>   with haltpoll                         6.84       +- 22.07%
>
>
> No change in performance for a similar test on x86:
>
>                                      usecs/op        %stdev
>
>   haltpoll w/ cpu_relax() (baseline)     4.75      +-  1.76%
>   haltpoll w/ smp_cond_load_relaxed()    4.78      +-  2.31%
>
> Both sets of tests were on otherwise idle systems with guest VCPUs
> pinned to specific PCPUs. One reason for the higher stdev on arm64
> is that trapping of the WFE instruction by the host KVM is contingent
> on the number of tasks on the runqueue.
>
>
> The patch series is organized in four parts:
>  - patches 1, 2 mangle the config option ARCH_HAS_CPU_RELAX, renaming
>    and moving it from x86 to common architectural code.
>  - next, patches 3-5, reorganize the haltpoll selection and init logic
>    to allow architecture code to select it.
>  - patch 6, reorganizes the poll_idle() loop, switching from using
>    cpu_relax() directly to smp_cond_load_relaxed().
>  - and finally, patches 7-9, add the bits for arm64 support.
>
> What is still missing: this series largely completes the haltpoll side
> of functionality for arm64. There are, however, a few related areas
> that still need to be threshed out:
>
>  - WFET support: WFE on arm64 does not guarantee that poll_idle()
>    would terminate in halt_poll_ns. Using WFET would address this.
>  - KVM_NO_POLL support on arm64
>  - KVM TWED support on arm64: allow the host to limit time spent in
>    WFE.
>
>
> Changelog:
>
> v5:
>  - rework the poll_idle() loop around smp_cond_load_relaxed() (review
>    comment from Tomohiro Misono.)
>  - also rework selection of cpuidle-haltpoll. Now selected based
>    on the architectural selection of ARCH_CPUIDLE_HALTPOLL.
>  - arch_haltpoll_supported() (renamed from arch_haltpoll_want()) on
>    arm64 now depends on the event-stream being enabled.
>  - limit POLL_IDLE_RELAX_COUNT on arm64 (review comment from Haris Okanovic)
>  - ARCH_HAS_CPU_RELAX is now renamed to ARCH_HAS_OPTIMIZED_POLL.
>
> v4 changes from v3:
>  - change 7/8 per Rafael input: drop the parens and use ret for the final check
>  - add 8/8 which renames the guard for building poll_state
>
> v3 changes from v2:
>  - fix 1/7 per Petr Mladek - remove ARCH_HAS_CPU_RELAX from arch/x86/Kconfig
>  - add Ack-by from Rafael Wysocki on 2/7
>
> v2 changes from v1:
>  - added patch 7 where we change cpu_relax with smp_cond_load_relaxed per PeterZ
>    (this improves by 50% at least the CPU cycles consumed in the tests above:
>    10,716,881,137 now vs 14,503,014,257 before)
>  - removed the ifdef from patch 1 per RafaelW
>
> Ankur Arora (4):
>   cpuidle: rename ARCH_HAS_CPU_RELAX to ARCH_HAS_OPTIMIZED_POLL
>   cpuidle-haltpoll: condition on ARCH_CPUIDLE_HALTPOLL
>   arm64: support cpuidle-haltpoll
>   cpuidle/poll_state: limit POLL_IDLE_RELAX_COUNT on arm64
>
> Joao Martins (4):
>   Kconfig: move ARCH_HAS_OPTIMIZED_POLL to arch/Kconfig
>   cpuidle-haltpoll: define arch_haltpoll_supported()
>   governors/haltpoll: drop kvm_para_available() check
>   arm64: define TIF_POLLING_NRFLAG
>
> Mihai Carabas (1):
>   cpuidle/poll_state: poll via smp_cond_load_relaxed()
>
>  arch/Kconfig                              |  3 +++
>  arch/arm64/Kconfig                        | 10 ++++++++++
>  arch/arm64/include/asm/cpuidle_haltpoll.h | 21 +++++++++++++++++++++
>  arch/arm64/include/asm/thread_info.h      |  2 ++
>  arch/x86/Kconfig                          |  4 +---
>  arch/x86/include/asm/cpuidle_haltpoll.h   |  1 +
>  arch/x86/kernel/kvm.c                     | 10 ++++++++++
>  drivers/acpi/processor_idle.c             |  4 ++--
>  drivers/cpuidle/Kconfig                   |  5 ++---
>  drivers/cpuidle/Makefile                  |  2 +-
>  drivers/cpuidle/cpuidle-haltpoll.c        |  9 ++-------
>  drivers/cpuidle/governors/haltpoll.c      |  6 +-----
>  drivers/cpuidle/poll_state.c              | 21 ++++++++++++++++-----
>  drivers/idle/Kconfig                      |  1 +
>  include/linux/cpuidle.h                   |  2 +-
>  include/linux/cpuidle_haltpoll.h          |  5 +++++
>  16 files changed, 79 insertions(+), 27 deletions(-)
>  create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h


--
ankur

