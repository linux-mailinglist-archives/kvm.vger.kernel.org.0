Return-Path: <kvm+bounces-18808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA3948FBFA4
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:10:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 23613B25B7B
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 23:10:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CF4D14D44D;
	Tue,  4 Jun 2024 23:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h/leF/5M";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="C0ONI5JQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C402914B077;
	Tue,  4 Jun 2024 23:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717542598; cv=fail; b=p0aBwYFyyyy1hCpChbN2LDzy3+KozvJZOJbtSW0GfUi6TuPbPnCKdwyT1BlYivWGrNc/3+RkTxs1/PLbmURkYEN1RQFYhNDeyQg8Wsj4PP6fj1SBjXDzOMzNsMbTXk+sJ7ePsQ0X9qBOB5wqGnzt2KroZo92EnlyhhuVMNpKnhE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717542598; c=relaxed/simple;
	bh=tiVWVijt4KHCq94b2adTNhCQDblPtfnqDgpKIYL6VBk=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=WBXQKLMYkwPngeGAYiXHL+P3No74OhQS8MdtvowjdVx8wpXOIk0q5lCbab9yktfQ6Z4cf2qsazDByCTNZJethd/8LySsWdFisXzHNde1Fx3O1qLNK4bVlFU7LZXcg7cqBf1Daam6EoyYPZ3aT5qMZHdqsfl8NyZgeDSICBn0FEE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=h/leF/5M; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=C0ONI5JQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 454MR49n031482;
	Tue, 4 Jun 2024 23:09:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc : content-type :
 date : from : in-reply-to : message-id : mime-version : references :
 subject : to; s=corp-2023-11-20;
 bh=aSKdd6A7nwdiKuN5vpwSdXCKgld2BRsqEhGqKGiB2hE=;
 b=h/leF/5MQt7BBsG8JIzem+zvxccwMpsC8PYDS6kIq22OWYDugRSfLTwwliR44C1T41Mr
 F8itvhjYl4VSgFolI9xTB2mnuq1bErK+R31fnUGUovZ15E9GPQdBQL38cABgzoqMFwGI
 /kiE/Uesw3RwBrnPqi7Xrmwg50Mr9q5+COFE17jpu3oMa6XXDAKTl7eLEdCzdJdSYs7Z
 AZONfwtmDUEp2Fyq0sJIwFtpLO1Dbt/TC/SkF5wO/cYRoCxAq6BRcfABMoDoFrlRjWDV
 oi2dn+DAWYLAugY1vs4zULFz2i4xbEstP5xAbId4ShZM4ZAyNvsRW9kyEEGT8kpUIotJ /A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yjbqn0125-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Jun 2024 23:09:14 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 454L8xc0005509;
	Tue, 4 Jun 2024 23:09:13 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2048.outbound.protection.outlook.com [104.47.51.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrme7k1x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Jun 2024 23:09:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QO86B/bZ6r0HlQFCVZKZxfz+NUe67w2eiNa7G94ti28QJ43Ye3IbMJ/tnVTxFsicBTeP7E3+2Wa+XLIdzmwfsOj4JkREIyPHMYb9646wJf1dgwsIrT3LvVN3wq/aeYtp1/wZI5nqt90VSmvbZkpukIjFLfxuzon0EI3HaomphTZf2HjMhPxEKofGhLiwILKLSNYzGj6lD8lX07vg05IKI7TVA6CAT+N5sRYwyoKPGMdsYTcB4WZ3eSsy6mLJNQueoe1jyWM3u0tNL0y1SOdu/M3WRzAveHyXbdHwnJa10sVGJukGyc0TTXRMLx7Jun3NtBs3324xiQErNNRdyV8nvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aSKdd6A7nwdiKuN5vpwSdXCKgld2BRsqEhGqKGiB2hE=;
 b=aDpB/7sjjnExhiwe/iM7XFZ9bBV9PfE/xBZ9Cd2uLWSKJYbsRMHKKPaelI+P5PeYvTSLptaG1G7mhKCqi4I1MXlbWWt9yu+/R9yFX5ZdpUrXNME06AGKk9WlZMaUG4jBJvd1YzSD34nXcKM2902UoQSTnCYb8OqlqF9Mr1I6PNFzHb4/aPP1SJmDazR0ALiuY1cbH07A+1HFdL2seXDpBYTUF00Pg1sYK2Qy9+xt3J1QEssVFXsKoZvVXIN4HwuEOEl8nbUFuEH+SfNP6ICXPY1e8YIergHftOCRP0hneWGd7Y+FJffG560itcefKBif8uZSvxrsODC7b41gJQ8nnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aSKdd6A7nwdiKuN5vpwSdXCKgld2BRsqEhGqKGiB2hE=;
 b=C0ONI5JQHf7Tabi4qGFYVAJ3Ye2GQd2dibh7zp2WXxiKJhyja0p1oLimDYYh3wZ31pNIwMMzNR3oKr/YC1WurrSNzIuANK0Bvj1GcZMJfC2RRF8tgT3CkoNIkW3UGsfLwBNxF4QMQCR+i95p+xdZtVTxxJQYZ5tzCxUy9DlJlNc=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA1PR10MB6688.namprd10.prod.outlook.com (2603:10b6:208:418::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Tue, 4 Jun
 2024 23:09:10 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%3]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 23:09:10 +0000
References: <20240430183730.561960-1-ankur.a.arora@oracle.com>
 <20240430183730.561960-9-ankur.a.arora@oracle.com>
 <41a184a3f5695061487e86a6da5eb87c140dbe3c.camel@amazon.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "Okanovic, Haris" <harisokn@amazon.com>
Cc: "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
        "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>,
        "linux-pm@vger.kernel.org"
 <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,
        "ankur.a.arora@oracle.com"
 <ankur.a.arora@oracle.com>,
        "joao.m.martins@oracle.com"
 <joao.m.martins@oracle.com>,
        "boris.ostrovsky@oracle.com"
 <boris.ostrovsky@oracle.com>,
        "konrad.wilk@oracle.com"
 <konrad.wilk@oracle.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "catalin.marinas@arm.com"
 <catalin.marinas@arm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "daniel.lezcano@linaro.org"
 <daniel.lezcano@linaro.org>,
        "lenb@kernel.org" <lenb@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>,
        "will@kernel.org" <will@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org"
 <peterz@infradead.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "rafael@kernel.org" <rafael@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "mark.rutland@arm.com"
 <mark.rutland@arm.com>
Subject: Re: [PATCH 8/9] arm64: support cpuidle-haltpoll
In-reply-to: <41a184a3f5695061487e86a6da5eb87c140dbe3c.camel@amazon.com>
Date: Tue, 04 Jun 2024 16:09:06 -0700
Message-ID: <87frts2tm5.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0355.namprd04.prod.outlook.com
 (2603:10b6:303:8a::30) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA1PR10MB6688:EE_
X-MS-Office365-Filtering-Correlation-Id: 983193c4-6792-4936-0354-08dc84eb57ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015|7416005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?Vbajg5pZZz1hSYn72OAQZTpCNklCMZZGJaKBFFYcd6rFWGvwdpL5ly3MxFm9?=
 =?us-ascii?Q?zHAJIzgGJ03i/j34BGaRAxhCHMc6LokDnue7udz3kFlr++gHyiBXSwGhuDH6?=
 =?us-ascii?Q?Xw5PqR9VPEnp0imP0156exp3knY3WkMAjdPNNPsdBnDUHa3ksKRcqSxvoMOU?=
 =?us-ascii?Q?RoARPfKlCSHGsgcKpFOWdL1i9GhX/QAYeSfJD1qY+SBMGxgKZFJ7yUOELoCO?=
 =?us-ascii?Q?nHV74Q2RU+gR7qkNQtvknvHUYZUsj819Jfb4d5MxhSzodRooTxl/2rhCq96c?=
 =?us-ascii?Q?cO7sfjfHLw4mmmYa+XYIVna+tVJDfPfHfLi8tStW4d/wWYq/TOnEcShMf0g+?=
 =?us-ascii?Q?kSoXdIeVhxF1Hwmx3LFnlqqZPqbi9/YzzUbXR1wAwf8odFVGYQYhAw3LHNZE?=
 =?us-ascii?Q?gEvMOwhmc+M4NPYUveSrsUUU/vfRejm4D/CnokKV3aIlhJFFpeg1iRnplkuk?=
 =?us-ascii?Q?koNbqcEjlP5YFcuzxHk03cxagzwwQUcFjUIDcbXecB4XN3SrqfquE3qGmfJT?=
 =?us-ascii?Q?nwA5TcxupnaTVp4hqBKoQMH0n+V6dALBNaNYOTMsKvcOR3Fyboqngd9Sv8e0?=
 =?us-ascii?Q?1/ewysN/nMVmRe8178nP0fk1qQXHXEBIbLDGWeZ05LHYMsVAyV4SbDS5wf6T?=
 =?us-ascii?Q?B2P7bp/JC9K3Md8z2VPidXwtsZ9c3o4ka23HFsuw5ilT04l1XMvIvQmvCwc7?=
 =?us-ascii?Q?gYXJVqR7TpJ3wpE2IZdctwhNWIYe3xKZfowrX/vdjFRb/hnfsZ1ER55KlnTH?=
 =?us-ascii?Q?nQkF+13apVUAMJ0TrQxTAAjqbXt78F+cP1I74DPE2xf79ZAlIJDoB4QKcyDF?=
 =?us-ascii?Q?8k5yliHdtB2aB7i7aM8RwMYS6nAJ+kQHwrUnuXIeF1F2VSMOIfQNTEJFrnQ+?=
 =?us-ascii?Q?vTeGBIz9vGW3CX94JwpilO7wHzhxCH8es/wRo6xGCs35pkmJRSJJcavTXiJb?=
 =?us-ascii?Q?ekKgPdwyo2NozyKIq5uVEhzI+aMcFv3aIizS0C0NMtu0+tfznCCyzlqJmSoj?=
 =?us-ascii?Q?4Uh3zOcONa6msoVGohgCODdPEhioOqt0Sv0rsM2tynedYqY6ShyBvryxu3ND?=
 =?us-ascii?Q?/qNdUtr+JHEqRJZCEVxhZlBrf7gVHlFNbOA6XJVM/g5/nFijPnCudlRu7cJW?=
 =?us-ascii?Q?ydiVSLrnqvxK5wJRzOBA4znYKuqos9lw0uJawSB8tN6AwzGidfn0kmgOOFJT?=
 =?us-ascii?Q?Rze2FRscTRDriIqtZ4BHOPRB0b7x3MLs/3D+Ly19kdf58xo6NYURGIbCdHmA?=
 =?us-ascii?Q?XREhDWqx74Tp01z7JbRgyVVNAB0dDHefGsl3oJbpTg=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?zip6yOScip0xjuMjgm1AXr4EQe+/llVsKFvO7qJL6RVHe3iVp7MIcAyrioEB?=
 =?us-ascii?Q?TmwtJcuIJ7/9t8JaEutoRyUjKAekj7djYh+WPIy9fgxfZLb8InqgI+j11n4v?=
 =?us-ascii?Q?KrIy7GKPtj/YaLrojzhoEqKYouXh5wVQNHIK8//6coBHghnNolZ8WSZGPvqC?=
 =?us-ascii?Q?HrwDfwO/1N76z36iaapOdOgGtJB2+HP4NYMUmrceSZBHDBOdpJk5Te7BLTZo?=
 =?us-ascii?Q?9FLrbn1t3cPAgu8UX7e7NNQqCwrY1sVC/ND8WD7dggvrHPWgTildjwVvfyPz?=
 =?us-ascii?Q?ikzk+dDzXpLu8fuqbp/33WFveviED5Pc/pn+7/OVLhare2+hZey4VNt+9mYq?=
 =?us-ascii?Q?9x1QC7/Az9aDIoQVbZvTRmlng9WeClL9RYAsDuGK+Z4AcGPnSSHV0eApKYdB?=
 =?us-ascii?Q?veEogfvbSszPhs9oOIwdSWqcqT1f3pog5VG+AtgABqIeXkBCPuIUolPT0jsj?=
 =?us-ascii?Q?tTSTHcR8iGK8p8oBHCsNJcFsbgrbOEuvZLwri5DIbITgdKaEgqFnFlNqe/9e?=
 =?us-ascii?Q?7oDevFVpqcO21m1p3ZJSyB0a4wqAaokzNjbcOKaipzgKexC0uECgytYzGXnx?=
 =?us-ascii?Q?H76HaYhmvLWZ4J8oahnCINHLI3yDqDbyenY8WA819GukE8edVMvGMSmVA54k?=
 =?us-ascii?Q?l3BcHYA0H8xgRdSpz0Q7Oft5wbtY/yk3FMWwqWEHiyi1Ut1h5XFPFvvWIErl?=
 =?us-ascii?Q?WAlw9iJiUIvqbpcj2aaJbFbZUvbUSPvw7cRs9xrErB/B9oLv0j9pUMtOmwMk?=
 =?us-ascii?Q?HzITzSmaUMLGw178XUtamN14Sym/sxiU3fuseaYEqJ5oJDebDCy/0FtpWocd?=
 =?us-ascii?Q?6C+bE+aUo3b+BiPqutgBZlrmt0JlobpJD+M2d7lM3SXufHWKRVTpJaonzeYI?=
 =?us-ascii?Q?sluJxGzRuvRT0nPbfS4aRflwVM7WHw/Ov2DlWej+1xu2/LL9V4bNEzrjxUlN?=
 =?us-ascii?Q?q6mO0L4cZ5rm2V3gO+yaQAlHqZ721M0o643BTbuViixg1dyIjoqnIDhVwW2b?=
 =?us-ascii?Q?NTDc9AuVM6igRxXLstEFvse6VKVA1TAh4hO+4WguBts4Hfs3UnwlDfAeawJS?=
 =?us-ascii?Q?Hv3G6KkBSRCOVq9QY+I+xqry+UFCUIGEmIyr+Zdoy6wKPTMfFoNerZGPGG9A?=
 =?us-ascii?Q?AneLHlca6MugKczkMHxqtobcCo9SJK/otpq+9hBPE26Vr1OrqVG6KIAYRCLX?=
 =?us-ascii?Q?a2VqZFehZhdNDdJ7jWaB8bfP/dYPOTKMeKEZ2AsMCjxFwL71pyR6o8i8BAR9?=
 =?us-ascii?Q?YX61LF7MxLd/69h2mQJK+z1nPtf2U4hiLeMbaguogsEYknvV3Cx2FAmHLVDe?=
 =?us-ascii?Q?I9V6HqwbUFjWozSAuri+Nhbab49BgjDFeRg/Qs41/r0jop6ZnMpIeYxIKCYV?=
 =?us-ascii?Q?MAm4uv25bUBjsOckpn8NOgXfDgvol7ooVCRFK0vQQ3vCxe43nmntFb4QmKV0?=
 =?us-ascii?Q?fP1oofODLOqTV+2NjuSCAmV318FK/WicHG1PTMukkfxAsR0Rcz4sJYUuy6gc?=
 =?us-ascii?Q?SGq2joDtVicvO0aBnVTj+HiUP2D5qEPaHdfR5fOBHRrdZyWcEvbZ+OLrao4+?=
 =?us-ascii?Q?pnjaNtN0gNCezxqG6844YInIeU6DF0ZV59YoFHL+jqRCTWwyOeaBl4ulxsVI?=
 =?us-ascii?Q?pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	zODW3NIvZuVpguSR/FgtGjHX0oflqBXcSbh7K8NJpGaDmsDaIr3jWW2KrS42iSbqFGEEHh2SdrOvTDhFQsZVYQjThU+CuZqUardBlbUg668NVbw/O9lDtHeAYxUFNWwqUTI9LKBq/A6AAZ+EzjP3Z61lgMVGC1/m/JmDGqqzi6lOfBIfoERS3RXvkmADZ91pG+n79jPxt9hnAvnNJoSZ6awIGFI5eYqUfdXfFtjUbA8SGdIBsZJ0AZUA96WbuRhEESiOEr9Zcq/gw/6/hDMu3BmtBKU4E65mzH9Wl59mIPrVyXljIeodQT5u/Atm+2NoKX4P5zp/k1a0vKvJJrs0SCWggSNYcLgLvhMh0UxFics80yiLJgbmLkPw73sxcZn6AWM9cH2IMARUv5Rr4cb+1nB+Z4KX+BXUGcZBobcEKooKlOYi0QK6/WmLiLrbANJ2bXDGIMin6nQst/w88fjQliqmUPy2qPsUISs2dId39RukT59oyRyRx7yeppRKlLxc77aAIptw52GpO4om9k+29zkMPdfOzJR1YthXdqKXfug7uSsVs3S0DimrJvnHWqzXG51wK3rCk2AwtBwZN0ChyVrdSGxkrC5nqnng2re0L7I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 983193c4-6792-4936-0354-08dc84eb57ad
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 23:09:10.5991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /BDy73nQDNMwN8b5UehKXNiYMzC47ijUcLTfN6wzHj8uIt4mF5ckEP6unT04H7fBOvvl7b/t1YT/WEGWPN0uLgvHPb0YcedJo1Xp4H23LL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6688
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-04_11,2024-06-04_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406040187
X-Proofpoint-ORIG-GUID: MiMBWa_LUNGJrEE9kyDtXzboVSP5YC-z
X-Proofpoint-GUID: MiMBWa_LUNGJrEE9kyDtXzboVSP5YC-z


Okanovic, Haris <harisokn@amazon.com> writes:

> On Tue, 2024-04-30 at 11:37 -0700, Ankur Arora wrote:
>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>>
>>
>>
>> Add architectural support for the cpuidle-haltpoll driver by defining
>> arch_haltpoll_*(). Also select ARCH_HAS_OPTIMIZED_POLL since we have
>> an optimized polling mechanism via smp_cond_load*().
>>
>> Add the configuration option, ARCH_CPUIDLE_HALTPOLL to allow
>> cpuidle-haltpoll to be selected.
>>
>> Note that we limit cpuidle-haltpoll support to when the event-stream is
>> available. This is necessary because polling via smp_cond_load_relaxed()
>> uses WFE to wait for a store which might not happen for an prolonged
>> period of time. So, ensure the event-stream is around to provide a
>> terminating condition.
>>
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> ---
>>  arch/arm64/Kconfig                        | 10 ++++++++++
>>  arch/arm64/include/asm/cpuidle_haltpoll.h | 21 +++++++++++++++++++++
>>  2 files changed, 31 insertions(+)
>>  create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 7b11c98b3e84..6f2df162b10e 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -34,6 +34,7 @@ config ARM64
>>         select ARCH_HAS_MEMBARRIER_SYNC_CORE
>>         select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
>>         select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
>> +       select ARCH_HAS_OPTIMIZED_POLL
>>         select ARCH_HAS_PTE_DEVMAP
>>         select ARCH_HAS_PTE_SPECIAL
>>         select ARCH_HAS_HW_PTE_YOUNG
>> @@ -2331,6 +2332,15 @@ config ARCH_HIBERNATION_HEADER
>>  config ARCH_SUSPEND_POSSIBLE
>>         def_bool y
>>
>> +config ARCH_CPUIDLE_HALTPOLL
>> +       bool "Enable selection of the cpuidle-haltpoll driver"
>> +       default n
>> +       help
>> +         cpuidle-haltpoll allows for adaptive polling based on
>> +         current load before entering the idle state.
>> +
>> +         Some virtualized workloads benefit from using it.
>> +
>>  endmenu # "Power management options"
>>
>>  menu "CPU Power Management"
>> diff --git a/arch/arm64/include/asm/cpuidle_haltpoll.h b/arch/arm64/include/asm/cpuidle_haltpoll.h
>> new file mode 100644
>> index 000000000000..a79bdec7f516
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/cpuidle_haltpoll.h
>> @@ -0,0 +1,21 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _ASM_HALTPOLL_H
>> +#define _ASM_HALTPOLL_H
>> +
>> +static inline void arch_haltpoll_enable(unsigned int cpu)
>> +{
>> +}
>> +
>> +static inline void arch_haltpoll_disable(unsigned int cpu)
>> +{
>> +}
>> +
>> +static inline bool arch_haltpoll_supported(void)
>> +{
>> +       /*
>> +        * Ensure the event stream is available to provide a terminating
>> +        * condition to the WFE in the poll loop.
>> +        */
>> +       return arch_timer_evtstrm_available();
>
> Note this fails build when CONFIG_HALTPOLL_CPUIDLE=m (module):
>
> ERROR: modpost: "arch_cpu_idle" [drivers/cpuidle/cpuidle-haltpoll.ko]
> undefined!
> ERROR: modpost: "arch_timer_evtstrm_available"
> [drivers/cpuidle/cpuidle-haltpoll.ko] undefined!
> make[2]: *** [scripts/Makefile.modpost:145: Module.symvers] Error 1
> make[1]: *** [/home/ubuntu/linux/Makefile:1886: modpost] Error 2
> make: *** [Makefile:240: __sub-make] Error 2

Thanks for trying it out. Missed that.

> You could add EXPORT_SYMBOL_*()'s on the above helpers or restrict
> HALTPOLL_CPUIDLE module to built-in (remove "tristate" Kconfig).

Yeah AFAICT this is the only cpuidle driver providing the module
option. Unfortunately can't remove the tristate thing. People might
already be using it as a module on x86.

I think the arch_cpu_idle() makes sense to export. For
arch_timer_evtstrm_available(), eventually the arch_haltpoll_*()
in any case need to move out of a header file. I'll just do that
now.

> Otherwise, everything worked for me when built-in (=y) atop 6.10.0
> (4a4be1a). I see similar performance gains in `perf bench` on AWS
> Graviton3 c7g.16xlarge.

Excellent. Thanks for checking.

--
ankur

