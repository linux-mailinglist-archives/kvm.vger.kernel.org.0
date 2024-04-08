Return-Path: <kvm+bounces-13911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ADFCB89CBEA
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 20:46:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 266B51F283D5
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 18:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66FCA1448C4;
	Mon,  8 Apr 2024 18:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QWc18v6e";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Cz6Hhwx6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12585B04F;
	Mon,  8 Apr 2024 18:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712601999; cv=fail; b=tzF2yYtp9wkojPkGDwAys8TGEwP0fpL2Sx32xTWEAM1QKZKGdBOEOeJ/RmvDJuLl/Iutw5cj/XemHNnwg6gRLeEiaEftwykiUmAlrv+gI/tQyhjgX3xB20CqQ+9N3tSAazyNheq9NOIugKJ6lMIeEhadTXAmTl0fVkJZps0xDjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712601999; c=relaxed/simple;
	bh=woS7mS4Z6sH8TH9H+T6Iais/zy3RXQKZdHyJI4mQsp4=;
	h=References:From:To:Cc:Subject:In-reply-to:Message-ID:Date:
	 Content-Type:MIME-Version; b=PnYkEAxk/tjYG115+Jv6EONvOwnQV1EYBwK4EVo3G9SNMKzvg3hIDiz+YrmPoo7qOIjVrUTF4ItOBibST9NJX/t3yMweUWIzXmQs/GHmS97GP3HndN5EDCOZifY0ObV+jBYf5t5dxhnwNxNIHLQH4iuCtlPQe6dPMJsng6V/pWk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QWc18v6e; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Cz6Hhwx6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 438EPXJG019892;
	Mon, 8 Apr 2024 18:45:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=zJEfrYpkoK/2typK+0ksu3aVQHfb/kvolN9hRyrxS54=;
 b=QWc18v6epzKEoHtWTa3MV2LWLl6LrEuk+BSa5kH8jGPp43d90MCrzk8HZ+pmcmpq72gl
 g+Tmj5cnAoxpD0YsB7SgRQG5FN81w087d78KvpwD9j0B9bDhP9iP0ykB0pBJIvK8luDq
 y5cXdbfjc0rTUGqGhjr/efn03Pa3IBfT9w1vMnwIJbVSyDcwLiCfhi1tWnIsSU5Oq/v0
 sy2UBWcs6zDYB9WsWJzQJntKEBfhY9o/bH+XIUihhJ+kBiX0Vt4RwnxOAwBW6IcFlkxk
 cELSY/+1tTnrje4lAXmW1jt2a+n07EMVfaVKVXlzOYbhuXKKuv7dhoNGQvTJx9UPNLcg KQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xaw023fqg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Apr 2024 18:45:30 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 438H2CxT019441;
	Mon, 8 Apr 2024 18:45:28 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xavubvyfx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Apr 2024 18:45:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HWEqv++iiA7WulqQSXhf8IsOEllIAKeAc8q1rvCAhbx5z+d+oyZ3P0GXO+jH95bOfYA6BeFuFFg+FdXrNkZlH+UHhRrPpSBW+C2ec1PC0OCpYydHNsk/+T04Q5VGRXuAZeRzV5VN8hjQj+4uNG61BS6Dd8/ycPaa/f6vdyPzVhn011Wu9o4g+Ryx70bO6bIkQ8u6hCEFpASt6aiNWnG43bmyuCIDdXRG4/+asvtvNzv3ePaaHWkbWcntXOAjC/887RnhJrK7GJN7z/FfenREgxYlhiBDxIsNOX3+GY8F/8oQebTrkOlOaEXb9JROnDOIkLOuXNeFPr0kgKO9yUdS2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zJEfrYpkoK/2typK+0ksu3aVQHfb/kvolN9hRyrxS54=;
 b=ifeXOUa0TYhnVEuw3xj1TqpjO0Xv0XXVQVuiOqPe8kP0OqB7HF2BirP/Mua5Mz45XEj37ZlXjNrfAwVtXBA98Pu7onZgjPyo5Gg80INqSSj3ivwKV/7jc6XT6Zf9RNp2ayUbCnuTm1fW2dWXdNcCDKDtIZlv+c2MkTie2iwP6jU7BCSd7ii/jJRHt9LR8r3saihw4qpNX64EweIPLDshtgau8I22jFvyFOSlRwziK0q53k7x9Dh0iyXLQAK8i0QlfFbqqqhZ3c7vouZmqZwk+gt8akN3AcNb6QrWaljjdnFYLJPBkzT0YC+ZfZFLGMcgxJoIgYRnlHlu8+O6zNJ3Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJEfrYpkoK/2typK+0ksu3aVQHfb/kvolN9hRyrxS54=;
 b=Cz6Hhwx6NQdIPEwNfxE/Z9AxY8vX7+rY27RB524wig9bIDv2BZp3y2O0iE9q5CG/lxoFAak2YYRW6/4DfgMruNBdmDEoKF2aq3tHsWs87lN3NbqS225/oWJVf1iyKrJf9Phxm/QZW+DvXLR4MlFAkAXDDF82U1P8BKLBbo9pcrQ=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SN7PR10MB6956.namprd10.prod.outlook.com (2603:10b6:806:34a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Mon, 8 Apr
 2024 18:45:25 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8%7]) with mapi id 15.20.7409.042; Mon, 8 Apr 2024
 18:45:25 +0000
References: <1707982910-27680-1-git-send-email-mihai.carabas@oracle.com>
 <1707982910-27680-8-git-send-email-mihai.carabas@oracle.com>
 <7f3e540ad30f40ae51f1abda24b1bea2c8b648ea.camel@amazon.com>
 <87r0fjtn9y.fsf@oracle.com>
 <aada0beae0b3479bfa311eea94a3b595bb8e5835.camel@amazon.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "Okanovic, Haris" <harisokn@amazon.com>
Cc: "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dianders@chromium.org"
 <dianders@chromium.org>,
        "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
        "pmladek@suse.com"
 <pmladek@suse.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "mingo@redhat.com"
 <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "daniel.lezcano@linaro.org"
 <daniel.lezcano@linaro.org>,
        "mihai.carabas@oracle.com"
 <mihai.carabas@oracle.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "will@kernel.org" <will@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mic@digikod.net"
 <mic@digikod.net>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "npiggin@gmail.com" <npiggin@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "rafael@kernel.org"
 <rafael@kernel.org>,
        "juerg.haefliger@canonical.com"
 <juerg.haefliger@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "rick.p.edgecombe@intel.com" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v4 7/8] cpuidle/poll_state: replace cpu_relax with
 smp_cond_load_relaxed
In-reply-to: <aada0beae0b3479bfa311eea94a3b595bb8e5835.camel@amazon.com>
Message-ID: <87il0rsnf0.fsf@oracle.com>
Date: Mon, 08 Apr 2024 11:46:11 -0700
Content-Type: text/plain
X-ClientProxiedBy: MN2PR18CA0027.namprd18.prod.outlook.com
 (2603:10b6:208:23c::32) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SN7PR10MB6956:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Ets+L1JkbgmOoyN+T9UpIPzdm1FVTRYn2XVXXJedxRdOaRXXTRnG93S0pzSLETb5zcuu2KE4jDjG1l42P/WLtdQtBKBdOCMY9rJ/SAZ0l/ZH6mKerWI14vTtM2VSEBXvgbSTDzMozc+nA85gV9Uy7pjkALqZMYYdxjyYATolDGtGCl7O+1Y1+ByCAUB6ZO4Anizskqjzd7nOkLOxPuJz2bZXXnwg2F8itCTabYMBxoAmlFHYkh/lJp8SNgmjvYnEKTrP1VrG03mcdt69dPgFPCCcx4ztQH1ZQAgV1jQD2CMQxf4/Q0pqj4Pv+tu53YC4XYBWXwrdOgv5Rfx9SeCsDJpvuV0iVBTWaUgL5kPerotnhRt0kMzssKhMgoEtrhgO1/71iaXygHQcS1SIgQhbCSTZBPP32aMvGiRsNW7vAjSVs+kdJRFrVgNOLweFsgg5D8vljOms1cPfMxCc2R8APma7Gk0ZK4mfiq9g28lW9YhQaDM85SzMj3NZ9T/MyuEZOBmgpcxo3jZsYN9sf3ooRCLJ2RYsftZccbcBy3tHrM+jplnUdq0PxPnPPQNc+MeIGGNGcfY8vt7Qf/0LvwNw0RCUSklLgpcSCUVVUqaMrfo=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?0u4iciE2SefoNyOqRZTjXTvSGRdAr21ZBlHniS1ygZe9CiMpeM68cp0GvsOv?=
 =?us-ascii?Q?3wNTWzTwCxm5ovwwS5ySKmwFfr+3O+7rd67eJk22eOJEuAkOgZrZx1wan5zN?=
 =?us-ascii?Q?lJbmSlGXsy6MD+OIQtKg9jLMF/cDAqewDH9a3PJHe/YT/+wzzFWsndSOO/UT?=
 =?us-ascii?Q?8BZLy6uzTuxNGIMxM506oaljKk+VxSM7qbdJze0i99YxQA8wqzXnyyOhu8yf?=
 =?us-ascii?Q?DxAgRglcY1VX284JeRCL1MVsB/q4Dwaqq0SBucK1/jpTh0dvhAOa1MpOiP3D?=
 =?us-ascii?Q?rn/l7b/gpfqI6vEzza9Ug/rCaei8bTNilk84yhvyqDtHddTTWE0frOciUw7P?=
 =?us-ascii?Q?R64Z1xPVrYe6YkAwOavt7WZcbipgBhTswUg+TvQ48uqky4LDDbvR17QdHWNX?=
 =?us-ascii?Q?sALcPEk5pPWcFITM4ELBrXjOe1mRrIYGzRM6xoPEKUIHT1cs8wafDyYVhb3C?=
 =?us-ascii?Q?RbqV6R5hnI1/A0nWJMkZu1ClQ9MFiFRquXgRopToEdyvBBEgEQxP6vgHrtp0?=
 =?us-ascii?Q?HVoFsSIvW6IDhZxDMzxaoUhuT80/MdYRRDFEpY3+pbRAk+TsyZgIWl/79vP3?=
 =?us-ascii?Q?W0NjCWPsvVpjdZW1ljzMlghtKNvXSediluaGmp8IIF7pk3912gvwFPfWvdAv?=
 =?us-ascii?Q?XgLyCjNUaK2M21Pdj7LNGaZsRszONb3EML2nneG3O5ACiMOFvtItlpMwT0Q+?=
 =?us-ascii?Q?0v71NOTMiFZgbNCpXnivZcAha2gykjJRkxEj545NI/poPSb14y3CTJmEyMib?=
 =?us-ascii?Q?xQhdAVuHBk7v0tyJgMoKBVbkCYcE7L7nndCk/0uqCXqKLuU5r4QTUwKTlWZU?=
 =?us-ascii?Q?BMUdi6xzHuKRlOJ/7SrojEQqZcFWXoyMqPRl6NXoBXR3LLl1QNyvYBN3v5CJ?=
 =?us-ascii?Q?C7WiubSCavwuG+frm0hWzqYqzEIbqfjP8kUWQi23wXykyfhE/zbRGRJkU2dg?=
 =?us-ascii?Q?gqrZgqf+nVZa6ha0MhZUiDmKwTTvbUQHx6atWNY1Ep2tu8It4J5d9dI47KHj?=
 =?us-ascii?Q?gRFcdtgBO06PXRongGLbi2GJWPcxvqD5QKaBxPROwrtszJd6qCZ8DnEam5Ga?=
 =?us-ascii?Q?dRNm3+c0hvb076fRPMCfQGnsiZPDLBeLxHlsN1HLmGpwY1GnDQkEpHhxGmpg?=
 =?us-ascii?Q?3ZGBCVRyB4kbg7jq6biR9RDIwNpkTPgd1cMKjztVTUYfeI+WTSzH6Hidvkc4?=
 =?us-ascii?Q?Y4woUid7f0qn9WY7Y8ncYvLLmcEwuanxV3IRz7px8YODeg/yHxPsiC05HYpi?=
 =?us-ascii?Q?0sy1fXwzQdF3zO2cMWhlfDNa2OHb8KnBQ0QkqjPnrnOLdgKHmnod8V7Qes+U?=
 =?us-ascii?Q?vSg2wsBoOXEaQGmNy2M/iPvbkjI749vxJI6Cy8kDaUO1vWJyabyMHLtWarmX?=
 =?us-ascii?Q?i2MtkqM0DmQF5tG80dCQhr6/JOG6hsuzi043wrdbhPwxq9j0VlmQRuP2jNSz?=
 =?us-ascii?Q?mYOSeBvYU+GvXA2y67EWUdEb6xHwig8/s3obHmHsKYcwQpgUuew98XX6X+Hi?=
 =?us-ascii?Q?gVVAq0rpKpkmAJYG6RINYGqxJGrocwLC/lLcrvtVse/2ul1nKXSMpePmwYly?=
 =?us-ascii?Q?qXJDB5Uu5AMwViHP48TsSHzseqeNDrbBppLwv60Byk8JTQxh39iM7h/YDPNB?=
 =?us-ascii?Q?zQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	IwlKGc/OlXM84MxvQHpVE3Vph2e03ja8kn5iiW8laA2sjFi0i6aZfrFAmx1jrIUGYAT1kbpWyTt26Yrc967PFzUggyKveh9ayNWMF36Guup7FtRaQiC6P54TuR6ylNTJFiRBRv6aI95mt2rjnUHmaviayfy1p0ehnDAVc6JF31exuMKgfGNp+x5XK9vn9CgQcoTC1zIITXD6mYneiKivWLApGRAhPHFjTCxptX5ImabzvafM9OI1w0SV2nrEEKidQMvj/NZ8Y3Az/qNHrHO4Dzh8Jh/VFQV4IZNjewCrtxRdy+eAzS4108Rz7Wzl2pZHB9xodde42ZvCQOWHH7WLjzASTsWEb5HfUIHOfq6/REf9k2kG90rx7UBKb/oofJmlm9/K/a67BaK2hx7jbKBKwx50hfUCS1ZrYIz/XEEBN3X3Hgfx3jzlQtJA9LdODBIvZXsqON9j7mZybrJbuIsGHbWybentXdadZGcvM69DqE40bc123tLHLrPB054swdQ4yO1F0Djie3GjJ9fpkCsEEG5Ui9YEgVCnJWfrIG2wWrqSSt8wTu4MwhU4u1KC0Hm/KFdv7k3NrmILKlXTFc40CiQwZF5i7BnDfcXledw8t+Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 103a2451-e88a-44fc-9977-08dc57fc0dc8
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2024 18:45:25.6321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QysN8SZyHZIdq/Gf4CC4dy04lHM6maj6nlPhLCiBbNeRiTCw3lJbAH/RbKJy5+NWWeUnPuBI2PIsGwGxAqgaNRS0cFGFeJCYqYCV73VqcSk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6956
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-08_16,2024-04-05_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404080145
X-Proofpoint-ORIG-GUID: MYUG7cWhQDLCKiu8q4fWQHW7l0x180Fr
X-Proofpoint-GUID: MYUG7cWhQDLCKiu8q4fWQHW7l0x180Fr


Okanovic, Haris <harisokn@amazon.com> writes:

> On Fri, 2024-04-05 at 16:14 -0700, Ankur Arora wrote:
>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>>
>>
>>
>> Okanovic, Haris <harisokn@amazon.com> writes:
>>
>> > On Thu, 2024-02-15 at 09:41 +0200, Mihai Carabas wrote:
>> > > cpu_relax on ARM64 does a simple "yield". Thus we replace it with
>> > > smp_cond_load_relaxed which basically does a "wfe".
>> > >
>> > > Suggested-by: Peter Zijlstra <peterz@infradead.org>
>> > > Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
>> > > ---
>> > >  drivers/cpuidle/poll_state.c | 15 ++++++++++-----
>> > >  1 file changed, 10 insertions(+), 5 deletions(-)
>> > >
>> > > diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
>> > > index 9b6d90a72601..1e45be906e72 100644
>> > > --- a/drivers/cpuidle/poll_state.c
>> > > +++ b/drivers/cpuidle/poll_state.c
>> > > @@ -13,6 +13,7 @@
>> > >  static int __cpuidle poll_idle(struct cpuidle_device *dev,
>> > >                             struct cpuidle_driver *drv, int index)
>> > >  {
>> > > +    unsigned long ret;
>> > >      u64 time_start;
>> > >
>> > >      time_start = local_clock_noinstr();
>> > > @@ -26,12 +27,16 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
>> > >
>> > >              limit = cpuidle_poll_time(drv, dev);
>> > >
>> > > -            while (!need_resched()) {
>> > > -                    cpu_relax();
>> > > -                    if (loop_count++ < POLL_IDLE_RELAX_COUNT)
>> > > -                            continue;
>> > > -
>> > > +            for (;;) {
>> > >                      loop_count = 0;
>> > > +
>> > > +                    ret = smp_cond_load_relaxed(&current_thread_info()->flags,
>> > > +                                                VAL & _TIF_NEED_RESCHED ||
>> > > +                                                loop_count++ >= POLL_IDLE_RELAX_COUNT);
>> >
>> > Is it necessary to repeat this 200 times with a wfe poll?
>>
>> The POLL_IDLE_RELAX_COUNT is there because on x86 each cpu_relax()
>> iteration is much shorter.
>>
>> With WFE, it makes less sense.
>>
>> > Does kvm not implement a timeout period?
>>
>> Not yet, but it does become more useful after a WFE haltpoll is
>> available on ARM64.
>
> Note that kvm conditionally traps WFE and WFI based on number of host
> CPU tasks. VMs will sometimes see hardware behavior - potentially
> polling for a long time before entering WFI.
>
> https://elixir.bootlin.com/linux/latest/source/arch/arm64/kvm/arm.c#L459

Yeah. There was a discussion on this
https://lore.kernel.org/lkml/871qc6qufy.fsf@oracle.com/.

>> Haltpoll does have a timeout, which you should be able to tune via
>> /sys/module/haltpoll/parameters/ but that, of course, won't help here.
>>
>> > Could you make it configurable? This patch improves certain workloads
>> > on AWS Graviton instances as well, but blocks up to 6ms in 200 * 30us
>> > increments before going to wfi, which is a bit excessive.
>>
>> Yeah, this looks like a problem. We could solve it by making it an
>> architectural parameter. Though I worry about ARM platforms with
>> much smaller default timeouts.
>> The other possibility is using WFET in the primitive, but then we
>> have that dependency and that's a bigger change.
>
> See arm64's delay() for inspiration:
>
> https://elixir.bootlin.com/linux/v6.9-rc2/source/arch/arm64/lib/delay.c#L26

Sure, that part is straight-forward enough. However, this will need a fallback
the case when WFET is not available. And, because this path is used on x86,
so we need a cross platform smp_cond*timeout(). Though given that the x86
version is based on cpu_relax() then that could just fold the sched_clock()
check in.

Maybe another place to do this would be by KVM forcing a WFE timeout. Arguably
that is needed regardless of whether we use a smp_cond*timeout() or not.

--
ankur

