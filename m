Return-Path: <kvm+bounces-39165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7470CA44B08
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 20:07:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 945203A41CC
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 19:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 370EA1C8602;
	Tue, 25 Feb 2025 19:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F2cP/xSu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TB+9X/Q7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64DE376;
	Tue, 25 Feb 2025 19:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740510419; cv=fail; b=GdmlakDl+/F02+siNh+Uke7zWS1GJ9a8FqURvog9dwZ0U69ArHWwrCb82zA9J6k/2Mvp67wWS1IR2k3Pb/TR0fU91SmGCx7WEFCyK+K/kdDZ3Q881ovygb4IOePwVyDCH1vUbiSymewsT9+21bel4hEILkpZpTWgxzpaBHSUvqo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740510419; c=relaxed/simple;
	bh=lAu3PmaSZnkyNFBqHeJ37WbK/jyzRrdKFsJeiVTVqq8=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=avFMi4nvIAGtEziTIilVhMhce8PoPRbnCCC8TeF0mDywQ+d3vWRqInwVJO599Nbmz/dxj89lQC0pZr3xh/SjtR9Q16BB52qJTFlybvgWLxrOEx494/cHPe09YX51qFslAao2N5Y76iahqvnG1jRyKY3lFLf/tA24filjCUyhHMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=F2cP/xSu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TB+9X/Q7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51PIXjaK026155;
	Tue, 25 Feb 2025 19:06:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=lAu3PmaSZnkyNFBqHe
	J37WbK/jyzRrdKFsJeiVTVqq8=; b=F2cP/xSuhripNbYT30Bo15fxAySoHgvOWM
	14wrZpyRVPbQu9nGSyM51IRzrBeAjOaD8u+Q4XluDcrKS159QFcpBA8Hv40D64YH
	3eAcQA97X0dJeNmxLtcbESVeuLjym8mhGGHN4Wo2mHO2TFMXd2Ppd1KbtNacqKm1
	rKs5WomS1X/pcjKv72lGMIwjgEz5lLlrun7pIgTzv4Xd/DiClz5GcVKNQ0Wes7Ok
	f71Vc4ukYZkprDGHE8Ad7O8g6rWiiYJqC7ec6+sryN+fTPVJzrBewOpVtjYcDbUs
	TxfYQW79D+UUMj6HDiXpyCu5kxggOF8GqEykFfcu5ka90Sx6oQ1A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y560635x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 19:06:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51PHdwtV002799;
	Tue, 25 Feb 2025 19:06:20 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2171.outbound.protection.outlook.com [104.47.73.171])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44y519wpgy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 19:06:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t9nNPN5KZMrKRaoMpBVIfBIgWlz8ghR7qZgnfYH0CyIDKr7UHiP9UOq834sFXqitax6gpYTsEzrzqRfrru0jogwHYLubbenJIHwHdp2JIM1dxlhBnwf77T28ghCOAbTQkFHj20LSUtlh0bPkbkrEEMNQHkG7fvVo1Hg2IWqWxE+xvKLk4Fju0E01UL3XN8K7TjRFZgLCFtR7qBJFo9ZIZ9svl2yBlmqs+WFcCrlUT/qScKhiZjDjVlzSqqar7fD+wXW99ElaLUNgD6x3rUWMBsYbiOrYWqp4q5vXiH+ZqpsvadfrZB3ZF8Ky83mqmdxBFRJ3a8fTgztqPdzwNan0bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lAu3PmaSZnkyNFBqHeJ37WbK/jyzRrdKFsJeiVTVqq8=;
 b=HNHqY1JyOSRureuuz2OZ2dCLWBe6Mt+aUThnO9I1V8D0V8lwnObz4UWktNUHDHLUUc2e69Ke1yitjlV823etbXpzpuIRhEklEOtTkDTfwbynctJOZLgwEvQ4RYinNZSSWXTACwo3DOXnJXSX6B06wHHwqLMMTGET1yAmihKfjuhBlDVZnROlkVFoJWNikXGy374takpEjRSRa+O4HNz33U/ncfR8tvMXYrfEPsWFfMlKfW3WTjg9IDo33TTOijY3pcSHLYcPypvTtlJ3wghzovZFcbUI/QxW6YxS5qXsDvy9jS3hZjt3Pbp1XdS+PKRqqmc8HdMIfjHweGmMn7SdXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAu3PmaSZnkyNFBqHeJ37WbK/jyzRrdKFsJeiVTVqq8=;
 b=TB+9X/Q7ITUD5p56v0O/N4/H3yF/zKx8v/hEY+Bbsyk/8VZISHz1WTsWTuVi0iRlToOFJTZRYjpRuJppUjBCycWRo7zQIrdZLWPjmoNSW5srL+hISxSkPKjUXPcpuDKZtOIRUrDfbLzSp8r+VilxvEMBsvf75gyaEZAXMGgebqQ=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CY8PR10MB6634.namprd10.prod.outlook.com (2603:10b6:930:56::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Tue, 25 Feb
 2025 19:06:17 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%2]) with mapi id 15.20.8466.020; Tue, 25 Feb 2025
 19:06:17 +0000
References: <20250218213337.377987-1-ankur.a.arora@oracle.com>
 <20250218213337.377987-9-ankur.a.arora@oracle.com>
 <6d035996-8b8f-3d3d-d41e-6573f8a76f31@gentwo.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        catalin.marinas@arm.com, will@kernel.org, x86@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
        lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
        mtosatti@redhat.com, sudeep.holla@arm.com, maz@kernel.org,
        misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        zhenglifeng1@huawei.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v10 08/11] governors/haltpoll: drop kvm_para_available()
 check
In-reply-to: <6d035996-8b8f-3d3d-d41e-6573f8a76f31@gentwo.org>
Date: Tue, 25 Feb 2025 11:06:16 -0800
Message-ID: <87y0xt26af.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0256.namprd03.prod.outlook.com
 (2603:10b6:303:b4::21) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CY8PR10MB6634:EE_
X-MS-Office365-Filtering-Correlation-Id: 79d4e4ed-1159-42cc-55a3-08dd55cf7b75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hfLNWUNHq5Zv5Y4/PhnMIxsH/8REoGUwu6XDXTtJ8e5Il1Lcu96EY6vtgT9U?=
 =?us-ascii?Q?hE/goTUt7/gnnbNoEcgOuEmbT+QCoUK6CQH95anIyiSvYdzMchyE+uknfp8t?=
 =?us-ascii?Q?r96UkytSVvAXvC/IJd7fH/ut2efZbUJvssIC/vk+3et5mmfstUzpTh8VHJdh?=
 =?us-ascii?Q?DS5NsHgudfqMbL7TgmVQozAG9Sw/o3pSiiXjxEcLx3UEX5TVIkRg6bvCuiZJ?=
 =?us-ascii?Q?R97+mOBmd1hAD6SRaFPtaO4ZZujfb1FmZOaDrLC9Az0O8g7SUg5j/fpkZf7n?=
 =?us-ascii?Q?PGDEYSG3PIdGHGwO/FT6nAC3XZG8D7W9aThI6jz0idwoJzBlZmh1kjC36rzg?=
 =?us-ascii?Q?B9nFzkfC0884Yd6NS5R9/zM17DbMNKHPIMspXwcQYQ0kNcREWC3E6vlQwZ6F?=
 =?us-ascii?Q?EQ3pLJjfaZE9uBAoarEEvRys2XUu2cPpq34JnMllhcp5ROJkKLp5bQ0yLIcm?=
 =?us-ascii?Q?IPyiNrx18yqBmCww+D+I3CMovEyQkkNQEgX3DY79IYS9tUr65mNXfFYiYAbd?=
 =?us-ascii?Q?QX4ou12SuMwcWOiuC/k8NE3roRFOxeLhBSM7lqTfhqfIjdDMvar8y0tYRkaX?=
 =?us-ascii?Q?NoRc4v3zuuT3RFm6DBoFjksx7ugz/XADM0vxYM80XaW13/9l+NjrtYyo+sGJ?=
 =?us-ascii?Q?AhA6vBLhdiRM403BRfuaLYnaQ34khLxUmSBUbK/uEdp4PhiIGE1vThzlxsoN?=
 =?us-ascii?Q?qXMIvRyw/onYjIRNJ8TWQWHrGa2tqTwlRMbMyDA3DwFMLZwTnHiUCH7ogAPP?=
 =?us-ascii?Q?Nh8iG3Q8q8jVr+w9CyuIqlAzcyqq//vNVowOkR2yX/kfKbLWmZIWfWfRq5zV?=
 =?us-ascii?Q?lryDB4rUjIMe53jvbvAj3gnTilktQk5py6rfdPYm5zxgaGSnYLmmN9y2QaMy?=
 =?us-ascii?Q?EC+VcQT+GF4mjBQ9UnMAMjD/rUW5q95fthIeMPFSedyajWOxFNqhcoXEoOo7?=
 =?us-ascii?Q?dNAVzMqpO89vvzlgxLMptL7yMKvkcUmuj6nA30v0VONZ3338lW9/Yzi1iEGm?=
 =?us-ascii?Q?edQulrI4CKzbtMaIfUyRUx6Y+FAcNl0ILSlGXypKd0T+YuaExNIRQSbW/bp3?=
 =?us-ascii?Q?LQAvQSaUCZtysPoYtqA6Zol+0Zczw//xg/o/xF6VgbE3nAOntdx6hoLz7d7S?=
 =?us-ascii?Q?dHfpT1m3etZf/+9pbA2/YTpjASEI3Y5+tFsmVB+SkgWjfgazn6k/ZEXGpCWc?=
 =?us-ascii?Q?g37M3RYLMTltL5jeqKZdj6nkLeAte4Xr6kGtVitakWHZ7RKdetUUfSuSzlFF?=
 =?us-ascii?Q?qADVCc9e7Eld5mfBduAcsf1K7O9Z2KnXUe/EP0U4yvtbDHZE8uJVAGu2qO0p?=
 =?us-ascii?Q?IZyoiW1iD8zG9I3kbF407jk+E0Azb47UImMXMtho2nahO2o5uUU1Ww+G3bo1?=
 =?us-ascii?Q?w8lNbvKn5X43iLMeNtStmW4PMPPv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pDCFJ0IC5HstrXkp5FQ8DwjRDo9AQqu87zyOQpqpjEk7QgbT0EmH3riOfTh/?=
 =?us-ascii?Q?MBmVRMvD99fUS5MiZVw3DxzD4Khzo9ocXGHnAcqXSH7tMCez3VoPHANxcmgI?=
 =?us-ascii?Q?MRKVg9elB6ucuAzkK8w0527Hzhqny2XpC6r/ekIgPDwK4Smh6ul9Ntyakc/s?=
 =?us-ascii?Q?YE/YhIk0MU5MZtT7ZqIetp8msptK+FvfWHqgLerf+Wmf5XKoQHj1Imhj3TkT?=
 =?us-ascii?Q?OtFkFgXoaCYSWZvbNYcqP1cyT99xMKSr8jWmZy8v/YvyBrA0Fy06FjvT3O0m?=
 =?us-ascii?Q?RgmcEOiEdjuOCTpzPIBKM7PIOmQ9mbMNXiGuir2H0bdFKlaj+20LfvCMoCol?=
 =?us-ascii?Q?HiuuV/3ypNbaAHisy2NJw56nQmKWZa4PcQTk3UQCqUbt7gSetJGtHEg3o/ez?=
 =?us-ascii?Q?JQ6hX2Yjif7MYQXKWHzZL0r2Iz1FaV8xDb0pPPayUSLyGxo+H5z8wy5dAmTX?=
 =?us-ascii?Q?A/XDzrH30nCorXByblpClsYUNYwqaGVZM04UvXcqNYonzutnUCHjdN+R+3p8?=
 =?us-ascii?Q?JsNzURhR/P7q50xAaCZfPfcfFVhHPLtDzaCEvgZbJjhcVt/Vmvz0wEBCSfCr?=
 =?us-ascii?Q?vrv1dsAive4CzmMRLW6ia+gR3UFJhpGEm6ivM5rGtB7WBOpvgJO6+azA4A2A?=
 =?us-ascii?Q?6e1v8YCgHHc75TSVoUtH9BVKNNr4K0AoHqut8W+Oh6tb1hxb7f1yh2Ho/SoP?=
 =?us-ascii?Q?RLUuKxnqngECUQOj/hDLsMmFvnm5vw+g+ItEwcv7QkmPHJzlQfGJBHmNHXz8?=
 =?us-ascii?Q?NxbMojA6CpqGey8b51Kur3qstIezJUTuRYJBYig4vIraMxYQ+40+SmKdE7M+?=
 =?us-ascii?Q?KBIgkcmHCl8Cf35hFbamFKA94AGSGpV8coBIitGUtTJH2IMFkzAb+uol+pov?=
 =?us-ascii?Q?oxaSmnL1sCt1NLVU9W3RnRwvv9FKtoGYqOz1Nv2O9C21Jgm7+fropNY/M+aE?=
 =?us-ascii?Q?bvHLnRuU9b/aoYnLLUqVbO5d/EdL833Zc1AR+PCHy5H9vxa+0E2nkes5N/Iz?=
 =?us-ascii?Q?WnvlOrQ6mVsEVlYzvovRhtNUZsb7gyo0qTsPdyJwwkb9QhY4dCGgd1lR1hG0?=
 =?us-ascii?Q?VTN9z8j326l3y+f5w5y9UglRfnD2E22mlivgqo1QhFhISXMzh/sYkFDr2At1?=
 =?us-ascii?Q?m8FkPNSBbB1OqFlp6F30fPvneHrjoAAU0uB6D2kLbKI2/W7rAw3XLyodcyQg?=
 =?us-ascii?Q?4ng6p/elmc+h3mR2S8NUTq/KJdTtD/ncm6V0dhSSzcvU8KqMlnwKF4hjPjCR?=
 =?us-ascii?Q?4r+EUD+2AY90oi2xhxieLH16fehuxOoCaLKz3xF4aKuAjFkFN1LA/pupFRI/?=
 =?us-ascii?Q?LAlau5qQOF9ManA0x5PnWQWJhy6GZovVXvzrJutIlQIGrsxhOETKFhuGnJiN?=
 =?us-ascii?Q?TnxmnyjNsBDBLo7B7hq2jz+W3HHoMRywoFU70mKIyK0eZPw9KNSkR/vaYsUR?=
 =?us-ascii?Q?dd0ClfQFGR05W4VslWUFrPGz0tpZUAK7F6w7P4UkJqkEFxHsJrHYtBPI9sRM?=
 =?us-ascii?Q?HVxPf3FMacLjHv/s1uqVGnDkO2eKP3J6V/NRFJuX5bMEfCnB2ySjiX6Qp/sg?=
 =?us-ascii?Q?EpLoPOPGxac9an7Ut8U74+VYKIkQr76ez2jGhLFzyqrB7yqLMsRkAJu0MyPw?=
 =?us-ascii?Q?TQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OYV+SEgk3LRm6X/eKG+hOoxqwWwUYv502szCwlsa8RrU1TJQx4McHlG8fArepaGdhZY7q9HqhIxWm+HzWCOCA6SCp8+B276pHBEAFUI0Add8Ch0PkMCCCgzcg9m8c4zbDWLmDGXSMqj7gLT2ALaITevIFrd3hXKBetGshbxMpGH4p6aGL88CmlIkmVGl6YtYwU/Vnr1qfksrtAVOb4QSNBPjorWueyJfW4O3/HtE/aIkIZosKhi4G8P2lJwy9Xnm0WL5IJe/sC8p8YLX5nzV124FfHq0HIp9LPIMh7NNX1glWoTJ6oNAn5i5Y1nyRaS/7LrlKos/Yo6bzXvfsa8JcVaFqjhS1VAg55/C2hvseln67zeOYwIhdzkoXsjDC38ZNnztQzaiNw0mY/tN5ZILy2WO+Fm+7oDYnMnf93qMllBJPX5MjX3/cqgwpChZCbUyxFfRFg2hnya5ge/FyMzWGQNqqGC446Ic4FJ4JYV5S9v3CB7c+oTyKn1RNWPMzkjPsDsWWsNrxnHymt29WkzkUbswVB2uplewNb/d4tjlxAHFvCdRIHkR0Nk3ilUOm4b08c5yQjq1JefdZu+NBDLtshw9lf91coaveMdPFQF3rdg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79d4e4ed-1159-42cc-55a3-08dd55cf7b75
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 19:06:17.6078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oBsUeZA3Qv/F91r4TFI4014ZqF8G1GbmQh6T3fk1Gxi728eDHfZTmS+w9GyA/da+YlZJ4XFfqdYX2qp7mAf2dup3fptIeeLzZ1pUVY+Mffc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6634
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-25_06,2025-02-25_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxlogscore=902 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502250117
X-Proofpoint-GUID: MncHCWmqqWjJSGsTsArJtrKBUwn-FIlK
X-Proofpoint-ORIG-GUID: MncHCWmqqWjJSGsTsArJtrKBUwn-FIlK


Christoph Lameter (Ampere) <cl@gentwo.org> writes:

> On Tue, 18 Feb 2025, Ankur Arora wrote:
>
>> So, we can safely forgo the kvm_para_available() check. This also
>> allows cpuidle-haltpoll to be tested on baremetal.
>
> I would hope that we will have this functionality as the default on
> baremetal after testing in the future.

Yeah, supporting haltpoll style adaptive polling on baremetal has some
way to go.

But, with Lifeng's patch-6 "ACPI: processor_idle: Support polling state
for LPI" we do get polling support in acpi-idle.

> Reviewed-by; Christoph Lameter (Ampere) <cl@linux.com>

Thanks Christoph!

--
ankur

