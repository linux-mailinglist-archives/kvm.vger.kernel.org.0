Return-Path: <kvm+bounces-26856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DCE00978832
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 20:52:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 132CA1C20B81
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 18:52:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50BF413777F;
	Fri, 13 Sep 2024 18:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ye0TWV/v";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="sspARN5K"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCEE43AAB;
	Fri, 13 Sep 2024 18:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726253569; cv=fail; b=C23G1t+MLQ+2KC5NBhzwKg2hHwV4aFKkFupm9N/SC3wAtzFRgKKEzUyGzdQIbFokAj1EyAL2ZIT7nQEqBk3vb8D+CZBO+w5wKZbGY3wX0kMmRTvvOFsr4OZ+V3ox3yDXLok5Fhrs/QCbA6PtqXDKmzQWYL4KrBNyhXAyk/6vaT8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726253569; c=relaxed/simple;
	bh=spaKgGsWBrt0Bb6lt5J1StJr22PO7NA8prbSEMvQ5T4=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=VnEQ82OwMaLhm/WtAmLt/f51c2h5bX4wOE4D34+jnbm9Fxg25be/dNRtHf2lkHg9y9kF3StH2/+jDnXnlb1SiMBDWhKKLO16F99GLlhDMbPagoosZjfTQf+5CIyTvYGHE2JSA9t6Q62ATpDQl04hsjUNNedoQAzVvFuHXxZZTwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ye0TWV/v; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=sspARN5K; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48DEmlmj008226;
	Fri, 13 Sep 2024 11:52:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=UGZkFXWGPm44b
	HBOL+o21YjX0/FcZNLRMty/eAnBrXo=; b=ye0TWV/v0Y4h6cwAFG/lJLVZmD+F+
	MSSQYaC533/hEICFOd3GK85zxGNytcfyjVQldQ+RrfbRNXluPqbu0xGUYBAY6c6d
	QPNOxzZI9gnqZF00O/5rW7VZAPmWHey8mMibj+BFhQfM0A5qBPLjuszzc6mLfFm4
	FwQcJTbN1DqiP8Gnoz5ZYOzvXc+LXlo1oECvyJobGf5zM2Fru2nndA6Ey5/Hh4Wd
	7I/eI9g+cYupDEcyKH3gBWdiLpgZWNxhjJUV2gLpdtD7KKX+6t1JqOGvB3spBSl+
	p2xWOXofMb4y/f0KPkJmULDn4ol9dQCPI79+/nWS5CH9NGQc78zSmgCVQ==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazlp17010005.outbound.protection.outlook.com [40.93.13.5])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 41gpc0ytjh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 11:52:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cTHamLUDrKZUzTtyJ48ahjEGGP5hp+qnreJyiIhB/3Pw8SBseiklqzVks1aFmsIInMzrkcZVE5XtM7SlB0Sd3Ja0KiCXhfQDBLXRCKMlKCn48YyddpB01rN0iCZUwpBeA8GBTfUY8BNMMLbDGQSPjNDKwv5gA92SunW5ymlC0nwgqzeSpAZbzc2wJ5P2sRMx8/ihcmDF8hLae7z+PBFz+WoOgZ+xh/GpPC3hq7EOVlICH3PyBE5vjZe1fJC+xWwVQrqv8AmZKihUBoSALd1bKQsY3IxDYxi5f9pi7pNLZ9HMbcf+aXQpGe9VL3HSfetEXPaseDbQcL5lJZPhCYXwhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UGZkFXWGPm44bHBOL+o21YjX0/FcZNLRMty/eAnBrXo=;
 b=P/SpUXIpZfA+XUTFoOQKR0BsLqjQ2ouUeTgjqlyiPi7uaJref7OClFMQR7HiJL8y39k0LLPlKaSfGlYS8qR3tA2Pl5RwcpQKEenhDGR40+ci6GzQnZ4TMcrqamobDh1VarJcLorz2sBVu1zOhmlO8ECBarP+5QEDfqjT8DNZ2XIxoAay898x8Bqjjwntn5wS31ymbWbj6Ipcefzi+rUgn+jCplCKNSy+encdwrDBm+DiR5S7dCHfnXzjjqTJ1bfoOqAmbmNRFNcEU0504KVj92B/L9iW4Y4+LOGUOi7SFVbVfyMvIA4C5kSMzPhf6efgRdeky7sMH0f6RgyEQRhaLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UGZkFXWGPm44bHBOL+o21YjX0/FcZNLRMty/eAnBrXo=;
 b=sspARN5K/azteobBdRCsAOCE72nMj+YptRK/al7QMaqqdGTM3ae2Vfnz8CFdPBXkwVfVy0QM2Ea0GjnkKjGlEmW1RKzyOkE+ELzb2BBCizOw53Ximyu74fdJkoSv1So2DIhUDi+d6vDZs6nKHTIQbQNE1EXS/sdb2eIBl2wuPs5QNtv7W++soj3HbIlYLPZ8SG1xl+du4dgfgHrOK4+jmHkFZgZGpSezjkfgxNFDjQ0EC0qkAJIzgRsgBjftqbgtPRGOS/2iNn+JKv/Avp7jLNGc4X52PsopD7GC/QhRmthJlW5iG41SNQdmZrnbKFEoi+1+VoxRzjzTuDYXs7WdYQ==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SJ0PR02MB7821.namprd02.prod.outlook.com
 (2603:10b6:a03:32e::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.20; Fri, 13 Sep
 2024 18:52:13 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.7918.020; Fri, 13 Sep 2024
 18:52:11 +0000
From: Jon Kohler <jon@nutanix.com>
To: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Sandipan Das <sandipan.das@amd.com>, Kai Huang <kai.huang@intel.com>,
        linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Jon Kohler <jon@nutanix.com>,
        Chao Gao <chao.gao@intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>
Subject: [PATCH v3] x86/bhi: use TSX abort for mitigation on RTM systems
Date: Fri, 13 Sep 2024 12:08:53 -0700
Message-ID: <20240913190857.1557383-1-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0112.namprd03.prod.outlook.com
 (2603:10b6:a03:333::27) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|SJ0PR02MB7821:EE_
X-MS-Office365-Filtering-Correlation-Id: ac9f1137-7a5d-4e38-c222-08dcd4252a6d
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|7416014|376014|1800799024|366016|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x7Gx9oOX400OlPRquzQVRc8ksCbH5EFktPDxSb9vdOmQPRkP6U49z0AEjr9b?=
 =?us-ascii?Q?1rxKewf6fUOXKVWbW8KvyQGNTNjLoWfslcfNOMHvRoixfmmk9NsZbRU0Ge4r?=
 =?us-ascii?Q?pjQkhyoVd/IjNHl73AS5bVizlAYyh/HmDc2AluK2P8ipF3h4/lUeXArJWR2A?=
 =?us-ascii?Q?4j6PuMMvplp+USbrdDe/8RmzYrQSg3JYwGx9UAuExo6om0Tw6lnQYVEWPmCl?=
 =?us-ascii?Q?t0GZRfJvCjRrFoqoUvYZdcTf0VrVBRHKgSEPkZMF4kv3Sdd2AdciCpEyz9Mg?=
 =?us-ascii?Q?VCAD6SQ+eBN/TOgRrUMrMoaF7jPVBcBQKVVEBZv4SH67iNm39WbLSAjDqffA?=
 =?us-ascii?Q?A7u2BFtB1uDiXAZKI3WvEtg7yNF3b4wB0rnbIn5zCtpNEKJnEmZKVSRkuqPX?=
 =?us-ascii?Q?yziHUQZTZH/eUjLqQl4FkNBlwTpb7L1aXiUxC7mzMaNhOCfXXQFRZUx/nMPu?=
 =?us-ascii?Q?Sg7JL1Z6DfTs+nnnclU+2kSe3A7I0Qo7tX7jj/rkV2Q1HkG9EmkjjiL+viEF?=
 =?us-ascii?Q?6Z1K9pNwokVlgeiU5WAKn19cOAFsho3G7tWOLfW5qieVzbiH3Zw0LSkZ8Ww2?=
 =?us-ascii?Q?78T12GRMWj7TLpSJ6ZkkVTkgFUuEarqfhmGdxMeUB3elsBJDfjXcnUlATNeF?=
 =?us-ascii?Q?DH7zeiJsqaO7vGReUGDJokPdsJToWGU71/mnj3c1e48FYNeT9IFUGNp5MKE5?=
 =?us-ascii?Q?MbhDgXlz2X0LuuwqP4Q9j/p/7jn5WKAZGl0mt+af+m/juyOnhfeEszHSUxPL?=
 =?us-ascii?Q?l4Vf/2GmJXkBRQ1jRXEsJcOpxNlcbdxXXsDU84qVPftdNtSeWT/irU95opqr?=
 =?us-ascii?Q?/euuaHbWtc1a8x4fdnnmQ3ZedHIA0eY5yE8e+63RHvPakrAA20EjoWKkWTgv?=
 =?us-ascii?Q?GZOUNytoKCpKV5CLb2my4ezYeGaWbSPi8iFeFH9Nsr5cktQhrqmWmqNLvyMM?=
 =?us-ascii?Q?bcxAlmExKwCV//RVYjJ6jzdK0ZUozmnh8No/J+OsHCi77sFHqQbBhu9zad6n?=
 =?us-ascii?Q?71Cz8w1I0o9Hen14cxPYZdz1ODMHvo0XAnZCjSeuwugX11O6XjCOr7+7eXVz?=
 =?us-ascii?Q?Uqmf6RlGZ98Vq2wSElfCievTthC9gkC6CNzbO1edmWaV3TJ0s2cBaP+zufDh?=
 =?us-ascii?Q?dClPoYffnXCNqI+ueCEg2ZtpoelXxHhjQQ696DM0UkFOy2XuOgCEyiWnt7cD?=
 =?us-ascii?Q?c6o4luq8dyHJ3DaNO69F4z/Ck8f42CdWzOXVV4QIx2m/3MSYcybhDSBT/oTk?=
 =?us-ascii?Q?ZpjBYtyHrE7WArWmjnvkCJjEJpKNemZ+hdOh81mSpG5CNCW+gwWAbZWGRk3x?=
 =?us-ascii?Q?MOMtV+M5w1PBZ3cqx0zFhEQ/MbGpXiyDi90RuEuOestzhr2z6rrXMe6BLq7g?=
 =?us-ascii?Q?w8MJZL1bBcXteKSM47Fme6a1av+tdEQpIHKktu+xM9cWhSvYQPjRLC8Nirz/?=
 =?us-ascii?Q?esFNq/418mI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(7416014)(376014)(1800799024)(366016)(38350700014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5+1FII95TkdjVVm8sFWx90UIRYp/ihJ5j1euvCztXH0ysziRq1ZKHGhZ4oqf?=
 =?us-ascii?Q?aMSnZbV4T+goOrsoajPLP3ZcTOeOwj6Q4+yukx83ozLPycvcYpFAL59mkJGl?=
 =?us-ascii?Q?Sm7u+BkrIMxX6kCIHE+kPK+wThy4vn+hNGgE7VxtPcjTUvy2Jg+DpEczH0lo?=
 =?us-ascii?Q?jBHJULe08KWJAYGAeAto3fDzJForvWgSlRciuPT2y8BBPJgfHenY1ElRgROg?=
 =?us-ascii?Q?2iRzAx0bG0W3FMQlpnCtB/0GHbPnN1zsRWwiTEhCt5r32Y27dNhKhl3COo/r?=
 =?us-ascii?Q?03Jn1X38evIW9It9HkuYBVLeXvhPNL22L1p+c2QmomjdTCaxkGmLhKpCjrf/?=
 =?us-ascii?Q?sHyKNF/pQvvWidc1ulmKTHr7mIiOkgwHqfr1x8obU2BJ4Cg8eL6FAihAokdk?=
 =?us-ascii?Q?yDWdBOjERFFkMc45ofxUUzqX+s2XRQ+V4vXut7H3n2bLRXx8+4P9I4tnrft/?=
 =?us-ascii?Q?aFpk+IdFG0mOBES8WGXn46H8OJUjUoXAu9j24pVqcgneouOXpNptc1Gi3AOZ?=
 =?us-ascii?Q?9SEfpSBzAJvoGuFnkhUYl1wb1ILJQmdZqewiq9HMv8yh4QDvBWY8YWWmbr0q?=
 =?us-ascii?Q?v/Jpx8tl2h02qSPoNO3AKDAiRhxvqjOzaDy9YqCE7cROkYSW7Y3LbAuF1Nph?=
 =?us-ascii?Q?KclpVvUE+FiXX2OxZ00VWIy/OFZh1zDLe3JX/8lEQky7MtZD7IOigBgr4soE?=
 =?us-ascii?Q?ip0nyZnSzIiDod6xm/YoTo7VI1ZWBu4OMbj0T5+hNcYbHlDuOOn0jZwar6A9?=
 =?us-ascii?Q?yPi8inNwCvL6kdHXIBUZatUiloTkizOXiG6yJzzdenTE+a7IEUJZ1ecisMPY?=
 =?us-ascii?Q?DFEMAegAJZUtQYmRPg8am0V9L3hNw84HtLqeupiN+4iMnrMzu5hxuHNtqc/O?=
 =?us-ascii?Q?w6xoMvjPqOy6Hy+We6Hymwyh2UUVOJu3NTFcX5Pr0xPxjXQ4sg1BPW7zZJHb?=
 =?us-ascii?Q?+T5pLma1V/lMdtpeEBKFA1pCPEeVFo0WE6ydqHFojw/gHXDc9I53fIuCfg5K?=
 =?us-ascii?Q?a7YZZ95tPL19h/CH4Z/mgwCsvLxoW+LJneVkeW/LFYUpLtfZR1zvcn5M5q9f?=
 =?us-ascii?Q?fMu0KWlv5FvazpwVYfG9NfIQigUSS5461suLvpKcYWrct00KAOXlcUWqaqfD?=
 =?us-ascii?Q?PgCedXvOuvCj3hT7Z3bBGbsvjWZWhk73xmRCO6R+PDR2UqfEbUQd3VGac0rl?=
 =?us-ascii?Q?VObze7v67G3bO8YQ6rvpVVZkT+3yjPxaPybeP8YrBUg3uQODU7GmL4mNfdJM?=
 =?us-ascii?Q?OOLuaVSCVQcpRIC8VEV1R8eQi9UQ1RC9BBAnwgGikzdghQsDl0x+6StMKjoF?=
 =?us-ascii?Q?7eBKCel1wQZsZasff0tAOZZzplXfUlQ4Berv7pODkGPaa0OfIiy5lirPZWVU?=
 =?us-ascii?Q?CpqVstAU7MzohZepk/GvU6HscJOQ/m3WCH0lgqO8k4Fx9M5Q0uXfbPfHrMK3?=
 =?us-ascii?Q?aQwMz2C42EnT5lbrsXCB/Y75/ENNu9ipEXQI84IFr/WUrSQcfSQdYbo4a6Gk?=
 =?us-ascii?Q?5dNqqJn7Wgz7hxfPzghEsNaWotVbC6lsfk5uLWKuBj6VyQhc6unydl/K8oNU?=
 =?us-ascii?Q?lyt+i382C8i2nAlHnbvsiFjgABZxxS1dqqV1p8bFpPTTA2QoxgNCV1A9MzGT?=
 =?us-ascii?Q?vQ=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac9f1137-7a5d-4e38-c222-08dcd4252a6d
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 18:52:10.3251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sHZet20wNJOT/zf/3kTZd2HQNhYD4KeB6gpx1fDQLfFdyUviCK5tmvmU4QUMqG9Qu6y4ikKs36vH/olHQ0lb3JWUGBvb5wH1CsKDghHGrgg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7821
X-Authority-Analysis: v=2.4 cv=YqddRJYX c=1 sm=1 tr=0 ts=66e489df cx=c_pps a=ga136hzsjl6Lb4dqulp3IQ==:117 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=EaEq8P2WXUwA:10 a=0034W8JfsZAA:10 a=0kUYKlekyDsA:10 a=QyXUC8HyAAAA:8 a=64Cc0HZtAAAA:8
 a=VwQbUJbxAAAA:8 a=FBfThdMdpptHyf1kRGMA:9 a=iJeLTDR2-uQA:10 a=y5rEMOVZ_0gA:10 a=14NRyaPF5x3gF6G45PvQ:22
X-Proofpoint-GUID: fDUB-SGgGwxIMKjPtQsEhL62EvbOJTe6
X-Proofpoint-ORIG-GUID: fDUB-SGgGwxIMKjPtQsEhL62EvbOJTe6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_11,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Reason: safe

Introduce ability to mitigate BHI via TSX aborts on systems that
support RTM feature. The assembly for this mitigation was provided by
Intel [1], noted as "Listing 3", which starts and immediately aborts a
TSX transaction and causes the processor to clear the BHB.

Vulnerable systems that do not support RTM or have TSX disabled will
still use the clear_bhb_loop mitigation by default.

Furthermore, on hardware that supports BHI_DIS_S/X86_FEATURE_BHI_CTRL,
do not use hardware mitigation when using BHI_MITIGATION_VMEXIT_ONLY,
as this causes the value of MSR_IA32_SPEC_CTRL to change, inflicting
measurable KVM overhead.

Example:
In a typical eIBRS enabled system, such as Intel SPR, the SPEC_CTRL may
be commonly set to val == 1 to reflect eIBRS enablement; however,
SPEC_CTRL_BHI_DIS_S causes val == 1025. If the guests that KVM is
virtualizing do not also set the guest side value == 1025, KVM will
constantly have to wrmsr toggle the guest vs host value on both entry
and exit, delaying both.

In fact, if the VMM (such as qemu) does not expose BHI_CTRL + the guest
kernel does not understand BHI_CTRL, or the VMM does expose it + the
guest understands BHI_CTRL *but* the guest does not reboot to
reinitialize SPEC_CTRL, the guest val will never equal 1025, making
this overhead both painful and unavoidable.

Testing:
On an Intel SPR 6442Y, using KVM unit tests tscdeadline_immed shows a
~17-18% speedup vs the existing default.

[1] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/branch-history-injection.html

Signed-off-by: Jon Kohler <jon@nutanix.com>
Cc: Chao Gao <chao.gao@intel.com>
Cc: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
v1: https://lore.kernel.org/kvm/20240912141156.231429-1-jon@nutanix.com/
v2: Switch approached to TSX abort, addressed comments from Chao/Pawan
v3: Added changelog here, fixed small issue in v2 in bugs.c

 arch/x86/entry/entry_64.S            | 24 ++++++++++++++++++++++++
 arch/x86/include/asm/cpufeatures.h   |  2 ++
 arch/x86/include/asm/nospec-branch.h |  8 ++++++--
 arch/x86/kernel/cpu/bugs.c           | 26 +++++++++++++++++++++-----
 4 files changed, 53 insertions(+), 7 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 1b5be07f8669..64e83caec40b 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1552,3 +1552,27 @@ SYM_FUNC_START(clear_bhb_loop)
 SYM_FUNC_END(clear_bhb_loop)
 EXPORT_SYMBOL_GPL(clear_bhb_loop)
 STACK_FRAME_NON_STANDARD(clear_bhb_loop)
+
+/*
+ * Aborting a TSX transactional region by invoking TSX abort also clears
+ * the BHB. This software sequence is an alternative to clear_bhb_loop,
+ * but it only works on processors that support Intel TSX. The TSX
+ * sequence is effective on all current processors with Intel TSX support
+ * that do not enumerate BHI_NO and should not be needed on parts that do
+ * enumerate BHI_NO. This sequence would be effective on all current
+ * processors with Intel TSX support whether or not XBEGIN is configured
+ * to always abort, such as when the IA32_TSX_CTRL (0x122) RTM_DISABLE
+ * control is set.
+ */
+SYM_FUNC_START(clear_bhb_tsx_abort)
+	push	%rbp
+	mov	%rsp, %rbp
+	xbegin label
+	xabort $0
+	lfence
+label:
+	pop	%rbp
+	RET
+SYM_FUNC_END(clear_bhb_tsx_abort)
+EXPORT_SYMBOL_GPL(clear_bhb_tsx_abort)
+STACK_FRAME_NON_STANDARD(clear_bhb_tsx_abort)
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index dd4682857c12..c6aa2d758389 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -473,6 +473,8 @@
 #define X86_FEATURE_CLEAR_BHB_HW	(21*32+ 3) /* BHI_DIS_S HW control enabled */
 #define X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT (21*32+ 4) /* Clear branch history at vmexit using SW loop */
 #define X86_FEATURE_FAST_CPPC		(21*32 + 5) /* AMD Fast CPPC */
+#define X86_FEATURE_CLEAR_BHB_TSX	(21*32 + 6) /* "" Clear branch history at syscall entry using TSX abort */
+#define X86_FEATURE_CLEAR_BHB_TSX_ON_VMEXIT (21*32 + 7) /* "" Clear branch history at vmexit using TSX abort */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index ff5f1ecc7d1e..915a767b9053 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -328,11 +328,14 @@
 
 #ifdef CONFIG_X86_64
 .macro CLEAR_BRANCH_HISTORY
-	ALTERNATIVE "", "call clear_bhb_loop", X86_FEATURE_CLEAR_BHB_LOOP
+	ALTERNATIVE_2 "", "call clear_bhb_loop", X86_FEATURE_CLEAR_BHB_LOOP, \
+			  "call clear_bhb_tsx_abort", X86_FEATURE_CLEAR_BHB_TSX
 .endm
 
 .macro CLEAR_BRANCH_HISTORY_VMEXIT
-	ALTERNATIVE "", "call clear_bhb_loop", X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT
+	ALTERNATIVE_2 "", "call clear_bhb_loop", X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT, \
+			  "call clear_bhb_tsx_abort", X86_FEATURE_CLEAR_BHB_TSX_ON_VMEXIT
+
 .endm
 #else
 #define CLEAR_BRANCH_HISTORY
@@ -383,6 +386,7 @@ extern void entry_ibpb(void);
 
 #ifdef CONFIG_X86_64
 extern void clear_bhb_loop(void);
+extern void clear_bhb_tsx_abort(void);
 #endif
 
 extern void (*x86_return_thunk)(void);
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 45675da354f3..4837f3968954 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1662,8 +1662,16 @@ static void __init bhi_select_mitigation(void)
 			return;
 	}
 
-	/* Mitigate in hardware if supported */
-	if (spec_ctrl_bhi_dis())
+	/*
+	 * Mitigate in hardware if appropriate.
+	 * Note: for vmexit only, do not mitigate in hardware to avoid changing
+	 * the value of MSR_IA32_SPEC_CTRL to include SPEC_CTRL_BHI_DIS_S. If a
+	 * guest does not also set their own SPEC_CTRL to include this, KVM has
+	 * to toggle on every vmexit and vmentry if the host value does not
+	 * match the guest value. Instead, depend on software loop mitigation
+	 * only.
+	 */
+	if (bhi_mitigation != BHI_MITIGATION_VMEXIT_ONLY && spec_ctrl_bhi_dis())
 		return;
 
 	if (!IS_ENABLED(CONFIG_X86_64))
@@ -1671,13 +1679,21 @@ static void __init bhi_select_mitigation(void)
 
 	if (bhi_mitigation == BHI_MITIGATION_VMEXIT_ONLY) {
 		pr_info("Spectre BHI mitigation: SW BHB clearing on VM exit only\n");
-		setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT);
+		if (boot_cpu_has(X86_FEATURE_RTM))
+			setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_TSX_ON_VMEXIT);
+		else
+			setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT);
 		return;
 	}
 
 	pr_info("Spectre BHI mitigation: SW BHB clearing on syscall and VM exit\n");
-	setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_LOOP);
-	setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT);
+	if (boot_cpu_has(X86_FEATURE_RTM)) {
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_TSX);
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_TSX_ON_VMEXIT);
+	} else {
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_LOOP);
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT);
+	}
 }
 
 static void __init spectre_v2_select_mitigation(void)
-- 
2.43.0


